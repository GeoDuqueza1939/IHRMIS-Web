#!/usr/bin/env node
// tools/mwb-ddl.mjs — render MySQL DDL (+ model seed INSERTs) from a .mwb file.
//
// The model (.docsanddesign/DB-ERD.mwb) is the source of truth. This tool
// composes two readers — `mwb-edit.mjs digest --json` (schema) and
// `mwb-inserts.py` (Inserts-tab seed rows from @db/data.db) — and emits a
// self-contained, re-runnable SQL script. It never touches the model.
//
// Usage:
//   node tools/mwb-ddl.mjs --mwb <model.mwb> --out <schema.sql>
//
// Rendering rules (verified against the model + MariaDB/MySQL):
//   - types verbatim, except ENUM((..)) -> ENUM(..) (digest double parens),
//     DATETIME_F -> DATETIME (fractional precision not tracked by the model),
//     BOOLEAN kept (server maps to TINYINT(1)).
//   - DEFAULT: bare numerics + CURRENT_TIMESTAMP[ ON UPDATE ..] stay bare,
//     everything else single-quoted; absent default -> no clause.
//   - tables in FK-topological order + FOREIGN_KEY_CHECKS=0 wrapper, so the
//     script loads cleanly in one pass. INSERTs follow in the same order.
//   - identifiers backticked; comments escaped (backslash, quote; newlines kept).

import { readFileSync, writeFileSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { spawnSync } from 'child_process';

const TOOL_DIR = dirname(fileURLToPath(import.meta.url));

function fail(msg) {
    process.stderr.write(`mwb-ddl: error: ${msg}\n`);
    process.exit(1);
}

function run(cmd, args) {
    const r = spawnSync(cmd, args, { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
    if (r.status !== 0) fail(`${cmd} failed: ${(r.stderr || '').slice(0, 500)}`);
    return r.stdout;
}

function qid(s) {
    return `\`${String(s).replace(/`/g, '``')}\``;
}

function qstr(s) {
    return `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`;
}

function sqlType(t) {
    if (t === 'DATETIME_F') return 'DATETIME'; // precision not tracked; flagged in db/README
    let m = /^ENUM\(\((.*)\)\)$/s.exec(t);
    if (m) return `ENUM(${m[1]})`;
    m = /^SET\(\((.*)\)\)$/s.exec(t);
    if (m) return `SET(${m[1]})`;
    return t;
}

const NUMERIC = new Set(['BIGINT', 'INT', 'INTEGER', 'SMALLINT', 'MEDIUMINT',
    'TINYINT', 'FLOAT', 'DOUBLE', 'REAL', 'DECIMAL', 'NUMERIC', 'BIT', 'YEAR']);

function baseOf(t) {
    return sqlType(t).split('(')[0].trim().split(/\s+/)[0].toUpperCase();
}

function sqlDefault(col) {
    const dv = col.default;
    if (dv === null || dv === undefined || dv === '') return '';
    if (/^(CURRENT_TIMESTAMP|TRUE|FALSE)/i.test(dv)) return `DEFAULT ${dv}`;
    if (/^-?\d+(\.\d+)?$/.test(dv)) return `DEFAULT ${dv}`;
    if (/^NULL$/i.test(dv)) return 'DEFAULT NULL';
    return `DEFAULT ${qstr(dv)}`;
}

function sqlLiteral(colType, v) {
    if (v === null || v === undefined) return 'NULL';
    const s = String(v);
    const b = baseOf(colType);
    if (NUMERIC.has(b) || b === 'BOOLEAN') {
        if (/^-?\d+(\.\d+)?$/.test(s)) return s;
        if (/^(TRUE|FALSE)$/i.test(s)) return s.toUpperCase();
        return qstr(s); // defensive: non-numeric stored in numeric column
    }
    if (/^CURRENT_TIMESTAMP/i.test(s)) return s;
    return qstr(s);
}

function topoOrder(tables) {
    const byName = new Map(tables.map((t) => [t.name, t]));
    const deps = new Map(tables.map((t) => [t.name,
        new Set((t.foreignKeys || []).map((f) => f.refTable).filter((r) => byName.has(r) && r !== t.name))]));
    const out = [];
    const done = new Set();
    let rest = tables.map((t) => t.name).sort();
    while (rest.length) {
        const ready = rest.filter((n) => [...deps.get(n)].every((d) => done.has(d)));
        const pick = ready.length ? ready : [rest[0]]; // cycle: break alphabetically
        for (const n of pick) {
            out.push(byName.get(n));
            done.add(n);
        }
        rest = rest.filter((n) => !done.has(n));
    }
    return out;
}

function createTable(t) {
    const lines = [];
    for (const c of t.columns) {
        let line = `  ${qid(c.name)} ${sqlType(c.type)}`;
        line += c.notNull ? ' NOT NULL' : ' NULL';
        if (c.autoIncrement) line += ' AUTO_INCREMENT';
        const d = sqlDefault(c);
        if (d) line += ` ${d}`;
        if (c.comment) line += ` COMMENT ${qstr(c.comment)}`;
        lines.push(line);
    }
    if (t.primaryKey && t.primaryKey.length) {
        lines.push(`  PRIMARY KEY (${t.primaryKey.map(qid).join(', ')})`);
    }
    for (const ix of t.indexes || []) {
        if (ix.type === 'PRIMARY') continue;
        const kind = ix.unique ? 'UNIQUE KEY' : 'KEY';
        lines.push(`  ${kind} ${qid(ix.name)} (${ix.columns.map(qid).join(', ')})`);
    }
    for (const fk of t.foreignKeys || []) {
        lines.push(`  CONSTRAINT ${qid(fk.name)} FOREIGN KEY (${fk.columns.map(qid).join(', ')}) ` +
            `REFERENCES ${qid(fk.refTable)} (${fk.refColumns.map(qid).join(', ')}) ` +
            `ON DELETE ${fk.onDelete} ON UPDATE ${fk.onUpdate}`);
    }
    let sql = `CREATE TABLE ${qid(t.name)} (\n${lines.join(',\n')}\n) ENGINE=${t.engine || 'InnoDB'} DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci`;
    if (t.comment) sql += ` COMMENT=${qstr(t.comment)}`;
    return sql + ';';
}

function main() {
    const args = Object.fromEntries(process.argv.slice(2).flatMap((a, i, arr) =>
        a.startsWith('--') ? [[a.slice(2), arr[i + 1] && !arr[i + 1].startsWith('--') ? arr[i + 1] : true]] : []));
    if (!args.mwb || !args.out) fail('usage: mwb-ddl.mjs --mwb <model.mwb> --out <schema.sql>');
    const digest = JSON.parse(run('node', [join(TOOL_DIR, 'mwb-edit.mjs'), 'digest', '--mwb', args.mwb, '--json']));
    let inserts = {};
    try {
        inserts = JSON.parse(run('python3', [join(TOOL_DIR, 'mwb-inserts.py'), args.mwb]));
    } catch (e) {
        process.stderr.write(`mwb-ddl: warning: no seed rows (${e.message || e})\n`);
    }
    const colTypes = new Map();
    for (const t of digest.tables) {
        colTypes.set(t.name, new Map(t.columns.map((c) => [c.name, c.type])));
    }
    const ordered = topoOrder(digest.tables);
    const L = [];
    L.push(`-- Schema generated from ${args.mwb}`);
    L.push(`-- by tools/mwb-ddl.mjs on ${new Date().toISOString()}`);
    L.push('-- DO NOT hand-edit: the .mwb model is the source of truth; regenerate.');
    L.push('');
    L.push('CREATE DATABASE IF NOT EXISTS `ihrmis` CHARACTER SET utf8 COLLATE utf8_general_ci;');
    L.push('USE `ihrmis`;');
    L.push('SET FOREIGN_KEY_CHECKS=0;');
    L.push('');
    for (const t of ordered) {
        L.push(createTable(t));
        L.push('');
    }
    const withRows = ordered.filter((t) => inserts[t.name] && inserts[t.name].rows.length);
    if (withRows.length) {
        L.push('-- ---- seed rows (Workbench Inserts tab; model-canonical) ----');
        L.push('-- Idempotent (ON DUPLICATE KEY UPDATE) so schema.sql and the');
        L.push('-- deploy seeder converge regardless of run order. Role_Right');
        L.push('-- grants are intentionally NOT here: their ids only exist at');
        L.push('-- deploy time and are resolved by the seeder.');
        for (const t of withRows) {
            const cols = inserts[t.name].columns;
            const tm = colTypes.get(t.name);
            const pkSet = new Set(t.primaryKey || []);
            const autoSet = new Set(t.columns.filter((c) => c.autoIncrement).map((c) => c.name));
            for (const row of inserts[t.name].rows) {
                // omit null/empty AI-PK cells (GUI leaves them blank -> auto-assign)
                const keep = cols.filter((cn, i) =>
                    !(autoSet.has(cn) && (row[i] === null || row[i] === undefined || row[i] === '')));
                const vals = keep.map((cn) => sqlLiteral(tm.get(cn) || 'TEXT',
                    row[cols.indexOf(cn)]));
                const upd = keep.filter((cn) => !pkSet.has(cn))
                    .map((cn) => `${qid(cn)}=VALUES(${qid(cn)})`).join(', ');
                L.push(`INSERT INTO ${qid(t.name)} (${keep.map(qid).join(', ')}) VALUES (${vals.join(', ')})` +
                    (upd ? ` ON DUPLICATE KEY UPDATE ${upd};` : ';'));
            }
        }
        L.push('');
    }
    L.push('SET FOREIGN_KEY_CHECKS=1;');
    mkdirSync(dirname(args.out), { recursive: true });
    writeFileSync(args.out, L.join('\n') + '\n');
    const nFk = digest.tables.reduce((a, t) => a + (t.foreignKeys || []).length, 0);
    const nRows = withRows.reduce((a, t) => a + inserts[t.name].rows.length, 0);
    process.stderr.write(`mwb-ddl: wrote ${args.out} (${ordered.length} tables, ${nFk} FKs, ${nRows} seed rows)\n`);
}

main();

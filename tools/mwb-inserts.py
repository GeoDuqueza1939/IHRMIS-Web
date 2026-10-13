#!/usr/bin/env python3
"""mwb-inserts.py — dump Workbench Inserts-tab rows from a .mwb file.

The Table Editor's Inserts tab stores rows in `@db/data.db` (SQLite),
keyed by GRT object id — NOT in document.mwb.xml (db.mysql.Table has no
row-data member; verified against structs.db.mysql.xml). This helper
resolves ids to table/column names via document.mwb.xml and prints JSON:

  {"TABLE": {"columns": [...], "rows": [[...], ...]}, ...}

Only tables with >= 1 row are listed. Usage:
  python3 tools/mwb-inserts.py model.mwb [--summary]
With --summary, prints {"tables": n, "rows": m, "perTable": {T: n}} instead.
Exit non-zero when @db/data.db is absent (caller decides severity).

Set-rows mode (writes Inserts-tab rows into the model):
  python3 tools/mwb-inserts.py model.mwb --set-rows rows.json [--in-place]
rows.json maps table names to lists of {column: value} dicts
(values become TEXT, null stays NULL). Each listed table is REPLACED
wholesale (DELETE + INSERT), so re-running converges; all other sqlite
tables (e.g. XP_PROC) and all other zip entries are preserved byte-wise.
Without --in-place, writes model.out.mwb next to the input (safe default).
Column order follows the model; ids are used verbatim as they appear in
the XML (braced and bare UUIDs both occur); unknown table/column names
are hard errors.
"""
import json
import re
import sqlite3
import sys
import tempfile
import zipfile
import xml.etree.ElementTree as ET

SQLITE_RE = re.compile(r'^\{?[0-9A-Fa-f-]{36}\}?$')
NS = 'http://www.lysator.liu.se/~alla/dia/'


def norm(uid):
    return uid.strip('{}').upper()


def id_name_map(xml_text):
    """Map GRT object id -> its OWN key='name' child (tables AND columns).

    NOTE: document.mwb.xml uses bare <value> tags (no dia: namespace,
    unlike .dia files). Matching is case-insensitive on the id.
    """
    root = ET.fromstring(xml_text)
    out = {}
    for v in root.iter('value'):
        uid = (v.get('id') or '')
        if not SQLITE_RE.match(uid):
            continue
        for c in v:
            if c.tag == 'value' and c.get('key') == 'name':
                out[norm(uid)] = (c.text or '').strip()
                break
    return out


def model_tables(xml_text):
    """table name -> {'id': raw id, 'columns': [(raw col id, name)]}.

    Raw ids are kept verbatim (braced AND bare UUIDs both occur in the
    wild); sqlite table/column names must match them exactly.
    """
    root = ET.fromstring(xml_text)
    out = {}
    for v in root.iter('value'):
        if v.get('struct-name') != 'db.mysql.Table' or not v.get('id'):
            continue
        tname = None
        cols = []
        for c in v:
            if c.tag != 'value':
                continue
            if c.get('key') == 'name':
                tname = (c.text or '').strip()
            if c.get('key') == 'columns':
                for col in c:
                    cid = col.get('id') or ''
                    if not SQLITE_RE.match(cid):
                        continue
                    cname = None
                    for k in col:
                        if k.tag == 'value' and k.get('key') == 'name':
                            cname = (k.text or '').strip()
                            break
                    cols.append((cid, cname))
        if tname:
            out[tname] = {'id': v.get('id'), 'columns': cols}
    return out


def cmd_set_rows(mwb_path, rows_path, in_place):
    import os
    with open(rows_path, encoding='utf-8') as f:
        wanted = json.load(f)
    with zipfile.ZipFile(mwb_path) as z:
        infos = z.infolist()
        try:
            raw = z.read('@db/data.db')
            have_db = True
        except KeyError:
            raw, have_db = None, False
        xml_text = z.read('document.mwb.xml').decode('utf-8')
        comment = z.comment
    tables = model_tables(xml_text)
    for t in wanted:
        if t not in tables:
            print(f'mwb-inserts: set-rows: unknown table {t!r}', file=sys.stderr)
            return 2
        known = {cname for _, cname in tables[t]['columns']}
        for row in wanted[t]:
            for c in row:
                if c not in known:
                    print(f'mwb-inserts: set-rows: {t}: unknown column {c!r}',
                          file=sys.stderr)
                    return 2
    with tempfile.NamedTemporaryFile(suffix='.db', delete=False) as tmp:
        tmpname = tmp.name
        if have_db:
            tmp.write(raw)
            tmp.flush()
        con = sqlite3.connect(tmpname)
        for t, rows in wanted.items():
            tid = tables[t]['id']
            con.execute(f'DROP TABLE IF EXISTS "{tid}"')
            coldefs = ', '.join(['"_" varchar'] +
                                [f'"{cid}" varchar' for cid, _ in tables[t]['columns']])
            con.execute(f'CREATE TABLE "{tid}" ({coldefs})')
            byname = {cname: cid for cid, cname in tables[t]['columns']}
            order = [cname for _, cname in tables[t]['columns']]
            for row in rows:
                vals = [None if row.get(c) is None else str(row.get(c))
                        for c in order]
                con.execute(
                    f'INSERT INTO "{tid}" VALUES ({",".join("?" * (len(order) + 1))})',
                    [None] + vals)
        con.commit()
        con.close()
        with open(tmpname, 'rb') as f:
            new_db = f.read()
        os.unlink(tmpname)
    out_path = mwb_path if in_place else (
        mwb_path[:-4] + '.out.mwb' if mwb_path.endswith('.mwb')
        else mwb_path + '.out.mwb')
    zin = zipfile.ZipFile(mwb_path)
    zout = zipfile.ZipFile(out_path, 'w')
    try:
        doc_dt = None
        for info in infos:
            if info.filename == '@db/data.db':
                continue
            if info.filename == 'document.mwb.xml':
                doc_dt = info.date_time
            zout.writestr(info, zin.read(info.filename))
        # match surrounding entries: deflate like document.mwb.xml
        db_info = zipfile.ZipInfo('@db/data.db')
        db_info.date_time = doc_dt or db_info.date_time
        db_info.compress_type = zipfile.ZIP_DEFLATED
        zout.writestr(db_info, new_db)
        zout.comment = comment
    finally:
        zin.close()
        zout.close()
    total = sum(len(v) for v in wanted.values())
    print(f'mwb-inserts: set {total} row(s) in {len(wanted)} table(s) -> {out_path}',
          file=sys.stderr)
    return 0


def main():
    if len(sys.argv) < 2:
        print('usage: mwb-inserts.py <model.mwb> [--summary | --set-rows rows.json [--in-place]]',
              file=sys.stderr)
        return 2
    if '--set-rows' in sys.argv:
        i = sys.argv.index('--set-rows')
        if i + 1 >= len(sys.argv):
            print('mwb-inserts: --set-rows needs a rows.json path', file=sys.stderr)
            return 2
        return cmd_set_rows(sys.argv[1], sys.argv[i + 1],
                            '--in-place' in sys.argv)
    summary = '--summary' in sys.argv[1:]
    with zipfile.ZipFile(sys.argv[1]) as z:
        try:
            raw = z.read('@db/data.db')
        except KeyError:
            print('mwb-inserts: @db/data.db absent', file=sys.stderr)
            return 1
        try:
            xml_text = z.read('document.mwb.xml').decode('utf-8')
        except KeyError:
            print('mwb-inserts: document.mwb.xml absent', file=sys.stderr)
            return 1
    with tempfile.NamedTemporaryFile(suffix='.db') as tmp:
        tmp.write(raw)
        tmp.flush()
        con = sqlite3.connect(tmp.name)
        tables = [r[0] for r in con.execute(
            "SELECT name FROM sqlite_master WHERE type='table'")]
        names = id_name_map(xml_text)
        result = {}
        for t in tables:
            if t == 'XP_PROC':
                continue
            cols = [r[1] for r in con.execute(f'PRAGMA table_info("{t}")')]
            rows = con.execute(f'SELECT * FROM "{t}"').fetchall()
            if not rows:
                continue
            col_names = [names.get(norm(c), None)
                         if SQLITE_RE.match(c) and c != '_' else None
                         for c in cols]
            # '_' is a row-marker column; drop it and its values
            keep = [i for i, c in enumerate(cols) if c != '_']
            result[names.get(norm(t), t)] = {
                'columns': [col_names[i] or cols[i] for i in keep],
                'rows': [[r[i] for i in keep] for r in rows],
            }
        con.close()
    if summary:
        print(json.dumps({
            'tables': len(result),
            'rows': sum(len(v['rows']) for v in result.values()),
            'perTable': {k: len(v['rows']) for k, v in result.items()},
        }, indent=1))
    else:
        print(json.dumps(result, indent=1))
    return 0


if __name__ == '__main__':
    sys.exit(main())

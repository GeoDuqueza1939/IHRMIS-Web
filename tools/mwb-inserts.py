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


def main():
    if len(sys.argv) < 2:
        print('usage: mwb-inserts.py <model.mwb> [--summary]', file=sys.stderr)
        return 2
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

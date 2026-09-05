#!/usr/bin/env python3
"""Any SOE .tab datatable (header row, type row, data rows) to JSON rows.

Usage: tab_to_json.py --tab <file.tab> [--tab ...] --out <json> [--only <regex on a row's first column>]

Output: {"tables": [{"table": path, "header": [...], "types": [...], "rows": [{col: value}]}], "notes"}. Empty cells are
dropped from each row dict so the JSON stays readable. The SOE data never leaves the machine.
"""
import argparse, json, re, sys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--tab', action='append', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--only', default=None)
    a = ap.parse_args()
    only = re.compile(a.only) if a.only else None
    tables = []
    for t in a.tab:
        lines = open(t, encoding='utf-8', errors='replace').read().split('\n')
        hdr = lines[0].split('\t')
        types = lines[1].split('\t') if len(lines) > 1 else []
        rows = []
        for l in lines[2:]:
            if not l.strip():
                continue
            c = l.split('\t')
            if only and not only.search(c[0]):
                continue
            rows.append({hdr[i]: c[i] for i in range(min(len(hdr), len(c))) if c[i] != ''})
        tables.append({'table': t, 'header': hdr, 'types': types, 'rows': rows})
        print(t, 'rows', len(rows), 'cols', len(hdr), file=sys.stderr)
    json.dump({'tables': tables, 'notes': f'tab_to_json.py {a.tab}'}, open(a.out, 'w', encoding='utf-8'), indent=1)


if __name__ == '__main__':
    main()

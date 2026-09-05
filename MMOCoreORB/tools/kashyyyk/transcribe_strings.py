#!/usr/bin/env python3
"""Filter the shipped string dump for the stf files an arc uses.

Usage: transcribe_strings.py --tsv <_STF_EN_ALL.tsv> --prefix <string/en/... prefix> [--prefix ...] --out <json>

Streams the tab-separated dump (file, tre, key, text) and keeps every row whose file column starts with one of the prefixes.
Output: {"strings": [{line, file, key, text}], "notes"}. The dump itself never leaves the machine.
"""
import argparse, json, sys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--tsv', required=True)
    ap.add_argument('--prefix', action='append', required=True)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    rows = []
    with open(a.tsv, encoding='utf-8', errors='replace') as f:
        for i, l in enumerate(f, start=1):
            c = l.rstrip('\n').split('\t')
            if len(c) < 3:
                continue
            if any(c[0].startswith(p) for p in a.prefix):
                rows.append({'line': i, 'file': c[0], 'key': c[2], 'text': c[3] if len(c) > 3 else ''})
    json.dump({'strings': rows, 'notes': f'transcribe_strings.py prefixes {a.prefix}'}, open(a.out, 'w', encoding='utf-8'), indent=1)
    print('strings', len(rows), file=sys.stderr)


if __name__ == '__main__':
    main()

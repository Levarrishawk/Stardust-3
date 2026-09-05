#!/usr/bin/env python3
"""Kashyyyk lairs: spawnLimit = SOE's largest intSpawnCount for the lair's type table.

The first spawn rounds set spawnLimit to the sum of the type table's fltSize values. fltSize is a WEIGHT (how often a row
is picked), not a count, so tables with many rows produced lairs of 20-76 creatures where SOE's spawners place 1-8. This
tool reads the transcribed spawner JSONs (area and patrol spawners), takes the largest intSpawnCount per type, and rewrites
each lair's spawnLimit and its header line.

Usage: set_lair_limits.py --scripts <bin/scripts> --json <spawner json> [--json ...] [--patrols <patrols.json>]
"""
import argparse, json, os, re, sys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--scripts', required=True)
    ap.add_argument('--json', action='append', default=[])
    ap.add_argument('--patrols', default=None)
    a = ap.parse_args()
    counts = {}
    for p in a.json:
        j = json.load(open(p, encoding='utf-8-sig'))
        for s in j['spawners']:
            g = 'kashyyyk_' + s['strSpawns'].split('/')[-1]
            counts[g] = max(counts.get(g, 0), int(s.get('count', 1)))
    if a.patrols:
        j = json.load(open(a.patrols, encoding='utf-8'))
        for z in j['zones'].values():
            for s in z['spawners']:
                g = 'kashyyyk_' + s['strSpawns'].split('/')[-1]
                counts[g] = max(counts.get(g, 0), int(s.get('count', 1)))
    lair_dir = os.path.join(a.scripts, 'mobile', 'lair', 'creature_dynamic')
    changed = skipped = 0
    for f in sorted(os.listdir(lair_dir)):
        if not f.startswith('kashyyyk_'):
            continue
        name = f[:-4]
        if name not in counts:
            print('no spawner count for', name, '- left as is', file=sys.stderr)
            skipped += 1
            continue
        path = os.path.join(lair_dir, f)
        b = open(path, 'rb').read()
        s = b.decode('utf-8')
        new_limit = max(1, counts[name])
        s2 = re.sub(r'spawnLimit = \d+', f'spawnLimit = {new_limit}', s, count=1)
        s2 = re.sub(r'-- spawnLimit = sum of fltSize[^\r\n]*',
                    "-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).",
                    s2, count=1)
        if s2 != s:
            open(path, 'wb').write(s2.encode('utf-8'))
            changed += 1
    print('lairs changed', changed, 'skipped', skipped, file=sys.stderr)


if __name__ == '__main__':
    main()

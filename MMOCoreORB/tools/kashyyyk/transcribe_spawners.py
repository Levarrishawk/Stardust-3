#!/usr/bin/env python3
"""Transcribe SOE buildout spawner rows for one Kashyyyk zone into the JSON shape the spawn rounds consume.

Usage: transcribe_spawners.py --dsrc <datatables root> --zone <zone dir> --tab <file.tab> [--tab ...]
                              --dx <float> --dz <float> --out <json>

Reads each buildout tab (13- or 11-column; the 11-column form drops objid/container), keeps every row whose template is under
object/tangible/ground_spawning/ or object/tangible/spawning/, parses the objvars (name|type|value triples), applies the
zone offset (world = buildout + (dx, dz)), and resolves each strSpawns type table under spawning/ground_spawning/types/.
Output keys: zone, types, spawners, quest_npcs, unresolved, notes. The SOE data never leaves the machine; only this tool
and the Lua built from its output are committed.
"""
import argparse, json, os, sys


def objvars(s):
    d = {}
    parts = s.split('|')
    i = 0
    while i + 2 < len(parts):
        if parts[i] == '$':
            break
        d[parts[i]] = parts[i + 2]
        i += 3
    return d


def read_type(dsrc, name):
    for cand in (os.path.join(dsrc, 'spawning', 'ground_spawning', 'types', name + '.tab'),
                 os.path.join(dsrc, 'spawning', 'ground_spawning', 'types', 'kashyyyk', os.path.basename(name) + '.tab')):
        if os.path.exists(cand):
            lines = open(cand, encoding='utf-8', errors='replace').read().split('\n')
            rows = []
            for l in lines[2:]:
                c = l.split('\t')
                if len(c) >= 1 and c[0].strip():
                    size = c[1].strip() if len(c) > 1 and c[1].strip() else '1'
                    try:
                        size = int(float(size))
                    except ValueError:
                        size = 1
                    rows.append({'template': c[0].strip(), 'size': size})
            return {'table': cand, 'name': name, 'rows': rows}
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--dsrc', required=True)
    ap.add_argument('--zone', required=True)
    ap.add_argument('--tab', action='append', required=True)
    ap.add_argument('--dx', type=float, required=True)
    ap.add_argument('--dz', type=float, required=True)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    spawners, quest_npcs, types, unresolved = [], [], {}, []
    for tab in a.tab:
        path = os.path.join(a.dsrc, 'buildout', a.zone, tab)
        lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
        hdr = lines[0].split('\t')
        ci = {n: i for i, n in enumerate(hdr)}
        stem = tab[:-4]
        for row, line in enumerate(lines[2:], start=3):
            c = line.split('\t')
            if len(c) < len(hdr):
                continue
            tpl = c[ci['server_template_crc']]
            if not (tpl.startswith('object/tangible/ground_spawning/') or tpl.startswith('object/tangible/spawning/')):
                continue
            px, py, pz = float(c[ci['px']]), float(c[ci['py']]), float(c[ci['pz']])
            ov = objvars(c[ci['objvars']])
            base = {'tab': stem, 'buildout_row': row, 'object_template': tpl, 'px': px, 'py': py, 'pz': pz,
                    'wx': round(px + a.dx, 2), 'wz': round(pz + a.dz, 2)}
            if tpl.endswith('area_spawner.iff') or tpl.endswith('patrol_spawner.iff'):
                st = ov.get('strSpawns', '')
                base.update({'strSpawns': st, 'minTime': float(ov.get('fltMinSpawnTime', 0)), 'maxTime': float(ov.get('fltMaxSpawnTime', 0)),
                             'radius': float(ov.get('fltRadius', 0)), 'count': int(ov.get('intSpawnCount', 1))})
                spawners.append(base)
                if st and st not in types:
                    t = read_type(a.dsrc, st)
                    if t is None:
                        unresolved.append(st)
                    else:
                        types[st] = t
            else:
                base.update({'qw': float(c[ci['qw']]), 'qx': float(c[ci['qx']]), 'qy': float(c[ci['qy']]), 'qz': float(c[ci['qz']]),
                             'scripts': c[ci['scripts']], 'objvars': ov})
                quest_npcs.append(base)
    out = {'zone': a.zone, 'types': list(types.values()), 'spawners': spawners, 'quest_npcs': quest_npcs,
           'unresolved': sorted(set(unresolved)),
           'notes': f'transcribe_spawners.py: world = buildout + ({a.dx}, {a.dz}); tabs {a.tab}'}
    json.dump(out, open(a.out, 'w', encoding='utf-8'), indent=1)
    print('spawners', len(spawners), 'types', len(types), 'quest_npcs', len(quest_npcs), 'unresolved', sorted(set(unresolved)), file=sys.stderr)


if __name__ == '__main__':
    main()

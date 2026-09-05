#!/usr/bin/env python3
"""Transcribe a set of ground quests into the JSON shape the quest rounds consume.

Usage: transcribe_quests.py --shared <sys.shared datatables root> --tre <tre file> [--tre ...] --pattern <regex on the
       quest name, e.g. '^ep3_hunt_'> --out <json> [--tre-reader <path to tre_read.py>]

For every questlist/quest/<name>.tab whose name matches the pattern: the questlist row (header + values). For every
matching quest/<name>.qst inside the given TREs (first TRE that carries it wins): the .qst is an IFF whose payload is XML
text; the XML is parsed into the task list (type, id, name and every <data name=... value=...> child, in order).
Output keys: quests (list of {name, questlist: {col: value}}), qst (list of {name, tre, tasks: [{type, id, name, data}]}),
missing_qst (list), notes. The SOE data never leaves the machine; only this tool and the Lua built from its output are
committed.
"""
import argparse, json, os, re, subprocess, sys, tempfile
import xml.etree.ElementTree as ET


def read_tab(path):
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    hdr = lines[0].split('\t')
    rows = []
    for l in lines[2:]:
        if not l.strip():
            continue
        c = l.split('\t')
        rows.append({hdr[i]: (c[i] if i < len(c) else '') for i in range(len(hdr))})
    return hdr, rows


def qst_xml(path):
    b = open(path, 'rb').read()
    i = b.find(b'<?xml')
    if i < 0:
        i = b.find(b'<quest')
    if i < 0:
        return None
    j = b.rfind(b'</quest>')
    return b[i:j + len(b'</quest>')].decode('utf-8', errors='replace') if j > 0 else b[i:].decode('utf-8', errors='replace')


def parse_tasks(xml):
    root = ET.fromstring(xml)
    out = []

    def walk(el, depth):
        for t in el.findall('task'):
            d = {c.get('name'): c.get('value') for c in t.findall('data')}
            out.append({'type': t.get('type'), 'id': t.get('id'), 'name': t.get('name'), 'depth': depth, 'data': d})
            walk(t, depth + 1)
    tasks = root.find('tasks')
    walk(tasks if tasks is not None else root, 0)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--shared', required=True)
    ap.add_argument('--tre', action='append', default=[])
    ap.add_argument('--pattern', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--tre-reader', required=True, help='path to a local tre_read.py; the TRE archives never enter the repo')
    a = ap.parse_args()
    pat = re.compile(a.pattern)
    qdir = os.path.join(a.shared, 'datatables', 'questlist', 'quest')
    names = sorted(f[:-4] for f in os.listdir(qdir) if f.endswith('.tab') and pat.search(f[:-4]))
    quests = []
    tdir = os.path.join(a.shared, 'datatables', 'questtask', 'quest')
    for n in names:
        hdr, rows = read_tab(os.path.join(qdir, n + '.tab'))
        entry = {'name': n, 'questlist': rows[0] if rows else {}}
        tpath = os.path.join(tdir, n + '.tab')  # the leaked server-side task table, when the client ships no .qst
        if os.path.exists(tpath):
            thdr, trows = read_tab(tpath)
            entry['questtask'] = [{k: v for k, v in r.items() if v != ''} for r in trows]
        quests.append(entry)
    tmp = tempfile.mkdtemp(prefix='qst_')
    qst, found = [], set()
    for tre in a.tre:
        rx = '^quest/(' + '|'.join(re.escape(n) for n in names if n not in found) + r')\.qst$'
        if not [n for n in names if n not in found]:
            break
        subprocess.run([sys.executable, a.tre_reader, tre, 'extract', rx, tmp], capture_output=True, text=True)
        for n in names:
            p = os.path.join(tmp, 'quest', n + '.qst')
            if n in found or not os.path.exists(p):
                continue
            xml = qst_xml(p)
            if xml is None:
                continue
            try:
                tasks = parse_tasks(xml)
            except ET.ParseError as e:
                tasks = [{'type': 'PARSE_ERROR', 'id': '', 'name': str(e), 'depth': 0, 'data': {}}]
            qst.append({'name': n, 'tre': os.path.basename(tre), 'tasks': tasks})
            found.add(n)
    missing = [n for n in names if n not in found]
    json.dump({'quests': quests, 'qst': qst, 'missing_qst': missing,
               'notes': f'transcribe_quests.py pattern {a.pattern}; questlist from {qdir}; qst from {[os.path.basename(t) for t in a.tre]}'},
              open(a.out, 'w', encoding='utf-8'), indent=1)
    print('quests', len(quests), 'qst', len(qst), 'missing', missing, file=sys.stderr)


if __name__ == '__main__':
    main()

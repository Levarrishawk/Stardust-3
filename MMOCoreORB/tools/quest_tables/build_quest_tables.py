#!/usr/bin/env python3
"""Build the client/server quest tables (questlist + questtask .iff) from a LOCAL SOE datatable source.

Ruling R16 (Aaron 2026-09-04): SOE-compiled datatables never live in this repo; only the compiler and this build
script do. Run it against your own copy of the source tables to produce the files the server reads loose under
MMOCoreORB/bin/datatables/questtask/quest/ (a loose file shadows the TRE copy, DataArchiveStore.cpp:20-46) and the
client overlay directory (searchPath_00_50=<dir> in swgemu_live.cfg; the client needs BOTH questlist and questtask).

    python build_quest_tables.py --src <SOE datatables root> --server <MMOCoreORB/bin/datatables> --client <overlay/datatables> som_ mtp_hideout_access_

Prefixes select the quest names, matched against <name> or <dir>/<name> (default: som_ mtp_hideout_access_; `mission/` selects the nine terminal-mission rows). Every table is round-tripped after packing
(pack -> unpack -> byte compare) and the run refuses to leave a table that does not round-trip.
"""
import argparse, glob, os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', required=True, help='SOE datatables root (contains questlist/quest and questtask/quest)')
    ap.add_argument('--server', help='MMOCoreORB/bin/datatables (writes questtask/quest/*.iff)')
    ap.add_argument('--client', help='client overlay datatables dir (writes questlist/quest and questtask/quest)')
    ap.add_argument('prefixes', nargs='*', default=['som_', 'mtp_hideout_access_'])
    a = ap.parse_args()
    tool = os.path.join(HERE, 'tab_to_iff.py'); built = []
    for kind in ('questlist', 'questtask'):
        # <kind>/<dir>/<name>.tab -> <kind>/<dir>/<name>.iff. The quest NAME the CRC table carries is "<dir>/<name>"
        # (PlayerManagerImplementation.cpp:663 opens datatables/questtask/<crc-table string>.iff), so ground quests sit
        # under quest/ and the generic terminal-mission rows under mission/ (journal-4-missions).
        for tab in sorted(glob.glob(os.path.join(a.src, kind, '*', '*.tab'))):
            sub = os.path.basename(os.path.dirname(tab)); name = os.path.basename(tab)[:-4]; qname = sub + '/' + name
            if not any(name.startswith(p) or qname.startswith(p) for p in a.prefixes): continue
            targets = []
            if a.client: targets.append(os.path.join(a.client, kind, sub, name + '.iff'))
            if a.server and kind == 'questtask': targets.append(os.path.join(a.server, kind, sub, name + '.iff'))
            for out in targets:
                os.makedirs(os.path.dirname(out), exist_ok=True)
                subprocess.check_call([sys.executable, tool, 'pack', tab, out]); built.append(out)
    if built:
        r = subprocess.run([sys.executable, tool, 'roundtrip'] + built, capture_output=True, text=True)
        print(r.stdout.strip())
        if 'differing' in r.stdout and not r.stdout.strip().endswith('0 differing'):
            sys.exit('round-trip failure -- see above')
    print('built', len(built), 'tables')
if __name__ == '__main__': main()

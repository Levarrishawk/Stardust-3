#!/usr/bin/env python3
"""Skeleton of SOE conversation / theme-park java scripts: the lines that carry the branch logic.

Usage: java_skeleton.py --root <script dir> --pattern <regex on file name> --out <json>

For every matching .java under the root (recursive): the file, its line count, and every line (with its number) that mentions a
string id ("s_123"), a quest call (grantQuest, completeQuest, clearQuest, isQuestActive, isQuestComplete, hasCompletedQuest,
sendSignal, signal), a condition on the player (getLevel, hasSkill, hasObjVar, getObjVar), an item or credit hand-out
(createObject, giveItem, transferCredits, grantItem, money), or a screen/branch marker (case, handler, screen, ConvoScreen).
The coder reads the full java beside it; this is the map. The java itself never leaves the machine.
"""
import argparse, json, os, re, sys

KEEP = re.compile(r'"s_\d+"|grantQuest|completeQuest|clearQuest|isQuestActive|isQuestComplete|hasCompletedQuest|sendSignal|'
                  r'signal|getLevel|hasSkill|hasObjVar|getObjVar|setObjVar|createObject|giveItem|transferCredits|grantItem|'
                  r'money|credits|case |handler|Screen|screen|npcStartConversation|npcEndConversation|isGod|faction|'
                  r'spawn|respawn|timer|Timer|messageTo|broadcast|sendSystemMessage|playClientEffect|play2dSound')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--root', required=True)
    ap.add_argument('--pattern', required=True)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    pat = re.compile(a.pattern)
    files = []
    for dp, dn, fn in os.walk(a.root):
        for f in fn:
            if f.endswith('.java') and pat.search(f):
                p = os.path.join(dp, f)
                lines = open(p, encoding='utf-8', errors='replace').read().split('\n')
                kept = [{'n': i, 'text': l.strip()[:220]} for i, l in enumerate(lines, start=1) if KEEP.search(l) and not l.strip().startswith('//')]
                files.append({'java': p, 'lines': len(lines), 'skeleton': kept})
    json.dump({'files': files, 'notes': f'java_skeleton.py root {a.root} pattern {a.pattern}'}, open(a.out, 'w', encoding='utf-8'), indent=1)
    print('files', len(files), 'kept lines', sum(len(f['skeleton']) for f in files), file=sys.stderr)


if __name__ == '__main__':
    main()

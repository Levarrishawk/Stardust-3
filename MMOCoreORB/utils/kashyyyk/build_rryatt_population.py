"""Generate the public Rryatt population from DSRC (no archive edits).

Usage: python build_rryatt_population.py DSRC_ROOT [--check]
--check compares generated files without writing them.
"""
import argparse
import csv
import json
import math
import re
from pathlib import Path

ORB = Path(__file__).resolve().parents[2]
SCRIPTS = ORB / 'bin/scripts'


def table(path):
    with path.open(encoding='utf-8-sig') as stream:
        rows = list(csv.reader(stream, delimiter='\t'))
    return [dict(zip(rows[0], row)) for row in rows[2:] if row and row[0]]


def variables(value):
    return dict(re.findall(r'([^|]+)\|[0245]\|([^|]*)\|', value))


def lua(value):
    if isinstance(value, str):
        return json.dumps(value)
    if isinstance(value, bool):
        return 'true' if value else 'false'
    if isinstance(value, (int, float)):
        return format(value, '.12g')
    if isinstance(value, list):
        return '{' + ', '.join(map(lua, value)) + '}'
    return '{' + ', '.join(k + ' = ' + lua(v) for k, v in value.items()) + '}'


def generate(root):
    server = root / 'sku.0/sys.server/compiled/game'
    shared = root / 'sku.0/sys.shared/compiled/game'
    areas = table(shared / 'datatables/buildout/areas_kashyyyk_rryatt_trail.tab')[:4]
    creatures = {r['creatureName']: r for r in table(server / 'datatables/mob/creatures.tab')}
    balance = table(server / 'datatables/mob/stat_balance.tab')
    dressed = {}
    for path in sorted((server / 'datatables/npc_customization').glob('dressed_species_*.tab')):
        rows = list(csv.reader(path.open(), delimiter='\t'))
        for i, name in enumerate(rows[0]):
            dressed[name] = list(dict.fromkeys(r[i] for r in rows[2:] if len(r) > i and r[i]))
    registered = {}
    for path in sorted((SCRIPTS / 'mobile').rglob('*.lua')):
        text = path.read_text(errors='replace')
        match = re.search(r'CreatureTemplates:addCreatureTemplate\([^,]+,\s*"([^"]+)"', text)
        templates = re.search(r'\btemplates\s*=\s*\{([^}]+)', text)
        if match and templates:
            registered[match[1]] = re.findall(r'"object/mobile/([^"]+)"', templates[1])
    controllers, patrols, points, conditional, types = [], [], {}, [], {}
    for area in areas:
        section = area['area']
        for line, row in enumerate(table(server / f'datatables/buildout/kashyyyk_rryatt_trail/{section}.tab'), 3):
            template, v = row['server_template_crc'], variables(row['objvars'])
            c = dict(id=section + ':' + str(line), section=section, row=line,
                     x=float(row['px']) + float(area['x1']), z=float(row['py']),
                     y=float(row['pz']) + float(area['z1']),
                     heading=math.degrees(2 * math.atan2(float(row['qy']), float(row['qw']))) % 360)
            if template.endswith(('area_spawner.iff', 'patrol_spawner.iff')):
                name = v['strSpawns']
                if name not in types:
                    types[name] = [dict(item=e['strItem'], clearance=float(e['fltSize']),
                                        mobile='rryatt_native_' + e['strItem'])
                                   for e in table(server / f'datatables/spawning/ground_spawning/types/{name}.tab')]
                c.update(type=name, radius=float(v['fltRadius']), count=int(v['intSpawnCount']),
                         respawnMin=float(v['fltMinSpawnTime']), respawnMax=float(v['fltMaxSpawnTime']),
                         behavior=int(v['intDefaultBehavior']), goodLocation=int(v['intGoodLocationSpawner']))
                assert c['goodLocation'] == 0 and 0 <= c['radius'] <= 9
                assert c['count'] > 0 and 0 <= c['respawnMin'] <= c['respawnMax']
                if template.endswith('patrol_spawner.iff'):
                    c.update(name=v['strName'], pathType=v['patrolPathType'],
                             pointNames=[p for p in v['strPatrolPointNames'].split(':') if p])
                    patrols.append(c)
                else:
                    assert c['behavior'] in (1, 2)
                    controllers.append(c)
            elif template.endswith('patrol_waypoint.iff'):
                points[v['pointName']] = [c['x'], c['z'], c['y']]
            elif template.endswith('rryatt_trail_rroot_spawner.iff'):
                conditional.append(c)
    for p in patrols:
        # spawner_patrol.setLocationArray prepends the controller itself.
        p['points'] = [[p['x'], p['z'], p['y']]] + [points[n] for n in p.pop('pointNames')]
    assert len(controllers) == 230 and sum(c['count'] for c in controllers) == 564
    assert len(types) == 41 and len(patrols) == 2 and len(conditional) == 1
    profiles = {}
    for item in sorted({e['item'] for entries in types.values() for e in entries}):
        r = creatures[item]
        appearance = r['template']
        appearances = [appearance] if appearance.endswith('.iff') else dressed[appearance]
        candidates = sorted(n for n, apps in registered.items() if appearances[0] in apps)
        stem = Path(appearances[0]).stem
        base = item if item in candidates else stem if stem in candidates else candidates[0] if len(candidates) == 1 else None
        # Mouf has an object template, but no existing creature profile to inherit.
        assert base or appearance == 'mouf.iff', (item, candidates)
        level = int(r['BaseLevel'])
        prefix = {'NORMAL': '', 'ELITE': 'Elite_', 'BOSS': 'Boss_'}[r['difficultyClass']]
        health = int(balance[max(1, level + int(r['StatLevelModifier'] or 0)) - 1][prefix + 'HP'])
        damage = float(balance[max(1, level + int(r['Damagelevelmodifier'] or 0)) - 1][prefix + 'damagePerSecond'])
        speed = float(r['primary_weapon_speed'] or 2)
        # Directly represent source health range/DPS in Core3's template fields.
        # Weapons, specials, armor and existing loot stay on the Core3 base profile.
        accuracy = float(balance[max(1, level + int(r['ToHitLevelModifier'] or 0)) - 1][prefix + 'ToHit'])
        fields = dict(objectName='@mob/creature_names:' + item, customName='',
                      socialGroup=r['socialGroup'], faction=r['pvpFaction'], level=level,
                      chanceHit=accuracy / 100, baseXp=int(balance[level - 1]['XP']),
                      baseHAM=int(health * .9), baseHAMmax=int(health * 1.1),
                      damageMin=math.floor(damage * speed * .5 + .5),
                      damageMax=math.floor(damage * speed * 1.5 + .5),
                      attackSpeed=speed, scale=(float(r['minScale'] or 1) + float(r['maxScale'] or 1)) / 2,
                      conversationTemplate='',
                      templates=['object/mobile/' + a for a in appearances])
        profiles[item] = dict(base=base or 'Creature', fields=fields,
                              invulnerable=int(r['invulnerable'] or 0) != 0,
                              aggressive=int(r['aggressive'] or 0) != 0,
                              scaleMin=float(r['minScale'] or 1), scaleMax=float(r['maxScale'] or 1),
                              difficulty=r['difficultyClass'], baseLevel=level)
    lines = ['-- Generated by utils/kashyyyk/build_rryatt_population.py; first four public DSRC areas only.',
             '-- Type rows are uniform selections; duplicates retain frequency. Clearance is not a weight.',
             'KashyyykRryattPopulationData = {', '\ttypes = {']
    for name, entries in sorted(types.items()):
        lines.append('\t\t[' + lua(name) + '] = {')
        lines.extend('\t\t\t' + lua(e) + ',' for e in entries)
        lines.append('\t\t},')
    lines += ['\t},', '\tprofiles = {']
    for item, p in profiles.items():
        lines.append('\t\t[' + lua('rryatt_native_' + item) + '] = ' + lua({k: p[k] for k in ['scaleMin', 'scaleMax', 'difficulty', 'baseLevel']}) + ',')
    lines += ['\t},', '\tcontrollers = {']
    lines.extend('\t\t' + lua(c) + ',' for c in controllers)
    lines += ['\t},', '\tpatrols = {']
    lines.extend('\t\t' + lua(c) + ',' for c in patrols)
    lines += ['\t},', '\trroot = ' + lua(conditional[0]), '}']
    mobile = ['-- Generated from DSRC creatures.tab and stat_balance.tab for Rryatt only.',
              '-- Source levels, class HP and DPS; inherited Core3 weapons, specials, armor and loot.',
              '-- NGE health is represented by Core3 HAM; accuracy / 100 matches Core3\'s accuracy multiplier.',
              '-- Scale uses the midpoint of the native range. This is a Core3 combat adaptation, not an NGE combat port.',
              '-- Other zones retain their original templates.']
    for item, p in profiles.items():
        f = p['fields']
        mobile += ['', 'local profile = ' + p['base'] + ':new {']
        mobile.extend('\t' + k + ' = ' + lua(v) + ',' for k, v in f.items())
        flags = 'NONE' if p['invulnerable'] else 'ATTACKABLE + ENEMY + AGGRESSIVE' if p['aggressive'] else 'ATTACKABLE'
        mobile += ['\trandomNameType = NAME_TAG,', '\tpvpBitmask = ' + flags + ',', '\toptionsBitmask = AIENABLED,']
        if p['base'] == 'Creature':
            mobile += ['\tweapons = {},', '\tattacks = {},', '\tlootGroups = {{groups = {{group = "kashyyyk_mouf", chance = 10000000}}, lootChance = 10000000}},']
        mobile += ['}', 'CreatureTemplates:addCreatureTemplate(profile, ' + lua('rryatt_native_' + item) + ')']
    return {SCRIPTS / 'screenplays/kashyyyk/kashyyyk_rryatt_population_data.lua': '\n'.join(lines) + '\n',
            SCRIPTS / 'mobile/custom_content/kashyyyk_rryatt_profiles.lua': '\n'.join(mobile) + '\n'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dsrc', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    for path, text in generate(args.dsrc).items():
        if args.check:
            assert path.read_text() == text, 'Generated data differs: ' + str(path)
        else:
            path.write_text(text, encoding='utf-8', newline='\n')
        print(('Checked' if args.check else 'Generated'), path.name)


if __name__ == '__main__':
    main()

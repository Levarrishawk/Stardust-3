"""Generate the standalone Hunting Grounds or South Dungeons population from DSRC."""
import argparse
import csv
import math
import re
from pathlib import Path, PurePosixPath

from build_dead_forest_population import position
from build_main_population import (AREA_SCRIPT, CELEBRITY_SCRIPT, PATROL_SCRIPT,
                                   get_registered, model_properties)
from build_rryatt_population import SCRIPTS, lua, table, variables

ZONE = 'kashyyyk_hunting'
PREFIX = 'hunting_'


def render_profiles(root, identities, actor_ids, name_prefix, comments):
    server = root / 'sku.0/sys.server/compiled/game'
    shared = root / 'sku.0/sys.shared/compiled/game'
    dt = server / 'datatables'
    dictionary = {r['creatureName']: r for r in table(dt / 'mob/creatures.tab')}
    balance = table(dt / 'mob/stat_balance.tab')
    registered = get_registered()
    dressed = {}
    for path in sorted((dt / 'npc_customization').glob('dressed_species_*.tab')):
        with path.open() as source:
            columns, _, *entries = csv.reader(source, delimiter='\t')
        for index, name in enumerate(columns):
            if name:
                dressed[name] = [row[index] for row in entries if len(row) > index and row[index]]

    profiles = list(comments)
    weapons = {r['weapon_id']: [path for key, path in r.items() if key != 'weapon_id' and path]
               for r in table(dt / 'ai/ai_weapons.tab')}
    used_weapons = {dictionary[item][key] for item in identities for key in ('primary_weapon', 'secondary_weapon')
                    if dictionary[item][key]}
    profiles.extend(f'addWeapon({lua(name_prefix + group)}, {lua(weapons[group])})' for group in sorted(used_weapons))
    profiles.extend(['', 'local profiles = {'])
    for item in sorted(identities):
        row = dictionary[item]
        template = row['template']
        apps = [template] if template.endswith('.iff') else dressed[template]
        stem = PurePosixPath(apps[0]).stem
        matching = [name for name, (_, paths, _) in registered.items() if apps[0] in paths]
        base_name = item if item in registered else stem if stem in matching else matching[0] if matching else 'Creature'
        base, _, legacy = registered.get(base_name, ('Creature', [], ''))
        if item == 'ep3_fern_bicker':
            # This base is included directly by custom_content/serverobjects.lua.
            base = item
        legacy = re.sub(r'--\[(=*)\[.*?\]\1\]', '', legacy, flags=re.S)
        conversation = re.search(r'^\s*conversationTemplate\s*=\s*"([^"]+)"', legacy, re.M)
        conv = conversation[1] if conversation else ''
        script = next((s.split('.', 1)[1] for s in row['scripts'].split(',') if s.startswith('conversation.')), '')
        assigned_names = set()
        if script:
            java = (server / 'script/conversation' / (script + '.java')).read_text()
            assigned_names = set(re.findall(r'setName\(self,\s*new string_id\("([^"]+)",\s*"([^"]+)"\)\)', java))
            assert len(assigned_names) <= 1, item

        models = [model_properties(shared, app) for app in apps]
        name = '@mob/creature_names:' + item
        if assigned_names:
            name = '@' + ':'.join(assigned_names.pop())
        elif item in actor_ids:
            name = models[0][0]
            assert name, item
        elif item == 'clone_droid':
            name = '@droid_name:b_surgical_droid_base'
            conv = 'clone_droid_convo'

        aggro = int(row['aggressive'] or 0)
        faction = row['pvpFaction'].lower()
        invulnerable = item in actor_ids or row['invulnerable'] == '1'
        flags = 'NONE' if invulnerable else 'ATTACKABLE' + (' + AGGRESSIVE + ENEMY' if aggro else '')
        options = 'AIENABLED' + (' + INVULNERABLE' if invulnerable else '')
        if conv:
            options += ' + CONVERSABLE + INTERESTING'
        fields = dict(objectName=name, customName='', conversationTemplate=conv, socialGroup=row['socialGroup'],
                      faction=faction, aggroRadius=aggro, templates=['object/mobile/' + app for app in apps])
        for field, source, default in (('primaryWeapon', 'primary_weapon', 'unarmed'),
                                       ('secondaryWeapon', 'secondary_weapon', 'none')):
            fields[field] = name_prefix + row[source] if row[source] else default
        model_min = min(model[1][0] for model in models)
        model_max = max(model[1][1] for model in models)
        lo, hi = model_min * float(row['minScale'] or 1), model_max * float(row['maxScale'] or 1)
        fields['scale'] = (lo + hi) / 2
        if lo < hi:
            fields.update(spawnScaleMin=lo, spawnScaleMax=hi)
        hue = int(row['hue'] or 0)
        if hue:
            fields['hues'] = list(range((hue - 1) * 8, hue * 8))
        if not invulnerable:
            base_level = int(row['BaseLevel'])
            hp, damage, hit, armor = (max(1, base_level + int(row[k] or 0)) for k in
                                     ('StatLevelModifier', 'Damagelevelmodifier', 'ToHitLevelModifier', 'ArmorLevelModifier'))
            level = (6 * hp + 6 * damage + 2 * hit + 4 * armor) // 18
            prefix = {'NORMAL': '', 'ELITE': 'Elite_', 'BOSS': 'Boss_'}[row['difficultyClass']]
            speed = float(row['primary_weapon_speed'] or 2)
            health = float(balance[hp - 1][prefix + 'HP'])
            damage_per_attack = float(balance[damage - 1][prefix + 'damagePerSecond']) * speed
            fields.update(level=level, baseXp=int(balance[level - 1]['XP']), baseHAM=int(health * .9),
                          baseHAMmax=int(health * 1.1), chanceHit=float(balance[hit - 1][prefix + 'ToHit']) / 100,
                          attackSpeed=speed, damageMin=math.floor(damage_per_attack * .5 + .5),
                          damageMax=math.floor(damage_per_attack * 1.5 + .5))
        traits = ' + '.join(bit for bit, field in [('STALKER', 'stalker'), ('KILLER', 'death_blow')]
                            if not invulnerable and row[field] in ('1', 'yes', 'instant')) or 'NONE'
        niche = row['niche'].upper()
        assert niche in {'CARNIVORE', 'HERBIVORE', 'NPC', 'DROID', 'ANDROID'}, (item, niche)
        profiles.append(f'\t{{{base}, {lua(name_prefix + item)}, ' + lua(fields)[:-1] +
                        f', mobType = MOB_{niche}, randomNameType = NAME_TAG, pvpBitmask = {flags}, '
                        f'optionsBitmask = {options}, creatureBitmask = {traits}}}}},')
    profiles.extend(['}', '', 'for _, profile in ipairs(profiles) do',
                     '\tCreatureTemplates:addCreatureTemplate(profile[1]:new(profile[3]), profile[2])', 'end', ''])
    return '\n'.join(profiles)


def generate(root):
    server = root / 'sku.0/sys.server/compiled/game'
    shared = root / 'sku.0/sys.shared/compiled/game'
    dt = server / 'datatables'
    area, = table(shared / f'datatables/buildout/areas_{ZONE}.tab')
    rows = table(dt / f'buildout/{ZONE}/{ZONE}.tab')

    waypoints = {variables(row['objvars'])['pointName']: position(row, area) for row in rows
                 if row['scripts'] == 'systems.spawning.patrol_point_setup'}
    controllers, patrols, actors, types = [], [], [], {}
    for line, row in enumerate(rows, 3):
        script = row['scripts']
        if script not in {AREA_SCRIPT, PATROL_SCRIPT, CELEBRITY_SCRIPT}:
            continue
        assert row['container'] == row['cell_index'] == '0' and float(row['qx']) == float(row['qz']) == 0
        values = variables(row['objvars'])
        x, z, y = position(row, area)
        spawn = dict(id=int(row['objid']), row=line, x=x, z=z, y=y,
                     heading=math.degrees(2 * math.atan2(float(row['qy']), float(row['qw']))))
        if script == CELEBRITY_SCRIPT:
            assert not values.get('npc_name') and not values.get('quest_script')
            spawn.update(item=values['spawns'], mobile=PREFIX + values['spawns'], z=z + .5)
            actors.append(spawn)
            continue
        name = values['strSpawns']
        if name not in types:
            path = dt / f'spawning/ground_spawning/types/{name}.tab'
            entries = table(path) if path.is_file() else [{'strItem': name, 'fltSize': 8}]
            types[name] = [dict(item=e['strItem'], mobile=PREFIX + e['strItem'],
                                clearance=float(e['fltSize'] or 1)) for e in entries]
        spawn.update(type=name, count=int(values['intSpawnCount']), radius=float(values['fltRadius']),
                     respawnMin=float(values.get('fltRespawnTime', values['fltMinSpawnTime'])),
                     respawnMax=float(values.get('fltRespawnTime', values['fltMaxSpawnTime'])),
                     behavior=int(values['intDefaultBehavior']))
        assert spawn['count'] > 0 and 0 <= spawn['respawnMin'] <= spawn['respawnMax']
        if values['intGoodLocationSpawner'] == '1':
            spawn['findSpawnPoint'] = True
            for entry in types[name]:
                entry['searchRadius'] = next((size for size in (4, 8, 12, 16, 32, 48, 64, 80, 96)
                                              if entry['clearance'] <= size), 32)
        if script == PATROL_SCRIPT:
            packed = re.search(r'patrolArray\|9\|([^|]+)', row['objvars'])
            names = re.search(r'strPatrolPointNames\|5\|([^|]+)', row['objvars'])[1].strip(':').split(':')
            if packed:
                points = [list(map(float, point.split()[:3])) for point in packed[1].strip(':').split(':')]
            else:
                points = [[x, z, y]] + [waypoints[n] for n in names if n in waypoints]
            assert spawn['count'] < len(points), line
            spawn.update(pathType=values['patrolPathType'], points=points)
            patrols.append(spawn)
        else:
            controllers.append(spawn)

    actor_ids = {a['item'] for a in actors}
    identities = actor_ids | {e['item'] for entries in types.values() for e in entries}
    assert (len(controllers), len(patrols), len(types), len(actors)) == (258, 14, 43, 17)
    assert sum(c['count'] for c in controllers + patrols) == 618
    assert sum(c.get('findSpawnPoint', False) for c in controllers) == 5

    data = ['-- Generated by utils/kashyyyk/build_hunting_population.py.',
            '-- DSRC Hunting Grounds coordinates and weighted type rows.',
            'KashyyykHuntingData = {', '\ttypes = {']
    data.extend('\t\t[' + lua(name) + '] = ' + lua(entries) + ',' for name, entries in sorted(types.items()))
    data.append('\t},')
    for key, entries in (('controllers', controllers), ('patrols', patrols), ('actors', actors)):
        data.extend(['\t' + key + ' = {', *('\t\t' + lua(e) + ',' for e in entries), '\t},'])
    data.extend(['}', ''])

    profiles = render_profiles(root, identities, actor_ids, PREFIX, [
        '-- Generated by utils/kashyyyk/build_hunting_population.py.',
        '-- Dedicated Hunting Grounds identities retain the existing quest handlers.',
    ])
    print(f'{len(controllers)} area controllers, {len(patrols)} patrols, {len(actors)} actors, '
          f'{len(types)} type tables, {len(identities)} profiles.')
    return {SCRIPTS / 'screenplays/kashyyyk/kashyyyk_hunting_data.lua': '\n'.join(data),
            SCRIPTS / 'mobile/custom_content/kashyyyk_hunting_profiles.lua': profiles}


def generate_south_dungeons(root):
    zone = 'kashyyyk_south_dungeons'
    profile_prefix = 'south_'
    header = '-- Generated by utils/kashyyyk/build_hunting_population.py --south-dungeons.'
    base = root / 'sku.0'
    dt = base / 'sys.server/compiled/game/datatables'
    areas = table(base / f'sys.shared/compiled/game/datatables/buildout/areas_{zone}.tab')
    types, controllers = {}, []
    identities = {'ep3_hracca_chiss_poacher_hunter', 'ep3_hracca_kkorrwrot'}
    for island in ('hracca', 'bocctyyy'):
        area = next(area for area in areas if area['area'] == island)
        rows = table(dt / f'buildout/{zone}/{island}.tab')
        for line, row in enumerate(rows, 3):
            if row['scripts'] != AREA_SCRIPT:
                continue
            config = variables(row['objvars'])
            name = config['strSpawns']
            assert row['cell_index'] == '0' and config['intGoodLocationSpawner'] == '0'
            if name not in types:
                entries = table(dt / f'spawning/ground_spawning/types/{name}.tab')
                types[name] = []
                for entry in entries:
                    item = entry['strItem']
                    prefix = profile_prefix if item.startswith('ep3_hracca_') else 'hunting_'
                    if prefix == profile_prefix:
                        identities.add(item)
                    types[name].append(dict(mobile=prefix + item))
            controllers.append(dict(id=f'{island}:{line}', type=name,
                                    x=float(row['px']) + float(area['x1']), z=float(row['py']),
                                    y=float(row['pz']) + float(area['z1']),
                                    heading=math.degrees(2 * math.atan2(float(row['qy']), float(row['qw']))),
                                    count=int(config['intSpawnCount']), radius=float(config['fltRadius']),
                                    respawnMin=float(config['fltMinSpawnTime']),
                                    respawnMax=float(config['fltMaxSpawnTime']),
                                    behavior=int(config['intDefaultBehavior'])))

    assert len(controllers) == 55 and sum(c['count'] for c in controllers) == 158
    data = [header, 'KashyyykSouthDungeonsPopulation = KashyyykSpawnController:new {',
            '\tnumberOfActs = 1,', '\tscreenplayName = "KashyyykSouthDungeonsPopulation",',
            '\tdataKey = "SouthDungeonsPopulation",', f'\tzone = "{zone}",',
            '\tdata = {', '\t\ttypes = {']
    data.extend(f'\t\t\t[{lua(name)}] = {lua(entries)},' for name, entries in sorted(types.items()))
    data.extend(['\t\t},', '\t\tcontrollers = {'])
    data.extend(f'\t\t\t{lua(c)},' for c in controllers)
    data.extend(['\t\t},', '\t\tpatrols = {},', '\t},', '}', '',
                 'registerScreenPlay("KashyyykSouthDungeonsPopulation", true)', ''])
    return {
        SCRIPTS / 'screenplays/kashyyyk/kashyyyk_south_dungeons_population.lua': '\n'.join(data),
        SCRIPTS / 'mobile/custom_content/kashyyyk_south_dungeons_profiles.lua':
            render_profiles(root, identities, set(), profile_prefix, [header]),
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dsrc', type=Path)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--south-dungeons', action='store_true')
    args = parser.parse_args()
    build = generate_south_dungeons if args.south_dungeons else generate
    for path, content in build(args.dsrc).items():
        if args.check:
            assert path.read_text(encoding='utf-8') == content, path
        else:
            path.write_text(content, encoding='utf-8', newline='\n')

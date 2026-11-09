"""Generate the public Kachirho buildout population and its DSRC creature profiles."""

import argparse
import csv
import math
import re
from pathlib import Path, PurePosixPath

from build_rryatt_population import SCRIPTS, lua, table, variables

ZONE = 'kashyyyk_main'
STATIC_BASES = {
    'chewbacca': 'ep3_chewbacca',
    'ep3_chassis_broker_05': 'space_ep3_chassis_broker_05',
    'ep3_clone_relics_wookiee_prisoner_04': 'ep3_clone_relics_wookie_prisoner_04',
}
TEMPLATE_NAMES = {
    'ep3_etyyy_kerssoc', 'ep3_etyyy_chrilooc', 'ep3_etyyy_wrelaac', 'ep3_etyyy_mada_johnson',
    'ep3_harwakokok_mighty', 'ep3_musolium', 'ep3_pressk', 'ep3_eyma', 'ep3_ortha_ledox',
    'ep3_dr_farnsworth', 'ep3_col_gurnst', 'ep3_kachirho_chatook', 'ep3_marium_valmont',
    'ep3_wke_merchant_03', 'ep3_wke_merchant_04', 'ep3_chassis_broker_05',
    'ep3_mining_flash_harrison', 'ep3_mining_captain_koh', 'ep3_wke_vryyyr',
    'clone_relics_darth_vader', 'clone_relics_admiral_krieg',
}
CORPSE_SCRIPT = 'npc.celebrity.corpse_spawner'
CELEBRITY_SCRIPT = 'npc.celebrity.celebrity_spawner'
AREA_SCRIPT = 'systems.spawning.spawner_area'
PATROL_SCRIPT = 'systems.spawning.spawner_patrol'
ENCOUNTER_QUESTS = ('ep3_trando_boshaz_zssik_02', 'ep3_trando_ssiksik', 'ep3_slaver_gursan_entry_quest')
# Their DSRC conversation OnAttach and OnInitialize handlers set invulnerability.
SCRIPT_INVULNERABLE = {'clone_relics_admiral_krieg', 'clone_relics_darth_vader'}
# The local client archive has this text, but the configured server archives lack the key.
SERVER_NAME_FALLBACKS = {'ep3_wke_vryyyr': 'Vryyyr (Master Hunter)'}


def mobile_name(item):
    return 'kachirho_' + item


def get_registered():
    mobile = SCRIPTS / 'mobile'
    registered, visited = {}, set()

    def visit(path):
        path = path.resolve()
        if path in visited or not path.is_file():
            return
        visited.add(path)
        source = path.read_text(errors='replace')
        for child in re.findall(r'^\s*includeFile\("([^"]+)"\)', source, re.M):
            visit(mobile / child)
        match = re.search(r'CreatureTemplates:addCreatureTemplate\((\w+),\s*"([^"]+)"\)', source)
        if match:
            models = re.search(r'\btemplates\s*=\s*\{([^}]*)', source)
            registered[match[2]] = (match[1], re.findall(r'"object/mobile/([^"]+)"', models[1]) if models else [], source)

    for directory in ('custom_content/ep3', 'custom_content/mobile', 'faction/imperial', 'dungeon', 'townsperson'):
        visit(mobile / directory / 'serverobjects.lua')
    return registered


def model_properties(root, appearance):
    path = PurePosixPath('object/mobile') / appearance
    path = path.with_name('shared_' + path.name)
    label, scale = None, None
    while path:
        text = (root / path.with_suffix('.tpf')).read_text(errors='replace')
        if label is None:
            name = re.search(r'^\s*objectName\s*=\s*"([^"]+)"\s+"([^"]+)"', text, re.M)
            if name:
                label = '@' + ':'.join(name.groups())
        if scale is None:
            size = re.search(r'^\s*scale\s*=\s*([\d.]+?)\.\.([\d.]+)\s*$', text, re.M)
            if size:
                scale = tuple(map(float, size.groups()))
        parent = re.search(r'^@base\s+(\S+)', text, re.M)
        path = PurePosixPath(parent[1]) if parent else None
    return label, scale or (1, 1)


def generate(root):
    server = root / 'sku.0/sys.server/compiled/game'
    shared = root / 'sku.0/sys.shared/compiled/game'
    dt = server / 'datatables'
    area, = table(shared / f'datatables/buildout/areas_{ZONE}.tab')
    rows = table(dt / f'buildout/{ZONE}/{ZONE}.tab')
    dictionary = {r['creatureName']: r for r in table(dt / 'mob/creatures.tab')}
    balance = table(dt / 'mob/stat_balance.tab')
    dressed = {}
    for path in sorted((dt / 'npc_customization').glob('dressed_species_*.tab')):
        with path.open() as f:
            columns, _, *entries = csv.reader(f, delimiter='\t')
        for i, name in enumerate(columns):
            if name:
                dressed[name] = [r[i] for r in entries if len(r) > i and r[i]]
    registered = get_registered()

    controllers, types, patrols, actors = [], {}, [], []
    actor_names, actor_scripts = {}, {}
    waypoints = {
        variables(r['objvars'])['pointName']: [round(float(r['px']) + float(area['x1']), 7), float(r['py']),
                                               round(float(r['pz']) + float(area['z1']), 7)]
        for r in rows if r['scripts'] == 'systems.spawning.patrol_point_setup'
    }
    for line, row in enumerate(rows, 3):
        script = row['scripts']
        if script not in (AREA_SCRIPT, PATROL_SCRIPT, CELEBRITY_SCRIPT, CORPSE_SCRIPT):
            continue
        assert row['container'] == row['cell_index'] == '0' and float(row['qx']) == float(row['qz']) == 0
        v = variables(row['objvars'])
        x = round(float(row['px']) + float(area['x1']), 7)
        z = float(row['py'])
        y = round(float(row['pz']) + float(area['z1']), 7)
        heading = math.degrees(2 * math.atan2(float(row['qy']), float(row['qw'])))
        if script in (CELEBRITY_SCRIPT, CORPSE_SCRIPT):
            item = v['spawns']
            if v.get('npc_name'):
                assert actor_names.setdefault(item, v['npc_name']) == v['npc_name']
            if v.get('quest_script'):
                actor_scripts[item] = v['quest_script']
            if script == CELEBRITY_SCRIPT:
                z += .5
            if item == 'ep3_col_gurnst':
                # Previously checked against the first tree landing in game.
                x, z, y = -457.8, 158.5, -26.2
            actors.append([mobile_name(item), x, z, y, heading, line, script == CORPSE_SCRIPT])
            continue
        kind = v['strSpawns']
        if kind not in types:
            source = dt / f'spawning/ground_spawning/types/{kind}.tab'
            entries = table(source) if source.is_file() else [{'strItem': kind, 'fltSize': 1}]
            types[kind] = [
                dict(item=r['strItem'], clearance=float(r['fltSize'] or 1),
                     mobiles=[mobile_name('ep3_kachirho_bolotaur_sunbaked' if
                                          r['strItem'] == 'ep3_kachirho_sunbaked' else r['strItem'])])
                for r in entries
            ]
        c = dict(id=int(row['objid']), row=line, type=kind, x=x, z=z, y=y, heading=heading,
                 radius=float(v['fltRadius']), count=int(v['intSpawnCount']),
                 respawnMin=float(v['fltMinSpawnTime']), respawnMax=float(v['fltMaxSpawnTime']),
                 behavior=int(v['intDefaultBehavior']))
        assert v['intGoodLocationSpawner'] == '0' and c['count'] > 0
        if script == AREA_SCRIPT:
            if kind == 'kashyyyk/kash_kachirho_wke_ceremonial_guard' and line in (52, 53, 54, 55):
                c['snapToFloor'] = True
            controllers.append(c)
        else:
            # DSRC initializes on the first N entries of patrolArray, which includes the controller.
            encoded = re.search(r'patrolArray\|9\|([^|]+)', row['objvars'])
            names = re.search(r'strPatrolPointNames\|5\|([^|]+)', row['objvars'])[1].strip(':').split(':')
            points = ([list(map(float, point.split()[:3])) for point in encoded[1].strip(':').split(':')]
                      if encoded else [[x, z, y]] + [waypoints[n] for n in names])
            c.update(name=v['strName'], spawnZone=ZONE, zone=ZONE, pathType=v['patrolPathType'], points=points)
            patrols.append(c)

    bunker_source = table(dt / 'spawning/clone_relic/ep3_bunker_imperial_kashyyyk.tab')
    bunker = [[mobile_name(r['spawns']), r['room'],
               *(float(r[k]) for k in ('loc_x', 'loc_y', 'loc_z', 'yaw')), r['animation_mood']]
              for r in bunker_source]
    encounters = {}
    for quest in ENCOUNTER_QUESTS:
        for row in table(shared / f'datatables/questtask/quest/{quest}.tab'):
            if row['ATTACH_SCRIPT'] == 'quest.task.ground.encounter':
                encounters[row['TASK_NAME']] = dict(
                    mobile=mobile_name(row['CREATURE_TYPE']), count=int(row['COUNT']),
                    minDistance=int(row['MIN_DISTANCE']), maxDistance=int(row['MAX_DISTANCE']),
                    offsetX=float(row['RELATIVE_OFFSET_X']), offsetY=float(row['RELATIVE_OFFSET_Z']),
                )
    actor_ids = {a[0].removeprefix('kachirho_') for a in actors}
    bunker_ids = {r['spawns'] for r in bunker_source}
    encounter_ids = {row['mobile'].removeprefix('kachirho_') for row in encounters.values()}
    identities = actor_ids | bunker_ids | encounter_ids | {
        e['mobiles'][0].removeprefix('kachirho_') for entries in types.values() for e in entries
    }
    assert (len(controllers), sum(c['count'] for c in controllers), len(types), len(patrols), len(actors), len(bunker)) == (
        240, 579, 38, 27, 55, 10)

    data = ['-- Generated by MMOCoreORB/utils/kashyyyk/build_main_population.py.',
            '-- Buildout positions, weighted type rows, and the Imperial bunker spawn table.',
            'KashyyykMainPopulationData = {', '\ttypes = {']
    for kind, entries in sorted(types.items()):
        data += ['\t\t[' + lua(kind) + '] = {', *('\t\t\t' + lua(e) + ',' for e in entries), '\t\t},']
    data.append('\t},')
    for key, entries in (('controllers', controllers), ('patrols', patrols), ('actors', actors), ('bunker', bunker)):
        data += ['\t' + key + ' = {', *('\t\t' + lua(e) + ',' for e in entries), '\t},']
    data += ['\tencounters = {', *(f'\t\t{name} = {lua(row)},' for name, row in encounters.items()), '\t},']
    data += ['}', '']

    profiles = ['-- Generated from DSRC creatures.tab, dressed species, and the Kachirho spawn sources.',
                '-- These profiles are scoped to kashyyyk_main.']
    weapons = {r['weapon_id']: [path for key, path in r.items() if key != 'weapon_id' and path]
               for r in table(dt / 'ai/ai_weapons.tab')}
    used_weapons = {dictionary[item][key] for item in identities for key in ('primary_weapon', 'secondary_weapon')
                    if dictionary[item][key]}
    profiles.extend(f'addWeapon({lua(mobile_name(group))}, {lua(weapons[group])})' for group in sorted(used_weapons))
    profiles += ['', 'local profiles = {']
    for item in sorted(identities):
        r = dictionary[item]
        template = r['template']
        apps = [template] if template.endswith('.iff') else dressed[template]
        base_name = STATIC_BASES.get(item, item)
        if base_name not in registered:
            stem = PurePosixPath(apps[0]).stem
            matching = [name for name, (_, appearances, _) in registered.items() if apps[0] in appearances]
            base_name = stem if stem in matching else matching[0] if matching else 'Creature'
        base, _, legacy = registered.get(base_name, ('Creature', [], ''))
        if item == 'clone_relics_darth_vader':
            base, _, legacy = registered['ep3_clone_relics_darth_vader']
        elif item == 'clone_relics_admiral_krieg':
            base, _, legacy = registered['ep3_clone_relics_admiral_krieg']
        legacy = re.sub(r'--\[(=*)\[.*?\]\1\]', '', legacy, flags=re.S)
        conv = re.search(r'^\s*conversationTemplate\s*=\s*"([^"]+)"', legacy, re.M)
        conv = conv[1] if conv else ''
        conv_script = actor_scripts.get(item) or next((s for s in r['scripts'].split(',') if s.startswith('conversation.')), '')
        if conv_script:
            source = server / 'script/conversation' / (conv_script.split('.', 1)[1] + '.java')
            assignments = set(re.findall(r'setName\(self, new string_id\("([^"]+)",\s*"([^"]+)"\)\)', source.read_text()))
            assert len(assignments) <= 1, item
            candidate = source.stem + '_convo'
            if not conv and any((SCRIPTS / 'mobile/conversations').rglob(candidate + '.lua')):
                conv = candidate
        else:
            assignments = set()
        models = [model_properties(shared, a) for a in apps]
        custom = actor_names.get(item, SERVER_NAME_FALLBACKS.get(item, ''))
        if assignments:
            label = '@' + ':'.join(assignments.pop())
        elif item == 'clone_droid':
            label = '@droid_name:b_surgical_droid_base'
        elif item == 'ep3_kachirho_bolotaur_sunbaked':
            label = '@mob/creature_names:ep3_bolotaur_sunbaked'
        elif item in TEMPLATE_NAMES:
            label = models[0][0]
            assert label, item
        else:
            label = '@mob/creature_names:' + item
        if custom:
            label = ''
        radius = int(r['aggressive'] or 0)
        faction = r['pvpFaction'].lower()
        dictionary_invulnerable = r['invulnerable'] == '1'
        invulnerable = item in actor_ids or item in SCRIPT_INVULNERABLE or dictionary_invulnerable
        flags = 'NONE' if invulnerable else 'ATTACKABLE' + (' + AGGRESSIVE + ENEMY' if radius else '')
        options = 'AIENABLED' + (' + INVULNERABLE' if invulnerable else '')
        if conv:
            options += ' + CONVERSABLE + INTERESTING'
        if not invulnerable and faction in ('imperial', 'rebel'):
            options += ' + FACTIONAGGRO'
        fields = dict(objectName=label, customName=custom, conversationTemplate=conv, socialGroup=r['socialGroup'],
                      faction=faction, aggroRadius=radius, templates=['object/mobile/' + a for a in apps])
        for field, source, default in (('primaryWeapon', 'primary_weapon', 'unarmed'),
                                       ('secondaryWeapon', 'secondary_weapon', 'none')):
            if item not in actor_ids:
                fields[field] = mobile_name(r[source]) if r[source] else default
        scales = {m[1] for m in models}
        assert len(scales) == 1, (item, scales)
        model_min, model_max = scales.pop()
        lo, hi = model_min * float(r['minScale'] or 1), model_max * float(r['maxScale'] or 1)
        assert 0 < lo <= hi
        fields['scale'] = (lo + hi) / 2
        if lo < hi:
            fields.update(spawnScaleMin=lo, spawnScaleMax=hi)
        hue = int(r['hue'] or 0)
        if hue:
            fields['hues'] = list(range((hue - 1) * 8, hue * 8))
        if item not in actor_ids and not dictionary_invulnerable:
            base_level = int(r['BaseLevel'])
            hp_level, damage_level, hit_level, armor_level = (
                max(1, base_level + int(r[k] or 0)) for k in
                ('StatLevelModifier', 'Damagelevelmodifier', 'ToHitLevelModifier', 'ArmorLevelModifier'))
            level = (6 * hp_level + 6 * damage_level + 2 * hit_level + 4 * armor_level) // 18
            prefix = {'NORMAL': '', 'ELITE': 'Elite_', 'BOSS': 'Boss_'}[r['difficultyClass']]
            speed = float(r['primary_weapon_speed'] or 2)
            hp = float(balance[hp_level - 1][prefix + 'HP'])
            damage = float(balance[damage_level - 1][prefix + 'damagePerSecond']) * speed
            fields.update(level=level, baseXp=int(balance[level - 1]['XP']), baseHAM=int(hp * .9), baseHAMmax=int(hp * 1.1),
                          chanceHit=float(balance[hit_level - 1][prefix + 'ToHit']) / 100, attackSpeed=speed,
                          damageMin=math.floor(damage * .5 + .5), damageMax=math.floor(damage * 1.5 + .5))
        traits = ' + '.join(bit for bit, field in [('STALKER', 'stalker'), ('KILLER', 'death_blow')]
                            if not invulnerable and r[field] in ('1', 'yes', 'instant')) or 'NONE'
        niche = r['niche'].upper()
        assert niche in {'CARNIVORE', 'HERBIVORE', 'NPC', 'DROID', 'ANDROID'}, (item, niche)
        profiles.append(f'\t{{{base}, {lua(mobile_name(item))}, ' + lua(fields)[:-1] +
                        f', mobType = MOB_{niche}, randomNameType = NAME_TAG, pvpBitmask = {flags}, '
                        f'optionsBitmask = {options}, creatureBitmask = {traits}}}}},')
    profiles += ['}', '', 'for _, profile in ipairs(profiles) do',
                 '\tCreatureTemplates:addCreatureTemplate(profile[1]:new(profile[3]), profile[2])', 'end', '']
    print(f'{len(controllers)} area controllers, {len(patrols)} patrols, {len(actors)} static placements, '
          f'{len(bunker)} bunker rows, {len(encounters)} quest encounters and {len(identities)} DSRC creature identities.')
    return {
        SCRIPTS / 'screenplays/kashyyyk/kashyyyk_main_population_data.lua': '\n'.join(data),
        SCRIPTS / 'mobile/custom_content/kashyyyk_main_profiles.lua': '\n'.join(profiles),
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dsrc', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    for path, content in generate(args.dsrc).items():
        if args.check:
            assert path.read_text() == content, path
        else:
            path.write_bytes(content.encode())

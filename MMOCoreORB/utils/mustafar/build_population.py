"""Generate Mustafar's overworld population from local DSRC tables."""

import argparse
import csv
import math
import re
import sys
from collections import Counter
from pathlib import Path, PurePosixPath

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'kashyyyk'))
from build_rryatt_population import SCRIPTS, lua, table

ZONE = 'mustafar'
BASES = {
    'som_ash_scale': 'tanray',
    'som_berkens_flow_xandank_stalker': 'xandank',
    'som_blistmok_ura_jen': 'blistmok',
    'som_crystal_flats_salvage_bandit_chief': 'must_salvage_bandit_leader_01',
    'som_crystal_flats_salvage_bandit_enforcer': 'mustafarian_m_02',
    'som_crystal_flats_salvage_bandit_king': 'boss_uruli',
    'som_crystal_flats_salvage_bandit_thug': 'must_salvage_bandit_01',
    'som_doctor_lu': 'doc_lu',
    'som_dying_miner': 'mustafarian_m_01',
    'som_jundak_cinderclaw': 'cinderclaw',
    'som_kenobi_enclave_scavenger': 'ruins_human',
    'som_kenobi_striking_mining_leader': 'som_kenobi_moral_strike_leader',
    'som_kenobi_treasure_hunter_corpse_mix': 'som_kenobi_treasure_hunter_corpse_01',
    'som_kenobi_tulrus': 'som_kenobi_reunite_tulrus',
    'som_mining_droid_bucket': 'must_mining_droid_mark_01',
    'som_mining_droid_claw': 'must_mining_droid_mark_02',
    'som_mining_droid_fork': 'must_mining_droid_mark_03',
    'som_mustafarian_miner': 'mustafarian_m_01',
    'som_mustafarian_salvage_bandit': 'must_salvage_bandit_01',
    'som_mustafarian_salvage_leader': 'must_salvage_bandit_leader_01',
    'som_mustafarian_scout': 'must_scout',
    'som_nesting_grounds_tulrus': 'tulrus',
    'som_nesting_grounds_tulrus_ancient': 'tulrus',
    'som_nesting_grounds_tulrus_bull': 'tulrus',
    'som_nesting_grounds_tulrus_matriarch': 'tulrus',
    'som_pulverizer': 'union_sentry_droid',
    'som_ruins_hunter': 'ruins_human',
    'som_ruins_stalker': 'ruins_human',
    'som_sansii_kursk': 'sansii',
    'som_storm_lord_blistmok': 'storm_lord_minion',
    'som_striking_camp_miner': 'miner_on_strike',
    'som_striking_camp_miner_chief': 'miner_foreman_on_strike',
    'som_xandank_pack': 'xandank',
    'som_xandank_packleader': 'xandank',
}
NAMES = {
    'som_ash_scale': 'Ash Scale',
    'som_blistmok_ura_jen': 'Ura Jen',
    'som_crystal_flats_salvage_bandit_chief': 'a Salvage Bandit Chief',
    'som_crystal_flats_salvage_bandit_enforcer': 'a Salvage Bandit Enforcer',
    'som_kenobi_enclave_scavenger': 'a Scavenger',
    'som_nesting_grounds_tulrus': 'a Nesting Grounds Tulrus',
    'som_nesting_grounds_tulrus_ancient': 'an Ancient Tulrus',
    'som_nesting_grounds_tulrus_bull': 'a Tulrus Bull',
    'som_nesting_grounds_tulrus_matriarch': 'a Tulrus Matriarch',
    'som_pulverizer': 'Pulverizer',
    'som_ruins_hunter': 'a Mindless Hunter',
    'som_ruins_stalker': 'a Frenzied Hunter',
    'som_storm_lord_blistmok': "a Storm Lord's Blistmok",
    'som_xandank_packleader': 'a Xandank Packleader',
}


def variables(text):
    fields = text.removesuffix('$|').strip('|').split('|')
    assert fields == [''] or len(fields) % 3 == 0, text
    return {fields[i]: fields[i + 2] for i in range(0, len(fields) - 2, 3)}


def mobile(item):
    return 'mustafar_world_' + item.removeprefix('som_')


def placement(row, area):
    assert row['container'] == '0' and row['cell_index'] == '0', row
    return [
        round(float(row['px']) + float(area['x1']), 8),
        float(row['py']),
        round(float(row['pz']) + float(area['z1']), 8),
    ]


def heading(row):
    assert float(row['qx']) == float(row['qz']) == 0, row
    return math.degrees(2 * math.atan2(float(row['qy']), float(row['qw'])))


def read_population(server, shared):
    dt = server / 'datatables'
    controllers, patrols, points, actors, types = [], [], {}, {}, {}
    areas = table(shared / 'datatables/buildout/areas_mustafar.tab')[:4]
    for area in areas:
        section = area['area']
        for line, row in enumerate(table(dt / f'buildout/{ZONE}/{section}.tab'), 3):
            scripts = set(re.split('[:,]', row['scripts']))
            key = f'{section}:{line}'
            if 'systems.spawning.patrol_point_setup' in scripts:
                point_name = variables(row['objvars'])['pointName']
                assert point_name not in points, key
                points[point_name] = placement(row, area)
            elif scripts & {'npc.celebrity.celebrity_spawner', 'npc.celebrity.corpse_spawner'}:
                v = variables(row['objvars'])
                item = v['spawns']
                corpse = 'npc.celebrity.corpse_spawner' in scripts
                x, z, y = placement(row, area)
                actors.setdefault(item, []).append(dict(id=key, mobile=mobile(item), x=x,
                    z=z if corpse else z + .5, y=y, heading=heading(row),
                    corpse=corpse, name=v.get('npc_name', '')))
            elif scripts & {'systems.spawning.spawner_area', 'systems.spawning.spawner_patrol'}:
                v = variables(row['objvars'])
                kind = v['strSpawns']
                if kind not in types:
                    path = dt / f'spawning/ground_spawning/types/{kind}.tab'
                    entries = table(path)
                    types[kind] = [dict(item=r['strItem'], mobile=mobile(r['strItem']),
                        clearance=float(r['fltSize'])) for r in entries]
                    assert types[kind], path
                x, z, y = placement(row, area)
                c = dict(id=key, sourceID=int(row['objid']), name=v['strName'], type=kind,
                    x=x, z=z, y=y, heading=heading(row), radius=float(v['fltRadius']),
                    count=int(v['intSpawnCount']), respawnMin=float(v['fltMinSpawnTime']),
                    respawnMax=float(v['fltMaxSpawnTime']), behavior=int(v['intDefaultBehavior']),
                    findSpawnPoint=v['intGoodLocationSpawner'] == '1')
                if v['strSpawnerType'] == 'patrol':
                    assert c['behavior'] == 3 and not c['findSpawnPoint'], key
                    patrols.append((c, v['strPatrolPointNames'].strip(':').split(':')))
                    c['pathType'] = v['patrolPathType']
                else:
                    assert c['behavior'] in (0, 1, 2), key
                    controllers.append(c)
                assert c['count'] > 0 and 0 <= c['respawnMin'] <= c['respawnMax'], key

    used_points = set()
    for c, names in patrols:
        assert c['pathType'] in ('cycle', 'oscillate')
        c['points'] = [[c['x'], c['z'], c['y']]] + [points[name] for name in names]
        assert c['count'] < len(c['points']), c
        used_points.update(names)
    assert points.keys() - used_points == {'jedi_three_storm_lord_blistmok_02_11620645_7'}
    assert (len(controllers), sum(c['count'] for c in controllers)) == (178, 477)
    assert (len(patrols), sum(c['count'] for c, _ in patrols), len(points)) == (13, 23, 86)
    assert Counter(a['corpse'] for group in actors.values() for a in group) == {False: 7, True: 19}
    return controllers, [c for c, _ in patrols], actors, types


def read_lairs(server):
    dt = server / 'datatables'
    lairs, groups, regions = {}, {}, []
    for r in table(dt / 'region/region_mustafar.tab'):
        if r['spawnableType'] != 'spawnTrue':
            continue
        name = r['regionName'].split(':')[-1]
        groups[name] = []
        for entry in table(dt / f'spawning/spawn_lists/{ZONE}/{name}.tab'):
            assert entry['strTemplate'] == 'object/tangible/lair/npc_lair.iff'
            assert entry['intMinDifficulty'] == entry['intMaxDifficulty'] == '0'
            lair = entry['strLairType']
            if lair not in lairs:
                members = table(dt / f'npc_lair/{lair}.tab')
                assert all(not m.get(k) for m in members
                           for k in ('veryEasy', 'easy', 'medium', 'hard', 'veryHard'))
                counts = {m['mobiles']: int(m['spawnLimit']) for m in members}
                assert len(counts) == len(members) and all(n > 0 for n in counts.values())
                lairs[lair] = counts
            groups[name].append(dict(lairTemplateName=lair,
                spawnLimit=int(entry['intSpawnLimit']), minDifficulty=0, maxDifficulty=0,
                numberToSpawn=int(entry['intNumToSpawn'] or 0), weighting=int(entry['intWeighting']),
                size=int(entry['intSize'])))
        x, y, limit = (float(r[k]) for k in ('minX_or_centerX', 'minZ_or_centerZ', 'maxX_or_radius'))
        if r['geometry'] == 'circle':
            shape = [1, limit]
        else:
            assert r['geometry'] == 'rectangle'
            shape = [2, limit, float(r['maxZ'])]
        regions.append(f'\t{{"{name}", {x:.12g}, {y:.12g}, {lua(shape)}, SPAWNAREA, {{"mustafar_native_{name}"}}, 256}},')
    assert (len(regions), sum(len(rows) for rows in groups.values()), len(lairs)) == (34, 585, 156)
    return lairs, groups, regions


def make_profiles(server, identities, actors, lair_mobiles):
    dt = server / 'datatables'
    creatures = {r['creatureName']: r for r in table(dt / 'mob/creatures.tab')}
    dressed = {}
    for path in sorted((dt / 'npc_customization').glob('dressed_species_*.tab')):
        with path.open(encoding='utf-8-sig', newline='') as stream:
            columns, _, *entries = csv.reader(stream, delimiter='\t')
        for i, name in enumerate(columns):
            if name:
                dressed[name] = [r[i] for r in entries if len(r) > i and r[i]]

    som = SCRIPTS / 'mobile/custom_content/som'
    includes = (som / 'serverobjects.lua').read_text(encoding='utf-8')
    registered = {}
    for filename in re.findall(r'^includeFile\("custom_content/som/([^"]+)"\)', includes, re.M):
        source = (som / filename).read_text(encoding='utf-8', errors='replace')
        m = re.search(r'CreatureTemplates:addCreatureTemplate\((\w+),\s*"([^"]+)"', source)
        t = re.search(r'^\s*templates\s*=\s*\{([^}]+)', source, re.M)
        if m and t:
            registered[m[2]] = (m[1], re.findall(r'"object/mobile/([^"]+)"', t[1]))

    aliases = {}
    profiles = []
    for item in sorted(identities):
        creature = creatures[item]
        asset = creature['template']
        default = item if item in registered else item.removeprefix('som_')
        if item in lair_mobiles and default not in registered:
            default = PurePosixPath(asset).stem
        base = BASES.get(item, default)
        symbol, existing = registered[base]
        appearances = [asset] if asset.endswith('.iff') else dressed[asset]
        if len(appearances) == 1:
            # Stardust has two SOM mobiles under som/ which DSRC locates at the root.
            same = [p for p in existing if PurePosixPath(p).name == PurePosixPath(asset).name]
            if same:
                appearances = same
        if item == 'som_ruins_leader':
            # Stardust's loaded template for the DSRC ruins_patron role.
            appearances = existing
        corpse = item in actors and actors[item][0]['corpse']
        actor = item in actors
        scale = (float(creature['minScale'] or 1) + float(creature['maxScale'] or 1)) / 2
        fields = dict(templates=['object/mobile/' + a for a in appearances],
                      socialGroup=creature['socialGroup'], scale=scale)
        if item in NAMES:
            fields['customName'] = NAMES[item]
        if corpse:
            fields.update(customName=actors[item][0]['name'], conversationTemplate='')
        lines = ['', f'local profile = {symbol}:new {{']
        lines.extend('\t' + name + ' = ' + lua(value) + ',' for name, value in fields.items())
        if actor:
            flags = 'INVULNERABLE' if corpse else 'INVULNERABLE + CONVERSABLE'
            lines += ['\tpvpBitmask = NONE,', f'\toptionsBitmask = {flags},']
        lines += ['}', f'CreatureTemplates:addCreatureTemplate(profile, "{mobile(item)}")']
        profiles.extend(lines)
        aliases[mobile(item)] = base
    return profiles, aliases


def generate(root):
    server = root / 'sku.0/sys.server/compiled/game'
    shared = root / 'sku.0/sys.shared/compiled/game'
    controllers, patrols, actors, types = read_population(server, shared)
    lairs, groups, regions = read_lairs(server)
    lair_mobiles = {item for counts in lairs.values() for item in counts}
    identities = set(actors) | lair_mobiles | {e['item'] for entries in types.values() for e in entries}
    profiles, aliases = make_profiles(server, identities, actors, lair_mobiles)
    out = ['-- Generated by utils/mustafar/build_population.py.',
           'MustafarOverworldData = {', '\ttypes = {']
    for kind, entries in sorted(types.items()):
        out += [f'\t\t[{lua(kind)}] = {lua(entries)},']
    out += ['\t},', '\tactors = {']
    for name, entries in sorted(actors.items()):
        out += [f'\t\t{ name } = {{', *('\t\t\t' + lua(a) + ',' for a in entries), '\t\t},']
    out += ['\t},', '\tquestTemplates = {']
    out += [f'\t\t{name} = {lua(base)},' for name, base in aliases.items()]
    out += ['\t},']
    for name, entries in [('controllers', controllers), ('patrols', patrols)]:
        out += [f'\t{name} = {{', *('\t\t' + lua(c) + ',' for c in entries), '\t},']
    out += ['}', '']
    profile_header = ['-- Generated by utils/mustafar/build_population.py.',
        '-- DSRC identity, appearances and social groups. Combat stats and loot use Stardust templates.']
    lair_output = ['-- Generated by utils/mustafar/build_population.py from npc_lair and spawn_lists/mustafar.']
    for name, counts in sorted(lairs.items()):
        recipe = dict(mobiles=[[mobile(item), count] for item, count in counts.items()],
                      spawnLimit=sum(counts.values()), buildingType='none', cappedMobileCounts=True)
        lair_output.append(f'addLairTemplate("{name}", Lair:new {lua(recipe)})')
    for name, entries in sorted(groups.items()):
        lair_output += ['', f'addSpawnGroup("mustafar_native_{name}", {{', '\tlairSpawns = {']
        lair_output += ['\t\t' + lua(entry) + ',' for entry in entries]
        lair_output += ['\t}', '})']
    region_path = SCRIPTS / 'managers/planet/mustafar_regions.lua'
    header, marker, _ = region_path.read_text(encoding='utf-8').partition(
        '\t-- DSRC wildlife regions generated by utils/mustafar/build_population.py.')
    assert marker, region_path
    return {
        SCRIPTS / 'screenplays/mustafar/mustafar_overworld_data.lua': '\n'.join(out),
        SCRIPTS / 'mobile/custom_content/som/mustafar_overworld_profiles.lua': '\n'.join(profile_header + profiles) + '\n',
        SCRIPTS / 'mobile/lair/creature_dynamic/mustafar_native_lairs.lua': '\n'.join(lair_output) + '\n',
        region_path: header + marker + '\n' + '\n'.join(regions) + '\n}\n',
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dsrc', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    for path, text in generate(args.dsrc).items():
        if args.check:
            assert path.read_text(encoding='utf-8') == text, path
        else:
            path.write_text(text, encoding='utf-8', newline='\n')
        print(path.name)


if __name__ == '__main__':
    main()

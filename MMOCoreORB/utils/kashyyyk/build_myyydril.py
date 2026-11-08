"""Generate the Myyydril population and the matching loose native buildout."""
import argparse
import csv
import math
import re
import struct
import sys
from collections import Counter
from pathlib import Path, PurePosixPath

from build_rryatt_population import SCRIPTS, lua, table

REPO = SCRIPTS.parents[2]
sys.path.insert(0, str(REPO / 'client-assets/imperial_venator/source'))
from swg_asset import Archives, crc, descendants, form, chunk, nodes, string

ZONE = 'kashyyyk_pob_dungeons'
AREA = 'myyydril_caverns'
BUILDING = 'object/building/kashyyyk/thm_kash_myyydril_caverns.iff'
OUTPUT = REPO / 'client-assets/myyydril_caverns/loose'
REFUGEE_ALIAS = {'ep3_myyydril_refugee': 'ep3_myydril_refugee'}


def shared(path):
    path = PurePosixPath(path)
    return str(path.with_name('shared_' + path.name))


def datatable(columns, types, rows):
    fmt = {'f': '<f', 'i': '<i', 'h': '<I', 'b': '<i'}
    encoded = b''.join(string(value) if kind[0] == 's' else struct.pack(fmt[kind[0]], value)
                       for row in rows for kind, value in zip(types, row, strict=True))
    return form('DTII', form('0001', chunk('COLS', struct.pack('<I', len(columns)) + b''.join(map(string, columns))),
                             chunk('TYPE', b''.join(map(string, types))),
                             chunk('ROWS', struct.pack('<I', len(rows)) + encoded)))


def compile_source_table(path):
    with path.open() as stream:
        columns, types, *source = csv.reader(stream, delimiter='\t')
    # The downgraded client area table ends at eventRequired.
    assert columns[-1] == 'requiredLoadLevel'
    columns, types = columns[:-1], types[:-1]
    rows = []
    for row in source:
        fields = []
        for index, kind in enumerate(types):
            value = row[index] if index < len(row) else ''
            if kind != 's':
                value = value or (kind[2:-1] if '[' in kind else '0')
                value = float(value) if kind[0] == 'f' else int(value, 0)
            fields.append(value)
        rows.append(fields)
    return datatable(columns, types, rows)


def strip_legacy_caves(snapshot):
    names, = descendants(snapshot, 'OTNL')
    names = names[4:-1].decode('ascii').split('\0')
    removed = []

    def rewrite(blob):
        output = []
        for tag, data in nodes(blob):
            if tag == 'FORM' and data[:4] == b'NODE':
                node, = list(nodes(data[4:]))
                header, *_ = nodes(node[1][4:])
                assert header[0] == 'DATA'
                _, parent, template = struct.unpack_from('<3i', header[1])
                if parent == 0 and names[template] == shared(BUILDING):
                    removed.append(len(descendants(data[4:], 'DATA')))
                    continue
            output.append(form(data[:4].decode('ascii'), rewrite(data[4:])) if tag == 'FORM' else chunk(tag, data))
        return b''.join(output)

    result = rewrite(snapshot)
    assert not removed or removed == [80] * 10, removed
    return result


def conversation(source, name):
    text = source.read_text()
    start = text.index('public int OnStartNpcConversation(')
    end = text.index('public int OnNpcConversationResponse(', start)
    initial, screens, destinations = [], {}, {}

    def branches(text, pattern):
        for match in re.finditer(pattern + r'\s*\{', text, re.M):
            depth = 1
            for index in range(match.end(), len(text)):
                depth += (text[index] == '{') - (text[index] == '}')
                if depth == 0:
                    break
            body = text[match.end():index]
            message, = re.findall(r'string_id message = new string_id\(c_stringFile, "(s_\d+)"\)', body)
            responses = re.findall(r'responses\[responseIndex\+\+\] = new string_id\(c_stringFile, "(s_\d+)"\)', body)
            yield match[1], message, responses

    for response, message, responses in branches(text[:start], r'^        if \(response\.equals\("(s_\d+)"\)\)'):
        assert destinations.setdefault(response, message) == message, (name, response)
        assert screens.setdefault(message, responses) == responses, (name, message)
    for condition, message, responses in branches(text[start:end],
                                                    rf'^        if \({name}_condition_(\w+)\(player, npc\)\)'):
        initial.append([condition, message])
        assert screens.setdefault(message, responses) == responses, (name, message)
    assert initial and initial[-1][0] == '_defaultCondition', name
    prefix = '@conversation/' + name + ':'
    output = []
    for message, responses in screens.items():
        options = [[prefix + response, destinations[response]] for response in responses]
        output.append([message, prefix + message, options])
    return initial, output


def generate(dsrc):
    server = dsrc / 'sku.0/sys.server/compiled/game'
    client = dsrc / 'sku.0/sys.shared/compiled/game'
    dt = server / 'datatables'
    area_path = client / f'datatables/buildout/areas_{ZONE}.tab'
    source_areas = table(area_path)
    scenes = table(client / 'datatables/buildout/buildout_scenes.tab')
    assert scenes[4]['sceneName'] == ZONE
    areas = [i for i, row in enumerate(source_areas) if row['area'] == AREA]
    assert areas == list(range(20, 30)), areas
    copies = [-30000 * (4 * 100 + i + 1) for i in areas]
    source_buildout = table(dt / f'buildout/{ZONE}/{AREA}.tab')
    assert len(source_buildout) == 80 and source_buildout[0]['server_template_crc'] == BUILDING
    buildout = []
    for cell, row in enumerate(source_buildout):
        assert int(row['cell_index']) == cell
        assert cell == 0 or row['server_template_crc'] == 'object/cell/cell.iff'
        layout = re.search(r'portalProperty\.crc\|0\|(-?\d+)\|', row.get('objvars', ''))
        transform = [float(row[k]) for k in ('px', 'py', 'pz', 'qw', 'qx', 'qy', 'qz')]
        buildout.append([crc(shared(row['server_template_crc'])), cell, *transform,
                         int(layout[1]) & 0xffffffff if layout else 0, 1024.0 if cell == 0 else 0.0])

    rows, row_conversations = [], {}
    source_rows = table(dt / 'spawning/dungeon/ep3_myyydril_caverns.tab')
    for line, row in enumerate(source_rows, 3):
        item = REFUGEE_ALIAS.get(row['spawns'], row['spawns'])
        is_object = item.endswith('.iff')
        assert not row.get('name') and not row.get('mood')
        assert not row.get('spawn_objvar') or row['spawn_objvar'] == 'string:zoneLine=myyydril_deadforest'
        for script in row.get('script', '').split(','):
            if script.startswith('conversation.'):
                assert item not in row_conversations or row_conversations[item] == script
                row_conversations[item] = script
        respawn = (int(row.get('respawn_time') or 0) or 30) if row.get('script') == 'theme_park.dungeon.generic_death' else 0
        mobile = 'myyydril_' + item
        rows.append([line, item if is_object else mobile, row['room'],
                     *[float(row[k]) for k in ('loc_x', 'loc_y', 'loc_z', 'yaw')], -1 if is_object else respawn])
    assert Counter(row[-1] < 0 for row in rows) == {False: 352, True: 565}
    result = {SCRIPTS / 'screenplays/kashyyyk/myyydril_data.lua': (
        '-- Generated from DSRC. Rows are source line, template, cell, x, height, y, heading, respawn.\n'
        'MyyydrilData = {\n\tcopies = ' + lua(copies) + ',\n\trows = {\n' +
        ''.join('\t\t' + lua(row) + ',\n' for row in rows) + '\t},\n}\n')}

    identities = {REFUGEE_ALIAS.get(row['spawns'], row['spawns']) for row in source_rows
                  if not row['spawns'].endswith('.iff')}
    identities.update(('ep3_general_grievous', 'ep3_myyydril_nk3'))
    creature_table = {r['creatureName']: r for r in table(dt / 'mob/creatures.tab')}
    dressed = {}
    for path in sorted((dt / 'npc_customization').glob('dressed_species_*.tab')):
        with path.open() as stream:
            columns, _, *entries = csv.reader(stream, delimiter='\t')
        for i, key in enumerate(columns):
            if key:
                dressed[key] = [row[i] for row in entries if len(row) > i and row[i]]
    stats = table(dt / 'mob/stat_balance.tab')
    active_mobile = SCRIPTS / 'mobile/custom_content/mobile'
    includes = (active_mobile / 'serverobjects.lua').read_text()
    old_profiles = {path.stem for path in active_mobile.glob('*.lua')
                    if f'"custom_content/mobile/{path.name}"' in includes}
    lines = ['-- Generated from DSRC creature and dressed-species tables.', 'local profiles = {']
    dialogue = []
    for item in sorted(identities):
        r = creature_table[item]
        template = r['template']
        apps = [template] if template.endswith('.iff') else dressed[template]
        first = Path(apps[0]).stem
        base = next((name for name in (item, first) if name in old_profiles), 'Creature')
        convo = row_conversations.get(item) or next(
            (s for s in (r['scripts'] or '').split(',') if s.startswith('conversation.')), '')
        display = '@droid_name:b_surgical_droid_base' if item == 'clone_droid' else '@mob/creature_names:' + item
        if convo:
            convo = convo.removeprefix('conversation.')
            path = server / 'script/conversation' / f'{convo}.java'
            source = path.read_text()
            names = set(re.findall(r'setName\(self, new string_id\("([^"]+)", "([^"]+)"\)\)', source))
            assert len(names) <= 1, (item, names)
            if names:
                display = '@' + ':'.join(next(iter(names)))
            if not (SCRIPTS / f'mobile/conversations/kashyyyk/myyydril/{convo}_convo.lua').is_file():
                dialogue.append((convo, *conversation(path, convo)))
        level = int(r['BaseLevel'])
        cls = {'NORMAL': '', 'ELITE': 'Elite_', 'BOSS': 'Boss_'}[r['difficultyClass']]

        def stat(modifier, column):
            return float(stats[max(1, level + int(r[modifier] or 0)) - 1][cls + column])

        hp = stat('StatLevelModifier', 'HP')
        damage = stat('Damagelevelmodifier', 'damagePerSecond') * float(r['primary_weapon_speed'] or 2)
        radius = int(r['aggressive'] or 0)
        invulnerable = r['invulnerable'] == '1' or item == 'clone_droid'
        fields = dict(objectName=display, customName='', conversationTemplate=convo + '_convo' if convo else '',
                      socialGroup=r['socialGroup'], faction=r['pvpFaction'], aggroRadius=radius,
                      templates=['object/mobile/' + a for a in apps], level=level, baseHAM=int(hp * .9),
                      baseHAMmax=int(hp * 1.1), damageMin=math.floor(damage * .5 + .5),
                      damageMax=math.floor(damage * 1.5 + .5), chanceHit=stat('ToHitLevelModifier', 'ToHit') / 100,
                      baseXp=int(stats[level - 1]['XP']), scale=(float(r['minScale'] or 1) + float(r['maxScale'] or 1)) / 2)
        if item == 'ep3_general_grievous':
            fields['lootGroups'] = []
        elif r['lootList'] and (SCRIPTS / 'loot/groups/kashyyyk' / (r['lootList'] + '.lua')).is_file():
            fields['lootGroups'] = [dict(groups=[dict(group=r['lootList'], chance=10000000)], lootChance=10000000)]
        options = 'AIENABLED' + (' + INVULNERABLE' if invulnerable else '') + (' + CONVERSABLE + INTERESTING' if convo else '')
        flags = 'NONE' if invulnerable else 'ATTACKABLE' + (' + AGGRESSIVE + ENEMY' if radius else '')
        traits = ' + '.join(flag for flag, key in [('STALKER', 'stalker'), ('KILLER', 'death_blow')]
                            if not invulnerable and r[key] in ('1', 'yes', 'instant')) or 'NONE'
        lines.append(f'\t{{{base}, "myyydril_{item}", ' + lua(fields)[:-1] + f', randomNameType = NAME_TAG, '
                     f'pvpBitmask = {flags}, optionsBitmask = {options}, creatureBitmask = {traits}}}}},')
    lines += ['}', '', 'for _, profile in ipairs(profiles) do',
              '\tCreatureTemplates:addCreatureTemplate(profile[1]:new(profile[3]), profile[2])', 'end', '']
    result[SCRIPTS / 'mobile/custom_content/myyydril_profiles.lua'] = '\n'.join(lines)
    assert len(dialogue) == 10
    header = '-- Generated from the corresponding DSRC conversation scripts.\n'
    result[SCRIPTS / 'screenplays/kashyyyk/myyydril_dialogue_data.lua'] = header + (
        'MyyydrilDialogue = {\n' +
        ''.join('\t' + name + ' = ' + lua(initial) + ',\n' for name, initial, _ in dialogue) + '}\n')
    result[SCRIPTS / 'mobile/conversations/kashyyyk/myyydril/source_conversations.lua'] = header + (
        'local conversations = {\n' +
        ''.join('\t' + name + ' = {\n' + ''.join('\t\t' + lua(row) + ',\n' for row in screens) +
                '\t},\n' for name, _, screens in dialogue) +
        '}\n\nfor name, rows in pairs(conversations) do\n'
        '\tlocal template = ConvoTemplate:new {initialScreen = "", templateType = "Lua", luaClassHandler = name .. "_conv_handler", screens = {}}\n'
        '\tfor _, row in ipairs(rows) do\n'
        '\t\ttemplate:addScreen(ConvoScreen:new {id = row[1], leftDialog = row[2], '
        'stopConversation = #row[3] == 0 and "true" or "false", options = row[3]})\n'
        '\tend\n\taddConversationTemplate(name .. "_convo", template)\nend\n')
    result[OUTPUT / f'datatables/buildout/{ZONE}/{AREA}.iff'] = datatable(
        ['shared_template_crc', 'cell_index', 'px', 'py', 'pz', 'qw', 'qx', 'qy', 'qz', 'portal_layout_crc', 'radius'],
        'hifffffffhf', buildout)
    result[OUTPUT / f'datatables/buildout/areas_{ZONE}.iff'] = compile_source_table(area_path)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dsrc', type=Path)
    parser.add_argument('--config', type=Path, help='Read the existing client snapshot from this archive config')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    files = generate(args.dsrc)
    if args.config:
        path = f'snapshot/{ZONE}.ws'
        files[OUTPUT / path] = strip_legacy_caves(Archives(args.config).get(path))
    for path, data in files.items():
        encoded = data.encode() if isinstance(data, str) else data
        if args.check:
            assert path.read_bytes() == encoded, path
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(encoded)

# ROUND H(f) PART 2 SPEC — widen the three trophy loot pools to live

Do not commit. Do not run git. Only touch the files listed under "Files to change".

## What this fixes

The three Mustafar bounty-hunt species drop ONE item each today: the trophy, at
12.5%. Live drops one item on EVERY kill, and the trophy is 12.5% of those. The
other 87.5% of live's drops were never ported. This transcribes them.

Live mechanism, already verified, do not re-derive:

```
datatables/mob/creatures.tab
  som_blistmok / som_tulrus / som_xandank : intLootRolls=1, intRollPercent=100
  -> exactly one item per kill, always.

datatables/loot/loot_types/mustafar/mustafar_<species>.tab  -- 2 rows, uniform pick
  mustafar/<species>      50%
  mustafar/creature       50%

datatables/loot/loot_items/mustafar/<species>.tab  -- 4 rows, uniform pick, 25% each
datatables/loot/loot_items/mustafar/creature.tab   -- 5 rows, uniform pick, 20% each
```

So the trophy stays at 0.50 * 0.25 = 12.5%, exactly what it is today. Nothing
about the bounty hunt changes. What changes is that the other 7 outcomes per
species now exist instead of being nothing.

Engine rules that constrain the numbers (`MMOCoreORB/src/tests/LuaMobileTest.cpp`):

- `:441` a creature's `groups` chances must total exactly 10000000.
- `:713-714` a loot group's item weights must total exactly 10000000.
- `LootGroupMap.cpp:81,97` the registered template name must equal the file
  basename, or the server warns.

## Files to change

### A. Fourteen NEW loot items in `MMOCoreORB/bin/scripts/loot/items/mustafar/`

One file per item, filename = template name = the live `master_item.tab` key
(or the cube's object basename, which is the convention the existing
`cube_loot_*.lua` files in this folder already use).

Copy the exact body shape from the existing
`MMOCoreORB/bin/scripts/loot/items/mustafar/cube_loot_3j.lua` and
`item_tow_factory_gaurd_trinket_04_01.lua` -- same fields, same order, same
`addLootItemTemplate` call at the bottom. Use `minimumLevel = 0`,
`maximumLevel = -1`, empty `craftingValues`, `customizationStringNames`,
`customizationValues`.

| filename (no .lua) | directObjectTemplate | customObjectName |
| --- | --- | --- |
| `item_tow_junk_creature_eye_02_01` | `object/tangible/loot/creature/loot/generic/generic_eye.iff` | `a blistmok eyeball` |
| `item_tow_junk_creature_horn_02_01` | `object/tangible/loot/creature/loot/generic/generic_horn.iff` | `a tulrus horn` |
| `item_tow_junk_creature_jaw_02_01` | `object/tangible/loot/creature_loot/generic/carnivore_tooth.iff` | `a xandank jaw` |
| `item_tow_junk_creature_brain_02_01` | `object/tangible/loot/creature/loot/generic/generic_brain.iff` | `a Mustafarian creature brain` |
| `item_tow_junk_creature_bone_02_01` | `object/tangible/loot/creature/loot/generic/humanoid_arm_bone.iff` | `a Mustafarian creature bone` |
| `item_tow_junk_creature_intestines_02_01` | `object/tangible/loot/creature/loot/generic/generic_stomach.iff` | `Mustafarian creature intestines` |
| `item_tow_junk_creature_hide_02_01` | `object/tangible/loot/creature/loot/generic/generic_hide.iff` | `a patch of tough hide` |
| `item_tow_junk_creature_blood_02_01` | `object/tangible/loot/npc/loot/serum_vial_generic.iff` | `a bottle of Mustafarian creature blood` |
| `cube_loot_1y` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1y.iff` | (empty string) |
| `cube_loot_1f` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1f.iff` | (empty string) |
| `cube_loot_1g` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1g.iff` | (empty string) |
| `cube_loot_1p` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1p.iff` | (empty string) |
| `cube_loot_1o` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1o.iff` | (empty string) |
| `cube_loot_1x` | `object/tangible/loot/mustafar/cube/loot/cube_loot_1x.iff` | (empty string) |

**COPY THE PATHS EXACTLY FROM THE TABLE.** They are not uniform and you must not
"tidy" them:

- Live writes `creature_loot/generic/` and `npc_loot/`. This repo registers most
  of those objects at the split paths `creature/loot/generic/` and `npc/loot/`.
  That split is a pre-existing upstream defect and it is self-consistent -- the
  object template registers the split path too, so it resolves. Match the repo,
  not live.
- `carnivore_tooth.iff` is the exception: it is registered at the UNSPLIT live
  path `creature_loot/generic/`. One row in this table differs from its
  neighbours on purpose. Do not "fix" it either way.
- The cubes use `mustafar/cube/loot/`, the same split, same reason.

Every one of these 19 paths was checked against the object include closure with
Lua comments stripped, and all 19 are registered. Do not change any of them.

Each file gets a two or three line header comment in the same voice as the
existing files in that folder, naming the live `master_item.tab` key it
transcribes, which live pool table it comes from
(`loot_items/mustafar/<blistmok|tulrus|xandank|creature>.tab`), and -- only for
the ones that use a split path -- one short sentence that the split path is
deliberate and matches the repo's own registration. Live's `string_detail` text
has nowhere to go in this schema; do not invent a field for it.

### B. One NEW loot group

`MMOCoreORB/bin/scripts/loot/groups/mustafar/som_mustafar_creature.lua`

Transcribes `datatables/loot/loot_items/mustafar/creature.tab`, the shared
second pool all three species roll against. Five items, uniform, so
`weight = 2000000` each, totalling 10000000:

```
item_tow_junk_creature_brain_02_01
item_tow_junk_creature_bone_02_01
item_tow_junk_creature_intestines_02_01
item_tow_junk_creature_hide_02_01
item_tow_junk_creature_blood_02_01
```

Match the shape of the existing
`MMOCoreORB/bin/scripts/loot/groups/mustafar/devistator_loot.lua`, including its
header-comment style. `description = ""`, `minimumLevel = 0`,
`maximumLevel = -1`.

### C. Widen the three existing trophy groups, IN PLACE

These three files stay where they are. Do not move them, do not delete them,
do not create copies elsewhere.

- `MMOCoreORB/bin/scripts/custom_scripts/loot/groups/som_blistmok_trophy.lua`
- `MMOCoreORB/bin/scripts/custom_scripts/loot/groups/som_tulrus_trophy.lua`
- `MMOCoreORB/bin/scripts/custom_scripts/loot/groups/som_xandank_trophy.lua`

Each goes from one item at `weight = 10000000` to four items at
`weight = 2500000` each:

| group | items (weight 2500000 each) |
| --- | --- |
| `som_blistmok_trophy` | `item_tow_junk_creature_eye_02_01`, `blistmok_heart`, `cube_loot_1y`, `cube_loot_1f` |
| `som_tulrus_trophy` | `item_tow_junk_creature_horn_02_01`, `tulrus_parts`, `cube_loot_1g`, `cube_loot_1p` |
| `som_xandank_trophy` | `item_tow_junk_creature_jaw_02_01`, `xandank_jaw`, `cube_loot_1o`, `cube_loot_1x` |

List them in the live table's row order, which is the order given above. Add a
header comment to each naming the live table it now transcribes in full
(`loot_items/mustafar/<species>.tab`) and saying that the trophy's own rate is
unchanged at 12.5% because the widening happens on both sides of the multiply.

### D. Point the three creatures at both pools

- `MMOCoreORB/bin/scripts/mobile/custom_content/som/blistmok.lua`
- `MMOCoreORB/bin/scripts/mobile/custom_content/som/tulrus.lua`
- `MMOCoreORB/bin/scripts/mobile/custom_content/som/xandank.lua`

Each currently has:

```lua
	lootGroups = {
		{
			groups = {
				{group = "som_<species>_trophy", chance = 10000000}
			},
			lootChance = 1250000
		}
	},
```

Replace with:

```lua
	lootGroups = {
		{
			groups = {
				{group = "som_<species>_trophy", chance = 5000000},
				{group = "som_mustafar_creature", chance = 5000000}
			},
			lootChance = 10000000
		}
	},
```

Chances total 10000000, as `LuaMobileTest.cpp:441` requires.

Add a short comment directly above `lootGroups` in each of the three files
explaining, in plain sentences: live rolls once at 100% and then picks one of
two pools evenly, so the creature drops something on every kill; the trophy is
one of four in its own pool, so it is still 12.5% per kill, the same rate the
previous encoding produced; and the old `lootChance = 1250000` was that 12.5%
collapsed onto the roll itself, which delivered the trophy at the right rate but
dropped nothing the other 87.5% of the time.

Do not change anything else in these three creature files.

### E. Register the new files

- `MMOCoreORB/bin/scripts/loot/items.lua` -- add fourteen `includeFile` lines to
  the existing `-- mustafar sub-folder` block, in the alphabetical order that
  block already uses. Read the block and place each line correctly; do not
  append them at the end.
- `MMOCoreORB/bin/scripts/loot/groups.lua` -- add one `includeFile` line for
  `groups/mustafar/som_mustafar_creature.lua` to its `-- mustafar sub-folder`
  block, again in alphabetical position.

## Constraints

- **ASCII only.** No smart quotes, no em dashes, no curly apostrophes. Use `--`
  for a dash. This is enforced by a gate and a non-ASCII byte will fail the
  round.
- Tabs vs spaces: match the surrounding file exactly. The existing loot files
  use tabs for indentation inside the table.
- Do not touch any file not named above.
- Do not delete anything.
- Do not change the three trophy items that already exist (`blistmok_heart`,
  `tulrus_parts`, `xandank_jaw`) or their files under
  `custom_scripts/loot/items/`.

## When you are done

Print:
1. the list of files you created,
2. the full contents of `som_mustafar_creature.lua` and
   `som_blistmok_trophy.lua`,
3. the new `lootGroups` block from `blistmok.lua`,
4. the lines you added to `items.lua` and `groups.lua` with their line numbers.

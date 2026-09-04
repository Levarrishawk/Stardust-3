# ROUND H(c) — uplink cave content, the relay template, and four stale in-tree comments

Repo root for every path below: `C:\stardust-3-space-port\server`
Script root: `MMOCoreORB/bin/scripts`

## HARD RULES

1. **Do not run git. Do not commit.** Leave everything in the working tree.
2. **ASCII ONLY.** No em-dashes, no smart quotes, no accented characters, anywhere in any file
   you touch. Use `--` for a dash and `'` for an apostrophe.
3. **Tabs for indentation** inside Lua table bodies and function bodies, matching each file's
   existing style. `mustafar_dungeon_population.lua` uses tabs in code and spaces inside `--[[ ]]`
   comment blocks. Match what is already there, line for line.
4. Do not touch any file not named in this spec. In particular do NOT touch
   `obi_wan_ghost.lua`, `surveyor_jo.lua`, `jo_kelsev_conv_handler.lua`, or any
   `serverobjects.lua` other than `mobile/custom_content/som/serverobjects.lua`.
5. Every number in this spec is quoted from a live source file. Do not round, adjust, or
   "improve" a coordinate. If something looks wrong, leave it and note it -- do not invent.

---

## THE SOURCE TABLE

`_dsrc-full/sku.0/sys.server/compiled/game/datatables/dungeon/mustafar_trials/link_establish/link_event_data.tab`

Columns: `object  stage  locx  locy  locz  yaw  script  wp_name  path`

**AXIS MAPPING -- get this right.** Live `locy` is HEIGHT. This repo's argument order is
`x, z, y` where `z` is height. So:

    repo x  <-  locx
    repo z  <-  locy   (height)
    repo y  <-  locz

This is the same mapping already written out at `mustafar_dungeon_population.lua:25-37`.
`spawnMobile` takes heading in DEGREES. `spawnSceneObject` takes it in RADIANS and takes the
cell id BEFORE the heading. `MustafarDungeonPopulation:spawnProp` already does that conversion.

The cell is `mainroom` -- `trial.java:126` `UPLINK_ROOM = "mainroom"`, and that is also the only
cell `som_uplink_cave.ilf` has.

The 28-line table, verbatim (blank yaw means the column was empty):

| line | object | stage | locx | locy | locz | yaw | script / wp_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3  | patrol_waypoint.iff | 2 | -81 | 0 | 128 | | droid_spawner, path of 11 wp names |
| 4  | patrol_waypoint.iff | 1 | -105 | -1 | 124 | | firstCorner |
| 5  | patrol_waypoint.iff | 1 | -106 | -2 | 79 | | secondCorner |
| 6  | patrol_waypoint.iff | 1 | -78 | -2 | 71 | | oppositeSide |
| 7  | patrol_waypoint.iff | 1 | -56 | 0 | 40 | | firstSpawn |
| 8  | patrol_waypoint.iff | 1 | -70 | -1 | 0 | | tSection |
| 9  | patrol_waypoint.iff | 1 | -54 | -1 | -30 | | firstLegBend |
| 10 | patrol_waypoint.iff | 1 | -8 | -2 | -1 | | firstRelay |
| 11 | patrol_waypoint.iff | 1 | -82 | 0 | -5 | | secondLegBend |
| 12 | patrol_waypoint.iff | 1 | -99 | -3 | -45 | | secondSpawn |
| 13 | patrol_waypoint.iff | 1 | -101 | -2 | -73 | | finalEncounter |
| 14 | patrol_waypoint.iff | 1 | -102 | -3 | -26 | | finalRelay |
| 15 | **beetle_lair.iff** | 1 | -100 | -6 | 37 | | bug_spawner |
| 16 | **beetle_lair.iff** | 1 | -71 | -1 | -1 | | bug_spawner |
| 17 | **beetle_lair.iff** | 1 | -36 | -3 | -27 | | bug_spawner |
| 18 | **beetle_lair.iff** | 1 | -93 | -3 | -44 | | bug_spawner |
| 19 | patrol_waypoint.iff | 1 | -61 | 0 | 77 | | random1 |
| 20 | patrol_waypoint.iff | 1 | -62 | -1 | 124 | | random2 |
| 21 | patrol_waypoint.iff | 1 | -64 | -4 | 11 | | random3 |
| 22 | patrol_waypoint.iff | 1 | -106 | -6 | 32 | | random4 |
| 23 | patrol_waypoint.iff | 3 | -58 | -5 | 11 | | **foreman_spawner** |
| 24 | patrol_waypoint.iff | 3 | -74 | 0 | 75 | | **foreman_drone_spawner** |
| 25 | patrol_waypoint.iff | 3 | -6 | -1 | 0 | | **foreman_drone_spawner** |
| 26 | patrol_waypoint.iff | 3 | -102 | 0 | -87 | | **foreman_drone_spawner** |
| 27 | must_uplink_bunker_entrance.iff | 1 | -90 | 0 | 117 | 4 | (no script) |
| 28 | **exit_door.iff** | 1 | -90 | 0 | 117 | 4 | exit_door |

**Rows 3-14 and 19-22 place nothing.** `object/tangible/ground_spawning/patrol_waypoint.iff` is
not a registered server template anywhere in this tree (checked by grep across `object/`; zero
hits). This tree already made exactly this call at `battlefields/valley_battlefield.lua:96-100`,
which uses a pure coordinate rather than inventing a marker prop. Same call here.

**Row 27 places nothing.** It is a building shell (`object/building/...`), and the cave's copies
are already instantiated by `mustafar_instances.lua`. Spawning a building inside a cell would
create a second set of cells inside the first.

---

## TASK 1 -- three new creature templates

Create three files in `MMOCoreORB/bin/scripts/mobile/custom_content/som/`.

### Where the numbers come from

Live row, `_dsrc-full/.../datatables/mob/creatures.tab`:

```
som_link_lava_beetle_defender  BaseLevel 80  Damagelevelmodifier 4  difficultyClass ELITE
  where mustafar  socialGroup link_beetle  template som/kubaza_beetle.iff
  minScale 1.5  maxScale 1.5  hue 1  armorStun -1 (all other armour 0)  attackSpeed 2
  hasResources 1  meat 16 meat_insect  hide 24 hide_scaley  geneProfile defaultProfile
  intLootRolls 1  intRollPercent 80  (lootTable BLANK)  niche carnivore
  rootImmune 75  snareImmune 75  primary_weapon_specials roach_5  aggressive 9  assist 8

som_link_lava_beetle_drone  BaseLevel 80  Damagelevelmodifier 0  difficultyClass NORMAL
  where mustafar  socialGroup link_beetle  template som/kubaza_beetle.iff
  minScale 0.9  maxScale 0.9  hue 1  armorStun -1 (all other armour 0)  attackSpeed 2
  hasResources 1  meat 16 meat_insect  hide 24 hide_scaley  geneProfile defaultProfile
  niche carnivore  primary_weapon_specials roach_5  aggressive 0  assist 2
  death_blow instant

som_link_lava_beetle_worker  BaseLevel 80  Damagelevelmodifier 0  difficultyClass NORMAL
  where mustafar  socialGroup link_beetle  template som/kubaza_beetle.iff
  minScale 1.1  maxScale 1.1  hue 1  armorStun -1 (all other armour 0)  attackSpeed 2
  hasResources 1  meat 16 meat_insect  hide 24 hide_scaley  geneProfile defaultProfile
  niche carnivore  primary_weapon_specials roach_5  aggressive 0  assist 6
```

**Tier assignment, and it is precedent not invention.** The retune ladder is
`scratch/MUSTAFAR-GAPS.md:1761`. `MUSTAFAR-GAPS.md:1946-1964` records that mapping live's
three-valued `difficultyClass` onto the eight-rung ladder is a per-encounter judgement, and that
the valley battlefield's judgement was live ELITE -> 85 and live BOSS -> 120. The valley's live
rows confirm it: `som_battlefield_droid_soldier` and `som_battlefield_elite_guard` are live ELITE
and ship at `level = 85`; `som_battlefield_miner` and `som_battlefield_foreman_koseyet` are live
NORMAL and ship at `level = 70`. `som_link_lava_beetle_foreman` already took live BOSS -> 120 on
that same reading. So this cave uses the same band:

- live **ELITE** -> ladder **ELITE 85**
- live **NORMAL** -> ladder **STD 70**

Ladder rows, copied exactly:

| tier | level | chanceHit | damageMin | damageMax | baseXp | baseHAM | baseHAMmax | armor |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| STD   | 70 | 0.65 | 430 | 570 | 6747 | 12000 | 15000 | 0 |
| ELITE | 85 | 0.75 | 555 | 820 | 8130 | 12000 | 15000 | 1 |

**Resists: `R_BASE` = `{0,0,0,0,0,0,0,-1,-1}`** (`mobile/thug/thug.lua:16`). There is no tier
override for STD or ELITE -- only BOSS/APEX and RAID have one. R_BASE also happens to match live
exactly: all seven armour columns 0, `armorStun` -1.

**Loot: `lootGroups = {}` on all three.** `datatables/loot/master_loot.tab` has NO row for any
link beetle -- grep for `som_link` returns nothing, and all three rows leave `lootTable` blank.
(`som_link_lava_beetle_foreman` is the only one of the family with a live loot row:
`master_loot.tab:614` `mustafar_trial_foreman | ...:kubaza_foreman | 10000`.)

**Attacks.** Copy the pairing `som_link_lava_beetle_foreman.lua` already established, and say why
in the header. All three live rows carry `primary_weapon_specials roach_5`, the same AI profile
the foreman has. The foreman's header records that roach_5 (`ai_combat_profiles.tab:257`) is
`bm_bolster_armor_5` (once) + `bm_bite_5` + `bm_enfeeble_5` x2, that `bm_enfeeble_5` maps to
Core3's `intimidationattack`, that `bm_bite_5` has no Core3 analogue so the shipped kubaza
family's `creatureareaattack` (`kubaza_beetle.lua:35`) stands in, and that `bm_bolster_armor_5` is
dropped. Same profile, same mapping:

- defender: `primaryAttacks = { {"intimidationattack",""}, {"creatureareaattack",""} }`
- drone and worker: `primaryAttacks = { {"creatureareaattack",""} }` -- these two are the trash
  tier (live `Damagelevelmodifier 0`, `aggressive 0`); giving them the debuff is not warranted,
  and `creatureareaattack` alone is what the shipped `kubaza_beetle.lua` uses. **Disclose this
  as OURS, not sourced** -- live gives all three the same roach_5 profile.

**Bitmasks.**
- defender: `pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY` (live aggressive 9 / assist 8),
  `creatureBitmask = PACK` (live blanks `death_blow`; PACK because foreman_spawner calls
  `ai_lib.establishAgroLink` on the four of them -- disclose PACK as the port's stand-in for that
  binding, which Core3 does not have; the same reasoning is already written at
  `valley_battlefield.lua:105-108`).
- drone: `pvpBitmask = ATTACKABLE` (live aggressive 0), `creatureBitmask = KILLER`
  (live `death_blow instant`).
- worker: `pvpBitmask = ATTACKABLE` (live aggressive 0), `creatureBitmask = NONE`
  (live blanks `death_blow`).

**Common fields for all three:**

```
	socialGroup = "link_beetle",
	faction = "",
	mobType = MOB_CARNIVORE,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_insect",
	meatAmount = 16,
	hideType = "hide_scaley",
	hideAmount = 24,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	templates = {"object/mobile/som/kubaza_beetle.iff"},
	hues = { 1 },
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	secondaryAttacks = { }
```

`tamingChance = 0` -- live gives no taming data on these rows, and the shipped
`kubaza_beetle.lua` value of 0.25 is the ordinary open-world family, not this one. Same call the
foreman header already records.

`customName` -- authored English, matching the foreman's `"a Kubaza Beetle Foreman"` voice:
- defender: `"a Kubaza Beetle Defender"`
- drone: `"a Kubaza Beetle Drone"`
- worker: `"a Kubaza Beetle Worker"`

`scale` -- live minScale/maxScale: defender `1.5`, drone `0.9`, worker `1.1`.

### File shape

Follow `som_link_lava_beetle_foreman.lua` exactly: a `--[[ ]]` header that opens with the live
`creatures.tab` row read out in full, then a `TIER:` paragraph, then `SOURCED:` and `OURS, NOT
SOURCED:` sections, then the `Creature:new {}` body, then the
`CreatureTemplates:addCreatureTemplate(...)` call. Read that file before writing these.

### Register them

`mobile/custom_content/som/serverobjects.lua` -- the list is alphabetical. Insert three lines
immediately BEFORE the existing line 165 `includeFile("custom_content/som/som_link_lava_beetle_foreman.lua")`:

```
includeFile("custom_content/som/som_link_lava_beetle_defender.lua")
includeFile("custom_content/som/som_link_lava_beetle_drone.lua")
```

and immediately AFTER it:

```
includeFile("custom_content/som/som_link_lava_beetle_worker.lua")
```

(`defender` and `drone` sort before `foreman`; `worker` sorts after. Verify against the
surrounding lines before you write -- do not disturb the ordering.)

### Two templates deliberately NOT created

Write this into the header of `mustafar_dungeon_population.lua`'s new uplink block (Task 2), not
into a template file:

- `som_link_lava_beetle_soldier` -- live spawns it only from `soldier_spawner.java`, which
  `bug_spawner.java:33` attaches to a marker created in `OnDestroy` when a lair is destroyed. It
  has no row in `link_event_data.tab`. Nothing here would place it.
- `som_link_relay_droid` -- live spawns it from `droid_spawner.java`, attached to the single
  stage-2 row (line 3), whose `path` column drives an eleven-waypoint escort. That is the trial's
  event system, not a static population, and this port has no stage machine to walk the path.

---

## TASK 2 -- place the uplink cave, in `screenplays/mustafar/mustafar_dungeon_population.lua`

### 2a. Move the foreman out of `lairBosses`

Delete the `uplink_cave` entry from the `lairBosses` table (currently lines 555-572, the
`--[[ Foreman. ... ]]` comment plus the four-field entry). `lairBosses` keeps its other three
entries -- `monster_lair` / sher_kar, and the two `working_droid_factory` ones -- unchanged.

Reason to write into the new block: the foreman and its four guards come out of ONE live script
(`foreman_spawner.java:39-70`), and splitting them across two tables in this file would hide that.
Carry the substance of the deleted comment forward into the new block's header; do not lose the
`.ilf` corroboration it records (cave footprint x -200.8..8.6, z -108.5..178.2; nearest fixture a
`must_jeditemple_wall_long` 13.8 m away; local ground band h -4.2 to -7.7, which brackets live's
-5).

### 2b. Add the data

Add a new field on the `MustafarDungeonPopulation` table, after `lairBosses` and before the
`spawnedCount` counters. Name it `uplinkCave`. Shape:

```lua
uplinkCave = {
	poolKey = "uplink_cave",
	label = "Uplink Cave",
	table = "dungeon/mustafar_trials/link_establish/link_event_data.tab",
	cell = "mainroom",

	-- { template, x, z, y, heading }   z is HEIGHT, heading is DEGREES
	creatures = {
		...
	},

	-- { template, x, z, y, yaw }       z is HEIGHT, yaw is DEGREES (spawnProp converts)
	props = {
		...
	},
},
```

**Creature rows, in this order:**

| template | x | z | y | heading | source |
| --- | --- | --- | --- | --- | --- |
| som_link_lava_beetle_foreman | -58 | -5 | 11 | 0 | table line 23, `foreman_spawner` |
| som_link_lava_beetle_defender | -68 | -5 | 1 | 0 | offSet "-10:-10" |
| som_link_lava_beetle_defender | -68 | -5 | 21 | 0 | offSet "-10:10" |
| som_link_lava_beetle_defender | -48 | -5 | 1 | 0 | offSet "10:-10" |
| som_link_lava_beetle_defender | -48 | -5 | 21 | 0 | offSet "10:10" |
| som_link_lava_beetle_drone | -74 | 0 | 75 | 0 | table line 24, `foreman_drone_spawner` |
| som_link_lava_beetle_drone | -6 | -1 | 0 | 0 | table line 25, `foreman_drone_spawner` |
| som_link_lava_beetle_drone | -102 | 0 | -87 | 0 | table line 26, `foreman_drone_spawner` |

then, for EACH of the four lair points, six drones and two workers at that exact point:

| lair | x | z | y |
| --- | --- | --- | --- |
| line 15 | -100 | -6 | 37 |
| line 16 | -71 | -1 | -1 |
| line 17 | -36 | -3 | -27 |
| line 18 | -93 | -3 | -44 |

That is 4 x (6 x `som_link_lava_beetle_drone` + 2 x `som_link_lava_beetle_worker`) = 32 rows.
Write them out as literal rows, four groups of eight, one short comment per group naming the lair
line. **Do not generate them with a loop** -- every other placement table in this file is literal
rows, and a loop would hide the coordinates.

Heading on all 32 is `0` (the table leaves `yaw` blank on those rows).

**Prop rows, in this order:**

| template | x | z | y | yaw | source |
| --- | --- | --- | --- | --- | --- |
| object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff | -100 | -6 | 37 | 0 | line 15 |
| object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff | -71 | -1 | -1 | 0 | line 16 |
| object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff | -36 | -3 | -27 | 0 | line 17 |
| object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff | -93 | -3 | -44 | 0 | line 18 |
| object/tangible/dungeon/mustafar/uplink_trial/exit_door.iff | -90 | 0 | 117 | 4 | line 28 |

Both templates are registered and loaded:
`object/custom_content/tangible/dungeon/mustafar/uplink_trial/serverobjects.lua:2-4`, reached from
`object/custom_content/tangible/dungeon/mustafar/serverobjects.lua:5`.

### 2c. Add the code

Add `self:populateUplinkCave()` to `MustafarDungeonPopulation:start()`, immediately after the
existing `self:populateLairBosses()` call and before the two `print` lines.

Add one new function, placed after `populateLairBosses` / `spawnLairBoss` and before
`getSubstitute`:

```lua
function MustafarDungeonPopulation:populateUplinkCave()
	local cave = self.uplinkCave
	local buildings = MustafarInstances:getPoolBuildings(cave.poolKey)

	if (buildings == nil or #buildings == 0) then
		print("MustafarDungeonPopulation: instance pool '" .. cave.poolKey .. "' is empty; " .. cave.label .. " will not be populated")
		return
	end

	for i = 1, #buildings do
		self:populateUplinkCopy(cave, buildings[i])
	end
end

function MustafarDungeonPopulation:populateUplinkCopy(cave, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("MustafarDungeonPopulation: " .. cave.poolKey .. " copy " .. buildingID .. " is missing; it gets no creatures")
		return
	end

	local cellID = self:resolveCell(pBuilding, cave.cell)

	if (cellID == 0) then
		print("MustafarDungeonPopulation: " .. cave.poolKey .. " copy " .. buildingID .. " has no cell named '" .. cave.cell .. "'; its rows from " .. cave.table .. " are skipped")
		return
	end

	for i = 1, #cave.creatures do
		local row = cave.creatures[i]

		-- Heading is DEGREES here -- see THE AXIS MAPPING.
		local pMobile = spawnMobile("mustafar", row[1], self.respawn, row[2], row[3], row[4], row[5], cellID)

		if (pMobile == nil) then
			print("MustafarDungeonPopulation: failed to spawn " .. row[1] .. " in " .. cave.cell .. " of " .. cave.poolKey .. " copy " .. buildingID)
		else
			self.spawnedCount = self.spawnedCount + 1
		end
	end

	for i = 1, #cave.props do
		local row = cave.props[i]

		-- spawnSceneObject takes RADIANS and takes the cell id before the heading.
		local pObject = spawnSceneObject("mustafar", row[1], row[2], row[3], row[4], cellID, math.rad(row[5]))

		if (pObject == nil) then
			print("MustafarDungeonPopulation: failed to place " .. row[1] .. " in " .. cave.cell .. " of " .. cave.poolKey .. " copy " .. buildingID)
		else
			self.propCount = self.propCount + 1
		end
	end
end
```

Note the row index difference: `cave.creatures` rows are
`{ template, x, z, y, heading }` (5 fields, no cell name, because the cell is constant) whereas
`pool.rows` are `{ liveName, cell, x, z, y, heading }` (6 fields). That is why this does not
reuse `spawnRow`/`spawnProp`. Say so in a one-line comment above `populateUplinkCopy`.

### 2d. The header block for the new field

Write a `--[[ ]]` comment immediately above `uplinkCave = {`, in this file's existing voice (read
the `lairBosses` comments first). It must state, in plain sentences:

1. **The table exists, and an earlier note in this repo said it did not.**
   `mustafar_instances.lua:279-281` reads "som_uplink_cave has NO dungeon spawn table", and that
   was true only of `datatables/spawning/dungeon/`. The cave's placement table is in a different
   tree: `datatables/dungeon/mustafar_trials/link_establish/link_event_data.tab`, reached from the
   building's own server template through `link_event_manager`. That note is corrected in Task 4.
2. **The axis mapping** and that it is the same one at lines 25-37.
3. **The foreman and its four guards are one live script.** `foreman_spawner.java` does
   `create.object(FOREMAN, getLocation(self))` at the line-23 waypoint, then loops
   `offSet = { "-10:-10", "-10:10", "10:-10", "10:10" }` adding each pair to live
   `spawnLoc.x` and `spawnLoc.z` -- which are repo x and repo y -- while keeping the height. Then
   `ai_lib.establishAgroLink(foreman, eventMobs)`, which Core3 has no binding for; the four
   defenders carry `PACK` instead, the same substitution `valley_battlefield.lua` records for its
   commander's guards.
4. **The `.ilf` corroboration**, carried over from the deleted `lairBosses` comment: the foreman
   point sits inside the `som_uplink_cave.ilf` footprint (x -200.8..8.6, z -108.5..178.2), the
   nearest fixture is a `must_jeditemple_wall_long` 13.8 m away, and the local ground band runs
   h -4.2 to -7.7, which brackets live's -5. That is a check on the axis mapping, not the source
   of the coordinate.
5. **The 32 lair beetles, and exactly what is ported and what is not.**
   `bug_spawner.java` is attached to each `beetle_lair.iff`. It has `BUG_MAX = 8`, spawns one
   every 20 s at `getLocation(self)` -- the lair's own point -- and re-spawns on
   `droneDied` until the cap. Each roll is `DRONE` unless `rand(0, 9) > 7`, so 8 in 10 drones and
   2 in 10 workers. **Ported:** the cap of 8 per lair, at the lair point, split 6 drones / 2
   workers, which is that ratio applied to 8. **Not ported:** the 20 s stagger, the re-spawn on
   death, the lair's 50000 hit points and self-repair, and the `soldier_spawner` marker the lair
   drops when destroyed. So live's 8 is a ceiling a player climbs toward and this is 8 standing
   there from the start. Stated, not hidden.
   Also state the count: 40 creatures and 5 props per copy, across the 9 copies in the
   `uplink_cave` pool.
6. **What the table places that this does not**, with the reason for each:
   - the 15 `patrol_waypoint.iff` rows (11 named, 4 `randomN`) -- not a registered server
     template in this tree, checked by grep across `object/`; the same call
     `valley_battlefield.lua:96-100` already makes.
   - the single stage-2 `droid_spawner` row and its eleven-waypoint `path` -- an escort, and this
     port has no stage machine to walk it. `som_link_relay_droid` is therefore not created.
   - `must_uplink_bunker_entrance.iff` on line 27 -- a building, and the copies are already
     instantiated by `mustafar_instances.lua`; spawning it inside a cell would nest cells.
   - `som_link_lava_beetle_soldier` -- reachable only through the lair's `OnDestroy`.
7. **Respawn** is `self.respawn` (600), for the reason already given at lines 57-69.

---

## TASK 3 -- the uplink relay template, in `screenplays/mustafar/quest/story_arc_chapters.lua`

**Line 481 is wrong.** It reads:

```lua
	uplinkRelayTemplate = "object/building/mustafar/items/must_satellite_uplink.iff",
```

Change it to:

```lua
	uplinkRelayTemplate = "object/tangible/dungeon/mustafar/uplink_trial/relay_object.iff",
```

**Why, and put this in the comment.** The relay has a shipped template and it was found, so the
substitution is retired rather than kept:

- `script/library/trial.java:124` --
  `RELAY_OBJECT = "object/tangible/dungeon/mustafar/uplink_trial/relay_object.iff"`
- `theme_park/dungeon/mustafar_trials/establish_the_link/droid_patrol_script.java:141` --
  `createObject(trial.RELAY_OBJECT, playLoc)`, the droid building the relay. Also referenced at
  `droid_patrol_script.java:152` and `:158`, `bug_spawner_tracker.java:104`, and
  `link_event_manager.java:135` and `:162`.
- It is registered and loaded in this repo:
  `object/custom_content/tangible/dungeon/mustafar/uplink_trial/relay_object.lua:1`, included from
  `.../uplink_trial/serverobjects.lua:4`.
- It is a `SharedStaticObjectTemplate`
  (`object/custom_content/tangible/dungeon/mustafar/uplink_trial/objects.lua:12`), which is what
  `spawnSceneObject` wants. `must_satellite_uplink.iff` is a BUILDING template, and
  `DirectorManager::spawnSceneObject` calls `createCellObjects()` on anything that reports
  `isBuildingObject()` -- so the old value was creating a cell-bearing building as scenery.

Rewrite the `-- SUBSTITUTED:` block at lines 475-480 so it covers only what is still substituted.
`repairDroid` stays as it is: `must_mining_droid_mark_01` is still a substitution, the `.qst`
still names no template for it, and live's `som_link_relay_droid` belongs to the cave trial rather
than to this surface work site. Do not change `repairDroid`. Say in the comment that the relay
half of this note is retired and why, so the next reader does not go looking for a substitution
that is no longer there.

Do not change line 1803 or 1806 -- they read the field and are already correct.

---

## TASK 4 -- four stale in-tree comments

Each of these is a comment that is now false or misleading. Correct the text. Do not change any
code except where a task above says to.

### 4a. `screenplays/mustafar/battlefields/valley_battlefield.lua` lines 46-48

Currently:

```
- Demo-pack radial (pick up / plant charge / detonator) is round F1(d), not
  built here. The two packs still place as props at stage 1; they have no
  radial yet. Stated, not silently skipped, and no fake radial is stubbed.
```

**This is false -- the radial WAS built, in this same file.** Lines 804-813 do
`SceneObject(pObj):setObjectMenuComponent("SomDemoPackMenuComponent")` and seed
`demoInWorld`, `demoMines`, `demoSession`. Replace the bullet with an accurate one-sentence
statement that the demo pack radial ships, naming the menu component and the line range, so a
reader does not go looking for missing work.

### 4b. `screenplays/mustafar/battlefields/valley_battlefield.lua` -- add a turret bullet

Add a new bullet to the same SCOPED OMISSIONS list. Match the voice of the existing dead-code
note at lines 82-85 (`redirectArmy`). It must say that the ten turret templates in
`object/tangible/dungeon/mustafar/valley_battlefield/` are not placed **because live never places
them either**, and give the chain. The evidence, all of which is checked -- write it as prose,
not as a list of raw greps:

- `valley_event_data.tab` has **zero** turret rows. There is no shipped placement.
- `turret_controller_object.iff` is created in exactly one place in the whole extract:
  `turret_controller.java:139`, inside `regenerateInPlayerInventory`. Nothing calls that method.
  The only other `regenerateInPlayerInventory` in the tree is
  `demolition_generator.java:37` and `:54`, which is the demo pack's own separate method.
- `turret_droid_controller.java` is the sole owner of `buildTurret` (line 21) and the sole caller
  of `createObject` on a turret template (lines 38-40). No `.java` and no `.tpf` in the extract
  attaches that script to anything.
- `turret_controller.java` gates on a `constructionDroid` objvar that nothing in the tree ever
  writes; `getConstructionDroid()` `destroyObject`s the controller when it is absent.
- `mining_droid.java` never receives `turret_droid_controller` and has no `buildTurret` handler.

State the repo cross-check too, because it is the cleanest single proof: of the twenty templates
under `valley_battlefield/`, the ten turret ones have zero references anywhere in this repo and
the other ten -- the three demo charges, the detonator, the demo pack, the bunker, the cooling
unit, the two fence spans and the power generator -- are all placed by this file. The split is
exact.

**One honest note to include:** the first grep that looked at this was truncated at 40 lines and
filled entirely with `turret_controller.java` hits, which hid `turret_droid_controller.java` and
`turret_operations.java`. The conclusion survived the re-check, but state that the evidence above
is the rebuilt one, not the truncated one. `scratch/LIVE-VALLEY.md:11` asserted
"Turrets are unreachable dead code" with no citation; this bullet is that claim's citation.

### 4c. `screenplays/mustafar/mustafar_instances.lua` lines 279-281

Currently:

```
-- som_uplink_cave has NO dungeon spawn table. The five that ship are
-- som_mining_facility, som_old_republic_facility, som_crash_site_cruiser,
-- som_working_droid_factory and som_decrepit_droid_factory. So unlike
-- the ORF there is no live row to quote here, and the .ilf is the best
-- evidence that exists
```

That is true of `datatables/spawning/dungeon/` and false as a general statement. The cave's
placement table is `datatables/dungeon/mustafar_trials/link_establish/link_event_data.tab` -- a
different tree, reached from the building's own server template through `link_event_manager`, with
26 content rows.

Correct it. Keep the `INVENTED PLACEMENT` heading and keep the `.ilf` derivation for the ENTRY
POINT, because that is still invented -- `link_event_data.tab` has no entry row, and the entry
coordinate `(0, -2.0, 0)` still comes from the two `must_miner_tower` fixtures. What changes is
the sentence claiming no live table exists. Narrow it to
`datatables/spawning/dungeon/`, name the table that does exist, and point at
`mustafar_dungeon_population.lua`, which now reads it.

### 4d. `screenplays/mustafar/quest/kenobi_spine.lua` lines 232-274

Lines 232-273 are a superseded argument. They claim
`som_kenobi_final_crystal_pedestal` and `som_kenobi_final_force_crystal` are "left unplaced rather
than guessed at", spend ~40 lines deriving a gallery-2 location, and close with "That is the whole
decision, and it is Aaron's." Line 274 onward -- the `OVERTURNED -- ROUND G(b1)` block -- retracts
all of it, and **the pedestal is in fact placed, at line 569 of this same file.**

Collapse it. Replace lines 232-273 with a short, accurate paragraph that says, in this order:

1. Both tangibles ARE placed, from
   `datatables/dungeon/mustafar_trials/obiwan_finale/obiwan_event_data.tab`, which
   `lair_of_the_crystal.tpf` reaches through
   `theme_park.dungeon.mustafar_trials.obiwan_finale.obiwan_event_manager`. The pedestal row is
   `object/tangible/quest/som_kenobi_final_crystal_pedestal.iff` at live
   `(locx, locy, locz) = (57, 0, 6)`, yaw -90, which is repo `(x, z, y) = (57, 0, 6)`. Point at
   the finale section of this file where it lands.
2. Why the earlier note was wrong: it searched `.qst` files and `datatables/spawning/dungeon/` and
   concluded from two empty directories that nothing shipped. The table was in the building's own
   server template all along. That is a research gap, not a design question, and the sentence
   calling the placement Aaron's decision is withdrawn.
3. Keep the two-gallery geometry, because it still describes the room -- gallery 1 (x 21..40,
   h -0.2..0.8, 16 relic statues, where the player arrives and the boss fights) and gallery 2
   (x 74..86, h ~4.13, 8 statues ringed on pillars, the empty rotunda further in). Say explicitly
   that gallery 2 is no longer a guess about where the pedestal goes; the guess was wrong by about
   23 m.

Then delete the now-redundant `OVERTURNED -- ROUND G(b1)` block, since its content has been folded
into the paragraph above it. Keep any sentences from it that carry facts the new paragraph does
not.

**Do not change any code in `kenobi_spine.lua`.** Comment text only.

---

## WHEN YOU ARE DONE

Do not run git. Do not commit. Print a list of every file you created or modified, and for each
one, one line saying what changed. If anything in this spec did not match what you found in the
file, say so explicitly rather than adapting silently.

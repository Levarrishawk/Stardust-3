# ROUND G(c) — `som_sherkar_consort` (Malfosa)

Nine file changes. Author the creature, its loot, its outdoor spawner, and correct one
false comment. Every number below is sourced; where a value is a judgement it says so
and says what it was judged against. **Do not invent numbers. Do not "improve" the
stats.** If something here looks wrong, implement it as written and say so at the end.

Do not commit. Do not run git.

---

## §1 What this creature is (the live record)

Live name `som_sherkar_consort`, display name **Malfosa**. It is the open-world
Mustafar boss of the Sher Kar family. It is **not** a dungeon creature — live never
spawns it inside the lair (`monster_manager.java` spawns `som_sherkar`,
`som_sherkar_praetorian`, `som_sherkar_karling`, `som_sherkar_symbiot` and no consort).

Sourced from
`_dsrc-full/sku.0/sys.server/compiled/game/datatables/mob/creatures.tab` line 4808:

```
som_sherkar_consort  BaseLevel 80  difficultyClass BOSS  where mustafar  socialGroup sherkar
  template som/sher_kar.iff  minScale 0.65  maxScale 0.65  hue 3
  armorKinetic..armorAcid 0   armorStun -1   attackSpeed 2
  meat 19 meat_insect   hide 33 hide_scaley   niche carnivore
  intLootRolls 1  intRollPercent 100  lootTable mustafar/mustafar_sherkar_consort
  rootImmune 100  snareImmune 100  stunImmune 100  mezImmune 100  canNotPunish 1
  scripts theme_park.dungeon.mustafar_trials.sher_kar.malfosa
  primary_weapon_specials spider_5   secondary_weapon_specials spider_5
  aggressive 24  assist 24  stalker (blank)  herd (blank)  death_blow instant
```

HP comes from the attached script, not the table.
`script/theme_park/dungeon/mustafar_trials/sher_kar/malfosa.java` calls
`trial.setHp(self, trial.HP_SHER_KAR_CONSORT)`, and `script/library/trial.java:233`
gives `HP_SHER_KAR_CONSORT = 225000`. That script does nothing else — the consort has
**no special ability**, unlike its praetorian/symbiot siblings.

---

## §2 FILE 1 (new) — `MMOCoreORB/bin/scripts/mobile/custom_content/som/som_sherkar_consort.lua`

Follow the authored-som house style: a header comment that separates SOURCED from
OURS, then the table. Model the comment shape on
`mobile/custom_content/som/som_alien_parasite.lua`.

### The tier call, which the header must state

Live level 80 / `difficultyClass BOSS` does **not** map mechanically onto this port's
ladder (`scratch/MUSTAFAR-GAPS.md` §"Creature tiers vs live difficultyClass" — three
live values cannot key eight rungs, every mapping is a judgement). Two independent
inputs both land on **BOSS 120**:

- Live's own `difficultyClass` is `BOSS`. The consort and `som_sherkar` are the only
  two BOSS rows in the family; the praetorian/symbiot/karling are all ELITE.
- Relative strength is preserved. Live consort HP 225 000 is **25.4 %** of live Sher
  Kar's 885 000 (`trial.java:232-233`). This repo already ships `sher_kar.lua` at RAID
  200, HAM 160 000/195 000; the ladder's BOSS rung is 44 000/54 000, which is
  **27.5 %/27.7 %** of RAID. Within ~2 points of live's own ratio.

So: **BOSS 120**, taken whole from the ladder table at `scratch/MUSTAFAR-GAPS.md:1763` —
`level 120, chanceHit 4.0, damageMin 745, damageMax 1200, baseXp 11390,
baseHAM 44000, baseHAMmax 54000, armor 2`, and the BOSS resist override
`{90,90,90,90,90,90,90,90,-1}` (`MUSTAFAR-GAPS.md:1775`, source
`mobile/thug/dark_jedi_master.lua:16`).

Note in the header that live gives the consort `armorStun -1` (stun-vulnerable) where
the ladder's BOSS row gives stun 90. The ladder is the tuning and is applied whole, the
same as every other retuned row; the divergence is disclosed, not hidden.

This is the same block `mobile/custom_content/som/som_dark_jedi_boss.lua` already
carries, so the two BOSS-tier Mustafar creatures agree exactly.

### The exact table to write

```lua
som_sherkar_consort = Creature:new {
	customName = "Malfosa",
	socialGroup = "sher_kar",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "meat_insect",
	meatAmount = 19,
	hideType = "hide_scaley",
	hideAmount = 33,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/sher_kar.iff"},
	hues = { 3 },
	scale = 0.65,
	lootGroups = {
		{
			groups = {
				{group = "sher_kar_consort", chance = 10000000}
			},
			lootChance = 909091
		}
	},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"strongpoison",""}, {"creatureareapoison",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_sherkar_consort, "som_sherkar_consort")
```

### Why each non-ladder field is what it is — put this in the header comment

- **`customName = "Malfosa"`.** The live shared template only carries
  `objectName = "monster_name" "sher_kar"`, i.e. it would read "Sher Kar", and there is
  no STF key for the consort anywhere in the extract (`_STF_EN_ALL.tsv` searched for
  `som_sherkar`, `sherkar`, `malfosa`, `consort` — no creature-name hit). But live names
  it Malfosa in the Chronicles strings that DO ship:
  `string/en/collection_n.stf` → `relic_destroy_malfosa` = "Kill Malfosa", and the world
  spawner's own `strName` objvar is literally `malfosa`. Standing ruling for this port
  is author English and cite the live key, so the display name is Malfosa.
- **`socialGroup = "sher_kar"`.** Live uses `sherkar` for both this and `som_sherkar`,
  putting the family in one assist group. This repo's shipped `sher_kar.lua` already
  chose the token `sher_kar`. Matching the shipped sibling keeps live's grouping intent
  with the repo's existing spelling; inventing a second token would split the family.
- **`creatureBitmask = KILLER`.** SOURCED, and note what is absent. Live `stalker` is
  blank and `herd` is blank, so unlike `sher_kar.lua` there is no STALKER and no PACK.
  Live `death_blow = instant` is the KILLER flag (`ObjectFlag.h:24`, consumed by the AI
  behaviour tree at `Checks.h:230 CheckIsKiller`).
- **`pvpBitmask`.** Live `aggressive 24` / `assist 24` — it aggroes at 24 m. That is
  AGGRESSIVE + ATTACKABLE + ENEMY, the base-tree pattern for a hostile creature.
- **`scale = 0.65` and `hues = { 3 }`.** SOURCED (`minScale`/`maxScale`/`hue`). ⚠ Four
  volcano files in this pack carry a comment claiming "Core3 Creature templates have no
  scale field." **That claim is false and this round disproves it** — `scale` is read at
  `CreatureTemplate.cpp:149` and `hues` at `:243-246`, and `diskret_stahn.lua:24`,
  `obi_wan_ghost.lua:23`, `som_kenobi_obi_wan.lua:42` and `som_surveyor_keslev.lua:41`
  all already set `scale`. A one-element `hues` list is safe: `CreatureTemplate.h:361`
  does `System::random(hues.size() - 1)`, which is `random(0)` → index 0.
  Say this in the header. Do **not** go and edit the volcano files — that is not this
  round's work; it is being recorded for the gaps file instead.
- **`primaryAttacks`.** Live has no weapon (`primary_weapon` blank → `unarmed`) and gets
  its specials from AI combat profile `spider_5`, which is
  `ai_combat_profiles.tab:308` = `bm_defensive_5`, `bm_damage_poison_5` (×2),
  `bm_puncture_3`. It is a tier-5 poison spider. The nearest shipped Core3 creature
  commands are `strongpoison` (the tier-5 poison, used by 65 base-tree mobiles) and
  `creatureareapoison` (the area form, 20 uses). `bm_defensive_5` and `bm_puncture_3`
  have no Core3 creature-command analogue and are dropped — say so.
  OURS, NOT SOURCED: the exact pairing. What is sourced is "poison, tier 5, and an
  area component."
- **meat/hide.** SOURCED (19 `meat_insect` / 33 `hide_scaley`). 33 other files in this
  som pack carry harvest values, so this is in style. Note that the shipped
  `sher_kar.lua` zeroes its own harvest even though live gives it 60/85 — that is a
  pre-existing divergence in the sibling, not something this file copies.

---

## §3 FILE 2 (new) — `MMOCoreORB/bin/scripts/loot/items/mustafar/cube_loot_3r.lua`

New sub-folder `loot/items/mustafar/`.

⚠ **THE PATH TRAP — read this before writing the file.** The obvious path
`object/tangible/loot/mustafar/cube_loot/cube_loot_3r.iff` is **wrong for this repo**
and will silently resolve to nothing. `object/custom_content/tangible/loot/mustafar/cube_loot/cube_loot_3r.lua`
registers the SERVER template at `object/tangible/loot/mustafar/cube/loot/cube_loot_3r.iff`
— with `cube_loot` split into `cube/loot`. This exact defect is already documented and
worked around at `screenplays/mustafar/quest/jenha_tar_cube.lua:118-137`, which ruled
that the object file "is not this port's file to change" and addresses the split path
instead (`jenha_tar_cube.lua:271-273`). **Do the same here. Use the split path**, and
cite `jenha_tar_cube.lua:124-137` in a comment so the next reader does not "fix" it.

```lua
-- Malfosa's only live drop. See mobile/custom_content/som/som_sherkar_consort.lua.
--
-- Live: datatables/loot/loot_items/mustafar/sher_kar_consort.tab holds exactly one
-- item, object/tangible/loot/mustafar/cube_loot/cube_loot_3r.iff.
--
-- ⚠ The directObjectTemplate below is deliberately the SPLIT path "cube/loot", not
-- "cube_loot". object/custom_content/tangible/loot/mustafar/cube_loot/cube_loot_3r.lua
-- registers the server template at that split path; the client template is registered
-- correctly. Same defect and same workaround as the three quest cubes -- see
-- screenplays/mustafar/quest/jenha_tar_cube.lua:124-137 and :271-273. Correcting the
-- object file is not this port's call.
--
-- No craftingValues: this is an inert quest cube, not equipment. Live's
-- cube_loot_3p + cube_loot_3q + cube_loot_3r assemble into object/tangible/item/som/
-- sher_kar_syringe.iff via datatables/item/loot_cube/republic_assembly_tool.tab:3.
-- customObjectName is left empty so the shipped STF name is used:
-- som/som_cube.stf cube_loot_3r_n = "a warmly glowing poison gland".

cube_loot_3r = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/mustafar/cube/loot/cube_loot_3r.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("cube_loot_3r", cube_loot_3r)
```

---

## §4 FILE 3 (new) — `MMOCoreORB/bin/scripts/loot/groups/mustafar/sher_kar_consort.lua`

New sub-folder `loot/groups/mustafar/`. Named for the live table it transcribes,
`datatables/loot/loot_items/mustafar/sher_kar_consort.tab`.

```lua
-- Transcribes datatables/loot/loot_items/mustafar/sher_kar_consort.tab, which is the
-- table datatables/loot/loot_types/mustafar/mustafar_sherkar_consort.tab points at.
-- One real row (cube_loot_3r) and ten blank rows -- the blanks are how live expresses
-- the drop rate, so they are NOT reproduced as entries here. The 1-in-11 they encode is
-- carried by lootChance = 909091 on the creature instead, which is where Core3 puts it.

sher_kar_consort = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "cube_loot_3r", weight = 10000000}
	}
}

addLootGroupTemplate("sher_kar_consort", sher_kar_consort)
```

---

## §5 FILE 4 (edit) — `MMOCoreORB/bin/scripts/loot/items.lua`

Insert a new sub-folder section in alphabetical order among the existing
`-- <name> sub-folder` sections. It goes between `--misc sub-folder` (line 507) and
`--npc sub-folder` (line 511): insert **immediately before** the `--npc sub-folder`
line.

```lua
-- mustafar sub-folder
includeFile("items/mustafar/cube_loot_3r.lua")

```

## §6 FILE 5 (edit) — `MMOCoreORB/bin/scripts/loot/groups.lua`

Same rule. It goes between `-- hero_of_tatooine sub-folder` (line 125) and
`-- npc/corellia sub-folder` (line 128): insert **immediately before** the
`-- npc/corellia sub-folder` line.

```lua
-- mustafar sub-folder
includeFile("groups/mustafar/sher_kar_consort.lua")

```

## §7 FILE 6 (edit) — `MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua`

Insert **immediately after line 171** (`includeFile("custom_content/som/som_pwwoz_thug_2.lua")`)
and **before** the comment block that begins on line 172 — that comment belongs to the
trinity-assassin line below it, so do not split it.

```lua
includeFile("custom_content/som/som_sherkar_consort.lua")
```

⚠ The prefix must be `custom_content/som/`, never a bare `som/`. A bare prefix silently
fails to resolve and has already killed four includes in this file — its own header
comment says so.

---

## §8 FILE 7 (new) — `MMOCoreORB/bin/scripts/screenplays/mustafar/regions/malfosa_region.lua`

### Where the creature goes, and why it is not where you would guess

⚠ **The live coordinate is NOT a world coordinate.** The spawner row is
`datatables/buildout/mustafar/mustafar_main_nw.tab` line 13:

```
-1391  0  object/tangible/ground_spawning/area_spawner.iff  0  3799.34  19.9804  2505.76 ...
  scripts systems.spawning.spawner_area
  objvars ... fltMaxSpawnTime 20000 | fltMinSpawnTime 10800 | fltRadius 200
          | intSpawnCount 1 | strName malfosa | strSpawns mustafar/malfosa
```

SWG buildout rows store `px`/`pz` **relative to the buildout area's minimum corner**,
and `py` absolute. `sys.shared/.../datatables/buildout/areas_mustafar.tab` gives
`mustafar_main_nw` `x1 = -6880`, `z1 = +2848`. So:

```
world.x = px + x1 = 3799.34 + (-6880) = -3080.66
height  = py                          =    19.98   (absolute, never offset)
world.y = pz + z1 = 2505.76 + 2848    =  5353.76
```

Do **not** use the `originX/originZ` columns — they are `(-2304, 2848)` for all four
quadrants (the shared inner corner) and are a trap.

The offset is proved three ways against values this repo already measured independently
from `snapshot/mustafar.ws`:

| object | buildout px/pz | computed world | repo's measured world | delta |
| --- | --- | --- | --- | --- |
| `must_sherkar_lair_exterior` | 175.733 / 1508.34 (`_ne`, x1 -2304 z1 2848) | -2128.267 / 4356.34 | -2128.27 / 4356.34 | 0.00 |
| `must_sherkar_door` | 226.926 / 1428.08 (`_ne`) | -2077.074 / 4276.08 | -2077.07 / 4276.08 | 0.00 |
| ORF door exterior | 1528.07 / 3240.28 (`_ne`) | -775.93 / 6088.28 | -775.93 / 6088.28 | 0.00 |

(repo values: `mustafar_instances.lua:205-210` and `scratch/PLACEMENT.md:86-95`.)
The NW quadrant is separately checked: the `must_jeditemple_dome` row lands at
(-4537, 3193) against this repo's `mustafar_regions.lua:150`
`{"blackguard_jedi_ruins", -4373, 3255, r200}`, and the jedi temple wall cluster lands
inside `{"nw_jedi_ruins", -5424, 6028, r200}` at `:151`.

Put this whole derivation in the file's header comment. It is the load-bearing part of
the round.

### The file

Match the house style of `screenplays/mustafar/regions/storm_lord_region.lua` exactly —
same `ScreenPlay:new` shape, same `registerScreenPlay(name, true)`, same
`start()` guarded by `isZoneEnabled("mustafar")`, same `spawnMobiles()`.

```lua
malfosa_region = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "malfosa_region"
}

registerScreenPlay("malfosa_region", true)

function malfosa_region:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnMobiles()
	end
end

function malfosa_region:spawnMobiles()
	local pMalfosa = spawnMobile("mustafar", "som_sherkar_consort", 10800, -3080.66, getWorldFloor(-3080.66, 5353.76, "mustafar"), 5353.76, 0, 0)

	if (pMalfosa == nil) then
		print("malfosa_region: failed to spawn som_sherkar_consort at (-3080.66, 5353.76)")
	end
end
```

Header comment must also record:

- **Respawn 10800 is SOURCED** — live's `fltMinSpawnTime` is 10 800 s (3 h) and
  `fltMaxSpawnTime` 20 000 s (~5.5 h). Core3's `spawnMobile` takes a single respawn
  value, so the minimum is used. This is far longer than any other respawn in the
  Mustafar screenplays (600 is the highest) and that is deliberate — live means this to
  be a rare world boss.
- **Height uses `getWorldFloor`, not the sourced 19.98.** Live is an *area spawner*
  with `fltRadius 200` and `intGoodLocationSpawner 1`, so the creature does not
  actually stand at the spawner's own point or its own height. This port places the
  creature directly at the spawner's centre, so the terrain floor is the honest z. The
  sourced 19.98 is recorded here as the cross-check. Same convention as
  `storm_lord_region.lua:96` (`pSkar`).
- **`intSpawnCount 1`** — one consort, not a group. `malfosa.tab` has exactly one row
  (`som_sherkar_consort 5`); its `fltSize 5` is a theater radius, not a count
  (`script/library/qa.java:1677-1690`).
- **OURS, NOT SOURCED: the heading (0).** No heading is derivable — the row's
  quaternion is the *spawner object's* facing, not the creature's, and the creature is
  placed by the area spawner at a runtime-chosen good location anyway.
- **cellID 0** — outdoors.
- The point sits in open ground; the nearest region in `mustafar_regions.lua` is
  `burning_plains_5` at (-2776, 4593) r300, about 819 m away, so nothing covers it and
  no `NOSPAWNAREA` is added (this port does not add regions it was not given).

## §9 FILE 8 (edit) — `MMOCoreORB/bin/scripts/screenplays/screenplays.lua`

Insert alphabetically among the four mustafar region includes at lines 839-842.
`malfosa` sorts before `mensix`, so insert **immediately before** line 839:

```lua
includeFile("mustafar/regions/malfosa_region.lua")
```

---

## §10 FILE 9 (edit) — `MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_dungeon_population.lua`

Replace **only** the final paragraph of the `lairBosses` block comment — the one that
currently begins `KNOWN INCOMPLETE, not a defect:` and ends `...until someone decides
what the consort is. ]]` (lines 533-537). Leave every other line of that comment, and
the `lairBosses` table itself, byte-for-byte unchanged. **Do not add the consort to
`lairBosses`.**

The old paragraph is wrong on its premise and the correction must say so plainly. It
claimed `malfosa.tab` shows the live lair held a consort population. It does not:
`malfosa.tab` lives under `datatables/spawning/ground_spawning/types/mustafar/`, which is
the OPEN-WORLD spawn system, not a dungeon table. Live never puts the consort in the
lair — `monster_manager.java` spawns `som_sherkar`, `som_sherkar_praetorian`,
`som_sherkar_karling` and `som_sherkar_symbiot`, and no consort. Sher Kar standing alone
in the lair is **correct**, not incomplete.

New final paragraph (write it in the same indented block-comment style as the rest):

```
	     THE CONSORT IS NOT MISSING FROM HERE, and the note that used to stand in
	     this spot was wrong on its premise. It read malfosa.tab as evidence that
	     the live lair held a consort population. It is not: malfosa.tab sits under
	     datatables/spawning/ground_spawning/types/mustafar/, which is the
	     open-world spawn system, not a dungeon table. Live spawns the lair from
	     monster_manager.java -- som_sherkar, som_sherkar_praetorian,
	     som_sherkar_karling and som_sherkar_symbiot -- and never a consort. Sher
	     Kar standing alone in here is what live does.

	     som_sherkar_consort now ships, as the open-world boss it actually is:
	     mobile/custom_content/som/som_sherkar_consort.lua, placed by
	     screenplays/mustafar/regions/malfosa_region.lua at (-3080.66, 5353.76),
	     which is buildout row mustafar_main_nw.tab:13 resolved through the
	     areas_mustafar.tab offset. The derivation is written out in full there. ]]
```

---

## §11 What "done" means

1. Nine files: 4 new (`som_sherkar_consort.lua`, `cube_loot_3r.lua`,
   `sher_kar_consort.lua`, `malfosa_region.lua`), 5 edited (`items.lua`, `groups.lua`,
   som `serverobjects.lua`, `screenplays.lua`, `mustafar_dungeon_population.lua`).
2. Every one of the nine passes `luac5.3 -p`.
3. `lairBosses` is unchanged and the consort was NOT added to it.
4. The loot item uses the **split** path `cube/loot`, not `cube_loot`.
5. The spawner uses **-3080.66 / 5353.76**, never the raw 3799.34 / 2505.76.
6. Nothing outside these nine files is touched. In particular do not edit the volcano
   creature files, `sher_kar.lua`, or `object/custom_content/tangible/loot/...`.

# ROUND F2(a) — the volcano creature roster

Write 19 new creature templates and add 19 include lines. Nothing else.
Do not touch any other file. Do not commit. Do not run git.

---

## §1 WHERE THINGS GO

New files, one per creature, all in:

```
MMOCoreORB/bin/scripts/mobile/custom_content/som/
```

Then add one `includeFile(...)` line per new file to:

```
MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua
```

That file is a flat alphabetically-sorted list of `includeFile("custom_content/som/NAME.lua")`
lines. Insert each new line in alphabetical position. Read the file first and match its exact
existing form — do not reformat it, do not re-sort it, do not touch any line that is already there.

`serverobjects.lua` is otherwise FENCED. The only change permitted to it is inserting the 19
new include lines.

---

## §2 THE FILE SHAPE — copy this exactly

Every file is a comment header, then one `Creature:new` table, then one
`CreatureTemplates:addCreatureTemplate(...)` call. The canonical example already in the tree is
`som_battlefield_commander.lua`. Read it before you start. Field order below is the field order
you must use.

```lua
-- <header, see §5>
NAME = Creature:new {
	customName = "<from the table>",
	socialGroup = "droid_army",
	faction = "",
	mobType = <from the table>,
	level = <from the table>,
	chanceHit = <from the tier block>,
	damageMin = <from the tier block>,
	damageMax = <from the tier block>,
	baseXp = <from the tier block>,
	baseHAM = <from the tier block>,
	baseHAMmax = <from the tier block>,
	armor = <from the tier block>,
	resists = {75,75,100,60,100,25,40,85,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"<from the table>"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},

	primaryWeapon = "<from the table>",
	secondaryWeapon = "<from the table>",
	conversationTemplate = "",
	primaryAttacks = <from the table>,
	secondaryAttacks = <from the table>
}

CreatureTemplates:addCreatureTemplate(NAME, "NAME")
```

Tabs for indentation, not spaces. The whole tree uses tabs.

---

## §3 THE TIER BLOCKS — copy verbatim, do not compute

Three blocks. Each row in §4 names which one it uses.

**APEX 140** (anchor `mobile/dungeon/corellian_corvette/neutral/corsec_special_ops_master_sergeant.lua`)
```
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
	armor = 2,
```

**BOSS 120** (anchor `mobile/dungeon/corellian_corvette/neutral/corsec_security_specialist.lua`)
```
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
```

**CIV 45** (anchor `mobile/corellia/gronda_patriarch.lua`)
```
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
```

---

## §4 THE 19 ROWS

Common to all except where a row says otherwise:
`socialGroup = "droid_army"`, `faction = ""`, `optionsBitmask = AIENABLED`,
`pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY`, `creatureBitmask = PACK + STALKER`,
`resists = {75,75,100,60,100,25,40,85,-1}`, `diet = HERBIVORE`, the loot block from §2.

Attack-set shorthand used in the table:
- **HK** = `primaryWeapon "ranged_weapons"`, `secondaryWeapon "none"`,
  `primaryAttacks merge(marksmanmaster,bountyhuntermaster)`, `secondaryAttacks bountyhuntermaster`
- **CWW** = `primaryWeapon "ranged_weapons"`, `secondaryWeapon "none"`,
  `primaryAttacks merge(marksmanmaster,pistoleermaster)`, `secondaryAttacks pistoleermaster`
- **DARK** = `primaryWeapon "dark_jedi_weapons_gen4"`, `secondaryWeapon "dark_jedi_weapons_ranged"`,
  `primaryAttacks merge(lightsabermaster,forcepowermaster)`, `secondaryAttacks forcepowermaster`
- **BEETLE** = `primaryWeapon "unarmed"`, `secondaryWeapon "none"`,
  `primaryAttacks { {"creatureareaattack",""} }`, `secondaryAttacks { }`
- **SENTRY** = no weapon-group fields at all. Instead, after `conversationTemplate = "",` put:
  `defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",` and
  `defaultAttack = "attack"`, and omit primaryWeapon/secondaryWeapon/primaryAttacks/secondaryAttacks
  entirely. This is the shape `union_sentry_droid.lua:66-67` already uses in this folder.

| # | file / template name | customName | tier | mobType | appearance .iff | attacks |
|---|---|---|---|---|---|---|
| 1 | `som_volcano_one_taskmaster` | `a Droid Army Taskmaster` | APEX | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 2 | `som_volcano_one_sustainer` | `a Droid Army Sustainer` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 3 | `som_volcano_two_ak_prime` | `AK Prime` | APEX | MOB_ANDROID | `object/mobile/som/cww8a_battle_droid.iff` | CWW |
| 4 | `som_volcano_two_hk77` | `an HK-77 Assault Droid` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 5 | `som_volcano_three_forward_commander` | `a Droid Army Forward Commander Mk II` | APEX | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 6 | `som_volcano_three_hk77` | `an HK-77 Assault Droid` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 7 | `som_volcano_three_risen_commander` | `a Risen Commander` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 8 | `som_volcano_four_cym_prototype` | `the Cyborg Prototype` | APEX | MOB_NPC | `object/mobile/som/volcano_cyborg_lt.iff` | DARK |
| 9 | `som_volcano_four_lava_beetle` | `a lava beetle` | BOSS | MOB_CARNIVORE | `object/mobile/som/kubaza_beetle.iff` | BEETLE |
| 10 | `som_volcano_five_boss_septipod` | `the Oppressor Septipod` | APEX | MOB_DROID | `object/mobile/som/union_sentry_droid.iff` | SENTRY |
| 11 | `som_volcano_five_septipod` | `a GK Septipod` | BOSS | MOB_DROID | `object/mobile/som/union_sentry_droid.iff` | SENTRY |
| 12 | `som_volcano_five_midguard` | `a GK Midguard` | BOSS | MOB_DROID | `object/mobile/som/union_sentry_droid.iff` | SENTRY |
| 13 | `som_volcano_final_hk47` | `HK-47` | APEX | MOB_ANDROID | `object/mobile/som/hk47.iff` | HK |
| 14 | `som_volcano_final_squadleader` | `a Droid Army Squad Leader` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 15 | `som_volcano_final_squadmember` | `a Droid Army Soldier` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 16 | `som_volcano_final_risen_sustainer` | `a Risen Sustainer` | BOSS | MOB_ANDROID | `object/mobile/som/hk77.iff` | HK |
| 17 | `som_volcano_final_lava_beetle` | `a lava beetle` | BOSS | MOB_CARNIVORE | `object/mobile/som/kubaza_beetle.iff` | BEETLE |
| 18 | `som_volcano_final_septipod` | `a GK Septipod` | BOSS | MOB_DROID | `object/mobile/som/union_sentry_droid.iff` | SENTRY |
| 19 | `som_volcano_final_walker` | `a CWW8 Battle Walker` | BOSS | MOB_DROID | `object/mobile/som/cww8_battle_droid.iff` | CWW |

### Per-row overrides — apply these, they are not optional

- **Row 9 and row 17 (both lava beetles):** `socialGroup = "kubaza"`, `diet = CARNIVORE`,
  `resists = {5,5,5,30,-1,30,-1,-1,-1}` (the beetle's own resist line, from
  `kubaza_beetle.lua:40`, not the droid_army block — these are animals, not droids), and
  `lootGroups = {},` (an empty table, exactly as `kubaza_beetle.lua` has it; the droid loot
  block does not belong on a beetle).
- **Row 8 (cym prototype):** `socialGroup = "imperial"`, `creatureBitmask = STALKER` (no PACK —
  it is a lone boss, matching `som_dark_jedi_boss.lua`), and the loot block's first group is
  `imperial_tier_4` instead of `technician_tier_1`, matching `volcano_cyborg_lt.lua`.
- **Rows 10, 11, 12, 18 (SENTRY attacks):** loot block's groups are
  `{group = "technician_tier_1", chance = 7000000}, {group = "junk", chance = 3000000}` with
  NO `lootChance` line, matching `union_sentry_droid.lua:56-63`.
- **Row 13 (HK-47):** `creatureBitmask = STALKER` (no PACK). This is the campaign's final boss
  and stands alone.
- **Row 19 (walker):** loot block's groups are
  `{group = "technician_tier_1", chance = 7000000}, {group = "junk", chance = 3000000}` with
  NO `lootChance` line, matching `cww8_battle_droid.lua`.

### Row 20 — the autopilot, which is different from all of the above

`som_volcano_autopilot` is a non-combat protocol droid that stands on the bridge of the
evacuation ship. It is NOT a droid_army mob. Write it as:

- tier **CIV 45**
- `customName = "an autopilot droid"`
- `socialGroup = "townsperson"`, `faction = ""`
- `mobType = MOB_DROID`
- `pvpBitmask = NONE`
- `creatureBitmask = NONE`
- `optionsBitmask = AIENABLED + CONVERSABLE`
- `diet = NONE`
- `resists = {0,0,0,0,0,0,0,-1,-1}`
- `templates = {"object/mobile/3po_protocol_droid_red.iff"}`
- `lootGroups = {},`
- `conversationTemplate = "",`
- `defaultWeapon = "",` and `defaultAttack = "attack"` — no weapon groups, no attack sets

**Before you write it, verify `object/mobile/3po_protocol_droid_red.iff` is a registered
template.** Grep for `3po_protocol_droid_red` under `MMOCoreORB/bin/scripts/object/`. If it is
NOT there, do not invent a path — write the file using
`object/mobile/som/miner_pilot.iff` instead and put a one-line note in that file's header
saying the red 3PO appearance is not registered in this tree and the miner pilot stands in.

That makes **19 combat mobs + 1 autopilot = 20 files**. (§1 says 19; it is 20. Write 20.)

---

## §5 THE HEADER ON EACH FILE

Three to six lines. Plain sentences. Every one must say, in its own words for that creature:

1. What it is and where it appears — name the event
   (`event_one` … `event_five`, or the HK-47 finale).
2. Its live row name and live level and difficultyClass, and the tier it got here instead.
   Use this sentence pattern, filled in for the row:
   `-- Live row som_volcano_x, level 85 BOSS; level here is APEX tier 140, not live's 85 -- see`
   `-- the note below.`
3. Any substitution that row needed — the weapon group, the loot group, the appearance.

Then, on **every one of the 20 files**, close the header with this exact paragraph, verbatim:

```
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
```

### Substitutions you must name in the headers, because they are real and they are all forced

- **Weapons.** Live gives `droid_hk77_boss.iff`, `droid_hk77_elite.iff`,
  `droid_hk77_assault_droid.iff`, `droid_cww8_01.iff`, `droid_union_sentry.iff`,
  `droid_union_sentry_01.iff`, `droid_union_sentry_02.iff`, `jedi_dark`, `jedi_dark_ranged`.
  **None of the nine is registered in this tree** (grepped). Each row falls back to the weapon
  its own appearance sibling already uses in `mobile/custom_content/som/`. This also erases
  live's three-way distinction between boss / elite / assault HK-77 weapons: all three become
  the same `ranged_weapons`. Say so on rows 1, 2, 4, 6, 7, 14, 15, 16.
- **Loot.** Live's six trial tables (`mustafar/mustafar_trial_taskmaster`, `_akprime`,
  `_cmdr_mk2`, `_cym`, `_oppressor`, `_hk47`) are **all absent** (grepped `bin/scripts/loot/`).
  So is the collection item `col_shattered_shard_02` and every chronicle-relic entry. Each row
  falls back to its appearance sibling's loot block. Say so on the six boss rows.
- **Live HP is dropped.** `trial.java:213-231` sets 3,000 to 950,485 HP per mob via `setHp`.
  Those numbers are replaced by the tier anchor's `baseHAM`/`baseHAMmax`. Say so once, on the
  files where it is largest — rows 1, 3, 5, 8, 10, 13.
- **Scale is dropped.** Live sets `minScale`/`maxScale` 0.9-1.5 per row. Core3's Creature
  template has no scale field. Say so on any row whose live scale was not 1.0.

Say all of this in plain sentences. No bullet lists inside the Lua comments.

---

## §6 WHAT NOT TO DO

- **Do not write a screenplay.** Nothing spawns these. That is round F2(b) and it is not yours.
  No file outside `mobile/custom_content/som/` may be touched.
- **Do not add the two never-spawned live rows** — `som_volcano_observer` and `som_volcano_pilot`.
  `volcano_event_data.tab` has no row for either and no volcano script spawns either. They are
  dead in live; they stay dead here.
- **Do not invent a weapon path, a loot group, an .iff, or a stat.** If a value is not in this
  spec and not copyable from a named sibling file, stop and leave a `-- TODO(F2a):` comment
  saying exactly what is missing. A TODO is a correct answer; a guess is not.
- **Do not touch** `obi_wan_ghost.lua`, `surveyor_jo.lua`, or any file in this folder that
  already exists, other than inserting include lines into `serverobjects.lua`.
- **Do not commit and do not run git.**

---

## §7 WHEN YOU ARE DONE

Report, in this order:
1. The 20 filenames you created.
2. The 20 include lines you inserted and the line numbers they landed on.
3. Every `TODO(F2a)` you left, with the file and the reason.
4. Confirmation that you touched no file outside `mobile/custom_content/som/`.

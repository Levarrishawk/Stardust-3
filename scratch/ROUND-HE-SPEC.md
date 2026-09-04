# ROUND H(e) — Mustafar trial bosses, their loot, and the two link-trial creatures

All coordinates, levels, templates and yaws below were read out of the live server dsrc by hand
before this spec was written. Every number has a cited source. Do not re-derive any of them and do
not "improve" them.

Repo root for every path in this file: `MMOCoreORB/bin/scripts/`.

**Do not commit. Do not run git.**

---

## 0. Conventions you must follow

**Axis mapping.** Live tables use `loc_x, loc_y, loc_z` where **`loc_y` is HEIGHT**. The repo's row
shape is `x, z, y` where **`z` is HEIGHT**. So:

    repo x  <-  live loc_x
    repo z  <-  live loc_y     (height)
    repo y  <-  live loc_z

Every coordinate in this spec is **already converted** and given in repo order. Transcribe it
literally.

**Headings.** `spawnMobile` takes DEGREES. Every heading in this spec is in degrees, already
converted from live's `setYaw`.

**No non-ASCII.** Not one byte, anywhere you touch. No smart quotes, no em dashes, no arrows. Use
`--` and `->`.

**Tabs, not spaces**, for indentation inside lua tables — match the surrounding file exactly.

**The tier ladder** is in `scratch/MUSTAFAR-GAPS.md` under "The tier ladder". You will use exactly
three rows of it:

| tier | level | chanceHit | dmgMin | dmgMax | baseXp | baseHAM | baseHAMmax | armor |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| STD   | 70  | 0.65 | 430 | 570  | 6747  | 12000 | 15000 | 0 |
| ELITE | 85  | 0.75 | 555 | 820  | 8130  | 12000 | 15000 | 1 |
| BOSS  | 120 | 4.0  | 745 | 1200 | 11390 | 44000 | 54000 | 2 |

Resists: `STD`/`ELITE` take `{0,0,0,0,0,0,0,-1,-1}`. `BOSS` takes `{90,90,90,90,90,90,90,90,-1}`.

**Live level maps to tier by `difficultyClass`, not by the number.** Live NORMAL -> STD 70, live
ELITE -> ELITE 85, live BOSS -> BOSS 120. That is the mapping every prior round used and it is the
one you use. Record live's own level in the file header comment.

**The model file to copy.** `mobile/custom_content/som/som_working_doom_bringer.lua` is the exact
shape wanted: a `--[[ ]]` header that states the live record, then the tier call, then the SOURCED
block explaining each authored choice, then the table. Read it before writing anything. Match its
structure, its comment density, and its field order.

**Weapon rule, already precedented.** Live names four droid weapon iffs that this repo does not
register: `droid_union_sentry_01.iff`, `droid_union_sentry_02.iff`, `droid_cww8.iff`,
`droid_hk77_boss.iff`. I verified this directly: each has a file under
`object/custom_content/weapon/droid/`, but every one of those files declares
`object/weapon/melee/2h_sword/2h_sword_kashyyk.iff` instead of its own path (a pre-existing
copy-paste defect in 36 files), and none of them is inside the object load closure. So none of the
four resolves. Every creature naming one of them takes the same fallback
`som_working_doom_bringer.lua:4` already records:

    defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
    defaultAttack = "attack"

with `mobType = MOB_DROID`. State the fallback in the file header, do not invent a second answer.

Live's two weapon **group** names DO resolve and are used as-is:
`battledroid` -> repo group `battle_droid_weapons`; `pirate_carbine` -> repo group `pirate_carbine`.
Both are included by `mobile/weapon/serverobjects.lua` (lines 102 and 77). Use the
`weapons = {"..."}` form, as `custom_content/ep3/ep3_clone_relics_super_battle_droid_01.lua:31` does.

**Special-attack profiles.** Live's `primary_weapon_specials` for these rows are `droid_special_6`,
`spider_5`, `roach_5`, `droid_5` and `som_working_devistator`. `som_working_doom_bringer.lua`
already records that live's `droid_special_6` profile row contains no actions at all. Do not author
specials for any creature in this round. Say so in each header, one line.

---

## 1. Twelve new creature templates

Create these twelve files in `mobile/custom_content/som/`. One file each, named after the creature.

Every one of these was read out of
`datatables/mob/creatures.tab` in the live dsrc. The `HP` column is live's runtime HP from
`script/library/trial.java` — **record it in the header comment only**. Core3 has no HAM column that
corresponds; the tier ladder's `baseHAM` governs. Do not try to reconcile the two numbers.

### 1a. Sher Kar's three guard types

All three: `socialGroup = "sherkar"`, `templates = {"object/mobile/som/sher_kar.iff"}`,
`hues = { 1 }`, `mobType = MOB_CARNIVORE`, `diet = CARNIVORE`,
`meatType = "meat_insect"`, `hideType = "hide_scaley"` (amounts: follow
`som_link_lava_beetle_defender.lua` — meatAmount 16, hideAmount 24),
`primaryWeapon = "unarmed"`, `secondaryWeapon = "none"`, `lootGroups = {}`.
Live `intLootRolls 1 / intRollPercent 80` with a **blank `lootTable`** — so there is no group to
name. Say that in the header; do not substitute a filler group.

| file | tier | live | scale | creatureBitmask | pvpBitmask | live script |
| --- | --- | --- | --- | --- | --- | --- |
| `som_sherkar_praetorian.lua` | ELITE 85 | L85 ELITE, HP 120000 | 0.3 | `PACK + KILLER` | `AGGRESSIVE + ATTACKABLE + ENEMY` | `sher_kar.praetorian` |
| `som_sherkar_karling.lua` | ELITE 85 | L83 ELITE, HP 65400 | 0.13 | `PACK + KILLER` | `AGGRESSIVE + ATTACKABLE + ENEMY` | `sher_kar.karling` |
| `som_sherkar_symbiot.lua` | ELITE 85 | L85 ELITE, HP 95000 | 0.15 | `PACK + KILLER` | `AGGRESSIVE + ATTACKABLE + ENEMY` | `sher_kar.life_sapper` |

`KILLER` because live `death_blow` is `instant` on praetorian and karling and `yes` on symbiot.
`PACK` because live calls `ai_lib.establishAgroLink(guards[0], guards)` on all four guards and
Core3 has no binding for that — the same substitution `som_link_lava_beetle_defender.lua` records.
`customName`: "Sher Kar Praetorian", "Karling", "Sher Kar Symbiot".

Header must note: all three wear the same `sher_kar.iff` body as the boss, at 0.3 / 0.13 / 0.15
scale against his 1.2, so they read as his brood and not as separate species. That is live's own
data, not a choice.

### 1b. Working Droid Factory — five templates

All five: `socialGroup = "droid_army"`, `mobType = MOB_DROID`, `diet = NONE`,
`meatType`/`hideType`/`boneType` empty with 0 amounts, `creatureBitmask = KILLER`
(live `death_blow = instant` on all five), `pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY`.

| file | tier | live | template iff | scale | hues | weapon | loot |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `som_working_hk_58_aurek.lua` | BOSS 120 | L83 BOSS, HP 448220 | `object/mobile/som/hk77.iff` | 1.2 | none | droideka fallback | `lootGroups = {}` |
| `som_working_hk_58_besh.lua` | BOSS 120 | L83 BOSS, HP 448220 | `object/mobile/som/hk77.iff` | 1.2 | none | droideka fallback | `lootGroups = {}` |
| `som_working_devistator.lua` | BOSS 120 | L88 BOSS, HP 635425 | `object/mobile/som/cww8a_battle_droid.iff` | none | `{ 1 }` | droideka fallback | `devistator_loot` (see 2) |
| `som_working_master_droid_engineer.lua` | BOSS 120 | L84 BOSS, HP 385225 | `object/mobile/ev_9d9.iff` | none | none | `weapons = {"pirate_carbine"}` | `lootGroups = {}` |
| `som_working_hand_of_doom.lua` | ELITE 85 | L82 ELITE, HP 125000 | `object/mobile/som/union_sentry_droid.iff` | 0.9 | none | droideka fallback | `lootGroups = {}` |

`customName`: "HK-58 Aurek", "HK-58 Besh", "the Devistator", "Master Droid Engineer",
"Hand of Doom". Live spells it "Devistator" -- keep live's spelling, note in the header that it is
live's own and not a typo introduced here.

Aurek and Besh are byte-identical in `creatures.tab` apart from the name. Say that in both headers
so a later reader does not think one was copied carelessly.

The four with `lootGroups = {}`: live gives them `intLootRolls 1 / intRollPercent 80` and a **blank
`lootTable`**. Header must say that explicitly -- an empty group here is live's data, not an
omission. `master_droid_loot` belongs to `som_working_super_repair_droid`
(`creatures.tab` lootTable `mustafar/mustafar_trial_engineer`), which already ships; do NOT
re-point it at the MDE.

`som_working_master_droid_engineer` uses `weapons = {"pirate_carbine"}` and needs an `attacks`
field; follow `ep3_clone_relics_super_battle_droid_01.lua:33`
(`attacks = merge(pistoleermaster,carbineermaster,marksmanmaster)`).

### 1c. Decrepit Droid Factory — two templates

Both: `socialGroup = "droid_army"`, `mobType = MOB_DROID`, `diet = NONE`, tier **BOSS 120**,
`creatureBitmask = KILLER`, `pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY`, empty meat/hide/bone.

| file | live | template iff | weapon | loot group | rolls |
| --- | --- | --- | --- | --- | --- |
| `som_decrepit_colonel_or5.lua` | L86 BOSS, HP 145000 | `object/mobile/death_watch_battle_droid.iff` | `weapons = {"battle_droid_weapons"}` | `colonel_or5_loot` | **2** |
| `som_decrepit_guardian.lua` | L85 BOSS, HP 185250 | `object/mobile/death_watch_s_battle_droid.iff` | droideka fallback | `factory_guardian_loot` | 1 |

`customName`: "Colonel OR-5", "Factory Guardian".

`som_decrepit_colonel_or5` has live `intLootRolls = 2`, so it gets **two identical `lootGroups`
blocks**, each `{ groups = { {group = "colonel_or5_loot", chance = 10000000} }, lootChance = 10000000 }`
-- the same shape `sher_kar.lua:39-52` uses. `som_decrepit_guardian` gets one block.
Both are `intRollPercent 100`, which is why `lootChance` is 10000000 and not a lower band.

`som_decrepit_colonel_or5` uses a weapon group, so give it the same `attacks = merge(...)` line as
the MDE.

### 1d. The two link-trial creatures

| file | tier | live | template iff | scale | hues | notes |
| --- | --- | --- | --- | --- | --- | --- |
| `som_link_lava_beetle_soldier.lua` | STD 70 | L80 NORMAL | `object/mobile/som/kubaza_beetle.iff` | 1.3 | `{ 1 }` | see below |
| `som_link_relay_droid.lua` | STD 70 | L55 NORMAL | `object/mobile/som/must_mining_droid_mark_03.iff` | none | none | see below |

`som_link_lava_beetle_soldier`: `socialGroup = "link_beetle"`, `mobType = MOB_CARNIVORE`,
`diet = CARNIVORE`, `meatType = "meat_insect"` amount 16, `hideType = "hide_scaley"` amount 24,
`primaryWeapon = "unarmed"`, `secondaryWeapon = "none"`, `lootGroups = {}` (live blank lootTable),
`creatureBitmask = PACK`, `pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY` (live aggressive 6,
assist 6). `customName = "Lava Beetle Soldier"`. It is the third beetle grade in the cave, above
the drone and the worker -- note in the header that it sits at scale 1.3 against the defender's
1.5, which is live's data.

`som_link_relay_droid`: `socialGroup = "link_player"`, `mobType = MOB_DROID`, `diet = NONE`,
empty meat/hide/bone, droideka fallback weapon, `lootGroups = {}`,
`creatureBitmask = KILLER` (live `death_blow = instant`),
**`pvpBitmask = ATTACKABLE` only** -- live has `aggressive` BLANK and `assist 2`, so it is not an
aggressive mob. It is the escort droid the player protects. `customName = "Relay Droid"`.
Getting this bitmask wrong turns a friendly escort into an attacker; it is the one field in this
round where the obvious copy is wrong.

### 1e. Registration

Add twelve `includeFile(...)` lines to `mobile/custom_content/som/serverobjects.lua`, in the
alphabetical position each belongs in. This file is under a retune fence, but the fence is on the
retune; **additive registration lines are established practice in this file across many prior
rounds.** Add lines only. Change nothing else in it.

### 1f. What is deliberately NOT created, and why

Do NOT create these four. They exist in live `creatures.tab` but have no static position anywhere:

    som_working_blastromech       L80 ELITE
    som_working_assassin_droid    L82 ELITE
    som_working_detonation_droid  L25 NORMAL
    som_working_repair_droid      L80 ELITE

They are spawned only by `working_droid_factory/rapid_assembly_unit.java`, whose `doEventSpawn` is
gated on `trial.isMdeEngaged(self)` and switches on a six-stage counter, at
`utils.findLocInFrontOfTarget(self, 3)` -- a runtime offset from a cloner, not a table row. This
port has no stage machine and no attested point for any of them. Registering four creatures that
nothing places would be a dead registration, which is the same thing H(c) proved about the ten
valley turrets. They are recorded in `MUSTAFAR-GAPS.md`, not shipped.

---

## 2. Three new loot groups and ten new loot items

### 2a. The chain, verified

    creatures.tab lootTable
      som_working_devistator     -> mustafar/mustafar_trial_devistator
      som_decrepit_colonel_or5   -> mustafar/mustafar_trial_col_or5
      som_decrepit_guardian      -> mustafar/mustafar_trial_factory_guardian

    loot/loot_types/mustafar/<that>.tab  strItems column
      mustafar_trial_devistator.tab        -> mustafar/devistator_loot
      mustafar_trial_col_or5.tab           -> mustafar/colonel_or5_loot
      mustafar_trial_factory_guardian.tab  -> mustafar/factory_guardian_loot

    loot/loot_items/mustafar/<that>.tab   rows, verbatim, in order

### 2b. `loot/groups/mustafar/devistator_loot.lua`

Live rows:

    weapon_tow_cannon_04_02
    weapon_tow_heavy_acid_beam_04_01
    object/tangible/loot/mustafar/cube_loot/cube_loot_3j.iff

Deliver **two** entries: `weapon_tow_cannon_04_02` and `cube_loot_3j`.

`weapon_tow_heavy_acid_beam_04_01` is **ABSENT and not delivered**. Its
`master_item.tab` template is `object/weapon/ranged/heavy/heavy_acid_beam_static.iff`, and that iff
path is declared by no file inside the object load closure -- I checked all 25,950 files in it. The
repo does have `object/custom_content/weapon/ranged/heavy/heavy_acid_beam_static.lua`, but that file
declares `2h_sword_kashyyk.iff` (the copy-paste defect described in section 0) and is not included
by any serverobjects. Record this in the file header in the same words
`loot/groups/mustafar/doombringer_loot.lua:2-4` uses. **Do not substitute.**

### 2c. `loot/groups/mustafar/colonel_or5_loot.lua`

Live rows, all three delivered:

    weapon_tow_carbine_e5_04_01
    weapon_tow_pistol_de10_04_01
    weapon_tow_sword_rsf_04_01

### 2d. `loot/groups/mustafar/factory_guardian_loot.lua`

Live rows, all seven delivered:

    item_tow_ring_droideng_04_01
    item_tow_ring_bioeng_04_01
    item_tow_ring_chef_04_01
    weapon_tow_rifle_lightning_cannon_04_01
    weapon_tow_blasterfist_04_01
    item_tow_factory_gaurd_trinket_04_01
    object/tangible/loot/mustafar/cube_loot/cube_loot_3a.iff   -> cube_loot_3a

(`gaurd` is live's own misspelling. Keep the live key verbatim. Note it in the header.)

### 2e. Group file shape

Copy `loot/groups/mustafar/colonel_or5_loot.lua`'s shape from
`loot/groups/mustafar/master_droid_loot.lua`. Weights must sum to **10000000** across the entries in
each group, split evenly, remainder to the first entry. Add the same
"Weights sum to 10000000 as transcribed; do not recompute" line the sibling files carry, and a first
line naming the live table each transcribes.

Register all three in `loot/groups.lua`, alphabetically among the existing
`includeFile("groups/mustafar/...")` lines (they start at line 130).

### 2f. Ten new item files in `loot/items/mustafar/`

Shape: copy `loot/items/mustafar/weapon_tow_2h_obsidian_04_01.lua` exactly. Two header comment
lines (live master_item key + tier; and which group names it), then the table, then
`addLootItemTemplate(...)`.

**These template paths are the SPLIT paths this repo actually declares, not live's paths.** I
verified each one resolves inside the object load closure. Use the right-hand column verbatim.

| item key | customObjectName | directObjectTemplate |
| --- | --- | --- |
| `weapon_tow_cannon_04_02` | Devastator Lava Cannon | `object/weapon/ranged/heavy/som_lava_cannon_generic.iff` |
| `cube_loot_3j` | (see note) | `object/tangible/loot/mustafar/cube/loot/cube_loot_3j.iff` |
| `weapon_tow_carbine_e5_04_01` | OR-5's E-5 | `object/weapon/ranged/carbine/carbine_e5_generic.iff` |
| `weapon_tow_pistol_de10_04_01` | OR-5's DE-10 | `object/weapon/ranged/pistol/pistol_de_10_generic.iff` |
| `weapon_tow_sword_rsf_04_01` | OR-5's Sword | `object/weapon/melee/sword/sword_rsf_generic.iff` |
| `item_tow_ring_droideng_04_01` | Relic Droid Engineer's Ring | `object/tangible/wearables/ring/ring_s03.iff` |
| `item_tow_ring_bioeng_04_01` | Relic Bioengineer's Ring | `object/tangible/wearables/ring/ring_s04.iff` |
| `item_tow_ring_chef_04_01` | Relic Chef's Ring | `object/tangible/wearables/ring/ring_s01.iff` |
| `weapon_tow_rifle_lightning_cannon_04_01` | Guardian Lightning Cannon | `object/weapon/ranged/rifle/rifle_lightning_heavy_static.iff` |
| `weapon_tow_blasterfist_04_01` | Guardian Blaster Fist | `object/weapon/melee/special/blasterfist_generic.iff` |
| `item_tow_factory_gaurd_trinket_04_01` | Old Republic Repulsion Generator | `object/tangible/loot/generic/usable/building_repair_device_generic_lt_4.iff` |

That is eleven rows because the two cubes are listed separately -- `cube_loot_3a` is the eleventh:

| `cube_loot_3a` | (see note) | `object/tangible/loot/mustafar/cube/loot/cube_loot_3a.iff` |

Note on the cubes: follow whatever `loot/items/mustafar/cube_loot_3c.lua` already does for
`customObjectName`. Do not invent a different convention for these two.

All `customObjectName` strings above are live's own `string_name` from `master_item.tab`, read
directly. `minimumLevel = 0`, `maximumLevel = -1`, empty `craftingValues` /
`customizationStringNames` / `customizationValues`, same as the sibling files. Live's
`required_level` (88 / 80) is recorded in the header comment only; it is not a repo field.

Register all eleven in `loot/items.lua` in the alphabetical `items/mustafar/` block that starts at
line 511.

---

## 3. Placements

All of these go in `screenplays/mustafar/mustafar_dungeon_population.lua`.

### 3a. `lairBosses` -- sixteen new entries

`lairBosses` already carries three entries and `spawnLairBoss` already does exactly what these need:
one spawn per copy of a pool, cell resolved by name, `spawnMobile` with a direct template name and
degrees. Add to that list. Do not write a new loop.

**Update the `lairBosses` header comment.** It currently explains the list as "no live table, no
substitute key", which was true when Sher Kar was its only member. It is not true now -- most of the
new entries come straight from `datatables/spawning/dungeon/som_working_droid_factory.tab` and from
hardcoded live java. Rewrite the opening paragraph so it says what the list is now: **fixed-point,
one-per-copy spawns whose position is a single attested point rather than a table row set.** Keep
the Sher Kar derivation paragraphs; they are still correct and still needed.

**Also fix the contradiction at the end of that comment.** It currently reads:

    Live spawns the lair from monster_manager.java -- som_sherkar, som_sherkar_praetorian,
    som_sherkar_karling and som_sherkar_symbiot -- and never a consort. Sher Kar standing alone
    in here is what live does.

Those two sentences contradict each other. The first is right. Delete "Sher Kar standing alone in
here is what live does." and replace it with a sentence saying the four guards are now placed
alongside him, which is what `monster_manager.java:54-95` does.

#### Sher Kar's four guards -- `poolKey = "monster_lair"`, `cell = "r1"`, heading 0

Source: `datatables/dungeon/mustafar_trials/sher_kar/sher_kar_data.tab`, the four
`minefield_spawner.iff` rows carrying `string:spawn_point=guard0/1/3/4`, read through
`sher_kar/monster_manager.java:54-95`, which allocates `obj_id[] guards = new obj_id[4]` and assigns
by index: type 0 and 1 -> `som_sherkar_praetorian`, type 2 -> `som_sherkar_karling`, type 3 ->
`som_sherkar_symbiot`.

| template | x | z (height) | y |
| --- | --- | --- | --- |
| `som_sherkar_praetorian` | -87.4726 | -18.2924 | -128.367 |
| `som_sherkar_praetorian` | -103.436 | -17.7027 | -62.5382 |
| `som_sherkar_karling` | -155.967 | -18.7049 | -57.0598 |
| `som_sherkar_symbiot` | -124.443 | -17.1073 | -133.004 |

Comment above the block must record three things:
1. The table has **guard0, guard1, guard3 and guard4 -- there is no guard2.** That gap is live's
   own and is not a transcription error here.
2. The table also carries seven `karling0..karling6` markers. **Nothing in live reads them** --
   `monster_manager.java` only ever looks for `sher_kar` and `guard*`. They are dead markers, and
   the four `spawnAdd` / `praetorianDied` / `lifeSapperDied` messages that would have used them are
   never sent. Not ported, on purpose.
3. Live calls `ai_lib.establishAgroLink(guards[0], guards)`; Core3 has no binding, so the four
   carry `PACK` instead -- the same substitution recorded elsewhere in this tree.

#### Working Droid Factory -- `poolKey = "working_droid_factory"`

Source: `datatables/spawning/dungeon/som_working_droid_factory.tab` `boss_wp` rows, read through
`working_droid_factory/working_controller.java`. `beginSpawn` at :28-36 fires `spawnGuardians`,
`spawnDevistator`, `spawnDroidEngineer` and `spawnDoomBringer` unconditionally; `spawnDoomBringer`
at :225 then fires `spawnDoomGuards`. So every one of these is placed on entry, not gated.

| template | cell | x | z | y | heading | source |
| --- | --- | --- | --- | --- | --- | --- |
| `som_working_hk_58_aurek` | smallroom21 | 100.881 | -12 | 30.9766 | 270 | tab line 9 `boss_wp=aurek`, `setYaw(aurek, 270)` :99 |
| `som_working_hk_58_besh` | smallroom24 | 11.1364 | -12 | -17.0658 | 90 | tab line 10 `boss_wp=besh`, `setYaw(besh, 90)` :103 |
| `som_working_devistator` | smallroom6 | 119.999 | -28 | 67.5402 | 180 | tab line 15 `boss_wp=devistator`, `setYaw` :137 |
| `som_working_master_droid_engineer` | mediumroom10 | 44.0914 | -38 | -41.7914 | 121 | tab line 18 `boss_wp=droid_engineer`, `setYaw(mde, 121)` :186 |
| `som_working_hand_of_doom` | mediumroom18 | -19.9774 | -28 | 52.3294 | 0 | tab line 35 `boss_wp=watcher0` |
| `som_working_hand_of_doom` | mediumroom18 | -31.498 | -28 | 52.415 | 0 | tab line 36 `watcher1` |
| `som_working_hand_of_doom` | mediumroom18 | -31.3043 | -28 | 41.041 | 0 | tab line 37 `watcher2` |
| `som_working_hand_of_doom` | mediumroom18 | -31.5005 | -28 | 29.5312 | 0 | tab line 38 `watcher3` |
| `som_working_hand_of_doom` | mediumroom18 | -19.9949 | -28 | 29.6682 | 0 | tab line 39 `watcher4` |
| `som_working_hand_of_doom` | mediumroom18 | -8.74025 | -28 | 29.6619 | 0 | tab line 40 `watcher5` |

Comment must record that the six Hands of Doom ring the Doom Bringer's room -- `boss_wp=doom_bringer`
is tab line 41, `mediumroom18 / -28.058 / -28 / 6.81914`, and that boss is **already placed** by the
existing `lairBosses` entry. Do not double it.

#### Decrepit Droid Factory -- `poolKey = "decrepit_droid_factory"`

Neither of these comes from a table. Both positions are hardcoded in live java and were read
directly.

| template | cell | x | z | y | heading | source |
| --- | --- | --- | --- | --- | --- | --- |
| `som_decrepit_colonel_or5` | mediumroom10 | 63 | -67 | -50 | 90 | `decrepit_droid_factory/decrepit_controller.java:106-113`, `new location(63, -67, -50, ...)`, `setYaw(colonel, 90)` |
| `som_decrepit_guardian` | mainroom27 | 65.7 | -24 | -1.3 | -90 | derived, see below |

The guardian's point is **derived and must be labelled as derived in the comment**.
`decrepit_droid_factory/power_core.java:59-82` finds the `patrol_wp` object named `controlFour`,
takes its location, then does `spawnLoc.x -= 3.4` and `spawnLoc.z -= 1.4` before
`create.object("som_decrepit_guardian", spawnLoc)` and `setYaw(guardian, -90)`. In live's axes that
`.z` is the horizontal, which is repo `y`. `controlFour` is at `mainroom27 / 69.1 / -24 / 0.1`, so
the guardian lands at `65.7 / -24 / -1.3`. Write the subtraction out in the comment so the number
can be checked without opening the java.

Also record: live gates the guardian behind the power-core objective
(`power_core.java` fires `spawnGuardian` after the core is worked) and the colonel behind
`spawnOr5`. This port has no objective machine, so both stand from the start. Say it plainly, the
same way the uplink comment says it about the beetle cap.

### 3b. Working Droid Factory props -- five new rows

Add to the `props` list of the `working_droid_factory` pool (currently two rows, at :497-500).
These four templates are already registered in this repo -- I verified all four resolve inside the
object load closure. Their exact paths come from `script/library/trial.java:92-95`.

Row shape in `props` is `{ template, cell, x, z, y, heading }`, heading in DEGREES.

| template | cell | x | z | y | heading | source |
| --- | --- | --- | --- | --- | --- | --- |
| `object/tangible/dungeon/mustafar/working_droid_factory/reactive_repair_module.iff` | smallroom6 | 119.986 | -28 | 73.0647 | 180 | tab line 16 `reactive_repair_unit`, `setYaw(rru, 180)` `working_controller.java:141` |
| `object/tangible/dungeon/mustafar/working_droid_factory/inhibitor_storage.iff` | smallroom4 | 95.4285 | -20 | -0.959162 | 0 | tab line 17 `inhibitor_supply`, no setYaw call |
| `object/tangible/dungeon/mustafar/working_droid_factory/rapid_assembly_station.iff` | smallroom11 | 80.0664 | -38 | -84.7532 | 0 | tab line 19 `cloner1`, no setYaw |
| `object/tangible/dungeon/mustafar/working_droid_factory/rapid_assembly_station.iff` | smallroom12 | 47.9865 | -38 | -84.7016 | 0 | tab line 20 `cloner2`, no setYaw |
| `object/tangible/dungeon/mustafar/working_droid_factory/radioactive_pile.iff` | mediumroom18 | -20.0197 | -28 | 40.8667 | 0 | tab line 34 `destruction_pile`, no setYaw |

Comment must state: these five are the fight furniture of the three boss encounters --
the Devistator's repair module and inhibitor supply, the MDE's two cloners, and the Doom Bringer's
destruction pile. Live creates them from `working_controller.java` at the same `boss_wp` waypoints
as their bosses, not from a separate table. The cloner1 waypoint is also where
`som_working_super_repair_droid` already stands (existing `lairBosses` entry); the station and the
droid share the point in live too, so that is not a collision to fix.

### 3c. `uplinkCave.creatures` -- twelve new rows

Row shape here is `{ template, x, z, y, heading }` -- five fields, no cell, because the cell is
constant `mainroom`.

#### The relay droid -- one row

    { "som_link_relay_droid", -81, 0, 128, 0 },

Source: `link_event_data.tab` line 2 -- the `patrol_waypoint.iff` row at `locx -81, locy 0,
locz 128` carrying script `establish_the_link.droid_spawner`. `droid_spawner.java:22-29`
`spawnRelayDroid` does `create.object(RELAY_DROID, getLocation(self))` -- **at the waypoint
itself**.

**This corrects a wrong note already in this file.** Lines 633-635 currently read:

    - the single stage-2 droid_spawner row and its eleven-waypoint path --
      an escort, and this port has no stage machine to walk it.
      som_link_relay_droid is therefore not created.

That reasoning does not survive reading `link_event_manager.java`. `beginSpawn` at :17-23 calls
`spawnActors(self, 1)` and then `messageTo(self, "beginEvent", null, 20, false)`; `beginEvent` at
:108-112 is nothing but `spawnActors(self, 2)`. **Stage 2 is unconditional, twenty seconds in.**
Meanwhile the foreman and its three drone spawners are **stage 3** rows (table lines 22-25), and
stage 3 only fires from `validateRelays` at :123-141 once eleven relay objects are counted -- and
this port places those already. So the file was placing the gated content and skipping the
ungated content. Replace the old bullet with a note that says exactly that, and cite the two line
ranges. The eleven-waypoint patrol path is still not walked; say that separately, because it is
still true.

#### The eleven lava beetle soldiers -- one at each named waypoint

    { "som_link_lava_beetle_soldier", -105, -1, 124, 0 },   -- firstCorner
    { "som_link_lava_beetle_soldier", -106, -2,  79, 0 },   -- secondCorner
    { "som_link_lava_beetle_soldier",  -78, -2,  71, 0 },   -- oppositeSide
    { "som_link_lava_beetle_soldier",  -56,  0,  40, 0 },   -- firstSpawn
    { "som_link_lava_beetle_soldier",  -70, -1,   0, 0 },   -- tSection
    { "som_link_lava_beetle_soldier",  -54, -1, -30, 0 },   -- firstLegBend
    { "som_link_lava_beetle_soldier",   -8, -2,  -1, 0 },   -- firstRelay
    { "som_link_lava_beetle_soldier",  -82,  0,  -5, 0 },   -- secondLegBend
    { "som_link_lava_beetle_soldier",  -99, -3, -45, 0 },   -- secondSpawn
    { "som_link_lava_beetle_soldier", -101, -2, -73, 0 },   -- finalEncounter
    { "som_link_lava_beetle_soldier", -102, -3, -26, 0 },   -- finalRelay

Those are `link_event_data.tab` lines 3-13, the eleven stage-1 rows carrying a `wp_name`. Keep the
`wp_name` as a trailing comment on each row exactly as shown -- it is the only thing tying the
coordinate back to the table.

The comment above the block must be honest about the conversion, in this shape:

- Live never places these from the table. `bug_spawner.java:21-36` `OnDestroy` creates a marker in
  `mainroom` and attaches `soldier_spawner`. `soldier_spawner.java:24-60` then collects every
  object in the room carrying a `WP_NAME` script var -- which is exactly these eleven -- and
  `spawnNewBug` picks one at random, jitters it by `rand(-6,6)` on both axes, and spawns a soldier
  there, up to `BUG_MAX = 3`, re-spawning on death.
- So live's guaranteed total is 3 per destroyed lair across 4 lairs = 12 soldiers, drawn from these
  eleven points. This port places eleven, one per point, from the start.
- Not ported: the trigger on lair destruction, the +-6 jitter, the re-spawn, and
  `link_event_manager.stopRandomSoldiers` at :164-176, which destroys the spawners once the relay
  objective completes. So live's soldiers are a wave that arrives and later stops; these stand
  throughout.
- This is the same static conversion already applied to the beetle lairs' 8-cap two blocks above.
  Point at that so the two read as one decision, not two.

Also delete the now-wrong bullet at lines 639-642 (`som_link_lava_beetle_soldier -- reachable only
through the lair's OnDestroy ... Nothing here would place it.`) and put the corrected reasoning in
the new block.

### 3d. Expected counts after this round

State these in a comment near `spawnedCount` so a boot check can be read against them:

- `lairBosses` goes from 3 entries to 19.
- Per-pool boss placements: monster_lair 12 copies x 5 entries (Sher Kar + 4 guards) = 60;
  working_droid_factory 12 copies x 12 entries (doom bringer, super repair droid, aurek, besh,
  devistator, MDE, 6 hands) = 144; decrepit_droid_factory 12 copies x 2 = 24.
  **Total lair bosses 228**, up from 36.
- Props: working_droid_factory props goes 2 -> 7 rows, so +5 x 12 copies = +60. Uplink props
  unchanged. **Total props 471**, up from 411.
- Uplink creatures per copy goes 40 -> 52, x 9 copies = 468, up from 360.
  **Total pool creatures 1389**, up from 1281.

Do the arithmetic yourself against the current file and the pool copy counts in
`mustafar_instances.lua` (old_republic_facility 12, monster_lair 12, uplink_cave 9,
lair_of_the_crystal 12, working_droid_factory 12, decrepit_droid_factory 9) before you write the
comment. **Note that decrepit_droid_factory has 9 copies, not 12** -- if that changes the number
above, the pool table wins and this spec is wrong; write the right number and say in the comment
that you corrected it.

---

## 4. Do not touch

These are fenced. Do not open them for editing:

    screenplays/mustafar/quest/obi_wan_ghost.lua
    screenplays/mustafar/surveyor_jo.lua
    the retune-fenced serverobjects.lua (NOT mobile/custom_content/som/serverobjects.lua,
      which section 1e explicitly changes -- additive include lines only)
    conversations/jo_kelsev_conv_handler.lua
    MMOCoreORB/bin/conf/config.lua

Do not run git. Do not commit. Do not delete anything.

---

## 5. Self-check before you report done

Run these and report the actual output:

1. `grep -c includeFile MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua` --
   must be exactly 12 higher than before your change.
2. Every new `.lua` you wrote parses: `luac -p <file>` or equivalent on each.
3. No non-ASCII: scan every file you created or edited for bytes above 0x7F. Report zero.
4. Every `directObjectTemplate` string you wrote appears verbatim in the table in section 2f.
5. `lairBosses` has 19 entries. `working_droid_factory` props has 7 rows.
   `uplinkCave.creatures` has 52 rows.

Report what you changed, file by file, with the counts. Do not claim success without the pasted
output of 1, 3 and 5.

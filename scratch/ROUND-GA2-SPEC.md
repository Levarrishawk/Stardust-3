# ROUND G(a2) — Mustafar quest XP: the Kenobi spine award sites

Do exactly what this file says. Do not commit. Do not run git. Do not touch any file not
named here.

---

## 1. PRECONDITION — read this first

Round G(a1) has already run. It created
`MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_quest_xp.lua` and wired it into
`screenplays.lua`. **Read that module before you write anything.** It carries the full rationale,
the sourced table, and the one function you will call:

    MustafarQuestXp:award(pPlayer, questKey)

Every row for the quests below is ALREADY in that table. Do not add rows. Do not change the
module. If a key you need is missing, stop and report it rather than inventing it.

Short version of the why, so you do not have to re-derive it: SOE's server discarded each quest's
stored `Experience Amount` and recomputed it as `quest_experience[LEVEL][TIER_n]`
(`groundquests.java:1018`, `:1379-1409`). The stored 0 in the `.qst` was never what live paid.
The award type is `combat_general`, not SOE's `quest_combat` — an unrecognised type silently caps
at 2000 forever (`PlayerObjectImplementation.cpp:740-753`). The module owns all of this.

## 2. THE RULE FOR EVERY SITE

- The award goes **after** the stage is set and after any reward item has successfully been handed
  over. Never before an early return.
- Add one short comment in the file's existing voice:
  `-- Quest XP: quest_experience[<level>][TIER_<tier>]. See mustafar_quest_xp.lua.`
  The module header owns the reasoning; do not repeat it at each site.
- Where a file's header comment asserts that the quest pays no XP, **amend it forward** — keep the
  original sentence (the stored field IS 0, that finding was correct) and add that live still paid
  because the server recomputed. Do not delete a finding.

## 3. THE SITES

### 3.1 `quest/collectors_business.lua`

`collectorsBusinessScreenPlay:awardQuest` at `:433`. Award `som_kenobi_collectors_business_1`
after `setStage(pPlayer, self.STAGE_DONE)` (~`:438`).

### 3.2 `quest/cursed_shard.lua`

`cursedShardScreenPlay:completeQuest` at `:705`. Award `som_kenobi_cursed_shard_2` after
`setStage(pPlayer, self.STAGE_DONE)` (~`:710`).

`som_kenobi_cursed_shard_1` is TIER 0, so its award is 0 by SOE's own rule. It has no row in the
module and gets no call. Leave it alone.

### 3.3 `quest/hidden_treasure.lua` — two sites

- `hiddenTreasureScreenPlay:clickHolocron` at `:329`. Award `som_kenobi_hidden_treasure_1` after
  `setStage(pPlayer, 4)` (~`:334`).
- `hiddenTreasureScreenPlay:awardQuest` at `:420`. Award `som_kenobi_hidden_treasure_2` after
  `setStage(pPlayer, 6)` (~`:421`).

`awardQuest` has no internal stage guard — its guard lives in the caller (the guardian-kill
observer). Do not add one; just keep the award after the setStage so it inherits the same
protection the item reward already has.

### 3.4 `quest/historian.lua` — three quests, two functions

- `historianScreenPlay:finishQuest1` at `:852` carries **two** quests. The discriminator is
  `self:hasFlag(pPlayer, "slice")`, set by `startQuest1(pPlayer, isSmuggler)`:
    - flag set   -> `som_kenobi_historian_smuggler`
    - flag clear -> `som_kenobi_historian_1`
  Both are 110006, so the amounts are identical — but route each through its own key anyway, so
  the record says which quest paid.
- `historianScreenPlay:finishQuest2` at `:940`. Award `som_kenobi_historian_2` after the setStage
  to `STAGE_DONE`.

### 3.5 `quest/kenobi_spine.lua` — five quests, four sites

The A/B discriminator throughout this file is `self:sparedTheHermit(pPlayer)` (`:810-813`), which
reads the persisted `"spared"` key written at `:1291` and deleted at `:1320`. Use that accessor —
do not read the key directly.

| function | line | quest key | anchor |
| --- | --- | --- | --- |
| `hermitHandsOverShard` | `:1284` | `som_kenobi_main_quest_1` | after `setStage(pPlayer, self.STAGE_SHARD_SPARED)` ~`:1290` |
| `hermitKilled`         | `:1313` | `som_kenobi_main_quest_1` | after `setStage(pPlayer, self.STAGE_SHARD_KILLED)` ~`:1319` |
| `takeCrystal`          | `:1511` | `som_kenobi_main_quest_spared` if `sparedTheHermit`, else `som_kenobi_main_quest_killed` | after `self:setStage(pPlayer, self.STAGE_CHAMBER)` at `:1539` — that line sits **after** the "conduits charged: N of 3" early return at `:1536`, so it only runs on the third conduit. Put the award there, not at the top of the function. |
| `bossKilled`           | `:1684` | `som_kenobi_main_quest_3_b_visible` if `sparedTheHermit`, else `som_kenobi_main_quest_3_visible` | after `setStage(pPlayer, self.STAGE_DONE)` ~`:1689` |

Two notes so you get the pairing right:

- `hermitHandsOverShard` and `hermitKilled` are the two exits of the SAME quest
  (`som_kenobi_main_quest_1`, 110006). Both award it, once each, and only one is reachable per
  character. That is not a double-award.
- `_spared` / `_killed` and `_3_visible` / `_3_b_visible` are FOUR distinct quest rows in SOE's
  data, all 160562. Which of each pair fires is the `spared` flag. Keep them as separate keys.

`bossKilled` and `takeCrystal` both have hard stage guards at the top and cannot re-enter.

### 3.6 `quest/moral_choice.lua` — one quest, two endings

`som_kenobi_moral_choice_1` at both:
- `moralChoiceScreenPlay:finishForCorporation` at `:542`, after `setStage(..., self.STAGE_DONE_CORP)` ~`:547`
- `moralChoiceScreenPlay:finishForMiners` at `:654`, after `setStage(..., self.STAGE_DONE_MINERS)` ~`:659`

One quest, two mutually exclusive endings — one award either way.

### 3.7 `quest/reunite_shard.lua` — three sites

| quest key | function | anchor |
| --- | --- | --- |
| `som_kenobi_reunite_shard_1` | `gatherFirstSplinters` `:617` | after `setStage(pPlayer, 3)` ~`:622` |
| `som_kenobi_reunite_shard_2` | `collectSplinter` `:732`      | after `self:setStage(pPlayer, 4)` at `:753`. That line sits **after** the "Crystal splinters recovered: N of 4" early return at `:747`, so it fires only when the last leg lands. Put the award there. |
| `som_kenobi_reunite_shard_3` | `awardQuest` `:820`           | called from `retrieveCrystal` `:807`, which carries the stage guard. Award after the crystal item is handed over. |

### 3.8 `quest/samaritan.lua` — one quest, two endings

`som_kenobi_samaritan_1` at both:
- the killed branch inside `notifyKilledCreature`, after `self:setStage(pPlayer, self.STAGE_DONE_KILLED)` at `:525`
- `samaritanScreenPlay:keepCrystal` at `:605`, after `setStage(..., self.STAGE_DONE_KEPT)` ~`:610`

The killed branch returns 1 to drop the observer. Put the award **before** that return.

### 3.9 `quest/serpent_shard.lua`

`serpentShardScreenPlay:finishQuest` at `:576`. Award `som_kenobi_serpent_shard_1` after
`setStage(pPlayer, self.STAGE_DONE)` ~`:582`.

### 3.10 `quest/symbiosis.lua`

`symbiosisScreenPlay:awardQuest` at `:408`. Award `som_kenobi_symbiosis_1` after the weapon is
handed over, **before** the `createEvent` that chains into the symbiosis_2 ambush.

`som_kenobi_symbiosis_2` has no LEVEL/TIER columns in its questlist table, so passthrough gives 0.
It has no row in the module and gets no call.

## 4. NOT IN THIS ROUND — do not touch

- Everything G(a1) already edited: `mustafar_quest_xp.lua`, `screenplays.lua`,
  `mining_field_markers.lua`, `map_exploration.lua`, `trophy_hunts.lua`,
  `story_arc_chapters.lua`, `story_arc_prelude.lua`, `blackguard_problem.lua`, `glyph_hunt.lua`,
  `jedi_dog.lua`, `jenha_tar_cube.lua`, `lava_beetle_nests.lua`, `maneater.lua`,
  `som_poison_miners.lua`, `som_striking_miners.lua`, `storm_lord.lua`.
- `bounty_hunts.lua` — TIER -1 takes SOE's passthrough branch and keeps the stored 1000. The
  repo's existing 1000 is already correct.
- `som_kenobi_cursed_shard_1`, `som_kenobi_main_quest_3`, `som_kenobi_main_quest_3_b` — TIER 0.
- `som_kenobi_samaritan_2`, `som_kenobi_symbiosis_2`, the ten `som_hk_history_*`,
  `som_obi_wan_signal_*`, `som_sceismic_charges`, `som_prelude_obiwan_check` — no LEVEL/TIER
  columns at all, so passthrough gives 0.

## 5. FENCED — never edit, for any reason

    obi_wan_ghost.lua
    surveyor_jo.lua
    serverobjects.lua      (the retune-fenced one)
    jo_kelsev_conv_handler.lua
    MMOCoreORB/bin/conf/config.lua

## 6. HOUSE RULES

- Lua 5.3. Tabs for indent, matching each file you edit.
- Amend findings forward; never delete one to make room.
- Every file you touch must pass `luac5.3 -p`.
- Do not commit. Do not run git.

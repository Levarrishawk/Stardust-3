# ROUND G(a1) — Mustafar quest XP: the module, and the non-Kenobi award sites

Do exactly what this file says. Do not commit. Do not run git. Do not touch any file not
named here.

---

## 1. WHY THIS EXISTS (read before writing anything)

Every Mustafar `.qst` stores `Experience Amount 0`. The repo honoured that literally and awards
no quest XP anywhere except one line. **That is wrong, and it is now proven wrong from SOE's own
server source.**

SOE's server threw the stored amount away and recomputed it:

    _dsrc-full/sku.0/sys.server/compiled/game/script/library/groundquests.java:1018
      experienceAmount = getQuestExperienceReward(player, questLevel, questTier, experienceAmount);

    groundquests.java:1379-1409
      if (questLevel < 1 || questTier < 0)  return experienceAmount;   // passthrough
      if (questTier == 0)                   return 0;
      if (questTier > 6)                    questTier = 6;
      questXp = dataTableGetInt(QUEST_EXPERIENCE_TABLE, "" + questLevel, tierColumns[questTier-1]);
      if (questXp > getQuestXpCap(player))  questXp = xpCap;
      return questXp;

    groundquests.java:50
      QUEST_EXPERIENCE_TABLE = "datatables/quest/quest_experience.iff"

So the award is `quest_experience[LEVEL][TIER_n]`, with LEVEL and TIER coming from each quest's own
questlist table. Both values are shipped data; nothing below is invented.

**The proof that this reading is right:** Miner Madness. Its questlist row is LEVEL 70 / TIER 4.
`quest_experience.tab:72` row 70 column TIER_4_EXPERIENCE is **91383**. The community walkthrough
for Miner Madness says 91,383 XP. Exact match, to the digit, from two independent directions.

(The other walkthrough figure, Skull of the Jundak's 78,265, does **not** match: LEVEL 75 / TIER 3
gives 86092. 86092 / 78265 = 1.10000. This extract is a very late publish and Mustafar shipped at
Pub 27, so the table was almost certainly retuned between them. **Use the table, not the wiki.**
Do not write a comment claiming the 1.1 is a proven table-wide rescale — it was tested across all
540 cells and 246 of them are not integers after dividing by 1.1. State it as what it is: this
extract is later than the wiki capture.)

## 2. THE XP TYPE — DO NOT USE `quest_combat` OR `quest_general`

SOE's types are `quest_combat` and `quest_general`. **This server has neither, and passing an
unknown type is silently destructive, not inert.**

    src/server/zone/objects/player/PlayerObjectImplementation.cpp:740-753
      int xpCap = -1;
      if (xpTypeCapList.contains(xpType))  xpCap = xpTypeCapList.get(xpType);
      if (xpType.beginsWith("prestige_")) { xpCap = INT_MAX; }
      else if (xpCap < 0)                 { xpCap = 2000; }
      if (xp > xpCap) { valueToAdd = xpCap - (xp - valueToAdd); xp = xpCap; }

An unknown type takes the `xpCap = 2000` branch: the player would receive 2000 XP once and
nothing ever again.

**Use `combat_general` for every award.** That is not a new call — the repo already ruled it, in
this exact tree, for this exact reason:

    screenplays/mustafar/quest/mining_field_markers.lua:605-607
      -- 290 quest XP + 5000 credits per area set. Live NGE awards "Quest XP"; Core3's
      -- experience table has no such type, so combat_general carries the value -- the same
      -- mapping map_exploration.lua makes.
      CreatureObject(pPlayer):awardExperience("combat_general", self.areaXpReward, true)

SOE's own type is still recorded — it goes in the table as a data field, so nothing is lost.

The binding, so you get the arguments right:

    src/server/zone/objects/creature/LuaCreatureObject.cpp:1026-1035
      awardExperience(type:string, amount:int, sendSystemMessage:boolean)
      -- the wrapper hardcodes applyModifiers = false, so the number written is the
      -- number granted. No species modifier, no buff, no global multiplier.

---

## 3. CREATE `MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_quest_xp.lua`

A new file. One global table, the sourced data, one award function. Follow the file-header style
of the neighbouring Mustafar screenplays: a comment block that states the source, the mechanism,
the substitution, and what is deliberately not done.

The header must carry, in prose:
  - the groundquests.java mechanism above, cited file:line
  - the Miner Madness exact-match proof
  - the Skull of the Jundak mismatch, stated honestly as above
  - the `quest_combat` -> `combat_general` substitution and WHY (the 2000 cap), cited file:line
  - that SOE's own xp type is preserved in the `soeType` field and is not used for the call
  - that repeatable quests re-award on every completion, because SOE's server recomputed the
    reward on every completion too — this is faithful, not an oversight

The table. `xp` is `quest_experience[level][tier]`, already computed — do not recompute it in Lua,
and do not ship the level/tier as live fields. Carry them as data for the record:

```lua
MustafarQuestXp = {
	-- questKey = { xp, level, tier, soeType }
	quests = {
		som_blackguard_problem           = { xp =  91383, level = 70, tier = 4, soeType = "quest_combat"  },
		som_blistmok_rug                 = { xp =  59142, level = 65, tier = 3, soeType = "quest_combat"  },
		som_exploration_area             = { xp =    319, level = 60, tier = 1, soeType = "quest_general" },
		som_glyph_hunt                   = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_jedi_dog                     = { xp =  86092, level = 75, tier = 3, soeType = "quest_combat"  },
		som_jenha_tar_cube               = { xp =     72, level =  1, tier = 1, soeType = "quest_general" },
		som_jundak_skull                 = { xp =  86092, level = 75, tier = 3, soeType = "quest_combat"  },
		som_kenobi_collectors_business_1 = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_cursed_shard_2        = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_hidden_treasure_1     = { xp =    402, level = 75, tier = 1, soeType = "quest_combat"  },
		som_kenobi_hidden_treasure_2     = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_historian_1           = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_historian_2           = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_historian_smuggler    = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_main_quest_1          = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_main_quest_3_b_visible= { xp = 160562, level = 80, tier = 5, soeType = "quest_combat"  },
		som_kenobi_main_quest_3_visible  = { xp = 160562, level = 80, tier = 5, soeType = "quest_combat"  },
		som_kenobi_main_quest_killed     = { xp = 160562, level = 80, tier = 5, soeType = "quest_combat"  },
		som_kenobi_main_quest_spared     = { xp = 160562, level = 80, tier = 5, soeType = "quest_combat"  },
		som_kenobi_moral_choice_1        = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_reunite_shard_1       = { xp =    402, level = 75, tier = 1, soeType = "quest_combat"  },
		som_kenobi_reunite_shard_2       = { xp =    402, level = 75, tier = 1, soeType = "quest_combat"  },
		som_kenobi_reunite_shard_3       = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_samaritan_1           = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_serpent_shard_1       = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_kenobi_symbiosis_1           = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_lava_beetle_nest_destroy     = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_lava_beetle_nest_destroy_2   = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_maneater                     = { xp =  91383, level = 70, tier = 4, soeType = "quest_combat"  },
		som_mustafar_exploration         = { xp =  35123, level = 60, tier = 2, soeType = "quest_general" },
		som_poison_miners                = { xp =  91383, level = 70, tier = 4, soeType = "quest_combat"  },
		som_storm_lord                   = { xp = 131890, level = 80, tier = 4, soeType = "quest_combat"  },
		som_story_arc_chapter_one_03     = { xp = 189233, level = 80, tier = 6, soeType = "quest_combat"  },
		som_story_arc_chapter_three_01   = { xp = 189233, level = 80, tier = 6, soeType = "quest_combat"  },
		som_story_arc_chapter_three_02   = { xp =    435, level = 80, tier = 1, soeType = "quest_combat"  },
		som_story_arc_chapter_three_03   = { xp = 189233, level = 80, tier = 6, soeType = "quest_combat"  },
		som_story_arc_chapter_two_01     = { xp = 189233, level = 80, tier = 6, soeType = "quest_combat"  },
		som_story_arc_prelude_01         = { xp =  86092, level = 75, tier = 3, soeType = "quest_general" },
		som_story_arc_prelude_02         = { xp = 110006, level = 75, tier = 4, soeType = "quest_general" },
		som_story_arc_prelude_03         = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_striking_miners              = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
		som_xandank_trophey              = { xp = 110006, level = 75, tier = 4, soeType = "quest_combat"  },
	},
}
```

Note `som_exploration_area` — the seven `som_exploration_*` quests are identical rows (LEVEL 60 /
TIER 1 / 319), so they share one key. Say so in a comment, and list the seven names in it.

The function. Guard everything; a bad key must be loud, not silent:

```lua
function MustafarQuestXp:award(pPlayer, questKey)
	if (pPlayer == nil or questKey == nil) then
		return 0
	end

	local row = self.quests[questKey]

	if (row == nil) then
		printLuaError("MustafarQuestXp: no sourced award for quest key '" .. tostring(questKey) .. "'")
		return 0
	end

	CreatureObject(pPlayer):awardExperience(self.xpType, row.xp, true)

	return row.xp
end
```

with `xpType = "combat_general"` as a field on the table, commented with the substitution reason.

## 4. WIRE IT IN — `MMOCoreORB/bin/scripts/screenplays/screenplays.lua`

One line, and it must come **before** every Mustafar screenplay so the global exists when they
load. The Mustafar block starts around line 757. Add immediately above the first
`includeFile("mustafar/...")` line:

    includeFile("mustafar/mustafar_quest_xp.lua")

## 5. THE AWARD SITES IN THIS ROUND

For each: read the function, find the anchor, insert the award. **Every award goes AFTER the
stage is set / the item successfully handed over** — never before an early return.

Add a short comment at each site in the file's existing voice, of the shape:
`-- Quest XP: quest_experience[<level>][TIER_<tier>]. See mustafar_quest_xp.lua.`
Do NOT repeat the whole rationale at every site; the module header owns it.

### 5.1 `quest/mining_field_markers.lua` — CORRECT the number, do not add a call

`:607` already awards. The field is `areaXpReward`. Its value is 290; the sourced value is **319**.
Change the value where it is declared, and update the `-- 290 quest XP` comment at `:605` to say
319 and to point at `mustafar_quest_xp.lua` for the derivation. **Do not add a second
awardExperience call here — that would double-award.**

Leave `grantCompletionReward` (`:618`) alone. It is the all-seven trophy + badge and carries no
quest name; there is no sourced XP for it.

### 5.2 `quest/map_exploration.lua` — `awardQuest`, around `:535`

Award `som_mustafar_exploration`. Insert next to the existing `addCashCredits` at ~`:549`.

The comment at ~`:547` currently reads *"The .qst reward task carries Experience Amount 0, so
credits and the item are the whole of it."* **That reasoning is now superseded — amend it forward,
do not delete it.** Replace with a note that the stored 0 was never what live paid, that the award
is `quest_experience[60][TIER_2] = 35123`, and point at the module.

Also check this file's header near `:88-91`, which says *"The guide above quotes 'Quest XP: 31930';
the shipped reward task carries no experience at all, so nothing is awarded here rather than
inventing a type."* Amend that forward too: the amount is no longer invented, it is sourced; and
note that the guide's 31930 matches neither 35123 nor any cell of the table, same publish-drift
shape as the Jundak figure.

### 5.3 `quest/trophy_hunts.lua` — `completeQuest`, `:1471`

Three quests through one function. The discriminator is the `quest` table argument. Add a
`questKey` field to each of the three quest tables — `blistmokRug` (~`:386`),
`jundakSkull` (~`:446`), `xandankTrophey` (~`:498`) — set to `"som_blistmok_rug"`,
`"som_jundak_skull"`, `"som_xandank_trophey"`.

**Placement matters here and it is not cosmetic.** `completeQuest` takes two early returns before
`setStage` — a nil inventory and a failed `giveItem`. A player with a full inventory can
re-trigger the turn-in. The award MUST go after `self:setStage(pPlayer, quest, quest.STAGE_DONE)`
(~`:1489`), never before the `giveItem` check.

### 5.4 `quest/story_arc_chapters.lua` — five sites

| quest key | function | anchor |
| --- | --- | --- |
| `som_story_arc_chapter_one_03`   | `completeChapterOne` ~`:1902` | after the `advance` to `STAGE_FIND_FACTORY` |
| `som_story_arc_chapter_two_01`   | `grantFinalChapter` ~`:1642`  | after the `advance` to `STAGE_DROID_ARMY` |
| `som_story_arc_chapter_three_01` | `startVolcanoQuest` ~`:1653`  | after the `advance` to `STAGE_FIND_PILOT` |
| `som_story_arc_chapter_three_02` | `grantOverrideTool` ~`:1295`  | after `setFlag(pPlayer, "overrideTool")` ~`:1300` |
| `som_story_arc_chapter_three_03` | `useMiloTerminal` ~`:2238`    | after `setStage(pPlayer, self.STAGE_DONE)` ~`:2251` |

This file's header at `:139-142` says, verbatim:

    Verified across all seven: every "Time To Complete", "CountdownTimer",
    "Bank Credits" and "Experience Amount" field is 0, so this arc pays no credits,
    no XP and runs no timers.

That sentence is now half wrong and it will read as contradicting your change. **Amend it forward
in place** — keep the finding (the stored fields ARE 0), and add that the stored amount was not
what live paid, citing groundquests.java and the module. Do not delete it.

### 5.5 `quest/story_arc_prelude.lua` — three sites

| quest key | function | anchor |
| --- | --- | --- |
| `som_story_arc_prelude_01` | `sendCompanyComm` ~`:621`     | after `setStage` to `STAGE_FILTERS` ~`:622` |
| `som_story_arc_prelude_02` | `signalFilterReward` ~`:712`  | after `setStage` to `STAGE_REACTOR_OFFER` ~`:717` |
| `som_story_arc_prelude_03` | `signalRodReward` ~`:852`     | after `setStage` to `STAGE_DONE` ~`:857` |

The comment at ~`:630` (`-- task 3: Bank Credits 5000, Experience Amount 0, musicOnComplete.`) —
amend forward, same rule.

### 5.6 The eight standalone quest screenplays

| quest key | file | function | anchor |
| --- | --- | --- | --- |
| `som_blackguard_problem` | `quest/blackguard_problem.lua` | `awardQuest` ~`:617` | after `setStage(pPlayer, self.finishedStage)` ~`:618` |
| `som_glyph_hunt`         | `quest/glyph_hunt.lua`         | `awardQuest` ~`:747` | after `setStage(pPlayer, 5)` ~`:748`, and **before** the reset at ~`:761` |
| `som_jedi_dog`           | `quest/jedi_dog.lua`           | `signalReward` ~`:535` | after `setStage(pPlayer, self.STAGE_DONE)` ~`:541` |
| `som_jenha_tar_cube`     | `quest/jenha_tar_cube.lua`     | `awardQuest` ~`:572` | after `setStage(pPlayer, 4)` ~`:573` |
| `som_lava_beetle_nest_destroy` / `_2` | `quest/lava_beetle_nests.lua` | `signalReward` ~`:938` | after `setStage(pPlayer, self.STAGE_DONE)` ~`:947`. **Two quests, one function** — the discriminator is `self:getVariant(pPlayer)`, whose values are the `self.variants` keys `"one"` (~`:349`) and `"two"` (~`:356`). Map `"one"` -> `som_lava_beetle_nest_destroy`, `"two"` -> `som_lava_beetle_nest_destroy_2`. |
| `som_maneater`           | `quest/maneater.lua`           | `signalReward` ~`:688` | after `setStage(pPlayer, self.STAGE_DONE)` ~`:695` |
| `som_poison_miners`      | `quest/som_poison_miners.lua`  | `giveReward` ~`:659` | after the `playMusicMessage`, **before** `self:closeOut(pPlayer)` — closeOut resets the stage |
| `som_storm_lord`         | `quest/storm_lord.lua`         | `awardQuest` ~`:731` | after `setStage(pPlayer, self.finishedStage)` ~`:732`, **before** the reset at ~`:749` |
| `som_striking_miners`    | `quest/som_striking_miners.lua`| `giveReward` ~`:652` | after the existing `addBankCredits` ~`:655`, before `closeOut` ~`:677` |

Several of those files carry a header comment quoting `Experience Amount 0` (`blackguard_problem.lua:57,155`,
`glyph_hunt.lua:74,161`, `jedi_dog.lua:188`, `lava_beetle_nests.lua:223`, `maneater.lua:166`,
`som_poison_miners.lua:46,268`, `som_striking_miners.lua:50,287`, `storm_lord.lua:64,203`).
**Amend each one forward** with a single added sentence — the stored 0 is real, and live still
paid, because the server recomputed. Keep the original sentence.

## 6. NOT IN THIS ROUND — do not touch

- Every file under `quest/` belonging to the Kenobi spine: `kenobi_spine.lua`, `cursed_shard.lua`,
  `collectors_business.lua`, `hidden_treasure.lua`, `historian.lua`, `moral_choice.lua`,
  `reunite_shard.lua`, `samaritan.lua`, `serpent_shard.lua`, `symbiosis.lua`. Their table rows are
  already in the module; the call sites land in round G(a2).
- `bounty_hunts.lua`. Its seven quests are TIER **-1**, which takes groundquests.java's passthrough
  branch and keeps the stored amount — 1000. **The repo's existing 1000 is already correct.** Do
  not change it and do not route it through the module.
- The ten `som_hk_history_*` quests, `som_obi_wan_signal_*`, `som_sceismic_charges`,
  `som_prelude_obiwan_check`, `som_kenobi_samaritan_2`, `som_kenobi_symbiosis_2`: their questlist
  tables carry no LEVEL/TIER columns at all, so passthrough gives 0. Correct as-is.
- `som_kenobi_cursed_shard_1`, `som_kenobi_main_quest_3`, `som_kenobi_main_quest_3_b`: TIER 0, so
  the award is 0 by rule. Correct as-is.
- `som_story_arc_chapter_one_01` / `_02`: TIER -1, amount 0. Correct as-is.

## 7. FENCED — never edit, for any reason

    obi_wan_ghost.lua
    surveyor_jo.lua
    serverobjects.lua      (the retune-fenced one)
    jo_kelsev_conv_handler.lua
    MMOCoreORB/bin/conf/config.lua

## 8. HOUSE RULES

- Lua 5.3. Tabs for indent, matching each file you edit.
- Do not delete a finding to make room for a new one. **Amend it forward.** Every superseded
  sentence keeps its original text plus the correction.
- No `setMaxHAM`/`setHAM`. Not relevant here, but the rule stands.
- Every file you touch must pass `luac5.3 -p`.
- Do not commit. Do not run git.

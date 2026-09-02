--[[
	Mustafar quest XP -- sourced awards for every Mustafar .qst that carries LEVEL/TIER

	WHY THE .qst "Experience Amount 0" IS NOT WHAT LIVE PAID

	Every Mustafar .qst stores Experience Amount 0. SOE's server threw that stored
	amount away and recomputed it from the quest_experience table using the quest's
	own LEVEL and TIER:

	    _dsrc-full/sku.0/sys.server/compiled/game/script/library/groundquests.java:1018
	      experienceAmount = getQuestExperienceReward(player, questLevel, questTier,
	                                                 experienceAmount);

	    groundquests.java:1379-1409
	      if (questLevel < 1 || questTier < 0)  return experienceAmount;  -- passthrough
	      if (questTier == 0)                   return 0;
	      if (questTier > 6)                    questTier = 6;
	      questXp = dataTableGetInt(QUEST_EXPERIENCE_TABLE, "" + questLevel,
	                                tierColumns[questTier-1]);
	      if (questXp > getQuestXpCap(player))  questXp = xpCap;
	      return questXp;

	    groundquests.java:50
	      QUEST_EXPERIENCE_TABLE = "datatables/quest/quest_experience.iff"

	So the award is quest_experience[LEVEL][TIER_n]. Both values are shipped data;
	nothing below is invented. xp in each row is already computed -- do not recompute
	it here. level and tier are carried for the record only.

	PROOF THIS READING IS RIGHT

	Miner Madness (som_poison_miners): questlist LEVEL 70 / TIER 4.
	quest_experience.tab row 70 column TIER_4_EXPERIENCE is 91383. The community
	walkthrough for Miner Madness says 91,383 XP. Exact match, to the digit.

	Skull of the Jundak's walkthrough figure of 78,265 does NOT match: LEVEL 75 /
	TIER 3 gives 86092. 86092 / 78265 = 1.10000. This extract is a very late publish
	and Mustafar shipped at Pub 27, so the table was almost certainly retuned between
	them. Use the table, not the wiki. (Not a proven table-wide 1.1 rescale -- tested
	across all 540 cells and 246 are not integers after dividing by 1.1. This extract
	is later than the wiki capture.)

	XP TYPE -- quest_combat / quest_general MUST NOT BE USED

	SOE's types are quest_combat and quest_general. This server has neither. Passing
	an unknown type is silently destructive: PlayerObjectImplementation.cpp:740-753
	falls through to xpCap = 2000, so the player would receive 2000 XP once and
	nothing ever again. Use combat_general for every award -- the same substitution
	mining_field_markers.lua and map_exploration.lua already ruled for this tree.
	SOE's own type is preserved in soeType and is not used for the call.

	REPEATABLES

	Repeatable quests re-award on every completion. SOE's server recomputed the
	reward on every completion too -- this is faithful, not an oversight.

	WHAT THIS MODULE DELIBERATELY DOES NOT DO

	  * Does not award Kenobi-spine call sites (their rows are here; round G(a2)).
	  * Does not touch bounty_hunts (TIER -1 passthrough keeps the stored 1000).
	  * Does not invent awards for quests with no LEVEL/TIER (passthrough 0).
--]]

MustafarQuestXp = {
	-- combat_general: Core3 has no quest_combat / quest_general. An unknown type
	-- caps at 2000 once (PlayerObjectImplementation.cpp:740-753). See header.
	xpType = "combat_general",

	-- questKey = { xp, level, tier, soeType }
	-- xp is quest_experience[level][tier], already computed.
	quests = {
		som_blackguard_problem           = { xp =  91383, level = 70, tier = 4, soeType = "quest_combat"  },
		-- soeType is blank in the shipped table for this one, not quest_combat.
		-- The column exists; row 3's cell is empty. Recorded as shipped.
		som_blistmok_rug                 = { xp =  59142, level = 65, tier = 3, soeType = ""              },
		-- The seven som_exploration_* area quests (berken, burning, crystal,
		-- mining, smoking, tulrus, volcano) are identical rows (LEVEL 60 / TIER 1
		-- / 319), so they share this one key.
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

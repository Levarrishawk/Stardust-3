--[[
	Myyydril Caverns quest XP -- Mustafar / kashyyyk_quest_xp.lua shape, OURS.

	ruling 2026-09-04

	The ep3_myyydril_*.qst files store Experience Amount 0. SOE threw that
	amount away and recomputed from datatables/quest/quest_experience.iff using
	LEVEL and TIER. This file does the same.

	xp is quest_experience[LEVEL][TIER_n]. xpType is combat_general: Core3 has
	no quest_combat / quest_general.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.
]]

MyyydrilQuestXp = {
	xpType = "combat_general",
	quests = {
		ep3_myyydril_attiera_escort_2          = { xp = 131890, level = 80, tier =  4, soeType = "quest_combat" },
		ep3_myyydril_isdan_retrieve_5          = { xp = 103219, level = 80, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_kallaarac_destroy_2       = { xp = 103219, level = 80, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_kallaarac_destroy_3       = { xp = 136719, level = 81, tier =  4, soeType = "quest_combat" },
		ep3_myyydril_kallaarac_retrieve_1      = { xp = 103219, level = 80, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_kallaarac_talkto_2        = { xp =    193, level = 34, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_kinesworthy_epic_1        = { xp =    347, level = 65, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_kinesworthy_epic_2        = { xp =  59142, level = 65, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_kinesworthy_epic_3        = { xp =  55077, level = 57, tier =  4, soeType = "quest_combat" },
		ep3_myyydril_kirirr_gather_1           = { xp =  17424, level = 37, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_kirrir_talkto_4           = { xp =    204, level = 37, tier =  1, soeType = "" },
		ep3_myyydril_kivvaaa_talkto_1          = { xp =    204, level = 37, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_lorn_retrieve_6           = { xp =      0, level = 80, tier = -1, soeType = "" },
		ep3_myyydril_lorn_talkto               = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_nawika_escort_1           = { xp =    424, level = 78, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_nawika_talkto_5           = { xp =    424, level = 78, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_pers_retrieve_4           = { xp =  18337, level = 38, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_rensalla_1                = { xp =  69355, level = 78, tier =  2, soeType = "quest_combat" },
		ep3_myyydril_talaoree_destroy_1        = { xp =  14850, level = 34, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_talaoree_talkto_3         = { xp =    193, level = 34, tier =  1, soeType = "quest_combat" },
		ep3_myyydril_treesh_craft_1            = { xp =    149, level =  1, tier =  4, soeType = "quest_combat" },
		ep3_myyydril_treesh_gather_2           = { xp = 103219, level = 80, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_yraka_destroyloot_1       = { xp =  18337, level = 38, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_yraka_epic_1              = { xp = 166441, level = 81, tier =  5, soeType = "quest_combat" },
		ep3_myyydril_yraka_retrieve_2          = { xp =  18337, level = 38, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_yraka_retrieve_3          = { xp =  18337, level = 38, tier =  3, soeType = "quest_combat" },
		ep3_myyydril_yraka_talkto_6            = { xp =    209, level = 38, tier =  1, soeType = "quest_combat" },
	},
}

function MyyydrilQuestXp:award(pPlayer, questKey)
	if (pPlayer == nil or questKey == nil) then
		return 0
	end

	local row = self.quests[questKey]

	if (row == nil) then
		printLuaError("MyyydrilQuestXp: no sourced award for quest key '" .. tostring(questKey) .. "'")
		return 0
	end

	if (row.xp > 0) then
		CreatureObject(pPlayer):awardExperience(self.xpType, row.xp, true)
	end

	return row.xp
end

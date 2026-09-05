--[[
	Kashyyyk Kachirho quest XP -- Mustafar shape (mustafar_quest_xp.lua), OURS.

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	The eight ep3_kachirho_*.qst files store Experience Amount 0. SOE threw that
	amount away and recomputed from datatables/quest/quest_experience.iff using
	LEVEL and TIER (see mustafar_quest_xp.lua:1-51). This file does the same.

	xp is quest_experience[LEVEL][TIER_n], already computed from
	datatables/quest/quest_experience.iff.

	xpType is combat_general: Core3 has no quest_combat / quest_general. An unknown
	type caps at 2000 once (PlayerObjectImplementation.cpp:740-753).

	TIER -1 (takook_comm) is a passthrough of the stored amount, which is 0.
]]

KashyyykQuestXp = {
	xpType = "combat_general",

	-- questKey = { xp, level, tier, soeType }
	quests = {
		ep3_kachirho_destroyed_camp        = { xp =  9862, level = 27, tier =  3, soeType = "quest_combat" },
		ep3_kachirho_kill_wke              = { xp =   171, level = 30, tier =  1, soeType = "quest_combat" },
		ep3_kachirho_missing_son           = { xp = 62139, level = 60, tier =  4, soeType = "quest_combat" },
		ep3_kachirho_survey_data           = { xp =  7123, level = 27, tier =  2, soeType = "quest_combat" },
		ep3_kachirho_takook_comm           = { xp =     0, level =  1, tier = -1, soeType = "" },
		ep3_kachirho_trando_rifle_crafting = { xp = 11842, level = 30, tier =  3, soeType = "quest_combat" },
		ep3_kachirho_varactyl_egg          = { xp = 50754, level = 55, tier =  4, soeType = "quest_combat" },
		ep3_kachirho_varactyl_hunt         = { xp =   165, level = 28, tier =  1, soeType = "quest_combat" },
	},
}

function KashyyykQuestXp:award(pPlayer, questKey)
	if (pPlayer == nil or questKey == nil) then
		return 0
	end

	local row = self.quests[questKey]

	if (row == nil) then
		printLuaError("KashyyykQuestXp: no sourced award for quest key '" .. tostring(questKey) .. "'")
		return 0
	end

	if (row.xp > 0) then
		CreatureObject(pPlayer):awardExperience(self.xpType, row.xp, true)
	end

	return row.xp
end

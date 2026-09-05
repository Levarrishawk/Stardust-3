--[[
	Kashyyyk Avatar Platform quest XP -- Mustafar shape (mustafar_quest_xp.lua), OURS.

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	Same table as kashyyyk_quest_xp.lua, local to the Avatar arc so the
	Kachirho XP table is untouched.

	xp is quest_experience[LEVEL][TIER_n], already computed from
	datatables/quest/quest_experience.iff. TIER -1 is a passthrough of the
	stored QUEST_REWARD_EXPERIENCE_AMOUNT.

	xpType is combat_general: Core3 has no quest_combat / quest_general.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_*.qst. Do not call the journal API.
]]

KashyyykAvatarQuestXp = {
	xpType = "combat_general",

	-- questKey = { xp, level, tier, soeType }
	quests = {
		ep3_avatar_boss_taunt      = { xp =      0, level =  0, tier = -1, soeType = "" },
		ep3_avatar_return          = { xp =   1000, level = 85, tier = -1, soeType = "quest_combat" },
		ep3_avatar_security_01     = { xp = 123376, level = 85, tier =  3, soeType = "quest_combat" },
		ep3_avatar_security_02     = { xp =      0, level =  0, tier = -1, soeType = "" },
		ep3_avatar_self_destruct   = { xp = 157647, level = 85, tier =  4, soeType = "quest_combat" },
		ep3_avatar_techhall08      = { xp = 157647, level = 85, tier =  4, soeType = "quest_combat" },
		ep3_avatar_wke_prisoner_01 = { xp =    468, level = 85, tier =  1, soeType = "quest_combat" },
		ep3_avatar_wke_prisoner_02 = { xp =    468, level = 85, tier =  1, soeType = "quest_combat" },
		ep3_avatar_wke_prisoner_03 = { xp =    468, level = 85, tier =  1, soeType = "quest_combat" },
		ep3_avatar_wke_prisoner_04 = { xp =    468, level = 85, tier =  1, soeType = "quest_combat" },
		ep3_avatar_wke_prisoner_05 = { xp =    468, level = 85, tier =  1, soeType = "quest_combat" },
	},
}

function KashyyykAvatarQuestXp:award(pPlayer, questKey)
	if (pPlayer == nil or questKey == nil) then
		return 0
	end

	local row = self.quests[questKey]

	if (row == nil) then
		printLuaError("KashyyykAvatarQuestXp: no sourced award for quest key '" .. tostring(questKey) .. "'")
		return 0
	end

	if (row.xp > 0) then
		CreatureObject(pPlayer):awardExperience(self.xpType, row.xp, true)
	end

	return row.xp
end

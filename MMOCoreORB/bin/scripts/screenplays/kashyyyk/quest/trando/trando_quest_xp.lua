--[[
	Trandoshan / slave-camp / arena quest XP -- Mustafar shape, OURS.

	ruling 2026-09-04

	Extends KashyyykQuestXp.quests. Do not call the journal engine.
]]

do
	local rows = {
		ep3_arena_challenge                    = { xp =      0, level =  0, tier = -1, soeType = "" },
		ep3_slave_camp_control_room_access     = { xp =    473, level = 86, tier =  1, soeType = "quest_combat" },
		ep3_slaver_gursan_entry_quest          = { xp = 185229, level = 84, tier =  5, soeType = "quest_combat" },
		ep3_trando_borantok_01                 = { xp =  11325, level = 35, tier =  2, soeType = "quest_combat" },
		ep3_trando_borantok_02                 = { xp =  11325, level = 35, tier =  2, soeType = "quest_combat" },
		ep3_trando_boshaz_transfer             = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_trando_boshaz_zssik_02             = { xp = 103219, level = 80, tier =  3, soeType = "quest_combat" },
		ep3_trando_dakar_zssik_03              = { xp =  14850, level = 34, tier =  3, soeType = "quest_combat" },
		ep3_trando_harwakokok_zssik_09         = { xp = 110902, level = 82, tier =  3, soeType = "quest_combat" },
		ep3_trando_herald                      = { xp =   1040, level =  5, tier =  3, soeType = "quest_combat" },
		ep3_trando_hssissk_zssik_10            = { xp = 234317, level = 86, tier =  6, soeType = "quest_combat" },
		ep3_trando_jessokk                     = { xp =      0, level =  0, tier = -1, soeType = "" },
		ep3_trando_mololium_zssik_goto         = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_trando_mosolium_transfer           = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_trando_mosolium_zssik_05           = { xp =  32137, level = 50, tier =  3, soeType = "quest_combat" },
		ep3_trando_mosolium_zssik_07           = { xp = 185229, level = 84, tier =  5, soeType = "quest_combat" },
		ep3_trando_olima_grunc                 = { xp =    237, level = 45, tier =  1, soeType = "quest_combat" },
		ep3_trando_orooroo_transfer            = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_trando_orooroo_zssik_08            = { xp =    435, level = 80, tier =  1, soeType = "quest_combat" },
		ep3_trando_ssiksik                     = { xp =  13409, level = 28, tier =  4, soeType = "quest_combat" },
		ep3_trando_tempal_buncho               = { xp =  39721, level = 55, tier =  3, soeType = "quest_combat" },
		ep3_trando_ysith                       = { xp =  18337, level = 38, tier =  3, soeType = "quest_combat" },
		ep3_trando_ysith_reward                = { xp =      0, level =  0, tier = -1, soeType = "" },
	}

	for questKey, row in pairs(rows) do
		KashyyykQuestXp.quests[questKey] = row
	end
end

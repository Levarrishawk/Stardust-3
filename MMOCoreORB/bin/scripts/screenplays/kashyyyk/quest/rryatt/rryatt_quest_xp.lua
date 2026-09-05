--[[
	Kashyyyk Rryatt quest XP -- extends KashyyykQuestXp (mustafar_quest_xp.lua shape, OURS).

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	The ten Rryatt .qst files store Experience Amount 0. SOE threw that amount
	away and recomputed from datatables/quest/quest_experience.iff using LEVEL
	and TIER. Rows below are quest_experience[LEVEL][TIER_n].

	xpType stays combat_general: Core3 has no quest_combat / quest_general.

	NO JOURNAL: do not call the journal engine. The client ships the .qst files.
]]

KashyyykQuestXp.quests.ep3_cheyerooto_5_rrwii_root                    = { xp =  29442, level = 48, tier = 3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_krepauk_kill_walluga_smashers       = { xp =  38093, level = 54, tier = 3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_krepauk_defeat_exjedi               = { xp =  62139, level = 60, tier = 4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_tressk_kill_lost_rodian_hunters     = { xp =  59142, level = 65, tier = 3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_tressk_kill_deep_woods_poachers     = { xp =  59142, level = 65, tier = 3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_trail_mastery                       = { xp =  62178, level = 75, tier = 2, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_krepauk_cleanse_feral_wookiees      = { xp =  99572, level = 79, tier = 3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_krepauk_kill_elite_minstyngar       = { xp = 141708, level = 82, tier = 4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_tressk_kill_gotal_hunters           = { xp = 141708, level = 82, tier = 4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rryatt_krepauk_defeat_katarn               = { xp = 205931, level = 87, tier = 5, soeType = "quest_combat" }

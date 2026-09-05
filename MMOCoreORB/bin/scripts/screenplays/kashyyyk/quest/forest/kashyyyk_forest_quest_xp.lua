--[[
	Kashyyyk Dead Forest quest XP -- Mustafar shape, OURS.

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	Extends KashyyykQuestXp.quests. Do not edit kashyyyk_quest_xp.lua (scope fence).
	xp is quest_experience[LEVEL][TIER_n]. TIER < 1 is a passthrough of 0.
	xpType remains combat_general (Core3 has no quest_combat).
	This arc does not call the Journal API.
]]

KashyyykQuestXp.quests.ep3_forest_adressa_destroy_1 = { xp = 17963, level = 33, tier =  4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_adressa_retrieve_1 = { xp =   187, level = 33, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_adressa_retrieve_2 = { xp =     0, level =  0, tier =  0, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_ardon_assassin = { xp =     0, level =  1, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_ardon_quest_1 = { xp = 19283, level = 39, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_ardon_quest_2 = { xp = 29997, level = 39, tier =  5, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_ardon_quest_3 = { xp =     0, level =  0, tier =  0, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_arena_epic_1 = { xp = 108427, level = 65, tier =  6, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_athnalu_quest_1 = { xp = 14058, level = 33, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_athnalu_quest_2 = { xp = 16533, level = 36, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_aveso_quest_1 = { xp = 14850, level = 34, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_aveso_quest_2 = { xp = 14850, level = 34, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_aveso_quest_3 = { xp = 17424, level = 37, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_cryl_quest_1 = { xp =     0, level = 38, tier =  0, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_cryl_quest_2 = { xp =   209, level = 38, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_dahlia_epic_1 = { xp = 16533, level = 36, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_dahlia_epic_2 = { xp = 18337, level = 38, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_dahlia_epic_3 = { xp =   209, level = 38, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_dahlia_epic_4 = { xp = 24640, level = 39, tier =  4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_assassin = { xp =     0, level =  0, tier =  0, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_1 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_2 = { xp = 20037, level = 35, tier =  4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_3 = { xp = 11325, level = 35, tier =  2, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_4 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_5 = { xp = 24393, level = 35, tier =  5, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_6 = { xp =     0, level = 65, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_kerritamba_epic_7 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_meust_quest_1 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_meust_quest_2 = { xp = 21126, level = 36, tier =  4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_meust_quest_3 = { xp = 16533, level = 36, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_outcast_assassin_2 = { xp =     0, level =  0, tier =  0, soeType = "" }
KashyyykQuestXp.quests.ep3_forest_outcast_contact = { xp =   193, level = 35, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_perusta_quest_1 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_perusta_quest_2 = { xp = 15681, level = 35, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_rhiek_quest_1 = { xp = 12584, level = 37, tier =  2, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_rhiek_quest_2 = { xp = 18337, level = 38, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_rhiek_quest_3 = { xp = 25883, level = 40, tier =  4, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_wirartu_epic_1 = { xp = 91999, level = 65, tier =  5, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_wirartu_epic_2 = { xp =   347, level = 65, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_forest_wirartu_epic_3 = { xp =   347, level = 65, tier =  1, soeType = "quest_combat" }

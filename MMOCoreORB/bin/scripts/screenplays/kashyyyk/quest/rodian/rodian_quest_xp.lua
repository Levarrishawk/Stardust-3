--[[
	Kashyyyk rodian quest XP -- extends KashyyykQuestXp (mustafar_quest_xp.lua shape, OURS).

	ruling 2026-09-04

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
	the .qst; the journal row comes from the integration branch later.

	ep3_rodian_fop_1/2 LEVEL 28 TIER 3 -> quest_experience row 28 TIER_3 = 10494
	ep3_rodian_fop_3 LEVEL 28 TIER 1 -> quest_experience row 28 TIER_1 = 165
	ep3_rodian_hunt_* and ep3_rodian_hunter_* questlist rows carry no LEVEL/TIER
	(same passthrough as kashyyyk_quest_xp.lua takook_comm). xp 0, tier -1.
]]

KashyyykQuestXp.quests.ep3_rodian_fop_1    = { xp = 10494, level = 28, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rodian_fop_2    = { xp = 10494, level = 28, tier =  3, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rodian_fop_3    = { xp =   165, level = 28, tier =  1, soeType = "quest_combat" }
KashyyykQuestXp.quests.ep3_rodian_hunt_1   = { xp =     0, level =  0, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_rodian_hunt_2   = { xp =     0, level =  0, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_rodian_hunt_3   = { xp =     0, level =  0, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_rodian_hunter_1 = { xp =     0, level =  0, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_rodian_hunter_2 = { xp =     0, level =  0, tier = -1, soeType = "" }
KashyyykQuestXp.quests.ep3_rodian_hunter_3 = { xp =     0, level =  0, tier = -1, soeType = "" }

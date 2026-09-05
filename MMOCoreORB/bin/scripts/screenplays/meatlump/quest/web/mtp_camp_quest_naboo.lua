--[[
	mtp camp quest naboo  --  mtp_camp_quest_naboo

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_naboo.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestNabooScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestNabooScreenPlay",
	questName = "mtp_camp_quest_naboo",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_camp_quest_naboo.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	rewardXp = 1000, -- SOURCED questlist/quest/mtp_camp_quest_naboo.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1,2,3 },
			visible = false,
			title = "@quest/ground/mtp_camp_quest_naboo:task00_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_naboo:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "gotoNaboo01",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_naboo:task01_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_naboo:task01_journal_entry_description",
			planet = "naboo",
			x = -5246.0,
			y = 6.0,
			z = 3666.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_naboo:task01_waypoint_name",
		},
		{
			id = 2,
			name = "waitingForNaboo",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoNaboo01", "gotoNaboo02" },
		},
		{
			id = 3,
			name = "gotoNaboo02",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_naboo:task03_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_naboo:task03_journal_entry_description",
			planet = "naboo",
			x = 4637.0,
			y = 6.0,
			z = -5048.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_naboo:task03_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpCampQuestNabooScreenPlay)

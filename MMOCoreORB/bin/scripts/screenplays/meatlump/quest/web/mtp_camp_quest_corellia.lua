--[[
	mtp camp quest corellia  --  mtp_camp_quest_corellia

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_corellia.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestCorelliaScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestCorelliaScreenPlay",
	questName = "mtp_camp_quest_corellia",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_camp_quest_corellia.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	rewardXp = 1000, -- SOURCED questlist/quest/mtp_camp_quest_corellia.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1,2,3,4 },
			visible = false,
			title = "@quest/ground/mtp_camp_quest_corellia:task00_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_corellia:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "gotoCorellia01",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_corellia:task01_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_corellia:task01_journal_entry_description",
			planet = "corellia",
			x = -5699.0,
			y = 46.0,
			z = -2329.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_corellia:task01_waypoint_name",
		},
		{
			id = 2,
			name = "waitingForCorellia",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoCorellia01", "gotoCorellia02", "gotoCorellia03" },
		},
		{
			id = 3,
			name = "gotoCorellia03",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_corellia:task03_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_corellia:task03_journal_entry_description",
			planet = "corellia",
			x = -3942.0,
			y = 21.0,
			z = 3165.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_corellia:task03_waypoint_name",
		},
		{
			id = 4,
			name = "gotoCorellia02",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_corellia:task04_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_corellia:task04_journal_entry_description",
			planet = "corellia",
			x = 3619.0,
			y = 428.0,
			z = 5817.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_corellia:task04_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpCampQuestCorelliaScreenPlay)

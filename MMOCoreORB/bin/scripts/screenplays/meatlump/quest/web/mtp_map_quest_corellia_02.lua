--[[
	mtp map quest corellia 02  --  mtp_map_quest_corellia_02

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_map_quest_corellia_02.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpMapQuestCorellia02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpMapQuestCorellia02ScreenPlay",
	questName = "mtp_map_quest_corellia_02",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "nothingTask",
			type = "nothing",
			onComplete = { 1,2 },
			visible = false,
			title = "@quest/ground/mtp_map_quest_corellia_02:task00_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_corellia_02:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "waitForPlayerCorellia",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoCorellia" },
		},
		{
			id = 2,
			name = "gotoCorellia",
			type = "go_to_location",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_map_quest_corellia_02:task02_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_corellia_02:task02_journal_entry_description",
			planet = "corellia",
			x = -5290.0,
			y = 21.0,
			z = -2372.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_map_quest_corellia_02:task02_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpMapQuestCorellia02ScreenPlay)

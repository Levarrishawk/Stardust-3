--[[
	mtp map quest naboo 03  --  mtp_map_quest_naboo_03

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_map_quest_naboo_03.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpMapQuestNaboo03ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpMapQuestNaboo03ScreenPlay",
	questName = "mtp_map_quest_naboo_03",
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
			title = "@quest/ground/mtp_map_quest_naboo_03:task00_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_naboo_03:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "waitForPlayerNaboo",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoNaboo" },
		},
		{
			id = 2,
			name = "gotoNaboo",
			type = "go_to_location",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_map_quest_naboo_03:task02_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_naboo_03:task02_journal_entry_description",
			planet = "naboo",
			x = -5904.0,
			y = 6.0,
			z = 4278.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_map_quest_naboo_03:task02_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpMapQuestNaboo03ScreenPlay)

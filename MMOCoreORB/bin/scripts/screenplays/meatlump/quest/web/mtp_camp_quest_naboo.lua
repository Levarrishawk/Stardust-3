--[[
	mtp camp quest naboo  --  mtp_camp_quest_naboo

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_naboo.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestNabooScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestNabooScreenPlay",
	questName = "mtp_camp_quest_naboo",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
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

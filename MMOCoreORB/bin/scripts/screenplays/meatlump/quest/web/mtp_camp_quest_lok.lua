--[[
	mtp camp quest lok  --  mtp_camp_quest_lok

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_lok.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestLokScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestLokScreenPlay",
	questName = "mtp_camp_quest_lok",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1,2 },
			visible = false,
			title = "@quest/ground/mtp_camp_quest_lok:task00_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_lok:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "gotoLok",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_lok:task01_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_lok:task01_journal_entry_description",
			planet = "lok",
			x = 277.0,
			y = 12.0,
			z = 4644.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_lok:task01_waypoint_name",
		},
		{
			id = 2,
			name = "waitingForLok",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoLok" },
		},
	},
}

MtpQuestEngine.install(mtpCampQuestLokScreenPlay)

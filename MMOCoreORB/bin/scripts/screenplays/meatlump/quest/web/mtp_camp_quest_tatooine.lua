--[[
	mtp camp quest tatooine  --  mtp_camp_quest_tatooine

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_tatooine.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestTatooineScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestTatooineScreenPlay",
	questName = "mtp_camp_quest_tatooine",
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
			title = "@quest/ground/mtp_camp_quest_tatooine:task00_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_tatooine:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "gotoTatooine01",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_tatooine:task01_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_tatooine:task01_journal_entry_description",
			planet = "tatooine",
			x = 3960.0,
			y = 9.0,
			z = 2422.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_tatooine:task01_waypoint_name",
		},
		{
			id = 2,
			name = "waitingForTatooine",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoTatooine01", "gotoTatooine02" },
		},
		{
			id = 3,
			name = "gotoTatooine02",
			type = "go_to_location",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_tatooine:task03_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_tatooine:task03_journal_entry_description",
			planet = "tatooine",
			x = -5219.0,
			y = 75.0,
			z = -6774.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_tatooine:task03_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpCampQuestTatooineScreenPlay)

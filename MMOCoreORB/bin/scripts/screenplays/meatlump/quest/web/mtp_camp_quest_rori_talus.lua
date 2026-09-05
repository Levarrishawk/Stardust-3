--[[
	mtp camp quest rori talus  --  mtp_camp_quest_rori_talus

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_rori_talus.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestRoriTalusScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestRoriTalusScreenPlay",
	questName = "mtp_camp_quest_rori_talus",
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
			title = "@quest/ground/mtp_camp_quest_rori_talus:task00_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_rori_talus:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "gotoTalus",
			type = "go_to_location",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_rori_talus:task01_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_rori_talus:task01_journal_entry_description",
			planet = "talus",
			x = 3964.0,
			y = 2.0,
			z = 5076.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_rori_talus:task01_waypoint_name",
		},
		{
			id = 2,
			name = "gotoRori",
			type = "go_to_location",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_camp_quest_rori_talus:task02_journal_entry_title",
			description = "@quest/ground/mtp_camp_quest_rori_talus:task02_journal_entry_description",
			planet = "rori",
			x = -5164.0,
			y = 80.0,
			z = -2543.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_camp_quest_rori_talus:task02_waypoint_name",
		},
		{
			id = 3,
			name = "waitingForRoriTalus",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoRori", "gotoTalus" },
		},
	},
}

MtpQuestEngine.install(mtpCampQuestRoriTalusScreenPlay)

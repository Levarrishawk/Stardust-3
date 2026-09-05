--[[
	mtp map quest talus 01  --  mtp_map_quest_talus_01

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_map_quest_talus_01.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpMapQuestTalus01ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpMapQuestTalus01ScreenPlay",
	questName = "mtp_map_quest_talus_01",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_map_quest_talus_01.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	rewardXp = 1000, -- SOURCED questlist/quest/mtp_map_quest_talus_01.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "nothingTask",
			type = "nothing",
			onComplete = { 1,2 },
			visible = false,
			title = "@quest/ground/mtp_map_quest_talus_01:task00_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_talus_01:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "waitForPlayerTalus",
			type = "wait_for_tasks",
			onComplete = {  },
			visible = false,
			watches = { "gotoTalus" },
		},
		{
			id = 2,
			name = "gotoTalus",
			type = "go_to_location",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_map_quest_talus_01:task02_journal_entry_title",
			description = "@quest/ground/mtp_map_quest_talus_01:task02_journal_entry_description",
			planet = "talus",
			x = 4019.0,
			y = 2.0,
			z = 5244.0,
			radius = 32,
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
			waypointName = "@quest/ground/mtp_map_quest_talus_01:task02_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpMapQuestTalus01ScreenPlay)

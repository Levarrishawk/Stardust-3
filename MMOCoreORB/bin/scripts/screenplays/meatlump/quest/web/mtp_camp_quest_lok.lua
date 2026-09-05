--[[
	mtp camp quest lok  --  mtp_camp_quest_lok

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_camp_quest_lok.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). go_to_location is implemented in MtpWebTasks (active area); not in MtpQuestEngine. Task types: go_to_location, nothing, wait_for_tasks.
]]

mtpCampQuestLokScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCampQuestLokScreenPlay",
	questName = "mtp_camp_quest_lok",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_camp_quest_lok.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	rewardXp = 1000, -- SOURCED questlist/quest/mtp_camp_quest_lok.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=1000
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
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

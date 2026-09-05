--[[
	mtp find infiltrator 1  --  mtp_find_infiltrator_1

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_find_infiltrator_1.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Lumps are SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client). Task types: nothing, wait_for_signal, wait_for_tasks.
]]

mtpFindInfiltrator1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpFindInfiltrator1ScreenPlay",
	questName = "mtp_find_infiltrator_1",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_find_infiltrator_1.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=2500
	rewardXp = 2500, -- SOURCED questlist/quest/mtp_find_infiltrator_1.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=2500
	lumpCount = 5, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
			title = "@quest/ground/mtp_find_infiltrator_1:task00_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_1:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "findInfiltrator",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = false,
			title = "@quest/ground/mtp_find_infiltrator_1:task01_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_1:task01_journal_entry_description",
			signal = "findTheInfiltrator",
		},
		{
			id = 2,
			name = "waitingForInfiltrator",
			type = "wait_for_tasks",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_find_infiltrator_1:task02_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_1:task02_journal_entry_description",
			watches = { "findInfiltrator" },
		},
		{
			id = 3,
			name = "returnToLocksmith",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_find_infiltrator_1:task03_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_1:task03_journal_entry_description",
			signal = "returnedToMeatlumpLocksmith",
		},
	},
}

MtpQuestEngine.install(mtpFindInfiltrator1ScreenPlay)

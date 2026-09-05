--[[
	mtp find infiltrator 4  --  mtp_find_infiltrator_4

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_find_infiltrator_4.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. item_meatlump_lump_01_01 x5 is OPEN (token currency not in the fork). Task types: nothing, wait_for_signal, wait_for_tasks.
]]

mtpFindInfiltrator4ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpFindInfiltrator4ScreenPlay",
	questName = "mtp_find_infiltrator_4",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 5, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
			title = "@quest/ground/mtp_find_infiltrator_4:task00_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_4:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "findInfiltrator",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = false,
			title = "@quest/ground/mtp_find_infiltrator_4:task01_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_4:task01_journal_entry_description",
			signal = "findTheInfiltrator",
		},
		{
			id = 2,
			name = "waitingForInfiltrator",
			type = "wait_for_tasks",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_find_infiltrator_4:task02_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_4:task02_journal_entry_description",
			watches = { "findInfiltrator" },
		},
		{
			id = 3,
			name = "returnToLocksmith",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_find_infiltrator_4:task03_journal_entry_title",
			description = "@quest/ground/mtp_find_infiltrator_4:task03_journal_entry_description",
			signal = "returnedToMeatlumpLocksmith",
		},
	},
}

MtpQuestEngine.install(mtpFindInfiltrator4ScreenPlay)

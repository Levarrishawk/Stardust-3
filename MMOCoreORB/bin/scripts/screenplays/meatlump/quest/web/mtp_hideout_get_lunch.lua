--[[
	mtp hideout get lunch  --  mtp_hideout_get_lunch

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_get_lunch.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. item_meatlump_lump_01_01 x5 is OPEN (token currency not in the fork). Task types: nothing, wait_for_signal.
]]

mtpHideoutGetLunchScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutGetLunchScreenPlay",
	questName = "mtp_hideout_get_lunch",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 5, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "nothingTask",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
		},
		{
			id = 1,
			name = "findFood",
			type = "wait_for_signal",
			onComplete = {  },
			visible = false,
			title = "@quest/ground/mtp_hideout_get_lunch:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_get_lunch:task01_journal_entry_description",
			signal = "foundMeatlumps",
		},
	},
}

MtpQuestEngine.install(mtpHideoutGetLunchScreenPlay)

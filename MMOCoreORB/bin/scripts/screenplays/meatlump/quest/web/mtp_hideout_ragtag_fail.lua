--[[
	mtp hideout ragtag fail  --  mtp_hideout_ragtag_fail

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_ragtag_fail.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. Task types: nothing, wait_for_signal.
]]

mtpHideoutRagtagFailScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutRagtagFailScreenPlay",
	questName = "mtp_hideout_ragtag_fail",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "nothingTask",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
			title = "@quest/ground/mtp_hideout_ragtag_fail:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag_fail:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "failedBeatUp",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag_fail:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag_fail:task01_journal_entry_description",
			signal = "beatUpComplete",
		},
	},
}

MtpQuestEngine.install(mtpHideoutRagtagFailScreenPlay)

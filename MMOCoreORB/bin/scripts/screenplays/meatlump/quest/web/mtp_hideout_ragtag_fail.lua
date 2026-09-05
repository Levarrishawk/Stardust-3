--[[
	mtp hideout ragtag fail  --  mtp_hideout_ragtag_fail

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_ragtag_fail.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Task types: nothing, wait_for_signal.
]]

mtpHideoutRagtagFailScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutRagtagFailScreenPlay",
	questName = "mtp_hideout_ragtag_fail",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_ragtag_fail.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_ragtag_fail.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
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

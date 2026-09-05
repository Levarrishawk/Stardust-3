--[[
	mtp hideout get lunch  --  mtp_hideout_get_lunch

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_get_lunch.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Lumps are SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client). Task types: nothing, wait_for_signal.
]]

mtpHideoutGetLunchScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutGetLunchScreenPlay",
	questName = "mtp_hideout_get_lunch",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_get_lunch.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_get_lunch.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 5, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
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

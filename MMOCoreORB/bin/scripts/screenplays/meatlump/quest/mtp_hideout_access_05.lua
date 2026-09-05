--[[
	mtp hideout access 05  --  mtp_hideout_access_05

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_05. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Lumps are SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client). Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutAccess05ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess05ScreenPlay",
	questName = "mtp_hideout_access_05",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_access_05.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_access_05.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 2, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_05_01",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_05:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_05:task00_journal_entry_description",
			signal = "mtp_hideout_access_05_01",
		},
		{
			id = 1,
			name = "mtp_hideout_access_05_02",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_05:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_05:task01_journal_entry_description",
			signal = "mtp_hideout_access_05_02",
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess05ScreenPlay)


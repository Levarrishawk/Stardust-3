--[[
	mtp hideout access 05  --  mtp_hideout_access_05

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_05. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	item_meatlump_lump_01_01 x2 is OPEN (token currency not in the fork). Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccess05ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess05ScreenPlay",
	questName = "mtp_hideout_access_05",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 2, -- OPEN: item_meatlump_lump_01_01 is not in the fork
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


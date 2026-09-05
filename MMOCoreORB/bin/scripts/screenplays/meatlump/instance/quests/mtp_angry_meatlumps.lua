--[[
	mtp angry meatlumps  --  mtp_angry_meatlumps

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_angry_meatlumps. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpAngryMeatlumpsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpAngryMeatlumpsScreenPlay",
	questName = "mtp_angry_meatlumps",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 5, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "angry_meatlumps_01",
			type = "destroy_multi",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_angry_meatlumps:task00_journal_entry_title",
			description = "@quest/ground/mtp_angry_meatlumps:task00_journal_entry_description",
			count = 12,
			target = "mtp_angry_meatlump",
			mapped = "", -- OPEN: no repo template for mtp_angry_meatlump
		},
		{
			id = 1,
			name = "angry_meatlumps_02",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_angry_meatlumps:task01_journal_entry_title",
			description = "@quest/ground/mtp_angry_meatlumps:task01_journal_entry_description",
			signal = "angry_meatlumps_02",
		},
	},
}

MtpQuestEngine.install(mtpAngryMeatlumpsScreenPlay)

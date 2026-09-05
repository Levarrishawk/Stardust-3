--[[
	mtp angry meatlumps  --  mtp_angry_meatlumps

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_angry_meatlumps. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpAngryMeatlumpsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpAngryMeatlumpsScreenPlay",
	questName = "mtp_angry_meatlumps",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_angry_meatlumps.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_angry_meatlumps.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 5, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
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
			mapped = "mtp_angry_meatlump", -- SOURCED creatures.tab:6037 mtp_angry_meatlump base meatlump_hideout_thug
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

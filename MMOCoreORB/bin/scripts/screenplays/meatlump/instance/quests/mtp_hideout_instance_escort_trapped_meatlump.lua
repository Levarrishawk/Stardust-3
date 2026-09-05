--[[
	mtp hideout instance escort trapped meatlump  --  mtp_hideout_instance_escort_trapped_meatlump

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_escort_trapped_meatlump. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutInstanceEscortTrappedMeatlumpScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceEscortTrappedMeatlumpScreenPlay",
	questName = "mtp_hideout_instance_escort_trapped_meatlump",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_instance_escort_trapped_meatlump.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_instance_escort_trapped_meatlump.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "gotoInstance",
			type = "wait_for_signal",
			onComplete = { 1,3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task00_journal_entry_description",
			signal = "mtp_escort_trapped_meatlump",
		},
		{
			id = 1,
			name = "escort_trapped_meatlump",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task01_journal_entry_description",
			signal = "escort_trapped_meatlump",
		},
		{
			id = 2,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_escort_trapped_meatlump_success",
		},
		{
			id = 3,
			name = "mtp_quest_timer",
			type = "timer",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:task03_journal_entry_description",
			minTime = 585,
		},
		{
			id = 4,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_escort_trapped_meatlump_fail",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceEscortTrappedMeatlumpScreenPlay)

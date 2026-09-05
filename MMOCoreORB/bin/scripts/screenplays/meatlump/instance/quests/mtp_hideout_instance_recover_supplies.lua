--[[
	mtp hideout instance recover supplies  --  mtp_hideout_instance_recover_supplies

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_recover_supplies. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutInstanceRecoverSuppliesScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceRecoverSuppliesScreenPlay",
	questName = "mtp_hideout_instance_recover_supplies",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_instance_recover_supplies.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_instance_recover_supplies.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "gotoInstance",
			type = "wait_for_signal",
			onComplete = { 1,3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_recover_supplies:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_recover_supplies:task00_journal_entry_description",
			signal = "mtp_recover_supplies",
		},
		{
			id = 1,
			name = "find_supplies",
			type = "retrieve_item",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_recover_supplies:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_recover_supplies:task01_journal_entry_description",
			item = "object/tangible/meatlump/hideout/mtp_hideout_instance_supplies.iff",
			retrieveText = "@quest/ground/mtp_hideout_instance_recover_supplies:task01_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_instance_recover_supplies:task01_item_name",
			count = 14,
		},
		{
			id = 2,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_recover_supplies_success",
		},
		{
			id = 3,
			name = "mtp_quest_timer",
			type = "timer",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_recover_supplies:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_recover_supplies:task03_journal_entry_description",
			minTime = 585,
		},
		{
			id = 4,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_recover_supplies_fail",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceRecoverSuppliesScreenPlay)

--[[
	mtp hideout access high 01  --  mtp_hideout_access_high_01

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_high_01. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	TASK_NAME and SIGNAL_NAME reuse the base names. TIER_LEVEL = 82 is OURS-pending. Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutAccessHigh01ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccessHigh01ScreenPlay",
	questName = "mtp_hideout_access_high_01",
	repeatable = false,
	rewardCredits = 8956, -- SOURCED questlist/quest/mtp_hideout_access_high_01.tab QUEST_REWARD_BANK_CREDITS=8956 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_access_high_01.tab QUEST_REWARD_BANK_CREDITS=8956 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_01_01",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task00_journal_entry_description",
			signal = "mtp_hideout_access_01_01",
			planet = "corellia",
			x = -597.0,
			y = 24.0,
			z = -3927.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_01:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_01_02",
			type = "retrieve_item",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task01_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest01_datapad.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_high_01:task01_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_high_01:task01_item_name",
			count = 1,
			planet = "corellia",
			x = -597.0,
			y = 24.0,
			z = -3927.0,
			spawnInherited = true,
		},
		{
			id = 2,
			name = "mtp_hideout_access_01_03",
			type = "show_message_box",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task02_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_high_01:task02_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_high_01:task02_message_box_text",
		},
		{
			id = 3,
			name = "mtp_hideout_access_01_04",
			type = "retrieve_item",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task03_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest01_crated_bomb.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_high_01:task03_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_high_01:task03_item_name",
			count = 9,
			planet = "corellia",
			x = -597.0,
			y = 24.0,
			z = -3927.0,
			spawnInherited = true,
		},
		{
			id = 4,
			name = "mtp_hideout_access_01_05",
			type = "show_message_box",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task04_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_high_01:task04_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_high_01:task04_message_box_text",
		},
		{
			id = 5,
			name = "mtp_hideout_access_01_06",
			type = "destroy_multi",
			onComplete = { 6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task05_journal_entry_description",
			count = 1,
			target = "mtp_quest_crate_breaker_high",
			mapped = "mtp_quest_crate_breaker",
			planet = "corellia",
			x = 104.0,
			y = 16.0,
			z = 1700.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_01:task05_waypoint_name",
		},
		{
			id = 6,
			name = "mtp_hideout_access_01_07",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_01:task06_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_01:task06_journal_entry_description",
			signal = "mtp_hideout_access_01_07",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_01:task06_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccessHigh01ScreenPlay)


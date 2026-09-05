--[[
	mtp hideout access 01  --  mtp_hideout_access_01

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_01. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccess01ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess01ScreenPlay",
	questName = "mtp_hideout_access_01",
	repeatable = false,
	rewardCredits = 6492, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_01_01",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_01:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task00_journal_entry_description",
			signal = "mtp_hideout_access_01_01",
			planet = "corellia",
			x = -597.0,
			y = 24.0,
			z = -3927.0,
			waypointName = "@quest/ground/mtp_hideout_access_01:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_01_02",
			type = "retrieve_item",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_01:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task01_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest01_datapad.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_01:task01_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_01:task01_item_name",
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
			title = "@quest/ground/mtp_hideout_access_01:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task02_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_01:task02_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_01:task02_message_box_text",
		},
		{
			id = 3,
			name = "mtp_hideout_access_01_04",
			type = "retrieve_item",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_01:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task03_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest01_crated_bomb.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_01:task03_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_01:task03_item_name",
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
			title = "@quest/ground/mtp_hideout_access_01:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task04_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_01:task04_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_01:task04_message_box_text",
		},
		{
			id = 5,
			name = "mtp_hideout_access_01_06",
			type = "destroy_multi",
			onComplete = { 6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_01:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task05_journal_entry_description",
			count = 1,
			target = "mtp_quest_crate_breaker",
			mapped = "mtp_quest_crate_breaker",
			planet = "corellia",
			x = -1914.0,
			y = 20.0,
			z = -125.0,
			waypointName = "@quest/ground/mtp_hideout_access_01:task05_waypoint_name",
		},
		{
			id = 6,
			name = "mtp_hideout_access_01_07",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_01:task06_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_01:task06_journal_entry_description",
			signal = "mtp_hideout_access_01_07",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_01:task06_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess01ScreenPlay)


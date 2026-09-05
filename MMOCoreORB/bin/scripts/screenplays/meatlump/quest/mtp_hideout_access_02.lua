--[[
	mtp hideout access 02  --  mtp_hideout_access_02

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_02. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccess02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess02ScreenPlay",
	questName = "mtp_hideout_access_02",
	repeatable = false,
	rewardCredits = 6487, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_02_01",
			type = "wait_for_signal",
			onComplete = { 1,4,5,6,7 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_02:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task00_journal_entry_description",
			signal = "mtp_hideout_access_02_01",
			planet = "corellia",
			x = -6152.0,
			y = 29.0,
			z = -2004.0,
			waypointName = "@quest/ground/mtp_hideout_access_02:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_02_02",
			type = "wait_for_tasks",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_02:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task01_journal_entry_description",
			watches = { "mtp_hideout_access_02_02a", "mtp_hideout_access_02_02b", "mtp_hideout_access_02_02c", "mtp_hideout_access_02_02d" },
		},
		{
			id = 2,
			name = "mtp_hideout_access_02_03",
			type = "wait_for_signal",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_02:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task02_journal_entry_description",
			signal = "mtp_hideout_access_02_03",
		},
		{
			id = 3,
			name = "mtp_hideout_access_02_04",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_02:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task03_journal_entry_description",
			signal = "mtp_hideout_access_02_04",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_02:task03_waypoint_name",
		},
		{
			id = 4,
			name = "mtp_hideout_access_02_02d",
			type = "retrieve_item",
			onComplete = {  },
			visible = false,
			title = "@quest/ground/mtp_hideout_access_02:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task04_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest02_droid04.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_02:task04_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_02:task04_item_name",
			count = 1,
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			spawnInherited = true,
		},
		{
			id = 5,
			name = "mtp_hideout_access_02_02c",
			type = "retrieve_item",
			onComplete = {  },
			visible = false,
			title = "@quest/ground/mtp_hideout_access_02:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task05_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest02_droid03.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_02:task05_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_02:task05_item_name",
			count = 1,
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			spawnInherited = true,
		},
		{
			id = 6,
			name = "mtp_hideout_access_02_02b",
			type = "retrieve_item",
			onComplete = {  },
			visible = false,
			title = "@quest/ground/mtp_hideout_access_02:task06_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task06_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest02_droid02.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_02:task06_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_02:task06_item_name",
			count = 1,
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			spawnInherited = true,
		},
		{
			id = 7,
			name = "mtp_hideout_access_02_02a",
			type = "retrieve_item",
			onComplete = {  },
			visible = false,
			title = "@quest/ground/mtp_hideout_access_02:task07_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_02:task07_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest02_droid01.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_02:task07_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_02:task07_item_name",
			count = 1,
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			spawnInherited = true,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess02ScreenPlay)


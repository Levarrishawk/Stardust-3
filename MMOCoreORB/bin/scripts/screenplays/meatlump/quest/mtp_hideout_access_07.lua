--[[
	mtp hideout access 07  --  mtp_hideout_access_07

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_07. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	t7 retrieve_item _07_02a is activated by t0 but t1 watches only _02b/_02c. Dangling as shipped. item_meatlump_lump_01_01 x11 is OPEN (token currency not in the fork). Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccess07ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess07ScreenPlay",
	questName = "mtp_hideout_access_07",
	repeatable = false,
	rewardCredits = 6549, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 11, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_07_01",
			type = "retrieve_item",
			onComplete = { 1,5,6,7 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task00_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest07_plans.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_07:task00_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_07:task00_item_name",
			count = 1,
			planet = "corellia",
			x = -4437.0,
			y = 0,
			z = 3501.0,
			waypointName = "@quest/ground/mtp_hideout_access_07:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_07_02",
			type = "wait_for_tasks",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task01_journal_entry_description",
			watches = { "mtp_hideout_access_07_02b", "mtp_hideout_access_07_02c" },
			planet = "rori",
			x = 6126.0,
			y = 77.0,
			z = -2012.0,
			waypointName = "@quest/ground/mtp_hideout_access_07:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_07_03",
			type = "wait_for_signal",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task02_journal_entry_description",
			signal = "mtp_hideout_access_07_03",
			planet = "corellia",
			x = -277.0,
			y = 28.0,
			z = -4144.0,
			waypointName = "@quest/ground/mtp_hideout_access_07:task02_waypoint_name",
		},
		{
			id = 3,
			name = "mtp_hideout_access_07_04",
			type = "wait_for_signal",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task03_journal_entry_description",
			signal = "mtp_hideout_access_07_04",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_07:task03_waypoint_name",
		},
		{
			id = 4,
			name = "",
			type = "complete_quest",
			onComplete = {  },
			visible = false,
		},
		{
			id = 5,
			name = "mtp_hideout_access_07_02c",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task05_journal_entry_description",
			count = 11,
			target = "mtp_quest_stephax_meatlump",
			mapped = "meatlump_stooge",
			planet = "rori",
			x = 6126.0,
			y = 77.0,
			z = -2012.0,
			spawnInherited = true,
		},
		{
			id = 6,
			name = "mtp_hideout_access_07_02b",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_07:task06_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_07:task06_journal_entry_description",
			count = 1,
			target = "mtp_quest_stephax_dain",
			mapped = "meatlump_loon",
			planet = "rori",
			x = 6126.0,
			y = 77.0,
			z = -2012.0,
			spawnInherited = true,
		},
		{
			id = 7,
			name = "mtp_hideout_access_07_02a",
			type = "retrieve_item",
			onComplete = {  },
			visible = false,
			item = "object/tangible/quest/meatlump/mtp_hideout_quest07_databank.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_07:task07_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_07:task07_item_name",
			count = 11,
			planet = "rori",
			x = 6126.0,
			y = 77.0,
			z = -2012.0,
			spawnInherited = true,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess07ScreenPlay)


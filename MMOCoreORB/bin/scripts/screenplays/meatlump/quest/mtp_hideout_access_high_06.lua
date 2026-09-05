--[[
	mtp hideout access high 06  --  mtp_hideout_access_high_06

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_high_06. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	TASK_NAME and SIGNAL_NAME reuse the base names. TIER_LEVEL = 82 is OURS-pending. item_meatlump_lump_01_01 x7 is OPEN (token currency not in the fork). Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccessHigh06ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccessHigh06ScreenPlay",
	questName = "mtp_hideout_access_high_06",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 7, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_06_00",
			type = "nothing",
			onComplete = { 1,3,4 },
			visible = false,
		},
		{
			id = 1,
			name = "mtp_hideout_access_06_01",
			type = "wait_for_tasks",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_06:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_06:task01_journal_entry_description",
			watches = { "mtp_hideout_access_06_01a", "mtp_hideout_access_06_01b" },
			planet = "corellia",
			x = -7167.0,
			y = 72.0,
			z = 140.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_06:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_06_02",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_06:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_06:task02_journal_entry_description",
			signal = "mtp_hideout_access_06_02",
			planet = "corellia",
			x = -277.0,
			y = 28.0,
			z = -4144.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_06:task02_waypoint_name",
		},
		{
			id = 3,
			name = "mtp_hideout_access_06_01b",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_06:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_06:task03_journal_entry_description",
			count = 1,
			target = "mtp_quest_rogue_corsec_02_high",
			mapped = "corsec_traitor",
			planet = "corellia",
			x = -7167.0,
			y = 72.0,
			z = 140.0,
			spawnInherited = true,
		},
		{
			id = 4,
			name = "mtp_hideout_access_06_01a",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_06:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_06:task04_journal_entry_description",
			count = 1,
			target = "mtp_quest_rogue_corsec_01_high",
			mapped = "mercenary_destroyer",
			planet = "corellia",
			x = -7167.0,
			y = 72.0,
			z = 140.0,
			spawnInherited = true,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccessHigh06ScreenPlay)


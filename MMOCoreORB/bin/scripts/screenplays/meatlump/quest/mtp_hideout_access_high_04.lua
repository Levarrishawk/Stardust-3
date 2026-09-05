--[[
	mtp hideout access high 04  --  mtp_hideout_access_high_04

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_high_04. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	TASK_NAME and SIGNAL_NAME reuse the base names. TIER_LEVEL = 82 is OURS-pending. item_meatlump_lump_01_01 x9 is OPEN (token currency not in the fork). Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccessHigh04ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccessHigh04ScreenPlay",
	questName = "mtp_hideout_access_high_04",
	repeatable = false,
	rewardCredits = 8963, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 9, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_04_00",
			type = "nothing",
			onComplete = { 1,7,8 },
			visible = false,
		},
		{
			id = 1,
			name = "mtp_hideout_access_04_01",
			type = "wait_for_tasks",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task01_journal_entry_description",
			watches = { "mtp_hideout_access_04_01a", "mtp_hideout_access_04_01b" },
			planet = "corellia",
			x = 7378.0,
			y = 307.0,
			z = 6937.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_04:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_04_02",
			type = "retrieve_item",
			onComplete = { 3,6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task02_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest04_stash.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_high_04:task02_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_high_04:task02_item_name",
			count = 1,
			planet = "corellia",
			x = 7378.0,
			y = 307.0,
			z = 6937.0,
			spawnInherited = true,
		},
		{
			id = 3,
			name = "mtp_hideout_access_04_03",
			type = "wait_for_signal",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task03_journal_entry_description",
			signal = "mtp_hideout_access_04_03",
		},
		{
			id = 4,
			name = "mtp_hideout_access_04_04",
			type = "wait_for_signal",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task04_journal_entry_description",
			signal = "mtp_hideout_access_04_04",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_04:task04_waypoint_name",
		},
		{
			id = 5,
			name = "mtp_hideout_access_04_05",
			type = "complete_quest",
			onComplete = {  },
			visible = false,
		},
		{
			id = 6,
			name = "mtp_hideout_access_04_03a",
			type = "wave_event_player",
			onComplete = {  },
			visible = false,
			item = "object/tangible/quest/meatlump/mtp_hideout_quest03_radio.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_high_04:task06_retrieve_menu_text",
			waveTarget = "mtp_quest_strilath_farles_convo",
			waveMapped = "dressed_meatlump_male_01",
			waveDelay = 2,
			waveRadius = 3.0,
			startMessage = "@quest/ground/mtp_hideout_access_high_04:task06_start_message",
			utterance = "@quest/ground/mtp_hideout_access_high_04:task06_utterance_wave_1",
		},
		{
			id = 7,
			name = "mtp_hideout_access_04_01b",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task07_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task07_journal_entry_description",
			count = 13,
			target = "mtp_quest_farles_ragtag_high",
			mapped = "meatlump_clod",
			planet = "corellia",
			x = 7378.0,
			y = 307.0,
			z = 6937.0,
			spawnInherited = true,
		},
		{
			id = 8,
			name = "mtp_hideout_access_04_01a",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_04:task08_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_04:task08_journal_entry_description",
			count = 1,
			target = "mtp_quest_farles_ragtag_leader_high",
			mapped = "meatlump_loon",
			planet = "corellia",
			x = 7378.0,
			y = 307.0,
			z = 6937.0,
			spawnInherited = true,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccessHigh04ScreenPlay)


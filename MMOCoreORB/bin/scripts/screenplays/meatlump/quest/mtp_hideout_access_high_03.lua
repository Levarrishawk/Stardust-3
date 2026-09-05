--[[
	mtp hideout access high 03  --  mtp_hideout_access_high_03

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_high_03. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	TASK_NAME and SIGNAL_NAME reuse the base names. TIER_LEVEL = 82 is OURS-pending. Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutAccessHigh03ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccessHigh03ScreenPlay",
	questName = "mtp_hideout_access_high_03",
	repeatable = false,
	rewardCredits = 8997, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_03_01",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_03:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_03:task00_journal_entry_description",
			signal = "mtp_hideout_access_03_01",
			planet = "talus",
			x = 834.0,
			y = 6.0,
			z = -3178.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_03:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_03_02",
			type = "destroy_multi",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_03:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_03:task01_journal_entry_description",
			count = 11,
			target = "mtp_quest_farles_meatlump_high",
			mapped = "meatlump_stooge",
			planet = "endor",
			x = 1190.0,
			y = 10.0,
			z = 1926.0,
			waypointName = "@quest/ground/mtp_hideout_access_high_03:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_03_03",
			type = "show_message_box",
			onComplete = { 3,4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_03:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_03:task02_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_high_03:task02_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_high_03:task02_message_box_text",
		},
		{
			id = 3,
			name = "mtp_hideout_access_03_03a",
			type = "wave_event_player",
			onComplete = {  },
			visible = false,
			item = "object/tangible/quest/meatlump/mtp_hideout_quest03_radio.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_high_03:task03_retrieve_menu_text",
			waveTarget = "mtp_quest_strilath_farles_high",
			waveMapped = "dressed_meatlump_merkie_howzat",
			waveDelay = 3,
			waveRadius = 3.0,
			startMessage = "@quest/ground/mtp_hideout_access_high_03:task03_start_message",
			utterance = "@quest/ground/mtp_hideout_access_high_03:task03_utterance_wave_1",
		},
		{
			id = 4,
			name = "mtp_hideout_access_03_04",
			type = "wait_for_signal",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_high_03:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_high_03:task04_journal_entry_description",
			signal = "mtp_hideout_access_03_04",
		},
		{
			id = 5,
			name = "mtp_hideout_access_03_05",
			type = "complete_quest",
			onComplete = {  },
			visible = false,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccessHigh03ScreenPlay)


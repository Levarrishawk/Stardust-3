--[[
	mtp hideout ragtag  --  mtp_hideout_ragtag

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_ragtag.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. item_meatlump_lump_01_01 x5 is OPEN (token currency not in the fork). Task types: nothing, wait_for_signal, wave_event_player.
]]

mtpHideoutRagtagScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutRagtagScreenPlay",
	questName = "mtp_hideout_ragtag",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 5, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
			title = "@quest/ground/mtp_hideout_ragtag:task00_journal_entry_title",
		},
		{
			id = 1,
			name = "beatUpRagTag",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task01_journal_entry_description",
			signal = "fightAnita",
			planet = "corellia",
			x = 164.0,
			y = 27.0,
			z = -4778.0,
			waypointName = "@quest/ground/mtp_hideout_ragtag:task01_waypoint_name",
		},
		{
			id = 2,
			name = "engageAmes",
			type = "wave_event_player",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task02_journal_entry_description",
			retrieveText = "@quest/ground/mtp_hideout_ragtag:task02_retrieve_menu_text",
			waveTarget = "mtp_hideout_quest_ragtag_anita_bath",
			waveMapped = "dressed_corellia_ragtag_ames_missd",
			waveDelay = 1,
			waveRadius = 2.0,
			startMessage = "@quest/ground/mtp_hideout_ragtag:task02_start_message",
			utterance = "@quest/ground/mtp_hideout_ragtag:task02_utterance_wave_1",
		},
		{
			id = 3,
			name = "speakAmesAnitaDone",
			type = "wait_for_signal",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task03_journal_entry_description",
			signal = "fightBox",
		},
		{
			id = 4,
			name = "engageBox",
			type = "wave_event_player",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task04_journal_entry_description",
			retrieveText = "@quest/ground/mtp_hideout_ragtag:task04_retrieve_menu_text",
			waveTarget = "mtp_hideout_quest_ragtag_box_orox",
			waveMapped = "meatlump_clod",
			waveDelay = 1,
			waveRadius = 2.0,
			startMessage = "@quest/ground/mtp_hideout_ragtag:task04_start_message",
			utterance = "@quest/ground/mtp_hideout_ragtag:task04_utterance_wave_1",
		},
		{
			id = 5,
			name = "speakAmesBoxDone",
			type = "wait_for_signal",
			onComplete = { 6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task05_journal_entry_description",
			signal = "spokenAmes",
		},
		{
			id = 6,
			name = "goToClerk",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_ragtag:task06_journal_entry_title",
			description = "@quest/ground/mtp_hideout_ragtag:task06_journal_entry_description",
			signal = "spokeToClerk",
		},
	},
}

MtpQuestEngine.install(mtpHideoutRagtagScreenPlay)

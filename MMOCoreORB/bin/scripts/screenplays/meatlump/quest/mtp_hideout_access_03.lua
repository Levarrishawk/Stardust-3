--[[
	mtp hideout access 03  --  mtp_hideout_access_03

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_03. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutAccess03ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess03ScreenPlay",
	questName = "mtp_hideout_access_03",
	repeatable = false,
	rewardCredits = 6519, -- SOURCED questlist/quest/mtp_hideout_access_03.tab QUEST_REWARD_BANK_CREDITS=6519 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_access_03.tab QUEST_REWARD_BANK_CREDITS=6519 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_access_03_01",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_03:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_03:task00_journal_entry_description",
			signal = "mtp_hideout_access_03_01",
			planet = "talus",
			x = 843.0,
			y = 6.0,
			z = -3178.0,
			waypointName = "@quest/ground/mtp_hideout_access_03:task00_waypoint_name",
		},
		{
			id = 1,
			name = "mtp_hideout_access_03_02",
			type = "destroy_multi",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_03:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_03:task01_journal_entry_description",
			count = 11,
			target = "mtp_quest_farles_meatlump",
			mapped = "meatlump_stooge",
			planet = "talus",
			x = 2979.0,
			y = 180.0,
			z = 6374.0,
			waypointName = "@quest/ground/mtp_hideout_access_03:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_03_03",
			type = "show_message_box",
			onComplete = { 3,4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_03:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_03:task02_journal_entry_description",
			boxTitle = "@quest/ground/mtp_hideout_access_03:task02_message_box_title",
			boxText = "@quest/ground/mtp_hideout_access_03:task02_message_box_text",
		},
		{
			id = 3,
			name = "mtp_hideout_access_03_03a",
			type = "wave_event_player",
			onComplete = {  },
			visible = false,
			item = "object/tangible/quest/meatlump/mtp_hideout_quest03_radio.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_03:task03_retrieve_menu_text",
			waveTarget = "mtp_quest_strilath_farles",
			waveMapped = "dressed_meatlump_merkie_howzat",
			waveDelay = 3,
			waveRadius = 3.0,
			startMessage = "@quest/ground/mtp_hideout_access_03:task03_start_message",
			utterance = "@quest/ground/mtp_hideout_access_03:task03_utterance_wave_1",
		},
		{
			id = 4,
			name = "mtp_hideout_access_03_04",
			type = "wait_for_signal",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_03:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_03:task04_journal_entry_description",
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

MtpQuestEngine.install(mtpHideoutAccess03ScreenPlay)


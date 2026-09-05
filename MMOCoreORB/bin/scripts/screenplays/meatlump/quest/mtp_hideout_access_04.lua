--[[
	mtp hideout access 04  --  mtp_hideout_access_04

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_04. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Lumps are SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client). Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutAccess04ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess04ScreenPlay",
	questName = "mtp_hideout_access_04",
	repeatable = false,
	rewardCredits = 6412, -- SOURCED questlist/quest/mtp_hideout_access_04.tab QUEST_REWARD_BANK_CREDITS=6412 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_access_04.tab QUEST_REWARD_BANK_CREDITS=6412 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 9, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
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
			title = "@quest/ground/mtp_hideout_access_04:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task01_journal_entry_description",
			watches = { "mtp_hideout_access_04_01a", "mtp_hideout_access_04_01b" },
			planet = "corellia",
			x = 6354.0,
			y = 340.0,
			z = 7380.0,
			waypointName = "@quest/ground/mtp_hideout_access_04:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_access_04_02",
			type = "retrieve_item",
			onComplete = { 3,6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task02_journal_entry_description",
			item = "object/tangible/quest/meatlump/mtp_hideout_quest04_stash.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_04:task02_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_access_04:task02_item_name",
			count = 1,
			planet = "corellia",
			x = 6354.0,
			y = 340.0,
			z = 7380.0,
			spawnInherited = true,
		},
		{
			id = 3,
			name = "mtp_hideout_access_04_03",
			type = "wait_for_signal",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task03_journal_entry_description",
			signal = "mtp_hideout_access_04_03",
		},
		{
			id = 4,
			name = "mtp_hideout_access_04_04",
			type = "wait_for_signal",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task04_journal_entry_description",
			signal = "mtp_hideout_access_04_04",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_hideout_access_04:task04_waypoint_name",
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
			retrieveText = "@quest/ground/mtp_hideout_access_04:task06_retrieve_menu_text",
			waveTarget = "mtp_quest_strilath_farles_convo",
			waveMapped = "dressed_meatlump_male_01",
			waveDelay = 2,
			waveRadius = 3.0,
			startMessage = "@quest/ground/mtp_hideout_access_04:task06_start_message",
			utterance = "@quest/ground/mtp_hideout_access_04:task06_utterance_wave_1",
		},
		{
			id = 7,
			name = "mtp_hideout_access_04_01b",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04:task07_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task07_journal_entry_description",
			count = 13,
			target = "mtp_quest_farles_ragtag",
			mapped = "meatlump_clod",
			planet = "corellia",
			x = 6354.0,
			y = 340.0,
			z = 7380.0,
			spawnInherited = true,
		},
		{
			id = 8,
			name = "mtp_hideout_access_04_01a",
			type = "destroy_multi",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04:task08_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04:task08_journal_entry_description",
			count = 1,
			target = "mtp_quest_farles_ragtag_leader",
			mapped = "meatlump_loon",
			planet = "corellia",
			x = 6354.0,
			y = 340.0,
			z = 7380.0,
			spawnInherited = true,
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess04ScreenPlay)


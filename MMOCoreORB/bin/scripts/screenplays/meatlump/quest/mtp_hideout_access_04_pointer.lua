--[[
	mtp hideout access 04 pointer  --  mtp_hideout_access_04_pointer

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_access_04_pointer. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent).
]]

mtpHideoutAccess04PointerScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccess04PointerScreenPlay",
	questName = "mtp_hideout_access_04_pointer",
	repeatable = false,
	rewardCredits = 6519, -- SOURCED questlist/quest/mtp_hideout_access_04_pointer.tab QUEST_REWARD_BANK_CREDITS=6519 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_access_04_pointer.tab QUEST_REWARD_BANK_CREDITS=6519 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1,3 },
			visible = false,
		},
		{
			id = 1,
			name = "mtp_hideout_access_04_pointer",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_access_04_pointer:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_access_04_pointer:task01_journal_entry_description",
			signal = "mtp_hideout_access_04_pointer",
		},
		{
			id = 2,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
		},
		{
			id = 3,
			name = "mtp_hideout_access_03_03a",
			type = "wave_event_player",
			onComplete = {  },
			visible = false,
			item = "object/tangible/quest/meatlump/mtp_hideout_quest03_radio.iff",
			retrieveText = "@quest/ground/mtp_hideout_access_04_pointer:task03_retrieve_menu_text",
			waveTarget = "mtp_quest_strilath_farles_convo",
			waveMapped = "dressed_meatlump_male_01",
			waveDelay = 3,
			waveRadius = 3.0,
			startMessage = "@quest/ground/mtp_hideout_access_04_pointer:task03_start_message",
			utterance = "@quest/ground/mtp_hideout_access_04_pointer:task03_utterance_wave_1",
		},
	},
}

MtpQuestEngine.install(mtpHideoutAccess04PointerScreenPlay)


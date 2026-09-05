--[[
	mtp corsec intelligence officer intro  --  mtp_corsec_intelligence_officer_intro

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_corsec_intelligence_officer_intro.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Safe minigame is the minigames screenplay; collection slots pay through CollectionManager when present. Task types: comm_player, wait_for_signal.
]]

mtpCorsecIntelligenceOfficerIntroScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCorsecIntelligenceOfficerIntroScreenPlay",
	questName = "mtp_corsec_intelligence_officer_intro",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_corsec_intelligence_officer_intro.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_corsec_intelligence_officer_intro.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "meetCorSecIntelligenceOfficerCom",
			type = "comm_player",
			onComplete = { 1 },
			visible = false,
			title = "@quest/ground/mtp_corsec_intelligence_officer_intro:task00_journal_entry_title",
		},
		{
			id = 1,
			name = "meetCorSecIntelligenceOfficerSignal",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_intro:task01_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_intro:task01_journal_entry_description",
			signal = "corSecIntelligenceOfficerMet",
			planet = "corellia",
			x = -175.0,
			y = 28.0,
			z = -4435.0,
			waypointName = "@quest/ground/mtp_corsec_intelligence_officer_intro:task01_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpCorsecIntelligenceOfficerIntroScreenPlay)

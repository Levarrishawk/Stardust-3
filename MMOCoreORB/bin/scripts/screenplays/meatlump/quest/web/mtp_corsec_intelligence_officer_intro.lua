--[[
	mtp corsec intelligence officer intro  --  mtp_corsec_intelligence_officer_intro

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_corsec_intelligence_officer_intro.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. Safe minigame / collection slots are OPEN until the collections branch merges. Task types: comm_player, wait_for_signal.
]]

mtpCorsecIntelligenceOfficerIntroScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCorsecIntelligenceOfficerIntroScreenPlay",
	questName = "mtp_corsec_intelligence_officer_intro",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
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

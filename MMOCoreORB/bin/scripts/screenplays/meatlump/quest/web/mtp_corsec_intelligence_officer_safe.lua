--[[
	mtp corsec intelligence officer safe  --  mtp_corsec_intelligence_officer_safe

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_corsec_intelligence_officer_safe.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. Safe minigame / collection slots are OPEN until the collections branch merges. Task types: nothing, wait_for_signal, wait_for_tasks.
]]

mtpCorsecIntelligenceOfficerSafeScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCorsecIntelligenceOfficerSafeScreenPlay",
	questName = "mtp_corsec_intelligence_officer_safe",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "safeMasterNothingTask",
			type = "nothing",
			onComplete = { 1,7 },
			visible = false,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task00_journal_entry_title",
		},
		{
			id = 1,
			name = "InvisibleWaitForTasks2",
			type = "wait_for_tasks",
			onComplete = { 2,3,4,5,6 },
			visible = false,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task01_journal_entry_title",
			watches = { "solvedSafe6", "solvedSafe7", "solvedSafe8", "solvedSafe9" },
		},
		{
			id = 2,
			name = "solvedSafe10",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task02_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task02_journal_entry_description",
			signal = "mtpSafe01_10",
		},
		{
			id = 3,
			name = "solvedSafe9",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task03_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task03_journal_entry_description",
			signal = "mtpSafe01_09",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 4,
			name = "solvedSafe8",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task04_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task04_journal_entry_description",
			signal = "mtpSafe01_08",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 5,
			name = "solvedSafe7",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task05_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task05_journal_entry_description",
			signal = "mtpSafe01_07",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 6,
			name = "solvedSafe6",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task06_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task06_journal_entry_description",
			signal = "mtpSafe01_06",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 7,
			name = "InvisibleWaitForTasks1",
			type = "wait_for_tasks",
			onComplete = { 8,9,10,11,12 },
			visible = false,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task07_journal_entry_title",
			watches = { "solvedSafe1", "solvedSafe2", "solvedSafe3", "solvedSafe4" },
		},
		{
			id = 8,
			name = "solvedSafe5",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task08_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task08_journal_entry_description",
			signal = "mtpSafe01_05",
		},
		{
			id = 9,
			name = "solvedSafe4",
			type = "wait_for_signal",
			onComplete = { 7 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task09_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task09_journal_entry_description",
			signal = "mtpSafe01_04",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 10,
			name = "solvedSafe3",
			type = "wait_for_signal",
			onComplete = { 7 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task10_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task10_journal_entry_description",
			signal = "mtpSafe01_03",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 11,
			name = "solvedSafe2",
			type = "wait_for_signal",
			onComplete = { 7 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task11_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task11_journal_entry_description",
			signal = "mtpSafe01_02",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 12,
			name = "solvedSafe1",
			type = "wait_for_signal",
			onComplete = { 7 },
			visible = true,
			title = "@quest/ground/mtp_corsec_intelligence_officer_safe:task12_journal_entry_title",
			description = "@quest/ground/mtp_corsec_intelligence_officer_safe:task12_journal_entry_description",
			signal = "mtpSafe01_01",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
	},
}

MtpQuestEngine.install(mtpCorsecIntelligenceOfficerSafeScreenPlay)

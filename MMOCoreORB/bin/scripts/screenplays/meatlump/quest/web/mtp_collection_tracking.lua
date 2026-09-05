--[[
	mtp collection tracking  --  mtp_collection_tracking

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_collection_tracking.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. Collection glue: OPEN until the collections branch merges. Task types: nothing, wait_for_signal, wait_for_tasks.
]]

mtpCollectionTrackingScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCollectionTrackingScreenPlay",
	questName = "mtp_collection_tracking",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	collectionGlue = true, -- OPEN until the collections branch merges
	tasks = {
		{
			id = 0,
			name = "invisNothingTask",
			type = "nothing",
			onComplete = { 1,2,4,5,6,7,8 },
			visible = false,
			title = "@quest/ground/mtp_collection_tracking:task00_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "safeComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task01_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task01_journal_entry_description",
			signal = "mtpSafeComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 2,
			name = "waitingForAllMeatlumpTasks",
			type = "wait_for_tasks",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task02_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task02_journal_entry_description",
			watches = { "safeComplete", "containerComplete", "mapComplete", "bombComplete" },
		},
		{
			id = 3,
			name = "goBackToHaldenWes",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task03_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task03_journal_entry_description",
			signal = "returnToHaldenWes",
			planet = "corellia",
			x = -175.0,
			y = 28.0,
			z = -4435.0,
			waypointName = "@quest/ground/mtp_collection_tracking:task03_waypoint_name",
		},
		{
			id = 4,
			name = "containerComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task04_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task04_journal_entry_description",
			signal = "mtpContainerComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 5,
			name = "mapComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task05_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task05_journal_entry_description",
			signal = "mtpMapComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 6,
			name = "bombComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task06_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task06_journal_entry_description",
			signal = "mtpBombComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 7,
			name = "weaponComplete",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task07_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task07_journal_entry_description",
			signal = "mtpWeaponComplete",
		},
		{
			id = 8,
			name = "foodComplete",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking:task08_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking:task08_journal_entry_description",
			signal = "mtpFoodComplete",
		},
	},
}

MtpQuestEngine.install(mtpCollectionTrackingScreenPlay)

--[[
	mtp collection tracking 02  --  mtp_collection_tracking_02

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_collection_tracking_02.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). CollectionManager quest-signal glue is absent from this engine; wait_for_signal tasks carry the quest. Task types: nothing, wait_for_signal, wait_for_tasks.
]]

mtpCollectionTracking02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpCollectionTracking02ScreenPlay",
	questName = "mtp_collection_tracking_02",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_collection_tracking_02.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_collection_tracking_02.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	collectionGlue = true, -- CollectionManager quest-signal glue is absent from this engine
	tasks = {
		{
			id = 0,
			name = "invisNothingTask",
			type = "nothing",
			onComplete = { 1,2,4,5,6,7,8 },
			visible = false,
			title = "@quest/ground/mtp_collection_tracking_02:task00_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "safeComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task01_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task01_journal_entry_description",
			signal = "mtpSafeComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 2,
			name = "waitingForAllMeatlumpTasks",
			type = "wait_for_tasks",
			onComplete = { 3 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task02_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task02_journal_entry_description",
			watches = { "safeComplete", "containerComplete", "mapComplete", "bombComplete" },
		},
		{
			id = 3,
			name = "goBackToHaldenWes",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task03_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task03_journal_entry_description",
			signal = "returnToHaldenWes",
			planet = "corellia",
			x = -175.0,
			y = 28.0,
			z = -4435.0,
			waypointName = "@quest/ground/mtp_collection_tracking_02:task03_waypoint_name",
		},
		{
			id = 4,
			name = "containerComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task04_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task04_journal_entry_description",
			signal = "mtpContainerComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 5,
			name = "mapComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task05_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task05_journal_entry_description",
			signal = "mtpMapComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 6,
			name = "bombComplete",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task06_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task06_journal_entry_description",
			signal = "mtpBombComplete",
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 7,
			name = "weaponComplete",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task07_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task07_journal_entry_description",
			signal = "mtpWeaponComplete",
		},
		{
			id = 8,
			name = "foodComplete",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_collection_tracking_02:task08_journal_entry_title",
			description = "@quest/ground/mtp_collection_tracking_02:task08_journal_entry_description",
			signal = "mtpFoodComplete",
		},
	},
}

MtpQuestEngine.install(mtpCollectionTracking02ScreenPlay)

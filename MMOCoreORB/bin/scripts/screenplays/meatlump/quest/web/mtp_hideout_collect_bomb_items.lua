--[[
	mtp hideout collect bomb items  --  mtp_hideout_collect_bomb_items

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_collect_bomb_items.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Lumps are SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client). Task types: nothing, retrieve_item, wait_for_signal, wait_for_tasks.
]]

mtpHideoutCollectBombItemsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutCollectBombItemsScreenPlay",
	questName = "mtp_hideout_collect_bomb_items",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_collect_bomb_items.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_collect_bomb_items.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 5, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "nothingTask",
			type = "nothing",
			onComplete = { 1,2,3,4 },
			visible = false,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task00_journal_entry_description",
		},
		{
			id = 1,
			name = "getDetonator",
			type = "retrieve_item",
			onComplete = { 4 },
			visible = false,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task01_journal_entry_description",
			item = "object/tangible/quest/corellia_meatlump_hideout_detonator.iff",
			retrieveText = "@quest/ground/mtp_hideout_collect_bomb_items:task01_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_collect_bomb_items:task01_item_name",
			count = 1,
			planet = "corellia",
			x = -516.0,
			y = 28.0,
			z = -4448.0,
			spawnInherited = true, -- Core3 spawnRetrieve is world-only (parent 0); hideout-cell retrieve is absent from this engine
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 2,
			name = "getExplosives",
			type = "retrieve_item",
			onComplete = { 4 },
			visible = false,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task02_journal_entry_description",
			item = "object/tangible/quest/corellia_meatlump_hideout_explosives.iff",
			retrieveText = "@quest/ground/mtp_hideout_collect_bomb_items:task02_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_collect_bomb_items:task02_item_name",
			count = 1,
			planet = "corellia",
			x = -516.0,
			y = 28.0,
			z = -4448.0,
			spawnInherited = true, -- Core3 spawnRetrieve is world-only (parent 0); hideout-cell retrieve is absent from this engine
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 3,
			name = "getWireSpool",
			type = "retrieve_item",
			onComplete = { 4 },
			visible = false,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task03_journal_entry_description",
			item = "object/tangible/quest/corellia_meatlump_hideout_wire_spool.iff",
			retrieveText = "@quest/ground/mtp_hideout_collect_bomb_items:task03_retrieve_menu_text",
			itemName = "@quest/ground/mtp_hideout_collect_bomb_items:task03_item_name",
			count = 1,
			planet = "corellia",
			x = -516.0,
			y = 28.0,
			z = -4448.0,
			spawnInherited = true, -- Core3 spawnRetrieve is world-only (parent 0); hideout-cell retrieve is absent from this engine
			-- onComplete wired to wait_for_tasks so the engine does not complete the quest on the first child
		},
		{
			id = 4,
			name = "waitingForTasks",
			type = "wait_for_tasks",
			onComplete = { 5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task04_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task04_journal_entry_description",
			watches = { "getWireSpool", "getExplosives", "getDetonator" },
		},
		{
			id = 5,
			name = "returnTechnician",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_collect_bomb_items:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_collect_bomb_items:task05_journal_entry_description",
			signal = "spokeToTechnician",
		},
	},
}

MtpQuestEngine.install(mtpHideoutCollectBombItemsScreenPlay)

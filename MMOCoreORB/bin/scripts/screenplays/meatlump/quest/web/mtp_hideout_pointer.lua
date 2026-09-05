--[[
	mtp hideout pointer  --  mtp_hideout_pointer

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_pointer.

	Credits are SOURCED questlist QUEST_REWARD_BANK_CREDITS (Kashyyyk shipped-amount precedent). Task types: go_to_location, nothing, wait_for_signal.
]]

mtpHideoutPointerScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutPointerScreenPlay",
	questName = "mtp_hideout_pointer",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_pointer.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_pointer.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "mtp_hideout_pointer_01",
			type = "nothing",
			onComplete = { 1,2 },
			visible = false,
		},
		{
			id = 1,
			name = "mtp_hideout_pointer_03",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_pointer:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_pointer:task01_journal_entry_description",
			signal = "mtp_hideout_pointer_03",
			planet = "corellia",
			x = -175.0,
			y = 28.0,
			z = -4435.0,
			waypointName = "@quest/ground/mtp_hideout_pointer:task01_waypoint_name",
		},
		{
			id = 2,
			name = "mtp_hideout_pointer_02",
			type = "go_to_location",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_pointer:task02_journal_entry_title",
			description = "@quest/ground/mtp_hideout_pointer:task02_journal_entry_description",
			planet = "corellia",
			x = -516.0,
			y = 28.0,
			z = -4436.0,
			radius = 32,
			waypointName = "@quest/ground/mtp_hideout_pointer:task02_waypoint_name",
		},
	},
}

MtpQuestEngine.install(mtpHideoutPointerScreenPlay)

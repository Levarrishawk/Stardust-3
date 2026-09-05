--[[
	mtp_meatlump_king_story

	ruling 2026-09-04

	SOURCED: questlist mtp_meatlump_king_story QUEST_REWARD_BANK_CREDITS=49918
	QUEST_REWARD_LOOT_NAME=item_mtp_king_corellia_times_story QUEST_REWARD_LOOT_COUNT=1.
	SOURCED: questtask 0 wait_for_signal mtp_king_story; questtask 1 complete_quest.
	OURS: the fork-side analogue object/tangible/meatlump/hideout/mtp_king_story.iff granted on complete.
	Lumps: SOURCED QUEST_REWARD_LOOT_COUNT of eow_meatlump_lump (OURS appearance; master_item.tab:5620 dungeon iff absent from the client).
]]

mtpMeatlumpKingStoryScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpMeatlumpKingStoryScreenPlay",
	questName = "mtp_meatlump_king_story",
	repeatable = false,
	rewardCredits = 49918, -- SOURCED questlist/quest/mtp_meatlump_king_story.tab QUEST_REWARD_BANK_CREDITS=49918 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_meatlump_king_story.tab QUEST_REWARD_BANK_CREDITS=49918 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "mtp_king_story",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_meatlump_king_story:task00_journal_entry_title",
			description = "@quest/ground/mtp_meatlump_king_story:task00_journal_entry_description",
			signal = "mtp_king_story",
			planet = "corellia",
			x = -107.0,
			y = 28.0,
			z = -4465.0,
			waypointName = "@quest/ground/mtp_meatlump_king_story:task00_waypoint_name",
		},
		{
			id = 1,
			name = "",
			type = "complete_quest",
			onComplete = {  },
			visible = false,
		},
	},
}

MtpQuestEngine.install(mtpMeatlumpKingStoryScreenPlay)

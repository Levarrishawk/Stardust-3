--[[
	mtp_meatlump_king_story

	ruling 2026-09-04

	SOURCED: questlist mtp_meatlump_king_story QUEST_REWARD_BANK_CREDITS=49918
	QUEST_REWARD_LOOT_NAME=item_mtp_king_corellia_times_story QUEST_REWARD_LOOT_COUNT=1.
	SOURCED: questtask 0 wait_for_signal mtp_king_story; questtask 1 complete_quest.
	OURS: the fork-side analogue object/tangible/meatlump/hideout/mtp_king_story.iff granted on complete.
	OPEN: item_meatlump_lump_01_01 is not in the fork.
]]

mtpMeatlumpKingStoryScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpMeatlumpKingStoryScreenPlay",
	questName = "mtp_meatlump_king_story",
	repeatable = false,
	rewardCredits = 49918, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
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

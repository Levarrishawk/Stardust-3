--[[
	mtp hideout instance kill all droids fail  --  mtp_hideout_instance_kill_all_droids_fail

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_kill_all_droids_fail. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Return variant. Giver sends the wait_for_signal; then complete_quest.
]]

mtpHideoutInstanceKillAllDroidsFailScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceKillAllDroidsFailScreenPlay",
	questName = "mtp_hideout_instance_kill_all_droids_fail",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_instance_kill_all_droids_fail.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_instance_kill_all_droids_fail.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 0, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "mtp_kill_all_droids_failed",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_kill_all_droids_fail:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_kill_all_droids_fail:task00_journal_entry_description",
			signal = "mtp_kill_all_droids_failed",
		},
		{
			id = 1,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceKillAllDroidsFailScreenPlay)

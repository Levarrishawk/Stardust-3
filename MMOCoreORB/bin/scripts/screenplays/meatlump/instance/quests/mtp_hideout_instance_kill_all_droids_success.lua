--[[
	mtp hideout instance kill all droids success  --  mtp_hideout_instance_kill_all_droids_success

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_kill_all_droids_success. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Return variant. Giver sends the wait_for_signal; then complete_quest.
]]

mtpHideoutInstanceKillAllDroidsSuccessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceKillAllDroidsSuccessScreenPlay",
	questName = "mtp_hideout_instance_kill_all_droids_success",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_instance_kill_all_droids_success.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_instance_kill_all_droids_success.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 11, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "mtp_kill_all_droids_success",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_kill_all_droids_success:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_kill_all_droids_success:task00_journal_entry_description",
			signal = "mtp_kill_all_droids_success",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceKillAllDroidsSuccessScreenPlay)

--[[
	mtp hideout instance recover supplies success  --  mtp_hideout_instance_recover_supplies_success

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_recover_supplies_success. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Return variant. Giver sends the wait_for_signal; then complete_quest.
]]

mtpHideoutInstanceRecoverSuppliesSuccessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceRecoverSuppliesSuccessScreenPlay",
	questName = "mtp_hideout_instance_recover_supplies_success",
	repeatable = false,
	rewardCredits = 0, -- SOURCED questlist/quest/mtp_hideout_instance_recover_supplies_success.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	rewardXp = 0, -- SOURCED questlist/quest/mtp_hideout_instance_recover_supplies_success.tab QUEST_REWARD_BANK_CREDITS=0 QUEST_REWARD_EXPERIENCE_AMOUNT=0
	lumpCount = 7, -- SOURCED QUEST_REWARD_LOOT_COUNT; OURS eow_meatlump_lump (master_item.tab:5620 dungeon iff absent from the client)
	tasks = {
		{
			id = 0,
			name = "mtp_recover_supplies_success",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_recover_supplies_success:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_recover_supplies_success:task00_journal_entry_description",
			signal = "mtp_recover_supplies_success",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceRecoverSuppliesSuccessScreenPlay)

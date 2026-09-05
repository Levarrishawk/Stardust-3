--[[
	mtp hideout instance escort trapped meatlump success  --  mtp_hideout_instance_escort_trapped_meatlump_success

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_escort_trapped_meatlump_success. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Return variant. Giver sends the wait_for_signal; then complete_quest.
]]

mtpHideoutInstanceEscortTrappedMeatlumpSuccessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceEscortTrappedMeatlumpSuccessScreenPlay",
	questName = "mtp_hideout_instance_escort_trapped_meatlump_success",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 7, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "mtp_rescue_lost_meatlump_success",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump_success:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump_success:task00_journal_entry_description",
			signal = "mtp_rescue_lost_meatlump_success",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceEscortTrappedMeatlumpSuccessScreenPlay)

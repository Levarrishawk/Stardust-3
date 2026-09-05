--[[
	mtp hideout instance escort trapped meatlump fail  --  mtp_hideout_instance_escort_trapped_meatlump_fail

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_escort_trapped_meatlump_fail. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Return variant. Giver sends the wait_for_signal; then complete_quest.
]]

mtpHideoutInstanceEscortTrappedMeatlumpFailScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceEscortTrappedMeatlumpFailScreenPlay",
	questName = "mtp_hideout_instance_escort_trapped_meatlump_fail",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "mtp_rescue_lost_meatlump_failed",
			type = "wait_for_signal",
			onComplete = { 1 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump_fail:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump_fail:task00_journal_entry_description",
			signal = "mtp_rescue_lost_meatlump_failed",
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

MtpQuestEngine.install(mtpHideoutInstanceEscortTrappedMeatlumpFailScreenPlay)

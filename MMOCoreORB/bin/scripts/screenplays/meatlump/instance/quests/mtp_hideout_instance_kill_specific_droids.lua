--[[
	mtp hideout instance kill specific droids  --  mtp_hideout_instance_kill_specific_droids

	ruling 2026-09-04

	SOURCE: leaked questlist/questtask for quest/mtp_hideout_instance_kill_specific_droids. Client ships the
	string table but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	NO JOURNAL: this branch has no managers/quest/journal.lua.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending.
]]

mtpHideoutInstanceKillSpecificDroidsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutInstanceKillSpecificDroidsScreenPlay",
	questName = "mtp_hideout_instance_kill_specific_droids",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "gotoInstance",
			type = "wait_for_signal",
			onComplete = { 1,3,5 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task00_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task00_journal_entry_description",
			signal = "mtp_kill_specific_droids",
		},
		{
			id = 1,
			name = "destroy_some_droids",
			type = "destroy_multi",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task01_journal_entry_description",
			count = 34,
			socialGroup = "mtp_droid_target",
		},
		{
			id = 2,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_kill_specific_droids_success",
		},
		{
			id = 3,
			name = "dont_destroy_these_droids",
			type = "destroy_multi",
			onComplete = { 4 },
			visible = false,
			count = 2,
			socialGroup = "mtp_security_droid",
		},
		{
			id = 4,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_kill_specific_droids_fail",
		},
		{
			id = 5,
			name = "mtp_quest_timer",
			type = "timer",
			onComplete = { 6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_instance_kill_specific_droids:task05_journal_entry_description",
			minTime = 585,
		},
		{
			id = 6,
			name = "",
			type = "clear_quest",
			onComplete = {  },
			visible = false,
			grantQuest = "mtp_hideout_instance_kill_specific_droids_fail",
		},
	},
}

MtpQuestEngine.install(mtpHideoutInstanceKillSpecificDroidsScreenPlay)

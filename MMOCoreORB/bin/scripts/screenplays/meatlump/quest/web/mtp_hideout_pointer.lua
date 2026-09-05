--[[
	mtp hideout pointer  --  mtp_hideout_pointer

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_pointer.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. Task types: go_to_location, nothing, wait_for_signal.
]]

mtpHideoutPointerScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutPointerScreenPlay",
	questName = "mtp_hideout_pointer",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 0, -- OPEN: item_meatlump_lump_01_01 is not in the fork
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

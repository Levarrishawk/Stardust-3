--[[
	mtp hideout retrieve delivery  --  mtp_hideout_retrieve_delivery

	ruling 2026-09-04

	SOURCED: questlist/questtask mtp_hideout_retrieve_delivery.

	Credits are the questlist NGE amounts (REWARD_CREDITS on task rows is 0). Rebalance pending. item_meatlump_lump_01_01 x5 is OPEN (token currency not in the fork). Comlink / shuttle event is OPEN (quest_shuttle_comlink is not a Lua item on this branch). Task types: comm_player, destroy_multi, nothing, wait_for_signal.
]]

mtpHideoutRetrieveDeliveryScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutRetrieveDeliveryScreenPlay",
	questName = "mtp_hideout_retrieve_delivery",
	repeatable = false,
	rewardCredits = 0, -- OPEN: shipped NGE amount; the rebalance is a maintainer ruling
	lumpCount = 5, -- OPEN: item_meatlump_lump_01_01 is not in the fork
	tasks = {
		{
			id = 0,
			name = "",
			type = "nothing",
			onComplete = { 1 },
			visible = false,
		},
		{
			id = 1,
			name = "useComlink",
			type = "wait_for_signal",
			onComplete = { 2 },
			visible = true,
			title = "@quest/ground/mtp_hideout_retrieve_delivery:task01_journal_entry_title",
			description = "@quest/ground/mtp_hideout_retrieve_delivery:task01_journal_entry_description",
			signal = "shuttleTooHotCommSignal",
		},
		{
			id = 2,
			name = "comTooHot",
			type = "comm_player",
			onComplete = { 3 },
			visible = false,
		},
		{
			id = 3,
			name = "killRagtags",
			type = "destroy_multi",
			onComplete = { 4 },
			visible = true,
			title = "@quest/ground/mtp_hideout_retrieve_delivery:task03_journal_entry_title",
			description = "@quest/ground/mtp_hideout_retrieve_delivery:task03_journal_entry_description",
			count = 2,
			target = "mtp_delivery_ambush_ragtag_blackjack",
			mapped = "meatlump_clod",
		},
		{
			id = 4,
			name = "okCallShuttle",
			type = "comm_player",
			onComplete = { 5 },
			visible = false,
		},
		{
			id = 5,
			name = "shuttleLanded",
			type = "wait_for_signal",
			onComplete = { 6 },
			visible = true,
			title = "@quest/ground/mtp_hideout_retrieve_delivery:task05_journal_entry_title",
			description = "@quest/ground/mtp_hideout_retrieve_delivery:task05_journal_entry_description",
			signal = "shuttleLandedDelivery",
		},
		{
			id = 6,
			name = "landingNoteComm",
			type = "comm_player",
			onComplete = { 7 },
			visible = false,
		},
		{
			id = 7,
			name = "speakSmuggler",
			type = "wait_for_signal",
			onComplete = { 8 },
			visible = true,
			title = "@quest/ground/mtp_hideout_retrieve_delivery:task07_journal_entry_title",
			description = "@quest/ground/mtp_hideout_retrieve_delivery:task07_journal_entry_description",
			signal = "smugglerSpoken",
		},
		{
			id = 8,
			name = "seeArmorer",
			type = "wait_for_signal",
			onComplete = {  },
			visible = true,
			title = "@quest/ground/mtp_hideout_retrieve_delivery:task08_journal_entry_title",
			description = "@quest/ground/mtp_hideout_retrieve_delivery:task08_journal_entry_description",
			signal = "spokenToArmorer",
		},
	},
}

MtpQuestEngine.install(mtpHideoutRetrieveDeliveryScreenPlay)

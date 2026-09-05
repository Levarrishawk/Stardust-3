-- mtp_hideout_access_bike_racer
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_bike_racer_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_bike_racer_conv_handler",
	screens = {}
}

mtp_hideout_access_bike_racer_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_bike_racer:s_4", -- 03_01 done
	stopConversation = true,
	options = {}
}
mtp_hideout_access_bike_racer_convo:addScreen(mtp_hideout_access_bike_racer_convo_s_4)

mtp_hideout_access_bike_racer_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_access_bike_racer:s_29", -- 03_01 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_bike_racer:s_23", "s_24"},
	}
}
mtp_hideout_access_bike_racer_convo:addScreen(mtp_hideout_access_bike_racer_convo_s_29)

mtp_hideout_access_bike_racer_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_access_bike_racer:s_24", -- signal 03_01
	stopConversation = true,
	options = {}
}
mtp_hideout_access_bike_racer_convo:addScreen(mtp_hideout_access_bike_racer_convo_s_24)

mtp_hideout_access_bike_racer_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_bike_racer:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_bike_racer_convo:addScreen(mtp_hideout_access_bike_racer_convo_s_28)

addConversationTemplate("mtp_hideout_access_bike_racer_convo", mtp_hideout_access_bike_racer_convo)

-- mtp_hideout_weapon_supply_tech
-- ruling 2026-09-04

mtp_hideout_weapon_supply_tech_convo = ConvoTemplate:new {
	initialScreen = "s_50",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_weapon_supply_tech_conv_handler",
	screens = {}
}

mtp_hideout_weapon_supply_tech_convo_s_39 = ConvoScreen:new {
	id = "s_39",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_39", -- naboo camp already on the books
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_39)

mtp_hideout_weapon_supply_tech_convo_s_23 = ConvoScreen:new {
	id = "s_23",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_23", -- did you get the package
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_weapon_supply_tech:s_25", "s_27"},
	}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_23)

mtp_hideout_weapon_supply_tech_convo_s_27 = ConvoScreen:new {
	id = "s_27",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_27", -- ragtags
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_weapon_supply_tech:s_29", "s_31"},
	}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_27)

mtp_hideout_weapon_supply_tech_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_31", -- several times
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_weapon_supply_tech:s_33", "s_35"},
	}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_31)

mtp_hideout_weapon_supply_tech_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_35", -- signal armorer / grant naboo
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_35)

mtp_hideout_weapon_supply_tech_convo_s_49 = ConvoScreen:new {
	id = "s_49",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_49", -- delivery active: bad comlink OPEN
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_49)

mtp_hideout_weapon_supply_tech_convo_s_5 = ConvoScreen:new {
	id = "s_5",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_5", -- offer delivery
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_weapon_supply_tech:s_15", "s_17"},
	}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_5)

mtp_hideout_weapon_supply_tech_convo_s_17 = ConvoScreen:new {
	id = "s_17",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_17", -- grant delivery (comlink OPEN)
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_17)

mtp_hideout_weapon_supply_tech_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_tech:s_50", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_tech_convo:addScreen(mtp_hideout_weapon_supply_tech_convo_s_50)

addConversationTemplate("mtp_hideout_weapon_supply_tech_convo", mtp_hideout_weapon_supply_tech_convo)

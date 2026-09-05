-- mtp_hideout_food_supply_tech
-- ruling 2026-09-04

mtp_hideout_food_supply_tech_convo = ConvoTemplate:new {
	initialScreen = "s_74",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_food_supply_tech_conv_handler",
	screens = {}
}

mtp_hideout_food_supply_tech_convo_s_72 = ConvoScreen:new {
	id = "s_72",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_72", -- tatooine done
	stopConversation = true,
	options = {}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_72)

mtp_hideout_food_supply_tech_convo_s_69 = ConvoScreen:new {
	id = "s_69",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_69", -- ragtag fail: try again
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_70", "s_71"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_69)

mtp_hideout_food_supply_tech_convo_s_71 = ConvoScreen:new {
	id = "s_71",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_71", -- clear fail / regrant ragtag
	stopConversation = true,
	options = {}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_71)

mtp_hideout_food_supply_tech_convo_s_56 = ConvoScreen:new {
	id = "s_56",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_56", -- ragtag complete
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_58", "s_60"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_56)

mtp_hideout_food_supply_tech_convo_s_60 = ConvoScreen:new {
	id = "s_60",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_60", -- grant tatooine / signal clerk
	stopConversation = true,
	options = {}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_60)

mtp_hideout_food_supply_tech_convo_s_51 = ConvoScreen:new {
	id = "s_51",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_51", -- ragtag active: SW Coronet Ames
	stopConversation = true,
	options = {}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_51)

mtp_hideout_food_supply_tech_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_7", -- offer ragtag
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_9", "s_11"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_7)

mtp_hideout_food_supply_tech_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_11", -- ragtags
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_17", "s_19"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_11)

mtp_hideout_food_supply_tech_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_19", -- friend at camp
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_25", "s_47"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_19)

mtp_hideout_food_supply_tech_convo_s_47 = ConvoScreen:new {
	id = "s_47",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_47", -- deal
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_food_supply_tech:s_49", "s_51"},
	}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_47)

mtp_hideout_food_supply_tech_convo_s_74 = ConvoScreen:new {
	id = "s_74",
	leftDialog = "@conversation/mtp_hideout_food_supply_tech:s_74", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_food_supply_tech_convo:addScreen(mtp_hideout_food_supply_tech_convo_s_74)

addConversationTemplate("mtp_hideout_food_supply_tech_convo", mtp_hideout_food_supply_tech_convo)

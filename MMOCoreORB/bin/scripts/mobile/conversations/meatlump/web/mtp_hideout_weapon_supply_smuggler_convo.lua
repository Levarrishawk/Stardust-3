-- mtp_hideout_weapon_supply_smuggler
-- ruling 2026-09-04

mtp_hideout_weapon_supply_smuggler_convo = ConvoTemplate:new {
	initialScreen = "s_15",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_weapon_supply_smuggler_conv_handler",
	screens = {}
}

mtp_hideout_weapon_supply_smuggler_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_smuggler:s_4", -- jawa greeting
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_weapon_supply_smuggler:s_31", "s_42"},
	}
}
mtp_hideout_weapon_supply_smuggler_convo:addScreen(mtp_hideout_weapon_supply_smuggler_convo_s_4)

mtp_hideout_weapon_supply_smuggler_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_smuggler:s_42", -- signal smugglerSpoken
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_smuggler_convo:addScreen(mtp_hideout_weapon_supply_smuggler_convo_s_42)

mtp_hideout_weapon_supply_smuggler_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_hideout_weapon_supply_smuggler:s_15", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_weapon_supply_smuggler_convo:addScreen(mtp_hideout_weapon_supply_smuggler_convo_s_15)

addConversationTemplate("mtp_hideout_weapon_supply_smuggler_convo", mtp_hideout_weapon_supply_smuggler_convo)

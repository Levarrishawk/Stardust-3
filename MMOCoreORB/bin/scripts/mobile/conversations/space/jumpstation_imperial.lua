--[[
	Deep Space - Kessel Space Battlefield entry station (Imperial, Endor space).

	Every line below is a real client string from
	  string/en/conversation/battlefield_entry_station_imperial.stf
	which is the Live string table for this exact NPC.  Nothing here is authored
	prose.

	Key map (client text in the trailing comment on each line):
	  s_a136b7d3 greeting        s_fa22e207 Deep Space option   s_597d7f95 Kessel option
	  s_48f82131 out of range    s_358253b2 civilian ship       s_33077605 enemy
	  s_33f71018 wrong faction   s_2e491159 sign up             s_c2f477d7 cost (%DI)
	  s_ef420789 Yes!            s_7426e000 No!                 s_fe2e6ec0 no prestige (%DI)
	  s_a80d9308 jump            s_1bd14e67 goodbye

	Unlike the Rebel table, the Imperial table carries only ONE "Good luck" line
	(s_a80d9308), so both the Deep Space and Kessel jump screens use it.
]]

jumpstation_imperial_convotemplate = ConvoTemplate:new {
	initialScreen = "jumpstation_imperial_greeting",
	templateType = "Lua",
	luaClassHandler = "JumpstationImperialConvoHandler",
	screens = {}
}

-- Initial Greeting
jumpstation_imperial_greeting = ConvoScreen:new {
	id = "jumpstation_imperial_greeting",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_a136b7d3", -- Welcome to the Imperial Space Station!
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_imperial:s_fa22e207", "jumpstation_imperial_deepspace"}, -- I would like to enter Deep Space!
		{"@conversation/battlefield_entry_station_imperial:s_597d7f95", "jumpstation_imperial_kessel_jump"}, -- I would like to go to Kessel.
	}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_greeting);

jumpstation_imperial_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_48f82131", -- You need to move closer to this station.
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_out_of_range);

-- Not wired by the handler: no Lua binding distinguishes a civilian hull from a
-- combat hull (LuaShipObject.cpp has no ship-type/chassis getter), and ship
-- faction is not a safe proxy.  Screen is kept so the client string has a home
-- the moment a determinant exists.
jumpstation_imperial_civilian = ConvoScreen:new {
	id = "jumpstation_imperial_civilian",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_358253b2", -- There's nothing we can do for you while you're in that civilian ship.
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_civilian);

jumpstation_imperial_enemy = ConvoScreen:new {
	id = "jumpstation_imperial_enemy",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_33077605", -- You are not welcome at this station, Rebel SCUM!
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_enemy);

jumpstation_imperial_wrong_faction = ConvoScreen:new {
	id = "jumpstation_imperial_wrong_faction",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_33f71018", -- You are not of the proper faction. Go find your own station.
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_wrong_faction);

jumpstation_imperial_sign_up = ConvoScreen:new {
	id = "jumpstation_imperial_sign_up",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_2e491159", -- Sign up with the Empire and we'll talk.
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_sign_up);

-- Prestige fee prompt. %DI is filled in by the handler (setDialogTextDI).
jumpstation_imperial_deepspace = ConvoScreen:new {
	id = "jumpstation_imperial_deepspace",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_c2f477d7", -- This will cost %DI points of Prestige. Do you wish to spend the points and enter?
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_imperial:s_ef420789", "jumpstation_imperial_deepspace_jump"}, -- Yes!
		{"@conversation/battlefield_entry_station_imperial:s_7426e000", "jumpstation_imperial_goodbye"}, -- No!
	}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_deepspace);

-- Insufficient prestige. %DI is filled in by the handler (setDialogTextDI).
jumpstation_imperial_insufficient = ConvoScreen:new {
	id = "jumpstation_imperial_insufficient",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_fe2e6ec0", -- You do not have enough Prestige to enter Deep Space. You need %DI points. Go do more work for the Empire and we'll talk.
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_insufficient);

-- Deep Space jump confirmed - handler schedules the hyperspace jump
jumpstation_imperial_deepspace_jump = ConvoScreen:new {
	id = "jumpstation_imperial_deepspace_jump",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_deepspace_jump);

-- Kessel jump confirmed - handler schedules the hyperspace jump.
-- No prestige screen exists for Kessel in any of the three battlefield entry
-- station string tables (every prestige line names Deep Space), so this route
-- carries no fee.
jumpstation_imperial_kessel_jump = ConvoScreen:new {
	id = "jumpstation_imperial_kessel_jump",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_kessel_jump);

jumpstation_imperial_goodbye = ConvoScreen:new {
	id = "jumpstation_imperial_goodbye",
	leftDialog = "@conversation/battlefield_entry_station_imperial:s_1bd14e67", -- Okay. Goodbye!
	stopConversation = "true",
	options = {}
}
jumpstation_imperial_convotemplate:addScreen(jumpstation_imperial_goodbye);

-- Add Template (EOF)
addConversationTemplate("jumpstation_imperial_convotemplate", jumpstation_imperial_convotemplate);

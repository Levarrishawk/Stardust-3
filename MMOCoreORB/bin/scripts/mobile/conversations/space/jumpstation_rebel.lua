--[[
	Deep Space - Kessel Space Battlefield entry station (Rebel, Dantooine space).

	Every line below is a real client string from
	  string/en/conversation/battlefield_entry_station_rebel.stf
	which is the Live string table for this exact NPC ("Space Battlefield entry
	station" is SOE's own name for it - Publish 27.4 Update Notes, Monday March
	6th: "Space Battlefield entry stations will no longer charge prestige points
	for access to Deep Space.").  Nothing here is authored prose.

	Key map (client text in the trailing comment on each line):
	  s_6aebdf84 greeting        s_fa22e207 Deep Space option   s_359fde4 Kessel option
	  s_3b257674 out of range    s_2103c96f civilian ship       s_514ace33 enemy
	  s_33f71018 wrong faction   s_17456755 sign up             s_c2f477d7 cost (%DI)
	  s_ef420789 Yes!            s_7426e000 No!                 s_f68255a0 no prestige (%DI)
	  s_a80d9308 Deep Space jump s_93272f1a Kessel jump         s_1bd14e67 goodbye
]]

jumpstation_rebel_convotemplate = ConvoTemplate:new {
	initialScreen = "jumpstation_rebel_greeting",
	templateType = "Lua",
	luaClassHandler = "JumpstationRebelConvoHandler",
	screens = {}
}

-- Initial Greeting
jumpstation_rebel_greeting = ConvoScreen:new {
	id = "jumpstation_rebel_greeting",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_6aebdf84", -- Welcome to the Rebel Space Station!
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_rebel:s_fa22e207", "jumpstation_rebel_deepspace"}, -- I would like to enter Deep Space!
		{"@conversation/battlefield_entry_station_rebel:s_359fde4", "jumpstation_rebel_kessel_jump"}, -- I want to go to Kessel.
	}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_greeting);

jumpstation_rebel_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_3b257674", -- You need to move close to this station, %TU.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_out_of_range);

-- Not wired by the handler: no Lua binding distinguishes a civilian hull from a
-- combat hull (LuaShipObject.cpp has no ship-type/chassis getter), and ship
-- faction is not a safe proxy.  Screen is kept so the client string has a home
-- the moment a determinant exists.
jumpstation_rebel_civilian = ConvoScreen:new {
	id = "jumpstation_rebel_civilian",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_2103c96f", -- We can't do anything for you while you're in that civilian ship.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_civilian);

jumpstation_rebel_enemy = ConvoScreen:new {
	id = "jumpstation_rebel_enemy",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_514ace33", -- You are not welcome at this station!
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_enemy);

jumpstation_rebel_wrong_faction = ConvoScreen:new {
	id = "jumpstation_rebel_wrong_faction",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_33f71018", -- You are not of the proper faction. Go find your own station.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_wrong_faction);

jumpstation_rebel_sign_up = ConvoScreen:new {
	id = "jumpstation_rebel_sign_up",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_17456755", -- Sign up with the Rebel Alliance and we'll talk.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_sign_up);

-- Prestige fee prompt. %DI is filled in by the handler (setDialogTextDI).
jumpstation_rebel_deepspace = ConvoScreen:new {
	id = "jumpstation_rebel_deepspace",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_c2f477d7", -- This will cost %DI points of Prestige. Do you wish to spend the points and enter?
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_rebel:s_ef420789", "jumpstation_rebel_deepspace_jump"}, -- Yes!
		{"@conversation/battlefield_entry_station_rebel:s_7426e000", "jumpstation_rebel_goodbye"}, -- No!
	}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_deepspace);

-- Insufficient prestige. %DI is filled in by the handler (setDialogTextDI).
jumpstation_rebel_insufficient = ConvoScreen:new {
	id = "jumpstation_rebel_insufficient",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_f68255a0", -- You do not have enough Prestige to enter Deep Space. You need %DI points. Go do more work for the Rebellion and we'll talk.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_insufficient);

-- Deep Space jump confirmed - handler schedules the hyperspace jump
jumpstation_rebel_deepspace_jump = ConvoScreen:new {
	id = "jumpstation_rebel_deepspace_jump",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_deepspace_jump);

-- Kessel jump confirmed - handler schedules the hyperspace jump.
-- No prestige screen exists for Kessel in any of the three battlefield entry
-- station string tables (every prestige line names Deep Space), so this route
-- carries no fee.
jumpstation_rebel_kessel_jump = ConvoScreen:new {
	id = "jumpstation_rebel_kessel_jump",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_93272f1a", -- Good Luck.
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_kessel_jump);

jumpstation_rebel_goodbye = ConvoScreen:new {
	id = "jumpstation_rebel_goodbye",
	leftDialog = "@conversation/battlefield_entry_station_rebel:s_1bd14e67", -- Okay. Goodbye!
	stopConversation = "true",
	options = {}
}
jumpstation_rebel_convotemplate:addScreen(jumpstation_rebel_goodbye);

-- Add Template (EOF)
addConversationTemplate("jumpstation_rebel_convotemplate", jumpstation_rebel_convotemplate);

--[[
	Deep Space - Kessel Space Battlefield entry station (Neutral/Freelance,
	Dathomir space).

	Every line below is a real client string from
	  string/en/conversation/battlefield_entry_station_neutral.stf
	Nothing here is authored prose.

	The neutral table is the only one of the three that carries a side-picking
	tree, and its own text explains why:

	  s_a99b5897 "This area of Deep Space has been closed by order of the Empire.
	   The only way to get in is to pose as either an Imperial yourself, or to use
	   the Rebel Alliance's hyperspace route.  Be warned though, whichever route
	   you choose, you will be treated as an enemy by the other side!"

	so a freelancer picks a side (s_a785faa6 "Which side would you like to
	support?") and that choice decides which arrival point in space_heavy1 they
	are dropped at.

	Key map (client text in the trailing comment on each line):
	  s_729b53ce greeting        s_fa22e207 Deep Space option   s_c4588d4d Kessel option
	  s_3b257674 out of range    s_3693fe50 civilian ship       s_a99b5897 briefing
	  s_43be1790 I understand    s_a785faa6 which side          s_5f09f8fe The Empire
	  s_d62f971d The Rebel Alliance                             s_1e10b20e Forget that!
	  s_11e15256 declined        s_45e440c8 rebels not welcome  s_993453d7 imperials not welcome
	  s_7e6edae  cost (%DI)      s_370822d1 Yes                 s_457a7010 No
	  s_37d359a2 no prestige (%DI)                              s_1cfc0538 Deep Space jump
	  s_f61543c9 Kessel jump     s_5755f403 goodbye
]]

jumpstation_neutral_convotemplate = ConvoTemplate:new {
	initialScreen = "jumpstation_neutral_greeting",
	templateType = "Lua",
	luaClassHandler = "JumpstationNeutralConvoHandler",
	screens = {}
}

-- Initial Greeting
jumpstation_neutral_greeting = ConvoScreen:new {
	id = "jumpstation_neutral_greeting",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_729b53ce", -- Welcome, pilot!
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_neutral:s_fa22e207", "jumpstation_neutral_briefing"}, -- I would like to enter Deep Space!
		{"@conversation/battlefield_entry_station_neutral:s_c4588d4d", "jumpstation_neutral_kessel_jump"}, -- I want to go to Kessel
	}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_greeting);

jumpstation_neutral_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_3b257674", -- You need to move close to this station, %TU.
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_out_of_range);

-- Not wired by the handler: no Lua binding distinguishes a civilian hull from a
-- combat hull (LuaShipObject.cpp has no ship-type/chassis getter), and ship
-- faction is not a safe proxy.  Screen is kept so the client string has a home
-- the moment a determinant exists.
jumpstation_neutral_civilian = ConvoScreen:new {
	id = "jumpstation_neutral_civilian",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_3693fe50", -- There's nothing we can do for you as long as you're in that civilian ship.
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_civilian);

-- Why a freelancer has to pick a side
jumpstation_neutral_briefing = ConvoScreen:new {
	id = "jumpstation_neutral_briefing",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_a99b5897", -- This area of Deep Space has been closed by order of the Empire. ...
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_neutral:s_43be1790", "jumpstation_neutral_side"}, -- I understand
	}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_briefing);

jumpstation_neutral_side = ConvoScreen:new {
	id = "jumpstation_neutral_side",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_a785faa6", -- Which side would you like to support?
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_neutral:s_5f09f8fe", "jumpstation_neutral_deepspace_imperial"}, -- The Empire
		{"@conversation/battlefield_entry_station_neutral:s_d62f971d", "jumpstation_neutral_deepspace_rebel"}, -- The Rebel Alliance
		{"@conversation/battlefield_entry_station_neutral:s_1e10b20e", "jumpstation_neutral_declined"}, -- Forget that!
	}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_side);

jumpstation_neutral_declined = ConvoScreen:new {
	id = "jumpstation_neutral_declined",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_11e15256", -- Ha ha!  I don't blame you.  Goodbye, then.
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_declined);

-- Picked the side you are already at war with
jumpstation_neutral_rebels_no = ConvoScreen:new {
	id = "jumpstation_neutral_rebels_no",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_45e440c8", -- Rebels are not welcome here
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_rebels_no);

jumpstation_neutral_imperials_no = ConvoScreen:new {
	id = "jumpstation_neutral_imperials_no",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_993453d7", -- Imperials are not welcome here.
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_imperials_no);

-- Prestige fee prompt, one per side. %DI is filled in by the handler.
jumpstation_neutral_deepspace_imperial = ConvoScreen:new {
	id = "jumpstation_neutral_deepspace_imperial",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_7e6edae", -- This will cost %DI points of prestige.  Do you wish to spend the points and enter?
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_neutral:s_370822d1", "jumpstation_neutral_jump_imperial"}, -- Yes
		{"@conversation/battlefield_entry_station_neutral:s_457a7010", "jumpstation_neutral_goodbye"}, -- No
	}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_deepspace_imperial);

jumpstation_neutral_deepspace_rebel = ConvoScreen:new {
	id = "jumpstation_neutral_deepspace_rebel",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_7e6edae", -- This will cost %DI points of prestige.  Do you wish to spend the points and enter?
	stopConversation = "false",
	options = {
		{"@conversation/battlefield_entry_station_neutral:s_370822d1", "jumpstation_neutral_jump_rebel"}, -- Yes
		{"@conversation/battlefield_entry_station_neutral:s_457a7010", "jumpstation_neutral_goodbye"}, -- No
	}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_deepspace_rebel);

-- Insufficient prestige. %DI is filled in by the handler (setDialogTextDI).
jumpstation_neutral_insufficient = ConvoScreen:new {
	id = "jumpstation_neutral_insufficient",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_37d359a2", -- You do not have enough Prestige to enter Deep Space.  You need %DI points.
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_insufficient);

-- Deep Space jump confirmed - handler schedules the hyperspace jump.
-- Two ids for one string so the handler knows which arrival point to use.
jumpstation_neutral_jump_imperial = ConvoScreen:new {
	id = "jumpstation_neutral_jump_imperial",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_1cfc0538", -- Good luck
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_jump_imperial);

jumpstation_neutral_jump_rebel = ConvoScreen:new {
	id = "jumpstation_neutral_jump_rebel",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_1cfc0538", -- Good luck
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_jump_rebel);

-- Kessel jump confirmed - handler schedules the hyperspace jump.
-- No prestige screen exists for Kessel in any of the three battlefield entry
-- station string tables (every prestige line names Deep Space), so this route
-- carries no fee.
jumpstation_neutral_kessel_jump = ConvoScreen:new {
	id = "jumpstation_neutral_kessel_jump",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_f61543c9", -- Good Luck
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_kessel_jump);

jumpstation_neutral_goodbye = ConvoScreen:new {
	id = "jumpstation_neutral_goodbye",
	leftDialog = "@conversation/battlefield_entry_station_neutral:s_5755f403", -- Okay, Goodbye
	stopConversation = "true",
	options = {}
}
jumpstation_neutral_convotemplate:addScreen(jumpstation_neutral_goodbye);

-- Add Template (EOF)
addConversationTemplate("jumpstation_neutral_convotemplate", jumpstation_neutral_convotemplate);

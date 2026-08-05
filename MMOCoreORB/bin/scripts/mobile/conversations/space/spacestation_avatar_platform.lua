-- Trandoshan Avatar Platform. Every screen is backed by a shipped key in
-- conversation/station_avatar_platform.stf. The platform is mid-uprising, so the
-- handler picks the greeting from how far the fighting has gone.

spacestation_avatar_platform_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_avatar_platform_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationAvatarPlatformConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_avatar_platform_greeting = ConvoScreen:new {
	id = "spacestation_avatar_platform_greeting",
	leftDialog = "@conversation/station_avatar_platform:s_62", --Pilot, can you read me? We are under attack. The resistance has managed to get through our security net and have infiltrated the station. Heavy fighting is taking place throughout the station. We can use any help that you can give to us!
	stopConversation = "false",
	options = {
		{"@conversation/station_avatar_platform:s_64", "spacestation_avatar_platform_help"}, --I am ready to help deal with the problem.
		{"@conversation/station_avatar_platform:s_68", "spacestation_avatar_platform_refuse"}, --Sounds rough. Good luck with that.
	}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_greeting);

--out of range
spacestation_avatar_platform_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_avatar_platform:s_60", --Hey, what do you expect me to do for you when you're so far away? Come closer before you bother me.
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_out_of_range);

spacestation_avatar_platform_help = ConvoScreen:new {
	id = "spacestation_avatar_platform_help",
	leftDialog = "@conversation/station_avatar_platform:s_66", --Your ship's authorization codes check out. Stand by to land on alpha pad. Good luck and watch your back. Things are nasty down here.
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_help);

spacestation_avatar_platform_refuse = ConvoScreen:new {
	id = "spacestation_avatar_platform_refuse",
	leftDialog = "@conversation/station_avatar_platform:s_70", --Lock down sections eight through twelve...send in the...blast...end communication.
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_refuse);

--Pilot has no business here
spacestation_avatar_platform_greeting_trespass = ConvoScreen:new {
	id = "spacestation_avatar_platform_greeting_trespass",
	leftDialog = "@conversation/station_avatar_platform:s_72", --You are not authorized to be in this area. You are hearby ordered to exit the area or be face immediate termination.
	stopConversation = "false",
	options = {
		{"@conversation/station_avatar_platform:s_74", "spacestation_avatar_platform_leaving"}, --Ok, I am leaving.
		{"@conversation/station_avatar_platform:s_78", "spacestation_avatar_platform_defiant"}, --And what if I don't leave?
	}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_greeting_trespass);

spacestation_avatar_platform_leaving = ConvoScreen:new {
	id = "spacestation_avatar_platform_leaving",
	leftDialog = "@conversation/station_avatar_platform:s_76", --You are smarter than you look. Good decision.
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_leaving);

spacestation_avatar_platform_defiant = ConvoScreen:new {
	id = "spacestation_avatar_platform_defiant",
	leftDialog = "@conversation/station_avatar_platform:s_80", --You have failed to comply with a direct order. Scrambling fighters for an intercept with trespassing vessel. Terminating communcation with unauthorized vessel.
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_defiant);

--Comm system shot out, the platform is losing
spacestation_avatar_platform_greeting_damaged = ConvoScreen:new {
	id = "spacestation_avatar_platform_greeting_damaged",
	leftDialog = "@conversation/station_avatar_platform:s_81", --...breaking up...station badly damaged...warning...high levels of...
	stopConversation = "false",
	options = {
		{"@conversation/station_avatar_platform:s_82", "spacestation_avatar_platform_garbled_land"}, --I just need to land. Can you read me?
		{"@conversation/station_avatar_platform:s_83", "spacestation_avatar_platform_garbled_leave"}, --I think I will keep flying. Good luck.
	}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_greeting_damaged);

spacestation_avatar_platform_garbled_land = ConvoScreen:new {
	id = "spacestation_avatar_platform_garbled_land",
	leftDialog = "@conversation/station_avatar_platform:s_84", --...section eight...watch for...
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_garbled_land);

spacestation_avatar_platform_garbled_leave = ConvoScreen:new {
	id = "spacestation_avatar_platform_garbled_leave",
	leftDialog = "@conversation/station_avatar_platform:s_85", --...service tunnel three...platform one is...resistance still holding sections...
	stopConversation = "true",
	options = {}
}
spacestation_avatar_platform_convotemplate:addScreen(spacestation_avatar_platform_garbled_leave);

-- Add Template (EOF)
addConversationTemplate("spacestation_avatar_platform_convotemplate", spacestation_avatar_platform_convotemplate);

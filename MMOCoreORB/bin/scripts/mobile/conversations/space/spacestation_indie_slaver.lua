-- Independent slaver station. Every screen is backed by a shipped key in
-- conversation/station_indie_slaver.stf. Work only opens to Civilian Protection
-- Guild pilots, so the handler picks the greeting from that standing.

spacestation_indie_slaver_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_indie_slaver_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationIndieSlaverConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_indie_slaver_greeting = ConvoScreen:new {
	id = "spacestation_indie_slaver_greeting",
	leftDialog = "@conversation/station_indie_slaver:s_578", --What can I do for you, buddy?
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_180", "spacestation_indie_slaver_offer"}, --I'm looking for work.
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_greeting);

--out of range
spacestation_indie_slaver_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_indie_slaver:s_204", --Come closer. Stupid low-range comm system! I'm only getting every other word...
	stopConversation = "true",
	options = {}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_out_of_range);

--The Trandoshan transport hijack contract
spacestation_indie_slaver_offer = ConvoScreen:new {
	id = "spacestation_indie_slaver_offer",
	leftDialog = "@conversation/station_indie_slaver:s_185", --I have some work you might be interested in. You see, we're trying to make a name for ourselves here in the Kashyyyk system... but the Trandoshans always show us up!
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_186", "spacestation_indie_slaver_detail"}, --What do you mean?
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_offer);

spacestation_indie_slaver_detail = ConvoScreen:new {
	id = "spacestation_indie_slaver_detail",
	leftDialog = "@conversation/station_indie_slaver:s_188", --The Trandos are pulling in Krayt bellies full of credits every day with their... um... operation. We don't have the time or the resources to compete with them legitimately!
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_190", "spacestation_indie_slaver_orders"}, --Where do I come in?
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_detail);

spacestation_indie_slaver_orders = ConvoScreen:new {
	id = "spacestation_indie_slaver_orders",
	leftDialog = "@conversation/station_indie_slaver:s_193", --I want you to disable Trandoshan slaver transports en route to the Avatar platform. When you do this, we can send a high-frequency slicing signal to their navicomputer. In a few seconds, that transport will become ours!
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_31", "spacestation_indie_slaver_haul"}, --And then?
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_orders);

spacestation_indie_slaver_haul = ConvoScreen:new {
	id = "spacestation_indie_slaver_haul",
	leftDialog = "@conversation/station_indie_slaver:s_32", --And then you lead the transport back here for processing. Don't get me wrong - the Trandoshans aren't going to just let you do this. Expect a lot of resistance.
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_33", "spacestation_indie_slaver_accepted"}, --I'm ready!
		{"@conversation/station_indie_slaver:s_36", "spacestation_indie_slaver_decline"}, --No thanks.
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_haul);

spacestation_indie_slaver_accepted = ConvoScreen:new {
	id = "spacestation_indie_slaver_accepted",
	leftDialog = "@conversation/station_indie_slaver:s_34", --Good luck!
	stopConversation = "true",
	options = {}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_accepted);

spacestation_indie_slaver_decline = ConvoScreen:new {
	id = "spacestation_indie_slaver_decline",
	leftDialog = "@conversation/station_indie_slaver:s_38", --Are you kidding? This is good money I'm paying here!
	stopConversation = "true",
	options = {}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_decline);

--Pilot has not worked for the Civilian Protection Guild yet
spacestation_indie_slaver_greeting_unqualified = ConvoScreen:new {
	id = "spacestation_indie_slaver_greeting_unqualified",
	leftDialog = "@conversation/station_indie_slaver:s_199", --Wish I could help you. Right now we've got our hands full just trying to make ends meet. Have you talked to the Civilian Protection guild yet?
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_200", "spacestation_indie_slaver_who"}, --Who are they?
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_greeting_unqualified);

spacestation_indie_slaver_who = ConvoScreen:new {
	id = "spacestation_indie_slaver_who",
	leftDialog = "@conversation/station_indie_slaver:s_201", --Well, why don't you check in with them and find out for yourself. Go do the Kashyyyk space station. Talk to the gal they have running the place. She'll get you started.
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_203", "spacestation_indie_slaver_then_what"}, --Then what?
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_who);

spacestation_indie_slaver_then_what = ConvoScreen:new {
	id = "spacestation_indie_slaver_then_what",
	leftDialog = "@conversation/station_indie_slaver:s_207", --Then you give it some time! Work for the Civilian Protectors. Get your bearings. Learn the ins and outs. Come back and see me when you're ready.
	stopConversation = "false",
	options = {
		{"@conversation/station_indie_slaver:s_209", "spacestation_indie_slaver_signoff"}, --I will.
	}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_then_what);

spacestation_indie_slaver_signoff = ConvoScreen:new {
	id = "spacestation_indie_slaver_signoff",
	leftDialog = "@conversation/station_indie_slaver:s_211", --Fine. I'll talk to you later.
	stopConversation = "true",
	options = {}
}
spacestation_indie_slaver_convotemplate:addScreen(spacestation_indie_slaver_signoff);

-- Add Template (EOF)
addConversationTemplate("spacestation_indie_slaver_convotemplate", spacestation_indie_slaver_convotemplate);

-- Sordaan's Rodian outpost. Every screen is backed by a shipped key in
-- conversation/station_rodian_base.stf. Contracts only open to Civilian
-- Protection Guild pilots, so the handler picks the greeting from that standing.

spacestation_rodian_base_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_rodian_base_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationRodianBaseConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_rodian_base_greeting = ConvoScreen:new {
	id = "spacestation_rodian_base_greeting",
	leftDialog = "@conversation/station_rodian_base:s_578", --Acknowledged. This is Rodian Security Command. You here to do business with Sordaan?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_180", "spacestation_rodian_base_offer"}, --Yes. What've you got?
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_greeting);

--out of range
spacestation_rodian_base_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_rodian_base:s_204", --What? You're breaking up! Come closer if you want to do business!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_out_of_range);

--The Gotal Bandit contract
spacestation_rodian_base_offer = ConvoScreen:new {
	id = "spacestation_rodian_base_offer",
	leftDialog = "@conversation/station_rodian_base:s_185", --I have an outstanding deal for you, my friend. See, the Gotal Bandits have been a problem for us ever since we came to Kashyyyk. No idea why they picked a fight with us... I don't think they have respect for anything!
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_186", "spacestation_rodian_base_detail"}, --And?
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_offer);

spacestation_rodian_base_detail = ConvoScreen:new {
	id = "spacestation_rodian_base_detail",
	leftDialog = "@conversation/station_rodian_base:s_188", --Master Sordaan would really enjoy seeing the Gotals lose a significant portion of their fighting force! You get me? You think you can help us with this problem?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_189", "spacestation_rodian_base_granted"}, --You got it!
		{"@conversation/station_rodian_base:s_190", "spacestation_rodian_base_pay"}, --What's in it for me?
		{"@conversation/station_rodian_base:s_191", "spacestation_rodian_base_decline"}, --No thanks.
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_detail);

spacestation_rodian_base_granted = ConvoScreen:new {
	id = "spacestation_rodian_base_granted",
	leftDialog = "@conversation/station_rodian_base:s_194", --Don't let me down, pilot!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_granted);

spacestation_rodian_base_pay = ConvoScreen:new {
	id = "spacestation_rodian_base_pay",
	leftDialog = "@conversation/station_rodian_base:s_193", --This is an excellent credit opportunity for a pilot such as you. What do you say to three hundred cred per kill... and a tiny bit of my respect when you're finished?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_195", "spacestation_rodian_base_accepted"}, --I'll take it.
		{"@conversation/station_rodian_base:s_196", "spacestation_rodian_base_haggle"}, --You can do better than that.
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_pay);

spacestation_rodian_base_haggle = ConvoScreen:new {
	id = "spacestation_rodian_base_haggle",
	leftDialog = "@conversation/station_rodian_base:s_197", --Maybe I can do better than you?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_195", "spacestation_rodian_base_accepted"}, --I'll take it.
		{"@conversation/station_rodian_base:s_191", "spacestation_rodian_base_decline"}, --No thanks.
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_haggle);

spacestation_rodian_base_accepted = ConvoScreen:new {
	id = "spacestation_rodian_base_accepted",
	leftDialog = "@conversation/station_rodian_base:s_198", --Good! Don't let me down, pilot!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_accepted);

spacestation_rodian_base_decline = ConvoScreen:new {
	id = "spacestation_rodian_base_decline",
	leftDialog = "@conversation/station_rodian_base:s_192", --You'll be back!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_decline);

--Pilot has not worked for the Civilian Protection Guild yet
spacestation_rodian_base_greeting_unqualified = ConvoScreen:new {
	id = "spacestation_rodian_base_greeting_unqualified",
	leftDialog = "@conversation/station_rodian_base:s_199", --Hmm. I don't have anything for you right now. For better or for worse, we only hire Civilian Protection Guild pilots. They're the only ones we can trust.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_200", "spacestation_rodian_base_trust"}, --You can trust me!
		{"@conversation/station_rodian_base:s_203", "spacestation_rodian_base_how"}, --How do I become a Civilian Protector?
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_greeting_unqualified);

spacestation_rodian_base_trust = ConvoScreen:new {
	id = "spacestation_rodian_base_trust",
	leftDialog = "@conversation/station_rodian_base:s_201", --Oh, I'm sure. However, I can't offer contracts to any pilot who has yet to prove themselves as a strong Civilian Protector. Sorry about that.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_203", "spacestation_rodian_base_how"}, --How do I become a Civilian Protector?
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_trust);

spacestation_rodian_base_how = ConvoScreen:new {
	id = "spacestation_rodian_base_how",
	leftDialog = "@conversation/station_rodian_base:s_207", --The Kashyyyk space station is run by a Civilian Protector named Rian Ry. Work with her for a while. When she runs out of errands for you, stop by and we'll talk.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_base:s_209", "spacestation_rodian_base_signoff"}, --I will.
	}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_how);

spacestation_rodian_base_signoff = ConvoScreen:new {
	id = "spacestation_rodian_base_signoff",
	leftDialog = "@conversation/station_rodian_base:s_211", --Rodian Protectors out.
	stopConversation = "true",
	options = {}
}
spacestation_rodian_base_convotemplate:addScreen(spacestation_rodian_base_signoff);

-- Add Template (EOF)
addConversationTemplate("spacestation_rodian_base_convotemplate", spacestation_rodian_base_convotemplate);

-- Tripp's Rodian outpost. Every screen is backed by a shipped key in
-- conversation/station_rodian_tripp_base.stf. Contracts only open to Civilian
-- Protection Guild pilots, so the handler picks the greeting from that standing.

spacestation_rodian_tripp_base_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_rodian_tripp_base_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationRodianTrippBaseConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_rodian_tripp_base_greeting = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_greeting",
	leftDialog = "@conversation/station_rodian_tripp_base:s_578", --Hello? This is the security chief... are you here for a job or something?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_180", "spacestation_rodian_tripp_base_offer"}, --Yes. What've you got?
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_greeting);

--out of range
spacestation_rodian_tripp_base_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_rodian_tripp_base:s_204", --What? You're breaking up! Come closer if you want to do business!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_out_of_range);

--The Chiss poacher contract
spacestation_rodian_tripp_base_offer = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_offer",
	leftDialog = "@conversation/station_rodian_tripp_base:s_185", --We have trouble with the Chiss. Stupid poachers! Tripp has ordered me to offer seek-and-destroy contracts to any willing pilot of sufficient standing.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_186", "spacestation_rodian_tripp_base_detail"}, --Sounds good.
		{"@conversation/station_rodian_tripp_base:s_191", "spacestation_rodian_tripp_base_decline"}, --No thanks.
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_offer);

spacestation_rodian_tripp_base_detail = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_detail",
	leftDialog = "@conversation/station_rodian_tripp_base:s_188", --The Chiss are polluting our hunting grounds on Kashyyyk! They have already landed a number of settler ships on the planet surface. We cannot allow them to land any more!
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_190", "spacestation_rodian_tripp_base_orders"}, --What do I do about it?
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_detail);

spacestation_rodian_tripp_base_orders = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_orders",
	leftDialog = "@conversation/station_rodian_tripp_base:s_193", --I will upload coordinates of Chiss settlers and their landing craft. You intercept them and destroy every last one of them. Sound good?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_195", "spacestation_rodian_tripp_base_accepted"}, --I'll take it.
		{"@conversation/station_rodian_tripp_base:s_196", "spacestation_rodian_tripp_base_pay"}, --What's it worth to you?
		{"@conversation/station_rodian_tripp_base:s_26", "spacestation_rodian_tripp_base_skip"}, --I'll skip this.
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_orders);

spacestation_rodian_tripp_base_pay = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_pay",
	leftDialog = "@conversation/station_rodian_tripp_base:s_197", --Three hundred and fifty cred per lousy, worthless Chiss Poacher starship you bring down! How does that sound?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_25", "spacestation_rodian_tripp_base_upload"}, --Sounds good.
		{"@conversation/station_rodian_tripp_base:s_26", "spacestation_rodian_tripp_base_skip"}, --I'll skip this.
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_pay);

spacestation_rodian_tripp_base_upload = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_upload",
	leftDialog = "@conversation/station_rodian_tripp_base:s_28", --Uploading mission package now!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_upload);

spacestation_rodian_tripp_base_accepted = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_accepted",
	leftDialog = "@conversation/station_rodian_tripp_base:s_198", --Good! Don't let me down, pilot!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_accepted);

spacestation_rodian_tripp_base_skip = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_skip",
	leftDialog = "@conversation/station_rodian_tripp_base:s_27", --Well... okay...
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_skip);

spacestation_rodian_tripp_base_decline = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_decline",
	leftDialog = "@conversation/station_rodian_tripp_base:s_192", --What? Are you kidding?
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_decline);

--Pilot has not worked for the Civilian Protection Guild yet
spacestation_rodian_tripp_base_greeting_unqualified = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_greeting_unqualified",
	leftDialog = "@conversation/station_rodian_tripp_base:s_199", --Wait. Um. No. There's nothing I can give you right now. Tripp has laid out specific orders. Only the Civilian Protection Guild gets our contracts. They are the only ones we can trust.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_200", "spacestation_rodian_tripp_base_trust"}, --You can trust me!
		{"@conversation/station_rodian_tripp_base:s_203", "spacestation_rodian_tripp_base_how"}, --How do I become a Civilian Protector?
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_greeting_unqualified);

spacestation_rodian_tripp_base_trust = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_trust",
	leftDialog = "@conversation/station_rodian_tripp_base:s_201", --Yeah. Oh, yeah. I trust you just fine. That's not the thing. Tripp wants it this way. He's the boss. If it were up to me, I'd give you the contract right now! But, it's not up to me. You see?
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_203", "spacestation_rodian_tripp_base_how"}, --How do I become a Civilian Protector?
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_trust);

spacestation_rodian_tripp_base_how = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_how",
	leftDialog = "@conversation/station_rodian_tripp_base:s_207", --Go to the Kashyyyk space station. There you will find a human named Rian Ry. She commands the Civilian Protection Guild space fleet. Work for her a bit then come see us again.
	stopConversation = "false",
	options = {
		{"@conversation/station_rodian_tripp_base:s_209", "spacestation_rodian_tripp_base_signoff"}, --I will.
	}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_how);

spacestation_rodian_tripp_base_signoff = ConvoScreen:new {
	id = "spacestation_rodian_tripp_base_signoff",
	leftDialog = "@conversation/station_rodian_tripp_base:s_211", --Good! I'll see you later!
	stopConversation = "true",
	options = {}
}
spacestation_rodian_tripp_base_convotemplate:addScreen(spacestation_rodian_tripp_base_signoff);

-- Add Template (EOF)
addConversationTemplate("spacestation_rodian_tripp_base_convotemplate", spacestation_rodian_tripp_base_convotemplate);

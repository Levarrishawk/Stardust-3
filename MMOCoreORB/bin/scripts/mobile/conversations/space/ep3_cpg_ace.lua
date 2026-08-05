-- Civilian Protection Guild ace, "CPG Patrol Gamma" (s_351). Ship agents ep3_cpg_ace_tier4 /
-- ep3_cpg_ace_tier5, comm portraits shared_space_comm_ep3_cpg_ace_01.iff / _02.iff.
--
-- This giver GRANTS NOTHING. Every shipped line in conversation/ep3_cpg_ace.stf either points the
-- pilot at Rian Ry (s_169) or comments on a job Rian already handed out. There is no offer/accept
-- pair anywhere in the file, so wiring a quest onto him would be authored content, not client
-- content. He is built because the client ships him a portrait and a full set of lines.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key. Nothing is authored.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY, as for the veteran: the .stf is a flat key/value dump
-- and the client ships no screen graph. The strings are client fact; the edges are reconstructed.
--
-- UNUSED SHIPPED KEYS: none, except do_not_edit and s_183 (empty string in the client file).

ep3_cpg_ace_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_cpg_ace_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3CpgAceConvoHandler",
	screens = {}
}

ep3_cpg_ace_greeting = ConvoScreen:new {
	id = "ep3_cpg_ace_greeting",
	leftDialog = "@conversation/ep3_cpg_ace:s_351", --Roger. This is CPG Patrol Gamma.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_168", "ep3_cpg_ace_rian"}, --Is there anything to do around here?
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_greeting);

ep3_cpg_ace_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/ep3_cpg_ace:s_185", --[ ... Transmission Blocked ... ]
	stopConversation = "true",
	options = {}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_out_of_range);

ep3_cpg_ace_busy = ConvoScreen:new {
	id = "ep3_cpg_ace_busy",
	leftDialog = "@conversation/ep3_cpg_ace:s_156", --Hey! Either you back off or you help me out, okay?
	stopConversation = "true",
	options = {}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_busy);

ep3_cpg_ace_welcome = ConvoScreen:new {
	id = "ep3_cpg_ace_welcome",
	leftDialog = "@conversation/ep3_cpg_ace:s_187", --Come to Kashyyyk for some excitement, eh? You won't be disappointed!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_34", "ep3_cpg_ace_good_luck"}, --Thanks!
		{"@conversation/ep3_cpg_ace:s_168", "ep3_cpg_ace_rian"}, --Is there anything to do around here?
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_welcome);

ep3_cpg_ace_rian = ConvoScreen:new {
	id = "ep3_cpg_ace_rian",
	leftDialog = "@conversation/ep3_cpg_ace:s_169", --You should check in with Rian Ry. She's commander of the Kashyyyk space station.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_27", "ep3_cpg_ace_take_care"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_rian);

ep3_cpg_ace_take_care = ConvoScreen:new {
	id = "ep3_cpg_ace_take_care",
	leftDialog = "@conversation/ep3_cpg_ace:s_28", --Take care, %NU.
	stopConversation = "true",
	options = {}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_take_care);

ep3_cpg_ace_good_luck = ConvoScreen:new {
	id = "ep3_cpg_ace_good_luck",
	leftDialog = "@conversation/ep3_cpg_ace:s_36", --Good luck!
	stopConversation = "true",
	options = {}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_good_luck);

-- Same job as the veteran's s_233: escort/ep3_kash_station_escort_alpha, the damaged droid pilot.
ep3_cpg_ace_droid = ConvoScreen:new {
	id = "ep3_cpg_ace_droid",
	leftDialog = "@conversation/ep3_cpg_ace:s_233", --Look - that droid pilot's not going to save himself, okay? Get busy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_27", "ep3_cpg_ace_good_luck"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_droid);

-- s_235 names the Gotal bandits outright, which is escort/ep3_kash_station_escort_bravo.
ep3_cpg_ace_gotal = ConvoScreen:new {
	id = "ep3_cpg_ace_gotal",
	leftDialog = "@conversation/ep3_cpg_ace:s_235", --So you're off to beat up on some Gotal bandits, eh? Good. I hate those guys!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_34", "ep3_cpg_ace_good_luck"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_gotal);

-- "a disabled transport in the Tyyyn nebula... again" is rescue/ep3_kash_station_rescue_bravo --
-- the second Tyyyn rescue, whose own STF is the direct sequel to rescue_alpha ("They have gone
-- after yet another civilian transport"). The "again" is what makes it bravo rather than alpha.
ep3_cpg_ace_tyyyn = ConvoScreen:new {
	id = "ep3_cpg_ace_tyyyn",
	leftDialog = "@conversation/ep3_cpg_ace:s_237", --I hear there's a disabled transport in the Tyyyn nebula... again. Think can you handle a rescue like this by yourself?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_239", "ep3_cpg_ace_dock_tip"}, --No doubt.
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_tyyyn);

ep3_cpg_ace_dock_tip = ConvoScreen:new {
	id = "ep3_cpg_ace_dock_tip",
	leftDialog = "@conversation/ep3_cpg_ace:s_241", --You know, those old fashioned transports can take power directly from your ship. All you have to do is dock.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_27", "ep3_cpg_ace_take_care"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_dock_tip);

ep3_cpg_ace_good_work = ConvoScreen:new {
	id = "ep3_cpg_ace_good_work",
	leftDialog = "@conversation/ep3_cpg_ace:s_165", --%NU! Keep up the good work!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_34", "ep3_cpg_ace_good_luck"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_good_work);

ep3_cpg_ace_praise = ConvoScreen:new {
	id = "ep3_cpg_ace_praise",
	leftDialog = "@conversation/ep3_cpg_ace:s_243", --Good job, %TU! The Ghrag hate your guts! That means you're on the right track!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_ace:s_27", "ep3_cpg_ace_take_care"}, --Thanks!
	}
}
ep3_cpg_ace_convotemplate:addScreen(ep3_cpg_ace_praise);

addConversationTemplate("ep3_cpg_ace_convotemplate", ep3_cpg_ace_convotemplate);

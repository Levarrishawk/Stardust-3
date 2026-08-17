-- Civilian Protection Guild veteran pilot, "CPG Patrol Delta" (s_351).
--
-- He is a SHIP, not a station: ep3_cpg_veteran_tier4 / ep3_cpg_veteran_tier5 both ship the client
-- comm portrait object/mobile/shared_space_comm_ep3_cpg_veteran_01.iff / _02.iff, and
-- NpcConversationStartCommand.h (the isShipAiAgent() branch) starts a conversation with any
-- ShipAiAgent with no distance, line-of-sight or station-type requirement, exactly as it does for
-- the 22 stations. Range is still gated here, by the handler, with checkInConversationRange().
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_cpg_veteran.stf. Nothing is authored.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The .stf is a flat key/value dump; the client ships no
-- screen graph, so which option hangs under which screen is reconstructed here from the text and
-- from SwgConversationEditor's creation order (ids rise depth-first). The strings are client fact;
-- the edges between them are not. The one arc that is unambiguous end to end is the work offer,
-- s_37 -> s_38 -> s_39 -> s_40 -> s_41 -> s_42 -> s_43/s_47 -> s_46/s_49, and that is the arc that
-- hands out destroy_duty/ep3_kash_station_destroy_duty_veteran.
--
-- UNUSED SHIPPED KEYS: none, except do_not_edit and s_183 (empty string in the client file).

ep3_cpg_veteran_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_cpg_veteran_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3CpgVeteranConvoHandler",
	screens = {}
}

-- Default hail. The handler adds the work option (s_37) when the contract is actually available.
ep3_cpg_veteran_greeting = ConvoScreen:new {
	id = "ep3_cpg_veteran_greeting",
	leftDialog = "@conversation/ep3_cpg_veteran:s_351", --Roger. This is CPG Patrol Delta.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_168", "ep3_cpg_veteran_rian"}, --Any work around here?
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_greeting);

-- Out of comm range. Same role as the stations' s_204 screen.
ep3_cpg_veteran_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/ep3_cpg_veteran:s_185", --What? You're breaking up!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_out_of_range);

-- Brush-off for anyone who is not a pilot in a certified ship.
ep3_cpg_veteran_busy = ConvoScreen:new {
	id = "ep3_cpg_veteran_busy",
	leftDialog = "@conversation/ep3_cpg_veteran:s_156", --Can't you see I'm busy?!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_busy);

-- First hail from a pilot he has not spoken to before.
ep3_cpg_veteran_welcome = ConvoScreen:new {
	id = "ep3_cpg_veteran_welcome",
	leftDialog = "@conversation/ep3_cpg_veteran:s_187", --Welcome to Kashyyyk my friend. Watch your step!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_54", "ep3_cpg_veteran_project"}, --Thanks!
		{"@conversation/ep3_cpg_veteran:s_168", "ep3_cpg_veteran_rian"}, --Any work around here?
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_welcome);

-- The teaser he opens with before the pilot has proved anything. s_57/s_58 are the only two
-- shipped answers to it and s_60/s_59 are the only two shipped replies to those.
ep3_cpg_veteran_project = ConvoScreen:new {
	id = "ep3_cpg_veteran_project",
	leftDialog = "@conversation/ep3_cpg_veteran:s_56", --After you know your way around the Kashyyyk system, we should talk. I am working on a special project... Perhaps you can help?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_57", "ep3_cpg_veteran_stay_safe"}, --Sounds good!
		{"@conversation/ep3_cpg_veteran:s_58", "ep3_cpg_veteran_later"}, --What sort of project?
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_project);

ep3_cpg_veteran_stay_safe = ConvoScreen:new {
	id = "ep3_cpg_veteran_stay_safe",
	leftDialog = "@conversation/ep3_cpg_veteran:s_60", --Stay safe!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_stay_safe);

ep3_cpg_veteran_later = ConvoScreen:new {
	id = "ep3_cpg_veteran_later",
	leftDialog = "@conversation/ep3_cpg_veteran:s_59", --I'll tell you later. Take care!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_later);

-- He points everything he cannot hand out himself at Rian Ry on the Kashyyyk space station, which
-- is where the 18 already-wired station contracts live.
ep3_cpg_veteran_rian = ConvoScreen:new {
	id = "ep3_cpg_veteran_rian",
	leftDialog = "@conversation/ep3_cpg_veteran:s_169", --See Rian Ry at the Kashyyyk space station. She can offer contracts from the Civilian Protection Guild. You can become one of us!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_27", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_rian);

-- The two shipped sign-offs. They carry the same text; both are kept so no shipped key is dropped.
ep3_cpg_veteran_delta_out = ConvoScreen:new {
	id = "ep3_cpg_veteran_delta_out",
	leftDialog = "@conversation/ep3_cpg_veteran:s_28", --Good hunting! CPG Patrol Delta out!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_delta_out);

ep3_cpg_veteran_out = ConvoScreen:new {
	id = "ep3_cpg_veteran_out",
	leftDialog = "@conversation/ep3_cpg_veteran:s_26", --Good hunting! CPG Patrol Delta out!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_out);

--[[
	THE CONTRACT.

	destroy_duty/ep3_kash_station_destroy_duty_veteran, duty_update "\#pcontrast3 CPG Veteran
	Pilot:", is this arc word for word: s_40 "I have modified my starship communication system and
	have sliced in to the main Ghrag command frequency. From what I hear, they are recruiting talent
	from all over the galaxy." / s_42 "I'll stay on patrol here and maintain a lock on their
	communication stream. I'll forward coordinates to you so that you can intercept the replacement
	pilots the Ghrag have recruited." The quest sends the pilot at five levels of Ghrag replacement
	crews and a ghrag_avenger_tier5 boss.

	Corroboration that this giver is meant to be hailed in space, not found on the ground:
	station_kashyyyk.stf s_273 "You might check in with the CPG Veteran pilot that patrols the
	asteroid belt. Look for a friendly YT-1300 vessel protecting the civilian traffic near the
	station." ep3_cpg_veteran_tier4/tier5 are yt1300_tier4/tier5 and already spawn at the belt
	(space_kashyyyk_spawner.lua, kash_cpg_veteran_belt_1 at 3340/2308/3473).
]]
ep3_cpg_veteran_work_1 = ConvoScreen:new {
	id = "ep3_cpg_veteran_work_1",
	leftDialog = "@conversation/ep3_cpg_veteran:s_38", --Well, there is some new trouble brewing in Kashyyyk. The Ghrag are beaten but they are still here... and they are trying to get back in the game.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_39", "ep3_cpg_veteran_work_2"}, --How do you know this?
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_work_1);

ep3_cpg_veteran_work_2 = ConvoScreen:new {
	id = "ep3_cpg_veteran_work_2",
	leftDialog = "@conversation/ep3_cpg_veteran:s_40", --I have modified my starship communication system and have sliced in to the main Ghrag command frequency. From what I hear, they are recruiting talent from all over the galaxy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_41", "ep3_cpg_veteran_work_3"}, --What do we do about it?
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_work_2);

ep3_cpg_veteran_work_3 = ConvoScreen:new {
	id = "ep3_cpg_veteran_work_3",
	leftDialog = "@conversation/ep3_cpg_veteran:s_42", --I'll stay on patrol here and maintain a lock on their communication stream. I'll forward coordinates to you so that you can intercept the replacement pilots the Ghrag have recruited.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_43", "ep3_cpg_veteran_accept"}, --Sounds good.
		{"@conversation/ep3_cpg_veteran:s_47", "ep3_cpg_veteran_decline"}, --No thanks.
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_work_3);

-- The grant happens in the handler on this screen id.
ep3_cpg_veteran_accept = ConvoScreen:new {
	id = "ep3_cpg_veteran_accept",
	leftDialog = "@conversation/ep3_cpg_veteran:s_46", --Superb!
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_accept);

ep3_cpg_veteran_decline = ConvoScreen:new {
	id = "ep3_cpg_veteran_decline",
	leftDialog = "@conversation/ep3_cpg_veteran:s_49", --Suit yourself... I've got to get back to listening...
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_decline);

-- s_233 names Rian and a droid pilot. escort/ep3_kash_station_escort_alpha is that job: the
-- Kashyyyk station handler documents it from its own STF as "the droid pilot of this freighter has
-- been damaged by bandits and cannot leave the system without help"
-- (spacestation_kashyyyk_conv_handler.lua, SPACESTATION_KASHYYYK_DROID).
ep3_cpg_veteran_droid = ConvoScreen:new {
	id = "ep3_cpg_veteran_droid",
	leftDialog = "@conversation/ep3_cpg_veteran:s_233", --Rian asked you to save that droid pilot, didn't she? You ought to get moving...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_27", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_droid);

-- s_235 is "the civilian transport" and "those bandits". escort/ep3_kash_station_escort_bravo is
-- the only Kashyyyk job whose text is both: "a civilian transport that was damaged by Gotal
-- bandits... near the Gotal bandits stronghold" (SPACESTATION_KASHYYYK_GOTAL), and its attackers
-- are literally the gotal_bandit_* agents.
ep3_cpg_veteran_gotal = ConvoScreen:new {
	id = "ep3_cpg_veteran_gotal",
	leftDialog = "@conversation/ep3_cpg_veteran:s_235", --Good luck, %TU! Save the civilian transport from those bandits!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_27", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_gotal);

-- "the CPG commander" is Rian Ry. Her handler's stage 3 is the first rung where she says the guild
-- is "cleared to offer transport protection contracts to you", so that is when this is true.
ep3_cpg_veteran_cpg_friend = ConvoScreen:new {
	id = "ep3_cpg_veteran_cpg_friend",
	leftDialog = "@conversation/ep3_cpg_veteran:s_237", --So you're making friends with the CPG commander, eh?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_239", "ep3_cpg_veteran_our_side"}, --Roger that.
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_cpg_friend);

ep3_cpg_veteran_our_side = ConvoScreen:new {
	id = "ep3_cpg_veteran_our_side",
	leftDialog = "@conversation/ep3_cpg_veteran:s_241", --Glad to have you on our side!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_27", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_our_side);

ep3_cpg_veteran_good_work = ConvoScreen:new {
	id = "ep3_cpg_veteran_good_work",
	leftDialog = "@conversation/ep3_cpg_veteran:s_165", --%NU! Keep up the good work!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_159", "ep3_cpg_veteran_out"}, --You bet.
		{"@conversation/ep3_cpg_veteran:s_160", "ep3_cpg_veteran_on_track"}, --It's not too bad.
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_good_work);

ep3_cpg_veteran_on_track = ConvoScreen:new {
	id = "ep3_cpg_veteran_on_track",
	leftDialog = "@conversation/ep3_cpg_veteran:s_161", --Don't worry. You'll get back on-track!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_24", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_on_track);

-- FLAGGED INTERPRETATION -- s_162 is the one shipped line with a faction edge to it, and s_23
-- "Yes. My side." is the only shipped answer that fits it. The client names no trigger for it. It
-- is used here as the hail an Imperial-aligned pilot gets from a Civilian Protection Guild
-- volunteer. If the owner would rather it never fire, delete the one branch in
-- Ep3CpgVeteranConvoHandler:getInitialScreen() that returns it; nothing else depends on it.
ep3_cpg_veteran_right_side = ConvoScreen:new {
	id = "ep3_cpg_veteran_right_side",
	leftDialog = "@conversation/ep3_cpg_veteran:s_162", --Oh no? Are you sure you're fighting for the right side?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_23", "ep3_cpg_veteran_out"}, --Yes. My side.
		{"@conversation/ep3_cpg_veteran:s_25", "ep3_cpg_veteran_out"}, --Hmph.
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_right_side);

-- Once the Ghrag interception contract is done.
ep3_cpg_veteran_praise = ConvoScreen:new {
	id = "ep3_cpg_veteran_praise",
	leftDialog = "@conversation/ep3_cpg_veteran:s_243", --Good job, %TU! The Ghrag hate your guts! That means you're on the right track!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_27", "ep3_cpg_veteran_delta_out"}, --Thanks!
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_praise);

-- s_273/s_283 only make sense after a transport has been lost. Rian's handler already tracks
-- exactly that (its stages 6, 8 and 10 are the three "you lost it" side states), so this hail is
-- driven off her stage rather than off a new flag of ours.
ep3_cpg_veteran_lost = ConvoScreen:new {
	id = "ep3_cpg_veteran_lost",
	leftDialog = "@conversation/ep3_cpg_veteran:s_273", --So you lost a civilian transport, huh? Gives you a terrible sick feeling in your stomach, doesn't it?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cpg_veteran:s_25", "ep3_cpg_veteran_lost_detail"}, --Hmph.
	}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_lost);

ep3_cpg_veteran_lost_detail = ConvoScreen:new {
	id = "ep3_cpg_veteran_lost_detail",
	leftDialog = "@conversation/ep3_cpg_veteran:s_283", --They say that when a civilian transport goes critical the atmosphere inside the vessel reaches two thousand degrees. It's a quick death.
	stopConversation = "true",
	options = {}
}
ep3_cpg_veteran_convotemplate:addScreen(ep3_cpg_veteran_lost_detail);

addConversationTemplate("ep3_cpg_veteran_convotemplate", ep3_cpg_veteran_convotemplate);

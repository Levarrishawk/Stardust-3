-- Mosolium Zssik -- Trandoshan handler preparing the player for the meeting with the Wookiee
-- resistance. The repo mobile is named ep3_musolium; the client conversation file is
-- ep3_trandoshan_mosolium_zssik_03. Both spellings are kept as they ship.
--
-- Giver for inspect/ep3_trando_mosolium_zssik_04 (KashyyykSlaverScreenplay.lua, registered line
-- 659). Before this file nothing in the repo gave that quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_trandoshan_mosolium_zssik_03.stf (41 entries). Nothing is authored.
--
-- The arc matches the screenplay field for field: s_1103 "All flight leaders of the Blackscale have
-- them in their ship computers. You will intercept a flight leader, disable his fighter, and steal
-- the codes directly from his computer banks" is inspectTargets = {"trn_slaver_fighter_tier5"} with
-- inspectCargo = "avatar_landing_codes"; s_1107 "they are somewhere in orbit above the planet... you
-- are just going to have to do some old fashioned searching" is questZone space_kashyyyk with a
-- single targetLocation.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order.
--
-- GROUND LEG NOT ENFORCED. After the space inspect, s_1061 sends the player to kill Klesk in
-- southern Etyyy and take his key card. There is no Kashyyyk ground screenplay, no Kashyyyk ground
-- spawn areas and no Klesk mobile in this repo, so that leg cannot be checked. The handler advances
-- it one step per hail behind a single named switch (MOSOLIUM_GROUND_LEG_AUTO); see the block above
-- it. The dialogue is client fact; that progression is not.
--
-- UNUSED SHIPPED KEYS:
--   s_1037 -- empty string in the client file.
--   s_148  -- "Listen up %NU. I am going to be honest with you..." is the same speech as s_1087 plus
--             s_1091 merged into one line with a name token. It is an alternate delivery of screens
--             already used below, not a distinct screen, so it is not double-used here.

ep3_musolium_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_musolium_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3MusoliumConvoHandler",
	screens = {}
}

-- The player has not been sent here yet. He names Boshaz, who is the step before him.
ep3_musolium_stranger = ConvoScreen:new {
	id = "ep3_musolium_stranger",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1113", --What do you want? Do I look like someone who would want to talk with the likes of you? Perhaps you should go talk to Boshaz. He seems to enjoy talking to offworlders.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_stranger);

ep3_musolium_greeting = ConvoScreen:new {
	id = "ep3_musolium_greeting",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1087", --I thought I told you that I didn't want to buy any of tha...oh, it's you. Listen, I am going to be honest with you...I don't like you. I don't like all this sneaking around. If I had my way we would solve the Blackscale issue in combat like true Trandoshans. But Hssissk has strictly forbidden that so I guess I will have to make due with you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1089", "ep3_musolium_gifts"}, --I am not too thrilled with you either.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_greeting);

ep3_musolium_gifts = ConvoScreen:new {
	id = "ep3_musolium_gifts",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1091", --You do not have to like me. You just need to do what I tell you to. I have been charged with preparing you for your meeting with the resistance. You will need to bring them a few...eh, gifts.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1093", "ep3_musolium_why"}, --What do I need to bring them gifts for?
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_gifts);

ep3_musolium_why = ConvoScreen:new {
	id = "ep3_musolium_why",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1095", --Fool! What did you think we were setting this meeting up for anyways? An afternoon brunch? We are going to supply them with the access codes to the Avatar Space Platform. Of course, we do not have the access codes...yet. But I know how to get them and you will get them for me. Understood?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1097", "ep3_musolium_landing"}, --Just point me in the right direction.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_why);

ep3_musolium_landing = ConvoScreen:new {
	id = "ep3_musolium_landing",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1099", --Well, the first step is that we need to get landing access. Nothing else matters unless we can get a crew to actually land on the station. You will have to steal a set of access keys. Fortunately for us the Blackscale have gotten very lax on security and hardly ever change their passcodes anymore.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1101", "ep3_musolium_how"}, --Sure. How do I steal a landing access code?
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_landing);

ep3_musolium_how = ConvoScreen:new {
	id = "ep3_musolium_how",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1103", --All flight leaders of the Blackscale have them in their ship computers. You will intercept a flight leader, disable his fighter, and steal the codes directly from his computer banks. When you are done, do what you will with the flight leader. Naturally, I recommend you vaporize him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1105", "ep3_musolium_accept"}, --Ok, and where can I find these flight leaders?
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1109", "ep3_musolium_decline"}, --I don't like your attitude. Get them yourself.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_how);

-- The grant happens in the handler on this screen id.
ep3_musolium_accept = ConvoScreen:new {
	id = "ep3_musolium_accept",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1107", --Obviously, they are somewhere in orbit above the planet. They do not file flight plans with us, so I am afraid you are just going to have to do some old fashioned searching. When you have the codes come back and see me again. I have more work for you to do.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_accept);

ep3_musolium_decline = ConvoScreen:new {
	id = "ep3_musolium_decline",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1111", --You are already in this too deep to just quit now. Why don't you take a few moments and think about it. Come back and see me when you are ready to fulfill your promise to us.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_decline);

-- Inspect running.
ep3_musolium_busy = ConvoScreen:new {
	id = "ep3_musolium_busy",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1085", --Maybe you should think about finishing the mission you have already started before trying to take another one. When I hire a pilot I want their absolute concentration.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_busy);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_1075 "So, you failed to steal the landing access
	codes" is written for a player who took the inspect and lost it. SpaceInspectScreenplay leaves no
	distinguishable failure record the conversation can read, so this handler cannot separate "failed"
	from "walked away": it shows this arc to anyone who once accepted and no longer has the quest
	active or complete. The text is client fact; that trigger is not.
]]
ep3_musolium_failed = ConvoScreen:new {
	id = "ep3_musolium_failed",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1075", --So, you failed to steal the landing access codes. Don't look so surprised...we have monitoring stations all through this station.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1077", "ep3_musolium_retry_yes"}, --A minor set back. I will get it right this time.
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1081", "ep3_musolium_retry_no"}, --I am going to have to try again later.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_failed);

-- Re-grant happens in the handler on this screen id.
ep3_musolium_retry_yes = ConvoScreen:new {
	id = "ep3_musolium_retry_yes",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1079", --I am sure you will. My confidence is soaring. Just go get me the access codes from a Blackscale flight leader.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_retry_yes);

ep3_musolium_retry_no = ConvoScreen:new {
	id = "ep3_musolium_retry_no",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1083", --Why am I not surprised at your reluctance? Fine, come back to see me later...if I still have need of you, I will let you know then.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_retry_no);

-- Codes delivered. This is where the GROUND leg (kill Klesk, take his key card) is handed out.
ep3_musolium_codes_in = ConvoScreen:new {
	id = "ep3_musolium_codes_in",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1053", --You have made it back. How interesting. I was certain that you were just as soft as you look, but maybe you do have something to you. The codes appear to be in order and now we move onto the next stage of our operation. Now we need to get the Avatar's access keys.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1055", "ep3_musolium_keys"}, --Isn't that what I just got?
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_codes_in);

ep3_musolium_keys = ConvoScreen:new {
	id = "ep3_musolium_keys",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1057", --Of course not. All you stole from the flight leader was the landing codes. You still need to get the codes that will actually let you inside the station itself. You will need to get that from a Blackscale who has access.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1059", "ep3_musolium_klesk"}, --Ok, how do I get the Avatar's access keys?
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_keys);

ep3_musolium_klesk = ConvoScreen:new {
	id = "ep3_musolium_klesk",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1061", --By stealing a special key card that their slave masters carry. There is one in particular that I want you to make disappear. He goes by the name of Klesk and is currently working down south in Etyyy. There are rumors that the Blackscales maintain a small slaver camp in the southern portion of the area. You should start your search for him there.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1063", "ep3_musolium_ready"}, --There certainly are a lot of keys and codes involved in getting in there.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_klesk);

ep3_musolium_ready = ConvoScreen:new {
	id = "ep3_musolium_ready",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1065", --Did you expect it to be protected by a rusty screen door? Of course, when we take over, the entire system will be overhauled and we will use DNA scanners to determine who should be allowed inside. Are you ready to get started?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1067", "ep3_musolium_klesk_accept"}, --Yes, I am ready to begin.
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1071", "ep3_musolium_klesk_later"}, --I need to take care of some other business first.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_ready);

ep3_musolium_klesk_accept = ConvoScreen:new {
	id = "ep3_musolium_klesk_accept",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1069", --Good. And feel free to make Klesk suffer a little before you put him down. Once you have his pass stop by and I will give you further instructions.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_klesk_accept);

ep3_musolium_klesk_later = ConvoScreen:new {
	id = "ep3_musolium_klesk_later",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1073", --Very well. Come back and talk to me again when you think you are ready. Make it quick...I do not want to lose this chance to take Klesk out.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_klesk_later);

-- Klesk leg running.
ep3_musolium_klesk_active = ConvoScreen:new {
	id = "ep3_musolium_klesk_active",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1051", --What are you doing talking to me? I told you to go kill Klesk in Etyyy and take his key card. Do not come back to me until you have done so.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_klesk_active);

-- Key card in hand -- the whole Mosolium step is finished and the player is passed to Orooroo.
ep3_musolium_payoff = ConvoScreen:new {
	id = "ep3_musolium_payoff",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1041", --Nicely done. With that pass code we now have full access to the Avatar Space Platform. And you have recovered the codes just in time, Chawroo has sent word to Orooroo that the Wookiees are ready to speak with you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1043", "ep3_musolium_orooroo"}, --Great, so what do I do.
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1047", "ep3_musolium_orooroo_later"}, --I have to take care of something first.
	}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_payoff);

ep3_musolium_orooroo = ConvoScreen:new {
	id = "ep3_musolium_orooroo",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1045", --Turn around, walk over to Orooroo, and talk to him. Orooroo may be a Wookiee but he knows a winning team when he sees one. I have no doubts that he will guide you down the correct path.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_orooroo);

ep3_musolium_orooroo_later = ConvoScreen:new {
	id = "ep3_musolium_orooroo_later",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1049", --Alright. We should be okay. I doubt that the Blackscale will notice one of their slave masters gone for a while so there isn't much chance of them disabling the key card.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_orooroo_later);

-- Every hail after that.
ep3_musolium_done = ConvoScreen:new {
	id = "ep3_musolium_done",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1039", --You should speak to Orooroo because I have no further use for you.
	stopConversation = "true",
	options = {}
}
ep3_musolium_convotemplate:addScreen(ep3_musolium_done);

addConversationTemplate("ep3_musolium_convotemplate", ep3_musolium_convotemplate);

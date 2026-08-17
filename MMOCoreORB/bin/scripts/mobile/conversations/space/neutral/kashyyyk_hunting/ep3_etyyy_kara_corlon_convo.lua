-- Kara Corlon -- Kachirho contact running goods off Kashyyyk without the Rodian hunters knowing.
--
-- Giver for the three-leg poacher delivery run that had no giver:
--
--     delivery_no_pickup/ep3_hunting_kara_poacher_delivery_01   (head, questZone space_dantooine)
--         -> delivery_no_pickup/ep3_hunting_kara_poacher_delivery_02   (space_tatooine)
--             -> delivery_no_pickup/ep3_hunting_kara_poacher_delivery_03   (space_dathomir)
--
-- All three globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua and are
-- registered there (lines 205, 241, 276). Legs 02 and 03 carry sideQuest = true with
-- SIDE_QUEST_SPLIT_TYPES.COMPLETION, so the screenplays hand them out themselves; only the head is
-- granted cold from this conversation. The two mid-chain screens below are the client's own
-- "where are you with this" prompts and double as the recovery path if a leg is lost.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_kara_corlon.stf (33 entries). Nothing is authored.
--
-- The route matches the screenplay field for field: s_88 "Your first stop will be in the Dantooine
-- system" is leg 01's questZone space_dantooine; "We've had trouble with Blackscale pirates in the
-- past, and they may come after you" is its attackShips (blacksun_fighter_s01_tier4 /
-- blacksun_fighter_s02_tier4); s_54 "I need you to go to the Tatooine system" is leg 02
-- (space_tatooine); s_44 "This one is in... the Dathomir system" is leg 03 (space_dathomir).
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order, with the per-leg screens (s_64 / s_54 / s_44)
-- keyed off which leg the player is actually carrying.
--
-- UNUSED SHIPPED KEYS:
--   s_34  -- empty string in the client file.
--   s_38  -- "About those deliveries you asked me to make..." is a PLAYER line whose shipped answer
--            is s_40, but the client ships no NPC screen to hang it on. s_40 is used below as a
--            standalone screen; s_38 is left out rather than invent a parent for it.

ep3_etyyy_kara_corlon_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_kara_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyKaraCorlonConvoHandler",
	screens = {}
}

ep3_kara_greeting = ConvoScreen:new {
	id = "ep3_kara_greeting",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_78", --Why are you snooping around here? Go away. These poor Arconans are trying to find relief from their addiction to salt.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_80", "ep3_kara_intro"}, --Johnson Smith sent me to help you.
		{"@conversation/ep3_etyyy_kara_corlon:s_94", "ep3_kara_salt"}, --Really, they're addicted to salt?
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_greeting);

ep3_kara_salt = ConvoScreen:new {
	id = "ep3_kara_salt",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_96", --Apparently. It veils their vision with an addictive hallucination of colors. Or something like that. Regardless, you should not be here. And I should not be talking to you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_salt);

ep3_kara_intro = ConvoScreen:new {
	id = "ep3_kara_intro",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_82", --Did he? Hmmm, I guess if Johnson trusts you then maybe I can as well. I actually could use some help with some deliveries. Ready to get started?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_84", "ep3_kara_accept"}, --Yes, let's do this.
		{"@conversation/ep3_etyyy_kara_corlon:s_90", "ep3_kara_later"}, --Not just yet. I'll come back later.
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_intro);

ep3_kara_later = ConvoScreen:new {
	id = "ep3_kara_later",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_92", --Right. Don't tarry for too long. I'm already having second thoughts about trusting you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_later);

-- The grant of leg 01 happens in the handler on this screen id.
ep3_kara_accept = ConvoScreen:new {
	id = "ep3_kara_accept",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_88", --I'll have the cargo loaded onto your ship. [*fiddles with her datapad*] Your first stop will be in the Dantooine system. When you arrive in that area, we'll upload your exact destination within the system to you. Be alert and ready for trouble. We've had trouble with Blackscale pirates in the past, and they may come after you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_accept);

-- The client wrote its own "you already have a space task" gate for the first offer.
ep3_kara_busy_first = ConvoScreen:new {
	id = "ep3_kara_busy_first",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_86", --Great. First I need... wait, you already have something to do in space. You'll need to complete that before you can attempt any deliveries for me. Come back once your current space task is done.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_busy_first);

-- ...and its own version of the same gate for a player who is mid-chain with a leg in flight.
ep3_kara_busy_other = ConvoScreen:new {
	id = "ep3_kara_busy_other",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_40", --Before we talk about this, you need to complete your current space tasks.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_busy_other);

-- Leg 01 in flight (Dantooine). "Go finish what you've started" is a nudge, not a re-offer, so the
-- handler does not re-grant on this arc.
ep3_kara_leg1 = ConvoScreen:new {
	id = "ep3_kara_leg1",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_64", --I really need those goods to be delivered to Dantooine. My contacts there are getting edgy. Go  finish what you've started.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_66", "ep3_kara_leg1_go"}, --I'm on my way.
		{"@conversation/ep3_etyyy_kara_corlon:s_70", "ep3_kara_leg1_later"}, --I can't right now. I'll try later.
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg1);

ep3_kara_leg1_go = ConvoScreen:new {
	id = "ep3_kara_leg1_go",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_68", --Please hurry and make the delivery. I need to recoup some some profits from this venture soon, or Laen will want some answers. And I don't have any.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg1_go);

ep3_kara_leg1_later = ConvoScreen:new {
	id = "ep3_kara_leg1_later",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_72", --[*sigh*] Fine. But please hurry back. Or maybe I should just look elsewhere for help with this.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg1_later);

-- Leg 01 home but leg 02 is neither running nor done -- "Was there a mix up with the second
-- delivery?" is the client's own recovery line, so this arc re-offers leg 02 (Tatooine). s_62 naming
-- "that first delivery" is what pins this pair to leg 02.
ep3_kara_leg2 = ConvoScreen:new {
	id = "ep3_kara_leg2",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_54", --Was there a mix up with the second delivery? I need you to go to the Tatooine system. I've arranged to have a freighter meet you there. They will take these goods to Jab... to my buyer.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_56", "ep3_kara_leg2_go"}, --I'm on my way.
		{"@conversation/ep3_etyyy_kara_corlon:s_60", "ep3_kara_leg2_later"}, --I can't right now. I'll try later.
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg2);

-- Re-grant of leg 02 happens in the handler on this screen id.
ep3_kara_leg2_go = ConvoScreen:new {
	id = "ep3_kara_leg2_go",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_58", --There will be one more delivery after this one. But more on that later. For now head to the Tatooine system.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg2_go);

ep3_kara_leg2_later = ConvoScreen:new {
	id = "ep3_kara_leg2_later",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_62", --Okay. That first delivery bought my some daylight. But please don't dally too long. I need this next one as well.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg2_later);

-- Leg 02 home but leg 03 is neither running nor done -- "Is there a problem with the last delivery?"
-- is the client's own recovery line, so this arc re-offers leg 03 (Dathomir).
ep3_kara_leg3 = ConvoScreen:new {
	id = "ep3_kara_leg3",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_44", --Is there a problem with the last delivery? This one is in... [*she checks her datapad*]... the Dathomir system. I know that can be a dangerous place, but this is an important contract. I don't know for certain who I'm selling to there, but they are offering a lot for these goods.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_46", "ep3_kara_leg3_go"}, --I'll handle that delivery right now.
		{"@conversation/ep3_etyyy_kara_corlon:s_50", "ep3_kara_leg3_later"}, --I'll have to make that delivery later.
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg3);

-- Re-grant of leg 03 happens in the handler on this screen id.
ep3_kara_leg3_go = ConvoScreen:new {
	id = "ep3_kara_leg3_go",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_48", --Good. To the Dathomir system then. Return here to me when you've completed the delivery.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg3_go);

ep3_kara_leg3_later = ConvoScreen:new {
	id = "ep3_kara_leg3_later",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_52", --I see. Let me know when you can do this one. I'll be here. You've shown you can be trusted, so I'd hate to have to find someone else.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_leg3_later);

-- All three legs home.
ep3_kara_complete = ConvoScreen:new {
	id = "ep3_kara_complete",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_42", --Thanks for completing those. I really appreciate your help. Those [*spats out something in a language you don't understand*] Rodian hunters make things difficult for me and my comrades here. Just because we're here illegally doesn't mean... er... I've said too much. Let's just leave it with that. You have my thanks. You should go let Johnson Smith know you've completed my deliveries.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kara_corlon:s_74", "ep3_kara_farewell"}, --I understand. I'll be on my way.
	}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_complete);

ep3_kara_farewell = ConvoScreen:new {
	id = "ep3_kara_farewell",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_76", --Thank you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_farewell);

-- Every hail after the goodbye. She says outright she does not want to be seen with the player.
ep3_kara_done = ConvoScreen:new {
	id = "ep3_kara_done",
	leftDialog = "@conversation/ep3_etyyy_kara_corlon:s_36", --Look, I appreciate the help you have given me, and I appreciate any future assistance that you might offer as well, but we really can't be seen talking too often. If word gets back to any of those [*curses*] obnoxious Rodian hunters, I could lose some important contacts within Kachirho.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kara_corlon_convotemplate:addScreen(ep3_kara_done);

addConversationTemplate("ep3_etyyy_kara_corlon_convotemplate", ep3_etyyy_kara_corlon_convotemplate);

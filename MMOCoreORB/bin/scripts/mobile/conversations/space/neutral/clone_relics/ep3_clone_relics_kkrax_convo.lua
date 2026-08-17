-- Kkrax -- the ground giver for the Boba Fett clone-relics space quest that had no giver:
--
--   recovery/ep3_clone_relics_boba_fett_2   "Dantooine system: Tracking down Ogveer."
--     (screenplays/space/squadrons/KesselDutyScreenplay.lua, global line 232, registered line 292)
--
-- Before this file nothing in the repo handed it out. It declares no parentQuest, so nothing chained
-- it either. Its own COMPLETION side quest, destroy_surpriseattack/ep3_clone_relics_boba_fett_3, is
-- auto-granted by SpaceQuestLogic:triggerCompletionSplitQuest when this one completes, so wiring this
-- one giver reaches both quests.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_clone_relics_boba_fett_contact_1.stf (34 entries). Nothing is authored.
--
-- The pitch matches the screenplay field for field:
--   s_810 "< Kkrax looks inside the package > Curse that monster!  Yes, yes, I've seen Wogo... He was
--   working with Ogveer, a Rodian smuggler." == the quest's recoverShip, a Dantooine pirate, and its
--   quest_escort_d "Escort Ogveer to where he was supposed to meet with Uff Wogo...".
--   s_814 "I talked to him earlier, he was on his way to Dantooine to deliver something.  I can give
--   you the coordinates of the route he usually takes." == questZone space_dantooine (STF
--   quest_location_t "Dantooine system.") and the preRecoveryPoints track, which the quest's own
--   arrival_phase_1 calls "Scanning pre programmed route for ship signature now."
--   s_766 "Ogveer tricked me!  Now what?" == boba_fett_3's title_d, "Ogveer tricked you.  Defeat the
--   ambush that he lead you in to", and boba_fett_2's complete text, "You fool!  You actually think
--   I'd give up my friend to you? ... Get him boys!". That is why the post-completion screen carries
--   that option and the pre-completion one does not.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The blocks below are
-- read off the .stf's own key order and its strict speaker alternation (Kkrax on s_798, s_802, s_806,
-- s_810, s_814, s_818, s_822; the player on the keys between them), and off the two self-contained
-- openers the file ships. Which block the handler picks is ours.
--
-- FLAGGED INTERPRETATION -- NO FLIGHT GATE. Kkrax ships no dismissal line -- there is no equivalent
-- of Captain Koh's s_270 "I don't have time for you!  Be gone!" anywhere in his .stf -- so this
-- conversation does not turn away a player who cannot fly, and none is authored for him. That matches
-- the canonical grant site in the repo, rheaConvoHandler.lua:237, which gates nothing either. The
-- handler's grant() still re-reads the journal after the grant so a refused grant leaves no residue.
--
-- FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceRecoveryScreenplay leaves no distinguishable
-- failure record a conversation can read, so a "took it once" latch is written on a successful grant
-- and the s_780 re-approach block is shown to anyone who once took it and now has it neither active
-- nor complete. That cannot separate "failed it" from "abandoned it". The .stf's own re-approach
-- block exists precisely for that case: s_782 "I need the directions to Ogveer again."
--
-- UNUSED SHIPPED KEYS:
--   s_762 -- empty in the client.
--   s_774 "What?!" -- a player line whose parent is s_772 "...", which is a terminal; nothing is
--   shipped past it.
--   s_824 "How may I help?" -- a second shipped Kkrax greeting. The client distinguishes it from
--   s_798 by something this repo cannot see: the quest that hands the player Fett's package
--   (s_808 "Fett told me to give you this.") was never shipped here, so there is no state to switch
--   greetings on. s_798 is used as the greeting because it is the one the package branch hangs off.
--
-- REACHABILITY: ep3_clone_relics_kkrax is not spawned anywhere in this repo -- no screenplay
-- references any ep3_clone_relics_* mobile. This conversation is correct and inert until a spawn
-- exists. The mobile itself is now conversable: see mobile/custom_content/ep3/ep3_clone_relics_kkrax.lua.

ep3_clone_relics_kkrax_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_kkrax_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3CloneRelicsKkraxConvoHandler",
	screens = {}
}

-- ---------------------------------------------------------------------------------------------
-- First approach, and the package hand-off that starts the quest.
-- ---------------------------------------------------------------------------------------------

ep3_kkrax_greeting = ConvoScreen:new {
	id = "ep3_kkrax_greeting",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_798", --May I help you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_808", "ep3_kkrax_package"}, --Fett told me to give you this. < Give Kkrax the package. >
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_800", "ep3_kkrax_wogo"}, --I believe so. I'm looking for Uff Wogo.
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_826", "ep3_kkrax_mistake"}, --Oh I'm sorry, I thought you were someone else.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_greeting);

-- Asking after Uff Wogo without the package gets nothing; the package is what opens him up.
ep3_kkrax_wogo = ConvoScreen:new {
	id = "ep3_kkrax_wogo",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_802", --I've never heard of him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_804", "ep3_kkrax_wogo_end"}, --Oh, alright. Take care.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_wogo);

ep3_kkrax_wogo_end = ConvoScreen:new {
	id = "ep3_kkrax_wogo_end",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_806", --You too.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_wogo_end);

ep3_kkrax_mistake = ConvoScreen:new {
	id = "ep3_kkrax_mistake",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_828", --Not a problem, take care.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_mistake);

ep3_kkrax_package = ConvoScreen:new {
	id = "ep3_kkrax_package",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_810", --< Kkrax looks inside the package > Curse that monster! Yes, yes, I've seen Wogo... He was working with Ogveer, a Rodian smuggler.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_812", "ep3_kkrax_route"}, --Where do I find Ogveer?
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_package);

ep3_kkrax_route = ConvoScreen:new {
	id = "ep3_kkrax_route",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_814", --I talked to him earlier, he was on his way to Dantooine to deliver something. I can give you the coordinates of the route he usually takes.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_816", "ep3_kkrax_coords"}, --That would be most helpful.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_route);

-- The coordinates change hands here, so the grant of recovery/ep3_clone_relics_boba_fett_2 happens in
-- the handler on this id. Kkrax's own line is him collecting on the trade.
ep3_kkrax_coords = ConvoScreen:new {
	id = "ep3_kkrax_coords",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_818", --Now, what about my brother? Where is he?!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_820", "ep3_kkrax_curse"}, --I have no idea. Take care.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_coords);

ep3_kkrax_curse = ConvoScreen:new {
	id = "ep3_kkrax_curse",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_822", --Curse you! Curse you both! You stinking...
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_curse);

-- ---------------------------------------------------------------------------------------------
-- Quest in hand, and after Ogveer's ambush.
-- ---------------------------------------------------------------------------------------------

-- Quest active: he has already given up everything he knows.
ep3_kkrax_active = ConvoScreen:new {
	id = "ep3_kkrax_active",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_764", --You again, just leave me alone...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_776", "ep3_kkrax_passing"}, --Calm down, I'm just passing through.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_active);

-- Quest complete: s_766 is only true once Ogveer has sprung the ambush, so it is only offered here.
ep3_kkrax_done = ConvoScreen:new {
	id = "ep3_kkrax_done",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_764", --You again, just leave me alone...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_766", "ep3_kkrax_moping"}, --Ogveer tricked me! Now what?
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_776", "ep3_kkrax_passing"}, --Calm down, I'm just passing through.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_done);

ep3_kkrax_moping = ConvoScreen:new {
	id = "ep3_kkrax_moping",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_768", --How am I supposed to know?! Do I look like a Bounty Hunter to you?!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_770", "ep3_kkrax_silence"}, --Quit your moping.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_moping);

ep3_kkrax_silence = ConvoScreen:new {
	id = "ep3_kkrax_silence",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_772", --...
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_silence);

ep3_kkrax_passing = ConvoScreen:new {
	id = "ep3_kkrax_passing",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_778", --One day you will get what you deserve, mark my words!
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_passing);

-- ---------------------------------------------------------------------------------------------
-- Took it once, lost it: the shipped re-approach block. s_782 asks for the directions "again", which
-- is the client's own word for this case.
-- ---------------------------------------------------------------------------------------------

ep3_kkrax_retry_greeting = ConvoScreen:new {
	id = "ep3_kkrax_retry_greeting",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_780", --What do you want?!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_782", "ep3_kkrax_retry_brother"}, --I need the directions to Ogveer again.
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_794", "ep3_kkrax_retry_nothing"}, --Nothing, just stopping by.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_retry_greeting);

ep3_kkrax_retry_brother = ConvoScreen:new {
	id = "ep3_kkrax_retry_brother",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_784", --If I tell you, will you tell me what you know about my brother?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_786", "ep3_kkrax_retry_coords"}, --Sure.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_retry_brother);

-- The re-grant of recovery/ep3_clone_relics_boba_fett_2 happens in the handler on this id.
ep3_kkrax_retry_coords = ConvoScreen:new {
	id = "ep3_kkrax_retry_coords",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_788", --Good. Here's the location of his smuggling route in the Dantooine system. Now what do you know?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_boba_fett_contact_1:s_790", "ep3_kkrax_retry_finger"}, --He's missing a finger. See you around.
	}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_retry_coords);

ep3_kkrax_retry_finger = ConvoScreen:new {
	id = "ep3_kkrax_retry_finger",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_792", --One day you will get what you deserve, mark my words!
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_retry_finger);

ep3_kkrax_retry_nothing = ConvoScreen:new {
	id = "ep3_kkrax_retry_nothing",
	leftDialog = "@conversation/ep3_clone_relics_boba_fett_contact_1:s_796", --One day you will get what you deserve, mark my words!
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_kkrax_convotemplate:addScreen(ep3_kkrax_retry_nothing);

addConversationTemplate("ep3_clone_relics_kkrax_convotemplate", ep3_clone_relics_kkrax_convotemplate);

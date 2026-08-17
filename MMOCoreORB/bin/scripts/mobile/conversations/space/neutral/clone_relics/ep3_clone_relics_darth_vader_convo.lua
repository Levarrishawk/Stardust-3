-- Darth Vader -- the ground giver for the Clone Relics Jedi Starfighter space battles that had no
-- giver:
--
--   space_battle/ep3_clone_relics_jedi_starfighter_4   "Kashyyyk system: Defeating an invasion."
--     (screenplays/space/squadrons/KashyyykMiningScreenplay.lua, global line 497,
--      registered line 535)
--
-- ONLY PHASE IV IS GRANTED HERE, ON PURPOSE. jedi_starfighter_4 declares
-- sideQuestType = "space_battle", sideQuestName = "ep3_clone_relics_jedi_starfighter_5" with
-- sideQuestSplitType = COMPLETION (KashyyykMiningScreenplay.lua:509-513), so
-- SpaceQuestLogic:triggerCompletionSplitQuest hands phase V out automatically when phase IV
-- completes. Phase V must NOT be given a giver of its own. The client says the same thing in its own
-- words: jedi_starfighter_4's split_quest_alert is "Lord Vader: < Their transports are yours young
-- one, destroy them. >".
--
-- PHASES I, II AND III ARE NOT MISSING. They are GROUND quests -- quest/ep3_clone_relics_jedi_
-- starfighter_1.qst through _3.qst -- and this arc shares ONE phase counter across ground and space.
-- A space chain that starts at index 4 is therefore the correct shipped shape, not a gap. The sibling
-- arcs confirm the pattern: clone_relics_boba_fett runs ground 1 / space 2 / space 3 / ground 4-7,
-- and the queen arc runs ground 1 / ground 2 / space 3. Do not "fix" this by authoring space legs 1-3.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_clone_relics_jedi_starfighter_darth_vader.stf. Nothing is authored.
--
-- WHERE THIS SITS IN THE SHIPPED GROUND QUEST. quest/ep3_clone_relics_jedi_starfighter_4.qst,
-- journal title "Doing your duty, phase IV", journal category "The Clone Relics, Fist of the
-- Empire", sends the player to a commander "downstairs in the Imperial bunker" in Kachirho, has them
-- talk to Vader (task talkToVader1), and rewards
-- object/tangible/ship/crafted/chassis/jedi_starfighter_reward_deed.iff. THAT DEED IS THE GROUND
-- QUEST'S REWARD, NOT THE SPACE LEG'S -- nothing here hands out any item; the space screenplays own
-- their own rewards.
--
-- VADER SUPERSEDES ADMIRAL KRIEG. s_735 says so outright: "The meaningless skirmishes ordered by
-- Admiral Krieg will not continue." ep3_clone_relics_admiral_krieg already exists as a mobile in
-- mobile/custom_content/ep3/ and is likewise unspawned.
--
-- The pitch matches the screenplay field for field:
--   s_735 "The Rebels are moving a sizeable fleet in to this system. Their objective is to liberate
--   the planet of the Trandoshans and our presence." == questZone space_kashyyyk (STF
--   quest_location_t "Kashyyyk system.") and enemyShips reb_xwing/awing/bwing/ywing_tier5.
--   s_739 "I will entrust you with leading our fleet to victory against the Rebels." == the quest's
--   own quest_helpallies_d, "Lord Vader has put you in command of the attack.", and supportShips
--   imp_tie_interceptor/aggressor/advanced_tier5 (STF allies_arrived: "Your fleet has arrived young
--   one, take command.").
--   s_743 "I'm providing you with my old star fighter." == the ground quest's
--   jedi_starfighter_reward_deed, which is why that deed is not granted here.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The offer chain below
-- is read straight off the .stf's own key order and its strict speaker alternation (Vader on s_1106,
-- s_735, s_739, s_743, s_747; the player on s_733, s_737, s_741, s_745 between them), and the
-- success and failure blocks likewise (s_714/s_716/s_718 and s_720/s_722/s_724 + s_726/s_728). Which
-- block the handler picks is ours.
--
-- FLAGGED INTERPRETATION -- s_21 AS THE BRUSH-OFF. s_21 "I have no use for you at the moment %TU,
-- get back to your duties." is the only shipped line for "not now". The client names no trigger. It
-- is used here for an Imperial pilot who cannot presently fly the mission (JTL off or no certified
-- ship) and as Vader's standing screen once the arc has been debriefed.
--
-- FLAGGED INTERPRETATION -- s_749 AS THE WRONG-FACTION LINE. s_749 "Wrong place to be lost..." is the
-- only shipped line that turns a stranger away. The client names no trigger. It is used here for
-- anyone who is not an Imperial pilot.
--
-- THE FACTION GATE ITSELF IS ATTESTED, THE LINE CHOICE IS NOT. That this arc is Imperial-only is
-- client/publisher fact, not an invention: the shipped walkthrough source labels the reward
-- "Jedi Starfighter (Imperials Only)" and an SOE developer stated "There are no plans to change the
-- Rebel/Imperial requirements for the Actis and ARC-170 quests". Gating on
-- SpaceHelpers:isImperialPilot() therefore implements a documented requirement. Which shipped LINE
-- greets the rejected player is the interpretation.
--
-- UNUSED SHIPPED KEYS:
--   s_712 -- empty in the client.
--
-- REACHABILITY: no Clone Relics Vader mobile is spawned anywhere in this repo, no ep3 Vader
-- appearance ships in the client's ep3 mobile set at all (see the mobile file), there are no Kashyyyk
-- ground spawn areas, and bin/conf/config.lua ZonesEnabled has no Kashyyyk ground zone. This
-- conversation is correct and inert until all of that is addressed. The mobile is new and conversable:
-- see mobile/custom_content/ep3/ep3_clone_relics_darth_vader.lua.

ep3_clone_relics_darth_vader_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_vader_offer",
	templateType = "Lua",
	luaClassHandler = "Ep3CloneRelicsDarthVaderConvoHandler",
	screens = {}
}

-- ---------------------------------------------------------------------------------------------
-- The offer. One shipped chain, in the .stf's own key order, ending in the grant.
-- ---------------------------------------------------------------------------------------------

ep3_vader_offer = ConvoScreen:new {
	id = "ep3_vader_offer",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_1106", --Welcome %TU. You have proved most useful to the Emperor and that will now continue under my guidance.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_733", "ep3_vader_fleet"}, --(respectful) I'm honored my Lord.
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_offer);

ep3_vader_fleet = ConvoScreen:new {
	id = "ep3_vader_fleet",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_735", --Good. The meaningless skirmishes ordered by Admiral Krieg will not continue. The Rebels are moving a sizeable fleet in to this system. Their objective is to liberate the planet of the Trandoshans and our presence. We will of course stop their futile attempt.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_737", "ep3_vader_command"}, --(respectful) Of course my Lord.
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_fleet);

ep3_vader_command = ConvoScreen:new {
	id = "ep3_vader_command",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_739", --I will entrust you with leading our fleet to victory against the Rebels. Failure is not an option %TU.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_741", "ep3_vader_starfighter"}, --(respectful) I understand my Lord.
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_command);

-- s_743 is Vader describing the ground quest's own reward deed. Nothing is handed over here.
ep3_vader_starfighter = ConvoScreen:new {
	id = "ep3_vader_starfighter",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_743", --To ensure that the pilots understand your supremacy, I'm providing you with my old star fighter. This weapon of destruction should instill fear and respect in both friend and foe.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_745", "ep3_vader_accept"}, --(respectful) You are much too generous my Lord.
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_starfighter);

-- GRANT. s_747 closes the briefing, so the grant of
-- space_battle/ep3_clone_relics_jedi_starfighter_4 happens in the handler on this id. Phase V
-- follows automatically from phase IV's COMPLETION split and is never granted here.
ep3_vader_accept = ConvoScreen:new {
	id = "ep3_vader_accept",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_747", --Do not disappoint me young one...
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_accept);

-- ---------------------------------------------------------------------------------------------
-- Orders outstanding.
-- ---------------------------------------------------------------------------------------------

ep3_vader_orders = ConvoScreen:new {
	id = "ep3_vader_orders",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_730", --You have your orders %TU, proceed immediately.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_orders);

-- ---------------------------------------------------------------------------------------------
-- The Rebel fleet is beaten.
-- ---------------------------------------------------------------------------------------------

ep3_vader_success = ConvoScreen:new {
	id = "ep3_vader_success",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_714", --I am pleased %TU. As I foresaw, your success was inevitable.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_716", "ep3_vader_dismissed"}, --(respectful) I live to serve my Lord.
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_success);

ep3_vader_dismissed = ConvoScreen:new {
	id = "ep3_vader_dismissed",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_718", --Indeed. I will let your commanding officers know of your progress %TU. Now leave me.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_dismissed);

-- ---------------------------------------------------------------------------------------------
-- The attack failed. s_724 re-issues the order in the client's own words -- "there is still time to
-- stop them" -- so that is where the re-grant hangs. s_728 is the branch where the player makes
-- excuses instead, and Vader cuts them off without re-issuing anything.
-- ---------------------------------------------------------------------------------------------

ep3_vader_failure = ConvoScreen:new {
	id = "ep3_vader_failure",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_720", --I do not accept failure %TU.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_722", "ep3_vader_retry"}, --(respectful) I have no excuses my Lord, I failed you.
		{"@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_726", "ep3_vader_enough"}, --(nervous) There was too many of them my Lord, I couldn't...
	}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_failure);

-- RE-GRANT happens in the handler on this id.
ep3_vader_retry = ConvoScreen:new {
	id = "ep3_vader_retry",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_724", --You are only alive because the attack slowed down the Rebel fleet and there is still time to stop them. Do not fail me again young one.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_retry);

ep3_vader_enough = ConvoScreen:new {
	id = "ep3_vader_enough",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_728", --Enough...
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_enough);

-- ---------------------------------------------------------------------------------------------
-- Turned away. See the two FLAGGED INTERPRETATION blocks in the header.
-- ---------------------------------------------------------------------------------------------

ep3_vader_no_use = ConvoScreen:new {
	id = "ep3_vader_no_use",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_21", --I have no use for you at the moment %TU, get back to your duties.
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_no_use);

ep3_vader_intruder = ConvoScreen:new {
	id = "ep3_vader_intruder",
	leftDialog = "@conversation/ep3_clone_relics_jedi_starfighter_darth_vader:s_749", --Wrong place to be lost...
	stopConversation = "true",
	options = {}
}
ep3_clone_relics_darth_vader_convotemplate:addScreen(ep3_vader_intruder);

addConversationTemplate("ep3_clone_relics_darth_vader_convotemplate", ep3_clone_relics_darth_vader_convotemplate);

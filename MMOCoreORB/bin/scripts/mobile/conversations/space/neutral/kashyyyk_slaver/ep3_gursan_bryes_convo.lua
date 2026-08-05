-- Gursan Bryes -- the Alliance operations officer in the huts below Kachirho.
--
-- Giver for the three Kashyyyk slaver-file quest heads that had no giver:
--
--   assassinate/ep3_slaver_trando_reinforcement_intercept  (global line 285, questName/questType
--                                                           line 290-291, questZone space_tatooine)
--   space_battle/ep3_slaver_khrask_space_battle            (global line 131, line 134-135)
--   space_battle/ep3_slaver_khrask_space_battle_alt        (global line 167, line 170-171)
--
-- All three live in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_gursan_bryes.stf (47 entries). Nothing is authored.
--
-- KYMAYRR HANDS HIM THE PLAYER, IN THE CLIENT'S OWN WORDS. ep3_kymayrr:s_313 "My friend Gursan Bryes
-- who stays in the huts below will brief you on what our future plans are", and his own opener s_858
-- picks straight up from her battle: "With the loss of Adjutant Rhosk, Avatar Platform has been
-- shaken up." That is why the handler will not open the first leg until Kymayrr's
-- space_battle/ep3_slaver_rhosk_space_battle is complete.
--
-- Each pitch matches its screenplay field for field:
--   s_862 "A wing of fighters will be dispatched from an allied clan on Tatooine to bolster the
--   defense of the Avatar" and s_866 "intercept those fighters before they clear the Tatoo System"
--   == assassinate/ep3_slaver_trando_reinforcement_intercept, whose questZone is "space_tatooine"
--   (the one Kashyyyk-file quest that is not in Kashyyyk space) and whose own comment reads "Far
--   edge of the Tatooine system, old smuggler jump point". assassinateSpawns target
--   trn_slaver_fighter_tier5 with four lesser fighters == "The flight leader has been destroyed,
--   finish off the rest of his wing."
--   s_862 also says "There is also a report that Broodmaster Hss'kas is on his way to oversee the
--   Avatar Platform... Be prepared for recall if Hss'kas shows himself" and s_866 "There are no top
--   priorities, just targets of opportunity" == the BIDIRECTIONAL sideQuest
--   space_battle/ep3_slaver_hsskas_space_battle, which is also the sideFailQuest. It chains itself
--   and needs no giver.
--   s_810 "Lord Cyssc is already on the move and our forces have been sent to intercept" and s_814
--   "Cyssc will be flying in shortly, get up there and prepare your welcome.  Be at your best %NU,
--   your target is a modified heavy cruiser.  He will definitely have his Scaleguard present."
--   == space_battle/ep3_slaver_khrask_space_battle, whose battleLocation comment is "Ambush Point --
--   calculated intercept on the Hss'kor inbound approach", whose supportShips comment is "The last
--   few resistance fighters in the system." and whose BIDIRECTIONAL sideQuest is
--   assassinate/ep3_slaver_lord_cyssc_final -- Cyssc's cruiser itself.
--   s_38 "The Blackscales are sending a new leader to Kashyyyk" and s_54 "The Blackscales are
--   silent, at least for now.  If you wish to test your strength against the Blackscales again, %TO"
--   == space_battle/ep3_slaver_khrask_space_battle_alt, the repeatable variant, whose own comment
--   reads "Same ambush point, repeatable variant against the unnamed Blackscale Leader" and whose
--   sideQuest is assassinate/ep3_slaver_lord_cyssc_alt.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. Each block below is
-- read off the .stf's own key order and its yes/no pairings (s_39 against s_41 in the repeatable
-- block; the other two legs ship no decline line at all). The order in which the handler selects
-- between blocks is ours.
--
-- FLAGGED INTERPRETATION -- WHAT GATES THE CYSSC AMBUSH. The client's order is unambiguous: s_830
-- "With both Rhosk and Hss'kas gone Warden Tosk is sure to know something is up.  Now is our chance
-- to finish it." That places the Cyssc ambush after the Tatooine intercept and its Hss'kas side
-- quest. But the steps the client puts between them -- breaking into the Blackscale Compound (s_816
-- to s_828) and sending the false plea from its comms device (s_830 to s_842) -- were never shipped
-- as quests in this repo, and s_810's trophy line "Captain Beshk won't need his staff anymore"
-- refers to the Compound's guard captain. So this handler collapses the ladder onto the space legs
-- that exist and gates the Cyssc ambush on the Tatooine intercept alone. The relative order is
-- client fact; the collapsing is ours.
--
-- FLAGGED INTERPRETATION -- s_872 AS THE FLIGHT GATE. s_872 "Move along, I have important matters to
-- attend." is his shipped brush-off. It is used here at every accept point for a player the handler
-- can see cannot fly: JTL off, not a pilot, or no certified ship, and as the screen for a player who
-- has not yet done Kymayrr's battle. (The engine exposes no generic "player holds any space mission"
-- test: space_helpers.lua only offers isSpaceQuestActive / isSpaceQuestTaskActive /
-- isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and MissionObject.idl:479 only
-- exposes isSpaceDutyMission().) The text is client fact; those triggers are not.
--
-- NO FAILURE BRANCH IS BUILT, DELIBERATELY. He ships no failure line and no retry line for any of
-- the three legs, so a player who took one and no longer holds it simply walks that pitch again.
-- That needs no latch and invents nothing.
--
-- UNUSED SHIPPED KEYS:
--   s_800 -- empty in the client.
--   THE BLACKSCALE COMPOUND GROUND INSTANCE (never shipped as a quest here): s_816, s_818, s_820,
--   s_822, s_824, s_826, s_828.
--   THE FALSE PLEA TO LORD CYSSC, also ground (same): s_830, s_832, s_834, s_836, s_838, s_840,
--   s_842.
--   THE GROUND PURSUIT OF HSS'KAS INTO ETYYY after his escape pod goes down, and the Sith blade
--   handed over for it (same): s_844, s_846, s_848, s_850, s_852, s_854, s_856.
--
-- REACHABILITY: ep3_gursan_bryes is not spawned anywhere in this repo and there is no Kashyyyk
-- ground zone in config.lua ZonesEnabled. See the handler header.

ep3_gursan_bryes_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_gursan_brushoff",
	templateType = "Lua",
	luaClassHandler = "Ep3GursanBryesConvoHandler",
	screens = {}
}

-- See the FLAGGED INTERPRETATION on s_872 in the header.
ep3_gursan_brushoff = ConvoScreen:new {
	id = "ep3_gursan_brushoff",
	leftDialog = "@conversation/ep3_gursan_bryes:s_872", --Move along, I have important matters to attend.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_brushoff);

-- ---------------------------------------------------------------------------------------------
-- Leg 1 -- assassinate/ep3_slaver_trando_reinforcement_intercept (the Tatooine wing)
-- ---------------------------------------------------------------------------------------------

ep3_gursan_intercept_offer = ConvoScreen:new {
	id = "ep3_gursan_intercept_offer",
	leftDialog = "@conversation/ep3_gursan_bryes:s_858", --Welcome %NU, it is good to have you working with us.  I'll need to cut straight to business as our window of opportunity is short.  With the loss of Adjutant Rhosk, Avatar Platform has been shaken up.  Resistance forces are preparing to strike the platform proper and the rival Zssik clan is seeing this as a good opportunity to displace the Blackscale.  Hopefully they will destroy each other if that conflict ever erupts.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_860", "ep3_gursan_intercept_brief"}, --What is our first move?
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_intercept_offer);

ep3_gursan_intercept_brief = ConvoScreen:new {
	id = "ep3_gursan_intercept_brief",
	leftDialog = "@conversation/ep3_gursan_bryes:s_862", --A wing of fighters will be dispatched from an allied clan on Tatooine to bolster the defense of the Avatar.  There is also a report that Broodmaster Hss'kas is on his way to oversee the Avatar Platform.  The Broodmaster is a fanatic and would only make our situation worse.  But this was expected and we are watching his movements closely.  When he comes, we will be ready.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_864", "ep3_gursan_intercept_accept"}, --The fighters are top priority then?
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_intercept_brief);

-- The grant of assassinate/ep3_slaver_trando_reinforcement_intercept happens in the handler on this
-- id.
ep3_gursan_intercept_accept = ConvoScreen:new {
	id = "ep3_gursan_intercept_accept",
	leftDialog = "@conversation/ep3_gursan_bryes:s_866", --There are no top priorities, just targets of opportunity.  Be prepared for recall if Hss'kas shows himself, but for now intercept those fighters before they clear the Tatoo System.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_868", "ep3_gursan_intercept_signoff"}, --I will return shortly.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_intercept_accept);

ep3_gursan_intercept_signoff = ConvoScreen:new {
	id = "ep3_gursan_intercept_signoff",
	leftDialog = "@conversation/ep3_gursan_bryes:s_870", --Stay alert and be ready.  We are counting on you %NU
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_intercept_signoff);

-- ---------------------------------------------------------------------------------------------
-- Leg 2 -- space_battle/ep3_slaver_khrask_space_battle (the Cyssc ambush)
-- ---------------------------------------------------------------------------------------------

ep3_gursan_cyssc_offer = ConvoScreen:new {
	id = "ep3_gursan_cyssc_offer",
	leftDialog = "@conversation/ep3_gursan_bryes:s_810", --We haven't a moment to lose.  Lord Cyssc is already on the move and our forces have been sent to intercept.  I have a trophy for you though.  Captain Beshk won't need his staff anymore.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_812", "ep3_gursan_cyssc_accept"}, --I'll be off right away.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_cyssc_offer);

-- The grant of space_battle/ep3_slaver_khrask_space_battle happens in the handler on this id.
ep3_gursan_cyssc_accept = ConvoScreen:new {
	id = "ep3_gursan_cyssc_accept",
	leftDialog = "@conversation/ep3_gursan_bryes:s_814", --Cyssc will be flying in shortly, get up there and prepare your welcome.  Be at your best %NU, your target is a modified heavy cruiser.  He will definitely have his Scaleguard present.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_cyssc_accept);

ep3_gursan_cyssc_active = ConvoScreen:new {
	id = "ep3_gursan_cyssc_active",
	leftDialog = "@conversation/ep3_gursan_bryes:s_808", --What are you waiting for %NU, your destiny awaits you up there?
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_cyssc_active);

ep3_gursan_cyssc_done = ConvoScreen:new {
	id = "ep3_gursan_cyssc_done",
	leftDialog = "@conversation/ep3_gursan_bryes:s_802", --The force be praised, lord Cyssc is dead.  You have won a grand victory for the alliance here on Kashyyyk, and for freedom everywhere.  If you have not done so, Kymayrr would have a word with you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_804", "ep3_gursan_cyssc_debrief"}, --I will see her at once.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_cyssc_done);

ep3_gursan_cyssc_debrief = ConvoScreen:new {
	id = "ep3_gursan_cyssc_debrief",
	leftDialog = "@conversation/ep3_gursan_bryes:s_806", --Please do, friend.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_cyssc_debrief);

-- ---------------------------------------------------------------------------------------------
-- Leg 3 -- space_battle/ep3_slaver_khrask_space_battle_alt (the repeatable variant)
-- ---------------------------------------------------------------------------------------------

-- s_54 ends on %TO, which the engine fills from the conversation's TO field. Nothing here sets it,
-- so it renders empty -- exactly as the shipped string does on its own.
ep3_gursan_alt_reoffer = ConvoScreen:new {
	id = "ep3_gursan_alt_reoffer",
	leftDialog = "@conversation/ep3_gursan_bryes:s_54", --It's a pleasuer to see you again.  The Blackscales are silent, at least for now.  If you wish to test your strength against the Blackscales again, %TO
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_39", "ep3_gursan_alt_accept"}, --Very well, we will stop the Blackscales again.
		{"@conversation/ep3_gursan_bryes:s_41", "ep3_gursan_alt_decline"}, --I'm sorry, this time I cannot help you.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_reoffer);

ep3_gursan_alt_offer = ConvoScreen:new {
	id = "ep3_gursan_alt_offer",
	leftDialog = "@conversation/ep3_gursan_bryes:s_38", --%NU, It's good to see you.  It looks like you are not the only one returning to Kashyyyk.  The Blackscales are sending a new leader to Kashyyyk.  If you are willing, your help could save many lives.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_39", "ep3_gursan_alt_accept"}, --Very well, we will stop the Blackscales again.
		{"@conversation/ep3_gursan_bryes:s_41", "ep3_gursan_alt_decline"}, --I'm sorry, this time I cannot help you.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_offer);

-- The grant of space_battle/ep3_slaver_khrask_space_battle_alt happens in the handler on this id.
ep3_gursan_alt_accept = ConvoScreen:new {
	id = "ep3_gursan_alt_accept",
	leftDialog = "@conversation/ep3_gursan_bryes:s_40", --The fight will begin any minute.  Good luck and may the force be with you.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_accept);

ep3_gursan_alt_decline = ConvoScreen:new {
	id = "ep3_gursan_alt_decline",
	leftDialog = "@conversation/ep3_gursan_bryes:s_42", --I'm sorry to hear that.  Good luck to you.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_decline);

ep3_gursan_alt_done = ConvoScreen:new {
	id = "ep3_gursan_alt_done",
	leftDialog = "@conversation/ep3_gursan_bryes:s_43", --You have done it again.  The Blackscales have lost another leader.  Again we are in your debt.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_gursan_bryes:s_44", "ep3_gursan_alt_debrief"}, --Thank you Gursan.
	}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_done);

-- Debrief only. space_battle_ep3_slaver_khrask_space_battle_alt already pays its own creditReward on
-- completion, and the "item I came across recently" is not an item in this repo -- the screenplay
-- carries no itemReward for it. The text is client fact; whether that item should exist is an open
-- item for whoever sets itemReward.
ep3_gursan_alt_debrief = ConvoScreen:new {
	id = "ep3_gursan_alt_debrief",
	leftDialog = "@conversation/ep3_gursan_bryes:s_45", --Here's an item I came across recently.  It's not much but it might be useful to you.
	stopConversation = "true",
	options = {}
}
ep3_gursan_bryes_convotemplate:addScreen(ep3_gursan_alt_debrief);

addConversationTemplate("ep3_gursan_bryes_convotemplate", ep3_gursan_bryes_convotemplate);

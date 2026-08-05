-- Kymayrr -- the Wookiee elder in Kachirho who runs the resistance against the Blackscale clan.
--
-- Giver for the one Kashyyyk slaver-file quest head that had no giver:
--
--   space_battle/ep3_slaver_rhosk_space_battle   (KashyyykSlaverScreenplay.lua global line 13,
--                                                 questName/questType line 16-17)
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_kymayrr.stf (55 entries). Nothing is authored.
--
-- Her pitch matches the screenplay field for field:
--   s_364 "Adjutant Rhosk runs Avatar Platform, that cancerous station dug into an asteroid field
--   surrounding Kashyyyk.  He is currently here on Kashyyyk to meet with Tosk but will be returning
--   shortly to the Avatar.  We want him captured, and during his return flight is our best chance."
--   == questZone "space_kashyyyk" and the screenplay's own comment on battleLocation, "Intercept on
--   the Kashyyyk -> Avatar Platform flightpath".
--   s_368 "There will be a squad of Blackscale fighters sweeping the flight path ahead of Rhosk.  A
--   wing of our fighters will engage them, if we win Rhosk will send in his personal guard.  When
--   this happens you can slip in and capture his transport." == supportShips wke_resist_tier3/tier4
--   (a wing of our fighters), enemyShips trn_slaver_fighter/enforcer (the Blackscale sweep), the
--   supportShipsDelay 30 / enemyShipsDelay 60 ordering, and the BIDIRECTIONAL side quest
--   destroy_surpriseattack/ep3_slaver_rhosk_surprise_attack -- Rhosk's personal guard -- which is
--   also the sideFailQuest. The capture itself is recovery/ep3_slaver_rhosk_recovery, chained on
--   from the surprise attack; neither of those needs a giver and neither is wired here.
--   s_372 "If all goes well, they will believe it was mining pirates.  Be wary up there %NU.  The
--   Blackscale employ mercenaries to bolster their ranks, but the house guard are all expert pilots."
--   == the tier5 enforcers in enemyShips.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The run below is read
-- straight off the .stf's own key order (s_344 -> s_346 -> s_348 -> ... -> s_374 -> s_376) and its
-- one yes/no pairing, s_346 "I am willing." against s_378 "I have my own set of problems to deal
-- with, I'll be on my way."
--
-- FLAGGED INTERPRETATION -- s_382 AS THE STANDING SCREEN AND THE FLIGHT GATE. s_382 "Enjoy your stay
-- in Kachirho.  But be watchful for the Trandoshan Slavers, they cannot be trusted." is her shipped
-- idle line. It is used here while the battle is outstanding, and at the accept point for a player
-- the handler can see cannot fly: JTL off, not a pilot, or no certified ship. (The engine exposes no
-- generic "player holds any space mission" test: space_helpers.lua only offers isSpaceQuestActive /
-- isSpaceQuestTaskActive / isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and
-- MissionObject.idl:479 only exposes isSpaceDutyMission().) The text is client fact; those two
-- triggers are not.
--
-- NO FAILURE BRANCH IS BUILT, DELIBERATELY. She ships no failure line and no retry line, so a player
-- who took the battle and no longer holds it simply walks the pitch again from s_344. That needs no
-- latch and invents nothing.
--
-- s_324 IS THE COMPLETION SCREEN AND IT STOPS THERE. "I am glad you have returned.  I have heard of
-- your victory..." is her debrief for this battle. The rest of that block (s_326 "Is there anything
-- I can do?" through s_342) hands out the GROUND rescue of her son Rroot from the Rryatt Trail slave
-- camp, which is not a quest in this repo -- there is no such screenplay anywhere in the tree -- so
-- those keys are listed as unused rather than wired to nothing.
--
-- UNUSED SHIPPED KEYS:
--   s_273 -- empty in the client.
--   THE RROOT GROUND RESCUE (no such quest exists in this repo): s_326, s_330, s_332, s_334, s_336,
--   s_338, s_340, s_342.
--   AFTER THE RROOT RESCUE (same, and it also depends on a recovered radio that is not an item in
--   this repo): s_309, s_311, s_313, s_315, s_317, s_319, s_321.
--   THE WARDEN-SIGNATURE PLEA AND THE MEDAL CEREMONY (ground content further up the Kachirho
--   storyline, none of it shipped as a quest here): s_275, s_277, s_279, s_281, s_283, s_285,
--   s_287, s_289, s_291, s_293, s_295, s_297, s_299, s_301, s_303, s_305, s_307.
--
-- REACHABILITY: ep3_kymayrr is not spawned anywhere in this repo and there is no Kashyyyk ground
-- zone in config.lua ZonesEnabled. See the handler header.

ep3_kymayrr_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_kymayrr_intro",
	templateType = "Lua",
	luaClassHandler = "Ep3KymayrrConvoHandler",
	screens = {}
}

ep3_kymayrr_intro = ConvoScreen:new {
	id = "ep3_kymayrr_intro",
	leftDialog = "@conversation/ep3_kymayrr:s_344", --%NU, I was looking forward to meeting you.  Zhailaut tells me you provided a great service for us.  Being able to track the Trandoshans movements in the Trail will allow us to move refugees and supplies more easily.  But there is more we would ask of you if you are willing.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_346", "ep3_kymayrr_occupation"}, --I am willing.
		{"@conversation/ep3_kymayrr:s_378", "ep3_kymayrr_decline"}, --I have my own set of problems to deal with, I'll be on my way.
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_intro);

ep3_kymayrr_occupation = ConvoScreen:new {
	id = "ep3_kymayrr_occupation",
	leftDialog = "@conversation/ep3_kymayrr:s_348", --That is good to hear.  The occupation of Kashyyyk has never been a blessing, but what was once an endurable situation has ended with the coming of the Blackscale.  When the Empire made their declaration of destruction or servitude, many of our elders and warriors immediately surrendered to their rule and those that were left behind knew a form of peace.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_350", "ep3_kymayrr_blackscale"}, --And the Blackscale?
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_occupation);

ep3_kymayrr_blackscale = ConvoScreen:new {
	id = "ep3_kymayrr_blackscale",
	leftDialog = "@conversation/ep3_kymayrr:s_352", --This territory was handed over to them when the Empire pulled back its forces.  The Blackscale are killers and brutes.  Their herding of my people caught us unaware at first.  But their plan has backfired on them for we resisted.  As was feared they appealed to the Empire to carry through on their threat to lay waste to our lands but Commander Richards has denied their request.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_354", "ep3_kymayrr_richards"}, --Why would the Imperial not support the Trandoshans as promised?
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_blackscale);

ep3_kymayrr_richards = ConvoScreen:new {
	id = "ep3_kymayrr_richards",
	leftDialog = "@conversation/ep3_kymayrr:s_356", --A few believe he takes delight in seeing the Trandoshans fail where the Empire had such success.  Personally I think he is afraid to call for aid because it would be admitting that he has lost control of this region.  Commander Richards's authority ends at the borders of this village.  Warden Tosk rules the clan here on Kashyyyk.  And Tosk answers directly to Lord Cyssc, patriarch of the Blackscale, back on Hss'Kas.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_358", "ep3_kymayrr_plan"}, --What sort of plan do you have then?
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_richards);

ep3_kymayrr_plan = ConvoScreen:new {
	id = "ep3_kymayrr_plan",
	leftDialog = "@conversation/ep3_kymayrr:s_360", --Trandoshans are noted for their regenerative abilities.  They are willing to lose an arm in battle as they know it will grow back.  This makes them fierce fighters.  No, if you truly want to kill a Trandoshan you are best to remove the head.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_362", "ep3_kymayrr_rhosk"}, --Lord Cyssc.  But you say he is far from here.
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_plan);

ep3_kymayrr_rhosk = ConvoScreen:new {
	id = "ep3_kymayrr_rhosk",
	leftDialog = "@conversation/ep3_kymayrr:s_364", --That is true, and he is not known to leave his citadel.  It is here where you become important to our efforts.  Adjutant Rhosk runs Avatar Platform, that cancerous station dug into an asteroid field surrounding Kashyyyk.  He is currently here on Kashyyyk to meet with Tosk but will be returning shortly to the Avatar.  We want him captured, and during his return flight is our best chance.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_366", "ep3_kymayrr_briefing"}, --What do I need to do?
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_rhosk);

ep3_kymayrr_briefing = ConvoScreen:new {
	id = "ep3_kymayrr_briefing",
	leftDialog = "@conversation/ep3_kymayrr:s_368", --There will be a squad of Blackscale fighters sweeping the flight path ahead of Rhosk.  A wing of our fighters will engage them, if we win Rhosk will send in his personal guard.  When this happens you can slip in and capture his transport.  We will jam long range communications, so you will be on your own out there but more importantly so will they.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_370", "ep3_kymayrr_reprisal"}, --The mission sounds easy.  But what of their reprisal?
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_briefing);

ep3_kymayrr_reprisal = ConvoScreen:new {
	id = "ep3_kymayrr_reprisal",
	leftDialog = "@conversation/ep3_kymayrr:s_372", --If all goes well, they will believe it was mining pirates.  Be wary up there %NU.  The Blackscale employ mercenaries to bolster their ranks, but the house guard are all expert pilots.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kymayrr:s_374", "ep3_kymayrr_accept"}, --Understood.
	}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_reprisal);

-- The grant of space_battle/ep3_slaver_rhosk_space_battle happens in the handler on this id.
ep3_kymayrr_accept = ConvoScreen:new {
	id = "ep3_kymayrr_accept",
	leftDialog = "@conversation/ep3_kymayrr:s_376", --Then go with honor.
	stopConversation = "true",
	options = {}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_accept);

ep3_kymayrr_decline = ConvoScreen:new {
	id = "ep3_kymayrr_decline",
	leftDialog = "@conversation/ep3_kymayrr:s_380", --That is unfortunate.
	stopConversation = "true",
	options = {}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_decline);

-- See the FLAGGED INTERPRETATION on s_382 in the header.
ep3_kymayrr_standing = ConvoScreen:new {
	id = "ep3_kymayrr_standing",
	leftDialog = "@conversation/ep3_kymayrr:s_382", --Enjoy your stay in Kachirho.  But be watchful for the Trandoshan Slavers, they cannot be trusted.
	stopConversation = "true",
	options = {}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_standing);

-- The debrief, and where her shipped SPACE content ends. The Rroot ground rescue that continues from
-- here is not a quest in this repo -- see the header.
ep3_kymayrr_complete = ConvoScreen:new {
	id = "ep3_kymayrr_complete",
	leftDialog = "@conversation/ep3_kymayrr:s_324", --%NU, I am glad you have returned.  I have heard of your victory and we are grateful for your efforts.  But I have had a personal tragedy while you were gone.  My son Rroot travels the Rryatt Trail transporting supplies and refugees throughout the area.  Earlier today I received word that he was captured by the slavers that inhabit that area.  We learned this from the radio you recovered for us, it has already proved its worth.
	stopConversation = "true",
	options = {}
}
ep3_kymayrr_convotemplate:addScreen(ep3_kymayrr_complete);

addConversationTemplate("ep3_kymayrr_convotemplate", ep3_kymayrr_convotemplate);

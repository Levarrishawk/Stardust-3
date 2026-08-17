-- Belga Daeri -- the space port official on the first floor of the tree in Kachirho.
--
-- Giver for the one Kashyyyk slaver-file quest head that had no giver:
--
--   assassinate/ep3_stren_dorn_lackey   (KashyyykSlaverScreenplay.lua global line 366,
--                                        registered further down the same file)
--
-- THE CLIENT NAMES HER AS THE GIVER, IN TWO PLACES. Stren Colo, the Kachirho bounty officer, posts
-- the bounty and pays it out but does not hand out the job:
--   ep3_stren_colo:s_89  "Dorn Nareusu the Human: 10,000 credits."
--   ep3_stren_colo:s_91  "Wanted for space piracy. There is a space port official on the first floor
--                         of the tree in Kachirho, Belga Daeri; she placed the bounty. Go get
--                         information from her."
--   ep3_stren_colo:s_63  "I received confirmation from Belga before you arrived. Here is your
--                         bounty."
-- and Belga's own s_396 answers back: "You must be one of Stren's lackeys."
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_belga_daeri.stf (14 entries). Nothing is authored.
--
-- Her pitch matches the screenplay field for field:
--   s_404 "Brought in?  And where would I put him?  No, just destroyed will suffice." == questType
--   "assassinate".
--   s_408 "He operates in Kashyyyk space but does not reside here.  If you take down some of his
--   lackeys then eventually he will come looking for you." == questZone "space_kashyyyk", the quest
--   NAME ep3_stren_dorn_lackey, and sideQuestName "ep3_stren_dorn_bounty" fired on
--   SIDE_QUEST_SPLIT_TYPES.COMPLETION -- Dorn himself comes looking only once the lackeys are down.
--   s_412 "I will provide you with a transponder signal for his suspected cohorts." == the
--   screenplay's own comment "Track the pirates transponder signal in the Kashyyyk System." over
--   targetPatrols dorn_lackey_1..4.
--   assassinateSpawns target gotal_warlord_tier5 with four gotal_bandit escorts == "Mining pirates
--   suspected to be working with Dorn Nerausu" / "The Pirates like to travel in packs."
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The chain below is
-- read straight off the .stf's own key order, which here is a single unbranched question-and-answer
-- run (s_392 -> s_394 -> s_396 -> s_398 -> s_400 -> s_402 -> s_404 -> s_406 -> s_408 -> s_410 ->
-- s_412) with no yes/no pair anywhere in it. She ships no decline line at all.
--
-- FLAGGED INTERPRETATION -- s_414 AS THE STANDING SCREEN AND THE FLIGHT GATE. s_414 "Be careful if
-- you approach the river to the north, you might find yourself in a Wookiee and Trandoshan battle."
-- is her only line outside the pitch. It is used here as her standing screen once the contract is
-- out or already settled, and as the fallback at the accept point for a player the handler can see
-- cannot fly: JTL off, not a pilot, or no certified ship. (The engine exposes no generic "player
-- holds any space mission" test: space_helpers.lua only offers isSpaceQuestActive /
-- isSpaceQuestTaskActive / isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and
-- MissionObject.idl:479 only exposes isSpaceDutyMission().) The text is client fact; those two
-- triggers are not.
--
-- NO FAILURE BRANCH IS BUILT, DELIBERATELY. She ships no failure line and no retry line, so a player
-- who took the contract and no longer holds it simply walks the pitch again from s_392. That needs
-- no latch and invents nothing.
--
-- UNUSED SHIPPED KEYS:
--   s_390 -- empty in the client.
--
-- REACHABILITY: ep3_belga_daeri is not spawned anywhere in this repo and there is no Kashyyyk ground
-- zone in config.lua ZonesEnabled. See the handler header.

ep3_belga_daeri_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_belga_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3BelgaDaeriConvoHandler",
	screens = {}
}

ep3_belga_greeting = ConvoScreen:new {
	id = "ep3_belga_greeting",
	leftDialog = "@conversation/ep3_belga_daeri:s_392", --What business do you have?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_belga_daeri:s_394", "ep3_belga_pirate"}, --I'm here to ask about a pirate.
	}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_greeting);

ep3_belga_pirate = ConvoScreen:new {
	id = "ep3_belga_pirate",
	leftDialog = "@conversation/ep3_belga_daeri:s_396", --You must be one of Stren's lackeys.  Yes there is a pirate up there taking more than his fair share.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_belga_daeri:s_398", "ep3_belga_share"}, --Fair share?
	}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_pirate);

ep3_belga_share = ConvoScreen:new {
	id = "ep3_belga_share",
	leftDialog = "@conversation/ep3_belga_daeri:s_400", --We do not have a lot of support from the Empire on this one, and the Trandoshans only care about their shipping lanes.  Piracy is expected to be dealt with by the individuals traveling these space lanes.  Normally, they don't cause too much trouble.  But this one has become a problem.  Not content with taking cargo, he has destroyed a number of transports in the last few weeks and shows no signs of stopping.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_belga_daeri:s_402", "ep3_belga_bring_in"}, --So you want him brought in?
	}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_share);

ep3_belga_bring_in = ConvoScreen:new {
	id = "ep3_belga_bring_in",
	leftDialog = "@conversation/ep3_belga_daeri:s_404", --Brought in?  And where would I put him?  No, just destroyed will suffice.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_belga_daeri:s_406", "ep3_belga_where"}, --Then destroyed it will be.  Where can I find this Dorn?
	}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_bring_in);

ep3_belga_where = ConvoScreen:new {
	id = "ep3_belga_where",
	leftDialog = "@conversation/ep3_belga_daeri:s_408", --He operates in Kashyyyk space but does not reside here.  If you take down some of his lackeys then eventually he will come looking for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_belga_daeri:s_410", "ep3_belga_accept"}, --Do you have a lead?
	}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_where);

-- The grant of assassinate/ep3_stren_dorn_lackey happens in the handler on this id.
ep3_belga_accept = ConvoScreen:new {
	id = "ep3_belga_accept",
	leftDialog = "@conversation/ep3_belga_daeri:s_412", --I will provide you with a transponder signal for his suspected cohorts.  The rest is up to you.
	stopConversation = "true",
	options = {}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_accept);

-- See the FLAGGED INTERPRETATION on s_414 in the header.
ep3_belga_standing = ConvoScreen:new {
	id = "ep3_belga_standing",
	leftDialog = "@conversation/ep3_belga_daeri:s_414", --Be careful if you approach the river to the north, you might find yourself in a Wookiee and Trandoshan battle.
	stopConversation = "true",
	options = {}
}
ep3_belga_daeri_convotemplate:addScreen(ep3_belga_standing);

addConversationTemplate("ep3_belga_daeri_convotemplate", ep3_belga_daeri_convotemplate);

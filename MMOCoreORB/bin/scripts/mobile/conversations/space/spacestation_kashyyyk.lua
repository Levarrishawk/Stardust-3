-- Kashyyyk space station (Civilian Protection Guild), commander Rian Ry.
-- Every screen is backed by a shipped key in conversation/station_kashyyyk.stf.
-- The greeting is chosen by the handler from the players station stage.

spacestation_kashyyyk_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_kashyyyk_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationKashyyykConvoHandler",
	screens = {}
}

-- Default Greeting
spacestation_kashyyyk_greeting = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting",
	leftDialog = "@conversation/station_kashyyyk:s_578", --This is Kashyyyk station. State your business.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_490", "spacestation_kashyyyk_land"}, --I need to land.
		{"@conversation/station_kashyyyk:s_709", "spacestation_kashyyyk_eyma_again"}, --How's it going, Rian?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting);

--out of range
spacestation_kashyyyk_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_kashyyyk:s_204", --Your communication stream is breaking up! Fly closer to the station so I can get a fix on your transmission.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_out_of_range);

--Unproven pilot greeting
spacestation_kashyyyk_greeting_hostile = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_hostile",
	leftDialog = "@conversation/station_kashyyyk:s_206", --Great - just what we needed: another mercenary killer. What do you want here anyway?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_208", "spacestation_kashyyyk_hostile_land"}, --I would like to land.
		{"@conversation/station_kashyyyk:s_222", "spacestation_kashyyyk_hostile_repair"}, --I'd like repairs.
		{"@conversation/station_kashyyyk:s_666", "spacestation_kashyyyk_droid_offer"}, --What's going on around here?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_hostile);

--Grudging landing clearance for an unproven pilot
spacestation_kashyyyk_hostile_land = ConvoScreen:new {
	id = "spacestation_kashyyyk_hostile_land",
	leftDialog = "@conversation/station_kashyyyk:s_210", --Sure. Anything to get you mercs out of my hair! I'll let you land at the Kachirho starport.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_214", "spacestation_kashyyyk_hostile_land_complete"}, --Thanks. (LAND)
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_hostile_land);

spacestation_kashyyyk_hostile_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_hostile_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_218", --Stay healthy... (you murdering mercenary!)
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_hostile_land_complete);

--Repairs refused until the pilot proves themselves
spacestation_kashyyyk_hostile_repair = ConvoScreen:new {
	id = "spacestation_kashyyyk_hostile_repair",
	leftDialog = "@conversation/station_kashyyyk:s_226", --Why? So you can blast us all to bits? Sorry. I don't trust you yet.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_394", "spacestation_kashyyyk_trust"}, --What will make you trust me?
		{"@conversation/station_kashyyyk:s_418", "spacestation_kashyyyk_forced_land_complete"}, --Fine! Just clear me for landing. (LAND)
		{"@conversation/station_kashyyyk:s_247", "spacestation_kashyyyk_station_out"}, --Uh... nevermind.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_hostile_repair);

spacestation_kashyyyk_forced_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_forced_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_245", --Confirmed... (filthy mercenary sithspawn!)
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_forced_land_complete);

spacestation_kashyyyk_station_out = ConvoScreen:new {
	id = "spacestation_kashyyyk_station_out",
	leftDialog = "@conversation/station_kashyyyk:s_249", --Kashyyyk station out.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_station_out);

--What will make you trust me?
spacestation_kashyyyk_trust = ConvoScreen:new {
	id = "spacestation_kashyyyk_trust",
	leftDialog = "@conversation/station_kashyyyk:s_396", --Why don't you drop in to Kachirho? Take a look around? Try not to kill anybody for a while... how about that?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_398", "spacestation_kashyyyk_deal_land_complete"}, --It's a deal. (LAND)
		{"@conversation/station_kashyyyk:s_402", "spacestation_kashyyyk_wrong"}, --You got me all wrong, lady.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_trust);

spacestation_kashyyyk_deal_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_deal_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_400", --Confirmed. Landing at Kachirho starport.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_deal_land_complete);

spacestation_kashyyyk_wrong = ConvoScreen:new {
	id = "spacestation_kashyyyk_wrong",
	leftDialog = "@conversation/station_kashyyyk:s_404", --Oh of course! You're the ONE pilot in all of Kashyyyk space who's not out to steal every last credit from these hard-working civilians, right? Sure.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_406", "spacestation_kashyyyk_clearance"}, --Can I have clearance to land?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_wrong);

spacestation_kashyyyk_clearance = ConvoScreen:new {
	id = "spacestation_kashyyyk_clearance",
	leftDialog = "@conversation/station_kashyyyk:s_408", --Oh. You want to visit Kachirho? Well - maybe that's different. Most of the mercs around here stay clear of the planet surface... for a variety of reasons. You sure you want to land?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_410", "spacestation_kashyyyk_clearance_land_complete"}, --Yes. (LAND)
		{"@conversation/station_kashyyyk:s_414", "spacestation_kashyyyk_station_out_two"}, --Nevermind.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_clearance);

spacestation_kashyyyk_clearance_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_clearance_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_412", --Confirmed.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_clearance_land_complete);

spacestation_kashyyyk_station_out_two = ConvoScreen:new {
	id = "spacestation_kashyyyk_station_out_two",
	leftDialog = "@conversation/station_kashyyyk:s_416", --Kashyyyk station out!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_station_out_two);

--The droid pilot distress call - the first CPG contract
spacestation_kashyyyk_droid_offer = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_offer",
	leftDialog = "@conversation/station_kashyyyk:s_669", --The usual mercenary mischief! We have received yet another distress call from a damaged freighter coming through the asteroid field. You want to be a hero? There's a few credits in it for you.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_698", "spacestation_kashyyyk_droid_brief"}, --Yes. I will help.
		{"@conversation/station_kashyyyk:s_677", "spacestation_kashyyyk_droid_pay"}, --What sort of credits are we talking about?
		{"@conversation/station_kashyyyk:s_674", "spacestation_kashyyyk_repair"}, --I'll need repairs first.
		{"@conversation/station_kashyyyk:s_672", "spacestation_kashyyyk_land"}, --I think I prefer to land.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_offer);

spacestation_kashyyyk_droid_pay = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_pay",
	leftDialog = "@conversation/station_kashyyyk:s_680", --The distress call bears the mark of the Civilian Protection Guild. They guarantee payment of a thousand credits for this sort of escort job. How does that sound?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_682", "spacestation_kashyyyk_droid_brief_paid"}, --I'll take it!
		{"@conversation/station_kashyyyk:s_693", "spacestation_kashyyyk_droid_decline"}, --I'll pass on this offer.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_pay);

spacestation_kashyyyk_droid_decline = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_decline",
	leftDialog = "@conversation/station_kashyyyk:s_696", --Suit yourself.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_decline);

spacestation_kashyyyk_droid_brief_paid = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_brief_paid",
	leftDialog = "@conversation/station_kashyyyk:s_685", --Okay. Maybe you're not so bad after all? The signal is coming from the other side of the asteroid belt. I am pretty certain that the pilot is a droid. Some roving bandits probably damaged the droid's navigation system.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_688", "spacestation_kashyyyk_droid_accept_paid"}, --I can lead the droid pilot back here.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_brief_paid);

spacestation_kashyyyk_droid_accept_paid = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_accept_paid",
	leftDialog = "@conversation/station_kashyyyk:s_690", --Good luck! I look forward to seeing you soon!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_accept_paid);

spacestation_kashyyyk_droid_brief = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_brief",
	leftDialog = "@conversation/station_kashyyyk:s_701", --Good. The distress call is an automated signal. It's coming from the other side of the asteroid belt. The pilot is a droid. I think something or someone damaged the droid's navigation system.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_704", "spacestation_kashyyyk_droid_accept"}, --I can lead the droid pilot back here.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_brief);

spacestation_kashyyyk_droid_accept = ConvoScreen:new {
	id = "spacestation_kashyyyk_droid_accept",
	leftDialog = "@conversation/station_kashyyyk:s_706", --Good luck! I look forward to seeing you soon!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_droid_accept);

--Droid escort in progress
spacestation_kashyyyk_greeting_droid_active = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_droid_active",
	leftDialog = "@conversation/station_kashyyyk:s_251", --That droid pilot needs your help! Escort him to this station so that we can tune his navigation system and get him on his way.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_281", "spacestation_kashyyyk_good_luck"}, --Roger that!
		{"@conversation/station_kashyyyk:s_490", "spacestation_kashyyyk_land"}, --I need to land.
		{"@conversation/station_kashyyyk:s_492", "spacestation_kashyyyk_repair"}, --I need to repair my ship.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_droid_active);

spacestation_kashyyyk_good_luck = ConvoScreen:new {
	id = "spacestation_kashyyyk_good_luck",
	leftDialog = "@conversation/station_kashyyyk:s_434", --Good luck!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_good_luck);

--Droid escort complete - Rian Ry introduces herself
spacestation_kashyyyk_greeting_intro = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_intro",
	leftDialog = "@conversation/station_kashyyyk:s_382", --Hey! Great job protecting that droid pilot. I thought he would be destroyed for sure! Listen... sorry if we got off on the wrong foot earlier. My name is Rian Ry. I am a representative of the Civilian Protection guild, and commander of this space station.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_558", "spacestation_kashyyyk_land"}, --Nice to meet you. Can I land now?
		{"@conversation/station_kashyyyk:s_388", "spacestation_kashyyyk_repair"}, --That's nice. Can I repair my ship, please?
		{"@conversation/station_kashyyyk:s_562", "spacestation_kashyyyk_about_cpg"}, --What's the Civilian Protection guild?
		{"@conversation/station_kashyyyk:s_566", "spacestation_kashyyyk_eyma_meeting"}, --Any thing CPG needs done right now?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_intro);

spacestation_kashyyyk_about_cpg = ConvoScreen:new {
	id = "spacestation_kashyyyk_about_cpg",
	leftDialog = "@conversation/station_kashyyyk:s_473", --It's a group of merchants and civilian interests that try to protect one another in lawless regions of space like Kashyyyk. CPG offers limited contracts to honest pilots such as yourself.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_566", "spacestation_kashyyyk_eyma_meeting"}, --Any thing CPG needs done right now?
		{"@conversation/station_kashyyyk:s_570", "spacestation_kashyyyk_quick_land_complete"}, --Actually, I should land right now.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_about_cpg);

spacestation_kashyyyk_quick_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_quick_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_574", --You got it!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_quick_land_complete);

--Eyma requests a meeting on the surface
spacestation_kashyyyk_eyma_meeting = ConvoScreen:new {
	id = "spacestation_kashyyyk_eyma_meeting",
	leftDialog = "@conversation/station_kashyyyk:s_536", --Absolutely! Our surface commander, Eyma, has requested a meeting with you to discuss a threat we have received. Will you agree to meet with him?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_538", "spacestation_kashyyyk_eyma_land_complete"}, --Yes. (Land)
		{"@conversation/station_kashyyyk:s_539", "spacestation_kashyyyk_repair"}, --Not now. I need repairs at the moment.
		{"@conversation/station_kashyyyk:s_542", "spacestation_kashyyyk_change_mind"}, --No. (Don't land)
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_eyma_meeting);

spacestation_kashyyyk_eyma_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_eyma_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_582", --Ah! Good. Eyma is looking forward to seeing you!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_eyma_land_complete);

spacestation_kashyyyk_change_mind = ConvoScreen:new {
	id = "spacestation_kashyyyk_change_mind",
	leftDialog = "@conversation/station_kashyyyk:s_364", --Well, I hope you change your mind.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_change_mind);

--Eyma has given the go-ahead, transport protection contracts are open
spacestation_kashyyyk_greeting_eyma_done = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_eyma_done",
	leftDialog = "@conversation/station_kashyyyk:s_730", --Hi there, %TU! Since Eyma gave the go-ahead, I'm cleared to offer transport protection contracts to you whenever you want them. You interested?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_732", "spacestation_kashyyyk_contract_granted"}, --Sounds good.
		{"@conversation/station_kashyyyk:s_736", "spacestation_kashyyyk_anything_else"}, --Is there anything else to do?
		{"@conversation/station_kashyyyk:s_490", "spacestation_kashyyyk_land"}, --I need to land.
		{"@conversation/station_kashyyyk:s_492", "spacestation_kashyyyk_repair"}, --I need to repair my ship.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_eyma_done);

spacestation_kashyyyk_contract_granted = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_granted",
	leftDialog = "@conversation/station_kashyyyk:s_734", --Exellent! Good luck, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_granted);

spacestation_kashyyyk_anything_else = ConvoScreen:new {
	id = "spacestation_kashyyyk_anything_else",
	leftDialog = "@conversation/station_kashyyyk:s_738", --Why don't you check in with Eyma again. I know he's been hard at work pulling in favors from civilian contacts all over the Kashyyyk system. He may have uncovered more information about the Ghrag mercenaries.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_740", "spacestation_kashyyyk_eyma_again_land_complete"}, --I'll go see him now! (Land)
		{"@conversation/station_kashyyyk:s_744", "spacestation_kashyyyk_contract_offer"}, --Maybe later.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_anything_else);

spacestation_kashyyyk_eyma_again_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_eyma_again_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_742", --You got it, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_eyma_again_land_complete);

spacestation_kashyyyk_contract_offer = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_offer",
	leftDialog = "@conversation/station_kashyyyk:s_746", --No problem. Would you like to take up one of our civilian protection contracts right now, then?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_732", "spacestation_kashyyyk_contract_granted"}, --Sounds good.
		{"@conversation/station_kashyyyk:s_748", "spacestation_kashyyyk_contract_detail"}, --Tell me about these contracts.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_offer);

spacestation_kashyyyk_contract_detail = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_detail",
	leftDialog = "@conversation/station_kashyyyk:s_750", --We have a large number of civilian transports headed through the Kashyyyk system at any given time. The CPG escorts the transports and protects them from pirates, the Gotal bandits and our new friends: the Ghrag mercenaries!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_732", "spacestation_kashyyyk_contract_granted"}, --Sounds good.
		{"@conversation/station_kashyyyk:s_726", "spacestation_kashyyyk_not_now"}, --I can't do this right now.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_detail);

spacestation_kashyyyk_not_now = ConvoScreen:new {
	id = "spacestation_kashyyyk_not_now",
	leftDialog = "@conversation/station_kashyyyk:s_728", --Sorry for that. Hope you can soon!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_not_now);

--Eyma wants another meeting
spacestation_kashyyyk_eyma_again = ConvoScreen:new {
	id = "spacestation_kashyyyk_eyma_again",
	leftDialog = "@conversation/station_kashyyyk:s_712", --Hey there, %TU! I just got another message from Eyma on Kashyyyk. He would like to meet with you again. What do you say?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_714", "spacestation_kashyyyk_eyma_agreed"}, --Sounds good.
		{"@conversation/station_kashyyyk:s_720", "spacestation_kashyyyk_bye_land_complete"}, --See you later! (Land)
		{"@conversation/station_kashyyyk:s_726", "spacestation_kashyyyk_not_now"}, --I can't do this right now.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_eyma_again);

spacestation_kashyyyk_eyma_agreed = ConvoScreen:new {
	id = "spacestation_kashyyyk_eyma_agreed",
	leftDialog = "@conversation/station_kashyyyk:s_717", --Excellent! I look forward to hearing from you when you get back.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_eyma_agreed);

spacestation_kashyyyk_bye_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_bye_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_722", --Bye!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_bye_land_complete);

--Tyyyn nebula rescue assigned on the surface, not yet started
spacestation_kashyyyk_greeting_rescue_pending = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_rescue_pending",
	leftDialog = "@conversation/station_kashyyyk:s_430", --Eyma said you were going to rescue a civilian transport lost in the Tyyyn nebula. You'd better get to it!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_432", "spacestation_kashyyyk_good_luck"}, --Roger that.
		{"@conversation/station_kashyyyk:s_492", "spacestation_kashyyyk_repair"}, --I need to repair my ship.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_rescue_pending);

--Tyyyn nebula rescue underway
spacestation_kashyyyk_greeting_rescue_active = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_rescue_active",
	leftDialog = "@conversation/station_kashyyyk:s_428", --That Civilian Transport needs your help, %TU! Guide them to this station and keep them out of harm's way!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_281", "spacestation_kashyyyk_good_luck"}, --Roger that!
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_rescue_active);

--Ghrag ambush warning
spacestation_kashyyyk_ghrag_warning = ConvoScreen:new {
	id = "spacestation_kashyyyk_ghrag_warning",
	leftDialog = "@conversation/station_kashyyyk:s_436", --Look out, %TU! The Ghrag are here to destroy you!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_ghrag_warning);

--Civilian transport lost
spacestation_kashyyyk_greeting_rescue_failed = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_rescue_failed",
	leftDialog = "@conversation/station_kashyyyk:s_508", --The civilians were lost! So many lives... it's such a shame! I'm hoping that you want a chance to redeem yourself right away. Am I right?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_514", "spacestation_kashyyyk_retry_rescue"}, --Yes. I want to try again!
		{"@conversation/station_kashyyyk:s_510", "spacestation_kashyyyk_land"}, --No. Land me.
		{"@conversation/station_kashyyyk:s_512", "spacestation_kashyyyk_repair"}, --No. Repair me.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_rescue_failed);

spacestation_kashyyyk_retry_rescue = ConvoScreen:new {
	id = "spacestation_kashyyyk_retry_rescue",
	leftDialog = "@conversation/station_kashyyyk:s_516", --That's the spirit! Let's go!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_retry_rescue);

--Ghrag mercenaries beaten off, the Tyyyn nebula is noisy again
spacestation_kashyyyk_greeting_ghrag_done = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_ghrag_done",
	leftDialog = "@conversation/station_kashyyyk:s_494", --Looks like these Ghrag mercenaries mean business. Good job putting them back in their place!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_500", "spacestation_kashyyyk_tyyyn_offer"}, --What's next?
		{"@conversation/station_kashyyyk:s_496", "spacestation_kashyyyk_land"}, --Thanks! I'd like to land please.
		{"@conversation/station_kashyyyk:s_498", "spacestation_kashyyyk_repair"}, --Can I repair my ship, Rian?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_ghrag_done);

spacestation_kashyyyk_tyyyn_offer = ConvoScreen:new {
	id = "spacestation_kashyyyk_tyyyn_offer",
	leftDialog = "@conversation/station_kashyyyk:s_502", --Well, I don't think they're ready to give up just yet. We're hearing all sorts of noise coming from the Tyyyn nebula. I worry that another transport has come under fire. Interested in saving the day again?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_504", "spacestation_kashyyyk_tyyyn_accept"}, --You bet!
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_tyyyn_offer);

spacestation_kashyyyk_tyyyn_accept = ConvoScreen:new {
	id = "spacestation_kashyyyk_tyyyn_accept",
	leftDialog = "@conversation/station_kashyyyk:s_506", --Great! Good luck, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_tyyyn_accept);

spacestation_kashyyyk_skip = ConvoScreen:new {
	id = "spacestation_kashyyyk_skip",
	leftDialog = "@conversation/station_kashyyyk:s_488", --No problem! Take care, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_skip);

--The Gotal bandit distress call
spacestation_kashyyyk_gotal_offer = ConvoScreen:new {
	id = "spacestation_kashyyyk_gotal_offer",
	leftDialog = "@conversation/station_kashyyyk:s_521", --Well, yeah... we just received a distress call from another transport. This one also seems to have run afoul of the Gotal bandits. Most people know to avoid the Gotal base... but not everyone, obviously. Do you want to investigate?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_504", "spacestation_kashyyyk_tyyyn_accept"}, --You bet!
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_gotal_offer);

--Second civilian transport lost
spacestation_kashyyyk_greeting_gotal_failed = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_gotal_failed",
	leftDialog = "@conversation/station_kashyyyk:s_518", --So you lost that civilian transport. So many lives... it's such a shame! I'm hoping that you want a chance to redeem yourself right away. Am I right?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_524", "spacestation_kashyyyk_retry_gotal"}, --Yes. I want to try again!
		{"@conversation/station_kashyyyk:s_520", "spacestation_kashyyyk_land"}, --No. Land me.
		{"@conversation/station_kashyyyk:s_522", "spacestation_kashyyyk_repair"}, --No. Repair me.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_gotal_failed);

spacestation_kashyyyk_retry_gotal = ConvoScreen:new {
	id = "spacestation_kashyyyk_retry_gotal",
	leftDialog = "@conversation/station_kashyyyk:s_526", --That's the spirit! Let's go!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_retry_gotal);

--Gotal bandits dusted
spacestation_kashyyyk_greeting_gotal_done = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_gotal_done",
	leftDialog = "@conversation/station_kashyyyk:s_528", --Nice to see you again, %TU! Good work dusting those Gotal bandits! The CPG is impressed. And, honestly... so am I!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_534", "spacestation_kashyyyk_eyma_meeting"}, --Is there anything CPG needs done today?
		{"@conversation/station_kashyyyk:s_530", "spacestation_kashyyyk_land"}, --Thanks! I'd like to land please.
		{"@conversation/station_kashyyyk:s_532", "spacestation_kashyyyk_repair"}, --Can I repair my ship, Rian?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_gotal_done);

--An escort contract went badly
spacestation_kashyyyk_greeting_escort_failed = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_escort_failed",
	leftDialog = "@conversation/station_kashyyyk:s_546", --Well that last escort didn't go as planned, did it? So I'm wondering now. Do you want another chance or are you done being a hero for the moment?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_514", "spacestation_kashyyyk_escort_retry"}, --Yes. I want to try again!
		{"@conversation/station_kashyyyk:s_551", "spacestation_kashyyyk_land"}, --I would like to land
		{"@conversation/station_kashyyyk:s_550", "spacestation_kashyyyk_repair"}, --I just want to repair my ship.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_escort_failed);

spacestation_kashyyyk_escort_retry = ConvoScreen:new {
	id = "spacestation_kashyyyk_escort_retry",
	leftDialog = "@conversation/station_kashyyyk:s_554", --You got it!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_escort_retry);

--The full CPG contract board
spacestation_kashyyyk_greeting_contracts = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_contracts",
	leftDialog = "@conversation/station_kashyyyk:s_444", --How's it going, %TU? You are cleared for two different contracts on behalf of the Civilian Protection Guild. Are you interested?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_446", "spacestation_kashyyyk_contract_pick"}, --Yes. I would like a mission.
		{"@conversation/station_kashyyyk:s_180", "spacestation_kashyyyk_rodians"}, --What else is there to do?
		{"@conversation/station_kashyyyk:s_269", "spacestation_kashyyyk_challenge"}, --I'm looking for a challenge!
		{"@conversation/station_kashyyyk:s_490", "spacestation_kashyyyk_land"}, --I need to land.
		{"@conversation/station_kashyyyk:s_492", "spacestation_kashyyyk_repair"}, --I need to repair my ship.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_contracts);

spacestation_kashyyyk_contract_pick = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_pick",
	leftDialog = "@conversation/station_kashyyyk:s_448", --Great to hear! You know the contracts, don't you? What would you like to do today?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_450", "spacestation_kashyyyk_contract_ghrag"}, --Let's hunt down the Ghrag!
		{"@conversation/station_kashyyyk:s_454", "spacestation_kashyyyk_contract_civilian"}, --Let me protect our civilian friends.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_pick);

spacestation_kashyyyk_contract_ghrag = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_ghrag",
	leftDialog = "@conversation/station_kashyyyk:s_452", --You got it! Good luck, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_ghrag);

spacestation_kashyyyk_contract_civilian = ConvoScreen:new {
	id = "spacestation_kashyyyk_contract_civilian",
	leftDialog = "@conversation/station_kashyyyk:s_456", --You are quite the hero, %TU!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_contract_civilian);

--The CPG Veteran patrolling the asteroid belt
spacestation_kashyyyk_challenge = ConvoScreen:new {
	id = "spacestation_kashyyyk_challenge",
	leftDialog = "@conversation/station_kashyyyk:s_273", --You might check in with the CPG Veteran pilot that patrols the asteroid belt. Look for a friendly YT-1300 vessel protecting the civilian traffic near the station.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_277", "spacestation_kashyyyk_see_you_soon"}, --Thanks! I will.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_challenge);

spacestation_kashyyyk_see_you_soon = ConvoScreen:new {
	id = "spacestation_kashyyyk_see_you_soon",
	leftDialog = "@conversation/station_kashyyyk:s_569", --Be safe, %TU. See you soon.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_see_you_soon);

--The Rodian warlords
spacestation_kashyyyk_rodians = ConvoScreen:new {
	id = "spacestation_kashyyyk_rodians",
	leftDialog = "@conversation/station_kashyyyk:s_181", --Have you contacted the Rodians? Two of their warlords operate space stations in Kashyyyk. Both of them have powerful enemies... and both will pay pilots like you to fight for them.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_182", "spacestation_kashyyyk_rodian_directions"}, --That sounds interesting!
		{"@conversation/station_kashyyyk:s_183", "spacestation_kashyyyk_slavers"}, --Anything else?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_rodians);

spacestation_kashyyyk_rodian_directions = ConvoScreen:new {
	id = "spacestation_kashyyyk_rodian_directions",
	leftDialog = "@conversation/station_kashyyyk:s_184", --You'll find them on the far side of the asteroid belt. Check your navicomputer for directions to either of the Rodian warlord bases.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_183", "spacestation_kashyyyk_slavers"}, --Anything else?
		{"@conversation/station_kashyyyk:s_575", "spacestation_kashyyyk_copy_that"}, --Disregard.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_rodian_directions);

--The Independent Slavers
spacestation_kashyyyk_slavers = ConvoScreen:new {
	id = "spacestation_kashyyyk_slavers",
	leftDialog = "@conversation/station_kashyyyk:s_185", --Nothing I would recommend. I know that there is a group of freelance slavers operating in Kashyyyk. Given how tightly the Trandoshans control this sort of commerce, I can only imagine that these 'Independent Slavers' want a piece.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_186", "spacestation_kashyyyk_slavers_where"}, --Where do I find them?
		{"@conversation/station_kashyyyk:s_187", "spacestation_kashyyyk_not_a_villain"}, --I'm not interested in that.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_slavers);

spacestation_kashyyyk_slavers_where = ConvoScreen:new {
	id = "spacestation_kashyyyk_slavers_where",
	leftDialog = "@conversation/station_kashyyyk:s_189", --Oh, I don't know. Even if I did know, I don't think I would tell you. It's horrible what they do. Just horrible!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_190", "spacestation_kashyyyk_slavers_refused"}, --Tell me anyway!
		{"@conversation/station_kashyyyk:s_191", "spacestation_kashyyyk_forget_slaving"}, --I understand.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_slavers_where);

spacestation_kashyyyk_slavers_refused = ConvoScreen:new {
	id = "spacestation_kashyyyk_slavers_refused",
	leftDialog = "@conversation/station_kashyyyk:s_193", --Forget it! You don't push me around!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_slavers_refused);

spacestation_kashyyyk_forget_slaving = ConvoScreen:new {
	id = "spacestation_kashyyyk_forget_slaving",
	leftDialog = "@conversation/station_kashyyyk:s_192", --Yeah. Just forget about slaving and stick to saving the galaxy. Sound good? Now let's talk about some CPG contracts!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_446", "spacestation_kashyyyk_contract_pick"}, --Yes. I would like a mission.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_forget_slaving);

spacestation_kashyyyk_not_a_villain = ConvoScreen:new {
	id = "spacestation_kashyyyk_not_a_villain",
	leftDialog = "@conversation/station_kashyyyk:s_188", --I knew you weren't a villain! At least... not that sort of villain. How about doing something for the CPG today instead?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_446", "spacestation_kashyyyk_contract_pick"}, --Yes. I would like a mission.
		{"@conversation/station_kashyyyk:s_575", "spacestation_kashyyyk_copy_that"}, --Disregard.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_not_a_villain);

spacestation_kashyyyk_copy_that = ConvoScreen:new {
	id = "spacestation_kashyyyk_copy_that",
	leftDialog = "@conversation/station_kashyyyk:s_664", --Copy that, %TU.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_copy_that);

--The Rebel shipyard traitor and the stolen Corellian Corvette
spacestation_kashyyyk_corvette_teaser = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_teaser",
	leftDialog = "@conversation/station_kashyyyk:s_460", --Yes, there is something else I have for you. It's very dangerous. Would you like details?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_285", "spacestation_kashyyyk_corvette_brief"}, --Yes, please.
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_teaser);

spacestation_kashyyyk_corvette_brief = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_brief",
	leftDialog = "@conversation/station_kashyyyk:s_464", --There has been some trouble at a remote Rebel Alliance shipyard. I know. I know. We're not the Alliance - but apparently one of their engineers has turned traitor and is planning to deliver a Corellian Corvette warship to the Ghrag mercenaries!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_288", "spacestation_kashyyyk_corvette_accept"}, --I'll stop them! Let's go!
		{"@conversation/station_kashyyyk:s_294", "spacestation_kashyyyk_corvette_why"}, --Why did this engineer turn traitor?
		{"@conversation/station_kashyyyk:s_478", "spacestation_kashyyyk_corvette_rebels"}, --I don't want to help the Rebels!
		{"@conversation/station_kashyyyk:s_482", "spacestation_kashyyyk_corvette_reward"}, --What will I get for this?
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_brief);

spacestation_kashyyyk_corvette_why = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_why",
	leftDialog = "@conversation/station_kashyyyk:s_476", --Seems that the Alliance has been unable to compensate their starship engineers lately. This engineer contacted the Ghrag Mercenaries and offered to sell them an Alliance warship. They jumped at the chance... as you can imagine.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_288", "spacestation_kashyyyk_corvette_accept"}, --I'll stop them! Let's go!
		{"@conversation/station_kashyyyk:s_482", "spacestation_kashyyyk_corvette_reward"}, --What will I get for this?
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_why);

spacestation_kashyyyk_corvette_rebels = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_rebels",
	leftDialog = "@conversation/station_kashyyyk:s_480", --You won't really be helping the Rebellion. If that starship falls into Ghrag Mercenary hands, all the peace and security you have fought to win here in Kashyyyk will be thrown to the wind.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_288", "spacestation_kashyyyk_corvette_accept"}, --I'll stop them! Let's go!
		{"@conversation/station_kashyyyk:s_482", "spacestation_kashyyyk_corvette_reward"}, --What will I get for this?
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_rebels);

spacestation_kashyyyk_corvette_reward = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_reward",
	leftDialog = "@conversation/station_kashyyyk:s_484", --Are you familiar with the Blacksun Vaksai prototype? It's a new starship chassis that's as small as a standard light fighter but totally re-designed on the inside. It has a much higher mass capacity than the standard! I can give you one if you recover the enemy ship!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_288", "spacestation_kashyyyk_corvette_accept"}, --I'll stop them! Let's go!
		{"@conversation/station_kashyyyk:s_486", "spacestation_kashyyyk_skip"}, --On second thought, I'll skip it.
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_reward);

spacestation_kashyyyk_corvette_accept = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_accept",
	leftDialog = "@conversation/station_kashyyyk:s_468", --I knew I could count on you, %NU! I will upload the mission data to you right now!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_291", "spacestation_kashyyyk_corvette_luck"}, --Thanks!
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_accept);

spacestation_kashyyyk_corvette_luck = ConvoScreen:new {
	id = "spacestation_kashyyyk_corvette_luck",
	leftDialog = "@conversation/station_kashyyyk:s_472", --Good luck!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_corvette_luck);

--Corvette recovered - the Blacksun Vaksai chassis reward
spacestation_kashyyyk_greeting_vaksai = ConvoScreen:new {
	id = "spacestation_kashyyyk_greeting_vaksai",
	leftDialog = "@conversation/station_kashyyyk:s_438", --I knew you wouldn't let us down, %NU! That was one in a million! Would you like the Blacksun Vaksai chassis, now?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_440", "spacestation_kashyyyk_vaksai_granted"}, --You bet!
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_greeting_vaksai);

spacestation_kashyyyk_vaksai_granted = ConvoScreen:new {
	id = "spacestation_kashyyyk_vaksai_granted",
	leftDialog = "@conversation/station_kashyyyk:s_442", --Congratulations! Happy flying!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_vaksai_granted);

--Landing clearance
spacestation_kashyyyk_land = ConvoScreen:new {
	id = "spacestation_kashyyyk_land",
	leftDialog = "@conversation/station_kashyyyk:s_563", --You can land at Kachirho starport. Confirm!
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_590", "spacestation_kashyyyk_land_complete"}, --Confirm (Land)
		{"@conversation/station_kashyyyk:s_661", "spacestation_kashyyyk_copy_that"}, --Nevermind
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_land);

spacestation_kashyyyk_land_complete = ConvoScreen:new {
	id = "spacestation_kashyyyk_land_complete",
	leftDialog = "@conversation/station_kashyyyk:s_594", --Cleared for landing. Kashyyyk space station out!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_land_complete);

-- Repair Main (repair amount options are added by the handler)
spacestation_kashyyyk_repair = ConvoScreen:new {
	id = "spacestation_kashyyyk_repair",
	leftDialog = "@conversation/station_kashyyyk:s_587", --Roger, %TU. Please indicate your status.
	stopConversation = "false",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair);

-- Recently repaired another player
spacestation_kashyyyk_repair_recent = ConvoScreen:new {
	id = "repair_recent",
	leftDialog = "@conversation/station_kashyyyk:s_605", --As you wish, %TU.  Please clear the area for other traffic.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_recent);

-- Repair Some
spacestation_kashyyyk_repair_small = ConvoScreen:new {
	id = "repair_small",
	leftDialog = "@conversation/station_kashyyyk:s_593", --Roger, %TU.  For a fee of %DI credits we'll repair just enough to get you underway.  Please confirm.
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_610", "accept_repair_25"}, --Do it
		{"@conversation/station_kashyyyk:s_614", "spacestation_kashyyyk_repair_deny"}, --No
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_small);

-- Accept Repair 25
spacestation_kashyyyk_accept_repair_25 = ConvoScreen:new {
	id = "accept_repair_25",
	leftDialog = "@conversation/station_kashyyyk:s_599", --25% of your ship damage has been fixed. Please clear the area for other traffic.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_accept_repair_25);

-- Repair Half
spacestation_kashyyyk_repair_half = ConvoScreen:new {
	id = "repair_half",
	leftDialog = "@conversation/station_kashyyyk:s_611", --Affirmative, %TU.  Repairing half your current damage will cost %DI credits. Are you ready to transfer the funds?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_622", "accept_repair_50"}, --Yes
		{"@conversation/station_kashyyyk:s_626", "spacestation_kashyyyk_repair_deny_two"}, --No
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_half);

-- Accept Repair 50
spacestation_kashyyyk_accept_repair_50 = ConvoScreen:new {
	id = "accept_repair_50",
	leftDialog = "@conversation/station_kashyyyk:s_617", --Received, %TU.  Half of your ship damage has been fixed.  You are clear to leave the area.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_accept_repair_50);

-- Repair Most
spacestation_kashyyyk_repair_most = ConvoScreen:new {
	id = "repair_most",
	leftDialog = "@conversation/station_kashyyyk:s_629", --Roger that, %TU.  We can repair three-fourths of your ship's damage at a fee of %DI credits.  Are you ready to transfer the funds?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_634", "accept_repair_75"}, --Yes
		{"@conversation/station_kashyyyk:s_638", "spacestation_kashyyyk_repair_deny_three"}, --No
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_most);

-- Accept Repair Most
spacestation_kashyyyk_accept_repair_75 = ConvoScreen:new {
	id = "accept_repair_75",
	leftDialog = "@conversation/station_kashyyyk:s_635", --Funds received, %TU... Repairs complete.  You are clear to leave the station.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_accept_repair_75);

-- Repair Full
spacestation_kashyyyk_repair_full = ConvoScreen:new {
	id = "repair_full",
	leftDialog = "@conversation/station_kashyyyk:s_646", --A complete repair of your ship will cost %DI credits, %TU.  Are you sure?
	stopConversation = "false",
	options = {
		{"@conversation/station_kashyyyk:s_649", "accept_repair_full"}, --Yes
		{"@conversation/station_kashyyyk:s_655", "spacestation_kashyyyk_repair_deny_three"}, --No
	}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_full);

-- Accept Repair Full
spacestation_kashyyyk_accept_repair_full = ConvoScreen:new {
	id = "accept_repair_full",
	leftDialog = "@conversation/station_kashyyyk:s_651", --Repairs complete!
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_accept_repair_full);

-- Declined repairs
spacestation_kashyyyk_repair_deny = ConvoScreen:new {
	id = "spacestation_kashyyyk_repair_deny",
	leftDialog = "@conversation/station_kashyyyk:s_605", --As you wish, %TU.  Please clear the area for other traffic.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_deny);

spacestation_kashyyyk_repair_deny_two = ConvoScreen:new {
	id = "spacestation_kashyyyk_repair_deny_two",
	leftDialog = "@conversation/station_kashyyyk:s_623", --As you wish, %TU.  Please clear the area for other traffic.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_deny_two);

spacestation_kashyyyk_repair_deny_three = ConvoScreen:new {
	id = "spacestation_kashyyyk_repair_deny_three",
	leftDialog = "@conversation/station_kashyyyk:s_658", --As you wish, %TU.  Please leave the area to make room for incoming traffic.  Out.
	stopConversation = "true",
	options = {}
}
spacestation_kashyyyk_convotemplate:addScreen(spacestation_kashyyyk_repair_deny_three);

-- Add Template (EOF)
addConversationTemplate("spacestation_kashyyyk_convotemplate", spacestation_kashyyyk_convotemplate);

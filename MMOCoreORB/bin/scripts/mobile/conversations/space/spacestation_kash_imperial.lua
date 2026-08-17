-- Kashyyyk Imperial Base. Every screen is backed by a shipped key in
-- conversation/station_imperial_base.stf, including the faction declare branch.

spacestation_kash_imperial_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_kash_imperial_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationKashImperialConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_kash_imperial_greeting = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting",
	leftDialog = "@conversation/station_imperial_base:s_260", --That's a fine-looking starship, %NU. Most impressive. What can I do for you today?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_262", "spacestation_kash_imperial_duty"}, --I would like a mission.
		{"@conversation/station_imperial_base:s_264", "spacestation_kash_imperial_declare_prompt"}, --I would like to declare my faction affiliation.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting);

--out of range
spacestation_kash_imperial_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_imperial_base:s_48f82131", --You need to move closer to this station.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_out_of_range);

--Neutral Greeting
spacestation_kash_imperial_greeting_neutral = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_neutral",
	leftDialog = "@conversation/station_imperial_base:s_2e491159", --Sign up with the Empire and we'll talk.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_neutral);

--Rebel Greeting
spacestation_kash_imperial_greeting_rebel = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_rebel",
	leftDialog = "@conversation/station_imperial_base:s_f48e8567", --You are not welcome at this station Rebel, SCUM!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_rebel);

--Player is flying a civilian hull
spacestation_kash_imperial_civilian_ship = ConvoScreen:new {
	id = "spacestation_kash_imperial_civilian_ship",
	leftDialog = "@conversation/station_imperial_base:s_358253b2", --There's nothing we can do for you while you're in that civilian ship.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_civilian_ship);

--Player is already on a mission
spacestation_kash_imperial_busy = ConvoScreen:new {
	id = "spacestation_kash_imperial_busy",
	leftDialog = "@conversation/station_imperial_base:s_e8cb2563", --We could put your ship to good use, %TU, but you seem to be busy doing something else. Finish your mission and we'll talk.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_busy);

--Duty mission board, unlocked by breaking the Ghrag plot
spacestation_kash_imperial_duty = ConvoScreen:new {
	id = "spacestation_kash_imperial_duty",
	leftDialog = "@conversation/station_imperial_base:s_310", --Ah yes! The hero who saved this space station from the Ghrag mercenaries' plot. We have unlocked two duty missions for you. What's your pleasure?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_312", "spacestation_kash_imperial_duty_choices"}, --What are my choices?
		{"@conversation/station_imperial_base:s_338", "spacestation_kash_imperial_challenge"}, --How about a more challenging mission?
		{"@conversation/station_imperial_base:s_336", "spacestation_kash_imperial_declare_prompt"}, --I would like to declare my faction affiliation.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_duty);

spacestation_kash_imperial_duty_choices = ConvoScreen:new {
	id = "spacestation_kash_imperial_duty_choices",
	leftDialog = "@conversation/station_imperial_base:s_314", --There are two to choose from. A destroy duty and an escort duty. Which would you like?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_316", "spacestation_kash_imperial_destroy_duty"}, --Destroy duty.
		{"@conversation/station_imperial_base:s_326", "spacestation_kash_imperial_escort_duty"}, --Escort duty.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_duty_choices);

spacestation_kash_imperial_destroy_duty = ConvoScreen:new {
	id = "spacestation_kash_imperial_destroy_duty",
	leftDialog = "@conversation/station_imperial_base:s_318", --Excellent. This mission requires you to punish the Ghrag mercenary clan. Patrol the Kashyyyk system and destroy all Ghrag pilots you encounter.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_320", "spacestation_kash_imperial_destroy_granted"}, --I'll take it!
		{"@conversation/station_imperial_base:s_324", "spacestation_kash_imperial_duty_choices"}, --I'd like something else.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_destroy_duty);

spacestation_kash_imperial_destroy_granted = ConvoScreen:new {
	id = "spacestation_kash_imperial_destroy_granted",
	leftDialog = "@conversation/station_imperial_base:s_322", --Outstanding!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_destroy_granted);

spacestation_kash_imperial_escort_duty = ConvoScreen:new {
	id = "spacestation_kash_imperial_escort_duty",
	leftDialog = "@conversation/station_imperial_base:s_328", --Outstanding. Protect Imperial freighters as they travel through this system. The Ghrag mercenaries will undoubtedly try to destroy them!
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_330", "spacestation_kash_imperial_escort_granted"}, --I'll take it!
		{"@conversation/station_imperial_base:s_334", "spacestation_kash_imperial_duty_choices"}, --I'd like something else.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_escort_duty);

spacestation_kash_imperial_escort_granted = ConvoScreen:new {
	id = "spacestation_kash_imperial_escort_granted",
	leftDialog = "@conversation/station_imperial_base:s_332", --Superb!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_escort_granted);

--The Gaaltura V corvette infiltration
spacestation_kash_imperial_challenge = ConvoScreen:new {
	id = "spacestation_kash_imperial_challenge",
	leftDialog = "@conversation/station_imperial_base:s_340", --Amusing. So you're too good for the standard duty mission, eh? Given your history this may be true. You are a well-respected pilot, %TU. Perhaps I do have something that you would find interesting...
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_342", "spacestation_kash_imperial_corvette_brief"}, --Let's hear it.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_challenge);

spacestation_kash_imperial_corvette_brief = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_brief",
	leftDialog = "@conversation/station_imperial_base:s_344", --A special Imperial Operative has infiltrated the Rebel Alliance and is stowed away aboard a Corellian Corvette called 'The Gaaltura V.' Reports indicate that this vessel is headed through the Kashyyyk system very soon.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_346", "spacestation_kash_imperial_corvette_orders"}, --What do you want me to do?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_brief);

spacestation_kash_imperial_corvette_orders = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_orders",
	leftDialog = "@conversation/station_imperial_base:s_348", --We wish to activate this special Operative. Once she receives her orders, she will fight her way to the bridge and take command of the vessel. Before she can do her job, you must intercept and disable the Corvette.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_350", "spacestation_kash_imperial_corvette_plan"}, --And then what?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_orders);

spacestation_kash_imperial_corvette_plan = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_plan",
	leftDialog = "@conversation/station_imperial_base:s_352", --The Operative will slice the navicomputer and allow me to take control of the ship by remote. I will fly it here. You protect it. That's it.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_354", "spacestation_kash_imperial_corvette_reward"}, --What do I get for this?
		{"@conversation/station_imperial_base:s_358", "spacestation_kash_imperial_corvette_accept"}, --For the Emperor!
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_plan);

spacestation_kash_imperial_corvette_reward = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_reward",
	leftDialog = "@conversation/station_imperial_base:s_356", --To accomplish this would set you firmly above the standard Imperial Navy pilot. Success in this mission qualifies you to fly the 'Crimson Guard' TIE Interceptor. Complete the mission and I will award the starship to you.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_358", "spacestation_kash_imperial_corvette_accept"}, --For the Emperor!
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_reward);

spacestation_kash_imperial_corvette_accept = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_accept",
	leftDialog = "@conversation/station_imperial_base:s_360", --Affirmative. Good luck, pilot.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_accept);

--Corvette mission still running
spacestation_kash_imperial_greeting_corvette_active = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_corvette_active",
	leftDialog = "@conversation/station_imperial_base:s_274", --You asked for the challenge... now do it!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_corvette_active);

--Escort duty still running
spacestation_kash_imperial_greeting_escort_active = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_escort_active",
	leftDialog = "@conversation/station_imperial_base:s_276", --You've got a transport to escort, pilot! Get going.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_escort_active);

--Corvette mission failed
spacestation_kash_imperial_greeting_corvette_failed = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_corvette_failed",
	leftDialog = "@conversation/station_imperial_base:s_278", --You failed! Fortunately our operative managed to escape the Corvette and has rejoined the Alliance in a nearby system. Apparently, the Rebels are going to try to cut through Kashyyyk space again... are you ready to stop them?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_280", "spacestation_kash_imperial_corvette_retry"}, --Yes. I will try again!
		{"@conversation/station_imperial_base:s_284", "spacestation_kash_imperial_declare_prompt"}, --I need to declare my faction affiliation.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_corvette_failed);

spacestation_kash_imperial_corvette_retry = ConvoScreen:new {
	id = "spacestation_kash_imperial_corvette_retry",
	leftDialog = "@conversation/station_imperial_base:s_282", --Outstanding!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_corvette_retry);

--Escort duty failed
spacestation_kash_imperial_greeting_escort_failed = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_escort_failed",
	leftDialog = "@conversation/station_imperial_base:s_286", --This is unacceptable! The Emperor's transports must be protected. Your performance is pitiful.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_288", "spacestation_kash_imperial_escort_retry"}, --Give me another chance.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_escort_failed);

spacestation_kash_imperial_escort_retry = ConvoScreen:new {
	id = "spacestation_kash_imperial_escort_retry",
	leftDialog = "@conversation/station_imperial_base:s_290", --Do not fail us again, pilot.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_escort_retry);

--The Ghrag plot against the station has been broken
spacestation_kash_imperial_greeting_hero = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_hero",
	leftDialog = "@conversation/station_imperial_base:s_292", --I recognize you, pilot. You are the one they have been talking about. The one who foiled the Ghrag mercenaries' plot to eliminate this space station. Outstanding!
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_294", "spacestation_kash_imperial_award_enroute"}, --Thank you.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_hero);

spacestation_kash_imperial_award_enroute = ConvoScreen:new {
	id = "spacestation_kash_imperial_award_enroute",
	leftDialog = "@conversation/station_imperial_base:s_296", --Apparently, word of your victory has spread far. Imperial command has authorized a special award for your service. It is en route to this base and should be here momentarily.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_298", "spacestation_kash_imperial_award_what"}, --What is it?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_award_enroute);

spacestation_kash_imperial_award_what = ConvoScreen:new {
	id = "spacestation_kash_imperial_award_what",
	leftDialog = "@conversation/station_imperial_base:s_300", --From what I understand, you are to receive a holographic projection system that produces a proud symbol of the Empire. You are encouraged to place this award in an obvious place... and spread the good-will of the Emperor.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_302", "spacestation_kash_imperial_favor"}, --Sounds good.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_award_what);

spacestation_kash_imperial_favor = ConvoScreen:new {
	id = "spacestation_kash_imperial_favor",
	leftDialog = "@conversation/station_imperial_base:s_304", --While we wait... I do have a favor to ask of you, though. We are short-staffed on the escort duty roster. I need someone to escort a transport through Kashyyyk space. Should not take long. By the time you are done, your award will have arrived.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_306", "spacestation_kash_imperial_favor_accept"}, --Yes, sir.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_favor);

spacestation_kash_imperial_favor_accept = ConvoScreen:new {
	id = "spacestation_kash_imperial_favor_accept",
	leftDialog = "@conversation/station_imperial_base:s_308", --Good luck, pilot.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_favor_accept);

--Hologram award handed over
spacestation_kash_imperial_greeting_award = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_award",
	leftDialog = "@conversation/station_imperial_base:s_362", --Good job, pilot. As I expected, your award from Imperial Command arrived while you were on duty. I would like to transfer it to your starship immediately.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_364", "spacestation_kash_imperial_award_granted"}, --Thank you.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_award);

spacestation_kash_imperial_award_granted = ConvoScreen:new {
	id = "spacestation_kash_imperial_award_granted",
	leftDialog = "@conversation/station_imperial_base:s_393", --You are welcome, pilot.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_award_granted);

--Corvette recovered - the Crimson Guard TIE Interceptor reward
spacestation_kash_imperial_greeting_tie = ConvoScreen:new {
	id = "spacestation_kash_imperial_greeting_tie",
	leftDialog = "@conversation/station_imperial_base:s_266", --Congratulations, pilot! The mission was a success. Our special Operative sends her regards. I am now authorized to present you with the 'Crimson Guard' TIE Interceptor. Are you ready to receive it?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_268", "spacestation_kash_imperial_tie_granted"}, --Yes, sir!
		{"@conversation/station_imperial_base:s_272", "spacestation_kash_imperial_declare_prompt"}, --I would like to declare my faction affiliation.
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_greeting_tie);

spacestation_kash_imperial_tie_granted = ConvoScreen:new {
	id = "spacestation_kash_imperial_tie_granted",
	leftDialog = "@conversation/station_imperial_base:s_270", --Good hunting!
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_tie_granted);

--Declare prompt
spacestation_kash_imperial_declare_prompt = ConvoScreen:new {
	id = "spacestation_kash_imperial_declare_prompt",
	leftDialog = "@conversation/station_imperial_base:s_afe52489", --Welcome to the Imperial Space Station, %TU. Would you like to declare your affiliation with the Empire?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_370822d1", "spacestation_kash_imperial_declare"}, --Yes
		{"@conversation/station_imperial_base:s_457a7010", "spacestation_kash_imperial_decline"}, --No
		{"@conversation/station_imperial_base:s_dd67013", "spacestation_kash_imperial_explain_01"}, --What does that mean?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_declare_prompt);

--Declare overt
spacestation_kash_imperial_declare = ConvoScreen:new {
	id = "spacestation_kash_imperial_declare",
	leftDialog = "@conversation/station_imperial_base:s_7b492de4", --Very well, %TU. Your ship will begin broadcasting your Imperial affiliation in 30 seconds. You may want to clear the area in the event there are hostiles nearby. Imperial Station, out.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_declare);

--Decline declaring overt
spacestation_kash_imperial_decline = ConvoScreen:new {
	id = "spacestation_kash_imperial_decline",
	leftDialog = "@conversation/station_imperial_base:s_1e8d6243", --In that case, please move away from the station. Clear the area for official traffic.
	stopConversation = "true",
	options = {}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_decline);

-- Begin explanation
spacestation_kash_imperial_explain_01 = ConvoScreen:new {
	id = "spacestation_kash_imperial_explain_01",
	leftDialog = "@conversation/station_imperial_base:s_25329880", --Although you are an Imperial Pilot by profession, you have not Declared your factional affiliation. Many Rebel ships [players] will hold-fire in the event you are not really affiliated with the Empire. You may declare your affiliation with the Empire to make it clear that you are willing to respond to their attacks.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_626fe576", "spacestation_kash_imperial_explain_02"}, --How long does this last?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_explain_01);

-- Continue explanation
spacestation_kash_imperial_explain_02 = ConvoScreen:new {
	id = "spacestation_kash_imperial_explain_02",
	leftDialog = "@conversation/station_imperial_base:s_41ebf230", --You will be Declared Imperial until you land your ship. The next time you launch, if you want to be a Declared Imperial again, you must speak to an Imperial Station again.
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_3a7768e6", "spacestation_kash_imperial_explain_03"}, --All Rebel Pilots will be able to attack me?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_explain_02);

-- Final explanation
spacestation_kash_imperial_explain_03 = ConvoScreen:new {
	id = "spacestation_kash_imperial_explain_03",
	leftDialog = "@conversation/station_imperial_base:s_ef2a0e9c", --Not all of them, %TU. Just the ones that have Declared their affiliation with the Rebel Alliance. You'll be able to attack them, and they will be able to attack you. Ready to declare?
	stopConversation = "false",
	options = {
		{"@conversation/station_imperial_base:s_370822d1", "spacestation_kash_imperial_declare"}, --Yes
		{"@conversation/station_imperial_base:s_457a7010", "spacestation_kash_imperial_decline"}, --No
		{"@conversation/station_imperial_base:s_dd67013", "spacestation_kash_imperial_explain_01"}, --What does that mean?
	}
}
spacestation_kash_imperial_convotemplate:addScreen(spacestation_kash_imperial_explain_03);

-- Add Template (EOF)
addConversationTemplate("spacestation_kash_imperial_convotemplate", spacestation_kash_imperial_convotemplate);

-- Kashyyyk Rebel Outpost. Every screen is backed by a shipped key in
-- conversation/station_rebel_outpost.stf, including the faction declare branch.

spacestation_kash_rebel_convotemplate = ConvoTemplate:new {
	initialScreen = "spacestation_kash_rebel_greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationKashRebelConvoHandler",
	screens = {}
}

-- Initial Greeting
spacestation_kash_rebel_greeting = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting",
	leftDialog = "@conversation/station_rebel_outpost:s_761", --Well hello there, %TU! Is there anything we can do for you?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_763", "spacestation_kash_rebel_duty"}, --I would like a mission.
		{"@conversation/station_rebel_outpost:s_793", "spacestation_kash_rebel_challenge"}, --I am looking for a challenge!
		{"@conversation/station_rebel_outpost:s_791", "spacestation_kash_rebel_declare_prompt"}, --I would like to declare my faction affiliation.
		{"@conversation/station_rebel_outpost:s_787", "spacestation_kash_rebel_nevermind"}, --Nevermind.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting);

--out of range
spacestation_kash_rebel_out_of_range = ConvoScreen:new {
	id = "out_of_range",
	leftDialog = "@conversation/station_rebel_outpost:s_727", --You need to move closer to this station.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_out_of_range);

--Neutral Greeting
spacestation_kash_rebel_greeting_neutral = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_neutral",
	leftDialog = "@conversation/station_rebel_outpost:s_725", --Sign up with the Rebel Alliance and we'll talk.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_neutral);

--Imperial Greeting
spacestation_kash_rebel_greeting_imperial = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_imperial",
	leftDialog = "@conversation/station_rebel_outpost:s_715", --You are not welcome at this station!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_imperial);

--Player is flying a civilian hull
spacestation_kash_rebel_civilian_ship = ConvoScreen:new {
	id = "spacestation_kash_rebel_civilian_ship",
	leftDialog = "@conversation/station_rebel_outpost:s_713", --There's nothing we can do for you while you're in that civilian ship.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_civilian_ship);

--Player is already on a mission
spacestation_kash_rebel_busy = ConvoScreen:new {
	id = "spacestation_kash_rebel_busy",
	leftDialog = "@conversation/station_rebel_outpost:s_717", --What's up, %TU? You look busy...
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_719", "spacestation_kash_rebel_good_luck"}, --That's because I am on a mission.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_busy);

spacestation_kash_rebel_good_luck = ConvoScreen:new {
	id = "spacestation_kash_rebel_good_luck",
	leftDialog = "@conversation/station_rebel_outpost:s_721", --Good luck!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_good_luck);

spacestation_kash_rebel_nevermind = ConvoScreen:new {
	id = "spacestation_kash_rebel_nevermind",
	leftDialog = "@conversation/station_rebel_outpost:s_789", --Roger that, %TU.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_nevermind);

--Duty mission selection
spacestation_kash_rebel_duty = ConvoScreen:new {
	id = "spacestation_kash_rebel_duty",
	leftDialog = "@conversation/station_rebel_outpost:s_765", --But of course, my friend! There are two different classes of ongoing duty missions that I can offer. Which would you like?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_767", "spacestation_kash_rebel_destroy_duty"}, --Destroy duty.
		{"@conversation/station_rebel_outpost:s_777", "spacestation_kash_rebel_escort_duty"}, --Escort duty.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_duty);

spacestation_kash_rebel_destroy_duty = ConvoScreen:new {
	id = "spacestation_kash_rebel_destroy_duty",
	leftDialog = "@conversation/station_rebel_outpost:s_769", --Good choice. As you may know, the Ghrag mercenaries used to be our allies here in Kashyyyk space. Now, all of that has changed. The Ghrag have announced that they are going to sell us out to the Empire. We need you to hunt down their pilots and prevent them from interfering with our operations here.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_771", "spacestation_kash_rebel_destroy_granted"}, --I'll take it!
		{"@conversation/station_rebel_outpost:s_775", "spacestation_kash_rebel_duty"}, --I'd like something else.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_destroy_duty);

spacestation_kash_rebel_destroy_granted = ConvoScreen:new {
	id = "spacestation_kash_rebel_destroy_granted",
	leftDialog = "@conversation/station_rebel_outpost:s_773", --Grant mission: Destroy Duty
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_destroy_granted);

spacestation_kash_rebel_escort_duty = ConvoScreen:new {
	id = "spacestation_kash_rebel_escort_duty",
	leftDialog = "@conversation/station_rebel_outpost:s_779", --Very good choice, my friend. Our operations in the Kashyyyk system are very sensitive - and the Ghrag mercenaries have become a real problem. It's hard enough to liberate our Wookiee allies with the Empire breathing down our necks all the time. Now we have Ghrag pilots threatening to disrupt our transport lines!
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_781", "spacestation_kash_rebel_escort_granted"}, --I'll take it.
		{"@conversation/station_rebel_outpost:s_785", "spacestation_kash_rebel_duty"}, --I'd like something else.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_escort_duty);

spacestation_kash_rebel_escort_granted = ConvoScreen:new {
	id = "spacestation_kash_rebel_escort_granted",
	leftDialog = "@conversation/station_rebel_outpost:s_783", --Grant mission: Escort duty.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_escort_granted);

--The stolen Corellian Corvette
spacestation_kash_rebel_challenge = ConvoScreen:new {
	id = "spacestation_kash_rebel_challenge",
	leftDialog = "@conversation/station_rebel_outpost:s_795", --Well, you've come to the right place. I just got word from Alliance Command that one of our Corvette starships has been stolen! We need it back, of course... are you ready to help?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_797", "spacestation_kash_rebel_corvette_accept"}, --Let's go!
		{"@conversation/station_rebel_outpost:s_805", "spacestation_kash_rebel_corvette_how"}, --Stolen? How did that happen?
		{"@conversation/station_rebel_outpost:s_813", "spacestation_kash_rebel_corvette_reward"}, --What do I get?
		{"@conversation/station_rebel_outpost:s_817", "spacestation_kash_rebel_corvette_decline"}, --No thanks!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_challenge);

spacestation_kash_rebel_corvette_how = ConvoScreen:new {
	id = "spacestation_kash_rebel_corvette_how",
	leftDialog = "@conversation/station_rebel_outpost:s_807", --Apparently, due to constant Imperial attacks, we have been unable to provide adequate payment to contractors working at a secret Rebel shipyard. One of the engineers has turned traitor...
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_809", "spacestation_kash_rebel_corvette_detail"}, --And?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_corvette_how);

spacestation_kash_rebel_corvette_detail = ConvoScreen:new {
	id = "spacestation_kash_rebel_corvette_detail",
	leftDialog = "@conversation/station_rebel_outpost:s_811", --This engineer is planning to sell the Corellian corvette to the Ghrag Mercenary Clan! Fortunately - the remaining engineers on-board the vessel are loyal to the Alliance and will re-take the bridge if you can disable the starship.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_797", "spacestation_kash_rebel_corvette_accept"}, --Let's go!
		{"@conversation/station_rebel_outpost:s_813", "spacestation_kash_rebel_corvette_reward"}, --What do I get?
		{"@conversation/station_rebel_outpost:s_817", "spacestation_kash_rebel_corvette_decline"}, --No thanks!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_corvette_detail);

spacestation_kash_rebel_corvette_reward = ConvoScreen:new {
	id = "spacestation_kash_rebel_corvette_reward",
	leftDialog = "@conversation/station_rebel_outpost:s_815", --Alliance High Command has authorized me to give you an experimental starship chassis. It is a heavy version of the X-wing fighter. It has much greater mass capacity than the standard one!
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_797", "spacestation_kash_rebel_corvette_accept"}, --Let's go!
		{"@conversation/station_rebel_outpost:s_817", "spacestation_kash_rebel_corvette_decline"}, --No thanks!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_corvette_reward);

spacestation_kash_rebel_corvette_accept = ConvoScreen:new {
	id = "spacestation_kash_rebel_corvette_accept",
	leftDialog = "@conversation/station_rebel_outpost:s_799", --Excellent! I will upload the mission package right now!
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_801", "spacestation_kash_rebel_for_the_alliance"}, --Thank you!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_corvette_accept);

spacestation_kash_rebel_for_the_alliance = ConvoScreen:new {
	id = "spacestation_kash_rebel_for_the_alliance",
	leftDialog = "@conversation/station_rebel_outpost:s_803", --For the Alliance!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_for_the_alliance);

spacestation_kash_rebel_corvette_decline = ConvoScreen:new {
	id = "spacestation_kash_rebel_corvette_decline",
	leftDialog = "@conversation/station_rebel_outpost:s_819", --Roger that.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_corvette_decline);

--Corvette recovered - the Heavy X-wing chassis reward
spacestation_kash_rebel_greeting_xwing = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_xwing",
	leftDialog = "@conversation/station_rebel_outpost:s_850", --Congratulations! Excellent work bringing down that traitor and saving our engineers! I would like to reward you with the prototype Heavy X-wing chassis. Would you like it now?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_1110", "spacestation_kash_rebel_xwing_granted"}, --Yes, please!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_xwing);

spacestation_kash_rebel_xwing_granted = ConvoScreen:new {
	id = "spacestation_kash_rebel_xwing_granted",
	leftDialog = "@conversation/station_rebel_outpost:s_1111", --You deserve it! The Force be with you!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_xwing_granted);

--The Ghrag plot against the station has been broken
spacestation_kash_rebel_greeting_hero = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_hero",
	leftDialog = "@conversation/station_rebel_outpost:s_735", --Nice to finally meet you, %TU. We've been hearing a lot about your exploits. Seems you've single-handedly brought down a Ghrag mercenary plot to destroy this station. Excellent work! I have something else for you to do... if you're interested.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_737", "spacestation_kash_rebel_transport_brief"}, --Sure, I'm interested.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_hero);

spacestation_kash_rebel_transport_brief = ConvoScreen:new {
	id = "spacestation_kash_rebel_transport_brief",
	leftDialog = "@conversation/station_rebel_outpost:s_739", --Good. We've been trying to get several transports out of this area for operations in classified regions of deep space. I need you to escort one of these transports and report back when you are done.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_745", "spacestation_kash_rebel_transport_accept"}, --Roger that.
		{"@conversation/station_rebel_outpost:s_741", "spacestation_kash_rebel_transport_cargo"}, --What are they carrying?
		{"@conversation/station_rebel_outpost:s_749", "spacestation_kash_rebel_transport_reward"}, --What do I get for this?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_transport_brief);

spacestation_kash_rebel_transport_cargo = ConvoScreen:new {
	id = "spacestation_kash_rebel_transport_cargo",
	leftDialog = "@conversation/station_rebel_outpost:s_743", --Awards, personal effects, decorations, hand-written messages to the troops. Nothing too special. But the Ghrag have been pounding the transports since they know that most of our fighter screen is deployed to other areas.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_745", "spacestation_kash_rebel_transport_accept"}, --Roger that.
		{"@conversation/station_rebel_outpost:s_749", "spacestation_kash_rebel_transport_reward"}, --What do I get for this?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_transport_cargo);

spacestation_kash_rebel_transport_accept = ConvoScreen:new {
	id = "spacestation_kash_rebel_transport_accept",
	leftDialog = "@conversation/station_rebel_outpost:s_747", --Good luck.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_transport_accept);

spacestation_kash_rebel_transport_reward = ConvoScreen:new {
	id = "spacestation_kash_rebel_transport_reward",
	leftDialog = "@conversation/station_rebel_outpost:s_751", --Well, considering how you've protected us from the Ghrag mercenaries - I think you deserve a special ornament that indicates your loyalty to the Alliance.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_753", "spacestation_kash_rebel_hologram"}, --What do you have in-mind?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_transport_reward);

spacestation_kash_rebel_hologram = ConvoScreen:new {
	id = "spacestation_kash_rebel_hologram",
	leftDialog = "@conversation/station_rebel_outpost:s_755", --A limited-edition holographic projection of the Alliance symbol. You could place it in your home if you wish. I'd recommend keeping it away from Imperial eyes, of course.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_757", "spacestation_kash_rebel_hologram_thanks"}, --Thanks!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_hologram);

spacestation_kash_rebel_hologram_thanks = ConvoScreen:new {
	id = "spacestation_kash_rebel_hologram_thanks",
	leftDialog = "@conversation/station_rebel_outpost:s_759", --No problem. Good luck!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_hologram_thanks);

--Escort duty award
spacestation_kash_rebel_greeting_award = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_award",
	leftDialog = "@conversation/station_rebel_outpost:s_821", --The Alliance thanks you, my friend. In payment, I would like to award you with the Alliance Symbol Hologram.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_823", "spacestation_kash_rebel_award_granted"}, --Thanks!
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_award);

spacestation_kash_rebel_award_granted = ConvoScreen:new {
	id = "spacestation_kash_rebel_award_granted",
	leftDialog = "@conversation/station_rebel_outpost:s_825", --You deserve it!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_award_granted);

--Escort duty failed
spacestation_kash_rebel_greeting_failed = ConvoScreen:new {
	id = "spacestation_kash_rebel_greeting_failed",
	leftDialog = "@conversation/station_rebel_outpost:s_729", --Perhaps your reputation isn't so well-deserved. The Alliance commands you to protect our transports!
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_731", "spacestation_kash_rebel_retry"}, --Let me try again.
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_greeting_failed);

spacestation_kash_rebel_retry = ConvoScreen:new {
	id = "spacestation_kash_rebel_retry",
	leftDialog = "@conversation/station_rebel_outpost:s_733", --Better luck, this time!
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_retry);

--Declare prompt
spacestation_kash_rebel_declare_prompt = ConvoScreen:new {
	id = "spacestation_kash_rebel_declare_prompt",
	leftDialog = "@conversation/station_rebel_outpost:s_827", --Welcome to the Rebel Alliance Space Station, %TU. Would you like to declare your affiliation with the Rebel Alliance?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_829", "spacestation_kash_rebel_declare"}, --Yes
		{"@conversation/station_rebel_outpost:s_833", "spacestation_kash_rebel_decline"}, --No
		{"@conversation/station_rebel_outpost:s_839", "spacestation_kash_rebel_explain_01"}, --What does that mean?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_declare_prompt);

--Declare overt
spacestation_kash_rebel_declare = ConvoScreen:new {
	id = "spacestation_kash_rebel_declare",
	leftDialog = "@conversation/station_rebel_outpost:s_831", --Very well, %TU. Your ship will begin broadcasting your Rebel Alliance affiliation in 30 seconds. You may want to clear the area in the event there are hostiles nearby. Rebel Alliance Station, out.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_declare);

--Decline declaring overt
spacestation_kash_rebel_decline = ConvoScreen:new {
	id = "spacestation_kash_rebel_decline",
	leftDialog = "@conversation/station_rebel_outpost:s_837", --In that case, please move away from the station.
	stopConversation = "true",
	options = {}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_decline);

-- Begin explanation
spacestation_kash_rebel_explain_01 = ConvoScreen:new {
	id = "spacestation_kash_rebel_explain_01",
	leftDialog = "@conversation/station_rebel_outpost:s_841", --Although you are a Rebel Alliance Pilot by profession, you have not Declared your factional affiliation. Many Imperial ships [players] will hold fire in the event you are not really affiliated with the Rebel Alliance. You may declare your affiliation with the Alliance to make it clear that you are willing to respond to their attacks.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_843", "spacestation_kash_rebel_explain_02"}, --How long does this last?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_explain_01);

-- Continue explanation
spacestation_kash_rebel_explain_02 = ConvoScreen:new {
	id = "spacestation_kash_rebel_explain_02",
	leftDialog = "@conversation/station_rebel_outpost:s_845", --You will be a Declared Rebel until you land your ship. The next time you launch, if you want to be a Declared Rebel again, you must speak to a Rebel Alliance Station again.
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_847", "spacestation_kash_rebel_explain_03"}, --All Imperial Pilots will be able to attack me?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_explain_02);

-- Final explanation
spacestation_kash_rebel_explain_03 = ConvoScreen:new {
	id = "spacestation_kash_rebel_explain_03",
	leftDialog = "@conversation/station_rebel_outpost:s_849", --Not all of them, %TU. Just the ones that have Declared their affiliation with the Empire. You'll be able to attack them, and they will be able to attack you. Ready to declare?
	stopConversation = "false",
	options = {
		{"@conversation/station_rebel_outpost:s_829", "spacestation_kash_rebel_declare"}, --Yes
		{"@conversation/station_rebel_outpost:s_833", "spacestation_kash_rebel_decline"}, --No
		{"@conversation/station_rebel_outpost:s_839", "spacestation_kash_rebel_explain_01"}, --What does that mean?
	}
}
spacestation_kash_rebel_convotemplate:addScreen(spacestation_kash_rebel_explain_03);

-- Add Template (EOF)
addConversationTemplate("spacestation_kash_rebel_convotemplate", spacestation_kash_rebel_convotemplate);

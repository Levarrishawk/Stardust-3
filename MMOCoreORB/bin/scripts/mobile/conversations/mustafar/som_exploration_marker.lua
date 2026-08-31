--[[
	Surveyor Keslev -- The Mining Field Markers.

	THIS TREE IS NO LONGER A RECONSTRUCTION

	It is now read off Mustafar's server-side som_exploration_marker conversation, which
	names the same conversation id this file is named for. Everything below -- screen order,
	which option hangs off which screen, and the animation on each -- is what that
	conversation does. The client string table settles the wording.

	The SD1 port this replaced carried seven near-identical choose_search_location_N screens
	and six welcome_back_N screens, each with one live option and the other six commented
	out, which hard-sequenced the areas. Live does not sequence them: each area's option is
	shown unless that area is already started or finished. That is one screen with runtime
	options, and it is what keslev_conv_handler builds.

	WHAT THE STRING-NUMBERING METHOD GOT WRONG

	The earlier revision paired screens by consecutive string numbers. That method got every
	screen and every edge right and still put three things in the wrong place:

	  * The two refusals were swapped. s_74 "No thanks. I think I will pass on this job."
	    reads like an opening brush-off, so it was hung off the opening screen. Live hangs
	    it off the LAST screen of the pitch, and hangs s_76 "Not right now. Maybe later."
	    off the opening.
	  * welcome_back's refusal was s_76. Live uses s_39 -- "No thanks. Maybe later.", a third
	    near-identical string that the numbering heuristic had no reason to reach for.
	  * The welcome-back area list reused s_44. Live has its own line for it, s_40, which
	    says "Same deal as before" -- wording that only makes sense on a return visit.

	Same lesson as som_kenobi_q4p3.lua: consecutive numbering pins WHICH line answers which.
	It says nothing about the order options are listed in, and nothing about which screen an
	option hangs off when two strings read alike.

	THE THREE REFUSALS ARE THREE SCREENS

	s_74, s_76 and s_39 all lead to the same reply, s_78. They are still three screens here
	because live plays a different animation on each: refuse_offer_affection off the opening,
	shake_head_no off the other two. Merging them would lose that.

	THE NAME IS "SURVEYOR KESLEV"

	No "Jo". All seven shipped quest journals -- som_exploration_{berken,burning,crystal,
	mining,smoking,tulrus,volcano}.stf -- say "Surveyor Keslev has asked you to...". The
	middle name came from the wiki. The template was also the one Mustafar tree not named
	after its own file; it is now som_exploration_marker, like every sibling in this folder
	and like the live conversation id.

	WHAT LIVE DOES NOT HAVE

	No turn-in screen and no in-progress screen. Live pays each area from the .qst's own
	Reward task the moment its markers are all activated, so there is nothing to walk back
	and hand in; the return visit is just s_10 asking whether you want another area. The
	earlier revision invented both screens and reused s_10 for them. mining_field_markers.lua
	now pays on area completion instead, and those two screens are gone.

	Every leftDialog and option string is an existing @conversation/som_exploration_marker
	entry, so this works against a stock client.

	THE COUNTS RECONCILE

	Live uses 20 distinct NPC lines and 18 distinct player responses, laid out as 25 option
	edges. This file is 22 screens and 11 static options. Both differences are accounted
	for, and neither is a missing piece:

	    20 NPC lines  + 2   s_78 is three screens here, one per refusal   = 22 screens
	    25 edges      - 14  the seven area options are listed twice, under
	                        s_44 and under s_40, and both lists are built
	                        at runtime by keslev_conv_handler                = 11 static

	Checked with /c/tmp/keslev-check.lua, which loads this file and the handler against a
	stubbed conversation API and asserts every edge, every option ORDER, every terminal
	flag, every animation key, and that areaOptions / areaListOrder / areaByScreen /
	markerAreas all name the same seven areas.
--]]

som_exploration_marker = ConvoTemplate:new {
	initialScreen = "first_screen",
	templateType = "Lua",
	luaClassHandler = "keslev_conv_handler",
	screens = {}
}

-----------------------------------------------------------------------------------
-- The pitch. Opens on the default condition -- the player has touched no area yet.
-----------------------------------------------------------------------------------

first_screen = ConvoScreen:new {
	id = "first_screen",
	leftDialog = "@conversation/som_exploration_marker:s_15", -- Welcome to our fiery moon. I have noticed you around and was hoping for a chance to speak with you. You seem very interested in helping others and I was wondering if you would be willing to perform a small task for me?
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_17", "opt1"}, -- Sure. What is it you need?
		{"@conversation/som_exploration_marker:s_76", "deny"}  -- Not right now. Maybe later.
	}
}
som_exploration_marker:addScreen(first_screen);

opt1 = ConvoScreen:new {
	id = "opt1",
	leftDialog = "@conversation/som_exploration_marker:s_19", -- Well, I have put up a number of markers around the planet. They are very helpful to keep track of certain important areas. Our world has a tendency to shift unexpectedly and it is important that we carefully mark different areas. Naturally, the markers also shift, so we occasionally have to manually check them out to make sure they are still valid.
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_21", "opt1a"}, -- Naturally. So what is it I can do for you?
	}
}
som_exploration_marker:addScreen(opt1);

opt1a = ConvoScreen:new {
	id = "opt1a",
	leftDialog = "@conversation/som_exploration_marker:s_23", -- Well, recent events have left me extremely short-handed, and I was hoping that you would check out these markers for me. The job is really simple. All you need to do is find the markers and activate them to make sure they still have valid information on them.
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_25", "opt1b"}, -- That seems easy enough.
	}
}
som_exploration_marker:addScreen(opt1a);

opt1b = ConvoScreen:new {
	id = "opt1b",
	leftDialog = "@conversation/som_exploration_marker:s_27", -- It would be, except that due to the shifting of our moon's surface, I cannot give you precise locations. All I can do is give you general directions to where each one should be. Each of Mustafar's main areas has several of these markers scattered throughout them. I will need you to activate each area's markers individually.
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_29", "opt1c"}, -- What would this sort of job pay?
	}
}
som_exploration_marker:addScreen(opt1b);

opt1c = ConvoScreen:new {
	id = "opt1c",
	leftDialog = "@conversation/som_exploration_marker:s_31", -- Hmmmm... How about this? For each area you complete, I will pay you five thousand credits. And as a bonus, if you check all the markers in all the areas, I will give you a Tanray Heart Crystal.
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_33", "opt1d"}, -- What is a Tanray Heart Crystal?
	}
}
som_exploration_marker:addScreen(opt1c);

-- The last screen of the pitch, and where the "pass on this job" refusal actually hangs.
opt1d = ConvoScreen:new {
	id = "opt1d",
	leftDialog = "@conversation/som_exploration_marker:s_35", -- It is a fabulous crystal formed under intense heat and pressure that is...well, it is shaped like the heart of a tanray. They can be worth a hefty sum to certain collectors, but most people just use them as decoration. So do we have a deal?
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_37", "choose_search_location"}, -- Okay, we have a deal.
		{"@conversation/som_exploration_marker:s_74", "deny_later"}              -- No thanks. I think I will pass on this job.
	}
}
som_exploration_marker:addScreen(opt1d);

-----------------------------------------------------------------------------------
-- The three refusals. One reply, three screens -- see THE THREE REFUSALS ARE THREE
-- SCREENS in the header.
-----------------------------------------------------------------------------------

deny = ConvoScreen:new {
	id = "deny",
	leftDialog = "@conversation/som_exploration_marker:s_78", -- Of course. I wouldn't want to impose on you too much.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(deny);

deny_later = ConvoScreen:new {
	id = "deny_later",
	leftDialog = "@conversation/som_exploration_marker:s_78", -- Of course. I wouldn't want to impose on you too much.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(deny_later);

deny_back = ConvoScreen:new {
	id = "deny_back",
	leftDialog = "@conversation/som_exploration_marker:s_78", -- Of course. I wouldn't want to impose on you too much.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(deny_back);

-----------------------------------------------------------------------------------
-- Area choice. Two screens, not one: live has a separate line for the return visit.
-- Options are added at runtime, one per area the player has neither started nor
-- finished -- live guards each with !isQuestActiveOrComplete on that area's quest.
-----------------------------------------------------------------------------------

choose_search_location = ConvoScreen:new {
	id = "choose_search_location",
	leftDialog = "@conversation/som_exploration_marker:s_44", -- Excellent. So what area would you like to search for markers in? We have markers near the mining facility, in the Crystal Flats, up in the Smoking Forest, around the Central Volcano, in the Burning Plains, all over Berken's Flow, and, of course, in the Tulrus Nesting Grounds.
	stopConversation = "false",
	options = {}
}
som_exploration_marker:addScreen(choose_search_location);

choose_again = ConvoScreen:new {
	id = "choose_again",
	leftDialog = "@conversation/som_exploration_marker:s_40", -- That is most excellent news. Same deal as before, five thousand credits per area completed and if you complete them all, I will give you a Tanray Heart Crystal. Which area would you like to search for markers in?
	stopConversation = "false",
	options = {}
}
som_exploration_marker:addScreen(choose_again);

-----------------------------------------------------------------------------------
-- Quest starters, one per area. Arriving here is what grants that area's quest --
-- live hangs the grant off the option, which fires before this screen is shown.
-----------------------------------------------------------------------------------

choose_facility = ConvoScreen:new {
	id = "choose_facility",
	leftDialog = "@conversation/som_exploration_marker:s_48", -- Sure do. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_facility);

choose_crystal_flats = ConvoScreen:new {
	id = "choose_crystal_flats",
	leftDialog = "@conversation/som_exploration_marker:s_52", -- Of course. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_crystal_flats);

choose_smoking_forest = ConvoScreen:new {
	id = "choose_smoking_forest",
	leftDialog = "@conversation/som_exploration_marker:s_56", -- That is a good choice. Remember, you will receive five thousand credits per area searched and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_smoking_forest);

choose_central_volcano = ConvoScreen:new {
	id = "choose_central_volcano",
	leftDialog = "@conversation/som_exploration_marker:s_60", -- Always a nice decision. Remember, you will receive five thousand credits per area searched and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_central_volcano);

choose_burning_plains = ConvoScreen:new {
	id = "choose_burning_plains",
	leftDialog = "@conversation/som_exploration_marker:s_64", -- I hear it is nice this time of year...well as nice as Mustafar gets, anyways. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_burning_plains);

choose_berkens_flow = ConvoScreen:new {
	id = "choose_berkens_flow",
	leftDialog = "@conversation/som_exploration_marker:s_68", -- Ah, Berken's Flow...I learned how to mine there. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_berkens_flow);

choose_tulrus_nesting_grounds = ConvoScreen:new {
	id = "choose_tulrus_nesting_grounds",
	leftDialog = "@conversation/som_exploration_marker:s_72", -- A very fine valley. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(choose_tulrus_nesting_grounds);

-----------------------------------------------------------------------------------
-- Return visits.
-----------------------------------------------------------------------------------

-- Opens whenever the player has started or finished at least one area and has not
-- finished them all. Live's condition is hasAcceptedOne.
welcome_back = ConvoScreen:new {
	id = "welcome_back",
	leftDialog = "@conversation/som_exploration_marker:s_10", -- Welcome back. It is good to see you are in good health. Are you back to check on some more markers for me?
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_38", "choose_again"}, -- Yeah, I will check a few more areas for you.
		{"@conversation/som_exploration_marker:s_39", "deny_back"}     -- No thanks. Maybe later.
	}
}
som_exploration_marker:addScreen(welcome_back);

-- All seven areas done and the crystal not yet handed over. NOT a terminal screen:
-- live offers s_41 here and grants the reward on the way to s_42.
finished_all = ConvoScreen:new {
	id = "finished_all",
	leftDialog = "@conversation/som_exploration_marker:s_6", -- Hello again, my friend. You certainly have done a wonderful job and saved me all sorts of trouble trying to check all of those markers out. And as promised, here is your Tanray Heart Crystal. Thank you again.
	stopConversation = "false",
	options = {
		{"@conversation/som_exploration_marker:s_41", "reward"}, -- Thank you.
	}
}
som_exploration_marker:addScreen(finished_all);

-- The crystal and the badge are granted on arriving here.
reward = ConvoScreen:new {
	id = "reward",
	leftDialog = "@conversation/som_exploration_marker:s_42", -- A deal is a deal. Safe travels to you, my friend.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(reward);

-- Every hail after the crystal has been handed over. Live gates this on the objvar
-- grantReward sets, and it outranks every other opening.
already_rewarded = ConvoScreen:new {
	id = "already_rewarded",
	leftDialog = "@conversation/som_exploration_marker:s_4", -- Ah, it is my good friend again. I hope everything is going well for you. Unfortunately, I cannot chat today. My boss has asked me to pull a double shift and I really need to get back to work. Take care.
	stopConversation = "true",
	options = {}
}
som_exploration_marker:addScreen(already_rewarded);

addConversationTemplate("som_exploration_marker", som_exploration_marker);

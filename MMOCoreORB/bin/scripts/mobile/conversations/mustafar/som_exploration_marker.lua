--[[
	Surveyor Jo Keslev -- The Mining Field Markers.

	The SD1 port carried seven near-identical choose_search_location_N screens and six
	welcome_back_N screens, each with a single live option and the other six commented out,
	which hard-sequenced the areas: mining facility first, then Crystal Flats, then Smoking
	Forest, and so on. Live NGE lets the player pick any area they have not finished. That
	is now one choose_search_location screen and one welcome_back screen whose options are
	built at runtime by jo_kelsev_conv_handler from the areas the player has left.

	Every leftDialog and option string below is an existing @conversation/som_exploration_marker
	entry -- no new client strings are introduced, so this works against a stock client. The
	turn_in and in_progress screens reuse s_10 ("Welcome back...") for the same reason; the
	payout itself is reported through a system message.
--]]

jo_kelsev = ConvoTemplate:new {
  initialScreen = "first_screen",
  templateType = "Lua",
  luaClassHandler = "jo_kelsev_conv_handler",
  screens = {}
}


--Intro First
jo_kelsev_first_screen = ConvoScreen:new {
  id = "first_screen",
  leftDialog = "@conversation/som_exploration_marker:s_15",  -- Welcome to our fiery moon. I have noticed you around and was hoping for a chance to speak with you. You seem very interested in helping others and I was wondering if you would be willing to perform a small task for me?
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_17", "opt1"},  -- Sure. What is it you need?
    {"@conversation/som_exploration_marker:s_74", "deny"}  -- No thanks.  I think I will pass on this job.

  }
}
jo_kelsev:addScreen(jo_kelsev_first_screen);

jo_kelsev_deny = ConvoScreen:new {
  id = "deny",
  leftDialog = "@conversation/som_exploration_marker:s_78",  -- Of course. I wouldn't want to impose on you too much.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(jo_kelsev_deny);



opt1 = ConvoScreen:new {
  id = "opt1",
  leftDialog = "@conversation/som_exploration_marker:s_19", -- Well, I have put up a number of markers around the planet. They are very helpful to keep track of certain important areas. Our world has a tendency to shift unexpectedly and it is important that we carefully mark different areas. Naturally, the markers also shift, so we occasionally have to manually check them out to make sure they are still valid.
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_21","opt1a"}, -- Naturally.  So what is it I can do for you?
  }
}
jo_kelsev:addScreen(opt1);

opt1a = ConvoScreen:new {
  id = "opt1a",
  leftDialog = "@conversation/som_exploration_marker:s_23", -- Well, recent events have left me extremely short-handed, and I was hoping that you would check out these markers for me. The job is really simple. All you need to do is find the markers and activate them to make sure they still have valid information on them.
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_25","opt1b"},  -- That seems easy enough.
  }
}
jo_kelsev:addScreen(opt1a);

opt1b = ConvoScreen:new {
  id = "opt1b",
  leftDialog = "@conversation/som_exploration_marker:s_27", -- It would be, except that due to the shifting of our moon's surface, I cannot give you precise locations. All I can do is give you general directions to where each one should be. Each of Mustafar's main areas has several of these markers scattered throughout them. I will need you to activate each area's markers individually.
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_29","opt1c"},  -- What would this sort of job pay?
  }
}
jo_kelsev:addScreen(opt1b);

opt1c = ConvoScreen:new {
  id = "opt1c",
  leftDialog = "@conversation/som_exploration_marker:s_31", -- pay: five thousand credits per area searched, plus a Tanray Heart Crystal for completing them all.
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_33","opt1d"},  -- What is a Tanray Heart Crystal?
  }
}
jo_kelsev:addScreen(opt1c);

opt1d = ConvoScreen:new {
  id = "opt1d",
  leftDialog = "@conversation/som_exploration_marker:s_35", -- description of the Tanray Heart Crystal.
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_37","choose_search_location"},  -- Okay, we have a deal
    {"@conversation/som_exploration_marker:s_76","deny"}  -- Not right now.  Maybe later.
  }
}
jo_kelsev:addScreen(opt1d);

-----------------------------------------------------------------------------------
-- Area choice -- options are added at runtime, one per area the player has left.
-- --------------------------------------------------------------------------------
choose_search_location = ConvoScreen:new {
  id = "choose_search_location",
  leftDialog = "@conversation/som_exploration_marker:s_44", -- Excellent. So what area would you like to search for markers in? We have markers near the mining facility, in the Crystal Flats, up in the Smoking Forest, around the Central Volcano, in the Burning Plains, all over Berken's Flow, and, of course, in the Tulrus Nesting Grounds.
  stopConversation = "false",
  options = {}
}
jo_kelsev:addScreen(choose_search_location);


----------------------------------------------------------------------------------------
-- Quest Starters -- one per area, each with its own NGE acceptance line.
-- -------------------------------------------------------------------------------------
choose_facility = ConvoScreen:new {
  id = "choose_facility",
  leftDialog = "@conversation/som_exploration_marker:s_48", -- Sure do. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_facility);

choose_crystal_flats = ConvoScreen:new {
  id = "choose_crystal_flats",
  leftDialog = "@conversation/som_exploration_marker:s_52", -- Of course. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_crystal_flats);

choose_smoking_forest = ConvoScreen:new {
  id = "choose_smoking_forest",
  leftDialog = "@conversation/som_exploration_marker:s_56", -- That is a good choice. Remember, you will receive five thousand credits per area searched and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_smoking_forest);

choose_central_volcano = ConvoScreen:new {
  id = "choose_central_volcano",
  leftDialog = "@conversation/som_exploration_marker:s_60", -- Always a nice decision. Remember, you will receive five thousand credits per area searched and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_central_volcano);

choose_burning_plains = ConvoScreen:new {
  id = "choose_burning_plains",
  leftDialog = "@conversation/som_exploration_marker:s_64", -- I hear it is nice this time of year...well as nice as Mustafar gets, anyways. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_burning_plains);

choose_berkens_flow = ConvoScreen:new {
  id = "choose_berkens_flow",
  leftDialog = "@conversation/som_exploration_marker:s_68", -- Ah, Berken's Flow...I learned how to mine there. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_berkens_flow);

choose_tulrus_nesting_grounds = ConvoScreen:new {
  id = "choose_tulrus_nesting_grounds",
  leftDialog = "@conversation/som_exploration_marker:s_72", -- A very fine valley. Remember, you will receive five thousand credits per area searched, and if you complete them all, I will toss in a Tanray Heart Crystal.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(choose_tulrus_nesting_grounds);

--------------------------------------------------------------------------------------------------------
-- Return / Next Quest Leg
--------------------------------------------------------------------------------------------------------

--  Player has finished at least one area set and is back for another.
welcome_back = ConvoScreen:new {
  id = "welcome_back",
  leftDialog = "@conversation/som_exploration_marker:s_10", -- Welcome back. It is good to see you are in good health. Are you back to check on some more markers for me?
  stopConversation = "false",
  options = {
    {"@conversation/som_exploration_marker:s_38","choose_search_location"},  -- Yeah, I will check a few more areas for you.
    {"@conversation/som_exploration_marker:s_76","deny"}  -- Not right now.  Maybe later.
  }
}
jo_kelsev:addScreen(welcome_back);

--  Player has a completed set to hand in. The handler pays out on entering this screen and
--  then adds the "check a few more areas" option only if areas remain.
turn_in = ConvoScreen:new {
  id = "turn_in",
  leftDialog = "@conversation/som_exploration_marker:s_10", -- Welcome back. It is good to see you are in good health. Are you back to check on some more markers for me?
  stopConversation = "false",
  options = {}
}
jo_kelsev:addScreen(turn_in);

--  Player is part way through an area set.
in_progress = ConvoScreen:new {
  id = "in_progress",
  leftDialog = "@conversation/som_exploration_marker:s_10", -- Welcome back. It is good to see you are in good health. Are you back to check on some more markers for me?
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(in_progress);

--------------------------------------------------------------------------
--   Finished all, issue reward.
--   ---------------------------------------------------------------------

finished_all = ConvoScreen:new {
  id = "finished_all",
  leftDialog = "@conversation/som_exploration_marker:s_6", -- Hello again, my friend. You certainly have done a wonderful job and saved me all sorts of trouble trying to check all of those markers out. And as promised, here is your Tanray Heart Crystal. Thank you again.
  stopConversation = "true",
  options = {}
}
jo_kelsev:addScreen(finished_all);


addConversationTemplate("jo_kelsev", jo_kelsev);

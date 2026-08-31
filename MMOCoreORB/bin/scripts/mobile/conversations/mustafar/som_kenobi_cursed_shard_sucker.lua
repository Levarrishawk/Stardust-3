--[[
	The Hungry Whiphid -- the "sucker" you can palm the cursed shard off on.

	SOURCE OF RECORD -- NO LONGER A RECONSTRUCTION

	  It is now read off Mustafar's server-side som_kenobi_cursed_shard_sucker
	  conversation, which names the same conversation id this file is named for.
	  The client string table settles the wording; the server conversation
	  settles the edges, the option ORDER and the conditions.  Every shipped
	  string is used except s_2, which is empty -- live never references it either.

	  The reconstruction was right about every edge.  It was wrong about the
	  order of two option lists, and both were only findable from the server side:

	    food_ask (branch 8)   live lists s_33, s_38, s_42.  This file had s_33,
	                          s_42, s_38 -- the winning night-time lie was shown
	                          ABOVE the failure instead of below it.
	    luck_ask (branch 12)  live lists s_50, s_54, s_58.  This file had s_50,
	                          s_58, s_54 -- same shape of error, the fall-back to
	                          the food lie shown above the failure.

	  Root cause: a string table records an option's TEXT but not its position.
	  The earlier revision grouped each list as "Force option, then the way that
	  works, then the way that fails", which reads sensibly and is not what SOE
	  shipped -- live puts the failure second in both.  Option order is not
	  cosmetic here: it is what the client renders and what the player's numbered
	  reply maps onto.

	  What the server side CONFIRMED, against the suspicion that it would not:
	  action_signalGivenCrystal fires on exactly s_24, s_36, s_44 and s_52 --
	  the four screens already in the handler's handover table.  s_35, s_40 and
	  s_56 grant nothing.  s_56 in particular looks like it might ("No! Now get
	  out of here...") and does not.

	  The shape: he opens hostile-bored (s_4/s_8), the player
	  shows him the crystal (s_10), he bites on "shiny" (s_12), and then asks the
	  only question that matters -- s_16 "So...what it do?".  From there the
	  player picks one of three lies, each with its own comeback:

	    s_18  "It doesn't do anything..."        -> s_20  "Then why I want it?"
	    s_29  "it can create food out of water"  -> s_31  "You show first! You think I a fool?!"
	    s_46  "It brings you great luck"         -> s_48  "I already have luck and fortune."

	  Each comeback has a [Use the Force] option (s_22 / s_33 / s_50) whose reply
	  parrots the suggestion straight back (s_24 / s_36 / s_52) -- that is a mind
	  trick, and those three are guaranteed successes.  s_58 lets the luck lie
	  fall back onto the food lie, and s_42 ("It only works during night time")
	  is the one non-Force success.  s_35 / s_40 / s_56 are the failures; all
	  three end with "before I have you for food!".

	  s_60 "Step back or be hurt!" is what he says once he has already thrown the
	  player out, and doubles as his line to anyone with no business with him.

	FORCE GATING
	  Live guards s_22, s_33 and s_50 with condition_playerJedi, which is
	  jedi.isForceSensitive -- force sensitive, NOT Padawan.
	  cursed_shard_sucker_conv_handler strips those three (removeAllOptions +
	  addOption rebuild) and tests force_title_jedi_novice; it used to test
	  force_title_jedi_rank_01, which is Padawan and hid the options from every
	  FS character below it.  See that file's canUseTheForce.

	  A non-sensitive therefore has exactly one way through: the night-time lie
	  under the food branch.

	THE OPENING
	  Live gates the whole conversation on condition_givingAwayCrystal, which is
	  isTaskActive(player, "som_kenobi_cursed_shard_2", "givingUpShard").  Anyone
	  else gets s_60 as a chat.chat bubble with no conversation window at all.
	  Core3 cannot do that from getInitialScreen, so s_60 is a one-line terminal
	  screen here -- same words, one extra click to dismiss.  Same deviation, and
	  same reason, as the brush-off in som_kenobi_serpent_thief.

	COUNTS RECONCILE
	    14 live screens  + 1  rebuffed, the deviation in THE OPENING above  = 15
	    14 options across the 7 screens that have any, in live's order
	    24 animations hang off those 14 options; they land on 13 distinct
	       destinations, which is what the handler's screenAnimations holds
	     4 grants, 3 Force-guarded options
	  Checked by tmp/sucker-check.lua against the server-side conversation. It
	  also proves the thing the handler depends on rather than assuming it: no
	  destination screen is reached by two edges carrying DIFFERENT animations,
	  which is what makes keying by destination lossless here.

	QUEST
	  Every success screen fires the .qst's "gaveAwayShard" signal, which is
	  Branch B of quest/som_kenobi_cursed_shard_2 -- see
	  screenplays/mustafar/quest/cursed_shard.lua.  (Branch A is throwing the
	  shard into the volcano instead; the two branches are alternatives.)
]]

som_kenobi_cursed_shard_sucker = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "cursed_shard_sucker_conv_handler",
	screens = {}
}

------------------------------------------------------------------------------
-- the pitch
------------------------------------------------------------------------------

sucker_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_4", -- What you want?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_6", "not_interested"},  -- I'm here to offer you a deal of a lifetime!
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_greeting)

sucker_not_interested = ConvoScreen:new {
	id = "not_interested",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_8", -- I have job to do. Unless it food, I not interested!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_10", "shiny"},         -- Well, it's not food, but look at this crystal! Pretty eh?
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_not_interested)

sucker_shiny = ConvoScreen:new {
	id = "shiny",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_12", -- Sure is shiny...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_14", "what_it_do"},    -- I know! You offer me something nice in return and it's yours!
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_shiny)

sucker_what_it_do = ConvoScreen:new {
	id = "what_it_do",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_16", -- So...what it do?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_18", "nothing_ask"},   -- Do? It doesn't do anything...
		{"@conversation/som_kenobi_cursed_shard_sucker:s_29", "food_ask"},      -- Do? Well, it can create food out of water, of course!
		{"@conversation/som_kenobi_cursed_shard_sucker:s_46", "luck_ask"},      -- Do? It brings you great luck and fortune!
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_what_it_do)

------------------------------------------------------------------------------
-- lie 1: it does nothing
------------------------------------------------------------------------------

sucker_nothing_ask = ConvoScreen:new {
	id = "nothing_ask",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_20", -- Then why I want it?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_22", "take_pretty"},   -- [Use the Force] Since it's real pretty, you will pay well for it.
		{"@conversation/som_kenobi_cursed_shard_sucker:s_26", "fail_pretty"},   -- Well, it's so pretty.
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_nothing_ask)

sucker_take_pretty = ConvoScreen:new {
	id = "take_pretty",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_24", -- It is really pretty. I pay you well for it. Here, take this. Give me the shiny.
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_take_pretty)

sucker_fail_pretty = ConvoScreen:new {
	id = "fail_pretty",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_35", -- It is pretty, but not pretty enough. Now leave before I have you for food. I really hungry!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_fail_pretty)

------------------------------------------------------------------------------
-- lie 2: it makes food out of water
------------------------------------------------------------------------------

sucker_food_ask = ConvoScreen:new {
	id = "food_ask",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_31", -- Get out of here! That would be so good! Wait a minute. You show first! You think I a fool?!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_33", "take_fool"},     -- [Use the Force] You are a fool and will pay well for the crystal.
		{"@conversation/som_kenobi_cursed_shard_sucker:s_38", "fail_water"},    -- Well, I don't think there's any water around here...
		{"@conversation/som_kenobi_cursed_shard_sucker:s_42", "take_night"},    -- I can't. It only works during night time.
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_food_ask)

sucker_take_fool = ConvoScreen:new {
	id = "take_fool",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_36", -- I be a fool and will give you this for the shiny. Now give it!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_take_fool)

sucker_take_night = ConvoScreen:new {
	id = "take_night",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_44", -- Ohh yeah, that makes sense. Alright, you take this. I take shiny.
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_take_night)

sucker_fail_water = ConvoScreen:new {
	id = "fail_water",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_40", -- Yeah, you probably right... Get out of here before I have you for food! I really hungry!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_fail_water)

------------------------------------------------------------------------------
-- lie 3: it brings luck and fortune
------------------------------------------------------------------------------

sucker_luck_ask = ConvoScreen:new {
	id = "luck_ask",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_48", -- I already have luck and fortune.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_cursed_shard_sucker:s_50", "take_fortune"},  -- [Use the Force] You could always use more fortune.
		{"@conversation/som_kenobi_cursed_shard_sucker:s_54", "fail_fortune"},  -- Well, couldn't you use some more luck and fortune?
		{"@conversation/som_kenobi_cursed_shard_sucker:s_58", "food_ask"},      -- Oh...and food. I forgot to mention it can make food of water!
	}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_luck_ask)

sucker_take_fortune = ConvoScreen:new {
	id = "take_fortune",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_52", -- I could always use more fortune. Here, you take this. Now give shiny!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_take_fortune)

sucker_fail_fortune = ConvoScreen:new {
	id = "fail_fortune",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_56", -- No! Now get out of here before I have you for food! I really hungry!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_fail_fortune)

------------------------------------------------------------------------------
-- state the handler opens on: already thrown out, or no business with him
------------------------------------------------------------------------------

sucker_rebuffed = ConvoScreen:new {
	id = "rebuffed",
	leftDialog = "@conversation/som_kenobi_cursed_shard_sucker:s_60", -- Step back or be hurt!
	stopConversation = "true",
	options = {}
}
som_kenobi_cursed_shard_sucker:addScreen(sucker_rebuffed)

addConversationTemplate("som_kenobi_cursed_shard_sucker", som_kenobi_cursed_shard_sucker)

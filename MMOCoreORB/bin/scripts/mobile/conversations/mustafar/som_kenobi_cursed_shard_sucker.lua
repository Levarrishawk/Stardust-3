--[[
	The Hungry Whiphid -- the "sucker" you can palm the cursed shard off on.

	SOURCE OF RECORD
	  string/en/conversation/som_kenobi_cursed_shard_sucker.stf, 30 strings.  As
	  with every conversation in this arc the .stf shipped but SOE's editor tree
	  did not, so the branching is reconstructed from the strings.  Every shipped
	  string is used except s_2, which is empty.

	  The shape the strings dictate: he opens hostile-bored (s_4/s_8), the player
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
	  cursed_shard_sucker_conv_handler strips the three [Use the Force] options
	  for a player without force_title_jedi_rank_01 (removeAllOptions + addOption
	  rebuild).  A non-Jedi therefore has exactly one way through: the night-time
	  lie under the food branch.

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
		{"@conversation/som_kenobi_cursed_shard_sucker:s_42", "take_night"},    -- I can't. It only works during night time.
		{"@conversation/som_kenobi_cursed_shard_sucker:s_38", "fail_water"},    -- Well, I don't think there's any water around here...
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
		{"@conversation/som_kenobi_cursed_shard_sucker:s_58", "food_ask"},      -- Oh...and food. I forgot to mention it can make food of water!
		{"@conversation/som_kenobi_cursed_shard_sucker:s_54", "fail_fortune"},  -- Well, couldn't you use some more luck and fortune?
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

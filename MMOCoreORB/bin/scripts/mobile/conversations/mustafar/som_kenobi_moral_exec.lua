--[[
	The mining corporation executive -- som_kenobi_moral_choice_1.

	RECONSTRUCTED, not ported. som_kenobi_moral_exec.stf shipped in the client
	(string/en/conversation/); the SwgConversationEditor tree that wires those
	strings into screens did not. Every leftDialog and option string below is
	SOE's verbatim text; the edges between them are reconstructed.

	THE PITCH IS WRITTEN TWICE, and the player's first answer picks the copy:

	  s_112  "That depends on what you need assistance with."
	         -> s_63 "OF COURSE IT DOES. We have a bit of a problem with some
	         miners that are on strike..." -- the opening words are the tell,
	         s_63 only answers s_112 -- then s_64/s_65, s_66/s_70, s_71/s_91,
	         with s_68/s_69 as the way out.

	  s_111  "Sure am. What did you have in mind?"
	         -> s_95, which is s_63 with the "Of course it does." stripped off
	         the front and nothing else changed, then s_99/s_103, s_128/s_130,
	         s_132/s_134, with s_136/s_138 as the way out.

	s_65 and s_103 are the same paragraph, one per chain, exactly like the
	pwwoz and serpent tables. Neither chain's lines appear in the other.

	The second chain has one extra beat the first does not: s_116 "Is there
	really no other way to solve the conflict?" and its answer s_127. It hands
	the same accept/refuse pair back afterwards, so it is a detour, not a fork.

	TWO WAYS OUT OF THE GREETING that are neither chain: s_113 "No, sorry, not
	right now." is answered by s_62 "I trust that you'll come back when you
	are.", and the flat s_114 "No." is answered by s_61 "You shouldn't be so
	quick to dismiss people of importance..." -- the same refusal, told off.

	THE RETURN IS WRITTEN TWICE TOO, and this time it is the player's attitude
	to what he just did that picks the copy off s_140:

	  s_142  "I hope this will get a peaceful ending now."  -> s_145, s_146,
	         reward s_148, s_150, s_152
	  s_144  "Of course I do. They didn't know what hit them."  -> s_156,
	         s_160, reward s_162, s_165, s_169

	s_148 and s_162 are the same reward speech written twice, and s_152/s_169
	the same sign-off -- s_169 with "Now now, settle down there, buddy."
	prepended, because s_165 is angrier than s_150.

	s_47 "I'm busy and you're too wet behind the ears..." is the too-low-level
	refusal. Unlike Pwwoz, whose table shipped nothing of the kind, SOE wrote
	this one, so the level gate needs no invented text.

	s_45 "You have ruined me! I thought I could trust you, you rotting mynock!"
	is what he says to a player who took the miners' side and uploaded the
	proof. He survives it -- nothing in the .qst kills him -- which is why the
	creature template is ATTACKABLE rather than a corpse.

	s_2 is the empty string and is not a screen.
]]

som_kenobi_moral_exec = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "moral_exec_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- THE OFFER -- the opening, and the two ways out of it
--------------------------------------------------------------------------------

moral_exec_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_110", -- You there. The corporation could use your assistance. Are you available at the moment?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_112", "pitch_a"},  -- That depends on what you need assistance with.
		{"@conversation/som_kenobi_moral_exec:s_111", "pitch_b"},  -- Sure am. What did you have in mind?
		{"@conversation/som_kenobi_moral_exec:s_113", "later"},    -- No, sorry, not right now.
		{"@conversation/som_kenobi_moral_exec:s_114", "dismiss"},  -- No.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_greeting)

moral_exec_later = ConvoScreen:new {
	id = "later",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_62", -- I trust that you'll come back when you are.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_later)

moral_exec_dismiss = ConvoScreen:new {
	id = "dismiss",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_61", -- You shouldn't be so quick to dismiss people of importance...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_dismiss)

-- The .qst's [list] block says Level = 75. moral_exec_conv_handler routes here
-- instead of the greeting when the player is under it.
moral_exec_toolow = ConvoScreen:new {
	id = "toolow",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_47", -- I'm busy and you're too wet behind the ears. Come back when you've gained some experience and I may have a job for you.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_toolow)

--------------------------------------------------------------------------------
-- CHAIN A -- "That depends on what you need assistance with."
--------------------------------------------------------------------------------

moral_exec_pitch_a = ConvoScreen:new {
	id = "pitch_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_63", -- Of course it does. We have a bit of a problem with some miners that are on strike...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_64", "plan_a"}, -- This should be good...
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_pitch_a)

moral_exec_plan_a = ConvoScreen:new {
	id = "plan_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_65", -- Oh, it will be. I need you to go in to their facility and destroy the power generator...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_66", "grant_a"},  -- Not bad, that might work. Where is their camp?
		{"@conversation/som_kenobi_moral_exec:s_68", "refuse_a"}, -- Might work but not something I'd do. Find someone else.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_plan_a)

-- GRANT.
moral_exec_grant_a = ConvoScreen:new {
	id = "grant_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_70", -- I knew you'd be the right one for the job. The facility is up in the northwest part of the continent...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_71", "resist_a"}, -- Sounds good. What kind of resistance can I expect?
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_grant_a)

moral_exec_resist_a = ConvoScreen:new {
	id = "resist_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_91", -- They are just miners. Shouldn't pose a problem for you at all. The leader of the strike is fairly clever though...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_resist_a)

moral_exec_refuse_a = ConvoScreen:new {
	id = "refuse_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_69", -- Fine, I will! And don't you go talking about this to anyone, if you want to ever leave this planet in one piece!
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_refuse_a)

--------------------------------------------------------------------------------
-- CHAIN B -- "Sure am. What did you have in mind?"
--------------------------------------------------------------------------------

moral_exec_pitch_b = ConvoScreen:new {
	id = "pitch_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_95", -- We have a bit of a problem with some miners that are on strike. We've tried reasoning with them, but they won't budge...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_99", "plan_b"}, -- Alright, what have you come up with?
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_pitch_b)

moral_exec_plan_b = ConvoScreen:new {
	id = "plan_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_103", -- We need you to go into their facility and destroy the power generator...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_116", "noother"},  -- Is there really no other way to solve the conflict?
		{"@conversation/som_kenobi_moral_exec:s_128", "grant_b"},  -- Alright, if there's no other way, I'll help you.
		{"@conversation/som_kenobi_moral_exec:s_136", "refuse_b"}, -- This whole thing sounds fishy. I don't want to do it.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_plan_b)

-- A detour, not a fork: it hands the same accept/refuse pair straight back.
moral_exec_noother = ConvoScreen:new {
	id = "noother",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_127", -- Oh believe me, friend, we've tried everything, but I don't think they are interested in a peaceful outcome at all...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_128", "grant_b"},  -- Alright, if there's no other way, I'll help you.
		{"@conversation/som_kenobi_moral_exec:s_136", "refuse_b"}, -- This whole thing sounds fishy. I don't want to do it.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_noother)

-- GRANT.
moral_exec_grant_b = ConvoScreen:new {
	id = "grant_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_130", -- Excellent. Their facility is up in the northwest part of the continent. Here, let me mark it down in your datapad...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_132", "walkin"}, -- And they will just let me walk in there?
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_grant_b)

moral_exec_walkin = ConvoScreen:new {
	id = "walkin",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_134", -- Yeah, they are only hostile towards us, it seems like. The leader of the strike is fairly clever, though...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_walkin)

moral_exec_refuse_b = ConvoScreen:new {
	id = "refuse_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_138", -- Bah! I will find someone else then. Now move along!
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_refuse_b)

--------------------------------------------------------------------------------
-- ON THE JOB
--------------------------------------------------------------------------------

moral_exec_progress = ConvoScreen:new {
	id = "progress",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_139", -- What are you doing back here already? Get out there and finish the job!
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_progress)

--------------------------------------------------------------------------------
-- THE RETURN -- written twice, the player's attitude picks the copy
--------------------------------------------------------------------------------

moral_exec_has_core = ConvoScreen:new {
	id = "has_core",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_140", -- There you are! Do you have the core?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_142", "peace"}, -- Yeah, I got it. I hope this will get a peaceful ending now.
		{"@conversation/som_kenobi_moral_exec:s_144", "style"}, -- Of course I do. They didn't know what hit them.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_has_core)

moral_exec_peace = ConvoScreen:new {
	id = "peace",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_145", -- Haha, don't you worry about that. This is most excellent. Those fools won't have any choice but to come crawling back now.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_146", "reward_a"}, -- That is...great, I guess.
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_peace)

-- REWARD.
moral_exec_reward_a = ConvoScreen:new {
	id = "reward_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_148", -- It sure is! Very well, friend, you deserve your reward. Not only will I pay you the sum of 20,000 credits...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_150", "holo_a"}, -- What would I do with that?
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_reward_a)

moral_exec_holo_a = ConvoScreen:new {
	id = "holo_a",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_152", -- You should put it in your home to commemorate this fantastic day, of course!...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_holo_a)

moral_exec_style = ConvoScreen:new {
	id = "style",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_156", -- Haha. Excellent! I like your style, my friend. This is splendid indeed...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_160", "reward_b"}, -- This is all very interesting, but there was talk of a reward?
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_style)

-- REWARD.
moral_exec_reward_b = ConvoScreen:new {
	id = "reward_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_162", -- Of course, of course. You are in for a treat, my friend. Not only will I pay you the sum of 20,000 credits...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_exec:s_165", "holo_b"}, -- What the heck would I do with a hologram of you?!
	}
}
som_kenobi_moral_exec:addScreen(moral_exec_reward_b)

moral_exec_holo_b = ConvoScreen:new {
	id = "holo_b",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_169", -- Now now, settle down there, buddy. You should put it in your home to commemorate this fantastic day, of course!...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_holo_b)

--------------------------------------------------------------------------------
-- AFTERWARDS
--------------------------------------------------------------------------------

moral_exec_epilogue = ConvoScreen:new {
	id = "epilogue",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_171", -- I don't believe we have anything more to say to each other now, do we?
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_epilogue)

moral_exec_betrayed = ConvoScreen:new {
	id = "betrayed",
	leftDialog = "@conversation/som_kenobi_moral_exec:s_45", -- You have ruined me! I thought I could trust you, you rotting mynock!
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_exec:addScreen(moral_exec_betrayed)

addConversationTemplate("som_kenobi_moral_exec", som_kenobi_moral_exec)

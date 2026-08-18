--[[
	Pwwoz Pwwa, Ithorian geologist -- som_kenobi_samaritan_1 and _2.

	RECONSTRUCTED, not ported. som_kenobi_pwwoz_pwwa.stf shipped in the client
	(string/en/conversation/), the SwgConversationEditor tree that wires those
	strings into screens did not. Every leftDialog and option string below is
	SOE's verbatim text; the edges between them are reconstructed.

	FOUR THINGS THE PLAYER CAN BE WHEN HE HAILS PWWOZ, and the table has a
	distinct opening line for each:

	  s_110  never spoken to him              -> the offer
	  s_172  quest running, no crystal yet    -> "What are you doing back here?!"
	  s_173  crystal in hand                  -> "You are back! Where is it?!"
	  s_225  kept the crystal                 -> "You better watch where you are
	                                             going, thief!"
	  s_226  gave it, then had to put him down -> the epilogue

	s_226 is why the .qst's killIthorian step does not end him for good: "Yes,
	I'm still alive, friend. The Mustafarians managed to save me despite the
	serious injuries." SOE wrote the aftermath, so he comes back.

	THE OFFER IS WRITTEN TWICE

	Exactly like the serpent thief's table, the pitch exists in two copies that
	partition on the player's first answer, and the second copy is numbered in
	odd steps -- which is what pins the split:

	  POLITE  s_111 "I have some time to spare."  -> s_115, then
	          s_116/s_117, s_118/s_119, s_120/s_121, and it ends on
	          s_124 (accept) or s_125 (refuse).

	  BLUNT   s_112 "How am I supposed to know?"  -> s_151 "Oh, let me get
	          right to the point", then s_153/s_155, s_157/s_159,
	          s_161/s_163, ending on s_167 (accept) or s_171 (refuse).

	s_117 and s_155 are the same paragraph, as are s_119/s_159 and
	s_121/s_163 -- one duplicate per beat, one beat per chain, and no line
	spans both.

	s_113 "I'm a bit busy at the moment" is answered by s_114 and is the only
	way out of the greeting that is neither chain.

	THE DECISION IS WRITTEN FOUR TIMES

	Coming back holding the crystal, the player picks one of four attitudes off
	s_173, and each gets its own NPC reply and its own [Use the Force] beat:

	  s_174 you seem obsessed  -> s_178, force option s_181 -> s_182
	  s_175 I couldn't find it -> s_187, force option s_193 -> s_195
	  s_176 what about the reward? -> s_205, force option s_208 -> s_209
	  s_177 I'm tired of this  -> s_212, force option s_218 -> s_220

	All four converge on the same two endings:

	  s_186  GIVE -- he smashes it, is taken over, and attacks
	  s_185  KEEP -- "I will get my revenge. Mark my words!"

	with one exception: s_195 is a keep ending in its own right, the only Force
	screen that finishes the conversation instead of handing back a choice.

	The four "[Use the Force]" option links (obsessed_force, lied_force,
	reward_force, tired_force) are stripped for anyone without the Jedi rank by
	pwwoz_pwwa_conv_handler, the same way cursed_shard_sucker_conv_handler does.
	Every screen that carries one also carries a plain give and a plain keep, so
	a non-Jedi is never cornered.

	s_2 is the empty string. s_82 ("You will not escape my wrath, %TU!"), s_84
	and s_85 are combat barks -- %TU is the spatial-chat token -- and none of
	them is a screen. All four are deliberately unused.
]]

som_kenobi_pwwoz_pwwa = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "pwwoz_pwwa_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- THE OFFER -- the opening, and the one way out of it
--------------------------------------------------------------------------------

pwwoz_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_110", -- Greetings, friend. I am Pwwoz Pwwa, geologist and ambassador for the Ithorian people on Mustafar...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_111", "polite"}, -- I have some time to spare. How may I assist?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_112", "blunt"},  -- How am I supposed to know? What is it you need help with?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_113", "busy"},   -- I'm a bit busy at the moment, sorry.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_greeting)

pwwoz_busy = ConvoScreen:new {
	id = "busy",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_114", -- Bah! What could be more...ex.. excuse me, where's my manners. Have a nice day.
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_busy)

--------------------------------------------------------------------------------
-- POLITE CHAIN
--------------------------------------------------------------------------------

pwwoz_polite = ConvoScreen:new {
	id = "polite",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_115", -- Good, good. My predicament is this. About a week ago...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_116", "fleas_a"}, -- You think the lava fleas took it? Sounds unlikely...
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_polite)

pwwoz_fleas_a = ConvoScreen:new {
	id = "fleas_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_117", -- The only explanation I can think of is that one of them swallowed it...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_118", "what_a"}, -- Perhaps. What is the trinket? What does it look like?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_fleas_a)

pwwoz_what_a = ConvoScreen:new {
	id = "what_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_119", -- Oh, it's just a small red crystal.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_120", "trouble_a"}, -- And you're going through all this trouble for a piece of crystal?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_what_a)

pwwoz_trouble_a = ConvoScreen:new {
	id = "trouble_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_121", -- It is very dear to me... I will pay a reward...everything I have!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_122", "directions_a"}, -- Calm down, I'll do it. Where did you lose it?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_123", "refuse_a"},     -- Settle down, friend. I'm afraid I can't right now.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_trouble_a)

-- GRANT.
pwwoz_directions_a = ConvoScreen:new {
	id = "directions_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_124", -- Thank you, thank you! Let me mark down the location in your datapad. There, now please hurry!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_directions_a)

pwwoz_refuse_a = ConvoScreen:new {
	id = "refuse_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_125", -- But you must! I need it back. Don't you understand?! Come back here! You will do this for me!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_refuse_a)

--------------------------------------------------------------------------------
-- BLUNT CHAIN -- the same pitch, odd-numbered
--------------------------------------------------------------------------------

pwwoz_blunt = ConvoScreen:new {
	id = "blunt",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_151", -- Oh, let me get right to the point. About a week ago...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_153", "fleas_b"}, -- You're not going to tell me the fleas took it?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_blunt)

pwwoz_fleas_b = ConvoScreen:new {
	id = "fleas_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_155", -- The only explanation I can think of is that one of them swallowed it...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_157", "what_b"}, -- Oh, I can guarantee that. Now what is this thing I need to find?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_fleas_b)

pwwoz_what_b = ConvoScreen:new {
	id = "what_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_159", -- Oh, it's just a small red crystal.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_161", "trouble_b"}, -- What? Crystals are everywhere. Just go buy one from a Mustafarian!
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_what_b)

pwwoz_trouble_b = ConvoScreen:new {
	id = "trouble_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_163", -- No, it has to be this one! It is very dear to me...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_165", "directions_b"}, -- Gee, calm down. I'll do it! Where did you lose it?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_169", "refuse_b"},     -- I don't have time for this nonsense!
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_trouble_b)

-- GRANT.
pwwoz_directions_b = ConvoScreen:new {
	id = "directions_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_167", -- Thank you, thank you! Let me mark down the location in your datapad. There, now please hurry!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_directions_b)

pwwoz_refuse_b = ConvoScreen:new {
	id = "refuse_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_171", -- But you must! I need it back. Don't you understand?! Come back here! You will do this for me!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_refuse_b)

--------------------------------------------------------------------------------
-- MID-QUEST, EMPTY-HANDED
--------------------------------------------------------------------------------

pwwoz_progress = ConvoScreen:new {
	id = "progress",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_172", -- What are you doing back here?! You need to find that crystal. Now!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_progress)

--------------------------------------------------------------------------------
-- THE DECISION -- back with the crystal
--------------------------------------------------------------------------------

pwwoz_has_crystal = ConvoScreen:new {
	id = "has_crystal",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_173", -- You are back! Where is it?! Give it to me!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_174", "obsessed"},     -- You seem a little obsessed. Are you sure it's healthy for you?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_175", "lied"},         -- I'm sorry, friend. I couldn't find it. Maybe it's for the best...
		{"@conversation/som_kenobi_pwwoz_pwwa:s_176", "reward_asked"}, -- Yeah, yeah. Calm down! There was talk of a reward?
		{"@conversation/som_kenobi_pwwoz_pwwa:s_177", "tired"},        -- I didn't find the darn thing and I'm tired of this.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_has_crystal)

-- 1 of 4: you seem obsessed
pwwoz_obsessed = ConvoScreen:new {
	id = "obsessed",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_178", -- You just want it for yourself! Now give it to me. Don't you want that reward?!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_179", "give"},           -- Fine, as you wish. Here you go.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_180", "keep"},           -- No, I'm sorry. I can't have that on my conscience.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_181", "obsessed_force"}, -- [Use the Force] You don't really want it. I should keep it.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_obsessed)

pwwoz_obsessed_force = ConvoScreen:new {
	id = "obsessed_force",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_182", -- I... I don't really want...yes, yes I do! What are you doing to me?! Hand me the crystal. Now!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_183", "give"}, -- Fine, as you wish. Here you go.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_184", "keep"}, -- No, I'm sorry. I can't have that on my conscience.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_obsessed_force)

-- 2 of 4: I couldn't find it
pwwoz_lied = ConvoScreen:new {
	id = "lied",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_187", -- What?! I know you have it! You're lying to me and want to keep it yourself! Give it to me now!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_189", "give"},       -- Fine, as you wish. Here you go.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_191", "keep"},       -- As I said, I don't have it. I'm sorry, Pwwoz.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_193", "lied_force"}, -- [Use the Force] I don't have it. You should give up now.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_lied)

-- KEEP, and the only Force screen that ends the conversation itself.
pwwoz_lied_force = ConvoScreen:new {
	id = "lied_force",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_195", -- You don't ha...have it... No! I know you do!... I will have my revenge. Mark my words!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_lied_force)

-- 3 of 4: what about the reward?
pwwoz_reward_asked = ConvoScreen:new {
	id = "reward_asked",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_205", -- Yes, of course! But first, the crystal. Now!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_206", "give"},         -- Fine, but you better have my reward ready!
		{"@conversation/som_kenobi_pwwoz_pwwa:s_207", "keep"},         -- I don't think there's a reward at all. I will just keep this.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_208", "reward_force"}, -- [Use the Force] You should show me the reward first.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_reward_asked)

pwwoz_reward_force = ConvoScreen:new {
	id = "reward_force",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_209", -- I... I should show...no, there is no reward, you fool! Just give me the blasted thing!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_210", "keep"}, -- As I thought: no reward, no crystal. I'm keeping it.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_211", "give"}, -- Yeah, whatever. I don't want it anyway.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_reward_force)

-- 4 of 4: I'm tired of this
pwwoz_tired = ConvoScreen:new {
	id = "tired",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_212", -- What?! I know you're lying. You have it on you. I can feel it! Now give it to me!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_214", "give"},        -- Fine, but you better have my reward ready!
		{"@conversation/som_kenobi_pwwoz_pwwa:s_216", "keep"},        -- I don't think there's a reward at all. I will just keep this.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_218", "tired_force"}, -- [Use the Force] You should show me the reward first.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_tired)

pwwoz_tired_force = ConvoScreen:new {
	id = "tired_force",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_220", -- I... I should show...no, there is no reward, you fool! Just give me the blasted thing!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_222", "keep"}, -- As I thought: no reward, no crystal. I'm keeping it.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_224", "give"}, -- Yeah, whatever. I don't want it anyway.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_tired_force)

--------------------------------------------------------------------------------
-- THE TWO ENDINGS
--------------------------------------------------------------------------------

-- GIVE: .qst signal giveCrystal. He smashes it and comes for the player.
pwwoz_give = ConvoScreen:new {
	id = "give",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_186", -- Yes, yes! Finally it's mine!... kneel and accept your reward!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_give)

-- KEEP: .qst signal keepCrystal. The revenge is som_kenobi_samaritan_2.
pwwoz_keep = ConvoScreen:new {
	id = "keep",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_185", -- You, you bastard! It's that ghost telling you to give it to him instead, isn't it?! I will get my revenge. Mark my words!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_keep)

--------------------------------------------------------------------------------
-- AFTERWARDS
--------------------------------------------------------------------------------

-- The player kept it and the thugs have been or are being sent.
pwwoz_grudge = ConvoScreen:new {
	id = "grudge",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_225", -- You! You better watch where you are going, thief! One day, when you least expect it, I will get my crystal back!
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_grudge)

-- The player gave it and had to put him down. He lived.
pwwoz_epilogue = ConvoScreen:new {
	id = "epilogue",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_226", -- Yes, I'm still alive, friend. The Mustafarians managed to save me despite the serious injuries...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_227", "sorry"},  -- I'm glad you are okay, Pwwoz, and I'm sorry for what I had to do.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_228", "sloppy"}, -- I must be getting sloppy...thought you were dead for sure.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_epilogue)

pwwoz_sorry = ConvoScreen:new {
	id = "sorry",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_229", -- As I said, you did what you had to do, my friend. No worries at all.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_230", "farewell_a"}, -- Thank you and take care of yourself, Pwwoz.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_231", "ghost_a"},    -- Last I saw you, you kept talking about some ghost?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_sorry)

pwwoz_farewell_a = ConvoScreen:new {
	id = "farewell_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_236", -- You too, my friend. Be careful out there.
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_farewell_a)

-- The one line in this table that points at the rest of the arc: the old human
-- spirit who told him to throw the crystal into the lava.
pwwoz_ghost_a = ConvoScreen:new {
	id = "ghost_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_232", -- Yes, I have a vague memory of that... He urged me to throw the crystal into the lava...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_233", "farewell_ghost_a"}, -- Very interesting. Well, take care of yourself, Pwwoz.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_ghost_a)

pwwoz_farewell_ghost_a = ConvoScreen:new {
	id = "farewell_ghost_a",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_234", -- You too, my friend. Be careful out there.
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_farewell_ghost_a)

pwwoz_sloppy = ConvoScreen:new {
	id = "sloppy",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_237", -- Yes, well, lucky for me. I'm tougher than I look.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_238", "farewell_b"}, -- Yes, lucky indeed. Well, stay out of trouble.
		{"@conversation/som_kenobi_pwwoz_pwwa:s_239", "ghost_b"},    -- What was that ghost thing you kept talking about, by the way?
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_sloppy)

pwwoz_farewell_b = ConvoScreen:new {
	id = "farewell_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_240", -- You too, friend. Be careful out there.
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_farewell_b)

pwwoz_ghost_b = ConvoScreen:new {
	id = "ghost_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_242", -- Hmm, oh yes, I remember that vaguely... He urged me to throw the crystal into the lava...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_pwwoz_pwwa:s_244", "farewell_ghost_b"}, -- Strange. Well, stay out of trouble.
	}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_ghost_b)

pwwoz_farewell_ghost_b = ConvoScreen:new {
	id = "farewell_ghost_b",
	leftDialog = "@conversation/som_kenobi_pwwoz_pwwa:s_246", -- You too, friend. Be careful out there.
	stopConversation = "true",
	options = {}
}
som_kenobi_pwwoz_pwwa:addScreen(pwwoz_farewell_ghost_b)

addConversationTemplate("som_kenobi_pwwoz_pwwa", som_kenobi_pwwoz_pwwa)

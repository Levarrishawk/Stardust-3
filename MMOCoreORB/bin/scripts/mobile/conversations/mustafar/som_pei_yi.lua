--[[
	Pei Yi -- the stranded dancer in the Mensix cantina.

	Every line below is an existing @conversation/som_pei_yi entry, so this works against a
	stock client with no new strings. The tree was reconstructed from the shipped string table
	(string/en/conversation/som_pei_yi.stf, mtg_patch_019.tre); SOE kept the conversation trees
	themselves server-side, so only the strings survive in the TREs.

	The live tree has since been read, and the reconstruction holds screen for screen except
	for two options; both are corrected below.

	The renumbering in the middle of the table (s_15..s_41 and s_54..s_88 are odd-only, while
	s_42..s_53 run consecutively) marks the return-visit branch as a later addition, which is
	why it is a separate greeting here rather than a screen hanging off the first one. Live
	agrees -- s_42 is its own start-chain entry, gated on hasDance.

	THE TWO MISPLACED EXITS

	s_25 "Probably not. Good bye." was on s_23; live branch 8 puts it on s_19, beside s_21.
	s_50 "Oh, sorry. I've got to go." was on the s_42 greeting; live branch 2 puts it on s_47,
	beside s_48 and s_49. Live's greeting offers only s_44 and s_45.

	ROOT CAUSE: pairing each exit line with the NPC line it reads best against instead of with
	the screen that offers it. This file used to argue the point outright -- 's_25 "Probably
	not. Good bye." only makes sense after s_23 "...a troupe that you've probably never heard
	of"'. It reads well there, and it is not where SOE put it. An exit option sits on the
	screen the player is leaving, and that screen need not have set it up.

	THE DANCE  --  live grants it; we cannot

	Live does hand over a real command:

	    action_grantDance -> sendSystemMessage(player, "som/som_quest:grant_dance")
	                         grantCommand(player, "startDance+peiyi")

	This file used to say the lesson was "a conversation, not an ability grant" and that "there
	is no dance here to grant". The first half is wrong about SOE and the second half is right
	about the data, and they are two different claims.

	What is still true: datatables/performance/performance.iff has no peiyi row, and
	datatables/skill/skills.iff lists no startDance+peiyi. The pei yi animations do ship
	(appearance/animation/all_b_dnc_pei_yi_*.ans, mtg_patch_001_appearance_01.tre) with nothing
	pointing at them. Core3 drives dances off performance.iff, so granting the command here
	would hand the player a startDance that resolves to no row.

	So the grant is not made, and the handler keeps its own flag where live tests
	hasCommand("startDance+peiyi"). That is a deviation, and it is one because the row the
	command needs is missing from the client this server runs against -- not because SOE never
	wrote a grant.

	ROOT CAUSE: searching for the dance where a player-learnable dance would live -- a
	performance row and a skills.iff ability -- and reading its absence as SOE's intent. A
	grantCommand needs neither, so absence from those two tables says nothing about whether a
	grant was written. Only the conversation says that, and the conversation had not been read.

	THE GATE  --  isEntertainer, not social_dancer_novice

	Live gates both the "I'm a dancer myself" option (branch 13) and the grant itself
	(branch 15) on one condition:

	    condition_isEntertainer -> utils.isProfession(player, utils.ENTERTAINER) && level >= 46

	It also defines condition_isDancer -> hasSkill(player, "social_dancer_novice") and never
	calls it. That dead condition is exactly the skill this file used to gate on.
--]]

som_pei_yi = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "pei_yi_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- First meeting
--------------------------------------------------------------------------------

pei_yi_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_pei_yi:s_15", -- Hello, it's nice to see a friendly face on such a violent planet.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_17", "not_a_miner"},  -- You don't look much like a miner.
		{"@conversation/som_pei_yi:s_29", "who_are_you"},  -- Who are you?
		{"@conversation/som_pei_yi:s_86", "bye_nice"},     -- It's nice to meet you. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_greeting)

pei_yi_not_a_miner = ConvoScreen:new {
	id = "not_a_miner",
	leftDialog = "@conversation/som_pei_yi:s_19", -- Oh no? I wouldn't imagine so. I don't know the first thing about mining. My area of expertise is dancing, actually.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_21", "a_dancer"},  -- You're a dancer?
		-- Live branch 8 -- the options on s_19 are s_21 and s_25. This was one
		-- screen deeper, on s_23; see THE TWO MISPLACED EXITS.
		{"@conversation/som_pei_yi:s_25", "bye_probably"},  -- Probably not. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_not_a_miner)

pei_yi_a_dancer = ConvoScreen:new {
	id = "a_dancer",
	leftDialog = "@conversation/som_pei_yi:s_23", -- That's right. My name is Pei Yi. I dance for a small troupe that you've probably never heard of.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_33", "why_here"},      -- What brings you here?
	}
}
som_pei_yi:addScreen(pei_yi_a_dancer)

pei_yi_who_are_you = ConvoScreen:new {
	id = "who_are_you",
	leftDialog = "@conversation/som_pei_yi:s_31", -- My name is Pei Yi. I'm a dancer in a small dance troupe that you've probably never heard of.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_33", "why_here"},       -- What brings you here?
		{"@conversation/som_pei_yi:s_82", "bye_probably2"},  -- Probably not. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_who_are_you)

pei_yi_why_here = ConvoScreen:new {
	id = "why_here",
	leftDialog = "@conversation/som_pei_yi:s_35", -- I was to meet up with the rest of my troupe on Naboo for a very prestigious show. I bought passage on Captain Stahn's ship, but the engine fell apart or something and we were forced to make a detour here for supplies and repairs.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_37", "how_long"},     -- How long will the repairs take?
		{"@conversation/som_pei_yi:s_78", "bye_too_bad2"}, -- That's too bad. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_why_here)

pei_yi_how_long = ConvoScreen:new {
	id = "how_long",
	leftDialog = "@conversation/som_pei_yi:s_39", -- It seems like we've been here ages already, and Captain Stahn still doesn't have a good idea when the ship will be ready. I should be grateful, I suppose. We might not have even made it here at all.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_41", "miss_show"},  -- Are you going to miss your performance on Naboo?
		{"@conversation/som_pei_yi:s_74", "bye_true"},   -- That's true. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_how_long)

pei_yi_miss_show = ConvoScreen:new {
	id = "miss_show",
	leftDialog = "@conversation/som_pei_yi:s_54", -- I'm afraid so. Even if we left right now, I don't see any way that I could make it there in time. It's a shame, too. I designed a new dance especially for this performance. But...the show must go on.
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_56", "offer_lesson"},  -- I'm sorry to hear that. I'm a dancer myself.
		{"@conversation/som_pei_yi:s_70", "bye_too_bad"},   -- That's too bad. Good bye.
	}
}
som_pei_yi:addScreen(pei_yi_miss_show)

pei_yi_offer_lesson = ConvoScreen:new {
	id = "offer_lesson",
	leftDialog = "@conversation/som_pei_yi:s_58", -- Oh, really? Then you understand my disappointment. It really was a very impressive dance. Say...if you have a moment, perhaps I could teach it to you! If you show it to your friends, maybe you could tell me if they like it or not.
	stopConversation = "false",
	-- Both options are added by the handler so that s_60 ("That would be great!") can point at
	-- taught or too_unskilled according to the player's dancing skill, in the order SOE listed
	-- them.
	options = {}
}
som_pei_yi:addScreen(pei_yi_offer_lesson)

pei_yi_taught = ConvoScreen:new {
	id = "taught",
	leftDialog = "@conversation/som_pei_yi:s_62", -- Then let the lessons commence! And be sure to tell me what your friends think after you show them!
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_taught)

pei_yi_too_unskilled = ConvoScreen:new {
	id = "too_unskilled",
	leftDialog = "@conversation/som_pei_yi:s_64", -- Hmm... I can tell that you're eager to learn, but you're just not skilled enough yet. It's a pretty complex routine. I should have warned you. Perhaps if you came back after getting a little more practice.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_too_unskilled)

--------------------------------------------------------------------------------
-- Return visit, once she has taught the dance
--------------------------------------------------------------------------------

pei_yi_greeting_taught = ConvoScreen:new {
	id = "greeting_taught",
	leftDialog = "@conversation/som_pei_yi:s_42", -- Hello! It's good to see you again! Have you shown anyone the dance I taught you?
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_44", "shown_yes"},  -- Yes, I did.
		{"@conversation/som_pei_yi:s_45", "shown_no"},   -- No, not yet.
	}
}
som_pei_yi:addScreen(pei_yi_greeting_taught)

pei_yi_shown_no = ConvoScreen:new {
	id = "shown_no",
	leftDialog = "@conversation/som_pei_yi:s_46", -- When you do, be sure to tell me what they think of it.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_shown_no)

pei_yi_shown_yes = ConvoScreen:new {
	id = "shown_yes",
	leftDialog = "@conversation/som_pei_yi:s_47", -- And? What did they think?
	stopConversation = "false",
	options = {
		{"@conversation/som_pei_yi:s_48", "they_liked"},     -- They liked it.
		{"@conversation/som_pei_yi:s_49", "they_disliked"},  -- They did not like it.
		-- Live branch 2 -- the options on s_47 are s_48, s_49 and s_50. This was
		-- one screen shallower, on the s_42 greeting.
		{"@conversation/som_pei_yi:s_50", "bye_got_go"},     -- Oh, sorry. I've got to go.
	}
}
som_pei_yi:addScreen(pei_yi_shown_yes)

pei_yi_they_liked = ConvoScreen:new {
	id = "they_liked",
	leftDialog = "@conversation/som_pei_yi:s_53", -- Oh, I'm glad to hear it! Thank you so much for telling me.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_they_liked)

pei_yi_they_disliked = ConvoScreen:new {
	id = "they_disliked",
	leftDialog = "@conversation/som_pei_yi:s_52", -- Oh, that's too bad. I tried so hard to come up with something everyone would like. Thank you for being honest though.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_they_disliked)

pei_yi_bye_got_go = ConvoScreen:new {
	id = "bye_got_go",
	leftDialog = "@conversation/som_pei_yi:s_51", -- Oh, alright. Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_got_go)

--------------------------------------------------------------------------------
-- Farewells. Each one is the reply SOE paired with its own player line.
--------------------------------------------------------------------------------

pei_yi_bye_probably = ConvoScreen:new {
	id = "bye_probably",
	leftDialog = "@conversation/som_pei_yi:s_27", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_probably)

pei_yi_bye_another = ConvoScreen:new {
	id = "bye_another",
	leftDialog = "@conversation/som_pei_yi:s_68", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_another)

pei_yi_bye_too_bad = ConvoScreen:new {
	id = "bye_too_bad",
	leftDialog = "@conversation/som_pei_yi:s_72", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_too_bad)

pei_yi_bye_true = ConvoScreen:new {
	id = "bye_true",
	leftDialog = "@conversation/som_pei_yi:s_76", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_true)

pei_yi_bye_too_bad2 = ConvoScreen:new {
	id = "bye_too_bad2",
	leftDialog = "@conversation/som_pei_yi:s_80", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_too_bad2)

pei_yi_bye_probably2 = ConvoScreen:new {
	id = "bye_probably2",
	leftDialog = "@conversation/som_pei_yi:s_84", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_probably2)

pei_yi_bye_nice = ConvoScreen:new {
	id = "bye_nice",
	leftDialog = "@conversation/som_pei_yi:s_88", -- Good bye.
	stopConversation = "true",
	options = {}
}
som_pei_yi:addScreen(pei_yi_bye_nice)

addConversationTemplate("som_pei_yi", som_pei_yi)

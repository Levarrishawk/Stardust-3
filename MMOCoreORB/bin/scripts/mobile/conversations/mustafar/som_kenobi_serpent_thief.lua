--[[
	The Dark Jedi Thief who took Ikt's shard -- the "Stakeout" beat of
	som_kenobi_serpent_shard_1.

	RECONSTRUCTED, not ported. som_kenobi_serpent_thief.stf shipped in the client
	(string/en/conversation/), the SwgConversationEditor tree that wires those
	strings into screens did not. Every leftDialog and option string below is
	SOE's verbatim text; the edges between them are reconstructed.

	The table is one encounter written twice over -- she flirts, the player says
	what he is looking for, she claims to have seen it, admits it is in her
	pocket, and it comes to blows. The two copies partition on the very first
	answer the player gives her:

	  CHAIN B  the player is vague -- s_63 "I'm out looking for something a
	           friend lost." Her line is s_64 "...I've been here for a while.
	           If you tell me what it is, maybe I've seen it?" The suspicion
	           beat is s_116 ("You can't trust little old me?"), the reveal is
	           s_71 ("...it was in my pocket."), and it ends on s_91/s_93.

	  CHAIN A  the player is blunt -- s_120 "Fine! I'm here looking for a
	           thief." Her line is s_121 "Oh my. What did they take?" The
	           suspicion beat is s_135 ("Me? Now you're being silly."), the
	           reveal is s_126 ("...it was in my pocket."), and it ends on
	           s_127/s_128.

	s_116/s_135, s_71/s_126 and s_69/s_124 are the three duplicate pairs, one
	per chain, and no line spans both -- that is what pins the split. The two
	chains hang off her two replies to the same player option s_112 ("What am I
	doing out here?! What about yourself?"): s_61 "True...but I do believe I
	asked first" after the s_43 flirt, and s_62 "No fair. I asked first"
	without it.

	FOUR WAYS INTO THE FIGHT

	  s_101  she drops the act and claims the ground (chain B, plain)
	  s_99   she answers a Force push (chain B)
	  s_115  "We shall see how action works then!" (chain A, plain)
	  s_133  she answers a Force push (chain A)

	All four stop the conversation and are the handler's fight hooks -- see
	serpent_thief_conv_handler. s_97 and s_131 are the two [Use the Force]
	options; the handler strips them for anyone without the Jedi rank, the same
	way cursed_shard_sucker_conv_handler does.

	s_2 is the empty string and is deliberately unused.
]]

som_kenobi_serpent_thief = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "serpent_thief_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- OPENING -- shared by both chains
--------------------------------------------------------------------------------

serpent_thief_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_110", -- Well, hello there, sweetie. What are you doing all the way out here?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_111", "coy"},           -- I could say the same to you, M'Lady...
		{"@conversation/som_kenobi_serpent_thief:s_112", "asked_first_b"}, -- What am I doing out here?! What about yourself?
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_greeting)

serpent_thief_coy = ConvoScreen:new {
	id = "coy",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_43", -- You're a cute one, maybe too cute...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_112", "asked_first_a"}, -- What am I doing out here?! What about yourself?
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_coy)

serpent_thief_asked_first_a = ConvoScreen:new {
	id = "asked_first_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_61", -- True...but I do believe I asked first.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_63", "seen_it"}, -- I guess so. I'm out looking for something a friend lost.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_asked_first_a)

serpent_thief_asked_first_b = ConvoScreen:new {
	id = "asked_first_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_62", -- No fair. I asked first.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_120", "what_taken"}, -- Fine! I'm here looking for a thief.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_asked_first_b)

--------------------------------------------------------------------------------
-- CHAIN B -- "something a friend lost"
--------------------------------------------------------------------------------

serpent_thief_seen_it = ConvoScreen:new {
	id = "seen_it",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_64", -- Oh really? Well, I've been here for a while. If you tell me what it is, maybe I've seen it?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_68", "seen_that"}, -- It was a small crystal shard with a flaw of a snake on it.
		{"@conversation/som_kenobi_serpent_thief:s_66", "trust_b"},   -- Well, it was stolen from him, so I'm not sure I can trust you.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_seen_it)

serpent_thief_trust_b = ConvoScreen:new {
	id = "trust_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_116", -- You can't trust little old me? Have you had any luck so far? I might be your best bet, sweetie.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_117", "specific"}, -- I suppose you are right. It's a little crystal shard.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_trust_b)

serpent_thief_specific = ConvoScreen:new {
	id = "specific",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_118", -- You may have to be a bit more specific.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_119", "seen_that"}, -- Yes, of course. It has a small flaw on it -- the shape of a snake.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_specific)

serpent_thief_seen_that = ConvoScreen:new {
	id = "seen_that",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_69", -- Oh really? Yeah, I've seen that.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_70", "pocket_b"}, -- Where did you see it?
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_seen_that)

serpent_thief_pocket_b = ConvoScreen:new {
	id = "pocket_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_71", -- Let me think, sweetie... Oh yeah, the last time I saw it, it was in my pocket.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_91", "refuse_b"}, -- I thought so. If you give it back, I'll forget this ever happened.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_pocket_b)

-- s_97 is a [Use the Force] option and is stripped for non-Jedi; see the handler.
serpent_thief_refuse_b = ConvoScreen:new {
	id = "refuse_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_93", -- I'm afraid I can't do that, cutie.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_95", "fight_b"},       -- Why not? Don't make this any harder than it needs to be.
		{"@conversation/som_kenobi_serpent_thief:s_97", "fight_b_force"}, -- [Use the Force] You will give it to me.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_refuse_b)

-- Fight hook; see the handler.
serpent_thief_fight_b = ConvoScreen:new {
	id = "fight_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_101", -- Because I need it, sweetie. I'm also afraid that I can't let you leave now...
	stopConversation = "true",
	options = {}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_fight_b)

-- Fight hook; see the handler.
serpent_thief_fight_b_force = ConvoScreen:new {
	id = "fight_b_force",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_99", -- You think you have power?! I will show you power, you feeble fool!
	stopConversation = "true",
	options = {}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_fight_b_force)

--------------------------------------------------------------------------------
-- CHAIN A -- "I'm here looking for a thief"
--------------------------------------------------------------------------------

serpent_thief_what_taken = ConvoScreen:new {
	id = "what_taken",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_121", -- Oh my. What did they take?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_122", "seen_that_a"}, -- A small crystal shard with a little serpent on it.
		{"@conversation/som_kenobi_serpent_thief:s_123", "trust_a"},     -- How do I know you're not the thief?
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_what_taken)

serpent_thief_trust_a = ConvoScreen:new {
	id = "trust_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_135", -- Me? Now you're being silly. Listen, how much luck have you had so far? I might be your best lead.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_136", "seen_that_a"}, -- I suppose. It's a small crystal with a serpent on it.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_trust_a)

serpent_thief_seen_that_a = ConvoScreen:new {
	id = "seen_that_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_124", -- Really? I've seen that!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_125", "pocket_a"}, -- Where?!
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_seen_that_a)

serpent_thief_pocket_a = ConvoScreen:new {
	id = "pocket_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_126", -- Let me see...that's right, the last time I saw it it was in my pocket.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_127", "refuse_a"}, -- As I suspected. Well you have only one choice, give it to me.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_pocket_a)

-- s_131 is a [Use the Force] option and is stripped for non-Jedi; see the handler.
serpent_thief_refuse_a = ConvoScreen:new {
	id = "refuse_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_128", -- Oh no, I couldn't do that, sweetie.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_129", "wrong_a"},       -- If you don't give it up right now, I'm forced to hurt you.
		{"@conversation/som_kenobi_serpent_thief:s_131", "fight_a_force"}, -- [Use the Force] You will give it to me.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_refuse_a)

serpent_thief_wrong_a = ConvoScreen:new {
	id = "wrong_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_134", -- No no, you got it all wrong. Since you've come here, I can't let you leave and I will most definitely hurt you.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_103", "fight_a"}, -- Threats will get you nowhere.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_wrong_a)

-- Fight hook; see the handler.
serpent_thief_fight_a = ConvoScreen:new {
	id = "fight_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_115", -- Very well. We shall see how action works then!
	stopConversation = "true",
	options = {}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_fight_a)

-- Fight hook; see the handler.
serpent_thief_fight_a_force = ConvoScreen:new {
	id = "fight_a_force",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_133", -- You think you have power?! I will show you power, you feeble fool!
	stopConversation = "true",
	options = {}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_fight_a_force)

addConversationTemplate("som_kenobi_serpent_thief", som_kenobi_serpent_thief)

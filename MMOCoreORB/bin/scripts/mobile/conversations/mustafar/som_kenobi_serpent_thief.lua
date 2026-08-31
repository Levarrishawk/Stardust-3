--[[
	The Dark Jedi Thief who took Ikt's shard -- the "Stakeout" beat of
	som_kenobi_serpent_shard_1.

	THIS TREE IS NO LONGER A RECONSTRUCTION

	It is now read off Mustafar's server-side som_kenobi_serpent_thief conversation, which
	names the same conversation id this file is named for. The client string table settles
	the wording; the server conversation settles the edges.

	The two-chain reading was right and the strings were right. Four things about the SHAPE
	were wrong, and each has the same root cause: the earlier revision inferred edges from
	which strings read like replies to which, and that inference is unfalsifiable from a
	string table alone.

	  1. s_43 IS NOT A SCREEN IN THE TREE. "You're a cute one, maybe too cute..." is what
	     she says to a player who is NOT on the quest -- live chats it at him with a
	     laugh_titter and never opens a conversation window at all. The earlier revision
	     made it a screen called "coy", hung it off the flirt, and routed the whole of
	     chain B through it. The gate that decides it now lives in
	     serpent_thief_conv_handler.

	     It is still ONE screen here -- "brush_off", the last one in this file -- and that
	     is a Core3 deviation, not a live screen. Core3 has already opened the conversation
	     window by the time getInitialScreen runs, and returning nil from there drops the
	     session with forceClose=false, which leaves the client sitting on an empty window.
	     So the brush-off is a one-line terminal screen: same words, same animation, one
	     extra click to dismiss. It is unreachable from any option in this tree.

	  2. THE CHAINS SPLIT ON THE GREETING, not one option later. Live's two openings are
	     the greeting's own two options:

	         s_111  "I could say the same to you, M'Lady..."  -> s_61  -> CHAIN B
	         s_112  "What am I doing out here?! ..."          -> s_62  -> CHAIN A

	     The earlier revision had s_112 appear twice -- once off the greeting and once off
	     the invented "coy" screen -- so that both of her replies hung off the same player
	     line. They do not. The flirt gets "True...but I do believe I asked first"; the
	     blunt answer gets "No fair. I asked first". Reading the two lines next to their
	     real prompts is the tell the string table could not give.

	  3. s_101 IS NOT AN ENDING. "Because I need it, sweetie... this will have to be your
	     burial ground" is the second-to-last screen of chain B: it offers s_103 "Threats
	     will get you nowhere", and s_115 is what she answers that with. So chain B's plain
	     ending is s_115, not s_101. The earlier revision cut chain B one screen short and,
	     having spent s_115, moved s_103/s_115 into chain A to fill the hole.

	  4. s_134 IS AN ENDING. Live: s_129 "If you don't give it up right now" -> s_134 "No
	     no, you got it all wrong... I will most definitely hurt you", and the fight starts
	     there. The earlier revision made s_134 a middle screen leading to the borrowed
	     s_103/s_115 pair.

	  3 and 4 are one mistake, not two: s_103 and s_115 belong to CHAIN B and were moved to
	  CHAIN A. Chain A's tail is one screen shorter than chain B's, and the numbering
	  heuristic had no way to see that.

	THE FOUR ENDINGS

	    s_115  "We shall see how action works then!"      chain B, plain
	    s_99   she answers a Force push                   chain B
	    s_134  "you got it all wrong"                     chain A, plain
	    s_133  she answers a Force push                   chain A

	All four stop the conversation and all four fire live's action_talked AND action_attack
	together -- see serpent_thief_conv_handler. s_97 and s_131 are the two [Use the Force]
	options, one per chain; the handler strips them for a player who is not force sensitive.

	s_2 is the empty string and is deliberately unused -- checked against the live
	conversation, which never references it either.

	THE COUNTS RECONCILE

	Live uses 19 distinct NPC lines as conversation screens and 18 player responses laid
	out as 20 option edges. This file is 20 screens and 20 options:

	    19 live screens  + 1  brush_off, the Core3 deviation in note 1 above  = 20

	The 19 are one for one with live -- no line is reused as two screens here, and no
	screen is reached by two different lines except seen_that (s_69) and seen_that_a
	(s_124), which live also reaches twice, from the direct answer and from the suspicion
	detour. brush_off has no incoming option at all; only getInitialScreen names it.

	Checked with /c/tmp/serpent-thief-check.lua, which loads this file and the handler
	against a stubbed conversation API and asserts every edge, every option ORDER, every
	terminal flag, that the only unreachable screen is brush_off, and that every
	edgeAnimations key names a real edge.
]]

som_kenobi_serpent_thief = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "serpent_thief_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- OPENING -- the greeting's two options are the two chains
--------------------------------------------------------------------------------

-- NO GESTURE HERE, AND THAT IS DELIBERATE. Live's curtsey is played by
-- serpent_thief_conv_handler:getInitialScreen, next to the condition that picks
-- this screen over brush_off, so that the gesture and the choice cannot drift
-- apart. Same for brush_off's laugh_titter.
--
-- WITHDRAWN. An "animation = curtsey" line sat here, added with the note that
-- "a GREETING has no inbound edge, so its gesture can only be a screen field --
-- these two were missed". Both halves were wrong. A greeting's gesture can also
-- be played from getInitialScreen, which is what four other handlers in this
-- directory do; and it was not missed, it was already being played there. The
-- line made the curtsey fire TWICE.
--
-- ROOT CAUSE: the animation checker only read screen fields, so a gesture in
-- getInitialScreen looked like a gesture that was not there at all. I trusted
-- the tool's silence over the handler I could have read, and "fixed" a file that
-- was already correct. The checker now reads getInitialScreen too.
serpent_thief_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_110", -- Well, hello there, sweetie. What are you doing all the way out here?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_111", "asked_first"}, -- I could say the same to you, M'Lady...
		{"@conversation/som_kenobi_serpent_thief:s_112", "no_fair"},     -- What am I doing out here?! What about yourself?
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_greeting)

-- Her answer to the flirt. Opens chain B.
serpent_thief_asked_first = ConvoScreen:new {
	id = "asked_first",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_61", -- True...but I do believe I asked first.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_63", "seen_it"}, -- I guess so. I'm out looking for something a friend lost.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_asked_first)

-- Her answer to the blunt reply. Opens chain A.
serpent_thief_no_fair = ConvoScreen:new {
	id = "no_fair",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_62", -- No fair. I asked first.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_120", "what_taken"}, -- Fine! I'm here looking for a thief.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_no_fair)

--------------------------------------------------------------------------------
-- CHAIN B -- "something a friend lost"
--------------------------------------------------------------------------------

-- Live lists the suspicion first and the straight answer second.
serpent_thief_seen_it = ConvoScreen:new {
	id = "seen_it",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_64", -- Oh really? Well, I've been here for a while. If you tell me what it is, maybe I've seen it?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_66", "trust_b"},   -- Well, it was stolen from him, so I'm not sure I can trust you.
		{"@conversation/som_kenobi_serpent_thief:s_68", "seen_that"}, -- It was a small crystal shard with a flaw of a snake on it.
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

-- Both the straight answer and the suspicion detour land here.
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

-- s_97 is a [Use the Force] option and is stripped for the non-sensitive; see the handler.
serpent_thief_refuse_b = ConvoScreen:new {
	id = "refuse_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_93", -- I'm afraid I can't do that, cutie.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_95", "burial_ground"}, -- Why not? Don't make this any harder than it needs to be.
		{"@conversation/som_kenobi_serpent_thief:s_97", "fight_b_force"}, -- [Use the Force] You will give it to me.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_refuse_b)

-- Chain B's extra screen. This is where the earlier revision stopped, one screen early.
serpent_thief_burial_ground = ConvoScreen:new {
	id = "burial_ground",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_101", -- Because I need it, sweetie. I'm also afraid that I can't let you leave now. My apologies, but this will have to be your burial ground.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_103", "fight_b"}, -- Threats will get you nowhere.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_burial_ground)

-- Fight hook; see the handler.
serpent_thief_fight_b = ConvoScreen:new {
	id = "fight_b",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_115", -- Very well. We shall see how action works then!
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
--
-- Same beats as chain B, one screen shorter: she goes straight from the refusal
-- to the threat. There is no chain-A counterpart to burial_ground.
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

-- s_131 is a [Use the Force] option and is stripped for the non-sensitive; see the handler.
serpent_thief_refuse_a = ConvoScreen:new {
	id = "refuse_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_128", -- Oh no, I couldn't do that, sweetie.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_serpent_thief:s_129", "fight_a"},       -- If you don't give it up right now, I'm forced to hurt you.
		{"@conversation/som_kenobi_serpent_thief:s_131", "fight_a_force"}, -- [Use the Force] You will give it to me.
	}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_refuse_a)

-- Fight hook; see the handler. Chain A ends here -- there is no further screen.
serpent_thief_fight_a = ConvoScreen:new {
	id = "fight_a",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_134", -- No no, you got it all wrong. Since you've come here, I can't let you leave and I will most definitely hurt you.
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

--------------------------------------------------------------------------------
-- THE BRUSH-OFF -- not a live screen. See note 1 in the header.
--
-- No option anywhere in this tree leads here. serpent_thief_conv_handler's
-- getInitialScreen returns it, and only for a player who is not on the task.
--------------------------------------------------------------------------------

-- Its laugh_titter is in getInitialScreen with the condition that picks it; see
-- the withdrawal note above greeting.
serpent_thief_brush_off = ConvoScreen:new {
	id = "brush_off",
	leftDialog = "@conversation/som_kenobi_serpent_thief:s_43", -- You're a cute one, maybe too cute...
	stopConversation = "true",
	options = {}
}
som_kenobi_serpent_thief:addScreen(serpent_thief_brush_off)

addConversationTemplate("som_kenobi_serpent_thief", som_kenobi_serpent_thief)

--[[
	Ikt -- the Mustafarian treasure hunter who gives som_kenobi_serpent_shard_1.

	RECONSTRUCTED, not ported. som_kenobi_ikt.stf shipped in the client
	(string/en/conversation/), but the SwgConversationEditor tree that binds those
	strings into screens did not -- exactly as with som_kenobi_menth_paul and
	som_kenobi_epo_qetora. Every leftDialog and option string below is SOE's
	verbatim text; the edges between them are reconstructed.

	The table carries two near-duplicate chains on both halves of the quest, and
	both partition cleanly.

	THE OFFER, duplicated 2x

	  s_84 set   s_84 backstory -> s_85 "How am I supposed to find them?"
	             -> s_86 -> s_87 "Where are the ruins?" -> s_88 directions
	             -> s_89 "Anything else?" -> s_90
	  s_92 set   s_92 backstory (byte-identical to s_84) -> s_94 "It will be hard
	             to track the thief down with just that information..." -> s_96
	             -> s_98 "How do I find the ruins?" -> s_100 directions
	             -> s_102 "Anything else I should know?" -> s_104

	Each set is a complete four-beat chain and no line spans two sets. They hang off
	the two ways into the job: s_72 "I need help hunting down a thief" (reached by
	asking what the job is) and s_78, the same line reached by asking about the pay
	first. s_74 and s_79 are the two "what did he steal?" options, one per route.

	THE TURN-IN, duplicated 2x

	  s_151 "Indeed! I found the thief and retrieved the shard." -> s_157 "What
	    about the thief?" -> s_159 "I had no choice. She forced me to kill her..."
	    -> s_164 -> s_166 "I found another shard as well. Here." -> s_170 reward
	  s_153 "Yes, that thief will not bother anyone again." -> s_155 (he does not
	    need to ask, the player already said) -> s_168 "Alright... Well, I have your
	    shard, plus another one that I found." -> s_172 reward

	That is what pins them: s_157 only exists because one of the two openers does
	not mention the thief's fate, and s_155 / s_164 are the two copies of the "no one
	steals from Ikt" line that answer them. Both reward screens converge on the
	single closing run s_174 -> s_176 -> s_178 -> s_180 -> s_182 -> s_184.

	THE TWO "DISAPPOINTING" LINES

	s_143 and s_147 are byte-identical. One serves the offer being turned down
	(both refusal options land on it -- the strings s_113 and s_114 differ, the
	answer does not), the other serves the two ways a player walks away mid-quest:
	s_108 "I can't find the thief and don't have time to look anymore" and s_141
	"I'm afraid not". Neither takes the quest back -- see the handler.

	s_2 is the empty string and is deliberately unused.
]]

som_kenobi_ikt = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "ikt_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- OPENING -- the quest not taken yet
--------------------------------------------------------------------------------

ikt_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_ikt:s_110", -- Hey there, you available for some employment?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_111", "job_ask"},  -- I might be. What is the job?
		{"@conversation/som_kenobi_ikt:s_112", "job_pay"},  -- If it pays well enough.
		{"@conversation/som_kenobi_ikt:s_113", "decline"},  -- No, sorry. Not right now.
		{"@conversation/som_kenobi_ikt:s_114", "decline"},  -- No.
	}
}
som_kenobi_ikt:addScreen(ikt_greeting)

ikt_decline = ConvoScreen:new {
	id = "decline",
	leftDialog = "@conversation/som_kenobi_ikt:s_143", -- Disappointing. Guess I will have to find someone else.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline)

-- Route one: ask what the job is.
ikt_job_ask = ConvoScreen:new {
	id = "job_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_72", -- I need help hunting down a thief.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_74", "story_a"},        -- I might be interested in that. What did he steal?
		{"@conversation/som_kenobi_ikt:s_75", "decline_nofit"},  -- Not really something I'm good at. Sorry.
	}
}
som_kenobi_ikt:addScreen(ikt_job_ask)

ikt_decline_nofit = ConvoScreen:new {
	id = "decline_nofit",
	leftDialog = "@conversation/som_kenobi_ikt:s_76", -- My mistake.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline_nofit)

-- Route two: ask about the pay first.
ikt_job_pay = ConvoScreen:new {
	id = "job_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_73", -- Money is not a problem.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_77", "job_pay_thief"}, -- Good, then what is the problem so that I can solve it?
		{"@conversation/som_kenobi_ikt:s_80", "decline_busy"},  -- Bah! I have more important things to do.
	}
}
som_kenobi_ikt:addScreen(ikt_job_pay)

ikt_decline_busy = ConvoScreen:new {
	id = "decline_busy",
	leftDialog = "@conversation/som_kenobi_ikt:s_81", -- Very well, I'll just keep the money then.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline_busy)

ikt_job_pay_thief = ConvoScreen:new {
	id = "job_pay_thief",
	leftDialog = "@conversation/som_kenobi_ikt:s_78", -- I need help hunting down a thief.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_79", "story_b"}, -- Alright, I can do that. What did he steal?
	}
}
som_kenobi_ikt:addScreen(ikt_job_pay_thief)

-- Backstory chain A; see THE OFFER.
ikt_story_a = ConvoScreen:new {
	id = "story_a",
	leftDialog = "@conversation/som_kenobi_ikt:s_84", -- I found this little piece of crystal out in some old ruins...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_85", "watched_a"}, -- How am I supposed to find them? They could be anywhere now.
	}
}
som_kenobi_ikt:addScreen(ikt_story_a)

ikt_watched_a = ConvoScreen:new {
	id = "watched_a",
	leftDialog = "@conversation/som_kenobi_ikt:s_86", -- The next morning, I searched around the ruins some more... I think whoever it was that stole it is still out there.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_87", "directions_a"}, -- I'll see what I can find. Where are the ruins?
	}
}
som_kenobi_ikt:addScreen(ikt_watched_a)

-- Grants the quest; see the handler.
ikt_directions_a = ConvoScreen:new {
	id = "directions_a",
	leftDialog = "@conversation/som_kenobi_ikt:s_88", -- The ruins are to the west of that, across the river of molten lava.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_89", "closing_a"}, -- Anything else?
	}
}
som_kenobi_ikt:addScreen(ikt_directions_a)

ikt_closing_a = ConvoScreen:new {
	id = "closing_a",
	leftDialog = "@conversation/som_kenobi_ikt:s_90", -- I don't even care that much about the little crystal, but no one steals from Ikt and gets away with it! That's all...
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_closing_a)

-- Backstory chain B.
ikt_story_b = ConvoScreen:new {
	id = "story_b",
	leftDialog = "@conversation/som_kenobi_ikt:s_92", -- I found this little piece of crystal out in some old ruins...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_94", "watched_b"}, -- It will be hard to track the thief down with just that information...
	}
}
som_kenobi_ikt:addScreen(ikt_story_b)

ikt_watched_b = ConvoScreen:new {
	id = "watched_b",
	leftDialog = "@conversation/som_kenobi_ikt:s_96", -- The next morning, I searched around the ruins some more...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_98", "directions_b"}, -- Hopefully the thief will still be there. How do I find the ruins?
	}
}
som_kenobi_ikt:addScreen(ikt_watched_b)

-- Grants the quest; see the handler.
ikt_directions_b = ConvoScreen:new {
	id = "directions_b",
	leftDialog = "@conversation/som_kenobi_ikt:s_100", -- The ruins are to the west of that, across the river of molten lava.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_102", "closing_b"}, -- Okay, I will do my best. Anything else I should know?
	}
}
som_kenobi_ikt:addScreen(ikt_directions_b)

ikt_closing_b = ConvoScreen:new {
	id = "closing_b",
	leftDialog = "@conversation/som_kenobi_ikt:s_104", -- I don't even care that much about the little crystal, but no one steals from Ikt and gets away with it! That's all...
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_closing_b)

--------------------------------------------------------------------------------
-- QUEST IN PROGRESS
--------------------------------------------------------------------------------

ikt_progress = ConvoScreen:new {
	id = "progress",
	leftDialog = "@conversation/som_kenobi_ikt:s_67", -- Already back?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_105", "progress_end"},  -- Just back to stock up on some rations, etc.
		{"@conversation/som_kenobi_ikt:s_107", "abandon_press"}, -- Some things have come up that I have to take care of.
	}
}
som_kenobi_ikt:addScreen(ikt_progress)

ikt_progress_end = ConvoScreen:new {
	id = "progress_end",
	leftDialog = "@conversation/som_kenobi_ikt:s_106", -- Very well.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_progress_end)

ikt_abandon_press = ConvoScreen:new {
	id = "abandon_press",
	leftDialog = "@conversation/som_kenobi_ikt:s_109", -- You won't be able to finish the job?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_108", "abandon_end"}, -- Yeah, I can't find the thief and don't have time to look anymore.
	}
}
som_kenobi_ikt:addScreen(ikt_abandon_press)

ikt_abandon_end = ConvoScreen:new {
	id = "abandon_end",
	leftDialog = "@conversation/som_kenobi_ikt:s_147", -- Disappointing. Guess I will have to find someone else.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_abandon_end)

--------------------------------------------------------------------------------
-- TURN-IN -- both shards in hand
--------------------------------------------------------------------------------

ikt_turnin = ConvoScreen:new {
	id = "turnin",
	leftDialog = "@conversation/som_kenobi_ikt:s_149", -- There you are. Have you had any luck?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_151", "thief_asked"}, -- Indeed! I found the thief and retrieved the shard.
		{"@conversation/som_kenobi_ikt:s_153", "thief_told"},  -- Yes, that thief will not bother anyone again.
		{"@conversation/som_kenobi_ikt:s_141", "abandon_end"}, -- I'm afraid not.
	}
}
som_kenobi_ikt:addScreen(ikt_turnin)

ikt_thief_asked = ConvoScreen:new {
	id = "thief_asked",
	leftDialog = "@conversation/som_kenobi_ikt:s_157", -- What about the thief?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_159", "praise_asked"}, -- I had no choice. She forced me to kill her...
	}
}
som_kenobi_ikt:addScreen(ikt_thief_asked)

ikt_praise_asked = ConvoScreen:new {
	id = "praise_asked",
	leftDialog = "@conversation/som_kenobi_ikt:s_164", -- That is excellent news! No one steals from Ikt and gets away with it. No one!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_166", "reward_asked"}, -- I found another shard as well. Here.
	}
}
som_kenobi_ikt:addScreen(ikt_praise_asked)

-- Pays out; see the handler.
ikt_reward_asked = ConvoScreen:new {
	id = "reward_asked",
	leftDialog = "@conversation/som_kenobi_ikt:s_170", -- Oh yeah, the shard. And another one, you say. Strange little things, they seem to fit together...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_174", "notinterested"}, -- You don't even want it back?
	}
}
som_kenobi_ikt:addScreen(ikt_reward_asked)

ikt_thief_told = ConvoScreen:new {
	id = "thief_told",
	leftDialog = "@conversation/som_kenobi_ikt:s_155", -- That is excellent news, friend. No one steals from Ikt and gets away with it. No one!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_168", "reward_told"}, -- Alright... Well, I have your shard, plus another one that I found.
	}
}
som_kenobi_ikt:addScreen(ikt_thief_told)

-- Pays out; see the handler.
ikt_reward_told = ConvoScreen:new {
	id = "reward_told",
	leftDialog = "@conversation/som_kenobi_ikt:s_172", -- Oh yeah, the shard. And another one, you say. Strange little things, they seem to fit together...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_174", "notinterested"}, -- You don't even want it back?
	}
}
som_kenobi_ikt:addScreen(ikt_reward_told)

ikt_notinterested = ConvoScreen:new {
	id = "notinterested",
	leftDialog = "@conversation/som_kenobi_ikt:s_176", -- No, the shard wasn't very interesting, but as I said, no one...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_178", "dontforget"}, -- ...steals from Ikt and gets away with it. Yeah I get it.
	}
}
som_kenobi_ikt:addScreen(ikt_notinterested)

ikt_dontforget = ConvoScreen:new {
	id = "dontforget",
	leftDialog = "@conversation/som_kenobi_ikt:s_180", -- That's right and don't you forget it!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_182", "farewell"}, -- Pleasure doing business with you.
	}
}
som_kenobi_ikt:addScreen(ikt_dontforget)

ikt_farewell = ConvoScreen:new {
	id = "farewell",
	leftDialog = "@conversation/som_kenobi_ikt:s_184", -- The pleasure was all mine, friend.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_farewell)

--------------------------------------------------------------------------------
-- DONE
--------------------------------------------------------------------------------

ikt_all_done = ConvoScreen:new {
	id = "all_done",
	leftDialog = "@conversation/som_kenobi_ikt:s_186", -- I trust you are enjoying your stay on our nice little corner of the galaxy? I know I am.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_all_done)

addConversationTemplate("som_kenobi_ikt", som_kenobi_ikt)

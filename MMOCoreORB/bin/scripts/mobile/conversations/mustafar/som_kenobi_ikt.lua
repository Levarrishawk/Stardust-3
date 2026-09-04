--[[
	Ikt -- the Mustafarian treasure hunter who gives som_kenobi_serpent_shard_1.

	RECONSTRUCTED FROM THE STRING TABLE, THEN CHECKED AGAINST THE LIVE TREE.
	som_kenobi_ikt.stf shipped in the client (string/en/conversation/) but the
	SwgConversationEditor tree that binds those strings into screens did not, so
	the wiring below was first reconstructed by matching each option to the screen
	its wording answers. The live conversation script has since been read. Every
	leftDialog and option string is SOE's verbatim text either way; what changed
	is the edges, and they changed a lot. Four corrections, and one of them is the
	shape of the whole file.

	s_2 is the empty string and is unused. Everything else is used.

	CORRECTING THE TWO DECLINES. s_82 "Alright, come back if you change your mind."
	and s_83 "Very well." were not in this file at all. Both declines on the
	greeting -- s_113 "No, sorry. Not right now." and s_114 "No." -- were pointed
	at a single shared screen carrying s_143 instead. Live answers s_113 with s_82
	and s_114 with s_83, one apiece, and never uses s_143 there.

	ROOT CAUSE: s_143 and s_147 are byte-identical, and the earlier revision built
	its whole reading of the file around explaining that duplicate -- it decided
	one copy must serve the offer being turned down and the other the mid-quest
	walk-away, and then went looking for options to hang on them. Once s_143 had a
	job, s_82 and s_83 had none, and two shipped strings were quietly dropped to
	keep the theory. The duplicate has a much duller explanation: BOTH copies are
	mid-quest walk-aways, one per route out of s_67, and SOE wrote the line twice
	because the editor makes you write it twice. A duplicated string is a fact
	about the tool, not a clue about the tree.

	CORRECTING THE TWO OFFER CHAINS -- they were on the wrong routes. The table
	carries the backstory twice, s_84 and s_92 byte-identical, each with its own
	four-beat follow-up. Live is:

	    via s_74, off "What is the job?"   ->  s_92 s_94 s_96 s_98 s_100 s_102 s_104
	    via s_79, off "If it pays well"    ->  s_84 s_85 s_86 s_87 s_88 s_89 s_90

	This file had them the other way round. The chains are named _ask and _pay
	below rather than _a and _b so that the route they belong to is on the screen.

	ROOT CAUSE: numeric order. s_84 comes before s_92, and s_72 comes before s_78,
	so the first chain was matched to the first route. Nothing in the .stf pairs
	them -- the backstory is the same words both times and the player's four
	replies are interchangeable paraphrases. It was a coin flip presented as a
	reading.

	CORRECTING WHERE THE JOB IS ACCEPTED. s_80 "Bah! I have more important things
	to do." sat on s_73, the "Money is not a problem" screen. Live puts it one
	screen later, on s_78, beside s_79. So s_73 offers exactly one option and the
	refusal lives next to the acceptance, which is the same shape s_72 has with
	s_74 and s_75. Both routes are a two-button choice at the same beat.

	CORRECTING THE MID-QUEST BRANCH. Three lines were misplaced at once:

	    s_108  "I can't find the thief and don't have time to look anymore."
	           lives on s_67 as a third option, not behind s_109
	    s_141  "I'm afraid not."   lives behind s_109, not on the turn-in
	    s_143  is what answers s_141; s_147 is what answers s_108

	So s_67 offers three ways out and s_109 "You won't be able to finish the job?"
	is the screen you reach by being vague, with s_141 the only way on from it.
	And the turn-in screen s_149 offers two options, not three.

	ROOT CAUSE: taking s_109's question at face value. "You won't be able to finish
	the job?" reads as a prompt that needs a blunt answer, and s_108 is the blunt
	one, so it was put there and s_141 was left over and pushed onto the turn-in
	where "I'm afraid not" also parses. Live means the opposite: s_108 is the blunt
	answer given straight away, and s_109 is what you get for hedging.

	CORRECTING THE TURN-IN, which is the big one. The two chains do not converge.
	This file ran both openers into one shared tail -- s_174 through s_184, six
	screens -- on the strength of s_170 and s_172 being byte-identical. Live splits
	them and they are different lengths:

	    s_151 "I found the thief and retrieved the shard."   (does not say her fate)
	          -> s_157 "What about the thief?"  -> s_159 -> s_164 -> s_168
	          -> s_172 payment -> s_174 -> s_176 -> s_178 -> s_180  REWARD
	    s_153 "That thief will not bother anyone again."     (says her fate)
	          -> s_155 -> s_166 -> s_170 payment -> s_182 -> s_184  REWARD

	s_166 and s_168 were swapped, which swapped s_170 and s_172 behind them, and
	the six-screen tail belongs to the first route alone. The player who spelled
	out that he killed her gets the short goodbye; the player who made Ikt ask gets
	the long one where Ikt will not take the shard back.

	ROOT CAUSE: the same duplicate-string reasoning as the declines. s_170 and
	s_172 are identical, so they were read as one beat reached two ways, and
	whatever came after was assumed shared. In this table an identical pair means
	two separate chains that happen to say the same thing, every time -- s_84/s_92
	and s_143/s_147 are the same pattern. Three duplicates, three chains that do
	not merge.
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
		{"@conversation/som_kenobi_ikt:s_111", "job_ask"},       -- I might be. What is the job?
		{"@conversation/som_kenobi_ikt:s_112", "job_pay"},       -- If it pays well enough.
		{"@conversation/som_kenobi_ikt:s_113", "decline_later"}, -- No, sorry. Not right now.
		{"@conversation/som_kenobi_ikt:s_114", "decline_flat"},  -- No.
	}
}
som_kenobi_ikt:addScreen(ikt_greeting)

-- s_82 and s_83, one per refusal. See CORRECTING THE TWO DECLINES.
ikt_decline_later = ConvoScreen:new {
	id = "decline_later",
	leftDialog = "@conversation/som_kenobi_ikt:s_82", -- Alright, come back if you change your mind.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline_later)

ikt_decline_flat = ConvoScreen:new {
	id = "decline_flat",
	leftDialog = "@conversation/som_kenobi_ikt:s_83", -- Very well.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline_flat)

-- Route one: ask what the job is. Leads to the s_92 chain.
ikt_job_ask = ConvoScreen:new {
	id = "job_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_72", -- I need help hunting down a thief.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_74", "story_ask"},      -- I might be interested in that. What did he steal?
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

-- Route two: ask about the pay first. One option; the refusal is a screen later.
ikt_job_pay = ConvoScreen:new {
	id = "job_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_73", -- Money is not a problem.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_77", "job_pay_thief"}, -- Good, then what is the problem so that I can solve it?
	}
}
som_kenobi_ikt:addScreen(ikt_job_pay)

-- Leads to the s_84 chain. See CORRECTING WHERE THE JOB IS ACCEPTED for s_80.
ikt_job_pay_thief = ConvoScreen:new {
	id = "job_pay_thief",
	leftDialog = "@conversation/som_kenobi_ikt:s_78", -- I need help hunting down a thief.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_79", "story_pay"},    -- Alright, I can do that. What did he steal?
		{"@conversation/som_kenobi_ikt:s_80", "decline_busy"}, -- Bah! I have more important things to do.
	}
}
som_kenobi_ikt:addScreen(ikt_job_pay_thief)

ikt_decline_busy = ConvoScreen:new {
	id = "decline_busy",
	leftDialog = "@conversation/som_kenobi_ikt:s_81", -- Very well, I'll just keep the money then.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_decline_busy)

--------------------------------------------------------------------------------
-- the backstory, off "What is the job?". See CORRECTING THE TWO OFFER CHAINS.
--------------------------------------------------------------------------------

ikt_story_ask = ConvoScreen:new {
	id = "story_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_92", -- I found this little piece of crystal out in some old ruins...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_94", "watched_ask"}, -- It will be hard to track the thief down with just that information...
	}
}
som_kenobi_ikt:addScreen(ikt_story_ask)

ikt_watched_ask = ConvoScreen:new {
	id = "watched_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_96", -- The next morning, I searched around the ruins some more... I think whoever it was that stole it is still out there.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_98", "directions_ask"}, -- Hopefully the thief will still be there. How do I find the ruins?
	}
}
som_kenobi_ikt:addScreen(ikt_watched_ask)

ikt_directions_ask = ConvoScreen:new {
	id = "directions_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_100", -- The ruins are to the west of that, across the river of molten lava.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_102", "closing_ask"}, -- Okay, I will do my best. Anything else I should know?
	}
}
som_kenobi_ikt:addScreen(ikt_directions_ask)

-- Grants the quest; see the handler.
ikt_closing_ask = ConvoScreen:new {
	id = "closing_ask",
	leftDialog = "@conversation/som_kenobi_ikt:s_104", -- I don't even care that much about the little crystal, but no one steals from Ikt and gets away with it! That's all...
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_closing_ask)

--------------------------------------------------------------------------------
-- the backstory, off "If it pays well enough."
--------------------------------------------------------------------------------

ikt_story_pay = ConvoScreen:new {
	id = "story_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_84", -- I found this little piece of crystal out in some old ruins...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_85", "watched_pay"}, -- How am I supposed to find them? They could be anywhere now.
	}
}
som_kenobi_ikt:addScreen(ikt_story_pay)

ikt_watched_pay = ConvoScreen:new {
	id = "watched_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_86", -- The next morning, I searched around the ruins some more... I think whoever it was that stole it is still out there.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_87", "directions_pay"}, -- I'll see what I can find. Where are the ruins?
	}
}
som_kenobi_ikt:addScreen(ikt_watched_pay)

ikt_directions_pay = ConvoScreen:new {
	id = "directions_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_88", -- The ruins are to the west of that, across the river of molten lava.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_89", "closing_pay"}, -- Anything else?
	}
}
som_kenobi_ikt:addScreen(ikt_directions_pay)

-- Grants the quest; see the handler.
ikt_closing_pay = ConvoScreen:new {
	id = "closing_pay",
	leftDialog = "@conversation/som_kenobi_ikt:s_90", -- I don't even care that much about the little crystal, but no one steals from Ikt and gets away with it! That's all...
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_closing_pay)

--------------------------------------------------------------------------------
-- QUEST IN PROGRESS. Three ways out of s_67, two of which drop the quest.
--------------------------------------------------------------------------------

ikt_progress = ConvoScreen:new {
	id = "progress",
	leftDialog = "@conversation/som_kenobi_ikt:s_67", -- Already back?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_105", "progress_end"},   -- Just back to stock up on some rations, etc.
		{"@conversation/som_kenobi_ikt:s_107", "abandon_press"},  -- Some things have come up that I have to take care of.
		{"@conversation/som_kenobi_ikt:s_108", "abandon_direct"}, -- Yeah, I can't find the thief and don't have time to look anymore.
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

-- What hedging gets you. See CORRECTING THE MID-QUEST BRANCH.
ikt_abandon_press = ConvoScreen:new {
	id = "abandon_press",
	leftDialog = "@conversation/som_kenobi_ikt:s_109", -- You won't be able to finish the job?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_141", "abandon_asked"}, -- I'm afraid not.
	}
}
som_kenobi_ikt:addScreen(ikt_abandon_press)

-- Both drop the quest; see the handler. s_143 and s_147 are byte-identical and
-- both are mid-quest walk-aways -- neither serves a declined offer.
ikt_abandon_direct = ConvoScreen:new {
	id = "abandon_direct",
	leftDialog = "@conversation/som_kenobi_ikt:s_147", -- Disappointing. Guess I will have to find someone else.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_abandon_direct)

ikt_abandon_asked = ConvoScreen:new {
	id = "abandon_asked",
	leftDialog = "@conversation/som_kenobi_ikt:s_143", -- Disappointing. Guess I will have to find someone else.
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_abandon_asked)

--------------------------------------------------------------------------------
-- TURN-IN -- both shards in hand. Two chains, and they do NOT converge.
-- See CORRECTING THE TURN-IN.
--------------------------------------------------------------------------------

ikt_turnin = ConvoScreen:new {
	id = "turnin",
	leftDialog = "@conversation/som_kenobi_ikt:s_149", -- There you are. Have you had any luck?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_151", "thief_asked"}, -- Indeed! I found the thief and retrieved the shard.
		{"@conversation/som_kenobi_ikt:s_153", "thief_told"},  -- Yes, that thief will not bother anyone again.
	}
}
som_kenobi_ikt:addScreen(ikt_turnin)

-- the long chain: he has to ask what became of her, and he will not take the
-- shard back afterwards.
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
		{"@conversation/som_kenobi_ikt:s_168", "pay_asked"}, -- Alright... Well, I have your shard, plus another one that I found.
	}
}
som_kenobi_ikt:addScreen(ikt_praise_asked)

ikt_pay_asked = ConvoScreen:new {
	id = "pay_asked",
	leftDialog = "@conversation/som_kenobi_ikt:s_172", -- Oh yeah, the shard. And another one, you say. Strange little things, they seem to fit together... here's your payment for a job well done.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_174", "notinterested"}, -- You don't even want it back?
	}
}
som_kenobi_ikt:addScreen(ikt_pay_asked)

ikt_notinterested = ConvoScreen:new {
	id = "notinterested",
	leftDialog = "@conversation/som_kenobi_ikt:s_176", -- No, the shard wasn't very interesting, but as I said, no one...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_178", "dontforget"}, -- ...steals from Ikt and gets away with it. Yeah I get it.
	}
}
som_kenobi_ikt:addScreen(ikt_notinterested)

-- Pays out; see the handler.
ikt_dontforget = ConvoScreen:new {
	id = "dontforget",
	leftDialog = "@conversation/som_kenobi_ikt:s_180", -- That's right and don't you forget it!
	stopConversation = "true",
	options = {}
}
som_kenobi_ikt:addScreen(ikt_dontforget)

-- the short chain: the player already said what became of her, so Ikt skips
-- straight to the praise and the goodbye is two screens.
ikt_thief_told = ConvoScreen:new {
	id = "thief_told",
	leftDialog = "@conversation/som_kenobi_ikt:s_155", -- That is excellent news, friend. No one steals from Ikt and gets away with it. No one!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_166", "pay_told"}, -- I found another shard as well. Here.
	}
}
som_kenobi_ikt:addScreen(ikt_thief_told)

ikt_pay_told = ConvoScreen:new {
	id = "pay_told",
	leftDialog = "@conversation/som_kenobi_ikt:s_170", -- Oh yeah, the shard. And another one, you say. Strange little things, they seem to fit together... here's your payment for a job well done.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_ikt:s_182", "farewell"}, -- Pleasure doing business with you.
	}
}
som_kenobi_ikt:addScreen(ikt_pay_told)

-- Pays out; see the handler.
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

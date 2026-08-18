--[[
	The leader of the striking miners -- som_kenobi_moral_choice_1.

	RECONSTRUCTED, not ported. som_kenobi_moral_strike_leader.stf shipped in the
	client (string/en/conversation/); the SwgConversationEditor tree that wires
	those strings into screens did not. Every leftDialog and option string below
	is SOE's verbatim text; the edges between them are reconstructed.

	THE WHOLE CONVERSATION IS WRITTEN TWICE, and the player's opening question
	picks the copy. The two halves are numbered in different bands, which is
	what pins the split -- the first runs s_177..s_212, the second s_214,
	s_216 and then s_261..s_302, and no line is shared:

	  s_173  "This looks like a mine but you aren't working?"
	         -> s_177 "No, we are currently on strike." Straight to the point,
	         so this half is one beat shorter.

	  s_175  "What is going on here?"
	         -> s_214 "Not much." -- he stonewalls -- then s_216/s_261 and
	         s_262/s_264 to get to the same place.

	After that the two run in lockstep, paragraph for paragraph:

	     s_185 = s_264   the accusation (identical text)
	     s_191 = s_268   "Hmm, why do you ask?"
	     s_198 = s_272   "I knew it!..."
	     s_200 = s_276   the offer
	     s_202 = s_280   the plan
	     s_204 = s_284   the disk        <- GRANT, both halves
	     s_206 = s_288   "Be careful of guards on the executive's payroll."

	THE DUPLICATE CONFESSION IS A SECOND CHANCE

	"Well, I was sent here by that executive to sabotage." ships twice per half
	-- s_192 and s_195, s_270 and s_294 -- and that is the one edge in this tree
	the numbering alone does not give. The first copy hangs off "Hmm, why do you
	ask?" (s_191/s_268). The second hangs off the brush-off that follows the
	player playing it coy: s_193/s_290 "Oh, I'm just curious." is answered by
	s_194/s_292 "...we can't be careful enough, so I believe our conversation
	ends here", and the duplicate is the player owning up before he walks. Take
	it and both copies land on the same confession screen; leave it and s_196 /
	s_296 "I understand." closes on s_197 / s_298 "Good. You take care now."

	Without that placement s_195 and s_294 have nowhere to live, and a player
	who answered "just curious" once would be locked out of the miners' branch
	forever over a single option click.

	WALKING AWAY is offered at every beat before the confession -- s_181/s_183,
	s_188/s_190, s_300/s_302, s_196/s_197, s_296/s_298 -- and none of them
	changes any state. The .qst models no abandon.

	THE FOUR STANDING LINES, one per state the quest can be in when the player
	hails him, all of which shipped, and between them they use up the table:

	  s_110  "Be careful around here, friend. I wouldn't be surprised if the
	         corporation will resort to violence against us strikers soon."
	         -- no quest. Friendly, and to a stranger: he has no reason not to
	         be. The tree proper is gated behind the executive's errand
	         because every one of its branches assumes the player was sent.

	  s_207  "The executive will get suspicious, friend..."   disk in hand
	  s_208  "My friend! We have already heard the good news!..."  uploaded
	  s_139  "I don't like your look. You should move along..."  the player
	         took the corporation's reward. He tore out their power core and
	         two of their miners came at him doing it, so by the time he comes
	         back to gloat the camp knows exactly who he is.
	  s_171  "Yes, we are still here and will be until this is solved."
	         the miners' branch is finished; the trial has not happened yet.

	s_2 is the empty string and is not a screen.
]]

som_kenobi_moral_strike_leader = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "moral_strike_leader_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- THE OPENING -- the player's first question picks the half
--------------------------------------------------------------------------------

moral_leader_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_140", -- How may I assist?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_173", "p1_strike"},   -- This looks like a mine but you aren't working?
		{"@conversation/som_kenobi_moral_strike_leader:s_175", "p2_notmuch"},  -- What is going on here?
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_greeting)

--------------------------------------------------------------------------------
-- HALF ONE -- "This looks like a mine but you aren't working?"
--------------------------------------------------------------------------------

moral_leader_p1_strike = ConvoScreen:new {
	id = "p1_strike",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_177", -- No, we are currently on strike.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_179", "p1_why"},      -- How come?
		{"@conversation/som_kenobi_moral_strike_leader:s_181", "p1_goodluck"}, -- Alright. Well good luck then.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_strike)

moral_leader_p1_goodluck = ConvoScreen:new {
	id = "p1_goodluck",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_183", -- Thank you. We need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_goodluck)

moral_leader_p1_why = ConvoScreen:new {
	id = "p1_why",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_185", -- Recently we found out that one of the executives in our corporation is skimming bonus money that should be going to us, the workers...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_187", "p1_proof"}, -- You don't say? Do you have any proof?
		{"@conversation/som_kenobi_moral_strike_leader:s_188", "p1_bye"},   -- Interesting. Well, good luck with that.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_why)

moral_leader_p1_bye = ConvoScreen:new {
	id = "p1_bye",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_190", -- Thank you. We need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_bye)

moral_leader_p1_proof = ConvoScreen:new {
	id = "p1_proof",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_191", -- Hmm, why do you ask?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_192", "p1_confess"}, -- Well, I was sent here by that executive to sabotage.
		{"@conversation/som_kenobi_moral_strike_leader:s_193", "p1_curious"}, -- Oh, I'm just curious.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_proof)

-- s_195 is s_192 word for word: the second chance to own up before he walks.
moral_leader_p1_curious = ConvoScreen:new {
	id = "p1_curious",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_194", -- Well, these days, we can't be careful enough, so I believe our conversation ends here.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_195", "p1_confess"},  -- Well, I was sent here by that executive to sabotage.
		{"@conversation/som_kenobi_moral_strike_leader:s_196", "p1_takecare"}, -- I understand.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_curious)

moral_leader_p1_takecare = ConvoScreen:new {
	id = "p1_takecare",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_197", -- Good. You take care now.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_takecare)

moral_leader_p1_confess = ConvoScreen:new {
	id = "p1_confess",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_198", -- I knew it! I was wondering how long it would take him to resort to that kind of action. How come you are telling me?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_199", "p1_offer"}, -- After hearing your side, I'd like to help you guys out.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_confess)

moral_leader_p1_offer = ConvoScreen:new {
	id = "p1_offer",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_200", -- Interesting. You asked earlier if we have proof and we indeed do. The problem is that the executive's men will probably attack us on sight...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_201", "p1_plan"}, -- Agreed. What do you need me to do in there?
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_offer)

moral_leader_p1_plan = ConvoScreen:new {
	id = "p1_plan",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_202", -- If we give you a disk with the proof we have, you can upload it onto the corporation's communication network...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_203", "p1_disk"}, -- Sounds easy enough. I'll do it!
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_plan)

-- GRANT -- .qst signal talkedLeader, and the point of no return for the
-- corporation's half of the quest.
moral_leader_p1_disk = ConvoScreen:new {
	id = "p1_disk",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_204", -- Good, here's the disk. You will find the computer terminal inside the main mining facility.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_205", "p1_careful"}, -- Very well, I will return when it's done.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_disk)

moral_leader_p1_careful = ConvoScreen:new {
	id = "p1_careful",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_206", -- I look forward to it. Be careful of guards on the executive's payroll. They will try to stop you if they figure out what you are up to.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p1_careful)

--------------------------------------------------------------------------------
-- HALF TWO -- "What is going on here?"
--------------------------------------------------------------------------------

moral_leader_p2_notmuch = ConvoScreen:new {
	id = "p2_notmuch",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_214", -- Not much.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_216", "p2_strike"}, -- I can see that. How come?
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_notmuch)

moral_leader_p2_strike = ConvoScreen:new {
	id = "p2_strike",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_261", -- We are on strike.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_262", "p2_why"}, -- Why?
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_strike)

moral_leader_p2_why = ConvoScreen:new {
	id = "p2_why",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_264", -- Recently we found out that one of the executives in our corporation is skimming bonus money that should be going to us, the workers...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_266", "p2_proof"}, -- You don't say? Do you have any proof?
		{"@conversation/som_kenobi_moral_strike_leader:s_300", "p2_bye"},   -- Interesting. Well, good luck with that.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_why)

moral_leader_p2_bye = ConvoScreen:new {
	id = "p2_bye",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_302", -- Thank you. We need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_bye)

moral_leader_p2_proof = ConvoScreen:new {
	id = "p2_proof",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_268", -- Hmm, why do you ask?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_270", "p2_confess"}, -- Well, I was sent here by that executive to sabotage.
		{"@conversation/som_kenobi_moral_strike_leader:s_290", "p2_curious"}, -- Oh, I'm just curious.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_proof)

-- s_294 is s_270 word for word: the second chance to own up before he walks.
moral_leader_p2_curious = ConvoScreen:new {
	id = "p2_curious",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_292", -- Well, these days we can't be careful enough, so I believe our conversation ends here.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_294", "p2_confess"},  -- Well, I was sent here by that executive to sabotage.
		{"@conversation/som_kenobi_moral_strike_leader:s_296", "p2_takecare"}, -- I understand.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_curious)

moral_leader_p2_takecare = ConvoScreen:new {
	id = "p2_takecare",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_298", -- Good. You take care now.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_takecare)

moral_leader_p2_confess = ConvoScreen:new {
	id = "p2_confess",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_272", -- I knew it! I was wondering how long it would take him to resort to that kind of action. How come you are telling me?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_274", "p2_offer"}, -- That guy deserves to be taught a lesson.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_confess)

moral_leader_p2_offer = ConvoScreen:new {
	id = "p2_offer",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_276", -- Interesting. You asked earlier if we have proof and we indeed do. The problem is that the executive's men will probably attack us on sight...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_278", "p2_plan"}, -- Most likely. Why?
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_offer)

moral_leader_p2_plan = ConvoScreen:new {
	id = "p2_plan",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_280", -- If we give you a disk with the proof we have, you can upload it onto the corporation's communication network...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_282", "p2_disk"}, -- Shouldn't be a problem.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_plan)

-- GRANT -- .qst signal talkedLeader.
moral_leader_p2_disk = ConvoScreen:new {
	id = "p2_disk",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_284", -- Good, here's the disk. You will find the computer terminal inside the main mining facility.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_286", "p2_careful"}, -- Very well, I will return when it's done.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_disk)

moral_leader_p2_careful = ConvoScreen:new {
	id = "p2_careful",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_288", -- I look forward to it. Be careful of guards on the executive's payroll. They will try to stop you if they figure out what you are up to.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_p2_careful)

--------------------------------------------------------------------------------
-- THE STANDING LINES -- one per state, all shipped
--------------------------------------------------------------------------------

moral_leader_moveon = ConvoScreen:new {
	id = "moveon",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_139", -- I don't like your look. You should move along...
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_moveon)

moral_leader_ambient = ConvoScreen:new {
	id = "ambient",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_110", -- Be careful around here, friend. I wouldn't be surprised if the corporation will resort to violence against us strikers soon.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_ambient)

moral_leader_progress = ConvoScreen:new {
	id = "progress",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_207", -- The executive will get suspicious, friend. You should go to the mining facility and upload that data as soon as possible.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_progress)

moral_leader_after = ConvoScreen:new {
	id = "after",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_171", -- Yes, we are still here and will be until this is solved.
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_after)

--------------------------------------------------------------------------------
-- THE PAYOFF
--------------------------------------------------------------------------------

moral_leader_done = ConvoScreen:new {
	id = "done",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_208", -- My friend! We have already heard the good news! I believe the corporation is setting up the trial for that scum, as we speak...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_209", "reward"}, -- It felt good sticking it to that pompous vermin.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_done)

-- REWARD.
moral_leader_reward = ConvoScreen:new {
	id = "reward",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_210", -- I agree! Now we are by no means rich, but we all chipped in and have managed to put together a credit reward...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_moral_strike_leader:s_211", "farewell"}, -- I'm most grateful. Thank your men for me.
	}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_reward)

moral_leader_farewell = ConvoScreen:new {
	id = "farewell",
	leftDialog = "@conversation/som_kenobi_moral_strike_leader:s_212", -- We're the ones that are grateful, friend. Take good care of yourself!
	stopConversation = "true",
	options = {}
}
som_kenobi_moral_strike_leader:addScreen(moral_leader_farewell)

addConversationTemplate("som_kenobi_moral_strike_leader", som_kenobi_moral_strike_leader)

--[[
	Captain Diskret Stahn -- the grounded freighter pilot in the Mensix cantina.

	Stahn is the other half of Pei Yi's story: he is the captain whose engine "fell apart or
	something", and he tells the same grounding from his own side, with pirates in it. See
	conversations/mustafar/som_pei_yi.lua for the shape of the reconstruction.

	Every line is an existing @conversation/som_diskret_stahn entry (from
	string/en/conversation/som_diskret_stahn.stf, mtg_patch_019.tre), so no new client strings
	are introduced. The pairings follow the text: s_56 "That sounds horrible. Good bye." answers
	s_35 "It was torn to shreds", s_76 "Sorry. Good bye." answers s_78 "you're pullin' my leg",
	and so on.

	The tune he passes on is a conversation, not an ability grant. The only
	datatables/performance/performance.iff in this tree lists 13 songs and none is calypso, and
	none of the three skills.iff copies carries a startMusic+calypso ability, so there is nothing
	to grant; see the longer note in conversations/mustafar/som_pei_yi.lua. The handler gates on
	social_musician_novice, which is real, and stops there rather than leaving a dead grant in
	the code.
--]]

som_diskret_stahn = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "diskret_stahn_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- First meeting
--------------------------------------------------------------------------------

diskret_stahn_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_diskret_stahn:s_7", -- What are you doing bothering me? Can't you see I'm busy?
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_9",  "not_busy"},    -- It doesn't look like you're busy at all.
		{"@conversation/som_diskret_stahn:s_21", "who_are_you"}, -- Who are you?
		{"@conversation/som_diskret_stahn:s_77", "narglatch"},   -- Look behind you! A three-headed narglatch!
		{"@conversation/som_diskret_stahn:s_17", "bye_leave"},   -- I'll leave you to it, then.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_greeting)

diskret_stahn_not_busy = ConvoScreen:new {
	id = "not_busy",
	leftDialog = "@conversation/som_diskret_stahn:s_11", -- Ah...some people might say that. And, er...those people would be right.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_13", "name_is"},  -- Who are you?
	}
}
som_diskret_stahn:addScreen(diskret_stahn_not_busy)

diskret_stahn_name_is = ConvoScreen:new {
	id = "name_is",
	leftDialog = "@conversation/som_diskret_stahn:s_15", -- The name's Cap'n Diskret Stahn. I pilot a small freighter hither and yon. To the farthest reaches of the galaxy. A dangerous job it is, to be sure.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_25", "why_here"},      -- What brings you here?
		{"@conversation/som_diskret_stahn:s_60", "bye_interest1"}, -- Interesting. Good bye.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_name_is)

diskret_stahn_who_are_you = ConvoScreen:new {
	id = "who_are_you",
	leftDialog = "@conversation/som_diskret_stahn:s_23", -- The name's Cap'n Diskret Stahn. I pilot a small freighter hither and yon. To the farthest reaches of the galaxy. A dangerous job it is, to be sure.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_25", "why_here"},      -- What brings you here?
		{"@conversation/som_diskret_stahn:s_64", "bye_interest2"}, -- Interesting. Good bye.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_who_are_you)

diskret_stahn_why_here = ConvoScreen:new {
	id = "why_here",
	leftDialog = "@conversation/som_diskret_stahn:s_27", -- Well, I was in the middle of bringin' this young lady here to Naboo (she paid me to do it, you see) when we were set upon by the biggest band of pirates you ever seen. Hundreds of 'em, there were.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_29", "no_kidding"},  -- No kidding?
	}
}
som_diskret_stahn:addScreen(diskret_stahn_why_here)

diskret_stahn_no_kidding = ConvoScreen:new {
	id = "no_kidding",
	leftDialog = "@conversation/som_diskret_stahn:s_31", -- Right. Hundreds of 'em. With huge ships. Each one had probably about a thousand turbolasers. Even with my masterful piloting skills, we were hopelessly overpowered.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_33", "what_happened"},  -- What happened?
	}
}
som_diskret_stahn:addScreen(diskret_stahn_no_kidding)

diskret_stahn_what_happened = ConvoScreen:new {
	id = "what_happened",
	leftDialog = "@conversation/som_diskret_stahn:s_35", -- We took a shot to the engine. It was torn to shreds, but I held her together long enough to land her here for repairs and supplies.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_37", "how_long"},      -- How long have you been here?
		{"@conversation/som_diskret_stahn:s_56", "bye_horrible"},  -- That sounds horrible. Good bye.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_what_happened)

diskret_stahn_how_long = ConvoScreen:new {
	id = "how_long",
	leftDialog = "@conversation/som_diskret_stahn:s_39", -- Far too long, that's for sure. And it wouldn't be quite so bad, but I got this tune stuck in my head ever since I made that delivery out to the Abregado system.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_41", "ask_tune"},       -- I'm a bit of a musician. Could you teach me the tune?
		{"@conversation/som_diskret_stahn:s_68", "bye_interest3"},  -- Interesting. Good bye.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_how_long)

diskret_stahn_ask_tune = ConvoScreen:new {
	id = "ask_tune",
	leftDialog = "@conversation/som_diskret_stahn:s_43", -- Ah, of course. The best way to get rid of a tune in your head is to get it stuck in someone else's head. Sure, I'll teach it to you. Feel free to write it down if you want. Are you ready?
	stopConversation = "false",
	-- Both options are added by the handler so that s_45 ("Yes, I'm ready.") can point at taught
	-- or too_unskilled according to the player's musicianship, in the order SOE listed them.
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_ask_tune)

diskret_stahn_taught = ConvoScreen:new {
	id = "taught",
	leftDialog = "@conversation/som_diskret_stahn:s_48", -- OK, here goes. Dum da dumm da dum dum dum. Got it? OK, good. Now it's your problem. Har har har.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_taught)

diskret_stahn_too_unskilled = ConvoScreen:new {
	id = "too_unskilled",
	leftDialog = "@conversation/som_diskret_stahn:s_50", -- OK, here goes. Dum da dumm da...hmm. Not following? Maybe you're needing a little more practice with your music first. Come back some other time and maybe you can get it.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_too_unskilled)

--------------------------------------------------------------------------------
-- Return visit, once he has passed the tune on
--------------------------------------------------------------------------------

diskret_stahn_greeting_taught = ConvoScreen:new {
	id = "greeting_taught",
	leftDialog = "@conversation/som_diskret_stahn:s_46", -- Still have that song stuck in your head, do you? Har har har.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_72", "bye_so_long"},  -- So long, cap'n.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_greeting_taught)

--------------------------------------------------------------------------------
-- The narglatch gag
--------------------------------------------------------------------------------

diskret_stahn_narglatch = ConvoScreen:new {
	id = "narglatch",
	leftDialog = "@conversation/som_diskret_stahn:s_78", -- Bah, you're pullin' my leg. There's no such creature that exists.
	stopConversation = "false",
	options = {
		{"@conversation/som_diskret_stahn:s_76", "bye_sorry"},  -- Sorry. Good bye.
	}
}
som_diskret_stahn:addScreen(diskret_stahn_narglatch)

--------------------------------------------------------------------------------
-- Farewells
--------------------------------------------------------------------------------

diskret_stahn_bye_leave = ConvoScreen:new {
	id = "bye_leave",
	leftDialog = "@conversation/som_diskret_stahn:s_19", -- That sounds like a good idea.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_leave)

diskret_stahn_bye_horrible = ConvoScreen:new {
	id = "bye_horrible",
	leftDialog = "@conversation/som_diskret_stahn:s_58", -- Yeah, so long.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_horrible)

diskret_stahn_bye_interest1 = ConvoScreen:new {
	id = "bye_interest1",
	leftDialog = "@conversation/som_diskret_stahn:s_62", -- So long.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_interest1)

diskret_stahn_bye_interest2 = ConvoScreen:new {
	id = "bye_interest2",
	leftDialog = "@conversation/som_diskret_stahn:s_66", -- So long.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_interest2)

diskret_stahn_bye_interest3 = ConvoScreen:new {
	id = "bye_interest3",
	leftDialog = "@conversation/som_diskret_stahn:s_70", -- So long.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_interest3)

diskret_stahn_bye_so_long = ConvoScreen:new {
	id = "bye_so_long",
	leftDialog = "@conversation/som_diskret_stahn:s_74", -- So long.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_so_long)

diskret_stahn_bye_sorry = ConvoScreen:new {
	id = "bye_sorry",
	leftDialog = "@conversation/som_diskret_stahn:s_80", -- Right. You are sorry.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_sorry)

diskret_stahn_bye_nevermind = ConvoScreen:new {
	id = "bye_nevermind",
	leftDialog = "@conversation/som_diskret_stahn:s_54", -- Argh... I'll never get this thing out of my head.
	stopConversation = "true",
	options = {}
}
som_diskret_stahn:addScreen(diskret_stahn_bye_nevermind)

addConversationTemplate("som_diskret_stahn", som_diskret_stahn)

--[[
	Epo Qetora -- the Twi'lek historian who gives som_kenobi_historian_1,
	som_kenobi_historian_smuggler and som_kenobi_historian_2.

	RECONSTRUCTED, THEN CHECKED AGAINST THE LIVE TREE.
	som_kenobi_epo_qetora.stf shipped in the client (string/en/conversation/), but
	the SwgConversationEditor tree that binds those strings into screens did not --
	exactly as with som_kenobi_menth_paul. Every leftDialog and option string below
	is SOE's verbatim text.

	The live wiring has since been read. Most of the reconstruction holds edge for
	edge: both intros, all four rebuffs, both turn-ins, all six armor chains and
	all six weapon chains are live's. Four things were wrong, and each is corrected
	below with the reason it went wrong.

	SEVEN OPENINGS, in the order live tests them, first match wins:

	  s_55   quest two already finished  -> he is busy; nothing on offer
	  s_105  tablet pieces retrieved     -> the quest-two turn-in
	  s_82   quest two running           -> progress
	  s_65   quest one finished          -> the second offer
	  s_85   data disk in hand           -> the quest-one turn-in
	  s_146  quest one running           -> progress
	  s_152  never spoken to him         -> the first offer

	THE FOUR REWARD CHAINS

	The .stf carries four near-duplicate reward chains. They separate by the line
	that CLOSES each chain: each set is complete (one Assault/Battle/Recon, one
	Rifle/Carbine/Pistol) and no closing line spans two sets.

	  armor, "please" set   {s_210 Assault, s_182 Battle, s_183 Recon}
	    all close "Very nice! It was a pleasure working with you, Epo."
	    (s_214 / s_192 / s_198)                 -> offered by s_101
	  armor, bare set       {s_218 Assault, s_226 Battle, s_234 Recon}
	    all close "This could come in handy. Well, good doing business with you."
	    (s_222 / s_230 / s_238)                 -> offered by s_130
	  weapons, warm set     {s_262 Rifle, s_270 Carbine, s_294 Pistol}
	    all close "Thank you for everything. It's been very interesting."
	    (s_266 / s_274 / s_298)                 -> offered by s_138
	  weapons, blunt set    {s_278 Rifle, s_286 Carbine, s_243 Pistol}
	    all close "You could say that again. So I guess our business is
	    concluded?" (s_282 / s_290 / s_258)     -> offered by s_126

	CORRECTING THE TWO ARMOR REWARD SCREENS -- s_101 answers s_97, not s_128

	The two armor sets were hung on the wrong lead-in. The gracious lead-in s_97
	"Don't mention it. I'm glad it's of some help." was given the gracious-sounding
	s_130 "Of course, of course...", and the blunt s_128 "Now there was talk of a
	reward?" was given s_101. Live is the other way round -- 35 s_97 -> s_101,
	43 s_128 -> s_130 -- and the text says so plainly once the lines are read as
	answers instead of as tone. s_101 opens "It very much is.", which answers "I'm
	glad it's of some help" and nothing else. s_130 opens "Of course, of course.",
	which answers "there was talk of a reward?" and nothing else.

	ROOT CAUSE: routing on register instead of on the clause that literally answers
	the option. Both lines end in the same armor question, so their first clause is
	the only thing that tells them apart, and the first clause was skipped in
	favour of how the rest of the paragraph sounded.

	CORRECTING THE TWO QUEST VARIANTS -- "Excellent!" is the smuggler one

	Each intro ends in an "Excellent!" pitch (s_164, s_195) and an otherwise
	identical "Good!" pitch (s_170, s_204), and that pair really is the two .qst
	variants. Which was which had been guessed, and guessed backwards. Live:

	  55 s_162 -> isSmuggler ? s_164 : s_170    56 s_166 -> s_168 giveQuestSmuggler
	                                            58 s_172 -> s_174 giveQuest
	  62 s_191 -> isSmuggler ? s_195 : s_204    63 s_199 -> s_202 giveQuestSmuggler
	                                            65 s_206 -> s_208 giveQuest

	So "Excellent!" grants som_kenobi_historian_smuggler and "Good!" grants
	som_kenobi_historian_1. The grant also fires on the DIRECTIONS reply, not on
	the pitch: a player who reads the pitch and walks away has taken nothing.

	The gate is not slicing skill either. isSmuggler is one line --
	hasSkill(player, "class_smuggler_phase1_novice"). It asks for the profession,
	not for the box that teaches slicing.

	ROOT CAUSE: reading the quest text instead of the branch. The smuggler .qst's
	message box says "with your skills, you will be able to crack it", which is
	about slicing, so slicing became the gate; and the warmer of the two replies
	was assumed to be the commoner path. What a .qst describes is not what the
	conversation tests.

	CORRECTING TWO MISPLACED OPTIONS

	s_211 "I really don't have time for this. Find someone else." was on the
	greeting. Live's greeting, branch 53, has four options -- s_154, s_180, s_219,
	s_227 -- and puts s_211 one screen deeper, in branch 62, as the way out of the
	wry hook s_188. s_176 "something just came up" belongs only to the keen hook
	s_160 (branch 54). Two near-identical brush-offs, one per hook.

	s_98 / s_100 were on the polite quest-two chain. Live ends the polite chain at
	s_80 (24 s_79 -> s_80, terminal, giveQuest2) and continues the curt one past
	s_96 (28 s_94 -> s_96, then 29 s_98 -> s_100, giveQuest2).

	ROOT CAUSE for both: a spare string was hung on the nearest screen that could
	take it, on the strength of the fiction. s_211 reads like a greeting brush-off
	so it went on the greeting; s_98 "I'll get them. Don't worry." reads polite so
	it went on the polite chain. A string with nowhere to go is a hole in the
	reconstruction, and both times the hole was one screen further down.

	s_2 is the empty string and is deliberately unused.
]]

som_kenobi_epo_qetora = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "epo_qetora_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- OPENING -- no historian quest taken yet
--------------------------------------------------------------------------------

epo_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_152", -- Well, hello there. You look like you know your way around dangerous situations.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_154", "intro_polite"},    -- I might be able to. What do you need help with?
		{"@conversation/som_kenobi_epo_qetora:s_180", "intro_wry"},       -- I'm sure of it, but if I want to is a different story.
		{"@conversation/som_kenobi_epo_qetora:s_219", "rebuff_nofighter"},-- I think you're mistaken, friend. I'm no fighter.
		{"@conversation/som_kenobi_epo_qetora:s_227", "rebuff_rude"},     -- Drop dead, trunk head.
	}
}
som_kenobi_epo_qetora:addScreen(epo_greeting)

epo_rebuff_busy = ConvoScreen:new {
	id = "rebuff_busy",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_215", -- Oh well. That's typical. Maybe you could come back later, when you have time?
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_rebuff_busy)

epo_rebuff_nofighter = ConvoScreen:new {
	id = "rebuff_nofighter",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_223", -- My apologies for making such hasty assumptions. Have a splendid day!
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_rebuff_nofighter)

epo_rebuff_rude = ConvoScreen:new {
	id = "rebuff_rude",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_231", -- How rude! You...you rude person!
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_rebuff_rude)

epo_intro_polite = ConvoScreen:new {
	id = "intro_polite",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_156", -- Very kind, my friend. I am Epo Qetora...yes, the famed Twi'lek historian.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_158", "hook_keen"}, -- Really? That's very...interesting.
	}
}
som_kenobi_epo_qetora:addScreen(epo_intro_polite)

epo_intro_wry = ConvoScreen:new {
	id = "intro_wry",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_184", -- A confident one, eh? I like it! I am Epo Qetora...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_186", "hook_bored"}, -- Do I really look like I'm interested in this stuff?
	}
}
som_kenobi_epo_qetora:addScreen(epo_intro_wry)

epo_hook_keen = ConvoScreen:new {
	id = "hook_keen",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_160", -- I agree! ... an old facility has been discovered ... This is where I need your help.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_162", "pitch_keen"},    -- That could actually be something I'm interested in.
		{"@conversation/som_kenobi_epo_qetora:s_176", "decline_intro"}, -- I'm sorry...something just came up. I've got to go.
	}
}
som_kenobi_epo_qetora:addScreen(epo_hook_keen)

epo_hook_bored = ConvoScreen:new {
	id = "hook_bored",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_188", -- Oh, I forgot that not everyone shares my passion. Just hear me out though, please.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_191", "pitch_wry"},  -- That could actually be something I'm interested in.
		-- The wry hook's way out is s_211, not s_176; see CORRECTING TWO
		-- MISPLACED OPTIONS. Live branch 62.
		{"@conversation/som_kenobi_epo_qetora:s_211", "rebuff_busy"}, -- I really don't have time for this. Find someone else.
	}
}
som_kenobi_epo_qetora:addScreen(epo_hook_bored)

epo_decline_intro = ConvoScreen:new {
	id = "decline_intro",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_178", -- Oh well. That's typical. Maybe you could come back later? I'll be here.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_decline_intro)

-- The four pitches, and the pair of screens each one leads to. The "Good!" pitch
-- is the DEFAULT arm and grants som_kenobi_historian_1; the handler swaps in the
-- "Excellent!" twin for a smuggler, and that one grants
-- som_kenobi_historian_smuggler. See CORRECTING THE TWO QUEST VARIANTS -- this
-- was the other way round, and gated on the wrong skill.
--
-- The grant is on the directions reply, which is where live puts it: reading the
-- pitch and leaving takes nothing.

epo_pitch_keen = ConvoScreen:new {
	id = "pitch_keen",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_170", -- Good! Apparently, it belonged to the Old Republic...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_172", "directions_keen"}, -- Sounds good. How do I get there?
	}
}
som_kenobi_epo_qetora:addScreen(epo_pitch_keen)

epo_directions_keen = ConvoScreen:new {
	id = "directions_keen",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_174", -- It's all the way up in the northeast corner of this continent.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_directions_keen)

epo_pitch_keen_smuggler = ConvoScreen:new {
	id = "pitch_keen_smuggler",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_164", -- Excellent! Apparently, it belonged to the Old Republic...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_166", "directions_keen_smuggler"}, -- Sounds good. How do I get there?
	}
}
som_kenobi_epo_qetora:addScreen(epo_pitch_keen_smuggler)

epo_directions_keen_smuggler = ConvoScreen:new {
	id = "directions_keen_smuggler",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_168", -- It's all the way up in the northeast corner of this continent.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_directions_keen_smuggler)

epo_pitch_wry = ConvoScreen:new {
	id = "pitch_wry",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_204", -- Good! Apparently, it belonged to the Old Republic...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_206", "directions_wry"}, -- How fitting. How do I get there?
	}
}
som_kenobi_epo_qetora:addScreen(epo_pitch_wry)

epo_directions_wry = ConvoScreen:new {
	id = "directions_wry",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_208", -- It's all the way up in the northeast corner of this continent.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_directions_wry)

epo_pitch_wry_smuggler = ConvoScreen:new {
	id = "pitch_wry_smuggler",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_195", -- Excellent! Apparently, it belonged to the Old Republic...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_199", "directions_wry_smuggler"}, -- How fitting. How do I get there?
	}
}
som_kenobi_epo_qetora:addScreen(epo_pitch_wry_smuggler)

epo_directions_wry_smuggler = ConvoScreen:new {
	id = "directions_wry_smuggler",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_202", -- It's all the way up in the northeast corner of this continent.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_directions_wry_smuggler)

--------------------------------------------------------------------------------
-- QUEST 1 (historian_1 / historian_smuggler) -- in progress, then turn-in
--------------------------------------------------------------------------------

epo_q1_progress = ConvoScreen:new {
	id = "q1_progress",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_146", -- How can I help, my friend?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_148", "q1_progress_end"}, -- Just making sure there was nothing you forgot to tell me?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q1_progress)

epo_q1_progress_end = ConvoScreen:new {
	id = "q1_progress_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_150", -- No, I think I covered everything. Be careful and good luck!
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q1_progress_end)

epo_q1_turnin = ConvoScreen:new {
	id = "q1_turnin",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_85", -- %TU, you are back! How did everything go?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_89", "q1_thanks_warm"}, -- There wasn't much data left intact but I got what I could.
		{"@conversation/som_kenobi_epo_qetora:s_122", "q1_thanks_curt"},-- Piece of cake. I got out what was left in that dump.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q1_turnin)

epo_q1_thanks_warm = ConvoScreen:new {
	id = "q1_thanks_warm",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_93", -- Let me have a look at that please. Ohh, this is very interesting.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_97", "reward_armor_warm"}, -- Don't mention it. I'm glad it's of some help.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q1_thanks_warm)

epo_q1_thanks_curt = ConvoScreen:new {
	id = "q1_thanks_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_125", -- Let me have a look at that please. Ohh, this is very interesting.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_128", "reward_armor_curt"}, -- That's great. Now there was talk of a reward?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q1_thanks_curt)

-- Gracious reward register: the "please" picks, closing on s_192/s_198/s_214.
epo_reward_armor_warm = ConvoScreen:new {
	id = "reward_armor_warm",
	-- s_101, not s_130: "It very much is." answers s_97. See CORRECTING THE TWO
	-- ARMOR REWARD SCREENS.
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_101", -- It very much is. Now for your reward. ... What type of armor would you like it to be modified for?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_210", "armor_warm_assault"}, -- Assault, please.
		{"@conversation/som_kenobi_epo_qetora:s_182", "armor_warm_battle"},  -- Battle, please.
		{"@conversation/som_kenobi_epo_qetora:s_183", "armor_warm_recon"},   -- Recon, please.
	}
}
som_kenobi_epo_qetora:addScreen(epo_reward_armor_warm)

epo_armor_warm_assault = ConvoScreen:new {
	id = "armor_warm_assault",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_212", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_214", "armor_warm_assault_end"}, -- Very nice! It was a pleasure working with you, Epo.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_assault)

epo_armor_warm_assault_end = ConvoScreen:new {
	id = "armor_warm_assault_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_216", -- The pleasure was all mine, %TU. ... I've got another lead I need help with.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_assault_end)

epo_armor_warm_battle = ConvoScreen:new {
	id = "armor_warm_battle",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_190", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_192", "armor_warm_battle_end"}, -- Very nice! It was a pleasure working with you, Epo.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_battle)

epo_armor_warm_battle_end = ConvoScreen:new {
	id = "armor_warm_battle_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_194", -- The pleasure was all mine, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_battle_end)

epo_armor_warm_recon = ConvoScreen:new {
	id = "armor_warm_recon",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_196", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_198", "armor_warm_recon_end"}, -- Very nice! It was a pleasure working with you, Epo.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_recon)

epo_armor_warm_recon_end = ConvoScreen:new {
	id = "armor_warm_recon_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_200", -- The pleasure was all mine, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_warm_recon_end)

-- Transactional reward register: the bare picks, closing on s_222/s_230/s_238.
epo_reward_armor_curt = ConvoScreen:new {
	id = "reward_armor_curt",
	-- s_130, not s_101: "Of course, of course." answers s_128.
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_130", -- Of course, of course. ... What type of armor would you like it to be modified for?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_218", "armor_curt_assault"}, -- Assault.
		{"@conversation/som_kenobi_epo_qetora:s_226", "armor_curt_battle"},  -- Battle.
		{"@conversation/som_kenobi_epo_qetora:s_234", "armor_curt_recon"},   -- Recon.
	}
}
som_kenobi_epo_qetora:addScreen(epo_reward_armor_curt)

epo_armor_curt_assault = ConvoScreen:new {
	id = "armor_curt_assault",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_220", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_222", "armor_curt_assault_end"}, -- This could come in handy. Well, good doing business with you.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_assault)

epo_armor_curt_assault_end = ConvoScreen:new {
	id = "armor_curt_assault_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_224", -- The pleasure was all mine, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_assault_end)

epo_armor_curt_battle = ConvoScreen:new {
	id = "armor_curt_battle",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_228", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_230", "armor_curt_battle_end"}, -- This could come in handy. Well, good doing business with you.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_battle)

epo_armor_curt_battle_end = ConvoScreen:new {
	id = "armor_curt_battle_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_232", -- The pleasure was all mine, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_battle_end)

epo_armor_curt_recon = ConvoScreen:new {
	id = "armor_curt_recon",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_236", -- Certainly. Here we go. All yours!.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_238", "armor_curt_recon_end"}, -- This could come in handy. Well, good doing business with you.
	}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_recon)

epo_armor_curt_recon_end = ConvoScreen:new {
	id = "armor_curt_recon_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_240", -- The pleasure was all mine, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_armor_curt_recon_end)

--------------------------------------------------------------------------------
-- QUEST 2 (historian_2) -- offer, in progress, turn-in
--------------------------------------------------------------------------------

epo_q2_offer = ConvoScreen:new {
	id = "q2_offer",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_65", -- Great to see you again, %TU! I could use your assistance again...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_66", "q2_tablet_polite"}, -- I was hoping you would say that. How can I help, Epo?
		{"@conversation/som_kenobi_epo_qetora:s_67", "q2_tablet_curt"},   -- Why else would I be here? Your charming personality?
		{"@conversation/som_kenobi_epo_qetora:s_68", "q2_brushoff"},      -- I'm sorry, Epo. Just stopped by to say hi.
		{"@conversation/som_kenobi_epo_qetora:s_69", "q2_snub"},          -- For you, I have about 10 seconds...and they just ran out.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_offer)

epo_q2_brushoff = ConvoScreen:new {
	id = "q2_brushoff",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_71", -- Well, that's typical. If you free up some time later, make sure to stop by.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_brushoff)

epo_q2_snub = ConvoScreen:new {
	id = "q2_snub",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_81", -- Haha, always such a charmer, %TU. Well, you take care then!
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_snub)

epo_q2_tablet_polite = ConvoScreen:new {
	id = "q2_tablet_polite",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_72", -- While you were up retrieving the data log ... a piece of an old tablet...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_73", "q2_figures_polite"}, -- Did you try to find the other pieces?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_tablet_polite)

epo_q2_figures_polite = ConvoScreen:new {
	id = "q2_figures_polite",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_74", -- Indeed I did, but ... I spotted some skulking figures moving around the area...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_75", "q2_reassure"},       -- Probably just some scavengers. Shouldn't be a problem.
		{"@conversation/som_kenobi_epo_qetora:s_76", "q2_decline_polite"}, -- I don't have the time to venture out there right now, I'm afraid.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_figures_polite)

epo_q2_decline_polite = ConvoScreen:new {
	id = "q2_decline_polite",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_77", -- That is too bad, my friend. Maybe you'll get some time later?
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_decline_polite)

epo_q2_reassure = ConvoScreen:new {
	id = "q2_reassure",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_78", -- For you? I'm sure not. Please be careful still, though.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_79", "q2_grant_polite"}, -- Don't worry. I will be.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_reassure)

-- The polite chain ends here. s_98 / s_100 are the curt chain's tail, not this
-- one's; see CORRECTING TWO MISPLACED OPTIONS.
epo_q2_grant_polite = ConvoScreen:new {
	id = "q2_grant_polite",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_80", -- Good, I hope you can find the pieces. ... there will be four more of them.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_grant_polite)

epo_q2_tablet_curt = ConvoScreen:new {
	id = "q2_tablet_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_88", -- Umm...anyway, while you were up retrieving the data log...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_90", "q2_figures_curt"}, -- Didn't occur to you to look for the other pieces while you were there?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_tablet_curt)

epo_q2_figures_curt = ConvoScreen:new {
	id = "q2_figures_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_92", -- Indeed it did, but ... I spotted some skulking figures...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_94", "q2_grant_curt"},   -- Probably just some filthy scavengers. I'll handle them.
		{"@conversation/som_kenobi_epo_qetora:s_102", "q2_decline_curt"},-- Right now, I have some more important things to do. Maybe later.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_figures_curt)

epo_q2_decline_curt = ConvoScreen:new {
	id = "q2_decline_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_104", -- That is too bad, my friend. Maybe you'll get some time later?
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_decline_curt)

-- The curt chain runs one screen longer than the polite one: s_96 is a branch,
-- not an ending, and the quest is granted on s_100.
epo_q2_grant_curt = ConvoScreen:new {
	id = "q2_grant_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_96", -- I'm sure you will... Don't forget about the tablet pieces, though.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_98", "q2_curt_end"}, -- I'll get them. Don't worry.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_grant_curt)

epo_q2_curt_end = ConvoScreen:new {
	id = "q2_curt_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_100", -- You haven't disappointed me so far, %TU. I'm not worried.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_curt_end)

epo_q2_progress = ConvoScreen:new {
	id = "q2_progress",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_82", -- How can I help you, my friend?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_84", "q2_progress_end"}, -- Just making sure there was nothing you forgot to tell me?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_progress)

epo_q2_progress_end = ConvoScreen:new {
	id = "q2_progress_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_86", -- No, I think I covered everything. Be careful and good luck!
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_q2_progress_end)

epo_q2_turnin = ConvoScreen:new {
	id = "q2_turnin",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_105", -- %TU! Please tell me you've had some luck.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_106", "q2_thanks_warm"}, -- Sorry to hear that. Yes, I do believe I have all the pieces.
		{"@conversation/som_kenobi_epo_qetora:s_107", "q2_thanks_curt"}, -- Yeah, I care. Here's your tablets. Where's my reward?
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_turnin)

epo_q2_thanks_warm = ConvoScreen:new {
	id = "q2_thanks_warm",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_108", -- You know how to make an old man happy, my friend. ... Give me a minute.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_134", "reward_weapon_warm"}, -- Thanks! I am curious as to what it will say.
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_thanks_warm)

epo_q2_thanks_curt = ConvoScreen:new {
	id = "q2_thanks_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_109", -- Your tough attitude really doesn't suit you, %TU. ... Give me a minute.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_124", "reward_weapon_curt"}, -- That better not be my only reward...
	}
}
som_kenobi_epo_qetora:addScreen(epo_q2_thanks_curt)

-- Warm weapon register: closes on s_266/s_274/s_298.
epo_reward_weapon_warm = ConvoScreen:new {
	id = "reward_weapon_warm",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_138", -- I bet, after all the trouble you've gone through. ... a rifle, carbine, or pistol?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_262", "weapon_warm_rifle"},   -- Rifle sounds good.
		{"@conversation/som_kenobi_epo_qetora:s_270", "weapon_warm_carbine"}, -- Carbine sounds good.
		{"@conversation/som_kenobi_epo_qetora:s_294", "weapon_warm_pistol"},  -- Pistol sounds good.
	}
}
som_kenobi_epo_qetora:addScreen(epo_reward_weapon_warm)

epo_weapon_warm_rifle = ConvoScreen:new {
	id = "weapon_warm_rifle",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_264", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_266", "weapon_warm_rifle_end"}, -- Thank you for everything. It's been very interesting.
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_rifle)

epo_weapon_warm_rifle_end = ConvoScreen:new {
	id = "weapon_warm_rifle_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_268", -- I'm glad to hear that, %TU. ... this concludes our business, for now at least.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_rifle_end)

epo_weapon_warm_carbine = ConvoScreen:new {
	id = "weapon_warm_carbine",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_272", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_274", "weapon_warm_carbine_end"}, -- Thank you for everything. It's been very interesting.
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_carbine)

epo_weapon_warm_carbine_end = ConvoScreen:new {
	id = "weapon_warm_carbine_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_276", -- I'm glad to hear that, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_carbine_end)

epo_weapon_warm_pistol = ConvoScreen:new {
	id = "weapon_warm_pistol",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_296", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_298", "weapon_warm_pistol_end"}, -- Thank you for everything. It's been very interesting.
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_pistol)

epo_weapon_warm_pistol_end = ConvoScreen:new {
	id = "weapon_warm_pistol_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_300", -- I'm glad to hear that, %TU. ...
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_warm_pistol_end)

-- Blunt weapon register: closes on s_258/s_282/s_290.
epo_reward_weapon_curt = ConvoScreen:new {
	id = "reward_weapon_curt",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_126", -- Of course not, silly. I've come across a stash of weapons...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_278", "weapon_curt_rifle"},   -- Rifle sounds good.
		{"@conversation/som_kenobi_epo_qetora:s_286", "weapon_curt_carbine"}, -- Carbine sounds good.
		{"@conversation/som_kenobi_epo_qetora:s_243", "weapon_curt_pistol"},  -- Pistol sounds good.
	}
}
som_kenobi_epo_qetora:addScreen(epo_reward_weapon_curt)

epo_weapon_curt_rifle = ConvoScreen:new {
	id = "weapon_curt_rifle",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_280", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_282", "weapon_curt_rifle_end"}, -- You could say that again. So I guess our business is concluded?
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_rifle)

epo_weapon_curt_rifle_end = ConvoScreen:new {
	id = "weapon_curt_rifle_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_284", -- Yes indeed, for now at least. Take care of yourself, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_rifle_end)

epo_weapon_curt_carbine = ConvoScreen:new {
	id = "weapon_curt_carbine",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_288", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_290", "weapon_curt_carbine_end"}, -- You could say that again. So I guess our business is concluded?
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_carbine)

epo_weapon_curt_carbine_end = ConvoScreen:new {
	id = "weapon_curt_carbine_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_292", -- Yes indeed, for now at least. Take care of yourself, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_carbine_end)

epo_weapon_curt_pistol = ConvoScreen:new {
	id = "weapon_curt_pistol",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_256", -- Not a problem. Here you go.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_epo_qetora:s_258", "weapon_curt_pistol_end"}, -- You could say that again. So I guess our business is concluded?
	}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_pistol)

epo_weapon_curt_pistol_end = ConvoScreen:new {
	id = "weapon_curt_pistol_end",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_260", -- Yes indeed, for now at least. Take care of yourself, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_weapon_curt_pistol_end)

--------------------------------------------------------------------------------
-- BOTH QUESTS DONE
--------------------------------------------------------------------------------

epo_all_done = ConvoScreen:new {
	id = "all_done",
	leftDialog = "@conversation/som_kenobi_epo_qetora:s_55", -- Good to see you, %TU! Unfortunately, you've caught me at a bad time.
	stopConversation = "true",
	options = {}
}
som_kenobi_epo_qetora:addScreen(epo_all_done)

addConversationTemplate("som_kenobi_epo_qetora", som_kenobi_epo_qetora)

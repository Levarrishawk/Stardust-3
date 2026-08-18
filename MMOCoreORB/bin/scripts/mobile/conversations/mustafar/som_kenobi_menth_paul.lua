--[[
	Menth Paul -- the man who sells you the cursed shard.

	SOURCE OF RECORD
	  string/en/conversation/som_kenobi_menth_paul.stf ships in the SOE Mustafar
	  content and carries 40 strings.  The .stf is a flat list -- SOE's
	  SwgConversationEditor tree that wired those strings together was never
	  shipped, so the branching below is reconstructed from the strings alone.
	  The reconstruction uses every shipped string except s_2, which is empty.

	  The strings come in four near-duplicate story blocks (s_142/146/150,
	  s_127 group, s_165/169/173, s_213/217/221).  All four tell the same
	  blue-glowing-man story with different player prompts, which is what a
	  conversation editor produces when the same beat is reachable down four
	  different paths.  That is why the tree has four story runs: two under the
	  short pitch (s_118) and two under the long pitch (s_161), each with a
	  1000-credit and a 500-credit ending.

	  The price endings are what SOE's four "accept" and four "no money"
	  strings imply:
	    s_156 / s_154  accept at 1000, short pitch
	    s_132 / s_134  accept at  500, short pitch (after he haggles himself down)
	    s_179 / s_177  accept at 1000, long pitch
	    s_227 / s_225  accept at  500, long pitch
	  and the four "take it for free" strings (s_160, s_133, s_183, s_231) let a
	  player who refuses the price get the shard for nothing.  He is desperate;
	  every road ends with him handing it over.

	  The handler (menth_paul_conv_handler) owns the money: it checks credits,
	  redirects to the matching no_money screen when the player is short, and
	  subtracts on success.  See that file for the redirect list.

	QUEST
	  Accepting the shard starts quest/som_kenobi_cursed_shard_1, run by
	  screenplays/mustafar/quest/cursed_shard.lua.  That .qst is Level 75, so
	  s_72 ("I wish you were more experienced...") is used as the level gate --
	  it is the only string in the file that fits nothing else.

	  s_136/s_137/s_138/s_139/s_140 are the mid-quest state: the player tries to
	  hand the shard back and he refuses it.  s_67 is the post-quest state.
]]

som_kenobi_menth_paul = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "menth_paul_conv_handler",
	screens = {}
}

------------------------------------------------------------------------------
-- opening
------------------------------------------------------------------------------

menth_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_110", -- Please, help me... I have to get off this planet.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_111", "trying"},         -- Why don't you just take the shuttle then friend?
		{"@conversation/som_kenobi_menth_paul:s_112", "pitch_sell"},     -- And what do you want from me?
		{"@conversation/som_kenobi_menth_paul:s_114", "lost_everything"},-- What do I look like, a shuttle ticket vendor?
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_greeting)

menth_trying = ConvoScreen:new {
	id = "trying",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_232", -- I'm trying to...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_112", "pitch_explain"},  -- And what do you want from me?
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_trying)

menth_lost_everything = ConvoScreen:new {
	id = "lost_everything",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_115", -- Please... I've lost everything...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_112", "pitch_explain"},  -- And what do you want from me?
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_lost_everything)

menth_come_back = ConvoScreen:new {
	id = "come_back",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_116", -- Will you come back? I've lost everything. I need some help...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_117", "bye_plea"},       -- Yeah, I might. You hang in there, friend.
	}
}
som_kenobi_menth_paul:addScreen(menth_come_back)

menth_bye_plea = ConvoScreen:new {
	id = "bye_plea",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_135", -- Please, help me... I need to get off this planet.
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_bye_plea)

------------------------------------------------------------------------------
-- short pitch (s_118) -- he opens at 1000 credits
------------------------------------------------------------------------------

menth_pitch_sell = ConvoScreen:new {
	id = "pitch_sell",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_118", -- I need to sell this crystal. Please, only a thousand credits and this beautiful shard could be yours.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_119", "story_c1"},       -- Interesting. It's all black. I might want it. Where'd you find it?
		{"@conversation/som_kenobi_menth_paul:s_120", "haggle_500"},     -- A thousand credits for a piece of glass? I don't think so.
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_pitch_sell)

menth_story_c1 = ConvoScreen:new {
	id = "story_c1",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_142", -- You wouldn't believe me if I told you.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_144", "story_c2"},       -- Try me.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_c1)

menth_story_c2 = ConvoScreen:new {
	id = "story_c2",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_146", -- I came to this place in hopes of finding fortune... a man covered in strange blue glowing dust...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_148", "story_c3"},       -- If it's so beautiful, why are you trying to get rid of it?
	}
}
som_kenobi_menth_paul:addScreen(menth_story_c2)

menth_story_c3 = ConvoScreen:new {
	id = "story_c3",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_150", -- I've had nothing but bad luck lately and I've lost everything. I need the credits to be able to get back home...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_152", "accept_1000"},    -- Fine, we said a thousand credits right?
		{"@conversation/som_kenobi_menth_paul:s_158", "free_1000"},      -- A thousand credits is too much though.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_c3)

-- handler redirects here from accept_1000 when the player cannot pay
menth_no_money_1000 = ConvoScreen:new {
	id = "no_money_1000",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_154", -- You don't have the money on you? Please, go get them now!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_no_money_1000)

menth_accept_1000 = ConvoScreen:new {
	id = "accept_1000",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_156", -- Right, right. Here you go. Take it now. Please.
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_accept_1000)

menth_free_1000 = ConvoScreen:new {
	id = "free_1000",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_160", -- Then take it for free! Just take the darn thing!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_free_1000)

------------------------------------------------------------------------------
-- short pitch, haggled down (s_121) -- 500 credits
------------------------------------------------------------------------------

menth_haggle_500 = ConvoScreen:new {
	id = "haggle_500",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_121", -- Please, I beg of you. I'll go with 500 credits, please. Just take it.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_122", "denies"},         -- You're acting like it has the plague. Did you steal it?
	}
}
som_kenobi_menth_paul:addScreen(menth_haggle_500)

menth_denies = ConvoScreen:new {
	id = "denies",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_123", -- No no, I found it...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_124", "story_d1"},       -- Where?
	}
}
som_kenobi_menth_paul:addScreen(menth_denies)

menth_story_d1 = ConvoScreen:new {
	id = "story_d1",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_125", -- You wouldn't believe me if I told you.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_126", "story_d2"},       -- Try me.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_d1)

menth_story_d2 = ConvoScreen:new {
	id = "story_d2",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_127", -- I came to this place in hopes of finding fortune... a man covered in strange blue glowing dust...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_128", "story_d3"},       -- If it's so beautiful, why are you trying to get rid of it?
	}
}
som_kenobi_menth_paul:addScreen(menth_story_d2)

menth_story_d3 = ConvoScreen:new {
	id = "story_d3",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_129", -- I've had nothing but bad luck lately and I've lost everything. I need the credits to be able to get back home...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_130", "accept_500"},     -- Fine, 500 credits we said right?
		{"@conversation/som_kenobi_menth_paul:s_131", "free_500"},       -- 500 credits is too much though.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_d3)

-- handler redirects here from accept_500 when the player cannot pay
menth_no_money_500 = ConvoScreen:new {
	id = "no_money_500",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_134", -- You don't have the money on you? Please, go get it now!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_no_money_500)

menth_accept_500 = ConvoScreen:new {
	id = "accept_500",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_132", -- Right, right. Here you go. Take it now. Please.
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_accept_500)

menth_free_500 = ConvoScreen:new {
	id = "free_500",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_133", -- Then take it for free! Just take the darn thing!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_free_500)

------------------------------------------------------------------------------
-- long pitch (s_161) -- reached by asking him what he wants after he explains
------------------------------------------------------------------------------

menth_pitch_explain = ConvoScreen:new {
	id = "pitch_explain",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_161", -- I've had a string of bad luck and lost everything... for the cheap price of a thousand credits.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_162", "story_a1"},       -- It looks very nice. Where did you find it?
		{"@conversation/som_kenobi_menth_paul:s_163", "drop_500"},       -- A thousand credits is a little steep...
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_pitch_explain)

menth_story_a1 = ConvoScreen:new {
	id = "story_a1",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_165", -- You wouldn't believe me if I told you.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_167", "story_a2"},       -- I'm very open-minded.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_a1)

menth_story_a2 = ConvoScreen:new {
	id = "story_a2",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_169", -- I came to this place in hopes of finding fortune... a man covered in strange blue glowing dust...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_171", "story_a3"},       -- And now you're trying to sell it?
	}
}
som_kenobi_menth_paul:addScreen(menth_story_a2)

menth_story_a3 = ConvoScreen:new {
	id = "story_a3",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_173", -- I've had nothing but bad luck lately and I've lost everything. I need the credits to be able to get back home...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_175", "accept_1000b"},   -- Alright, I'll help you. We said a thousand credits, right?
		{"@conversation/som_kenobi_menth_paul:s_181", "free_1000b"},     -- A thousand credits is still a bit too much, though.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_a3)

-- handler redirects here from accept_1000b when the player cannot pay
menth_no_money_1000b = ConvoScreen:new {
	id = "no_money_1000b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_177", -- You don't have the money on you? Please, go get it now!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_no_money_1000b)

menth_accept_1000b = ConvoScreen:new {
	id = "accept_1000b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_179", -- Indeed we did. Here you go. All yours.
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_accept_1000b)

menth_free_1000b = ConvoScreen:new {
	id = "free_1000b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_183", -- Then take it for free! Just take it, please!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_free_1000b)

------------------------------------------------------------------------------
-- long pitch, dropped to 500 (s_185)
------------------------------------------------------------------------------

menth_drop_500 = ConvoScreen:new {
	id = "drop_500",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_185", -- Fine, fine. I'll go down to 500 credits.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_187", "story_b1"},       -- Hmm, maybe. Where did you find it?
	}
}
som_kenobi_menth_paul:addScreen(menth_drop_500)

menth_story_b1 = ConvoScreen:new {
	id = "story_b1",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_213", -- You wouldn't believe me if I told you.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_215", "story_b2"},       -- I'm very open-minded.
	}
}
som_kenobi_menth_paul:addScreen(menth_story_b1)

menth_story_b2 = ConvoScreen:new {
	id = "story_b2",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_217", -- I came to this place in hopes of finding fortune... a man covered in strange blue glowing dust...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_219", "story_b3"},       -- And now you're trying to sell it?
	}
}
som_kenobi_menth_paul:addScreen(menth_story_b2)

menth_story_b3 = ConvoScreen:new {
	id = "story_b3",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_221", -- I've had nothing but bad luck lately and I've lost everything. I need the credits to be able to get back home...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_223", "accept_500b"},    -- Very well. We said 500 right?
		{"@conversation/som_kenobi_menth_paul:s_229", "free_500b"},      -- 500 credits is still a lot of money though...
	}
}
som_kenobi_menth_paul:addScreen(menth_story_b3)

-- handler redirects here from accept_500b when the player cannot pay
menth_no_money_500b = ConvoScreen:new {
	id = "no_money_500b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_225", -- You don't have the money on you? Please, go get it now!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_no_money_500b)

menth_accept_500b = ConvoScreen:new {
	id = "accept_500b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_227", -- We sure did. Here you go, friend. Enjoy!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_accept_500b)

menth_free_500b = ConvoScreen:new {
	id = "free_500b",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_231", -- Then take it for free! Just take the darn thing!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_free_500b)

------------------------------------------------------------------------------
-- states the handler opens on
------------------------------------------------------------------------------

-- below the .qst's Level 75 requirement
menth_too_low = ConvoScreen:new {
	id = "too_low",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_72", -- I wish you were more experienced... I could really use some help.
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_too_low)

-- player already carries the shard: he will not take it back
menth_in_progress = ConvoScreen:new {
	id = "in_progress",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_136", -- What do you want..?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_menth_paul:s_137", "refuse_back"},    -- I was wondering if you would like your crystal back?
		{"@conversation/som_kenobi_menth_paul:s_138", "refuse_evil"},    -- I'm here to give your crystal back.
		{"@conversation/som_kenobi_menth_paul:s_113", "come_back"},      -- I'm sorry. I have some things I have to attend to right now.
	}
}
som_kenobi_menth_paul:addScreen(menth_in_progress)

menth_refuse_back = ConvoScreen:new {
	id = "refuse_back",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_139", -- No way! It's all yours now. I don't want that blasted thing back!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_refuse_back)

menth_refuse_evil = ConvoScreen:new {
	id = "refuse_evil",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_140", -- I'm not taking that! The thing is evil!
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_refuse_evil)

-- the shard is gone and his luck has turned
menth_finished = ConvoScreen:new {
	id = "finished",
	leftDialog = "@conversation/som_kenobi_menth_paul:s_67", -- Yeah, I know. I'm still here. Since you took the crystal, my luck sure has turned!...
	stopConversation = "true",
	options = {}
}
som_kenobi_menth_paul:addScreen(menth_finished)

addConversationTemplate("som_kenobi_menth_paul", som_kenobi_menth_paul)

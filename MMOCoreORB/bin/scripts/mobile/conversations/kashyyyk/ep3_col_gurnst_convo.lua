-- Colonel Gurnst -- ep3_kachirho_kill_wke
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_col_gurnst_convo = ConvoTemplate:new {
	initialScreen = "s_150",
	templateType = "Lua",
	luaClassHandler = "ep3_col_gurnst_conv_handler",
	screens = {}
}

ep3_col_gurnst_convo_s_124 = ConvoScreen:new {
	id = "s_124",
	animation = "pose_proudly",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_124", -- Well if it isn't my favorite tourist. You back to do some more Wookiee hunting or did you just miss me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_126", "s_128"},
		{"@conversation/ep3_kachirho_col_gurnst:s_130", "s_132"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_124)

ep3_col_gurnst_convo_s_134 = ConvoScreen:new {
	id = "s_134",
	animation = "pose_proudly",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_134", -- I take it from that big grin on your face that the job is done. Those Wookiees should have known better then to mess with someone like you. Good job, bub.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_136", "s_138"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_134)

ep3_col_gurnst_convo_s_148 = ConvoScreen:new {
	id = "s_148",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_148", -- Maybe you didn't hear me clearly the first time. I hired you to go out and kill fifteen of those Wookiee resistance members. Until you have accomplished that...
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_148)

ep3_col_gurnst_convo_s_150 = ConvoScreen:new {
	id = "s_150",
	animation = "pose_proudly",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_150", -- So, what will it be bub? Are you here looking for adventure or are you just going to walk around and smell the pretty flowers? If it is the prior then maybe ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_152", "s_154"},
		{"@conversation/ep3_kachirho_col_gurnst:s_188", "s_190"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_150)

ep3_col_gurnst_convo_s_128 = ConvoScreen:new {
	id = "s_128",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_128", -- Right. Same deal as before. You hunt down and kill fifteen members of the Wookiee resistance and I pay you a bounty. Well? Get moving, bub.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_128)

ep3_col_gurnst_convo_s_132 = ConvoScreen:new {
	id = "s_132",
	animation = "refuse_offer_affection",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_132", -- Don't get all mushy on me or anything. I don't have time to chat with anyone who is just standing around gawking.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_132)

ep3_col_gurnst_convo_s_138 = ConvoScreen:new {
	id = "s_138",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_138", -- Yeah, I suppose you want to get paid. Well here you go, bub. If you are interested there are still more Wookiees that need a lesson taught to them. Same deal...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_140", "s_142"},
		{"@conversation/ep3_kachirho_col_gurnst:s_144", "s_146"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_138)

ep3_col_gurnst_convo_s_142 = ConvoScreen:new {
	id = "s_142",
	animation = "snap_finger1",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_142", -- That's the spirit. I figured you had a mean streak in you a click wide. Don't just stand there...get moving! Those Wookiees are not going to kill themselves ...
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_142)

ep3_col_gurnst_convo_s_146 = ConvoScreen:new {
	id = "s_146",
	animation = "check_wrist_device",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_146", -- Your choice. If you change your mind come back and see me.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_146)

ep3_col_gurnst_convo_s_154 = ConvoScreen:new {
	id = "s_154",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_154", -- Kashyyyk has a problem. And that problem is that the natives don't seem to understand their defined role. That is why I am here. I am putting together a task...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_156", "s_158"},
		{"@conversation/ep3_kachirho_col_gurnst:s_186", "s_166"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_154)

ep3_col_gurnst_convo_s_158 = ConvoScreen:new {
	id = "s_158",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_158", -- The Empire, of course. They are not interested in sending valuable soldiers all the way out here to help squelch this resistance but at the same time they ca...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_160", "s_162"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_158)

ep3_col_gurnst_convo_s_162 = ConvoScreen:new {
	id = "s_162",
	animation = "point_to_self",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_162", -- I am a merc, bub. I work for credits not for some misplaced ideal of those soldier boys. Now I don't have all day for chit-chat. You in or are you out?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_164", "s_166"},
		{"@conversation/ep3_kachirho_col_gurnst:s_182", "s_184"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_162)

ep3_col_gurnst_convo_s_166 = ConvoScreen:new {
	id = "s_166",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_166", -- Ok, then. If you are interested in working for me, you are going to head out and liquidate members of the Wookiee resistance. You eliminate the problem and I...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_168", "s_170"},
		{"@conversation/ep3_kachirho_col_gurnst:s_180", "s_184"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_166)

ep3_col_gurnst_convo_s_170 = ConvoScreen:new {
	id = "s_170",
	animation = "snap_finger1",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_170", -- By the powers invested in me...blah, blah, blah...you are now authorized to kill members of the Wookiee resistance. For every fifteen of those bums you kill ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_col_gurnst:s_172", "s_174"},
		{"@conversation/ep3_kachirho_col_gurnst:s_176", "s_178"},
	}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_170)

ep3_col_gurnst_convo_s_174 = ConvoScreen:new {
	id = "s_174",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_174", -- If we knew that they would be dead already. All I know is that there are rumors of them operating somewhere in the area around Kachirho. Now beat it bub, you...
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_174)

ep3_col_gurnst_convo_s_178 = ConvoScreen:new {
	id = "s_178",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_178", -- Good, I like people who don't ask very many questions.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_178)

ep3_col_gurnst_convo_s_184 = ConvoScreen:new {
	id = "s_184",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_184", -- Well then just move along, bub. You are cramping my style.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_184)

ep3_col_gurnst_convo_s_190 = ConvoScreen:new {
	id = "s_190",
	leftDialog = "@conversation/ep3_kachirho_col_gurnst:s_190", -- Better get used to it, bub. Kashyyyk isn't the type of place where people can afford to be all nice and polite. Now run along, greenhorn.
	stopConversation = "true",
	options = {}
}
ep3_col_gurnst_convo:addScreen(ep3_col_gurnst_convo_s_190)

addConversationTemplate("ep3_col_gurnst_convo", ep3_col_gurnst_convo)

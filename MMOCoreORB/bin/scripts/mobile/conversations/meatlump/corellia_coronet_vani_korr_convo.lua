-- corellia_coronet_vani_korr
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

corellia_coronet_vani_korr_convo = ConvoTemplate:new {
	initialScreen = "s_135",
	templateType = "Lua",
	luaClassHandler = "corellia_coronet_vani_korr_conv_handler",
	screens = {}
}

corellia_coronet_vani_korr_convo_s_161 = ConvoScreen:new {
	id = "s_161",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_161", -- returning 07
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_189", "s_190"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_161)

corellia_coronet_vani_korr_convo_s_190 = ConvoScreen:new {
	id = "s_190",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_190", -- hideout pointer after 07
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_190)

corellia_coronet_vani_korr_convo_s_160 = ConvoScreen:new {
	id = "s_160",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_160", -- active 07
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_160)

corellia_coronet_vani_korr_convo_s_159 = ConvoScreen:new {
	id = "s_159",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_159", -- active 06
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_159)

corellia_coronet_vani_korr_convo_s_158 = ConvoScreen:new {
	id = "s_158",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_158", -- active 05
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_158)

corellia_coronet_vani_korr_convo_s_152 = ConvoScreen:new {
	id = "s_152",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_152", -- returning 04
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_154", "s_155"},
		{"@conversation/corellia_coronet_vani_korr:s_156", "s_157"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_152)

corellia_coronet_vani_korr_convo_s_155 = ConvoScreen:new {
	id = "s_155",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_155", -- grant 05
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_155)

corellia_coronet_vani_korr_convo_s_157 = ConvoScreen:new {
	id = "s_157",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_157", -- decline 05
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_157)

corellia_coronet_vani_korr_convo_s_153 = ConvoScreen:new {
	id = "s_153",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_153", -- active 04
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_153)

corellia_coronet_vani_korr_convo_s_195 = ConvoScreen:new {
	id = "s_195",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_195", -- grant 04 pointer
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_195)

corellia_coronet_vani_korr_convo_s_151 = ConvoScreen:new {
	id = "s_151",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_151", -- active 03
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_151)

corellia_coronet_vani_korr_convo_s_146 = ConvoScreen:new {
	id = "s_146",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_146", -- returning 02
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_147", "s_148"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_146)

corellia_coronet_vani_korr_convo_s_148 = ConvoScreen:new {
	id = "s_148",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_148", -- grant 03 lead-in
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_149", "s_150"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_148)

corellia_coronet_vani_korr_convo_s_150 = ConvoScreen:new {
	id = "s_150",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_150", -- grant 03
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_150)

corellia_coronet_vani_korr_convo_s_145 = ConvoScreen:new {
	id = "s_145",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_145", -- active 02
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_145)

corellia_coronet_vani_korr_convo_s_142 = ConvoScreen:new {
	id = "s_142",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_142", -- returning 01
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_143", "s_144"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_142)

corellia_coronet_vani_korr_convo_s_144 = ConvoScreen:new {
	id = "s_144",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_144", -- grant 02
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_144)

corellia_coronet_vani_korr_convo_s_141 = ConvoScreen:new {
	id = "s_141",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_141", -- active 01
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_141)

corellia_coronet_vani_korr_convo_s_135 = ConvoScreen:new {
	id = "s_135",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_135", -- ready for hideout
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_136", "s_126"},
		{"@conversation/corellia_coronet_vani_korr:s_137", "s_138"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_135)

corellia_coronet_vani_korr_convo_s_126 = ConvoScreen:new {
	id = "s_126",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_126", -- accept 01 lead-in
	stopConversation = false,
	options = {
		{"@conversation/corellia_coronet_vani_korr:s_139", "s_140"},
	}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_126)

corellia_coronet_vani_korr_convo_s_140 = ConvoScreen:new {
	id = "s_140",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_140", -- grant 01
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_140)

corellia_coronet_vani_korr_convo_s_138 = ConvoScreen:new {
	id = "s_138",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_138", -- decline 01
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_138)

corellia_coronet_vani_korr_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_37", -- completed act1 under 55 / default hold
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_37)

corellia_coronet_vani_korr_convo_s_191 = ConvoScreen:new {
	id = "s_191",
	leftDialog = "@conversation/corellia_coronet_vani_korr:s_191", -- has hideout pointer
	stopConversation = true,
	options = {}
}
corellia_coronet_vani_korr_convo:addScreen(corellia_coronet_vani_korr_convo_s_191)

addConversationTemplate("corellia_coronet_vani_korr_convo", corellia_coronet_vani_korr_convo)

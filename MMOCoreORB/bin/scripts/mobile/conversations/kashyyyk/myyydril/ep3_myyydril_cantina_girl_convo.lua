-- ep3_myyydril_cantina_girl
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_cantina_girl_convo = ConvoTemplate:new {
	initialScreen = "s_300",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_cantina_girl_conv_handler",
	screens = {}
}

ep3_myyydril_cantina_girl_convo_s_89 = ConvoScreen:new {
	id = "s_89",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_89", -- Them be ugly boogers. Got a brain as a body, with sharp, pointy claws. Scares the poodoo right outta ya. I suggest ye be stayin' away fro...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_94", "s_96"},
		{"@conversation/ep3_myyydril_cantina_girl:s_98", "s_100"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_89)

ep3_myyydril_cantina_girl_convo_s_96 = ConvoScreen:new {
	id = "s_96",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_96", -- The Myyydril, huh? Welp. Let me see. There's not much to say, really. The Myyydril were thrown out o'the Kerritamba village a long time a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_163", "s_164"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_96)

ep3_myyydril_cantina_girl_convo_s_100 = ConvoScreen:new {
	id = "s_100",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_100", -- Iffin' yer not careful, I'd say a bit'o death. Urnies be bad things. Stay away from them.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_100)

ep3_myyydril_cantina_girl_convo_s_104 = ConvoScreen:new {
	id = "s_104",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_104", -- Iffin' yer not careful, I'd say a bit'o death. Urnies be bad things. Stay away from them.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_106", "s_108"},
		{"@conversation/ep3_myyydril_cantina_girl:s_110", "s_112"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_104)

ep3_myyydril_cantina_girl_convo_s_108 = ConvoScreen:new {
	id = "s_108",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_108", -- The Urnsor'is. Them be ugly boogers. Got a brain as a body, with sharp, pointy claws. Scares the poodoo right outta ya. I suggest ye be s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_175", "s_176"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_108)

ep3_myyydril_cantina_girl_convo_s_112 = ConvoScreen:new {
	id = "s_112",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_112", -- The Myyydril, huh? Welp. Let me see. There's not much to say, really. The Myyydril were thrown out o'the Kerritamba village a long time a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_185", "s_186"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_112)

ep3_myyydril_cantina_girl_convo_s_154 = ConvoScreen:new {
	id = "s_154",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_154", -- Ain't tha' the truth. Ye be needin' anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_155", "s_161"},
		{"@conversation/ep3_myyydril_cantina_girl:s_157", "s_159"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_154)

ep3_myyydril_cantina_girl_convo_s_159 = ConvoScreen:new {
	id = "s_159",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_159", -- Iffin' yer not careful, I'd say a bit'o death. Urnies be bad things. Stay away from them. I wish I had more ta say.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_160", "s_162"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_159)

ep3_myyydril_cantina_girl_convo_s_161 = ConvoScreen:new {
	id = "s_161",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_161", -- [Kirrir nods.] Aye. Ye best be careful out there.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_161)

ep3_myyydril_cantina_girl_convo_s_162 = ConvoScreen:new {
	id = "s_162",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_162", -- [Kirrir blushes visibly.] Aww, yer a sweet one.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_162)

ep3_myyydril_cantina_girl_convo_s_164 = ConvoScreen:new {
	id = "s_164",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_164", -- Yer welcome. Ye be needin' anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_166", "s_168"},
		{"@conversation/ep3_myyydril_cantina_girl:s_169", "s_170"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_164)

ep3_myyydril_cantina_girl_convo_s_168 = ConvoScreen:new {
	id = "s_168",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_168", -- Iffin' yer not careful, I'd say a bit'o death. Urnies be bad things. Stay away from them.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_171", "s_172"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_168)

ep3_myyydril_cantina_girl_convo_s_170 = ConvoScreen:new {
	id = "s_170",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_170", -- Ye best be on yer way, then. I gotta make drinks.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_170)

ep3_myyydril_cantina_girl_convo_s_172 = ConvoScreen:new {
	id = "s_172",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_172", -- Ta say the least. Ye be needin' anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_173", "s_174"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_172)

ep3_myyydril_cantina_girl_convo_s_174 = ConvoScreen:new {
	id = "s_174",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_174", -- Ye best be on yer way, then. Busy, busy, busy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_174)

ep3_myyydril_cantina_girl_convo_s_176 = ConvoScreen:new {
	id = "s_176",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_176", -- That's what I thought too. Ye be needin' anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_178", "s_180"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_176)

ep3_myyydril_cantina_girl_convo_s_180 = ConvoScreen:new {
	id = "s_180",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_180", -- The Myyydril, huh? Welp. Let me see. There's not much to say, really. The Myyydril were thrown out o'the Kerritamba village a long time a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_181", "s_182"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_180)

ep3_myyydril_cantina_girl_convo_s_182 = ConvoScreen:new {
	id = "s_182",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_182", -- Anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_183", "s_184"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_182)

ep3_myyydril_cantina_girl_convo_s_184 = ConvoScreen:new {
	id = "s_184",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_184", -- Thank ye. Welp. I best be off ta me work.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_184)

ep3_myyydril_cantina_girl_convo_s_186 = ConvoScreen:new {
	id = "s_186",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_186", -- What else ye be needin' ta know?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_188", "s_190"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_186)

ep3_myyydril_cantina_girl_convo_s_190 = ConvoScreen:new {
	id = "s_190",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_190", -- The Urnsor'is. Them be ugly boogers. Got a brain as a body, with sharp, pointy claws. Scares the poodoo right outta ya. I suggest ye be s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_192", "s_194"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_190)

ep3_myyydril_cantina_girl_convo_s_194 = ConvoScreen:new {
	id = "s_194",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_194", -- That's what I thought too. Ye be needin' anathin' else?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_208", "s_210"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_194)

ep3_myyydril_cantina_girl_convo_s_210 = ConvoScreen:new {
	id = "s_210",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_210", -- Thank ye. Welp. I best be off ta me work.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_210)

ep3_myyydril_cantina_girl_convo_s_300 = ConvoScreen:new {
	id = "s_300",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_300", -- What can I get fer ya?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_301", "s_302"},
		{"@conversation/ep3_myyydril_cantina_girl:s_303", "s_304"},
		{"@conversation/ep3_myyydril_cantina_girl:s_305", "s_306"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_300)

ep3_myyydril_cantina_girl_convo_s_302 = ConvoScreen:new {
	id = "s_302",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_302", -- All right, darlin'. Let me know.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_302)

ep3_myyydril_cantina_girl_convo_s_304 = ConvoScreen:new {
	id = "s_304",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_304", -- Ye know. Rumors are me speciality. But unfortunately, there be none 'ere. Ain't that a hoot?
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_304)

ep3_myyydril_cantina_girl_convo_s_306 = ConvoScreen:new {
	id = "s_306",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_306", -- All right. Ye can go ahead. I'll answer yer questions to the the best o'me ability.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_307", "s_310"},
		{"@conversation/ep3_myyydril_cantina_girl:s_87", "s_89"},
		{"@conversation/ep3_myyydril_cantina_girl:s_102", "s_104"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_306)

ep3_myyydril_cantina_girl_convo_s_310 = ConvoScreen:new {
	id = "s_310",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_310", -- The Myyydril, huh? Welp. Let me see. There's not much to say, really. The Myyydril were thrown out o'the Kerritamba village a long time a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_308", "s_311"},
		{"@conversation/ep3_myyydril_cantina_girl:s_309", "s_312"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_310)

ep3_myyydril_cantina_girl_convo_s_311 = ConvoScreen:new {
	id = "s_311",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_311", -- Them be ugly boogers. Got a brain as a body, with sharp, pointy claws. Scares the poodoo right outta ya. I suggest ye be stayin' away fro...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_153", "s_154"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_311)

ep3_myyydril_cantina_girl_convo_s_312 = ConvoScreen:new {
	id = "s_312",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_312", -- Iffin' yer not careful, I'd say a bit'o death. Urnies be bad things. Stay away from them.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_312)

ep3_myyydril_cantina_girl_convo_s_326 = ConvoScreen:new {
	id = "s_326",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_326", -- Have ye talked to me girl Nawika yet? What are ye waitin' fer? Don't be shy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_326)

ep3_myyydril_cantina_girl_convo_s_333 = ConvoScreen:new {
	id = "s_333",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_333", -- Ye know. We've got a lot ta do around here. The next person you should visit is me girl, Nawika here in the cantina. She's been needin' s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_334", "s_335"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_333)

ep3_myyydril_cantina_girl_convo_s_335 = ConvoScreen:new {
	id = "s_335",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_335", -- Ye be safe now.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_335)

ep3_myyydril_cantina_girl_convo_s_341 = ConvoScreen:new {
	id = "s_341",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_341", -- What can I--oh? A task I be needin' help with? Who sent ye? Was it tha sweetheart Tala'oree? She's always lookin' out fer me. Let me see ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_342", "s_345"},
		{"@conversation/ep3_myyydril_cantina_girl:s_343", "s_344"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_341)

ep3_myyydril_cantina_girl_convo_s_344 = ConvoScreen:new {
	id = "s_344",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_344", -- All right. Ye let me know, k?
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_344)

ep3_myyydril_cantina_girl_convo_s_345 = ConvoScreen:new {
	id = "s_345",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_345", -- Welp, they're small, purple plants. Ye can find them where there be hostile uwari beetles... right in the entrance o' the cavern. They be...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_365", "s_366"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_345)

ep3_myyydril_cantina_girl_convo_s_346 = ConvoScreen:new {
	id = "s_346",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_346", -- I smell Warl nectar all over ye! Thank ye fer gettin' it. Now, I can make me favorite drink. Let me stirr up a few. I knew me patrons bee...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_cantina_girl:s_347", "s_348"},
	}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_346)

ep3_myyydril_cantina_girl_convo_s_348 = ConvoScreen:new {
	id = "s_348",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_348", -- Ye do that. Ye should try me 'Warl Surprise'. I bet ye'll like it. Talk with me after I made me drinks.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_348)

ep3_myyydril_cantina_girl_convo_s_349 = ConvoScreen:new {
	id = "s_349",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_349", -- Ye got me Warl leaves yet? No? Ye best get out there, then, afore the storm comes. Warl leaves don't last too long in heavy rainfall.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_349)

ep3_myyydril_cantina_girl_convo_s_350 = ConvoScreen:new {
	id = "s_350",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_350", -- Ah! Welcome back, me friend. There ain't much goin' on these days. Bah! I gotta get back ta work.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_350)

ep3_myyydril_cantina_girl_convo_s_366 = ConvoScreen:new {
	id = "s_366",
	leftDialog = "@conversation/ep3_myyydril_cantina_girl:s_366", -- No problem at'all! Come back when ye gots 'em!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_cantina_girl_convo:addScreen(ep3_myyydril_cantina_girl_convo_s_366)

addConversationTemplate("ep3_myyydril_cantina_girl_convo", ep3_myyydril_cantina_girl_convo)

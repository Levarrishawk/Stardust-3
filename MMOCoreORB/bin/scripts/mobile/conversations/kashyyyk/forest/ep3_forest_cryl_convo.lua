-- Cryl -- ep3_forest_cryl_quest_1, ep3_forest_cryl_quest_2, ep3_forest_aveso_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_cryl_convo = ConvoTemplate:new {
	initialScreen = "s_1355",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_cryl_conv_handler",
	screens = {}
}

ep3_forest_cryl_convo_s_1293 = ConvoScreen:new {
	id = "s_1293",
	leftDialog = "@conversation/ep3_forest_cryl:s_1293", -- [Cryl chuckles.] I have no more work for you, mercenary. I ssuggest you sspeak with the otherss. If you hav...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1293)

ep3_forest_cryl_convo_s_1295 = ConvoScreen:new {
	id = "s_1295",
	leftDialog = "@conversation/ep3_forest_cryl:s_1295", -- Yess, merc? [Cryl turns his head inquisitively.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1297", "s_1299"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1295)

ep3_forest_cryl_convo_s_1309 = ConvoScreen:new {
	id = "s_1309",
	leftDialog = "@conversation/ep3_forest_cryl:s_1309", -- [Cryl snarls softly.] I have no proof that you talked to Zhadran. Now leave and return to your duty.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1309)

ep3_forest_cryl_convo_s_1311 = ConvoScreen:new {
	id = "s_1311",
	leftDialog = "@conversation/ep3_forest_cryl:s_1311", -- You did as I expected, mercenary. I am pleassed. Now, I want you to take thiss delicable treat to Zhadran. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1313", "s_1315"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1311)

ep3_forest_cryl_convo_s_1325 = ConvoScreen:new {
	id = "s_1325",
	leftDialog = "@conversation/ep3_forest_cryl:s_1325", -- Yesss, merc?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1327", "s_1329"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1325)

ep3_forest_cryl_convo_s_1331 = ConvoScreen:new {
	id = "s_1331",
	leftDialog = "@conversation/ep3_forest_cryl:s_1331", -- [Cryl frowns.] I am not known for my patience, merc. I ssuggest you find Risyl quickly before I losse my te...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1333", "s_1335"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1331)

ep3_forest_cryl_convo_s_1337 = ConvoScreen:new {
	id = "s_1337",
	leftDialog = "@conversation/ep3_forest_cryl:s_1337", -- [Cryl nods.] I've been expecting you. Avesso hass sspoken well of you. Perhapsss I could usse you for the s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1339", "s_1341"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1337)

ep3_forest_cryl_convo_s_1351 = ConvoScreen:new {
	id = "s_1351",
	leftDialog = "@conversation/ep3_forest_cryl:s_1351", -- [Cryl nods to himself.] Yess. You are ssoon to be one of uss. Find Zhadran and sspeak with him. He iss our ...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1351)

ep3_forest_cryl_convo_s_1353 = ConvoScreen:new {
	id = "s_1353",
	leftDialog = "@conversation/ep3_forest_cryl:s_1353", -- [Cryl chuckles darkly.] I sssuggest you leave quickly, Kerritamba puppet. The Sssociety is hungry for your ...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1353)

ep3_forest_cryl_convo_s_1355 = ConvoScreen:new {
	id = "s_1355",
	leftDialog = "@conversation/ep3_forest_cryl:s_1355", -- [Cryl hisses at you.] What are you doing here? You're not one of usss! Leave before I remove you myself, ou...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1355)

ep3_forest_cryl_convo_s_1299 = ConvoScreen:new {
	id = "s_1299",
	leftDialog = "@conversation/ep3_forest_cryl:s_1299", -- [Cryl nods.] Good, good. The deed iss done then. I have no more work for you, my mercenary. Take heart that...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1301", "s_1303"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1299)

ep3_forest_cryl_convo_s_1303 = ConvoScreen:new {
	id = "s_1303",
	leftDialog = "@conversation/ep3_forest_cryl:s_1303", -- You sshould sspeak to the otherss within the Ssociety. Perhapss there iss more work to be done.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1305", "s_1307"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1303)

ep3_forest_cryl_convo_s_1307 = ConvoScreen:new {
	id = "s_1307",
	leftDialog = "@conversation/ep3_forest_cryl:s_1307", -- Be ssafe, mercenary.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1307)

ep3_forest_cryl_convo_s_1315 = ConvoScreen:new {
	id = "s_1315",
	leftDialog = "@conversation/ep3_forest_cryl:s_1315", -- [Cryl shakes his head.] Too messsy. We do not want to implicate the Ssociety in wrong-doingss against the K...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1317", "s_1323"},
		{"@conversation/ep3_forest_cryl:s_1321", "s_1323"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1315)

ep3_forest_cryl_convo_s_1319 = ConvoScreen:new {
	id = "s_1319",
	leftDialog = "@conversation/ep3_forest_cryl:s_1319", -- You know where Zhadran iss. Take thiss concoction to him.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1319)

ep3_forest_cryl_convo_s_1323 = ConvoScreen:new {
	id = "s_1323",
	leftDialog = "@conversation/ep3_forest_cryl:s_1323", -- [Cryl bares his teeth.] Get losst, then, merc. Hope that my daggersss won't follow you.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1323)

ep3_forest_cryl_convo_s_1329 = ConvoScreen:new {
	id = "s_1329",
	leftDialog = "@conversation/ep3_forest_cryl:s_1329", -- Exccellent. Avesso ssaid I could count on you. I am glad sshe was correct. Now, if you'll wait here while I...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1329)

ep3_forest_cryl_convo_s_1335 = ConvoScreen:new {
	id = "s_1335",
	leftDialog = "@conversation/ep3_forest_cryl:s_1335", -- I believe it when I ssee it, merc. Find Risyl and come back before too long.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1335)

ep3_forest_cryl_convo_s_1341 = ConvoScreen:new {
	id = "s_1341",
	leftDialog = "@conversation/ep3_forest_cryl:s_1341", -- Good. Then, let uss sstart off by ssending you on a little errand. I need for you to find one of my contact...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_cryl:s_1343", "s_1349"},
		{"@conversation/ep3_forest_cryl:s_1347", "s_1349"},
	}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1341)

ep3_forest_cryl_convo_s_1345 = ConvoScreen:new {
	id = "s_1345",
	leftDialog = "@conversation/ep3_forest_cryl:s_1345", -- You're lucky I must sstay my hand againsst brethren, mercenary. Otherwisse, you'd be left in the cavess in ...
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1345)

ep3_forest_cryl_convo_s_1349 = ConvoScreen:new {
	id = "s_1349",
	leftDialog = "@conversation/ep3_forest_cryl:s_1349", -- The cave isss ssmall. You sshould have to trouble finding him. I await for your much needed return.
	stopConversation = "true",
	options = {}
}
ep3_forest_cryl_convo:addScreen(ep3_forest_cryl_convo_s_1349)

addConversationTemplate("ep3_forest_cryl_convo", ep3_forest_cryl_convo)

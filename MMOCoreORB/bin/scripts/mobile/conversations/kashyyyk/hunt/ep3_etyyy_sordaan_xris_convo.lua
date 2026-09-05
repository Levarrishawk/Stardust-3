-- ep3_etyyy_sordaan_xris -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_sordaan_xris_convo = ConvoTemplate:new {
	initialScreen = "s_1432",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_sordaan_xris_conv_handler",
	screens = {}
}

ep3_etyyy_sordaan_xris_convo_s_1138 = ConvoScreen:new {
	id = "s_1138",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1138", -- Tuwezz, that little punk. If Ziven wasn't protecting him, I'd... well, never mind that. So you've ma...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1138)

ep3_etyyy_sordaan_xris_convo_s_1158 = ConvoScreen:new {
	id = "s_1158",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1158", -- Ah, yes. Ehartt says you did well hunting wallugas. Not too bad, I guess. We might make an actual hu...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1158)

ep3_etyyy_sordaan_xris_convo_s_1168 = ConvoScreen:new {
	id = "s_1168",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1168", -- Tripp sent you? Very well then. She probably had you hunting moufs, didn't she? I'll admit, those cr...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1168)

ep3_etyyy_sordaan_xris_convo_s_1178 = ConvoScreen:new {
	id = "s_1178",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1178", -- Good ole Ziven. [*snarls*] I can't tell you how much I despise that pompous buffoon. He'll get his s...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1178)

ep3_etyyy_sordaan_xris_convo_s_1188 = ConvoScreen:new {
	id = "s_1188",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1188", -- At least you're polite. That's something, I suppose. Doesn't excuse wasting my time, but perhaps you...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1188)

ep3_etyyy_sordaan_xris_convo_s_1434 = ConvoScreen:new {
	id = "s_1434",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1434", -- Hmm, that's quite a list of creatures you've hunted. I know of many of them. Brightclaw the mouf and...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1434)

ep3_etyyy_sordaan_xris_convo_s_1142 = ConvoScreen:new {
	id = "s_1142",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1142", -- Okay, good. I'm sure he can't wait.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1142)

ep3_etyyy_sordaan_xris_convo_s_1146 = ConvoScreen:new {
	id = "s_1146",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1146", -- Of course! We're sporting people. What could be better than testing yourself against my best hunters...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1146)

ep3_etyyy_sordaan_xris_convo_s_1150 = ConvoScreen:new {
	id = "s_1150",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1150", -- Good. I look forward to taking your money. Er, [*coughs*] I mean to talking about this further. Good...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1150)

ep3_etyyy_sordaan_xris_convo_s_1154 = ConvoScreen:new {
	id = "s_1154",
	animation = "nod_head_multiple",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1154", -- Why not indeed. The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1154)

ep3_etyyy_sordaan_xris_convo_s_1416 = ConvoScreen:new {
	id = "s_1416",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1416", -- You don't have enough to cover the bet. I'm not a bank, and I don't loan people money to bet with. C...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1416)

ep3_etyyy_sordaan_xris_convo_s_1418 = ConvoScreen:new {
	id = "s_1418",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1418", -- Excellent. Let's make some arrangements. Take this ticket to the shuttle pilot over at the shuttle i...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1418)

ep3_etyyy_sordaan_xris_convo_s_1422 = ConvoScreen:new {
	id = "s_1422",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1422", -- No confidence, eh? I don't blame you. My hunters are pretty intimidating to most people like you. Co...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1422)

ep3_etyyy_sordaan_xris_convo_s_1162 = ConvoScreen:new {
	id = "s_1162",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1162", -- Good. And thank you. Those Chiss are infuriating.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1162)

ep3_etyyy_sordaan_xris_convo_s_1294 = ConvoScreen:new {
	id = "s_1294",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1294", -- You need to speak with Harroom and collect your weapon before we discuss another wager.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1294)

ep3_etyyy_sordaan_xris_convo_s_1296 = ConvoScreen:new {
	id = "s_1296",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1296", -- I think we should settle our current wager before discussing future bets, don't you agree? As much a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1192", "s_1200"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1210", "s_1218"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1228", "s_1236"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1246", "s_1254"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1264", "s_1266"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1296)

ep3_etyyy_sordaan_xris_convo_s_1298 = ConvoScreen:new {
	id = "s_1298",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1298", -- I think we should settle our current wager before discussing future bets, don't you agree? I believe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1270", "s_1272"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1274", "s_1276"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1278", "s_1280"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1282", "s_1284"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1286", "s_1288"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1298)

ep3_etyyy_sordaan_xris_convo_s_1300 = ConvoScreen:new {
	id = "s_1300",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1300", -- Wait, we already have a bet in place. I think we should complete our current wager before discussing...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1300)

ep3_etyyy_sordaan_xris_convo_s_1306 = ConvoScreen:new {
	id = "s_1306",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1306", -- Excellent. All four bets are available to you: you can try the uller warhoofs, the frenzied wallugas...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1306)

ep3_etyyy_sordaan_xris_convo_s_1328 = ConvoScreen:new {
	id = "s_1328",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1328", -- Excellent. You have four options: you can try the uller warhoofs, the frenzied wallugas, or the mouf...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1328)

ep3_etyyy_sordaan_xris_convo_s_1360 = ConvoScreen:new {
	id = "s_1360",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1360", -- Excellent. You have three options: you can try the uller warhoofs or the frenzied wallugas again at ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1360)

ep3_etyyy_sordaan_xris_convo_s_1388 = ConvoScreen:new {
	id = "s_1388",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1388", -- Excellent. You have two options: you can try the uller warhoofs again. Same stakes and terms as last...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1388)

ep3_etyyy_sordaan_xris_convo_s_1412 = ConvoScreen:new {
	id = "s_1412",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1412", -- Excellent. The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my best ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1412)

ep3_etyyy_sordaan_xris_convo_s_1172 = ConvoScreen:new {
	id = "s_1172",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1172", -- Fine. Oh, and tell him I said he's a pompous... no, wait. I'd better tell him that myself.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1172)

ep3_etyyy_sordaan_xris_convo_s_1182 = ConvoScreen:new {
	id = "s_1182",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1182", -- I see. Very well. Come talk to me again if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1182)

ep3_etyyy_sordaan_xris_convo_s_1194 = ConvoScreen:new {
	id = "s_1194",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1194", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings. And go speak with Harroom. I...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1196", "s_1198"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1194)

ep3_etyyy_sordaan_xris_convo_s_1200 = ConvoScreen:new {
	id = "s_1200",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1200", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1202", "s_1204"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1206", "s_1208"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1200)

ep3_etyyy_sordaan_xris_convo_s_1212 = ConvoScreen:new {
	id = "s_1212",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1212", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings. And go speak with Harroom. I...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1214", "s_1216"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1212)

ep3_etyyy_sordaan_xris_convo_s_1218 = ConvoScreen:new {
	id = "s_1218",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1218", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1220", "s_1222"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1224", "s_1226"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1218)

ep3_etyyy_sordaan_xris_convo_s_1230 = ConvoScreen:new {
	id = "s_1230",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1230", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings. And go speak with Harroom. I...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1232", "s_1234"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1230)

ep3_etyyy_sordaan_xris_convo_s_1236 = ConvoScreen:new {
	id = "s_1236",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1236", -- Yeah, yeah. Everyone gets lucky now and then. Here, take your winnings.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1238", "s_1240"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1242", "s_1244"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1236)

ep3_etyyy_sordaan_xris_convo_s_1248 = ConvoScreen:new {
	id = "s_1248",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1248", -- Another win. I suppose I can't really call it luck any longer. Take your winnings, you've earned the...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1250", "s_1252"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1248)

ep3_etyyy_sordaan_xris_convo_s_1254 = ConvoScreen:new {
	id = "s_1254",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1254", -- Yeah, yeah. Perhaps it is skill, but maybe you're just very lucky. Either way, here are your winning...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1256", "s_1258"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1260", "s_1262"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1254)

ep3_etyyy_sordaan_xris_convo_s_1266 = ConvoScreen:new {
	id = "s_1266",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1266", -- If you must. But I don't like leaving something like this unresolved, so do not delay too long.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1266)

ep3_etyyy_sordaan_xris_convo_s_1198 = ConvoScreen:new {
	id = "s_1198",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1198", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1198)

ep3_etyyy_sordaan_xris_convo_s_1204 = ConvoScreen:new {
	id = "s_1204",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1204", -- Such blatant greed! I gave you a bonus weapon as a generous gift the first time you won and instead ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1204)

ep3_etyyy_sordaan_xris_convo_s_1208 = ConvoScreen:new {
	id = "s_1208",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1208", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1208)

ep3_etyyy_sordaan_xris_convo_s_1216 = ConvoScreen:new {
	id = "s_1216",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1216", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1216)

ep3_etyyy_sordaan_xris_convo_s_1222 = ConvoScreen:new {
	id = "s_1222",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1222", -- What nerve! I gave you a bonus weapon as a generous gift the first time you won and instead of being...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1222)

ep3_etyyy_sordaan_xris_convo_s_1226 = ConvoScreen:new {
	id = "s_1226",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1226", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1226)

ep3_etyyy_sordaan_xris_convo_s_1234 = ConvoScreen:new {
	id = "s_1234",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1234", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1234)

ep3_etyyy_sordaan_xris_convo_s_1240 = ConvoScreen:new {
	id = "s_1240",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1240", -- How brash! I gave you a bonus weapon as a generous gift the first time you won and instead of being ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1240)

ep3_etyyy_sordaan_xris_convo_s_1244 = ConvoScreen:new {
	id = "s_1244",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1244", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1244)

ep3_etyyy_sordaan_xris_convo_s_1252 = ConvoScreen:new {
	id = "s_1252",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1252", -- Just be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1252)

ep3_etyyy_sordaan_xris_convo_s_1258 = ConvoScreen:new {
	id = "s_1258",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1258", -- Such unmitigated gall! I gave you a bonus weapon as a generous gift the first time you won and inste...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1258)

ep3_etyyy_sordaan_xris_convo_s_1262 = ConvoScreen:new {
	id = "s_1262",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1262", -- Be sure to come back some time and give me a chance to win my money back.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1262)

ep3_etyyy_sordaan_xris_convo_s_1272 = ConvoScreen:new {
	id = "s_1272",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1272", -- Not the great and mighty hunter after all. Ha. No hard feelings, I hope. Tell you what, if you'd lik...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1272)

ep3_etyyy_sordaan_xris_convo_s_1276 = ConvoScreen:new {
	id = "s_1276",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1276", -- Not the great and mighty hunter after all. Ha. No hard feelings, I hope. Tell you what, if you'd lik...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1276)

ep3_etyyy_sordaan_xris_convo_s_1280 = ConvoScreen:new {
	id = "s_1280",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1280", -- Not the great and mighty hunter after all. Ha. No hard feelings, I hope. Tell you what, if you'd lik...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1280)

ep3_etyyy_sordaan_xris_convo_s_1284 = ConvoScreen:new {
	id = "s_1284",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1284", -- Not the great and mighty hunter after all. Ha. No hard feelings, I hope. Tell you what, if you'd lik...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1284)

ep3_etyyy_sordaan_xris_convo_s_1288 = ConvoScreen:new {
	id = "s_1288",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1288", -- Hmmm, I suppose. But I don't like leaving something like this unresolved, so do not delay too long.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1288)

ep3_etyyy_sordaan_xris_convo_s_1426 = ConvoScreen:new {
	id = "s_1426",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1426", -- Then why are you wasting my time. Go away. Go bother someone else.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1426)

ep3_etyyy_sordaan_xris_convo_s_214 = ConvoScreen:new {
	id = "s_214",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_214", -- Lost your shuttle authorization? Okay, I'll replace your pass, but try to hold onto it this time. 
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_214)

ep3_etyyy_sordaan_xris_convo_s_1304 = ConvoScreen:new {
	id = "s_1304",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1304", -- Go speak to the shuttle pilot. He can take you to the Bocctyyy Path.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1304)

ep3_etyyy_sordaan_xris_convo_s_1310 = ConvoScreen:new {
	id = "s_1310",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1310", -- The bet would be for you to hunt and kill more webweaver spikers in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1310)

ep3_etyyy_sordaan_xris_convo_s_1314 = ConvoScreen:new {
	id = "s_1314",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1314", -- The bet would be for you to hunt and kill more mouf roarlords in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1314)

ep3_etyyy_sordaan_xris_convo_s_1318 = ConvoScreen:new {
	id = "s_1318",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1318", -- The bet would be for you to hunt and kill more frenzied wallugas in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1318)

ep3_etyyy_sordaan_xris_convo_s_1322 = ConvoScreen:new {
	id = "s_1322",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1322", -- The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1322)

ep3_etyyy_sordaan_xris_convo_s_1326 = ConvoScreen:new {
	id = "s_1326",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1326", -- You have to at least give me a chance to win my money back. It's only fair. Soon then?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1326)

ep3_etyyy_sordaan_xris_convo_s_1336 = ConvoScreen:new {
	id = "s_1336",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1336", -- You don't have enough to cover the bet. I'm not a bank, and I don't loan people money to bet with. C...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1336)

ep3_etyyy_sordaan_xris_convo_s_1338 = ConvoScreen:new {
	id = "s_1338",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1338", -- Then let's make the necessary arrangements. Take this ticket to the shuttle pilot over at the shuttl...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1338)

ep3_etyyy_sordaan_xris_convo_s_1342 = ConvoScreen:new {
	id = "s_1342",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1342", -- Oh, come on. Just one more little bet. I guess those big, bad webweavers make you a bit nervous? Pis...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1342)

ep3_etyyy_sordaan_xris_convo_s_1368 = ConvoScreen:new {
	id = "s_1368",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1368", -- You don't have enough to cover the bet. I'm not a bank, and I don't loan people money to bet with. C...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1368)

ep3_etyyy_sordaan_xris_convo_s_1370 = ConvoScreen:new {
	id = "s_1370",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1370", -- Then let's make the necessary arrangements. Take this ticket to the shuttle pilot over at the shuttl...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1370)

ep3_etyyy_sordaan_xris_convo_s_1374 = ConvoScreen:new {
	id = "s_1374",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1374", -- Didn't expect you to back down so easily. You've come so far. Don't tell me you've lost your nerve?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1374)

ep3_etyyy_sordaan_xris_convo_s_1396 = ConvoScreen:new {
	id = "s_1396",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1396", -- You don't have enough to cover the bet. I'm not a bank, and I don't loan people money to bet with. C...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1396)

ep3_etyyy_sordaan_xris_convo_s_1398 = ConvoScreen:new {
	id = "s_1398",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1398", -- Then let's make the necessary arrangements. Take this ticket to the shuttle pilot over at the shuttl...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1398)

ep3_etyyy_sordaan_xris_convo_s_1402 = ConvoScreen:new {
	id = "s_1402",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1402", -- You wouldn't be the first person to back down against those wallugas. They're even meaner than they ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1402)

ep3_etyyy_sordaan_xris_convo_s_1332 = ConvoScreen:new {
	id = "s_1332",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1332", -- The bet would be for you to hunt and kill more webweaver spikers in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1332)

ep3_etyyy_sordaan_xris_convo_s_1346 = ConvoScreen:new {
	id = "s_1346",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1346", -- The bet would be for you to hunt and kill more mouf roarlords in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1346)

ep3_etyyy_sordaan_xris_convo_s_1350 = ConvoScreen:new {
	id = "s_1350",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1350", -- The bet would be for you to hunt and kill more frenzied wallugas in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1350)

ep3_etyyy_sordaan_xris_convo_s_1354 = ConvoScreen:new {
	id = "s_1354",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1354", -- The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1354)

ep3_etyyy_sordaan_xris_convo_s_1358 = ConvoScreen:new {
	id = "s_1358",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1358", -- You have to at least give me a chance to win my money back. It's only fair. Soon then?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1358)

ep3_etyyy_sordaan_xris_convo_s_1364 = ConvoScreen:new {
	id = "s_1364",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1364", -- The bet would be for you to hunt and kill more mouf roarlords in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1364)

ep3_etyyy_sordaan_xris_convo_s_1378 = ConvoScreen:new {
	id = "s_1378",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1378", -- The bet would be for you to hunt and kill more frenzied wallugas in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1378)

ep3_etyyy_sordaan_xris_convo_s_1382 = ConvoScreen:new {
	id = "s_1382",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1382", -- The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1382)

ep3_etyyy_sordaan_xris_convo_s_1386 = ConvoScreen:new {
	id = "s_1386",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1386", -- You have to at least give me a chance to win my money back. It's only fair. Soon then?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1386)

ep3_etyyy_sordaan_xris_convo_s_1392 = ConvoScreen:new {
	id = "s_1392",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1392", -- The bet would be for you to hunt and kill more frenzied wallugas in 20 minutes than my hunters ever ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1392)

ep3_etyyy_sordaan_xris_convo_s_1406 = ConvoScreen:new {
	id = "s_1406",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1406", -- The bet would be for you to hunt and kill more uller warhoofs in 20 minutes than my hunters ever hav...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1406)

ep3_etyyy_sordaan_xris_convo_s_1410 = ConvoScreen:new {
	id = "s_1410",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1410", -- You have to at least give me a chance to win my money back. It's only fair. Soon then?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1410)

ep3_etyyy_sordaan_xris_convo_s_1436 = ConvoScreen:new {
	id = "s_1436",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1436", -- Yes. Okay. You're welcome.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1436)

ep3_etyyy_sordaan_xris_convo_s_1134 = ConvoScreen:new {
	id = "s_1134",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1134", -- So you want to speak with me? Who sent you this time?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1136", "s_1138"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1156", "s_1158"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1166", "s_1168"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1176", "s_1178"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1186", "s_1188"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1453", "s_1434"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1134)

ep3_etyyy_sordaan_xris_convo_s_1190 = ConvoScreen:new {
	id = "s_1190",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1190", -- I suppose you're here to settle our wager. The taste of losing is bitter, so let's finish this and b...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1192", "s_1200"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1210", "s_1218"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1228", "s_1236"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1246", "s_1254"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1264", "s_1266"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1190)

ep3_etyyy_sordaan_xris_convo_s_1268 = ConvoScreen:new {
	id = "s_1268",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1268", -- Here to settle our wager? I believe you lost, isn't that correct?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1270", "s_1272"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1274", "s_1276"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1278", "s_1280"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1282", "s_1284"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1286", "s_1288"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1268)

ep3_etyyy_sordaan_xris_convo_s_1290 = ConvoScreen:new {
	id = "s_1290",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1290", -- Ah you again, %TO. Ready to try your skills against my hunters in a little wager?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1292", "s_1412"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1424", "s_1426"},
		{"@conversation/ep3_etyyy_sordaan_xris:s_1451", "s_1434"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1290)

ep3_etyyy_sordaan_xris_convo_s_1428 = ConvoScreen:new {
	id = "s_1428",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1428", -- What are you waiting for? Go talk to Ziven Tissak. He's here in the hunting camp. Go on.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1449", "s_1434"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1428)

ep3_etyyy_sordaan_xris_convo_s_1430 = ConvoScreen:new {
	id = "s_1430",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1430", -- What are you doing here? Kerssoc sent you? That fool's letting anyone into my hunting grounds these ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1437", "s_1434"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1430)

ep3_etyyy_sordaan_xris_convo_s_1432 = ConvoScreen:new {
	id = "s_1432",
	leftDialog = "@conversation/ep3_etyyy_sordaan_xris:s_1432", -- There is no order in this place any more. My beautiful hunting grounds are being overrun. First by t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_sordaan_xris:s_1433", "s_1434"},
	}
}
ep3_etyyy_sordaan_xris_convo:addScreen(ep3_etyyy_sordaan_xris_convo_s_1432)

addConversationTemplate("ep3_etyyy_sordaan_xris_convo", ep3_etyyy_sordaan_xris_convo)

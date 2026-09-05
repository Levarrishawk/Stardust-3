-- Aveso -- ep3_forest_aveso_quest_1, ep3_forest_aveso_quest_2, ep3_forest_aveso_quest_3, ep3_forest_outcast_contact, ep3_forest_outcast_assassin, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_aveso_convo = ConvoTemplate:new {
	initialScreen = "s_1283",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_aveso_conv_handler",
	screens = {}
}

ep3_forest_aveso_convo_s_1173 = ConvoScreen:new {
	id = "s_1173",
	leftDialog = "@conversation/ep3_forest_aveso:s_1173", -- As I said before, grunt, I have nothing more for you. You should speak with the others if you haven't already.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1175", "s_1177"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1173)

ep3_forest_aveso_convo_s_1179 = ConvoScreen:new {
	id = "s_1179",
	leftDialog = "@conversation/ep3_forest_aveso:s_1179", -- Hm. [Aveso nods, trying to hide her pleased expression.] I approve of your progress, grunt. Perhaps not all...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1181", "s_1183"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1179)

ep3_forest_aveso_convo_s_1193 = ConvoScreen:new {
	id = "s_1193",
	leftDialog = "@conversation/ep3_forest_aveso:s_1193", -- I'm not even going to acknowledge your existence until I see those boxes. I know the look of failure on one...
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1193)

ep3_forest_aveso_convo_s_1195 = ConvoScreen:new {
	id = "s_1195",
	leftDialog = "@conversation/ep3_forest_aveso:s_1195", -- [Aveso smiles to herself.] You again. I thought I had the fortune of getting rid of you. I was wrong.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1197", "s_1199"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1195)

ep3_forest_aveso_convo_s_1213 = ConvoScreen:new {
	id = "s_1213",
	leftDialog = "@conversation/ep3_forest_aveso:s_1213", -- [Aveso smirks.] I'm surprised. You actually set aside your selfishness to help others. Was it difficult for...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1215", "s_1217"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1213)

ep3_forest_aveso_convo_s_1223 = ConvoScreen:new {
	id = "s_1223",
	leftDialog = "@conversation/ep3_forest_aveso:s_1223", -- As I expected, you have come back empty handed. I should see meats falling out of your pockets. I don't, no...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1225", "s_1227"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1223)

ep3_forest_aveso_convo_s_1229 = ConvoScreen:new {
	id = "s_1229",
	leftDialog = "@conversation/ep3_forest_aveso:s_1229", -- [Aveso looks you over.] So, Zhadran sent you? I can tell by your cocky swagger. Don't think you'll get any ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1231", "s_1253"},
		{"@conversation/ep3_forest_aveso:s_1251", "s_1237"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1229)

ep3_forest_aveso_convo_s_1271 = ConvoScreen:new {
	id = "s_1271",
	leftDialog = "@conversation/ep3_forest_aveso:s_1271", -- [Aveso arches a brow.] Who are you, why are you here and why haven't I heard of you. If you're even thinkin...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1273", "s_1275"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1271)

ep3_forest_aveso_convo_s_1277 = ConvoScreen:new {
	id = "s_1277",
	leftDialog = "@conversation/ep3_forest_aveso:s_1277", -- [Aveso rolls her eyes.] Oh. One of you. If you think you can just rat us out to your matted Kerritamba over...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1279", "s_1281"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1277)

ep3_forest_aveso_convo_s_1283 = ConvoScreen:new {
	id = "s_1283",
	leftDialog = "@conversation/ep3_forest_aveso:s_1283", -- What are you doing here? You're not one of us. Get out before you find yourself on the end of a polearm. [A...
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1283)

ep3_forest_aveso_convo_s_1177 = ConvoScreen:new {
	id = "s_1177",
	leftDialog = "@conversation/ep3_forest_aveso:s_1177", -- Well, I'm here and I'm fine. I'm sure you have tasks you must complete. In fact, I must return to mine. Per...
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1177)

ep3_forest_aveso_convo_s_1183 = ConvoScreen:new {
	id = "s_1183",
	leftDialog = "@conversation/ep3_forest_aveso:s_1183", -- Nice try, grunt. [Aveso smirks.] Our Lady Reverence, Dahlia Damask, is far more difficult to please--even d...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1185", "s_1187"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1183)

ep3_forest_aveso_convo_s_1187 = ConvoScreen:new {
	id = "s_1187",
	leftDialog = "@conversation/ep3_forest_aveso:s_1187", -- One day, you'll meet her. But until then, you're stuck with me. [Aveso looks at her list.] And perhaps you ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1189", "s_1191"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1187)

ep3_forest_aveso_convo_s_1191 = ConvoScreen:new {
	id = "s_1191",
	leftDialog = "@conversation/ep3_forest_aveso:s_1191", -- Speak with the others within this place. They may have tasks for you.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1191)

ep3_forest_aveso_convo_s_1199 = ConvoScreen:new {
	id = "s_1199",
	leftDialog = "@conversation/ep3_forest_aveso:s_1199", -- Lady? [Aveso smiles sweetly.] Don't tell me you're getting sweet on me, dear. Sarcasm aside, let's get down...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1201", "s_1203"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1199)

ep3_forest_aveso_convo_s_1203 = ConvoScreen:new {
	id = "s_1203",
	leftDialog = "@conversation/ep3_forest_aveso:s_1203", -- Weapons have a tendency to break with general use. We'll need a new stock if we plan to be able to keep the...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1205", "s_1211"},
		{"@conversation/ep3_forest_aveso:s_1209", "s_1211"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1203)

ep3_forest_aveso_convo_s_1207 = ConvoScreen:new {
	id = "s_1207",
	leftDialog = "@conversation/ep3_forest_aveso:s_1207", -- That's what I like to hear. Keep it up and maybe, in some distant future, we'll get along.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1207)

ep3_forest_aveso_convo_s_1211 = ConvoScreen:new {
	id = "s_1211",
	leftDialog = "@conversation/ep3_forest_aveso:s_1211", -- And I grow tired of your antics. Leave.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1211)

ep3_forest_aveso_convo_s_1217 = ConvoScreen:new {
	id = "s_1217",
	leftDialog = "@conversation/ep3_forest_aveso:s_1217", -- Good. A little rot and decay can go a long way for some. I have other work that needs to be done. Wait here...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1219", "s_1221"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1217)

ep3_forest_aveso_convo_s_1221 = ConvoScreen:new {
	id = "s_1221",
	leftDialog = "@conversation/ep3_forest_aveso:s_1221", -- [Aveso rolls her eyes.]
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1221)

ep3_forest_aveso_convo_s_1227 = ConvoScreen:new {
	id = "s_1227",
	leftDialog = "@conversation/ep3_forest_aveso:s_1227", -- Think of it this way; the more time you take, the closer it is to Mother Ves'ad's feeding time. Now hurry up.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1227)

ep3_forest_aveso_convo_s_1233 = ConvoScreen:new {
	id = "s_1233",
	animation = "bow",
	leftDialog = "@conversation/ep3_forest_aveso:s_1233", -- [Aveso sighs.] Somehow, I always get stuck with the imbeciles. [She rubs her temple.] Let's get started. Fi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1235", "s_1237"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1233)

ep3_forest_aveso_convo_s_1253 = ConvoScreen:new {
	id = "s_1253",
	leftDialog = "@conversation/ep3_forest_aveso:s_1253", -- [Aveso laughs.] You'll take orders from me, or I'll punch you in the throat. Pick one.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1255", "s_1257"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1253)

ep3_forest_aveso_convo_s_1237 = ConvoScreen:new {
	id = "s_1237",
	leftDialog = "@conversation/ep3_forest_aveso:s_1237", -- In the forests surrounding our cozy cave, you'll find the Mouf and the Webweaver. Contrary to what the Kerr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1239", "s_1249"},
		{"@conversation/ep3_forest_aveso:s_1243", "s_1245"},
		{"@conversation/ep3_forest_aveso:s_1247", "s_1249"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1237)

ep3_forest_aveso_convo_s_1241 = ConvoScreen:new {
	id = "s_1241",
	leftDialog = "@conversation/ep3_forest_aveso:s_1241", -- [Aveso spits on you.] Then, I don't want to see your disgusting face.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1241)

ep3_forest_aveso_convo_s_1245 = ConvoScreen:new {
	id = "s_1245",
	leftDialog = "@conversation/ep3_forest_aveso:s_1245", -- [Aveso gags.] Ugh.. just... collect 20 meats from each creature. Get out of here before you make me sick.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1245)

ep3_forest_aveso_convo_s_1249 = ConvoScreen:new {
	id = "s_1249",
	leftDialog = "@conversation/ep3_forest_aveso:s_1249", -- Petty or not, you'll do as you're told or I will feed you to Mother Ves'ad. Count it as the highlight of my...
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1249)

ep3_forest_aveso_convo_s_1257 = ConvoScreen:new {
	id = "s_1257",
	leftDialog = "@conversation/ep3_forest_aveso:s_1257", -- [Aveso chuckles darkly.] Too bad. It would have been enjoyable to have everyone watch while you're beat dow...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1259", "s_1261"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1257)

ep3_forest_aveso_convo_s_1261 = ConvoScreen:new {
	id = "s_1261",
	leftDialog = "@conversation/ep3_forest_aveso:s_1261", -- Let us continue, shall we? [Aveso rolls her eyes.] The only thing I need from you is for you to gather 20 m...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_aveso:s_1263", "s_1269"},
		{"@conversation/ep3_forest_aveso:s_1267", "s_1269"},
	}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1261)

ep3_forest_aveso_convo_s_1265 = ConvoScreen:new {
	id = "s_1265",
	leftDialog = "@conversation/ep3_forest_aveso:s_1265", -- Just get them and hurry up. My people are hungry, grunt.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1265)

ep3_forest_aveso_convo_s_1269 = ConvoScreen:new {
	id = "s_1269",
	leftDialog = "@conversation/ep3_forest_aveso:s_1269", -- Then, get out of my face, cretin. Your stench insults the very fibers of my being.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1269)

ep3_forest_aveso_convo_s_1275 = ConvoScreen:new {
	id = "s_1275",
	leftDialog = "@conversation/ep3_forest_aveso:s_1275", -- You'd rather deal with my attitude than a gaping wound in your side. Trust me. [Aveso smiles sweetly.]
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1275)

ep3_forest_aveso_convo_s_1281 = ConvoScreen:new {
	id = "s_1281",
	leftDialog = "@conversation/ep3_forest_aveso:s_1281", -- That's right. Run along now.
	stopConversation = "true",
	options = {}
}
ep3_forest_aveso_convo:addScreen(ep3_forest_aveso_convo_s_1281)

addConversationTemplate("ep3_forest_aveso_convo", ep3_forest_aveso_convo)

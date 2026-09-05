-- Ardon -- ep3_forest_ardon_quest_1, ep3_forest_ardon_quest_2, ep3_forest_ardon_quest_3, ep3_forest_ardon_assassin, ep3_forest_athnalu_quest_2, ep3_forest_meust_quest_3, ep3_forest_perusta_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_kerritamba_epic_convo = ConvoTemplate:new {
	initialScreen = "s_1616",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_kerritamba_epic_conv_handler",
	screens = {}
}

ep3_forest_kerritamba_epic_convo_s_1520 = ConvoScreen:new {
	id = "s_1520",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1520", -- I have no more work for you, my friend. You have succeeded the Chief's expectations and all is well in Kerr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1522", "s_1524"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1520)

ep3_forest_kerritamba_epic_convo_s_1526 = ConvoScreen:new {
	id = "s_1526",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1526", -- Well, if it isn't you again. [Ardon smirks.] You have done good work and are now free for my services. Chie...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1528", "s_1530"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1526)

ep3_forest_kerritamba_epic_convo_s_1532 = ConvoScreen:new {
	id = "s_1532",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1532", -- Ahh. Well if it isn't the hero of the day. My contacts have told me about your success against the Exemplar...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1534", "s_1536"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1532)

ep3_forest_kerritamba_epic_convo_s_1542 = ConvoScreen:new {
	id = "s_1542",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1542", -- [Ardon tubs his temple.] It annoys me how frequently you come back without having completed your duties. No...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1544", "s_1546"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1542)

ep3_forest_kerritamba_epic_convo_s_1548 = ConvoScreen:new {
	id = "s_1548",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1548", -- [Ardon rubs his hands together.] Excellent.. Now, let's discuss our next plan of attack. The Outcasts have ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1550", "s_1552"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1548)

ep3_forest_kerritamba_epic_convo_s_1566 = ConvoScreen:new {
	id = "s_1566",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1566", -- [Ardon arches a brow.] Back so soon? Tell me you haven't completed your task already.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1568", "s_1570"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1566)

ep3_forest_kerritamba_epic_convo_s_1576 = ConvoScreen:new {
	id = "s_1576",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1576", -- Unless you're here to tell me of your success against the worthless Outcasts, I do not wish to speak with you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1578", "s_1580"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1576)

ep3_forest_kerritamba_epic_convo_s_1582 = ConvoScreen:new {
	id = "s_1582",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1582", -- Ah, yes. I have heard your name whispered on the low voices of the Kerritamba people. Let's do business.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1584", "s_1586"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1582)

ep3_forest_kerritamba_epic_convo_s_1608 = ConvoScreen:new {
	id = "s_1608",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1608", -- [Ardon ponders for a moment.] No... I don't recognize you. I only speak with those of well-known renown. Yo...
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1608)

ep3_forest_kerritamba_epic_convo_s_1610 = ConvoScreen:new {
	id = "s_1610",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1610", -- [Ardon arches a brow.] One of the Lost? Here? In my presence? You must be daft or have the courage of a Ker...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1612", "s_1614"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1610)

ep3_forest_kerritamba_epic_convo_s_1616 = ConvoScreen:new {
	id = "s_1616",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1616", -- [Ardon smirks.] I don't remember requesting the presence of a nameless face. Leave or face the consequences.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1616)

ep3_forest_kerritamba_epic_convo_s_1524 = ConvoScreen:new {
	id = "s_1524",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1524", -- [Ardon nods.] As you wish.... Blood Hunter.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1524)

ep3_forest_kerritamba_epic_convo_s_1530 = ConvoScreen:new {
	id = "s_1530",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1530", -- [Ardon smirks.] Yes, it suits you, doesn't it?
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1530)

ep3_forest_kerritamba_epic_convo_s_1536 = ConvoScreen:new {
	id = "s_1536",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1536", -- [Ardon smiles smuggly.] Indeed. Speak with me in a moment or two. I have matters to which I must attend. Su...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1538", "s_1540"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1536)

ep3_forest_kerritamba_epic_convo_s_1540 = ConvoScreen:new {
	id = "s_1540",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1540", -- [Ardon returns to his thoughts.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1540)

ep3_forest_kerritamba_epic_convo_s_1546 = ConvoScreen:new {
	id = "s_1546",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1546", -- [Ardon sneers.] You do that.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1546)

ep3_forest_kerritamba_epic_convo_s_1552 = ConvoScreen:new {
	id = "s_1552",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1552", -- [Ardon sneers.] It is wise to know your enemies, child. Now stop interrupting me! Where were we... Ah yes. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1554", "s_1556"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1552)

ep3_forest_kerritamba_epic_convo_s_1556 = ConvoScreen:new {
	id = "s_1556",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1556", -- You'll find him milling around here somewhere. Lately, the Kerritamba people have noticed a strange individ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1558", "s_1564"},
		{"@conversation/ep3_forest_kerritamba_epic:s_1562", "s_1564"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1556)

ep3_forest_kerritamba_epic_convo_s_1560 = ConvoScreen:new {
	id = "s_1560",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1560", -- I approve of your attitude. Now go. Make me proud.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1560)

ep3_forest_kerritamba_epic_convo_s_1564 = ConvoScreen:new {
	id = "s_1564",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1564", -- Be sure to plan quickly then. [Ardon smirks.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1564)

ep3_forest_kerritamba_epic_convo_s_1570 = ConvoScreen:new {
	id = "s_1570",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1570", -- [Ardon smirks.] I have underestimated you, is all. Nonetheless... I must brood over our next attack. Come b...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1572", "s_1574"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1570)

ep3_forest_kerritamba_epic_convo_s_1574 = ConvoScreen:new {
	id = "s_1574",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1574", -- [Ardon returns to his thoughts.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1574)

ep3_forest_kerritamba_epic_convo_s_1580 = ConvoScreen:new {
	id = "s_1580",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1580", -- I suggest you get to your task immediately. [Ardon sneers.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1580)

ep3_forest_kerritamba_epic_convo_s_1586 = ConvoScreen:new {
	id = "s_1586",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1586", -- [Ardon chuckles darkly.] I am Ardon Da'mora, servant of Chief Kerritamba. I handle... worldly affairs for him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1588", "s_1590"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1586)

ep3_forest_kerritamba_epic_convo_s_1590 = ConvoScreen:new {
	id = "s_1590",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1590", -- I have no doubt that you have heard of the Outcasts; the pitiful insects of the world that thrive within th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1592", "s_1594"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1590)

ep3_forest_kerritamba_epic_convo_s_1594 = ConvoScreen:new {
	id = "s_1594",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1594", -- [Ardon scoffs.] Then you'll be banished from the Kerritamba village and marked as a traitor.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1596", "s_1598"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1594)

ep3_forest_kerritamba_epic_convo_s_1598 = ConvoScreen:new {
	id = "s_1598",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1598", -- Now. [Ardon smiles.] First, we want to send a message to the Outcasts that the Kerritamba mean business. Yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_epic:s_1600", "s_1606"},
		{"@conversation/ep3_forest_kerritamba_epic:s_1604", "s_1606"},
	}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1598)

ep3_forest_kerritamba_epic_convo_s_1602 = ConvoScreen:new {
	id = "s_1602",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1602", -- I'll keep that in mind when you come back, crawling and sniveling. [Ardon sneers.]
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1602)

ep3_forest_kerritamba_epic_convo_s_1606 = ConvoScreen:new {
	id = "s_1606",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1606", -- Good. [Ardon smiles smuggly.] Now get to it.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1606)

ep3_forest_kerritamba_epic_convo_s_1614 = ConvoScreen:new {
	id = "s_1614",
	leftDialog = "@conversation/ep3_forest_kerritamba_epic:s_1614", -- [Ardon chuckles darkly.] You'll just have to see, won't you, my pet?
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_epic_convo:addScreen(ep3_forest_kerritamba_epic_convo_s_1614)

addConversationTemplate("ep3_forest_kerritamba_epic_convo", ep3_forest_kerritamba_epic_convo)

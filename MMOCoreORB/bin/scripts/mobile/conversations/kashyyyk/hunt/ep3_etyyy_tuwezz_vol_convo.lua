-- ep3_etyyy_tuwezz_vol -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_tuwezz_vol_convo = ConvoTemplate:new {
	initialScreen = "s_1685",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_tuwezz_vol_conv_handler",
	screens = {}
}

ep3_etyyy_tuwezz_vol_convo_s_1689 = ConvoScreen:new {
	id = "s_1689",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1689", -- Ah, you've managed to defeat Spiketop. I wondered when someone would finally do so. To be honest, I'...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1691", "s_1693"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1689)

ep3_etyyy_tuwezz_vol_convo_s_1695 = ConvoScreen:new {
	id = "s_1695",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1695", -- Ah, you've managed to defeat Spiketop. I wondered when someone would finally do so. To be honest, I'...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1695)

ep3_etyyy_tuwezz_vol_convo_s_1629 = ConvoScreen:new {
	id = "s_1629",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1629", -- You've shown yourself to be a capable hunter. Sordaan will probably want to offer a hunting wager. I...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1629)

ep3_etyyy_tuwezz_vol_convo_s_1633 = ConvoScreen:new {
	id = "s_1633",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1633", -- Of course. Return to me when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1633)

ep3_etyyy_tuwezz_vol_convo_s_1641 = ConvoScreen:new {
	id = "s_1641",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1641", -- Thanks!
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1641)

ep3_etyyy_tuwezz_vol_convo_s_1649 = ConvoScreen:new {
	id = "s_1649",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1649", -- The elder ullers are a good bit tougher than the diseased ones. Be ready for that. Return to me when...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1649)

ep3_etyyy_tuwezz_vol_convo_s_1653 = ConvoScreen:new {
	id = "s_1653",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1653", -- Ah. Okay then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1653)

ep3_etyyy_tuwezz_vol_convo_s_1661 = ConvoScreen:new {
	id = "s_1661",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1661", -- Good to hear.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1661)

ep3_etyyy_tuwezz_vol_convo_s_1669 = ConvoScreen:new {
	id = "s_1669",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1669", -- Well, let's see. Oh, I've got it. We've had a problem lately with some diseased ullers. We're worrie...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1671", "s_1673"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1675", "s_1677"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1669)

ep3_etyyy_tuwezz_vol_convo_s_1681 = ConvoScreen:new {
	id = "s_1681",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1681", -- Ah. Okay then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1681)

ep3_etyyy_tuwezz_vol_convo_s_1673 = ConvoScreen:new {
	id = "s_1673",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1673", -- Head due east from here, and you'll find an area full of ullers. That's their primary habitat in thi...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1673)

ep3_etyyy_tuwezz_vol_convo_s_1677 = ConvoScreen:new {
	id = "s_1677",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1677", -- Ah. Okay then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1677)

ep3_etyyy_tuwezz_vol_convo_s_1693 = ConvoScreen:new {
	id = "s_1693",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1693", -- Good. He might even give you one of those Excellence in Hunting awards. Though so far, he's only awa...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1693)

ep3_etyyy_tuwezz_vol_convo_s_1621 = ConvoScreen:new {
	id = "s_1621",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1621", -- Welcome, hunter. I trust the hunt goes well for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1623", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1621)

ep3_etyyy_tuwezz_vol_convo_s_1625 = ConvoScreen:new {
	id = "s_1625",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1625", -- These horns are exactly what I wanted. Well done. I'm very happy with your hunting abilities. Enough...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1627", "s_1629"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1631", "s_1633"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1635", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1625)

ep3_etyyy_tuwezz_vol_convo_s_1637 = ConvoScreen:new {
	id = "s_1637",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1637", -- Unmarred uller horns. 11 of them. And remember, the elder ullers are the ones to target. None of the...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1639", "s_1641"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1643", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1637)

ep3_etyyy_tuwezz_vol_convo_s_1645 = ConvoScreen:new {
	id = "s_1645",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1645", -- You did quite well hunting those diseased ullers. Quite well indeed. I can see excellent potential i...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1647", "s_1649"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1651", "s_1653"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1655", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1645)

ep3_etyyy_tuwezz_vol_convo_s_1657 = ConvoScreen:new {
	id = "s_1657",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1657", -- Go hunt those diseased ullers. Return to me when you're done.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1659", "s_1661"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1663", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1657)

ep3_etyyy_tuwezz_vol_convo_s_1665 = ConvoScreen:new {
	id = "s_1665",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1665", -- Ziven sent you to me? Interesting. Well, I suppose he wants to see what kind of hunter you are. So l...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1667", "s_1669"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1679", "s_1681"},
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1683", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1665)

ep3_etyyy_tuwezz_vol_convo_s_1685 = ConvoScreen:new {
	id = "s_1685",
	leftDialog = "@conversation/ep3_etyyy_tuwezz_vol:s_1685", -- Be careful. There are many dangerous creatures in Etyyy, the hunting grounds.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tuwezz_vol:s_1687", "s_1695"},
	}
}
ep3_etyyy_tuwezz_vol_convo:addScreen(ep3_etyyy_tuwezz_vol_convo_s_1685)

addConversationTemplate("ep3_etyyy_tuwezz_vol_convo", ep3_etyyy_tuwezz_vol_convo)

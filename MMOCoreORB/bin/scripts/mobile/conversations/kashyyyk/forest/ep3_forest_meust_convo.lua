-- Meust (Shoartu Mystic) -- ep3_forest_meust_quest_1, ep3_forest_meust_quest_2, ep3_forest_meust_quest_3, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_meust_convo = ConvoTemplate:new {
	initialScreen = "s_2136",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_meust_conv_handler",
	screens = {}
}

ep3_forest_meust_convo_s_1619 = ConvoScreen:new {
	id = "s_1619",
	leftDialog = "@conversation/ep3_forest_meust:s_1619", -- Rrworr!
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_1619)

ep3_forest_meust_convo_s_2030 = ConvoScreen:new {
	id = "s_2030",
	leftDialog = "@conversation/ep3_forest_meust:s_2030", -- You have returned my young warrior. The Kerritamba people speak highly of you these days. I'm glad to see y...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2032", "s_2034"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2030)

ep3_forest_meust_convo_s_2036 = ConvoScreen:new {
	id = "s_2036",
	leftDialog = "@conversation/ep3_forest_meust:s_2036", -- The attacks have stopped. You must have been successful, young warrior.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2038", "s_2040"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2036)

ep3_forest_meust_convo_s_2046 = ConvoScreen:new {
	id = "s_2046",
	leftDialog = "@conversation/ep3_forest_meust:s_2046", -- [Meust raises a hand to silence you.] I do not want to speak with you unless you've been successful against...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2048", "s_2050"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2046)

ep3_forest_meust_convo_s_2052 = ConvoScreen:new {
	id = "s_2052",
	leftDialog = "@conversation/ep3_forest_meust:s_2052", -- I have decided on your final test, young warrior. Do you remember my warnings regarding the Sayormi?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2054", "s_2056"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2052)

ep3_forest_meust_convo_s_2066 = ConvoScreen:new {
	id = "s_2066",
	leftDialog = "@conversation/ep3_forest_meust:s_2066", -- It is good to see you, young warrior. How did the hunt go?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2068", "s_2070"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2066)

ep3_forest_meust_convo_s_2076 = ConvoScreen:new {
	id = "s_2076",
	leftDialog = "@conversation/ep3_forest_meust:s_2076", -- Steelclaw still roams the Kkowir Forest, young warrior. Do not return until you have slain him.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2076)

ep3_forest_meust_convo_s_2078 = ConvoScreen:new {
	id = "s_2078",
	leftDialog = "@conversation/ep3_forest_meust:s_2078", -- The Kerritamba people hold great pride in 'the hunt'. It is time you show the tribe that you too hold such ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2080", "s_2086"},
		{"@conversation/ep3_forest_meust:s_2084", "s_2086"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2078)

ep3_forest_meust_convo_s_2088 = ConvoScreen:new {
	id = "s_2088",
	leftDialog = "@conversation/ep3_forest_meust:s_2088", -- Warrior... [Meust nods.] I see that you have come home victorious. Let me take those Mouf Hides from you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2090", "s_2092"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2088)

ep3_forest_meust_convo_s_2094 = ConvoScreen:new {
	id = "s_2094",
	leftDialog = "@conversation/ep3_forest_meust:s_2094", -- Welcome home, warrior.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2096", "s_2098"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2094)

ep3_forest_meust_convo_s_2104 = ConvoScreen:new {
	id = "s_2104",
	leftDialog = "@conversation/ep3_forest_meust:s_2104", -- [Meust looks you over.] Your heart is pure and your will strong. You must be a warrior. We, the Kerritamba,...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2106", "s_2108"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2104)

ep3_forest_meust_convo_s_2134 = ConvoScreen:new {
	id = "s_2134",
	leftDialog = "@conversation/ep3_forest_meust:s_2134", -- [Meust seems taken aback by your presence.] One of the 'Misguided'... Your presence pains me. Leave now!
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2134)

ep3_forest_meust_convo_s_2136 = ConvoScreen:new {
	id = "s_2136",
	leftDialog = "@conversation/ep3_forest_meust:s_2136", -- [Meust frowns.] You're not a warrior. Leave this place immediately. We, the Kerritamba, only welcome strong...
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2136)

ep3_forest_meust_convo_s_2034 = ConvoScreen:new {
	id = "s_2034",
	leftDialog = "@conversation/ep3_forest_meust:s_2034", -- Continue to do so. I wish I had more for you to do.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2034)

ep3_forest_meust_convo_s_2040 = ConvoScreen:new {
	id = "s_2040",
	leftDialog = "@conversation/ep3_forest_meust:s_2040", -- It is a good day for the Kerritamba people. Thank you. [Meust nods his head low.] You have passed all of yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2042", "s_2044"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2040)

ep3_forest_meust_convo_s_2044 = ConvoScreen:new {
	id = "s_2044",
	leftDialog = "@conversation/ep3_forest_meust:s_2044", -- Good. Please speak with the others in the village. Surely, there's more for you to do.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2044)

ep3_forest_meust_convo_s_2050 = ConvoScreen:new {
	id = "s_2050",
	leftDialog = "@conversation/ep3_forest_meust:s_2050", -- I expect you to return soon, young warrior.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2050)

ep3_forest_meust_convo_s_2056 = ConvoScreen:new {
	id = "s_2056",
	leftDialog = "@conversation/ep3_forest_meust:s_2056", -- It is them you must hunt now. By the day, their actions become bolder and it is threatening our way of life...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2058", "s_2064"},
		{"@conversation/ep3_forest_meust:s_2062", "s_2064"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2056)

ep3_forest_meust_convo_s_2060 = ConvoScreen:new {
	id = "s_2060",
	leftDialog = "@conversation/ep3_forest_meust:s_2060", -- [Meust nods.] Good. Go then. The Sayormi can be found in the Dead Forest. Be safe in knowing that the spiri...
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2060)

ep3_forest_meust_convo_s_2064 = ConvoScreen:new {
	id = "s_2064",
	leftDialog = "@conversation/ep3_forest_meust:s_2064", -- [Meust sterns his jaw.] Fine, then.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2064)

ep3_forest_meust_convo_s_2070 = ConvoScreen:new {
	id = "s_2070",
	leftDialog = "@conversation/ep3_forest_meust:s_2070", -- You have proven yourself well, warrior. You have but one more test that I must give you. Return soon. I mus...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2072", "s_2074"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2070)

ep3_forest_meust_convo_s_2074 = ConvoScreen:new {
	id = "s_2074",
	leftDialog = "@conversation/ep3_forest_meust:s_2074", -- May the spirit of Nyenthi'Oris guide you.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2074)

ep3_forest_meust_convo_s_2082 = ConvoScreen:new {
	id = "s_2082",
	leftDialog = "@conversation/ep3_forest_meust:s_2082", -- You are brave. I await your return warrior.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2082)

ep3_forest_meust_convo_s_2086 = ConvoScreen:new {
	id = "s_2086",
	leftDialog = "@conversation/ep3_forest_meust:s_2086", -- [Meust frowns.] Then go... and return when you feel you are up to my challenge.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2086)

ep3_forest_meust_convo_s_2092 = ConvoScreen:new {
	id = "s_2092",
	leftDialog = "@conversation/ep3_forest_meust:s_2092", -- I see that you'll need a more challenging test. Let me think on the possibilities. Come speak with me in a ...
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2092)

ep3_forest_meust_convo_s_2098 = ConvoScreen:new {
	id = "s_2098",
	leftDialog = "@conversation/ep3_forest_meust:s_2098", -- As you should warrior. As a new member of the tribe, I expect you to go slower than others. But you mustn't...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2100", "s_2102"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2098)

ep3_forest_meust_convo_s_2102 = ConvoScreen:new {
	id = "s_2102",
	leftDialog = "@conversation/ep3_forest_meust:s_2102", -- May the spirit of Nyenthi'Oris guide you.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2102)

ep3_forest_meust_convo_s_2108 = ConvoScreen:new {
	id = "s_2108",
	leftDialog = "@conversation/ep3_forest_meust:s_2108", -- I am Meust, Headhunter of Kerritamba village. I set forth challenging goals for fellow warriors so that the...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2110", "s_2116"},
		{"@conversation/ep3_forest_meust:s_2114", "s_2116"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2108)

ep3_forest_meust_convo_s_2112 = ConvoScreen:new {
	id = "s_2112",
	leftDialog = "@conversation/ep3_forest_meust:s_2112", -- [Meust nods.] May the spirit of Nyenthi'Oris guide you.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2112)

ep3_forest_meust_convo_s_2116 = ConvoScreen:new {
	id = "s_2116",
	leftDialog = "@conversation/ep3_forest_meust:s_2116", -- [Meust arches a furry brow.] Only those of the Kerritamba tribe are tested.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2118", "s_2120"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2116)

ep3_forest_meust_convo_s_2120 = ConvoScreen:new {
	id = "s_2120",
	leftDialog = "@conversation/ep3_forest_meust:s_2120", -- I am skeptical, but if what you say is true, then I have no choice but to test your will and your honor. Fi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2122", "s_2132"},
		{"@conversation/ep3_forest_meust:s_2130", "s_2128"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2120)

ep3_forest_meust_convo_s_2124 = ConvoScreen:new {
	id = "s_2124",
	leftDialog = "@conversation/ep3_forest_meust:s_2124", -- Good. You will find the Mouf grazing in the Dead Forest, just east of here. But beware, the Sayormi lurk th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_meust:s_2126", "s_2128"},
	}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2124)

ep3_forest_meust_convo_s_2132 = ConvoScreen:new {
	id = "s_2132",
	leftDialog = "@conversation/ep3_forest_meust:s_2132", -- [Meust frowns.] You disappoint me.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2132)

ep3_forest_meust_convo_s_2128 = ConvoScreen:new {
	id = "s_2128",
	leftDialog = "@conversation/ep3_forest_meust:s_2128", -- May the spirit of Nyenthi'Oris guide you.
	stopConversation = "true",
	options = {}
}
ep3_forest_meust_convo:addScreen(ep3_forest_meust_convo_s_2128)

addConversationTemplate("ep3_forest_meust_convo", ep3_forest_meust_convo)

-- Perusta (Shoartu Mystic) -- ep3_forest_perusta_quest_1, ep3_forest_perusta_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_perusta_convo = ConvoTemplate:new {
	initialScreen = "s_2836",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_perusta_conv_handler",
	screens = {}
}

ep3_forest_perusta_convo_s_1676 = ConvoScreen:new {
	id = "s_1676",
	leftDialog = "@conversation/ep3_forest_perusta:s_1676", -- Rrworr!
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_1676)

ep3_forest_perusta_convo_s_2768 = ConvoScreen:new {
	id = "s_2768",
	leftDialog = "@conversation/ep3_forest_perusta:s_2768", -- Thank you for all the help you've given me. I hope this experiment was a success. I'll have to see in a few...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2770", "s_2772"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2768)

ep3_forest_perusta_convo_s_2774 = ConvoScreen:new {
	id = "s_2774",
	leftDialog = "@conversation/ep3_forest_perusta:s_2774", -- [Perusta looks at you expectantly.] Were you able to find the blossoms I asked for?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2776", "s_2778"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2774)

ep3_forest_perusta_convo_s_2780 = ConvoScreen:new {
	id = "s_2780",
	leftDialog = "@conversation/ep3_forest_perusta:s_2780", -- [Perusta nods.] It doesn't look like you've found the blossoms yet. Go back out there. We can't waste time.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2782", "s_2784"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2780)

ep3_forest_perusta_convo_s_2786 = ConvoScreen:new {
	id = "s_2786",
	leftDialog = "@conversation/ep3_forest_perusta:s_2786", -- [Perusta sighs.] It didn't work. The Mysess Blossoms that I had didn't live long enough for me to complete ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2788", "s_2794"},
		{"@conversation/ep3_forest_perusta:s_2792", "s_2794"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2786)

ep3_forest_perusta_convo_s_2796 = ConvoScreen:new {
	id = "s_2796",
	leftDialog = "@conversation/ep3_forest_perusta:s_2796", -- [Perusta hums a little tune while she fiddles with her plants.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2798", "s_2800"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2796)

ep3_forest_perusta_convo_s_2802 = ConvoScreen:new {
	id = "s_2802",
	leftDialog = "@conversation/ep3_forest_perusta:s_2802", -- [Perusta looks up from her work, face flecked with dirt and smudge.] Were you able to find the moss yet?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2804", "s_2806"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2802)

ep3_forest_perusta_convo_s_2812 = ConvoScreen:new {
	id = "s_2812",
	leftDialog = "@conversation/ep3_forest_perusta:s_2812", -- [Perusta nods, recognizing you immediately.] You've been stirring up quite the talk these days, my friend.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2814", "s_2816"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2812)

ep3_forest_perusta_convo_s_2834 = ConvoScreen:new {
	id = "s_2834",
	leftDialog = "@conversation/ep3_forest_perusta:s_2834", -- [Perusta looks around nervously.] You know, you shouldn't be here and I shouldn't be talking to you. You'd ...
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2834)

ep3_forest_perusta_convo_s_2836 = ConvoScreen:new {
	id = "s_2836",
	leftDialog = "@conversation/ep3_forest_perusta:s_2836", -- [Perusta arches a brow.] Why are you here milling about? Who are you? The Kerritamba are wary of strangers ...
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2836)

ep3_forest_perusta_convo_s_2772 = ConvoScreen:new {
	id = "s_2772",
	leftDialog = "@conversation/ep3_forest_perusta:s_2772", -- Me too. I'm sure I'll see you around. [Perusta nods.]
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2772)

ep3_forest_perusta_convo_s_2778 = ConvoScreen:new {
	id = "s_2778",
	leftDialog = "@conversation/ep3_forest_perusta:s_2778", -- Great! Let me plant them. I sure hope this works..
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2778)

ep3_forest_perusta_convo_s_2784 = ConvoScreen:new {
	id = "s_2784",
	leftDialog = "@conversation/ep3_forest_perusta:s_2784", -- Good. Be on your way.
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2784)

ep3_forest_perusta_convo_s_2790 = ConvoScreen:new {
	id = "s_2790",
	leftDialog = "@conversation/ep3_forest_perusta:s_2790", -- Hurry back! They don't last long... [Perusta calls after you.]
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2790)

ep3_forest_perusta_convo_s_2794 = ConvoScreen:new {
	id = "s_2794",
	leftDialog = "@conversation/ep3_forest_perusta:s_2794", -- I'll have to get them myself, then. [Perusta shrugs.]
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2794)

ep3_forest_perusta_convo_s_2800 = ConvoScreen:new {
	id = "s_2800",
	leftDialog = "@conversation/ep3_forest_perusta:s_2800", -- Hmm? Oh! Yes, yes of course. Thank you. Stay here while I place the moss inside the pots.
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2800)

ep3_forest_perusta_convo_s_2806 = ConvoScreen:new {
	id = "s_2806",
	leftDialog = "@conversation/ep3_forest_perusta:s_2806", -- Well... that's good to hear, I guess. I need those specimens as soon as possible. Why don't you go back out...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2808", "s_2810"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2806)

ep3_forest_perusta_convo_s_2810 = ConvoScreen:new {
	id = "s_2810",
	leftDialog = "@conversation/ep3_forest_perusta:s_2810", -- [Perusta nods and goes back to her work.]
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2810)

ep3_forest_perusta_convo_s_2816 = ConvoScreen:new {
	id = "s_2816",
	leftDialog = "@conversation/ep3_forest_perusta:s_2816", -- Mostly. Good enough that I'm going to ask you for a few favors, at least. What do you think? They are not m...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2818", "s_2820"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2816)

ep3_forest_perusta_convo_s_2820 = ConvoScreen:new {
	id = "s_2820",
	leftDialog = "@conversation/ep3_forest_perusta:s_2820", -- If you must know.. [Perusta wipes the dirt off her hands before offering you a handshake.] My name is Perus...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2822", "s_2824"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2820)

ep3_forest_perusta_convo_s_2824 = ConvoScreen:new {
	id = "s_2824",
	leftDialog = "@conversation/ep3_forest_perusta:s_2824", -- Not very well. But I have narrowed down my experiments to a few specimens. I'll need some of the samples fr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_perusta:s_2826", "s_2832"},
		{"@conversation/ep3_forest_perusta:s_2830", "s_2832"},
	}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2824)

ep3_forest_perusta_convo_s_2828 = ConvoScreen:new {
	id = "s_2828",
	leftDialog = "@conversation/ep3_forest_perusta:s_2828", -- [Perusta smiles.] Good. Be sure to return with the moss soon. Mysess Blossoms only last for a little while....
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2828)

ep3_forest_perusta_convo_s_2832 = ConvoScreen:new {
	id = "s_2832",
	leftDialog = "@conversation/ep3_forest_perusta:s_2832", -- [Perusta shrugs.] Fine.. Suit yourself.
	stopConversation = "true",
	options = {}
}
ep3_forest_perusta_convo:addScreen(ep3_forest_perusta_convo_s_2832)

addConversationTemplate("ep3_forest_perusta_convo", ep3_forest_perusta_convo)

-- Rhiek -- ep3_forest_rhiek_quest_1, ep3_forest_rhiek_quest_2, ep3_forest_rhiek_quest_3, ep3_forest_aveso_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_rhiek_convo = ConvoTemplate:new {
	initialScreen = "s_4012",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_rhiek_conv_handler",
	screens = {}
}

ep3_forest_rhiek_convo_s_3892 = ConvoScreen:new {
	id = "s_3892",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3892", -- Mercenary.. [Rhiek nods in acknowledgement before returning to his work]
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3892)

ep3_forest_rhiek_convo_s_3894 = ConvoScreen:new {
	id = "s_3894",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3894", -- [Rhiek arches a brow, looking at you intently.] It is done, then...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3896", "s_3898"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3894)

ep3_forest_rhiek_convo_s_3908 = ConvoScreen:new {
	id = "s_3908",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3908", -- [Rhiek looks at you expectantly.] Mercenary..
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3910", "s_3912"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3908)

ep3_forest_rhiek_convo_s_3914 = ConvoScreen:new {
	id = "s_3914",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3914", -- Every decade or so, there comes a time when a new Queen is created. The prior becomes old, withered and unp...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3916", "s_3918"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3914)

ep3_forest_rhiek_convo_s_3932 = ConvoScreen:new {
	id = "s_3932",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3932", -- Mercenary... [Rhiek nods.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3934", "s_3936"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3932)

ep3_forest_rhiek_convo_s_3942 = ConvoScreen:new {
	id = "s_3942",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3942", -- [Rhiek nods.] You have returned...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3944", "s_3946"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3942)

ep3_forest_rhiek_convo_s_3952 = ConvoScreen:new {
	id = "s_3952",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3952", -- With your valuable assistance, we were able to make our poisons. Now, we must request a different sort of t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3954", "s_3956"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3952)

ep3_forest_rhiek_convo_s_3966 = ConvoScreen:new {
	id = "s_3966",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3966", -- Your stance, your expression.. [Rhiek looks you over.] .. connotes that you were successful in your task.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3968", "s_3970"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3966)

ep3_forest_rhiek_convo_s_3976 = ConvoScreen:new {
	id = "s_3976",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3976", -- Mercenary. [Rhiek nods.] Have you returned with what I seek?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3978", "s_3980"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3976)

ep3_forest_rhiek_convo_s_3982 = ConvoScreen:new {
	id = "s_3982",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3982", -- Ahh, the newest mercenary. I have heard promising reports about you from Aveso.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3984", "s_3986"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3982)

ep3_forest_rhiek_convo_s_4008 = ConvoScreen:new {
	id = "s_4008",
	leftDialog = "@conversation/ep3_forest_rhiek:s_4008", -- Ahh. [Rhiek nods.] You are not yet one of us. Seek out Zhadran in the Kerritamba village. He is our contact...
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_4008)

ep3_forest_rhiek_convo_s_4010 = ConvoScreen:new {
	id = "s_4010",
	leftDialog = "@conversation/ep3_forest_rhiek:s_4010", -- [Rhiek frowns deeply.] You are not a part of the Society. I do not wish you harm, but others will seek to d...
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_4010)

ep3_forest_rhiek_convo_s_4012 = ConvoScreen:new {
	id = "s_4012",
	leftDialog = "@conversation/ep3_forest_rhiek:s_4012", -- [Rhiek looks at you strangely.] You should not be here. It would be best if you left us in peace.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_4012)

ep3_forest_rhiek_convo_s_3898 = ConvoScreen:new {
	id = "s_3898",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3898", -- It is my hope that Mother Ves'ad did not suffer. [Rhiek raises a silencing hand as you try to speak.] I wou...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3900", "s_3902"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3898)

ep3_forest_rhiek_convo_s_3902 = ConvoScreen:new {
	id = "s_3902",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3902", -- I have nothing more to say, but I will impart my last few words of wisdom to you; only trust yourself. You ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3904", "s_3906"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3902)

ep3_forest_rhiek_convo_s_3906 = ConvoScreen:new {
	id = "s_3906",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3906", -- [Rhiek nods.] Go then. Find those among the brethren of the Society that need your assistance. However, if ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_1722", "s_1724"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3906)

ep3_forest_rhiek_convo_s_1724 = ConvoScreen:new {
	id = "s_1724",
	leftDialog = "@conversation/ep3_forest_rhiek:s_1724", -- Be safe. [Rhiek returns to his work.]
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_1724)

ep3_forest_rhiek_convo_s_3912 = ConvoScreen:new {
	id = "s_3912",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3912", -- Then you should not be here. Return to the caves, mercenary, and only return when you have helped Mother Ve...
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3912)

ep3_forest_rhiek_convo_s_3918 = ConvoScreen:new {
	id = "s_3918",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3918", -- You assume correctly. It is a graceful end for such a magnificent creature and less painful than what her c...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3920", "s_3922"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3918)

ep3_forest_rhiek_convo_s_3922 = ConvoScreen:new {
	id = "s_3922",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3922", -- Only the best. We call it 'Virulent Blackbane', or known as its common name, 'the Baron'. But with that asi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3924", "s_3930"},
		{"@conversation/ep3_forest_rhiek:s_3928", "s_3930"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3922)

ep3_forest_rhiek_convo_s_3926 = ConvoScreen:new {
	id = "s_3926",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3926", -- [Rhiek smirks.] Either way, I expect you to follow through with quick efficiency and return as soon as poss...
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3926)

ep3_forest_rhiek_convo_s_3930 = ConvoScreen:new {
	id = "s_3930",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3930", -- Your lethargic attitude concerns me. In whatever terms, you should always be willing to help a brother.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3930)

ep3_forest_rhiek_convo_s_3936 = ConvoScreen:new {
	id = "s_3936",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3936", -- Ahh. You are undoubtedly an asset to us, my friend. Please wait here for a moment. It is necessary that I p...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3938", "s_3940"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3936)

ep3_forest_rhiek_convo_s_3940 = ConvoScreen:new {
	id = "s_3940",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3940", -- There is another matter of which we must speak, my friend. I expect you to return soon.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3940)

ep3_forest_rhiek_convo_s_3946 = ConvoScreen:new {
	id = "s_3946",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3946", -- Do not be discouraged. The Tombsingers are a challenging sort. I have no doubt you will return triumphant. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3948", "s_3950"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3946)

ep3_forest_rhiek_convo_s_3950 = ConvoScreen:new {
	id = "s_3950",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3950", -- [Rhiek nods before returning to his work.]
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3950)

ep3_forest_rhiek_convo_s_3956 = ConvoScreen:new {
	id = "s_3956",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3956", -- I do not appreciate the term 'bug', mercenary. [Rhiek frowns, but continues.] Various parts of the Webweave...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3958", "s_3964"},
		{"@conversation/ep3_forest_rhiek:s_3962", "s_3964"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3956)

ep3_forest_rhiek_convo_s_3960 = ConvoScreen:new {
	id = "s_3960",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3960", -- [Rhiek smiles.] Go then. We will watch over you.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3960)

ep3_forest_rhiek_convo_s_3964 = ConvoScreen:new {
	id = "s_3964",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3964", -- I will dismiss your poor attitude as mere ignorance.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3964)

ep3_forest_rhiek_convo_s_3970 = ConvoScreen:new {
	id = "s_3970",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3970", -- This news pleases me. [Rhiek takes the glands from you.] Good quality too. I will put these aside in specia...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3972", "s_3974"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3970)

ep3_forest_rhiek_convo_s_3974 = ConvoScreen:new {
	id = "s_3974",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3974", -- Aveso said I could count on you. I am glad she was right.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3974)

ep3_forest_rhiek_convo_s_3980 = ConvoScreen:new {
	id = "s_3980",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3980", -- I see. You must hurry with your task. I have much for you to do when you return.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3980)

ep3_forest_rhiek_convo_s_3986 = ConvoScreen:new {
	id = "s_3986",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3986", -- [Rhiek nods simply.] We do have ranks within the Society. You have finished your grunt work. However, that ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3988", "s_3990"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3986)

ep3_forest_rhiek_convo_s_3990 = ConvoScreen:new {
	id = "s_3990",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3990", -- Of course. Aveso said you were quite sure of yourself. We will see how that trait progresses. Now, onto bus...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3992", "s_3994"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3990)

ep3_forest_rhiek_convo_s_3994 = ConvoScreen:new {
	id = "s_3994",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3994", -- [Rhiek nods.] Exactly. You must learn how to properly use the Webweaver poisons by first learning how to ex...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_3996", "s_4006"},
		{"@conversation/ep3_forest_rhiek:s_4004", "s_4002"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3994)

ep3_forest_rhiek_convo_s_3998 = ConvoScreen:new {
	id = "s_3998",
	leftDialog = "@conversation/ep3_forest_rhiek:s_3998", -- That is all I can expect. As a mercenary, you must learn the art of the kill. May it be as swift and painle...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_rhiek:s_4000", "s_4002"},
	}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_3998)

ep3_forest_rhiek_convo_s_4006 = ConvoScreen:new {
	id = "s_4006",
	leftDialog = "@conversation/ep3_forest_rhiek:s_4006", -- [Rhiek sneers.] How disrespectful. Like us, they are assassins. They should be revered as deadly tools. I s...
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_4006)

ep3_forest_rhiek_convo_s_4002 = ConvoScreen:new {
	id = "s_4002",
	leftDialog = "@conversation/ep3_forest_rhiek:s_4002", -- I await your return, mercenary.
	stopConversation = "true",
	options = {}
}
ep3_forest_rhiek_convo:addScreen(ep3_forest_rhiek_convo_s_4002)

addConversationTemplate("ep3_forest_rhiek_convo", ep3_forest_rhiek_convo)

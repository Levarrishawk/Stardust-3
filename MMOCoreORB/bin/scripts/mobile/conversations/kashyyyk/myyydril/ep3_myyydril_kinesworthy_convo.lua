-- ep3_myyydril_kinesworthy
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_kinesworthy_convo = ConvoTemplate:new {
	initialScreen = "s_4172",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_kinesworthy_conv_handler",
	screens = {}
}

ep3_myyydril_kinesworthy_convo_s_4016 = ConvoScreen:new {
	id = "s_4016",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4016", -- [The doctor stares.] I have nothing else for you. I must continue my work. [The doctor turns, still staring, and mutters, '...for you alo...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4016)

ep3_myyydril_kinesworthy_convo_s_4018 = ConvoScreen:new {
	id = "s_4018",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4018", -- By your expression, I was correct. What was Treun Lorn working on down there?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4020", "s_4022"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4018)

ep3_myyydril_kinesworthy_convo_s_4022 = ConvoScreen:new {
	id = "s_4022",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4022", -- N-K 'Necrosis'? I should have known. This was graver than I had thought. And you defeated him? Amazing. I obviously underestimated you. [...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4024", "s_4026"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4022)

ep3_myyydril_kinesworthy_convo_s_4026 = ConvoScreen:new {
	id = "s_4026",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4026", -- My partner, Treun Lorn? Of course. He was able to manipulate the most awe-inspiring creation in the world of cybernetics. But... [The doc...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4028", "s_4030"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4026)

ep3_myyydril_kinesworthy_convo_s_4030 = ConvoScreen:new {
	id = "s_4030",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4030", -- Mmm. [The doctor continues to stare. Was that anger flashing in his eyes? Perhaps Kinesworthy wishes it had been him in the Deep Depths w...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4030)

ep3_myyydril_kinesworthy_convo_s_4032 = ConvoScreen:new {
	id = "s_4032",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4032", -- Have you found any information regarding Treun Lorn and his projects?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4034", "s_4036"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4032)

ep3_myyydril_kinesworthy_convo_s_4036 = ConvoScreen:new {
	id = "s_4036",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4036", -- I don't want to hear any excuses! Get down there and find out anything you can.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4036)

ep3_myyydril_kinesworthy_convo_s_4038 = ConvoScreen:new {
	id = "s_4038",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4038", -- Thanks to you, my machine is completely working. One of the features of this hulk of metal is to detect the frequency of high-powered mac...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4040", "s_4042"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4038)

ep3_myyydril_kinesworthy_convo_s_4042 = ConvoScreen:new {
	id = "s_4042",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4042", -- Precisely. I know him well, and I have no doubt that he has brought his project here to the Myyydril Caverns and sought to continue it in...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4044", "s_4046"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4042)

ep3_myyydril_kinesworthy_convo_s_4046 = ConvoScreen:new {
	id = "s_4046",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4046", -- I hope you're right. But nothing can be certain when dealing with Treun Lorn.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4046)

ep3_myyydril_kinesworthy_convo_s_4048 = ConvoScreen:new {
	id = "s_4048",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4048", -- You've returned. Let me see the part. [The doctor extends his hand.] I'm going to place this into the machine and hope that it works.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4050", "s_4052"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4048)

ep3_myyydril_kinesworthy_convo_s_4052 = ConvoScreen:new {
	id = "s_4052",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4052", -- Let me see it. [Kinesworthy looks over the cybernetic part.] I see. I can fix it, if that's what you want. Let me see what I can do.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4054", "s_4056"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4052)

ep3_myyydril_kinesworthy_convo_s_4056 = ConvoScreen:new {
	id = "s_4056",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4056", -- [The doctor mulls around, tinkering with the cybernetic part for a moment or two.] There. It should be in working order.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4058", "s_4060"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4056)

ep3_myyydril_kinesworthy_convo_s_4060 = ConvoScreen:new {
	id = "s_4060",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4060", -- I'm going to continue fiddling with my machine. If it doesn't work, I'll need your help finding out why.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4060)

ep3_myyydril_kinesworthy_convo_s_4062 = ConvoScreen:new {
	id = "s_4062",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4062", -- You still haven't done what I told you to. Why are you here? I don't want to talk about it until you're successful in your job!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4064", "s_4066"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4062)

ep3_myyydril_kinesworthy_convo_s_4066 = ConvoScreen:new {
	id = "s_4066",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4066", -- [The doctor nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4066)

ep3_myyydril_kinesworthy_convo_s_4068 = ConvoScreen:new {
	id = "s_4068",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4068", -- Oh, it's you. [Kinesworthy frowns.] What do you want?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4070", "s_4072"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4068)

ep3_myyydril_kinesworthy_convo_s_4072 = ConvoScreen:new {
	id = "s_4072",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4072", -- [Kinesworthy sighs.] It's just hopeless. Not all the things I need to continue my work were in the storage box. I am missing a key part t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4074", "s_4076"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4072)

ep3_myyydril_kinesworthy_convo_s_4076 = ConvoScreen:new {
	id = "s_4076",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4076", -- It would make more sense if I told you a little more behind the story. Bear with me. During my hunt to find Treun Lorn, I was stationed a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4078", "s_4080"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4076)

ep3_myyydril_kinesworthy_convo_s_4080 = ConvoScreen:new {
	id = "s_4080",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4080", -- [Kinesworthy frowns, eyes bleak with memories.] I was ordered to practice my expertise on Wookiee slaves. I was supposed to make them str...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4082", "s_4084"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4080)

ep3_myyydril_kinesworthy_convo_s_4084 = ConvoScreen:new {
	id = "s_4084",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4084", -- I had to free them. [The Doctor continues, staring off into the distance.] I had to free them. When the Wookiees came to free their frien...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4086", "s_4088"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4084)

ep3_myyydril_kinesworthy_convo_s_4088 = ConvoScreen:new {
	id = "s_4088",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4088", -- Yes. And still are. Erryia, one of the Wookiees who chose to come with me, had stolen a part of my machine. He ran off with it. He had ho...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4090", "s_4092"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4088)

ep3_myyydril_kinesworthy_convo_s_4092 = ConvoScreen:new {
	id = "s_4092",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4092", -- [The doctor looks up.] Yes. Maybe he still has the part. I don't know. Just.. go look. See what you can find. I understand that many of t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4094", "s_4096"},
		{"@conversation/ep3_myyydril_kinesworthy:s_4098", "s_4100"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4092)

ep3_myyydril_kinesworthy_convo_s_4096 = ConvoScreen:new {
	id = "s_4096",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4096", -- Then, go. I don't wish to speak of it anymore.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4096)

ep3_myyydril_kinesworthy_convo_s_4100 = ConvoScreen:new {
	id = "s_4100",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4100", -- It may be better that way.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4100)

ep3_myyydril_kinesworthy_convo_s_4102 = ConvoScreen:new {
	id = "s_4102",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4102", -- [Kinesworthy stares, expression incredulous.] My equipment? Where did you find it?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4104", "s_4106"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4102)

ep3_myyydril_kinesworthy_convo_s_4106 = ConvoScreen:new {
	id = "s_4106",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4106", -- Hmm. I suppose. Let's see what's in here. [Kinesworthy opens the box and looks inside.] I haven't seen this stuff in years. [The Doctor p...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4108", "s_4110"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4106)

ep3_myyydril_kinesworthy_convo_s_4110 = ConvoScreen:new {
	id = "s_4110",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4110", -- Let me look through my things for awhile. It doesn't seem to be all here. I may need your help again.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4110)

ep3_myyydril_kinesworthy_convo_s_4112 = ConvoScreen:new {
	id = "s_4112",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4112", -- [The Doctor looks up.] What are you doing here? I thought you were going to help me find my equipment so I can help with Myyydril people?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4114", "s_4116"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4112)

ep3_myyydril_kinesworthy_convo_s_4116 = ConvoScreen:new {
	id = "s_4116",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4116", -- [Kinesworthy just waves his hand dismissively.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4116)

ep3_myyydril_kinesworthy_convo_s_4118 = ConvoScreen:new {
	id = "s_4118",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4118", -- [Doctor Kinesworthy looks up from his work table.] I've been watching you. You come in here, help the Myyydril and you're all of a sudden...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4120", "s_4122"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4118)

ep3_myyydril_kinesworthy_convo_s_4122 = ConvoScreen:new {
	id = "s_4122",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4122", -- If you hurt these people... [Kinesworthy shakes a finger.] It'll be the last thing you do.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4124", "s_4126"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4122)

ep3_myyydril_kinesworthy_convo_s_4126 = ConvoScreen:new {
	id = "s_4126",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4126", -- You have no idea...! [Kinesworthy starts in a raised voice. He takes a deep breath.] You have no idea what we've been through down here i...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4128", "s_4130"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4126)

ep3_myyydril_kinesworthy_convo_s_4130 = ConvoScreen:new {
	id = "s_4130",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4130", -- What *is* normal around here in this pit of despair?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4132", "s_4134"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4130)

ep3_myyydril_kinesworthy_convo_s_4134 = ConvoScreen:new {
	id = "s_4134",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4134", -- There are so many things you don't know. [Kinesworthy sighs, rubbing his temple.] I am a doctor specializing in making and attaching cybe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4136", "s_4138"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4134)

ep3_myyydril_kinesworthy_convo_s_4138 = ConvoScreen:new {
	id = "s_4138",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4138", -- No. I have since lost the will and the machinery to continue my work. And... [Kinesworthy traces the scar over his eye with a finger.] Ev...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4140", "s_4142"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4138)

ep3_myyydril_kinesworthy_convo_s_4142 = ConvoScreen:new {
	id = "s_4142",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4142", -- [Kinesworthy glares.] Why do you want to know so much? Do you belong to the Empire? Are you a spy?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4144", "s_4146"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4142)

ep3_myyydril_kinesworthy_convo_s_4146 = ConvoScreen:new {
	id = "s_4146",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4146", -- Fine, fine. Treun Lorn and I were partners in the field of cybernetics. We had opened a practice together before he... [Kinesworthy strug...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4148", "s_4150"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4146)

ep3_myyydril_kinesworthy_convo_s_4150 = ConvoScreen:new {
	id = "s_4150",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4150", -- I don't know, honestly. He was always a little... out there. Always working on some secret project. I knew him when he didn't know a lick...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4152", "s_4154"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4150)

ep3_myyydril_kinesworthy_convo_s_4154 = ConvoScreen:new {
	id = "s_4154",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4154", -- Uh... [Kinesworthy shakes his head.] No. You already know too much. After his 'special project', details of which I still don't know, he ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4156", "s_4158"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4154)

ep3_myyydril_kinesworthy_convo_s_4158 = ConvoScreen:new {
	id = "s_4158",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4158", -- In all brevity, if the Virus isn't cured, the victim can lose their limbs. And I can't help them. I've since lost my equipment, all the t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4160", "s_4162"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4158)

ep3_myyydril_kinesworthy_convo_s_4162 = ConvoScreen:new {
	id = "s_4162",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4162", -- Hmm. [Kinesworthy rubs his chin.] Now that you've asked... While chasing down Treun Lorn, I naturally brought my equipment with me. I had...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4164", "s_4166"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4162)

ep3_myyydril_kinesworthy_convo_s_4166 = ConvoScreen:new {
	id = "s_4166",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4166", -- I suppose. If only to help the Myyydril people should the Poltur Virus inflict them beyond what natural medicine can cure. Find the Imper...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_kinesworthy:s_4168", "s_4170"},
	}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4166)

ep3_myyydril_kinesworthy_convo_s_4170 = ConvoScreen:new {
	id = "s_4170",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4170", -- [The Doctor nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4170)

ep3_myyydril_kinesworthy_convo_s_4172 = ConvoScreen:new {
	id = "s_4172",
	leftDialog = "@conversation/ep3_myyydril_kinesworthy:s_4172", -- Who are you and why are you here? Can't you see I'm busy? I don't talk to strangers.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_kinesworthy_convo:addScreen(ep3_myyydril_kinesworthy_convo_s_4172)

addConversationTemplate("ep3_myyydril_kinesworthy_convo", ep3_myyydril_kinesworthy_convo)

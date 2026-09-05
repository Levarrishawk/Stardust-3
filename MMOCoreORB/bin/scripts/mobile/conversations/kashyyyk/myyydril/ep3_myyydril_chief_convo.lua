-- ep3_myyydril_chief
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_chief_convo = ConvoTemplate:new {
	initialScreen = "s_3846",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_chief_conv_handler",
	screens = {}
}

ep3_myyydril_chief_convo_s_1076 = ConvoScreen:new {
	id = "s_1076",
	leftDialog = "@conversation/ep3_myyydril_chief:s_1076", -- Rrwowrr!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_1076)

ep3_myyydril_chief_convo_s_1113 = ConvoScreen:new {
	id = "s_1113",
	leftDialog = "@conversation/ep3_myyydril_chief:s_1113", -- I've decided to trust you and I have tasks only set for the most willing and noble of our people. So far, you have proven yourself. We of...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_1115", "s_1117"},
		{"@conversation/ep3_myyydril_chief:s_1119", "s_1121"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_1113)

ep3_myyydril_chief_convo_s_1117 = ConvoScreen:new {
	id = "s_1117",
	leftDialog = "@conversation/ep3_myyydril_chief:s_1117", -- Good. Go forth and slaughter them so that we may live in continued peace.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_1117)

ep3_myyydril_chief_convo_s_1121 = ConvoScreen:new {
	id = "s_1121",
	leftDialog = "@conversation/ep3_myyydril_chief:s_1121", -- Understood. Return when you are willing.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_1121)

ep3_myyydril_chief_convo_s_3742 = ConvoScreen:new {
	id = "s_3742",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3742", -- [nods] Welcome home, Hero. Our patrols have been quiet as of late and no other terrible situations have come up. I will keep you updated ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3744", "s_3746"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3742)

ep3_myyydril_chief_convo_s_3746 = ConvoScreen:new {
	id = "s_3746",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3746", -- [Kallaarac nods.] And we owe it all to you, hero.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3746)

ep3_myyydril_chief_convo_s_3748 = ConvoScreen:new {
	id = "s_3748",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3748", -- No words can express how much our community is thankful for all that you've done for us. You've defeated the Mother Brain... a remarkable...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3750", "s_3752"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3748)

ep3_myyydril_chief_convo_s_3752 = ConvoScreen:new {
	id = "s_3752",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3752", -- You are a hero in our eyes. I wish there were more for you to help us with. But alas, it is not so. Please enjoy the rest our community h...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3754", "s_3756"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3752)

ep3_myyydril_chief_convo_s_3756 = ConvoScreen:new {
	id = "s_3756",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3756", -- Welcome home, Hero.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3756)

ep3_myyydril_chief_convo_s_3758 = ConvoScreen:new {
	id = "s_3758",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3758", -- You've returned... and empty handed. I am not disappointed. I realize your task is very daunting. But, we the Myyydril, have faith in you...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3758)

ep3_myyydril_chief_convo_s_3760 = ConvoScreen:new {
	id = "s_3760",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3760", -- You wished to know of the new threat looming before us... The Urnsor'is operate around a central nervous system. We only know her as the ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3762", "s_3764"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3760)

ep3_myyydril_chief_convo_s_3764 = ConvoScreen:new {
	id = "s_3764",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3764", -- It is. I suggest bringing several friends. We cannot offer you help in this matter. Our soldiers, what little we have, are helping our pe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3766", "s_3768"},
		{"@conversation/ep3_myyydril_chief:s_3770", "s_3772"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3764)

ep3_myyydril_chief_convo_s_3768 = ConvoScreen:new {
	id = "s_3768",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3768", -- You're a brave soul indeed. Go then. You'll find her in the Deep Depths. I hope you'll return safely.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3768)

ep3_myyydril_chief_convo_s_3772 = ConvoScreen:new {
	id = "s_3772",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3772", -- Completely understood. Just... make a decision quickly. If she is not destroyed, our village will never be safe.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3772)

ep3_myyydril_chief_convo_s_3774 = ConvoScreen:new {
	id = "s_3774",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3774", -- I've heard news of your success! Soon, we will see dwindling numbers in the ranks of the Urnsor'is thanks to your continued efforts. But ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3776", "s_3778"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3774)

ep3_myyydril_chief_convo_s_3778 = ConvoScreen:new {
	id = "s_3778",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3778", -- We'll speak of this soon. For now, I suggest taking a long-needed breath of air before throwing yourself deeper into our caverns. A big b...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3780", "s_3782"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3778)

ep3_myyydril_chief_convo_s_3782 = ConvoScreen:new {
	id = "s_3782",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3782", -- Come speak with me again when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3782)

ep3_myyydril_chief_convo_s_3784 = ConvoScreen:new {
	id = "s_3784",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3784", -- I see you have returned, my friend. The more we wait, the more eggs that are produced. We need to hurry. Please, continue your objectives.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3784)

ep3_myyydril_chief_convo_s_3786 = ConvoScreen:new {
	id = "s_3786",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3786", -- We find ourselves in a constant unease in regards to the Urnsor'is, however. And we must strike them at the base. This time, I need you t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3788", "s_3790"},
		{"@conversation/ep3_myyydril_chief:s_3792", "s_3794"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3786)

ep3_myyydril_chief_convo_s_3790 = ConvoScreen:new {
	id = "s_3790",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3790", -- Your eagerness is refreshing and a little reckless. You're a great warrior in our eyes, however. Please go and come back safely.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3790)

ep3_myyydril_chief_convo_s_3794 = ConvoScreen:new {
	id = "s_3794",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3794", -- I understand. I do not hold it against you.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3794)

ep3_myyydril_chief_convo_s_3796 = ConvoScreen:new {
	id = "s_3796",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3796", -- Remarkable. I've heard of your success, my friend, against the Urnsor'is.  Our people have calmed more and are going about their normal l...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3798", "s_3800"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3796)

ep3_myyydril_chief_convo_s_3800 = ConvoScreen:new {
	id = "s_3800",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3800", -- You deserve a token of our gratitude. Please accept this.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3802", "s_3804"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3800)

ep3_myyydril_chief_convo_s_3804 = ConvoScreen:new {
	id = "s_3804",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3804", -- I must speak with my advisors. I do have other tasks for you. Please speak with me in a moment.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3804)

ep3_myyydril_chief_convo_s_3806 = ConvoScreen:new {
	id = "s_3806",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3806", -- You've returned so quickly. I don't understand. You've not yet completed your task. Please, hurry. I fear the Urnsor'is infestation will ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3808", "s_3810"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3806)

ep3_myyydril_chief_convo_s_3810 = ConvoScreen:new {
	id = "s_3810",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3810", -- [Kallaarac nods.] I know you'll come out successful, my friend. Worry not.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3810)

ep3_myyydril_chief_convo_s_3812 = ConvoScreen:new {
	id = "s_3812",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3812", -- I've heard about the great many accomplishments you are contributing to our village. You are an honorable addition to our community.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3814", "s_3816"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3812)

ep3_myyydril_chief_convo_s_3816 = ConvoScreen:new {
	id = "s_3816",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3816", -- I have more tests for you. Please talk with me in a few moments. I have much to think about regarding your role in our village.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3816)

ep3_myyydril_chief_convo_s_3826 = ConvoScreen:new {
	id = "s_3826",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3826", -- I see you have returned. Unfortunately, a little too prematurely. There are others than Tala'oree who need help. Please return when you h...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3828", "s_3830"},
		{"@conversation/ep3_myyydril_chief:s_363", "s_3836"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3826)

ep3_myyydril_chief_convo_s_3830 = ConvoScreen:new {
	id = "s_3830",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3830", -- [Kallaarac nods.] Indeed...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3830)

ep3_myyydril_chief_convo_s_3832 = ConvoScreen:new {
	id = "s_3832",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3832", -- You've spoken with Kivvaaa? I see. She must trust you, then. [Kallaarac nods.] We only request help from those we trust. Perhaps you're t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3834", "s_3836"},
		{"@conversation/ep3_myyydril_chief:s_3842", "s_3844"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3832)

ep3_myyydril_chief_convo_s_3836 = ConvoScreen:new {
	id = "s_3836",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3836", -- [Kallaarac nods.] I care very strongly for my people. Therefore, my problems and issues come second. I want you to speak with the individ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_chief:s_3838", "s_3840"},
	}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3836)

ep3_myyydril_chief_convo_s_3840 = ConvoScreen:new {
	id = "s_3840",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3840", -- [Kallaraac nods.] Good. Go speak with her and follow her direction.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3840)

ep3_myyydril_chief_convo_s_3844 = ConvoScreen:new {
	id = "s_3844",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3844", -- [nod]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3844)

ep3_myyydril_chief_convo_s_3846 = ConvoScreen:new {
	id = "s_3846",
	leftDialog = "@conversation/ep3_myyydril_chief:s_3846", -- You dare approach me without an audience? I will not speak with you unless you've gained our trust. Go away.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_chief_convo:addScreen(ep3_myyydril_chief_convo_s_3846)

addConversationTemplate("ep3_myyydril_chief_convo", ep3_myyydril_chief_convo)

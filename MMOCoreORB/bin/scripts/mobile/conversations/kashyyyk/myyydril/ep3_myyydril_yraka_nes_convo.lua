-- ep3_myyydril_yraka_nes
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_yraka_nes_convo = ConvoTemplate:new {
	initialScreen = "s_1133",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_yraka_nes_conv_handler",
	screens = {}
}

ep3_myyydril_yraka_nes_convo_s_894 = ConvoScreen:new {
	id = "s_894",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_894", -- Oh hello! I'm so glad you're back. How are you? Are you doing well? Things are quiet out here. Not too much to do around here anymore. I ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_898", "s_902"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_894)

ep3_myyydril_yraka_nes_convo_s_902 = ConvoScreen:new {
	id = "s_902",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_902", -- Be safe! [Yraka Nes smiles kindly.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_902)

ep3_myyydril_yraka_nes_convo_s_906 = ConvoScreen:new {
	id = "s_906",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_906", -- I'm so glad you've returned. Were you able to find the resin?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_910", "s_914"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_906)

ep3_myyydril_yraka_nes_convo_s_914 = ConvoScreen:new {
	id = "s_914",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_914", -- Perfect! Let me see what I can do with it. [Yraka Nes fiddles with it and places it inside the cybernetic part.] There. That should do it...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_916", "s_918"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_914)

ep3_myyydril_yraka_nes_convo_s_918 = ConvoScreen:new {
	id = "s_918",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_918", -- I hope you can put some good use to it.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_918)

ep3_myyydril_yraka_nes_convo_s_920 = ConvoScreen:new {
	id = "s_920",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_920", -- [Yraka Nes smiles.] Oh, welcome back! Do you have the resin with you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_922", "s_924"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_920)

ep3_myyydril_yraka_nes_convo_s_924 = ConvoScreen:new {
	id = "s_924",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_924", -- Just come back safe. I like seeing you around.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_924)

ep3_myyydril_yraka_nes_convo_s_926 = ConvoScreen:new {
	id = "s_926",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_926", -- You spoke to the Doctor? What did he say? [Yraka Nes smiles kindly.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_928", "s_930"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_926)

ep3_myyydril_yraka_nes_convo_s_930 = ConvoScreen:new {
	id = "s_930",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_930", -- Cybernetic parts? Hmm... I have something like that around here too. I'm afraid it isn't working, however. I'll need to fix it up. I used...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_932", "s_934"},
		{"@conversation/ep3_myyydril_yraka_nes:s_948", "s_950"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_930)

ep3_myyydril_yraka_nes_convo_s_934 = ConvoScreen:new {
	id = "s_934",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_934", -- It won't be easy, unfortunately. The part I have requires special healing resin in order for it to work. We usually got it imported from ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_936", "s_938"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_934)

ep3_myyydril_yraka_nes_convo_s_938 = ConvoScreen:new {
	id = "s_938",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_938", -- Indeed. What do you think? It's not an adventure to take lightly.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_940", "s_942"},
		{"@conversation/ep3_myyydril_yraka_nes:s_944", "s_946"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_938)

ep3_myyydril_yraka_nes_convo_s_942 = ConvoScreen:new {
	id = "s_942",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_942", -- Good. Come back soon and in one piece.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_942)

ep3_myyydril_yraka_nes_convo_s_946 = ConvoScreen:new {
	id = "s_946",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_946", -- I do understand. If you ever change your mind, I'll be right here.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_946)

ep3_myyydril_yraka_nes_convo_s_950 = ConvoScreen:new {
	id = "s_950",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_950", -- If you ever change your mind, I'm here. [ Yraka Nes smiles.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_950)

ep3_myyydril_yraka_nes_convo_s_952 = ConvoScreen:new {
	id = "s_952",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_952", -- Doctor Kinesworthy is still asking for you. You haven't spoken to him yet?
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_952)

ep3_myyydril_yraka_nes_convo_s_955 = ConvoScreen:new {
	id = "s_955",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_955", -- It's so nice to see you again. I hope you're well.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_957", "s_959"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_955)

ep3_myyydril_yraka_nes_convo_s_959 = ConvoScreen:new {
	id = "s_959",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_959", -- I've been quite well. Actually, things have been peaceful thanks to you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_961", "s_963"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_959)

ep3_myyydril_yraka_nes_convo_s_963 = ConvoScreen:new {
	id = "s_963",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_963", -- Well... Doctor Kinesworthy has taken quite an interest in you. You should go speak with him. [Yraka Nes leans in closer.] And tell him I ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_965", "s_967"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_963)

ep3_myyydril_yraka_nes_convo_s_967 = ConvoScreen:new {
	id = "s_967",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_967", -- Go on then, silly. Don't keep the doctor waiting.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_967)

ep3_myyydril_yraka_nes_convo_s_969 = ConvoScreen:new {
	id = "s_969",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_969", -- You've returned safely. I hope my silly errands haven't been too much for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_971", "s_973"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_969)

ep3_myyydril_yraka_nes_convo_s_973 = ConvoScreen:new {
	id = "s_973",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_973", -- Thank you so much!! Now, I can readily help those who have come in from the hunting party. I've prepared another gift for you. Thank you ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_975", "s_977"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_973)

ep3_myyydril_yraka_nes_convo_s_977 = ConvoScreen:new {
	id = "s_977",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_977", -- I wish I had other things for you to help me with, but I do not. Perhaps, I will at a later time. I hope you'll at least come visit.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_977)

ep3_myyydril_yraka_nes_convo_s_979 = ConvoScreen:new {
	id = "s_979",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_979", -- Were you able to find those medical boxes? I really need them. The hunting party is starting to come back and they have the wounded among...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_979)

ep3_myyydril_yraka_nes_convo_s_981 = ConvoScreen:new {
	id = "s_981",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_981", -- I'm so glad you've returned to us. How are you feeling this evening? If you're up to it, I have another task that needs to be done.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_983", "s_985"},
		{"@conversation/ep3_myyydril_yraka_nes:s_995", "s_997"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_981)

ep3_myyydril_yraka_nes_convo_s_985 = ConvoScreen:new {
	id = "s_985",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_985", -- We were able to seize boxes of medical supplies from a nearby Imperial camp. The person responsible for delivering the supplies placed th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_987", "s_989"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_985)

ep3_myyydril_yraka_nes_convo_s_989 = ConvoScreen:new {
	id = "s_989",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_989", -- I knew I could count on you. You're so kind to us. I don't think I could ever repay you in my lifetime.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_991", "s_993"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_989)

ep3_myyydril_yraka_nes_convo_s_993 = ConvoScreen:new {
	id = "s_993",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_993", -- [Yraka Nes smiles kindly.] Thank you so much. Please hurry back.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_993)

ep3_myyydril_yraka_nes_convo_s_997 = ConvoScreen:new {
	id = "s_997",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_997", -- Okay. Let me know if I can help you at all.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_997)

ep3_myyydril_yraka_nes_convo_s_999 = ConvoScreen:new {
	id = "s_999",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_999", -- I was getting worried for you out there. Are you okay?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1001", "s_1003"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_999)

ep3_myyydril_yraka_nes_convo_s_1003 = ConvoScreen:new {
	id = "s_1003",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1003", -- Thank you so much! Now, I'll be able to make my pies again. You've done so much for us. [Yraka Nes smiles gently.] Thank you. I've prepar...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1005", "s_1007"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1003)

ep3_myyydril_yraka_nes_convo_s_1007 = ConvoScreen:new {
	id = "s_1007",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1007", -- My pleasure. Please come back when you feel you can. I do have another thing that needs to be done.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1007)

ep3_myyydril_yraka_nes_convo_s_1009 = ConvoScreen:new {
	id = "s_1009",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1009", -- Hello, again. Were you able to find the Mushrooms I needed? They grow in the caves. You should be able to find them easily. Return to me ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1011", "s_1013"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1009)

ep3_myyydril_yraka_nes_convo_s_1013 = ConvoScreen:new {
	id = "s_1013",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1013", -- [Yraka Nes nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1013)

ep3_myyydril_yraka_nes_convo_s_1015 = ConvoScreen:new {
	id = "s_1015",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1015", -- I'm glad you've returned. I have another task, if you're interested. Of course, I'd understand it if you're too busy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1017", "s_1019"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1029", "s_1031"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1015)

ep3_myyydril_yraka_nes_convo_s_1019 = ConvoScreen:new {
	id = "s_1019",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1019", -- Well, I find it most rewarding to keep our community in high spirits while our warriors and defenders are out fighting against the Urnsor...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1021", "s_1023"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1025", "s_1027"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1019)

ep3_myyydril_yraka_nes_convo_s_1023 = ConvoScreen:new {
	id = "s_1023",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1023", -- Wonderful! I'll most likely be here when you get back. Just... try and be careful out there.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1023)

ep3_myyydril_yraka_nes_convo_s_1027 = ConvoScreen:new {
	id = "s_1027",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1027", -- Okay, well... Let me know when you're not busy.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1027)

ep3_myyydril_yraka_nes_convo_s_1031 = ConvoScreen:new {
	id = "s_1031",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1031", -- Return when you're ready, then, my friend.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1031)

ep3_myyydril_yraka_nes_convo_s_1033 = ConvoScreen:new {
	id = "s_1033",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1033", -- The webweaver strands! Thank you so much for bringing them. [Yraka Nes holds the strands tightly in her hands, eyes glittering with grati...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1035", "s_1037"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1033)

ep3_myyydril_yraka_nes_convo_s_1037 = ConvoScreen:new {
	id = "s_1037",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1037", -- Please come back, if you have some extra time. We could use an able hand around here again.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1037)

ep3_myyydril_yraka_nes_convo_s_1039 = ConvoScreen:new {
	id = "s_1039",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1039", -- You're back. [Yraka Nes nods her head deeply in respect.] I'm so sorry to be rude, but... we need those webweaver strands. Please find th...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1039)

ep3_myyydril_yraka_nes_convo_s_1041 = ConvoScreen:new {
	id = "s_1041",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1041", -- [Yraka Nes nods in kind greeting.] I've never seen your face before. I would have remembered someone with such kind features such as your...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1043", "s_1045"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1041)

ep3_myyydril_yraka_nes_convo_s_1045 = ConvoScreen:new {
	id = "s_1045",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1045", -- My name is Yraka Nes and I am the medical care-taker of the Myyydril people. My work is hard, but very rewarding. The Myyydril Tribe has ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1047", "s_1049"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1045)

ep3_myyydril_yraka_nes_convo_s_1049 = ConvoScreen:new {
	id = "s_1049",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1049", -- Oh. It's such a long story. Surely, you don't want to hear about that. I'm afraid it's pretty boring.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1051", "s_1053"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1096", "s_1098"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1049)

ep3_myyydril_yraka_nes_convo_s_1053 = ConvoScreen:new {
	id = "s_1053",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1053", -- Okay. Well... [Yraka Nes rubs her neck tiredly.] Long ago, I was the medical doctor aboard the T-S Sunstriker stationed here on Kashyyyk....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1055", "s_1057"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1053)

ep3_myyydril_yraka_nes_convo_s_1057 = ConvoScreen:new {
	id = "s_1057",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1057", -- Well... the Empire launched an attack at our camp; a camp they used to control and a place where they harbored Wookiee slaves. My crew pa...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1059", "s_1061"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1057)

ep3_myyydril_yraka_nes_convo_s_1061 = ConvoScreen:new {
	id = "s_1061",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1061", -- No, no... just their medical advisor. The captain of the ship just miscounted her crew and I was left here during the confusion. But, I'm...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1063", "s_1065"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1061)

ep3_myyydril_yraka_nes_convo_s_1065 = ConvoScreen:new {
	id = "s_1065",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1065", -- Indeed, it was. Hey--you seem like a very nice person. Times here have been rough and there's plenty to do. Unfortunately, another case o...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1067", "s_1069"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1080", "s_1082"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1065)

ep3_myyydril_yraka_nes_convo_s_1069 = ConvoScreen:new {
	id = "s_1069",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1069", -- Well, at this time, we need Webweaver Blankets. Webweaver Blankets are used to soothe our afflicted patients. They are made from the silk...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1071", "s_1073"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1075", "s_1078"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1069)

ep3_myyydril_yraka_nes_convo_s_1073 = ConvoScreen:new {
	id = "s_1073",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1073", -- I'm so glad. Thank you, my friend. Please hurry. The Webweaver Blankets lift up the afflicted's spirits. I'm afraid they're dwindling fast.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1073)

ep3_myyydril_yraka_nes_convo_s_1078 = ConvoScreen:new {
	id = "s_1078",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1078", -- I understand. Please see me when you're available again. I know how it is around here. [Yraka Nes smiles kindly.] Busy, busy, busy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1078)

ep3_myyydril_yraka_nes_convo_s_1082 = ConvoScreen:new {
	id = "s_1082",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1082", -- The Poltur Virus is a wicked ailment one can catch by coming in contact with an Urnsor'is. It usually happens when the victim has miracul...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1084", "s_1086"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1082)

ep3_myyydril_yraka_nes_convo_s_1086 = ConvoScreen:new {
	id = "s_1086",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1086", -- Well, at this time, we need Webweaver Blankets. Webweaver Blankets are used to soothe our afflicted patients. They are made from the silk...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1088", "s_1090"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1092", "s_1094"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1086)

ep3_myyydril_yraka_nes_convo_s_1090 = ConvoScreen:new {
	id = "s_1090",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1090", -- I'm so glad. Thank you, my friend. Please hurry. The Webweaver Blankets lift up the afflicted's spirits. I'm afraid they're dwindling fast.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1090)

ep3_myyydril_yraka_nes_convo_s_1094 = ConvoScreen:new {
	id = "s_1094",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1094", -- I understand. Please see me when you're available again. I know how it is around here. [Yraka Nes smiles kindly.] Busy, busy, busy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1094)

ep3_myyydril_yraka_nes_convo_s_1098 = ConvoScreen:new {
	id = "s_1098",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1098", -- Indeed. Hey--you seem like a very nice person. Times here have been rough and there's plenty to do. Unfortunately, another case of the Po...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1100", "s_1102"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1112", "s_1116"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1098)

ep3_myyydril_yraka_nes_convo_s_1102 = ConvoScreen:new {
	id = "s_1102",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1102", -- Well, at this time, we need Webweaver Blankets. Webweaver Blankets are used to soothe our afflicted patients. They are made from the silk...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1104", "s_1106"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1108", "s_1110"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1102)

ep3_myyydril_yraka_nes_convo_s_1106 = ConvoScreen:new {
	id = "s_1106",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1106", -- I'm so glad. Thank you, my friend. Please hurry. The Webweaver Blankets lift up the afflicted's spirits. I'm afraid they're dwindling fast.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1106)

ep3_myyydril_yraka_nes_convo_s_1110 = ConvoScreen:new {
	id = "s_1110",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1110", -- I understand. Please see me when you're available again. I know how it is around here. [Yraka Nes smiles kindly.] Busy, busy, busy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1110)

ep3_myyydril_yraka_nes_convo_s_1116 = ConvoScreen:new {
	id = "s_1116",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1116", -- The Poltur Virus is a wicked ailment one can catch by coming in contact with an Urnsor'is. It usually happens when the victim has miracul...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1120", "s_1123"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1116)

ep3_myyydril_yraka_nes_convo_s_1123 = ConvoScreen:new {
	id = "s_1123",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1123", -- Well, at this time, we need Webweaver Blankets. Webweaver Blankets are used to soothe our afflicted patients. They are made from the silk...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_yraka_nes:s_1125", "s_1127"},
		{"@conversation/ep3_myyydril_yraka_nes:s_1129", "s_1131"},
	}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1123)

ep3_myyydril_yraka_nes_convo_s_1127 = ConvoScreen:new {
	id = "s_1127",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1127", -- I'm so glad. Thank you, my friend. Please hurry. The Webweaver Blankets lift up the afflicted's spirits. I'm afraid they're dwindling fast.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1127)

ep3_myyydril_yraka_nes_convo_s_1131 = ConvoScreen:new {
	id = "s_1131",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1131", -- I understand. Please see me when you're available again. I know how it is around here. [Yraka Nes smiles kindly.] Busy, busy, busy!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1131)

ep3_myyydril_yraka_nes_convo_s_1133 = ConvoScreen:new {
	id = "s_1133",
	leftDialog = "@conversation/ep3_myyydril_yraka_nes:s_1133", -- Oh. [Yraka Nes nods quickly. The twi'lek woman seems very busy.] I'm sorry. I wish I could talk right now. It's been so busy around here ...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_yraka_nes_convo:addScreen(ep3_myyydril_yraka_nes_convo_s_1133)

addConversationTemplate("ep3_myyydril_yraka_nes_convo", ep3_myyydril_yraka_nes_convo)

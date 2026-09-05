-- Lisum's radio -- ep3_kachirho_destroyed_camp. String table is conversation/destroyed_camp_radio (not in the 370-row dump; shipped java c_stringFile).
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_kachirho_qst_radio_convo = ConvoTemplate:new {
	initialScreen = "s_467",
	templateType = "Lua",
	luaClassHandler = "ep3_kachirho_qst_radio_conv_handler",
	screens = {}
}

ep3_kachirho_qst_radio_convo_s_407 = ConvoScreen:new {
	id = "s_407",
	leftDialog = "@conversation/destroyed_camp_radio:s_407", -- *static*
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_407)

ep3_kachirho_qst_radio_convo_s_409 = ConvoScreen:new {
	id = "s_409",
	leftDialog = "@conversation/destroyed_camp_radio:s_409", -- So, is it done?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_411", "s_413"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_409)

ep3_kachirho_qst_radio_convo_s_415 = ConvoScreen:new {
	id = "s_415",
	leftDialog = "@conversation/destroyed_camp_radio:s_415", -- Come in...I am having trouble hearing you. Are you there?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_417", "s_419"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_415)

ep3_kachirho_qst_radio_convo_s_441 = ConvoScreen:new {
	id = "s_441",
	leftDialog = "@conversation/destroyed_camp_radio:s_441", -- Hello...hello...are you reading me?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_443", "s_445"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_441)

ep3_kachirho_qst_radio_convo_s_104 = ConvoScreen:new {
	id = "s_104",
	leftDialog = "@conversation/destroyed_camp_radio:s_104", -- Have you had any luck yet?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_105", "s_106"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_104)

ep3_kachirho_qst_radio_convo_s_467 = ConvoScreen:new {
	id = "s_467",
	leftDialog = "@conversation/destroyed_camp_radio:s_467", -- Hello? Who is this? I am looking for the people who are working in the camp. Can you please put one of them on?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_469", "s_471"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_467)

ep3_kachirho_qst_radio_convo_s_413 = ConvoScreen:new {
	id = "s_413",
	leftDialog = "@conversation/destroyed_camp_radio:s_413", -- Good. The code on the case is 2 5 8 5 4. Now please excuse me...I...I don't know what I am going to do now.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_413)

ep3_kachirho_qst_radio_convo_s_419 = ConvoScreen:new {
	id = "s_419",
	leftDialog = "@conversation/destroyed_camp_radio:s_419", -- So, did you find my friends? They are alright...aren't they?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_421", "s_68"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_419)

ep3_kachirho_qst_radio_convo_s_68 = ConvoScreen:new {
	id = "s_68",
	leftDialog = "@conversation/destroyed_camp_radio:s_68", -- So...they are dead...oh Jillian, I told you not to go. ...I know it is a lot to ask but could you perhaps do one more thing for me? I want you to make those ...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_70", "s_72"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_68)

ep3_kachirho_qst_radio_convo_s_72 = ConvoScreen:new {
	id = "s_72",
	leftDialog = "@conversation/destroyed_camp_radio:s_72", -- Listen...there is a case in the camp. The bandits probably didn't take it because it looks worthless. If you kill those bandits for me I will give you the co...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_74", "s_76"},
		{"@conversation/destroyed_camp_radio:s_78", "s_80"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_72)

ep3_kachirho_qst_radio_convo_s_76 = ConvoScreen:new {
	id = "s_76",
	leftDialog = "@conversation/destroyed_camp_radio:s_76", -- Good. Contact me again when it is done.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_76)

ep3_kachirho_qst_radio_convo_s_80 = ConvoScreen:new {
	id = "s_80",
	leftDialog = "@conversation/destroyed_camp_radio:s_80", -- Fine. I will just find someone else.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_80)

ep3_kachirho_qst_radio_convo_s_445 = ConvoScreen:new {
	id = "s_445",
	leftDialog = "@conversation/destroyed_camp_radio:s_445", -- Did you find anything? I have been waiting here hoping for good news. What did you find out?
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_447", "s_449"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_445)

ep3_kachirho_qst_radio_convo_s_449 = ConvoScreen:new {
	id = "s_449",
	leftDialog = "@conversation/destroyed_camp_radio:s_449", -- Canopy! Oh, this is worse then I thought. There is a group of bandits that work in that area who call themselves the Canopy bandits. They have a reputation f...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_451", "s_453"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_449)

ep3_kachirho_qst_radio_convo_s_453 = ConvoScreen:new {
	id = "s_453",
	leftDialog = "@conversation/destroyed_camp_radio:s_453", -- I need you to find the Canopy bandit's camp and see if you can find my friends there. They are probably just being held captive for ransom. You know...that i...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_455", "s_457"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_453)

ep3_kachirho_qst_radio_convo_s_457 = ConvoScreen:new {
	id = "s_457",
	leftDialog = "@conversation/destroyed_camp_radio:s_457", -- Please...please just go to their camp and see if you can find any signs of my friends. They are good people. They were just studying the plant life on Kashyy...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_459", "s_461"},
		{"@conversation/destroyed_camp_radio:s_463", "s_465"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_457)

ep3_kachirho_qst_radio_convo_s_461 = ConvoScreen:new {
	id = "s_461",
	leftDialog = "@conversation/destroyed_camp_radio:s_461", -- Thank you. Thank you. I will wait by the radio again until I hear back from you. And please be careful. I hear those bandits are a dangerous bunch.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_461)

ep3_kachirho_qst_radio_convo_s_465 = ConvoScreen:new {
	id = "s_465",
	leftDialog = "@conversation/destroyed_camp_radio:s_465", -- *static*
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_465)

ep3_kachirho_qst_radio_convo_s_106 = ConvoScreen:new {
	id = "s_106",
	leftDialog = "@conversation/destroyed_camp_radio:s_106", -- Ok, thank you for all your help. Please report back to me if you find anything out.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_106)

ep3_kachirho_qst_radio_convo_s_471 = ConvoScreen:new {
	id = "s_471",
	leftDialog = "@conversation/destroyed_camp_radio:s_471", -- What do you mean? Of course they are around there. They are the researchers in charge of the camp.
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_473", "s_475"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_471)

ep3_kachirho_qst_radio_convo_s_475 = ConvoScreen:new {
	id = "s_475",
	leftDialog = "@conversation/destroyed_camp_radio:s_475", -- Oh, no! I told them that Kashyyyk was too dangerous for them to be studying the flora on. Are there any signs of them around? Can you please look around and ...
	stopConversation = "false",
	options = {
		{"@conversation/destroyed_camp_radio:s_477", "s_479"},
		{"@conversation/destroyed_camp_radio:s_481", "s_483"},
	}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_475)

ep3_kachirho_qst_radio_convo_s_479 = ConvoScreen:new {
	id = "s_479",
	leftDialog = "@conversation/destroyed_camp_radio:s_479", -- Thank you. I will wait by the radio so you can just contact me if you find anything. I told them not to go there...
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_479)

ep3_kachirho_qst_radio_convo_s_483 = ConvoScreen:new {
	id = "s_483",
	leftDialog = "@conversation/destroyed_camp_radio:s_483", -- But what about my friends? Something terrible must have happened to them. Why won't you help ...*static*.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_qst_radio_convo:addScreen(ep3_kachirho_qst_radio_convo_s_483)

addConversationTemplate("ep3_kachirho_qst_radio_convo", ep3_kachirho_qst_radio_convo)

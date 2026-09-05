-- Athnalu (Shoartu Mystic) -- ep3_forest_athnalu_quest_1, ep3_forest_athnalu_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_athnalu_convo = ConvoTemplate:new {
	initialScreen = "s_4240",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_athnalu_conv_handler",
	screens = {}
}

ep3_forest_athnalu_convo_s_1136 = ConvoScreen:new {
	id = "s_1136",
	leftDialog = "@conversation/ep3_forest_athnalu:s_1136", -- 
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_1136)

ep3_forest_athnalu_convo_s_4176 = ConvoScreen:new {
	id = "s_4176",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4176", -- [Athnalu smiles at you.] They've released me from their grasp.. I am free. Thank you. Thank you for saving me.
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4176)

ep3_forest_athnalu_convo_s_4178 = ConvoScreen:new {
	id = "s_4178",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4178", -- Do you.. [Athnalu looks up at you.] Do you have the things that will fix me... the things that will free me...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4180", "s_4182"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4178)

ep3_forest_athnalu_convo_s_4184 = ConvoScreen:new {
	id = "s_4184",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4184", -- [Athnalu stares off into the distance, humming a haunting tune. She doesn't sense your presence.]
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4184)

ep3_forest_athnalu_convo_s_4186 = ConvoScreen:new {
	id = "s_4186",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4186", -- [Athnalu looks at you blankly.] Like threaded knives, I can feel them scrape at my soul. They use little do...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4188", "s_4190"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4186)

ep3_forest_athnalu_convo_s_4200 = ConvoScreen:new {
	id = "s_4200",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4200", -- Where are my dolls? Do you have them? Can I see them? [Athnalu looks at you curiously.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4202", "s_4204"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4200)

ep3_forest_athnalu_convo_s_4210 = ConvoScreen:new {
	id = "s_4210",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4210", -- I can't sense them.. I can't sense the Voodoo dolls on you. [Athnalu almost lunges at you.] Where are they?...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4212", "s_4214"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4210)

ep3_forest_athnalu_convo_s_4216 = ConvoScreen:new {
	id = "s_4216",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4216", -- Athnalu stares past you.] The Sayormi... they have.. touched my soul, a part of me that can never be restor...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4218", "s_4220"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4216)

ep3_forest_athnalu_convo_s_4238 = ConvoScreen:new {
	id = "s_4238",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4238", -- [Athnalu stares at you.] Such a dear soul. So lost.. so lost..
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4238)

ep3_forest_athnalu_convo_s_4240 = ConvoScreen:new {
	id = "s_4240",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4240", -- [Athnalu just stares at you.] Who are you? What do you want? Are you here to hurt us? Go away! I can't spea...
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4240)

ep3_forest_athnalu_convo_s_4182 = ConvoScreen:new {
	id = "s_4182",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4182", -- [Athnalu gathers them quickly from you.] Stay here while I mix these...
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4182)

ep3_forest_athnalu_convo_s_4190 = ConvoScreen:new {
	id = "s_4190",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4190", -- I need to wash my soul. And I need certain things to help me make the voices go away. I need snake eyes to ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4192", "s_4198"},
		{"@conversation/ep3_forest_athnalu:s_4196", "s_4198"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4190)

ep3_forest_athnalu_convo_s_4194 = ConvoScreen:new {
	id = "s_4194",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4194", -- Find them. Help me take the voices away.
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4194)

ep3_forest_athnalu_convo_s_4198 = ConvoScreen:new {
	id = "s_4198",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4198", -- [Athnalu dazes off and begins to mumble again.]
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4198)

ep3_forest_athnalu_convo_s_4204 = ConvoScreen:new {
	id = "s_4204",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4204", -- Yes! [Athnalu holds the dolls close to her.] Now, I will find out how they control me. Maybe I can cure my ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4206", "s_4208"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4204)

ep3_forest_athnalu_convo_s_4208 = ConvoScreen:new {
	id = "s_4208",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4208", -- [Athnalu dazes off, mumbling to herself while holding the dolls close.]
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4208)

ep3_forest_athnalu_convo_s_4214 = ConvoScreen:new {
	id = "s_4214",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4214", -- [Athnalu shrinks back.] Don't hurt me... just find them. Please. I need them. I need to get better.
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4214)

ep3_forest_athnalu_convo_s_4220 = ConvoScreen:new {
	id = "s_4220",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4220", -- [Athnalu looks at you, as if she just noticed your presence.] Who are you? What do you want?! You can't hur...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4222", "s_4224"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4220)

ep3_forest_athnalu_convo_s_4224 = ConvoScreen:new {
	id = "s_4224",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4224", -- I must understand why they wish to hurt me. I have to understand them. I have to... or my soul is lost. Wil...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4226", "s_4236"},
		{"@conversation/ep3_forest_athnalu:s_4234", "s_4232"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4224)

ep3_forest_athnalu_convo_s_4228 = ConvoScreen:new {
	id = "s_4228",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4228", -- Please.. before it's too late! I can feel their hands around my soul, squeezing tighter. All hope is lost t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_athnalu:s_4230", "s_4232"},
	}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4228)

ep3_forest_athnalu_convo_s_4236 = ConvoScreen:new {
	id = "s_4236",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4236", -- [Athnalu just cries.]
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4236)

ep3_forest_athnalu_convo_s_4232 = ConvoScreen:new {
	id = "s_4232",
	leftDialog = "@conversation/ep3_forest_athnalu:s_4232", -- I need 5 voodoo dolls. Such a tiny number. So small. Hurry back.. hurry back or they'll suffocate me! Pleas...
	stopConversation = "true",
	options = {}
}
ep3_forest_athnalu_convo:addScreen(ep3_forest_athnalu_convo_s_4232)

addConversationTemplate("ep3_forest_athnalu_convo", ep3_forest_athnalu_convo)

-- Dahlia -- ep3_forest_dahlia_epic_1, ep3_forest_dahlia_epic_2, ep3_forest_dahlia_epic_3, ep3_forest_dahlia_epic_4, ep3_forest_aveso_quest_2, ep3_forest_cryl_quest_2, ep3_forest_rhiek_quest_3, ep3_forest_kerritamba_epic_7, ep3_forest_outcast_assassin_2, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_dahlia_convo = ConvoTemplate:new {
	initialScreen = "s_3460",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_dahlia_conv_handler",
	screens = {}
}

ep3_forest_dahlia_convo_s_3134 = ConvoScreen:new {
	id = "s_3134",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3134", -- Exemplar... [Dahlia nods.] I have nothing for you at this time. Continue to make your presence known among ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3136", "s_3138"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3134)

ep3_forest_dahlia_convo_s_3140 = ConvoScreen:new {
	id = "s_3140",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3140", -- It's good to see you're still alive, mercenary.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3142", "s_3172"},
		{"@conversation/ep3_forest_dahlia:s_3154", "s_3148"},
		{"@conversation/ep3_forest_dahlia:s_3170", "s_3152"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3140)

ep3_forest_dahlia_convo_s_3182 = ConvoScreen:new {
	id = "s_3182",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3182", -- [Dahlia lunges at you.] Why are you still here? Do you not realize that we are in the midst of a battle?!
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3182)

ep3_forest_dahlia_convo_s_3184 = ConvoScreen:new {
	id = "s_3184",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3184", -- [Dahlia sighs loudly.] I told you to speak with Sertild, did I not? Why are you still here? Go!
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3184)

ep3_forest_dahlia_convo_s_3186 = ConvoScreen:new {
	id = "s_3186",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3186", -- Mercenary.. [Dahlia begins.] Our final blow has come to this; you will find Sertild near the Kerritamba vil...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3188", "s_3226"},
		{"@conversation/ep3_forest_dahlia:s_3208", "s_3202"},
		{"@conversation/ep3_forest_dahlia:s_3224", "s_3198"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3186)

ep3_forest_dahlia_convo_s_3244 = ConvoScreen:new {
	id = "s_3244",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3244", -- Tell me good news, mercenary. I've had a bad day today..
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3246", "s_3264"},
		{"@conversation/ep3_forest_dahlia:s_3254", "s_3252"},
		{"@conversation/ep3_forest_dahlia:s_3262", "s_3264"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3244)

ep3_forest_dahlia_convo_s_3270 = ConvoScreen:new {
	id = "s_3270",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3270", -- [Dahlia scoffs.] Why have I not heard the angry cries of the Kerritamba people? [Dahlia leans closer.] Beca...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3272", "s_3274"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3270)

ep3_forest_dahlia_convo_s_3276 = ConvoScreen:new {
	id = "s_3276",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3276", -- I am finding myself looking forward to your presence these days, mercenary.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3278", "s_3316"},
		{"@conversation/ep3_forest_dahlia:s_3294", "s_3284"},
		{"@conversation/ep3_forest_dahlia:s_3314", "s_3292"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3276)

ep3_forest_dahlia_convo_s_3342 = ConvoScreen:new {
	id = "s_3342",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3342", -- [Dahlia takes a moment to look you over.] Yes, mercenary?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3344", "s_3362"},
		{"@conversation/ep3_forest_dahlia:s_3352", "s_3350"},
		{"@conversation/ep3_forest_dahlia:s_3360", "s_3362"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3342)

ep3_forest_dahlia_convo_s_3368 = ConvoScreen:new {
	id = "s_3368",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3368", -- [Before you can speak, Dahlia raises a finger.] I don't want to speak to you unless you have stories of suc...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3370", "s_3372"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3368)

ep3_forest_dahlia_convo_s_3374 = ConvoScreen:new {
	id = "s_3374",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3374", -- I have heard many things about you, mercenary. [Dahlia looks you over.] So.. you wish to become an Exemplar...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3376", "s_3414"},
		{"@conversation/ep3_forest_dahlia:s_3396", "s_3382"},
		{"@conversation/ep3_forest_dahlia:s_3412", "s_3394"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3374)

ep3_forest_dahlia_convo_s_3452 = ConvoScreen:new {
	id = "s_3452",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3452", -- [Dahlia sniffs delicately.] I smell trash. Oh. It's just you. [Dahlia chuckles darkly.] What are you doing ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3454", "s_3456"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3452)

ep3_forest_dahlia_convo_s_3458 = ConvoScreen:new {
	id = "s_3458",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3458", -- [Dahlia laughs hauntingly.] Kerritamba. Your kind never ceases to amaze me. Do you think you can walk in he...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3458)

ep3_forest_dahlia_convo_s_3460 = ConvoScreen:new {
	id = "s_3460",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3460", -- [Dahlia frowns deeply.] Another nameless face in my court. How disgusting. I suggest you leave and quickly....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3462", "s_3464"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3460)

ep3_forest_dahlia_convo_s_3138 = ConvoScreen:new {
	id = "s_3138",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3138", -- You are dismissed. [Dahlia waves you off.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3138)

ep3_forest_dahlia_convo_s_3144 = ConvoScreen:new {
	id = "s_3144",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3144", -- I have been pleased with your progress, mercenary. You have completed my tasks to my satisfaction. I suppos...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3146", "s_3148"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3144)

ep3_forest_dahlia_convo_s_3156 = ConvoScreen:new {
	id = "s_3156",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3156", -- I am honored to say that, due to your continued success in your tasks, I am able to offer you a position at...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3158", "s_3160"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3156)

ep3_forest_dahlia_convo_s_3172 = ConvoScreen:new {
	id = "s_3172",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3172", -- [Dahlia seems unphased by the nickname.] You did your part well, I must say. Unfortunately, Sertild betraye...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3174", "s_3176"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3172)

ep3_forest_dahlia_convo_s_3148 = ConvoScreen:new {
	id = "s_3148",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3148", -- [Dahlia nods.] From this day forth, you will be at my side as my Exemplar. You have reached the end of the ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3150", "s_3152"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3148)

ep3_forest_dahlia_convo_s_3152 = ConvoScreen:new {
	id = "s_3152",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3152", -- For now, I must rest. I bid you well, Exemplar.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3152)

ep3_forest_dahlia_convo_s_3160 = ConvoScreen:new {
	id = "s_3160",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3160", -- Then, from this day forth, you are an Exemplar of the Society.. Welcome home, Exemplar.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3162", "s_3164"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3160)

ep3_forest_dahlia_convo_s_3164 = ConvoScreen:new {
	id = "s_3164",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3164", -- Oh.. [Dahlia smiles.] We rest. And continue to plot against the Kerritamba another day.. For now, enjoy you...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3166", "s_3168"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3164)

ep3_forest_dahlia_convo_s_3168 = ConvoScreen:new {
	id = "s_3168",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3168", -- And you...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3168)

ep3_forest_dahlia_convo_s_3176 = ConvoScreen:new {
	id = "s_3176",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3176", -- One day. For now, we rest. Besides, you must learn the ways of the Exemplar. You are a true hero of the Soc...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3178", "s_3180"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3176)

ep3_forest_dahlia_convo_s_3180 = ConvoScreen:new {
	id = "s_3180",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3180", -- [Dahlia just shakes her head.] What have I thrown myself into..
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3180)

ep3_forest_dahlia_convo_s_3190 = ConvoScreen:new {
	id = "s_3190",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3190", -- While you're dealing with their guardsmen, we will be dealing with Chief Kerritamba. It is a perfect setup.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3192", "s_3202"},
		{"@conversation/ep3_forest_dahlia:s_3200", "s_3198"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3190)

ep3_forest_dahlia_convo_s_3210 = ConvoScreen:new {
	id = "s_3210",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3210", -- And while you're in the thick of battle, the Society and the Quietus Sect will deal with Chief Kerritamba. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3212", "s_3222"},
		{"@conversation/ep3_forest_dahlia:s_3220", "s_3218"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3210)

ep3_forest_dahlia_convo_s_3226 = ConvoScreen:new {
	id = "s_3226",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3226", -- [Dahlia rolls her eyes.] While you're doing away with the Kerritamba guardsmen, our people will deal with C...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3228", "s_3242"},
		{"@conversation/ep3_forest_dahlia:s_3240", "s_3234"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3226)

ep3_forest_dahlia_convo_s_3194 = ConvoScreen:new {
	id = "s_3194",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3194", -- I am pleased to hear you speak those words, mercenary. Find Sertild near the Kerritamba village and give hi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3196", "s_3198"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3194)

ep3_forest_dahlia_convo_s_3202 = ConvoScreen:new {
	id = "s_3202",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3202", -- [Dahlia smiles.] You are both brave and intelligent. I will enjoy having you as my Exemplar, mercenary. Now...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3204", "s_3206"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3202)

ep3_forest_dahlia_convo_s_3198 = ConvoScreen:new {
	id = "s_3198",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3198", -- [Dahlia returns to her planning.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3198)

ep3_forest_dahlia_convo_s_3206 = ConvoScreen:new {
	id = "s_3206",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3206", -- [Dahlia continues her planning.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3206)

ep3_forest_dahlia_convo_s_3214 = ConvoScreen:new {
	id = "s_3214",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3214", -- Good. [Dahlia nods, pleased.] You will find Sertild near the Kerritamba village. Speak with him and give hi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3216", "s_3218"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3214)

ep3_forest_dahlia_convo_s_3222 = ConvoScreen:new {
	id = "s_3222",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3222", -- Then go. Time is of the essence. We must strike quickly. Return to me soon. You are dismissed.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3222)

ep3_forest_dahlia_convo_s_3218 = ConvoScreen:new {
	id = "s_3218",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3218", -- You are dismissed. [Dahlia smiles.] And come back safely.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3218)

ep3_forest_dahlia_convo_s_3230 = ConvoScreen:new {
	id = "s_3230",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3230", -- Just go and complete your task. Oh, and mercenary?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3232", "s_3234"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3230)

ep3_forest_dahlia_convo_s_3242 = ConvoScreen:new {
	id = "s_3242",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3242", -- Then get yourself ready! [Dahlia grumbles.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3242)

ep3_forest_dahlia_convo_s_3234 = ConvoScreen:new {
	id = "s_3234",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3234", -- Have a little adjustment before you leave, hm?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3236", "s_3238"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3234)

ep3_forest_dahlia_convo_s_3238 = ConvoScreen:new {
	id = "s_3238",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3238", -- [Dahlia chuckles darkly.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3238)

ep3_forest_dahlia_convo_s_3248 = ConvoScreen:new {
	id = "s_3248",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3248", -- [Dahlia exhales a sigh of relief.] We are one step closer to crushing the Kerritamba people. Soon, you will...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3250", "s_3252"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3248)

ep3_forest_dahlia_convo_s_3256 = ConvoScreen:new {
	id = "s_3256",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3256", -- [Dahlia nods.] The network within the Society has told me the great news. I am elated. I can now rest easy....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3258", "s_3260"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3256)

ep3_forest_dahlia_convo_s_3264 = ConvoScreen:new {
	id = "s_3264",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3264", -- [Dahlia chuckles darkly.] Although your personality conflicts with my ideal designs, you undoubtedly amuse ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3266", "s_3268"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3264)

ep3_forest_dahlia_convo_s_3252 = ConvoScreen:new {
	id = "s_3252",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3252", -- Hmm.. [Dahlia's expression grows pensive.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3252)

ep3_forest_dahlia_convo_s_3260 = ConvoScreen:new {
	id = "s_3260",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3260", -- [Dahlia returns to her thoughts.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3260)

ep3_forest_dahlia_convo_s_3268 = ConvoScreen:new {
	id = "s_3268",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3268", -- Ugh.. [Dahlia scoffs.] Damn mercenaries.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3268)

ep3_forest_dahlia_convo_s_3274 = ConvoScreen:new {
	id = "s_3274",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3274", -- [Dahlia only chuckles and returns to her brooding.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3274)

ep3_forest_dahlia_convo_s_3280 = ConvoScreen:new {
	id = "s_3280",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3280", -- Hmm.. [Dahlia almost sighs audibly, staring at you.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3282", "s_3284"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3280)

ep3_forest_dahlia_convo_s_3296 = ConvoScreen:new {
	id = "s_3296",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3296", -- [Dahlia continues without skipping a beat.] You did well with the Kerritamba warriors, mercenary. But now, ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3298", "s_3300"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3296)

ep3_forest_dahlia_convo_s_3316 = ConvoScreen:new {
	id = "s_3316",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3316", -- [Dahlia sighs frustratedly.] Of course, I can always expect you to say such stupid things, making me want t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3318", "s_3320"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3316)

ep3_forest_dahlia_convo_s_3284 = ConvoScreen:new {
	id = "s_3284",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3284", -- Oh.. [Dahlia frowns at herself and clears her throat.] Let's get down to business. It is the perfect time t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3286", "s_3292"},
		{"@conversation/ep3_forest_dahlia:s_3290", "s_3292"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3284)

ep3_forest_dahlia_convo_s_3288 = ConvoScreen:new {
	id = "s_3288",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3288", -- [Dahlia taps her lower lip. She struggles to hold back her comments.] You are dismissed, mercenary.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3288)

ep3_forest_dahlia_convo_s_3292 = ConvoScreen:new {
	id = "s_3292",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3292", -- [Dahlia frowns.] You can't stay here forever, mercenary. Come back when you are serious about becoming my E...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3292)

ep3_forest_dahlia_convo_s_3300 = ConvoScreen:new {
	id = "s_3300",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3300", -- The Kerritamba have responded to our attacks and have sent their weapons master, Warchief Naloriss, out loo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3302", "s_3304"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3300)

ep3_forest_dahlia_convo_s_3304 = ConvoScreen:new {
	id = "s_3304",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3304", -- He is of no concern to me. If anyone catches him in this lifetime, it will be nothing short of miraculous l...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3306", "s_3312"},
		{"@conversation/ep3_forest_dahlia:s_3310", "s_3312"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3304)

ep3_forest_dahlia_convo_s_3308 = ConvoScreen:new {
	id = "s_3308",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3308", -- [Dahlia nods.] Then go. I bid you to return soon. This is a matter of great importance.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3308)

ep3_forest_dahlia_convo_s_3312 = ConvoScreen:new {
	id = "s_3312",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3312", -- Find Warchief Naloriss and defeat him. I hope to hear of your great success in this endeavor.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3312)

ep3_forest_dahlia_convo_s_3320 = ConvoScreen:new {
	id = "s_3320",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3320", -- [Dahlia almost lunges toward you.] Then, behave! Is it so hard? [Dahlia sighs, centering herself.] I have a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3322", "s_3324"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3320)

ep3_forest_dahlia_convo_s_3324 = ConvoScreen:new {
	id = "s_3324",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3324", -- [Dahlia chuckles.] Zhadran is a snake. If anything catches him, it will be short of a miracle. You needn't ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3326", "s_3328"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3324)

ep3_forest_dahlia_convo_s_3328 = ConvoScreen:new {
	id = "s_3328",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3328", -- You are correct, mercenary. You should be like this more often, instead of quipping an attitude every two s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3330", "s_3340"},
		{"@conversation/ep3_forest_dahlia:s_3338", "s_3336"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3328)

ep3_forest_dahlia_convo_s_3332 = ConvoScreen:new {
	id = "s_3332",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3332", -- I hope to hear of your success. Warchief Naloriss patrols the path outside the village. His guards will be ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3334", "s_3336"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3332)

ep3_forest_dahlia_convo_s_3340 = ConvoScreen:new {
	id = "s_3340",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3340", -- Then, do so. And return quickly. I do not like to be kept waiting.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3340)

ep3_forest_dahlia_convo_s_3336 = ConvoScreen:new {
	id = "s_3336",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3336", -- [Dahlia smirks.] You're dismissed.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3336)

ep3_forest_dahlia_convo_s_3346 = ConvoScreen:new {
	id = "s_3346",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3346", -- [Dahlia nods.] Good. Your actions and efficiency please me. Now go. I must discuss your next task with my a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3348", "s_3350"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3346)

ep3_forest_dahlia_convo_s_3354 = ConvoScreen:new {
	id = "s_3354",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3354", -- [Dahlia smiles.] Thank you, mercenary. One day, you will be a fine Exemplar in my court. Now, leave me to b...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3356", "s_3358"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3354)

ep3_forest_dahlia_convo_s_3362 = ConvoScreen:new {
	id = "s_3362",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3362", -- [Dahlia narrows her eyes.] I am pleased, yet saddened. I am pleased that you have completed your mission. B...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3364", "s_3366"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3362)

ep3_forest_dahlia_convo_s_3350 = ConvoScreen:new {
	id = "s_3350",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3350", -- [Dahlia returns to her brooding.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3350)

ep3_forest_dahlia_convo_s_3358 = ConvoScreen:new {
	id = "s_3358",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3358", -- Yes.. yes. [Dahlia tries to hide her wide smile behind her hand.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3358)

ep3_forest_dahlia_convo_s_3366 = ConvoScreen:new {
	id = "s_3366",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3366", -- Good. Now, leave me. I must think about your next task..
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3366)

ep3_forest_dahlia_convo_s_3372 = ConvoScreen:new {
	id = "s_3372",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3372", -- [Dahlia returns to her brooding.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3372)

ep3_forest_dahlia_convo_s_3378 = ConvoScreen:new {
	id = "s_3378",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3378", -- [Dahlia nods.] It is rare to see other females in the Society. I will readily welcome another... If you can...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3380", "s_3382"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3378)

ep3_forest_dahlia_convo_s_3398 = ConvoScreen:new {
	id = "s_3398",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3398", -- [Dahlia fans herself with her hand.] Well, then.. such dashing respect. You intrigue me. [Dahlia clears her...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3400", "s_3402"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3398)

ep3_forest_dahlia_convo_s_3414 = ConvoScreen:new {
	id = "s_3414",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3414", -- [Dahlia leans closer.] Let's get one thing straight here, mercenary. You *will* give me your utmost respect...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3416", "s_3430"},
		{"@conversation/ep3_forest_dahlia:s_3428", "s_3426"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3414)

ep3_forest_dahlia_convo_s_3382 = ConvoScreen:new {
	id = "s_3382",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3382", -- [Dahlia nods.] As you know, the Kerritamba have treated many of our people with hateful disdain. The Societ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3384", "s_3394"},
		{"@conversation/ep3_forest_dahlia:s_3392", "s_3390"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3382)

ep3_forest_dahlia_convo_s_3386 = ConvoScreen:new {
	id = "s_3386",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3386", -- Hmm.. [Dahlia taps her chin.] 10 seems like a good number. Yes. I want you to find and destroy 10 Kerritamb...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3388", "s_3390"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3386)

ep3_forest_dahlia_convo_s_3394 = ConvoScreen:new {
	id = "s_3394",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3394", -- I am amazed at the quality of recruits that come in these days. You are a disappointment to the promising t...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3394)

ep3_forest_dahlia_convo_s_3390 = ConvoScreen:new {
	id = "s_3390",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3390", -- [Dahlia waves a dismissive hand.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3390)

ep3_forest_dahlia_convo_s_3402 = ConvoScreen:new {
	id = "s_3402",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3402", -- For their crimes in the past, the Kerritamba have been the targets for many of our devious practices. And w...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3404", "s_3410"},
		{"@conversation/ep3_forest_dahlia:s_3408", "s_3410"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3402)

ep3_forest_dahlia_convo_s_3406 = ConvoScreen:new {
	id = "s_3406",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3406", -- [Dahlia bites her lip, holding back a girlish smile.] You're dismissed.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3406)

ep3_forest_dahlia_convo_s_3410 = ConvoScreen:new {
	id = "s_3410",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3410", -- [Dahlia narrows her eyes.] You fool. Leave, then. I no longer want to see your face.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3410)

ep3_forest_dahlia_convo_s_3418 = ConvoScreen:new {
	id = "s_3418",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3418", -- It had better not, mercenary. As I was saying... As you know, we find the Kerritamba to be on the top of ou...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3420", "s_3426"},
		{"@conversation/ep3_forest_dahlia:s_3424", "s_3426"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3418)

ep3_forest_dahlia_convo_s_3430 = ConvoScreen:new {
	id = "s_3430",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3430", -- [Dahlia only sighs, flickering her wrist outward in your direction.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3432", "s_3434"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3430)

ep3_forest_dahlia_convo_s_3422 = ConvoScreen:new {
	id = "s_3422",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3422", -- Well done. I do enjoy favorable answers. Go, then, and return quickly. You are dismissed. [Dahlia waves you...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3422)

ep3_forest_dahlia_convo_s_3426 = ConvoScreen:new {
	id = "s_3426",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3426", -- Then, you will never amount to anything in the Society, grunt. Get out of my face. You're not even worth my...
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3426)

ep3_forest_dahlia_convo_s_3434 = ConvoScreen:new {
	id = "s_3434",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3434", -- And that, my little mercenary, is just a taste of what I can do. Are you finished with your games?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3436", "s_3450"},
		{"@conversation/ep3_forest_dahlia:s_3448", "s_3446"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3434)

ep3_forest_dahlia_convo_s_3438 = ConvoScreen:new {
	id = "s_3438",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3438", -- Good. [Dahlia smiles.] Now, let's get back to business. The Kerritamba must suffer for their iniquities in ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_dahlia:s_3440", "s_3446"},
		{"@conversation/ep3_forest_dahlia:s_3444", "s_3446"},
	}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3438)

ep3_forest_dahlia_convo_s_3450 = ConvoScreen:new {
	id = "s_3450",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3450", -- [Dahlia only chuckles darkly.]
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3450)

ep3_forest_dahlia_convo_s_3442 = ConvoScreen:new {
	id = "s_3442",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3442", -- Good. I expect you here soon. I can't wait to hear of your success.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3442)

ep3_forest_dahlia_convo_s_3446 = ConvoScreen:new {
	id = "s_3446",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3446", -- [Dahlia chickles.] Go, then.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3446)

ep3_forest_dahlia_convo_s_3456 = ConvoScreen:new {
	id = "s_3456",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3456", -- Ahh. Such refreshing respect. [Dahlia nods.] Run along now.
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3456)

ep3_forest_dahlia_convo_s_3464 = ConvoScreen:new {
	id = "s_3464",
	leftDialog = "@conversation/ep3_forest_dahlia:s_3464", -- [Dahlia points.] Leave!!
	stopConversation = "true",
	options = {}
}
ep3_forest_dahlia_convo:addScreen(ep3_forest_dahlia_convo_s_3464)

addConversationTemplate("ep3_forest_dahlia_convo", ep3_forest_dahlia_convo)

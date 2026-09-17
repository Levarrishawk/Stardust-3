beissa_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "dravisConvoHandler",
	screens = {}
}

-- Fallback screens required by the shared squadron handler.
beissa_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_15ef997f",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_no_jtl)

beissa_imperial_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_15ef997f",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_imperial_pilot)

beissa_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_15ef997f",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_rebel_pilot)

beissa_non_squadron = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_59d3a31c",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_non_squadron)

beissa_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_15ef997f",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_recruitment)

beissa_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_25ba96cd",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_no_ship)

beissa_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_59d3a31c",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_go_to_next)
beissa_tier3_completed_dulios = ConvoScreen:new {
	id = "tier3_completed_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you - maybe. But duty calls. You're now assigned to Admiral Diness Imler, down the hall - he'll be giving you orders from now on. See ya, %TU.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_completed_dulios);

beissa_tier3_train_warships_final = ConvoScreen:new {
	id = "tier3_train_warships_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_warships_final);

beissa_tier3_train_components_final = ConvoScreen:new {
	id = "tier3_train_components_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_components_final);

beissa_tier3_train_techniques_final = ConvoScreen:new {
	id = "tier3_train_techniques_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_techniques_final);

beissa_tier3_train_programming_final = ConvoScreen:new {
	id = "tier3_train_programming_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_programming_final);

beissa_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_da70d826", -- So YOU'RE the fool!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_19425c2f", "tier3_im_dulios"}, -- You are?
		{"@conversation/naboo_privateer_tier3:s_731caa45", "tier3_have_mission"}, -- Got a mission for me?
	}
}
beissa_convo:addScreen(beissa_tier3_first_mission);

beissa_tier3_im_dulios = ConvoScreen:new {
	id = "tier3_im_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_88a726df", -- Hey, we'll see what you say when you're on this side of the desk. Let's get you started.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b1da46d", "tier3_have_mission"}, -- Where do I start?
	}
}
beissa_convo:addScreen(beissa_tier3_im_dulios);

beissa_tier3_have_mission = ConvoScreen:new {
	id = "tier3_have_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_666cac71", -- These guys pose a SERIOUS threat to the royal family - hell, to this entire planet.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_5bd69df6", "tier3_blacksun_threat"}, -- What do you need me to do?
	}
}
beissa_convo:addScreen(beissa_tier3_have_mission);

beissa_tier3_blacksun_threat = ConvoScreen:new {
	id = "tier3_blacksun_threat",
	leftDialog = "@conversation/naboo_privateer_tier3:s_e1e07205", -- All you need to do is stop his ship. The boys in the lab are putting together a little surprise for him, but it's up to you to deliver the package. Get over to the Dantooine System; we'll update you from there.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_7478d95d", "tier3_accept_first_mission"}, -- Loud and clear. Where to?
	}
}
beissa_convo:addScreen(beissa_tier3_blacksun_threat);

beissa_tier3_accept_first_mission = ConvoScreen:new {
	id = "tier3_accept_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_first_mission);

beissa_tier3_failed_first_mission = ConvoScreen:new {
	id = "tier3_failed_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_97e76dd", -- This Royal Security Forces assignment isn't so easy after all, is it?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "tier3_try_first_again"}, -- Nothing I can't handle.
	}
}
beissa_convo:addScreen(beissa_tier3_failed_first_mission);

beissa_tier3_try_first_again = ConvoScreen:new {
	id = "tier3_try_first_again",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_try_first_again);

beissa_tier3_complete_mission1 = ConvoScreen:new {
	id = "tier3_complete_mission1",
	leftDialog = "@conversation/naboo_privateer_tier3:s_8de81731", -- I'm really going to miss that Saymonz Varg.
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission1);

beissa_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_5075e20b", -- Your new mission targets a criminal of a different type. I'm talking about diplomats.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_66f6527f", "tier3_diplomats_know"}, -- Do the diplomats know?
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "tier3_where_diplomats"}, -- Where are these diplomats?
	}
}
beissa_convo:addScreen(beissa_tier3_second_mission);

beissa_tier3_diplomats_know = ConvoScreen:new {
	id = "tier3_diplomats_know",
	leftDialog = "@conversation/naboo_privateer_tier3:s_68d4ba6b", -- To be honest, it's probably not them. It's probably smugglers taking advantage of the opportunity, and hiding gear on their ship. Doesn't matter. Same difference.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a41bb8c7", "tier3_how_suspicious"}, -- How can you be so suspicious?
	}
}
beissa_convo:addScreen(beissa_tier3_diplomats_know);

beissa_tier3_how_suspicious = ConvoScreen:new {
	id = "tier3_how_suspicious",
	leftDialog = "@conversation/naboo_privateer_tier3:s_83905129", -- Unlike you, I DO get paid the big bucks, %NU, and it's on account of my suspicious nature. Smugglers may be packing these ships with contraband.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_c089dba4", "tier3_just_am"}, -- I just am.
	}
}
beissa_convo:addScreen(beissa_tier3_how_suspicious);

beissa_tier3_just_am = ConvoScreen:new {
	id = "tier3_just_am",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c65cf2da", -- What's not to like?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "tier3_where_diplomats"}, -- Where are these diplomats?
	}
}
beissa_convo:addScreen(beissa_tier3_just_am);

beissa_tier3_where_diplomats = ConvoScreen:new {
	id = "tier3_where_diplomats",
	leftDialog = "@conversation/naboo_privateer_tier3:s_76734574", -- En route. Fly out to the waypoint and get ready to inspect each and every one of them.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6c251948", "tier3_accept_second_mission"}, -- You got it.
	}
}
beissa_convo:addScreen(beissa_tier3_where_diplomats);

beissa_tier3_accept_second_mission = ConvoScreen:new {
	id = "tier3_accept_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c4095762", -- Fly your ship out to the waypoint. Inspect the diplomats' ships. Use some pretext if you have to. See what you can find.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_second_mission);

beissa_tier3_failed_second_mission = ConvoScreen:new {
	id = "tier3_failed_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_53daee1c", -- You're starting to get a bad reputation.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_83b47a80", "tier3_stories_about_me"}, -- You telling stories about me?
	}
}
beissa_convo:addScreen(beissa_tier3_failed_second_mission);

beissa_tier3_stories_about_me = ConvoScreen:new {
	id = "tier3_stories_about_me",
	leftDialog = "@conversation/naboo_privateer_tier3:s_57d34626", -- I don't need to! People know those hunters are using you for target practice. Get back out there - and try fighting back this time.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_stories_about_me);

beissa_tier3_complete_mission2 = ConvoScreen:new {
	id = "tier3_complete_mission2",
	leftDialog = "@conversation/naboo_privateer_tier3:s_47152ac5", -- Oh yeah. The worst of the worst. That data you intercepted has led us to a real hornet's nest of assassins and terrorists.
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission2);

beissa_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_70e76a9a", -- OK, %NU, no more busywork. Time for some good old-fashioned killing. How does that sound?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_5a889c20", "tier3_rodians_feel"}, -- Like a dream come true.
		{"@conversation/naboo_privateer_tier3:s_5a2317e2", "tier3_killing_bad_guys"}, -- Depends. Am I killing bad guys?
	}
}
beissa_convo:addScreen(beissa_tier3_third_mission);

beissa_tier3_rodians_feel = ConvoScreen:new {
	id = "tier3_rodians_feel",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b7137723", -- OK. Then let's get started. How do you feel about Rodians?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_589399fa", "tier3_love_em"}, -- Love 'em.
		{"@conversation/naboo_privateer_tier3:s_af5ccac", "tier3_hate_em"}, -- Hate 'em.
	}
}
beissa_convo:addScreen(beissa_tier3_rodians_feel);

beissa_tier3_killing_bad_guys = ConvoScreen:new {
	id = "tier3_killing_bad_guys",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ab3f1614", -- Boy, do I. This is a good one. I'd like to do this myself.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a09da7f1", "tier3_rodians_feel"}, -- You like that?
	}
}
beissa_convo:addScreen(beissa_tier3_killing_bad_guys);

beissa_tier3_love_em = ConvoScreen:new {
	id = "tier3_love_em",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4bdc789d", -- Hope you're being sarcastic. You're looking for a Rodian assassin.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_51ca1520", "tier3_rodian_killed"}, -- An assassin? Who's he killed?
	}
}
beissa_convo:addScreen(beissa_tier3_love_em);

beissa_tier3_hate_em = ConvoScreen:new {
	id = "tier3_hate_em",
	leftDialog = "@conversation/naboo_privateer_tier3:s_bf22a8c8", -- Can't say I blame 'em. Got no use for them myself. But this Rodian's a real pain in the keister. We think he's killed two ambassadors already.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_24ee6c29", "tier3_shooting_politicians"}, -- Someone's always shooting at politicians.
	}
}
beissa_convo:addScreen(beissa_tier3_hate_em);

beissa_tier3_rodian_killed = ConvoScreen:new {
	id = "tier3_rodian_killed",
	leftDialog = "@conversation/naboo_privateer_tier3:s_96924c42", -- A couple of ambassadors, for starters. But that's not why we're interested in him. Word is, his next target is the Queen.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b8c1a96f", "tier3_more_complicated"}, -- Hm. That makes it a little more complicated.
	}
}
beissa_convo:addScreen(beissa_tier3_rodian_killed);

beissa_tier3_shooting_politicians = ConvoScreen:new {
	id = "tier3_shooting_politicians",
	leftDialog = "@conversation/naboo_privateer_tier3:s_919b5558", -- It's not the ambassadors they're worried about. This guy's gunning for the Queen.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_ebe811bd", "tier3_more_complicated"}, -- That makes it a little more complicated.
	}
}
beissa_convo:addScreen(beissa_tier3_shooting_politicians);

beissa_tier3_more_complicated = ConvoScreen:new {
	id = "tier3_more_complicated",
	leftDialog = "@conversation/naboo_privateer_tier3:s_d5861157", -- The Royal Family is always a high-profile target, buddy. Believe me. The Queen's got more bounties on her head than you've got toes on your feet.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_692788e8", "tier3_find_charmer"}, -- Where can I find this charmer?
	}
}
beissa_convo:addScreen(beissa_tier3_more_complicated);

beissa_tier3_find_charmer = ConvoScreen:new {
	id = "tier3_find_charmer",
	leftDialog = "@conversation/naboo_privateer_tier3:s_f6976b78", -- Sounds like a plan. Go to the Dantooine system. Follow the coordinates on your ship's nav system; should lead you right to him. And you've got the element of surprise - I think.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a5fe9928", "tier3_accept_third_mission"}, -- I'll take care of it.
	}
}
beissa_convo:addScreen(beissa_tier3_find_charmer);

beissa_tier3_accept_third_mission = ConvoScreen:new {
	id = "tier3_accept_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b679efe", -- See that you do.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_third_mission);

beissa_tier3_failed_third_mission = ConvoScreen:new {
	id = "tier3_failed_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_cae364a9", -- That Rodian is giving you a run for your money.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_18868d04", "tier3_i_was_better"}, -- I was better.
	}
}
beissa_convo:addScreen(beissa_tier3_failed_third_mission);

beissa_tier3_i_was_better = ConvoScreen:new {
	id = "tier3_i_was_better",
	leftDialog = "@conversation/naboo_privateer_tier3:s_2852c031", -- Prove it. Finish your job.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_i_was_better);

beissa_tier3_complete_mission3 = ConvoScreen:new {
	id = "tier3_complete_mission3",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b61d6d4f", -- OK! That's one less Rodian messing up the place. Nice work. Time to get back to your training.
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission3);

beissa_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_333a7093", -- This is a good one; wish I could do it myself. You're going after a Rodian assassin.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_e7b0a6c9", "tier3_another_assassin"}, -- Another assassin?
		{"@conversation/naboo_privateer_tier3:s_719a036e", "tier3_who"}, -- Who?
	}
}
beissa_convo:addScreen(beissa_tier3_fourth_mission);

beissa_tier3_another_assassin = ConvoScreen:new {
	id = "tier3_another_assassin",
	leftDialog = "@conversation/naboo_privateer_tier3:s_acc52186", -- There's more?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_c551ea96", "tier3_beldini_target"}, -- Looks that way.
	}
}
beissa_convo:addScreen(beissa_tier3_another_assassin);

beissa_tier3_who = ConvoScreen:new {
	id = "tier3_who",
	leftDialog = "@conversation/naboo_privateer_tier3:s_5ed53186", -- A human, name of Beldini. The worst of the bunch. He'd kill ya as soon as look at ya.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_981c060d", "tier3_shoot_first"}, -- Then I guess I better shoot first.
	}
}
beissa_convo:addScreen(beissa_tier3_who);

beissa_tier3_beldini_target = ConvoScreen:new {
	id = "tier3_beldini_target",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3c432969", -- Right. Your first target is a human, Beldini. Terrorist, killer, all-around bad guy.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6bdcb65c", "tier3_just_tell_where"}, -- Just tell me where to go.
	}
}
beissa_convo:addScreen(beissa_tier3_beldini_target);

beissa_tier3_shoot_first = ConvoScreen:new {
	id = "tier3_shoot_first",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_ff7bebda", "tier3_accept_fourth_mission"}, -- Don't let me down, ok? You'd hate to see a grown man cry.
	}
}
beissa_convo:addScreen(beissa_tier3_shoot_first);

beissa_tier3_just_tell_where = ConvoScreen:new {
	id = "tier3_just_tell_where",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_f69a2921", "tier3_accept_fourth_mission"}, -- Glad to hear it.
	}
}
beissa_convo:addScreen(beissa_tier3_just_tell_where);

beissa_tier3_accept_fourth_mission = ConvoScreen:new {
	id = "tier3_accept_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3fa8b6f1", -- Coordinates are in your ship. You're clear to leave.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_fourth_mission);

beissa_tier3_failed_fourth_mission = ConvoScreen:new {
	id = "tier3_failed_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_145dcab", -- NO! I only like pilots that finish their missions! Get back out there!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "tier3_nothing_cant_handle"}, -- Nothing I can't handle.
	}
}
beissa_convo:addScreen(beissa_tier3_failed_fourth_mission);

beissa_tier3_nothing_cant_handle = ConvoScreen:new {
	id = "tier3_nothing_cant_handle",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ff5d0ba8", -- Because those lowlifes are using you for target practice. Get back up there and take those guys out!
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_nothing_cant_handle);

beissa_tier3_complete_mission4 = ConvoScreen:new {
	id = "tier3_complete_mission4",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ae2d3229", -- I salute you, %TU. You're one heck of a pilot. Is there anything you DON'T know?
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission4);

beissa_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_327eb2d6", -- Oh yeah, that's right, I forgot. How about you GO DO THAT ALREADY.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_on_mission);

beissa_tier3_train_warships = ConvoScreen:new {
	id = "tier3_train_warships",
	leftDialog = "@conversation/naboo_privateer_tier3:s_89ff8475", -- Obviously. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_warships);

beissa_tier3_train_components = ConvoScreen:new {
	id = "tier3_train_components",
	leftDialog = "@conversation/naboo_privateer_tier3:s_9b1d2d87", -- Done. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_components);

beissa_tier3_train_techniques = ConvoScreen:new {
	id = "tier3_train_techniques",
	leftDialog = "@conversation/naboo_privateer_tier3:s_bd234730", -- You got it. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_techniques);

beissa_tier3_train_programming = ConvoScreen:new {
	id = "tier3_train_programming",
	leftDialog = "@conversation/naboo_privateer_tier3:s_dcf601cc", -- Don't we all! This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_programming);

addConversationTemplate("beissa_convo", beissa_convo);

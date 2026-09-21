dulios_convo_template = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "duliosConvoHandler",
	screens = {}
}

pilot_not_rsf = ConvoScreen:new {
	id = "pilot_not_rsf",
	leftDialog = "@conversation/naboo_privateer_tier3:s_843db48d", -- I don't think I know you. And Mama told me not to talk to strangers. Beat it.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(pilot_not_rsf);

completed_dulios = ConvoScreen:new {
	id = "completed_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you - maybe. But duty calls. You're now assigned to Admiral Diness Imler, down the hall - he'll be giving you orders from now on. See ya, %TU.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(completed_dulios);

train_warships_final = ConvoScreen:new {
	id = "train_warships_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_warships_final);

train_components_final = ConvoScreen:new {
	id = "train_components_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_components_final);

train_techniques_final = ConvoScreen:new {
	id = "train_techniques_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_techniques_final);

train_programming_final = ConvoScreen:new {
	id = "train_programming_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_programming_final);

--[[
	Quest Line Missions
]]

-- Mission 1: Capture a Black Sun Assassin (Recovery mission in Dantooine)

first_mission = ConvoScreen:new {
	id = "first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_a31b65f9", -- %TU. You're the new one.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_19425c2f", "im_dulios"}, -- You are?
		{"@conversation/naboo_privateer_tier3:s_731caa45", "have_mission"}, -- Got a mission for me?
	}
}
dulios_convo_template:addScreen(first_mission);

im_dulios = ConvoScreen:new {
	id = "im_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_88a726df", -- Hey, we'll see what you say when you're on this side of the desk. Let's get you started.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b1da46d", "have_mission"}, -- Where do I start?
	}
}
dulios_convo_template:addScreen(im_dulios);

have_mission = ConvoScreen:new {
	id = "have_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_666cac71", -- These guys pose a SERIOUS threat to the royal family - hell, to this entire planet.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_5bd69df6", "blacksun_threat"}, -- What do you need me to do?
	}
}
dulios_convo_template:addScreen(have_mission);

blacksun_threat = ConvoScreen:new {
	id = "blacksun_threat",
	leftDialog = "@conversation/naboo_privateer_tier3:s_e1e07205", -- All you need to do is stop his ship. The boys in the lab are putting together a little surprise for him, but it's up to you to deliver the package. Get over to the Dantooine System; we'll update you from there.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_7478d95d", "accept_first_mission"}, -- Loud and clear. Where to?
	}
}
dulios_convo_template:addScreen(blacksun_threat);

accept_first_mission = ConvoScreen:new {
	id = "accept_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(accept_first_mission);

failed_first_mission = ConvoScreen:new {
	id = "failed_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_97e76dd", -- This Royal Security Forces assignment isn't so easy after all, is it?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "try_first_again"}, -- Nothing I can't handle.
	}
}
dulios_convo_template:addScreen(failed_first_mission);

try_first_again = ConvoScreen:new {
	id = "try_first_again",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(try_first_again);

complete_mission1 = ConvoScreen:new {
	id = "complete_mission1",
	leftDialog = "@conversation/naboo_privateer_tier3:s_8de81731", -- I'm really going to miss that Saymonz Varg.
	stopConversation = "false",
	options = {}
}
dulios_convo_template:addScreen(complete_mission1);

-- Mission 2: Escort the Cadamo Sun

second_mission = ConvoScreen:new {
	id = "second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4f5f8321", -- Well, you noticed on your last mission that we have run-ins from time to time with pirates.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a56734f6", "pirates_are_crafty"}, -- I noticed.
	}
}
dulios_convo_template:addScreen(second_mission);

pirates_are_crafty = ConvoScreen:new {
	id = "pirates_are_crafty",
	leftDialog = "@conversation/naboo_privateer_tier3:s_e1775a2f", -- Pirates are crafty devils. Always scheming. So we've got to be crafty too.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_2b6e8499", "cadamo_sun"}, -- As long as I get to shoot down a couple of pirate ships, I'm happy.
	}
}
dulios_convo_template:addScreen(pirates_are_crafty);

cadamo_sun = ConvoScreen:new {
	id = "cadamo_sun",
	leftDialog = "@conversation/naboo_privateer_tier3:s_2c397539", -- I've got a freighter that needs a pilot escort. It's an old Corellian YT variant, the Cadamo Sun.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_3895c4ae", "decoy_freighter"}, -- Okay...so what's onboard this ship?
	}
}
dulios_convo_template:addScreen(cadamo_sun);

decoy_freighter = ConvoScreen:new {
	id = "decoy_freighter",
	leftDialog = "@conversation/naboo_privateer_tier3:s_7278c01", -- This is a decoy ship. The real goods are on another transport.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_7a9f14df", "keep_decoy_secret"}, -- So I'm guarding nothing.
	}
}
dulios_convo_template:addScreen(decoy_freighter);

keep_decoy_secret = ConvoScreen:new {
	id = "keep_decoy_secret",
	leftDialog = "@conversation/naboo_privateer_tier3:s_21bb034b", -- You got it. And we want to keep that a little-known fact, if you get my drift.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6540bc41", "aynat_pirates"}, -- Who's gunning for it?
	}
}
dulios_convo_template:addScreen(keep_decoy_secret);

aynat_pirates = ConvoScreen:new {
	id = "aynat_pirates",
	leftDialog = "@conversation/naboo_privateer_tier3:s_72c4169a", -- Ay'Nat Pirate Faction. They want what they think the ship has.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_d5d8a006", "accept_second_mission"}, -- But what they'll get is me.
	}
}
dulios_convo_template:addScreen(aynat_pirates);

accept_second_mission = ConvoScreen:new {
	id = "accept_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b8955212", -- The freighter is up around Naboo; you're clear to go.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(accept_second_mission);

failed_second_mission = ConvoScreen:new {
	id = "failed_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_53daee1c", -- You're starting to get a bad reputation.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_83b47a80", "stories_about_me"}, -- You telling stories about me?
	}
}
dulios_convo_template:addScreen(failed_second_mission);

stories_about_me = ConvoScreen:new {
	id = "stories_about_me",
	leftDialog = "@conversation/naboo_privateer_tier3:s_57d34626", -- I don't need to! People know those hunters are using you for target practice. Get back out there - and try fighting back this time.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(stories_about_me);

complete_mission2 = ConvoScreen:new {
	id = "complete_mission2",
	leftDialog = "@conversation/naboo_privateer_tier3:s_29a181c", -- Those pirates really wanted that cargo, eh?
	stopConversation = "false",
	options = {}
}
dulios_convo_template:addScreen(complete_mission2);

-- Mission 3: Inspect the diplomatic convoy

third_mission = ConvoScreen:new {
	id = "third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_5075e20b", -- Your new mission targets a criminal of a different type. I'm talking about diplomats.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_66f6527f", "diplomats_know"}, -- Do the diplomats know?
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "where_diplomats"}, -- Where are these diplomats?
	}
}
dulios_convo_template:addScreen(third_mission);

diplomats_know = ConvoScreen:new {
	id = "diplomats_know",
	leftDialog = "@conversation/naboo_privateer_tier3:s_68d4ba6b", -- It is probably smugglers hiding gear on the diplomats' ships.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a41bb8c7", "how_suspicious"}, -- How can you be so suspicious?
	}
}
dulios_convo_template:addScreen(diplomats_know);

how_suspicious = ConvoScreen:new {
	id = "how_suspicious",
	leftDialog = "@conversation/naboo_privateer_tier3:s_83905129", -- Smugglers may be packing these ships with contraband.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_c089dba4", "just_am"}, -- I just am.
	}
}
dulios_convo_template:addScreen(how_suspicious);

just_am = ConvoScreen:new {
	id = "just_am",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c65cf2da", -- I love you new guys. So easy to wind up.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "where_diplomats"}, -- Where are these diplomats?
	}
}
dulios_convo_template:addScreen(just_am);

where_diplomats = ConvoScreen:new {
	id = "where_diplomats",
	leftDialog = "@conversation/naboo_privateer_tier3:s_76734574", -- Fly out to the waypoint and inspect each of them.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6c251948", "accept_third_mission"}, -- You got it.
	}
}
dulios_convo_template:addScreen(where_diplomats);

accept_third_mission = ConvoScreen:new {
	id = "accept_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c4095762", -- Inspect the diplomats' ships and see what you can find.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(accept_third_mission);

failed_third_mission = ConvoScreen:new {
	id = "failed_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_53daee1c", -- You're starting to get a bad reputation.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_83b47a80", "i_was_better"}, -- You telling stories about me?
	}
}
dulios_convo_template:addScreen(failed_third_mission);

i_was_better = ConvoScreen:new {
	id = "i_was_better",
	leftDialog = "@conversation/naboo_privateer_tier3:s_57d34626", -- Get back out there and try fighting back this time.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(i_was_better);

complete_mission3 = ConvoScreen:new {
	id = "complete_mission3",
	leftDialog = "@conversation/naboo_privateer_tier3:s_47152ac5", -- The data you intercepted led us to assassins and terrorists.
	stopConversation = "false",
	options = {}
}
dulios_convo_template:addScreen(complete_mission3);
-- Mission 4: Hunt Human Assassin Beldini

fourth_mission = ConvoScreen:new {
	id = "fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_2b9a70e4", -- The data from your last mission identified a host of assassins and terrorists.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_7339c95e", "beldini_target"}, -- Anybody at the top of the list?
	}
}
dulios_convo_template:addScreen(fourth_mission);

beldini_target = ConvoScreen:new {
	id = "beldini_target",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3c432969", -- Right. Your first target is a human, Beldini. Terrorist, killer, all-around bad guy.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6bdcb65c", "just_tell_where"}, -- Just tell me where to go.
	}
}
dulios_convo_template:addScreen(beldini_target);

just_tell_where = ConvoScreen:new {
	id = "just_tell_where",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_f69a2921", "accept_fourth_mission"}, -- Glad to hear it.
	}
}
dulios_convo_template:addScreen(just_tell_where);

accept_fourth_mission = ConvoScreen:new {
	id = "accept_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3fa8b6f1", -- Coordinates are in your ship. You're clear to leave.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(accept_fourth_mission);

failed_fourth_mission = ConvoScreen:new {
	id = "failed_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_145dcab", -- NO! I only like pilots that finish their missions! Get back out there!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "nothing_cant_handle"}, -- Nothing I can't handle.
	}
}
dulios_convo_template:addScreen(failed_fourth_mission);

nothing_cant_handle = ConvoScreen:new {
	id = "nothing_cant_handle",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ff5d0ba8", -- Because those lowlifes are using you for target practice. Get back up there and take those guys out!
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(nothing_cant_handle);

complete_mission4 = ConvoScreen:new {
	id = "complete_mission4",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ae2d3229", -- I salute you, %TU. You're one heck of a pilot. Is there anything you DON'T know?
	stopConversation = "false",
	options = {}
}
dulios_convo_template:addScreen(complete_mission4);

--[[
	Conversation Enders
]]

not_tier3 = ConvoScreen:new {
	id = "not_tier3",
	leftDialog = "@conversation/naboo_privateer_tier3:s_406e1216", -- Looks like you took a wrong turn somewhere. Scram.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(not_tier3);

on_mission = ConvoScreen:new {
	id = "on_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_327eb2d6", -- Oh yeah, that's right, I forgot. How about you GO DO THAT ALREADY.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(on_mission);

train_warships = ConvoScreen:new {
	id = "train_warships",
	leftDialog = "@conversation/naboo_privateer_tier3:s_89ff8475", -- Obviously. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_warships);

train_components = ConvoScreen:new {
	id = "train_components",
	leftDialog = "@conversation/naboo_privateer_tier3:s_9b1d2d87", -- Done. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_components);

train_techniques = ConvoScreen:new {
	id = "train_techniques",
	leftDialog = "@conversation/naboo_privateer_tier3:s_bd234730", -- You got it. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_techniques);

train_programming = ConvoScreen:new {
	id = "train_programming",
	leftDialog = "@conversation/naboo_privateer_tier3:s_dcf601cc", -- Don't we all! This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dulios_convo_template:addScreen(train_programming);

addConversationTemplate("dulios_convo_template", dulios_convo_template);

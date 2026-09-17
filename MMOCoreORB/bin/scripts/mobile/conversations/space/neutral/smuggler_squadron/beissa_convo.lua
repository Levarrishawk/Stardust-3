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
	leftDialog = "@conversation/tatooine_privateer_tier3:s_b3b64ad2",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_completed_dulios);

beissa_tier3_train_warships_final = ConvoScreen:new {
	id = "tier3_train_warships_final",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_b3b64ad2",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_warships_final);

beissa_tier3_train_components_final = ConvoScreen:new {
	id = "tier3_train_components_final",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_b3b64ad2",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_components_final);

beissa_tier3_train_techniques_final = ConvoScreen:new {
	id = "tier3_train_techniques_final",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_b3b64ad2",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_techniques_final);

beissa_tier3_train_programming_final = ConvoScreen:new {
	id = "tier3_train_programming_final",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_b3b64ad2",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_programming_final);

beissa_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_da70d826",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_9ea143d7", "tier3_im_dulios"},
	}
}
beissa_convo:addScreen(beissa_tier3_first_mission);

beissa_tier3_im_dulios = ConvoScreen:new {
	id = "tier3_im_dulios",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_dea9aa2e",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_8ecd2ed0", "tier3_have_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_im_dulios);

beissa_tier3_have_mission = ConvoScreen:new {
	id = "tier3_have_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_e2e25101",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_4c695dbd", "tier3_beissa_why_back"},
	}
}
beissa_convo:addScreen(beissa_tier3_have_mission);

beissa_tier3_beissa_why_back = ConvoScreen:new {
	id = "tier3_beissa_why_back",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_e610029c",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_fccc4442", "tier3_beissa_strange"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_why_back);

beissa_tier3_beissa_strange = ConvoScreen:new {
	id = "tier3_beissa_strange",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_ef696d16",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_d6d5b88c", "tier3_beissa_killed"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_strange);

beissa_tier3_beissa_killed = ConvoScreen:new {
	id = "tier3_beissa_killed",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_eb9f64f0",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_9532fb5c", "tier3_beissa_tongue"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_killed);

beissa_tier3_beissa_tongue = ConvoScreen:new {
	id = "tier3_beissa_tongue",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_6a5f1bad",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_4d5af593", "tier3_beissa_has_use"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_tongue);

beissa_tier3_beissa_has_use = ConvoScreen:new {
	id = "tier3_beissa_has_use",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_48a3c712",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_1adbadc4", "tier3_beissa_loyalty"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_has_use);

beissa_tier3_beissa_loyalty = ConvoScreen:new {
	id = "tier3_beissa_loyalty",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_15349399",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_438512f8", "tier3_beissa_shipment"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_loyalty);

beissa_tier3_beissa_shipment = ConvoScreen:new {
	id = "tier3_beissa_shipment",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_ff68e70a",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_4d69a104", "tier3_beissa_enemies"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_shipment);

beissa_tier3_beissa_enemies = ConvoScreen:new {
	id = "tier3_beissa_enemies",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_505c7932",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_800d8ca1", "tier3_beissa_valarians"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_enemies);

beissa_tier3_beissa_valarians = ConvoScreen:new {
	id = "tier3_beissa_valarians",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f5dff86f",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_8c796cbf", "tier3_beissa_perfect"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_valarians);

beissa_tier3_beissa_perfect = ConvoScreen:new {
	id = "tier3_beissa_perfect",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f3d30738",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_bc375f79", "tier3_beissa_opportunity"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_perfect);

beissa_tier3_beissa_opportunity = ConvoScreen:new {
	id = "tier3_beissa_opportunity",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_acbfc0cc",
	stopConversation = "false",
	options = {{"@conversation/tatooine_privateer_tier3:s_31960979", "tier3_blacksun_threat"}}
}
beissa_convo:addScreen(beissa_tier3_beissa_opportunity);

beissa_tier3_blacksun_threat = ConvoScreen:new {
	id = "tier3_blacksun_threat",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_c6e0e27",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_ad7db4d", "tier3_accept_first_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_blacksun_threat);

beissa_tier3_accept_first_mission = ConvoScreen:new {
	id = "tier3_accept_first_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_5d667e15",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_first_mission);

beissa_tier3_failed_first_mission = ConvoScreen:new {
	id = "tier3_failed_first_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f840ac8a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_fa1878f7", "tier3_try_first_again"},
	}
}
beissa_convo:addScreen(beissa_tier3_failed_first_mission);

beissa_tier3_try_first_again = ConvoScreen:new {
	id = "tier3_try_first_again",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_5d667e15",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_try_first_again);

beissa_tier3_complete_mission1 = ConvoScreen:new {
	id = "tier3_complete_mission1",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_ea4e584a",
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission1);

beissa_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_afa084aa",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_db509386", "tier3_diplomats_know"},
		{"@conversation/tatooine_privateer_tier3:s_d7c19f3f", "tier3_where_diplomats"},
	}
}
beissa_convo:addScreen(beissa_tier3_second_mission);

beissa_tier3_diplomats_know = ConvoScreen:new {
	id = "tier3_diplomats_know",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_26790919",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_9fc316af", "tier3_how_suspicious"},
	}
}
beissa_convo:addScreen(beissa_tier3_diplomats_know);

beissa_tier3_how_suspicious = ConvoScreen:new {
	id = "tier3_how_suspicious",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_38f0bcdf",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_2bbcaa92", "tier3_just_am"},
	}
}
beissa_convo:addScreen(beissa_tier3_how_suspicious);

beissa_tier3_just_am = ConvoScreen:new {
	id = "tier3_just_am",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_7943df8d",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_d7c19f3f", "tier3_where_diplomats"},
	}
}
beissa_convo:addScreen(beissa_tier3_just_am);

beissa_tier3_where_diplomats = ConvoScreen:new {
	id = "tier3_where_diplomats",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_bcad400e",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_731189e6", "tier3_accept_second_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_where_diplomats);

beissa_tier3_accept_second_mission = ConvoScreen:new {
	id = "tier3_accept_second_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_ed7786ee",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_second_mission);

beissa_tier3_failed_second_mission = ConvoScreen:new {
	id = "tier3_failed_second_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_be822621",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_fa1878f7", "tier3_stories_about_me"},
	}
}
beissa_convo:addScreen(beissa_tier3_failed_second_mission);

beissa_tier3_stories_about_me = ConvoScreen:new {
	id = "tier3_stories_about_me",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_9b22b078",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_stories_about_me);

beissa_tier3_complete_mission2 = ConvoScreen:new {
	id = "tier3_complete_mission2",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_3f262d6b",
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission2);

beissa_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_2a335ce3",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_52917b0d", "tier3_rodians_feel"},
		{"@conversation/tatooine_privateer_tier3:s_9fc316af", "tier3_killing_bad_guys"},
	}
}
beissa_convo:addScreen(beissa_tier3_third_mission);

beissa_tier3_rodians_feel = ConvoScreen:new {
	id = "tier3_rodians_feel",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_509249db",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_b55e3f14", "tier3_love_em"},
		{"@conversation/tatooine_privateer_tier3:s_9fc316af", "tier3_hate_em"},
	}
}
beissa_convo:addScreen(beissa_tier3_rodians_feel);

beissa_tier3_killing_bad_guys = ConvoScreen:new {
	id = "tier3_killing_bad_guys",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_1edbaf3a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_ecbb4e43", "tier3_rodians_feel"},
	}
}
beissa_convo:addScreen(beissa_tier3_killing_bad_guys);

beissa_tier3_love_em = ConvoScreen:new {
	id = "tier3_love_em",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_d60918d0",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_72318c63", "tier3_rodian_killed"},
	}
}
beissa_convo:addScreen(beissa_tier3_love_em);

beissa_tier3_hate_em = ConvoScreen:new {
	id = "tier3_hate_em",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_dcea0b58",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_551c4bc7", "tier3_shooting_politicians"},
	}
}
beissa_convo:addScreen(beissa_tier3_hate_em);

beissa_tier3_rodian_killed = ConvoScreen:new {
	id = "tier3_rodian_killed",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_c1730a04",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_80bfc2af", "tier3_more_complicated"},
	}
}
beissa_convo:addScreen(beissa_tier3_rodian_killed);

beissa_tier3_shooting_politicians = ConvoScreen:new {
	id = "tier3_shooting_politicians",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_4050c6fc",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_80bfc2af", "tier3_more_complicated"},
	}
}
beissa_convo:addScreen(beissa_tier3_shooting_politicians);

beissa_tier3_more_complicated = ConvoScreen:new {
	id = "tier3_more_complicated",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_c33fad75",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_731189e6", "tier3_find_charmer"},
	}
}
beissa_convo:addScreen(beissa_tier3_more_complicated);

beissa_tier3_find_charmer = ConvoScreen:new {
	id = "tier3_find_charmer",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_c1730a04",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_4050c6fc", "tier3_accept_third_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_find_charmer);

beissa_tier3_accept_third_mission = ConvoScreen:new {
	id = "tier3_accept_third_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_4050c6fc",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_third_mission);

beissa_tier3_failed_third_mission = ConvoScreen:new {
	id = "tier3_failed_third_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_be822621",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_fa1878f7", "tier3_i_was_better"},
	}
}
beissa_convo:addScreen(beissa_tier3_failed_third_mission);

beissa_tier3_i_was_better = ConvoScreen:new {
	id = "tier3_i_was_better",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_9b22b078",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_i_was_better);

beissa_tier3_complete_mission3 = ConvoScreen:new {
	id = "tier3_complete_mission3",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_22f30f4c",
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission3);

beissa_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f390de3b",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_e2b3bd3d", "tier3_another_assassin"},
		{"@conversation/tatooine_privateer_tier3:s_719a036e", "tier3_who"},
	}
}
beissa_convo:addScreen(beissa_tier3_fourth_mission);

beissa_tier3_another_assassin = ConvoScreen:new {
	id = "tier3_another_assassin",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_2795978a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_58081a79", "tier3_beldini_target"},
	}
}
beissa_convo:addScreen(beissa_tier3_another_assassin);

beissa_tier3_who = ConvoScreen:new {
	id = "tier3_who",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_99b1ec0",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_dd19988e", "tier3_shoot_first"},
	}
}
beissa_convo:addScreen(beissa_tier3_who);

beissa_tier3_beldini_target = ConvoScreen:new {
	id = "tier3_beldini_target",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_83c2b64",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_800d8ca1", "tier3_just_tell_where"},
	}
}
beissa_convo:addScreen(beissa_tier3_beldini_target);

beissa_tier3_shoot_first = ConvoScreen:new {
	id = "tier3_shoot_first",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_5d667e15",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_bc375f79", "tier3_accept_fourth_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_shoot_first);

beissa_tier3_just_tell_where = ConvoScreen:new {
	id = "tier3_just_tell_where",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_5d667e15",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_bc375f79", "tier3_accept_fourth_mission"},
	}
}
beissa_convo:addScreen(beissa_tier3_just_tell_where);

beissa_tier3_accept_fourth_mission = ConvoScreen:new {
	id = "tier3_accept_fourth_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_6fe71f0c",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_accept_fourth_mission);

beissa_tier3_failed_fourth_mission = ConvoScreen:new {
	id = "tier3_failed_fourth_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f840ac8a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_tier3:s_fa1878f7", "tier3_nothing_cant_handle"},
	}
}
beissa_convo:addScreen(beissa_tier3_failed_fourth_mission);

beissa_tier3_nothing_cant_handle = ConvoScreen:new {
	id = "tier3_nothing_cant_handle",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_9b22b078",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_nothing_cant_handle);

beissa_tier3_complete_mission4 = ConvoScreen:new {
	id = "tier3_complete_mission4",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_bcb460ff",
	stopConversation = "false",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_complete_mission4);

beissa_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_25ba96cd",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_on_mission);

beissa_tier3_train_warships = ConvoScreen:new {
	id = "tier3_train_warships",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_999144d9",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_warships);

beissa_tier3_train_components = ConvoScreen:new {
	id = "tier3_train_components",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_f2593c16",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_components);

beissa_tier3_train_techniques = ConvoScreen:new {
	id = "tier3_train_techniques",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_32376199",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_techniques);

beissa_tier3_train_programming = ConvoScreen:new {
	id = "tier3_train_programming",
	leftDialog = "@conversation/tatooine_privateer_tier3:s_e413d452",
	stopConversation = "true",
	options = {}
}
beissa_convo:addScreen(beissa_tier3_train_programming);

addConversationTemplate("beissa_convo", beissa_convo);

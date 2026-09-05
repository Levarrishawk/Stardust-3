--[[
	Kashyyyk Etyyy hunt quest XP -- Mustafar shape (mustafar_quest_xp.lua), OURS.

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	Extends KashyyykQuestXp.quests. xp is quest_experience[LEVEL][TIER_n].
	TIER < 1 is a passthrough of the stored amount, which is 0.

	NO JOURNAL: do not call the journal engine.
]]

do
	local hunt = {
		ep3_hunt_kerssoc_enter_etyyy                 = { xp =    215, level =  40, tier =  1, soeType = "quest_combat" },
		ep3_hunt_kerssoc_bantha_pelts                = { xp =  20257, level =  40, tier =  3, soeType = "quest_combat" },
		ep3_hunt_kerssoc_kill_chiss_poachers         = { xp =  25702, level =  45, tier =  3, soeType = "quest_combat" },
		ep3_hunt_chrilooc_seek_rodians               = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_chrilooc_seek_rodians_02            = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_chrilooc_seek_johnson               = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_wrelaac_proof_of_mada               = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_wrelaac_to_chrilooc                 = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_mada_johnson_to_wrelaac             = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_sordaan_uller_bet                   = { xp =      0, level =  47, tier = -1, soeType = "quest_combat" },
		ep3_hunt_sordaan_uller_bet_won               = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_uller_bet_lost              = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_walluga_bet                 = { xp =      0, level =  48, tier = -1, soeType = "quest_combat" },
		ep3_hunt_sordaan_walluga_bet_won             = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_walluga_bet_lost            = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_mouf_bet                    = { xp =      0, level =  48, tier = -1, soeType = "quest_combat" },
		ep3_hunt_sordaan_mouf_bet_won                = { xp =      0, level =   1, tier = -1, soeType = "" },
		ep3_hunt_sordaan_mouf_bet_lost               = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_webweaver_bet               = { xp =      0, level =  48, tier = -1, soeType = "quest_combat" },
		ep3_hunt_sordaan_webweaver_bet_won           = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_webweaver_bet_lost          = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_all_bets_reward             = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_seek_harroom                = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_sordaan_seek_sordaan                = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_ziven_collect_webweaver_eyes        = { xp =  30767, level =  49, tier =  3, soeType = "quest_combat" },
		ep3_hunt_ziven_collect_webweaver_fangs       = { xp =  29442, level =  48, tier =  3, soeType = "quest_combat" },
		ep3_hunt_manfred_steal_chiss_goods           = { xp =  25702, level =  45, tier =  3, soeType = "quest_combat" },
		ep3_hunt_manfred_collect_enhancements        = { xp =  34381, level =  46, tier =  4, soeType = "quest_combat" },
		ep3_hunt_manfred_kill_chiss_leader           = { xp =  35976, level =  47, tier =  4, soeType = "quest_combat" },
		ep3_hunt_tripp_collect_mouf_pelts            = { xp =  25702, level =  45, tier =  3, soeType = "quest_combat" },
		ep3_hunt_tripp_collect_mouf_incisors         = { xp =  24530, level =  44, tier =  3, soeType = "quest_combat" },
		ep3_hunt_ehartt_collect_walluga_claws        = { xp =  26906, level =  46, tier =  3, soeType = "quest_combat" },
		ep3_hunt_harroom_uller_reward                = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_harroom_walluga_reward              = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_harroom_mouf_reward                 = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_harroom_webweaver_reward            = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_iluna_goto_arcona_compound          = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_hracca_kkorrwrot_hunt               = { xp = 198814, level =  86, tier =  5, soeType = "quest_combat" },
		ep3_hunt_tuwezz_collect_uller_horns          = { xp =  25702, level =  45, tier =  3, soeType = "quest_combat" },
		ep3_hunt_tuwezz_kill_diseased_ullers         = { xp =  23403, level =  43, tier =  3, soeType = "quest_combat" },
		ep3_hunt_johnson_help_kara                   = { xp =  18563, level =  45, tier =  2, soeType = "quest_combat" },
		ep3_hunt_johnson_retrieve_ryoos_stash        = { xp =  18563, level =  45, tier =  2, soeType = "quest_combat" },
		ep3_hunt_johnson_seek_kint                   = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_johnson_brody_johnson               = { xp =  18563, level =  45, tier =  2, soeType = "quest_combat" },
		ep3_hunt_jerrol_seek_johnson                 = { xp =    237, level =  45, tier =  1, soeType = "quest_combat" },
		ep3_hunt_loot_brightclaw_killed              = { xp =  20334, level =  47, tier =  2, soeType = "quest_combat" },
		ep3_hunt_loot_completed_all                  = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_loot_greyclimber_killed             = { xp =      0, level =  40, tier =  0, soeType = "quest_combat" },
		ep3_hunt_loot_paleclaw_killed                = { xp =  21263, level =  48, tier =  2, soeType = "quest_combat" },
		ep3_hunt_loot_silkthrower_killed             = { xp =  22220, level =  49, tier =  2, soeType = "quest_combat" },
		ep3_hunt_loot_spiketop_killed                = { xp =  19432, level =  46, tier =  2, soeType = "quest_combat" },
		ep3_hunt_loot_stoneleg_killed                = { xp =  23210, level =  50, tier =  2, soeType = "quest_combat" },
		ep3_hunt_reward_2000_credits                 = { xp =      0, level =   0, tier = -1, soeType = "" },
		ep3_hunt_vritol_reward_mount                 = { xp =      0, level =   0, tier = -1, soeType = "" },
	}
	for k, v in pairs(hunt) do
		KashyyykQuestXp.quests[k] = v
	end
end

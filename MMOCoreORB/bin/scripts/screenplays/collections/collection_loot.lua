-- Collection creature loot drops + consume-loot Use (ruling 2026-09-05:
-- "the items across the galaxy, everything").
-- SOURCED drop: loot.java:1545 addCollectionLoot -- on a kill, rand(1,100) <=
-- creatures.tab collectionRoll; pick ONE column at random from collectionLoot;
-- pick ONE item at random from that column of collection_loot.tab; create the
-- static item in the corpse inventory.
-- SOURCED creatures.tab collectionRoll (ruling 2026-09-05: shipped rolls
-- as SOURCED; heroic loot rounds took SOE chances as SOURCED; no Pre-CU
-- value conflicts). Six rows:
--   ancient_bull_rancor creatures.tab:38 roll=6 columns=11
--   bane_back_spider creatures.tab:138 roll=100 columns=1
--   binayre_chief creatures.tab:205 roll=6 columns=3
--   endor_ig88_security_battlemech_alpha creatures.tab:1216 roll=2 columns=1
--   mand_bunker_foreman creatures.tab:2789 roll=7 columns=7
--   naboo_pirate creatures.tab:3599 roll=4 columns=1
-- OURS attach: one lootGroups entry per collectionLoot column on the
-- creature template (CreatureTemplate.cpp:187 copies at registration;
-- Lua cannot amend a registered CreatureTemplate). lootChance =
-- collectionRoll * 100000 / nColumns so the per-kill total equals the
-- shipped roll (LootManagerImplementation.cpp:706-715; 1% = 100000).
-- Inner chance = 10000000. Core3 rolls each entry independently; the
-- split makes at most one column expected per kill.
-- Which creature drops which collection is content and is listed below.
-- SOURCED use: consume_loot.java:23 OnObjectMenuRequest ITEM_USE
-- @collection:consume_item; :32 OnObjectMenuSelect: need_to_activate_collection,
-- already_have_slot / already_finished_collection / modifyCollectionSlotValue
-- then destroy, or report_consume_item_fail. :216 multi-slot `a|b|c` uses
-- collection_list_prompt / collection_list_title.
-- OURS (Core3 translation): CollectionLootItemMenuComponent implements Use
-- (ITEM_USE 20; SharedTangibleObjectTemplate.lua:114 / SharedObjectTemplate.cpp:169).
-- OURS: CollectionLoot.ENABLED = true; chances are the SOURCED collectionRoll
-- split across columns as above. Templates under mobile/ hold the lootGroups.
-- OURS: grant path records the slot as writeStringData(oid .. ":collection.slot")
-- (Core3 has no per-object item_stats).
-- OURS: after that stored record, slot resolution matches
-- SceneObject:getCustomObjectName() (LuaSceneObject.cpp:74) to
-- CollectionStaticItems.displayName among rows sharing the template; if the
-- name is unique or every duplicate maps to the same slot, use it; if
-- duplicates map to different slots, return those slots joined with `|`
-- (consume_loot.java:216 multi-slot form). onUse then offers still-open
-- collections via collection_list_title / collection_list_prompt, or fills
-- the one remaining entry without asking (onUse #avail == 1 ->
-- confirmConsume). Else the unique-template reverse map. Loot
-- customObjectName and grant setCustomObjectName (LuaSceneObject.cpp:39)
-- are SOURCED master_item.tab string_name.
-- lootChance scale: LootGroupCollectionEntry.h:39 + LootManagerImplementation.cpp:711
-- System::random(10000000). SharedTangibleObjectTemplate.lua:114 objectMenuComponent;
-- SharedObjectTemplate.cpp:169 parses it.

CollectionLoot = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionLoot",
	ENABLED = true, -- SOURCED creatures.tab collectionRoll (see header)
	creatures = {
		{name="ancient_bull_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_01", "housing_improvement_02", "housing_improvement_03", "housing_improvement_04", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_dejarik_table", "col_story_count_dooku_set_2", "col_shattered_shard_02"}},
		{name="bane_back_spider", roll=100, columns={"col_bane_back_spider"}},
		{name="binayre_chief", roll=6, columns={"housing_improvement_02", "col_aurebesh_tiles", "col_shattered_shard_04"}},
		{name="binayre_hooligan", roll=4, columns={"housing_improvement_01", "col_aurebesh_tiles", "col_contraband_set_02", "col_shattered_shard_01"}},
		{name="binayre_scalawag", roll=4, columns={"housing_improvement_01", "col_aurebesh_tiles", "col_contraband_set_02", "col_shattered_shard_01"}},
		{name="binayre_swindler", roll=6, columns={"housing_improvement_02", "col_aurebesh_tiles", "col_contraband_set_02", "col_shattered_shard_04"}},
		{name="black_sun_smuggler", roll=6, columns={"housing_improvement_03", "col_aurebesh_tiles", "col_contraband_set_02", "col_shattered_shard_04", "col_glass_shelving_01"}},
		{name="dark_adept", roll=4, columns={"col_sith_holocron", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="endor_ig88_security_battlemech_alpha", roll=2, columns={"col_holo_emitter_01"}},
		{name="endor_ig88_security_battlemech_beta", roll=2, columns={"col_holo_emitter_01"}},
		{name="endor_ig88_security_battlemech_omega", roll=2, columns={"col_holo_emitter_01"}},
		{name="enraged_bull_rancor", roll=6, columns={"col_rancor_parts", "col_eng_trader", "col_mun_trader"}},
		{name="feeble_kima", roll=4, columns={"housing_improvement_01"}},
		{name="finned_blaggart", roll=100, columns={"col_finned_blaggart"}},
		{name="flit", roll=4, columns={"housing_improvement_01"}},
		{name="force_trained_archaist", roll=3, columns={"housing_improvement_05", "col_jedi_holocron", "col_aurebesh_tiles", "col_shattered_shard_03"}},
		{name="forsaken_force_drifter", roll=4, columns={"housing_improvement_05", "col_jedi_holocron", "col_shattered_shard_03"}},
		{name="giant_peko_peko", roll=3, columns={"col_feather_peko_peko"}},
		{name="gulginaw", roll=4, columns={"col_feather_gulginaw"}},
		{name="injured_kwi", roll=5, columns={"housing_improvement_03", "col_glass_shelving_01"}},
		{name="kai_tok_bloodreaver", roll=6, columns={"col_feather_kai_tok", "housing_improvement_04", "col_story_count_dooku_set_1", "col_glass_shelving_02"}},
		{name="kai_tok_prowler", roll=6, columns={"col_feather_kai_tok", "housing_improvement_04", "col_story_count_dooku_set_1", "col_glass_shelving_02"}},
		{name="kai_tok_scavenger", roll=6, columns={"col_feather_kai_tok", "housing_improvement_04", "col_story_count_dooku_set_1", "col_glass_shelving_02"}},
		{name="kai_tok_slayer", roll=6, columns={"col_feather_kai_tok", "housing_improvement_04", "col_story_count_dooku_set_1", "col_glass_shelving_02"}},
		{name="mand_bunker_foreman", roll=7, columns={"housing_improvement_01", "housing_improvement_02", "housing_improvement_03", "housing_improvement_04", "housing_improvement_05", "col_story_count_dooku_set_3", "col_contraband_set_04"}},
		{name="mand_bunker_technician", roll=6, columns={"housing_improvement_01", "housing_improvement_02", "housing_improvement_03", "housing_improvement_04", "housing_improvement_05", "col_story_count_dooku_set_3"}},
		{name="murra_blanca", roll=100, columns={"col_murra_blanca"}},
		{name="mutant_acklay", roll=100, columns={"col_mutant_acklay"}},
		{name="naboo_legacy_quest_droideka", roll=2, columns={"col_holo_emitter_01"}},
		{name="naboo_legacy_quest_mouse_droid", roll=2, columns={"col_holo_emitter_01"}},
		{name="naboo_pirate", roll=4, columns={"col_contraband_set_01"}},
		{name="naboo_pirate_armsman", roll=4, columns={"col_contraband_set_01"}},
		{name="naboo_pirate_crewman", roll=4, columns={"col_contraband_set_01"}},
		{name="naboo_pirate_cutthroat", roll=4, columns={"col_contraband_set_01"}},
		{name="naboo_pirate_lieutenant", roll=4, columns={"col_contraband_set_01"}},
		{name="narglatch_hunter", roll=6, columns={"col_dejarik_holomonster", "col_dejarik_table"}},
		{name="nightsister_bull_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_enraged_bull_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_enraged_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_initiate", roll=4, columns={"col_nightsister_valuables", "col_sith_holocron", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_outcast", roll=4, columns={"col_nightsister_valuables", "col_sith_holocron", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_ranger", roll=4, columns={"col_nightsister_valuables", "col_sith_holocron", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="nightsister_sentry", roll=4, columns={"col_nightsister_valuables", "col_sith_holocron", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="painted_spat", roll=100, columns={"col_painted_spat"}},
		{name="peko_peko", roll=4, columns={"col_feather_peko_peko"}},
		{name="peko_peko_albatross", roll=6, columns={"col_feather_peko_peko"}},
		{name="probot", roll=2, columns={"col_holo_emitter_01"}},
		{name="ragtag_kook", roll=4, columns={"col_contraband_set_01"}},
		{name="ragtag_mercenary", roll=6, columns={"col_contraband_set_01", "col_shattered_shard_01"}},
		{name="ragtag_thug", roll=6, columns={"col_contraband_set_01", "col_shattered_shard_01"}},
		{name="scorpion_kliknik", roll=100, columns={"col_scorpion_kliknik"}},
		{name="singing_mountain_clan_rancor", roll=6, columns={"col_rancor_parts", "housing_improvement_05", "col_dejarik_holomonster", "col_dejarik_table", "col_shattered_shard_02"}},
		{name="slicer_boyd_chillings", roll=4, columns={"col_contraband_set_01", "col_contraband_set_04", "col_shattered_shard_01", "col_shattered_shard_04"}},
		{name="slicer_kelson_sharphorn", roll=4, columns={"col_contraband_set_03", "col_contraband_set_04", "col_shattered_shard_03", "col_shattered_shard_04"}},
		{name="slicer_skaelor_tay", roll=4, columns={"col_contraband_set_01", "col_contraband_set_02", "col_shattered_shard_01", "col_shattered_shard_02"}},
		{name="som_kenobi_historian_dark_jedi", roll=4, columns={"housing_improvement_03", "housing_improvement_04", "housing_improvement_05", "col_sith_holocron", "col_aurebesh_tiles", "col_shattered_shard_02"}},
		{name="spiketail_blurrg", roll=100, columns={"col_spiketail_blurrg"}},
		{name="swirl_prong_impaler", roll=6, columns={"housing_improvement_04", "housing_improvement_05", "col_story_count_dooku_set_2"}},
		{name="swirl_prong_pack_leader", roll=4, columns={"housing_improvement_01"}},
		{name="tusken_avenger", roll=4, columns={"col_tusken_valuables", "housing_improvement_01", "housing_improvement_02", "col_kill_tusken_activation_loot"}},
		{name="tusken_berserker", roll=4, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_kill_tusken_activation_loot", "col_shattered_shard_01"}},
		{name="tusken_brute", roll=4, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_shattered_shard_01"}},
		{name="tusken_captain", roll=6, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_kill_tusken_activation_loot", "col_shattered_shard_01"}},
		{name="tusken_chief", roll=4, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_kill_tusken_activation_loot", "col_shattered_shard_01"}},
		{name="tusken_guard", roll=4, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_shattered_shard_01"}},
		{name="tusken_warlord", roll=6, columns={"col_tusken_valuables", "col_aurebesh_tiles", "col_kill_tusken_activation_loot", "col_shattered_shard_01"}},
	},
}

-- Absent from this server (146 rows; no mobile template of this name).
--   bestine_tusken_raid_leader creatures.tab:197 roll=4 columns=col_tusken_valuables,col_aurebesh_tiles,col_shattered_shard_01
--   bestine_tusken_raid_sub_leader creatures.tab:198 roll=4 columns=col_tusken_valuables,col_shattered_shard_01
--   borvos_rancor creatures.tab:389 roll=3 columns=col_rancor_parts,col_dejarik_holomonster,col_dejarik_table
--   corellia_braggans_fist_thug creatures.tab:648 roll=4 columns=col_contraband_set_02,col_shattered_shard_01
--   endor_ig88_security_battle_droid_blue creatures.tab:1213 roll=2 columns=col_holo_emitter_01
--   endor_ig88_security_battle_droid_purple creatures.tab:1214 roll=2 columns=col_holo_emitter_01
--   endor_ig88_security_battle_droid_red creatures.tab:1215 roll=2 columns=col_holo_emitter_01
--   feeder_tusken_guard creatures.tab:1774 roll=4 columns=col_tusken_valuables,housing_improvement_01,housing_improvement_02,col_shattered_shard_02
--   garyn_lieutenant creatures.tab:1899 roll=6 columns=housing_improvement_03,col_aurebesh_tiles,col_shattered_shard_04,col_glass_shelving_01
--   garyn_vigo creatures.tab:1906 roll=6 columns=housing_improvement_03,col_aurebesh_tiles,col_shattered_shard_03,col_shattered_shard_04,col_glass_shelving_01
--   heroic_axkva_axkva_min creatures.tab:2154 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table
--   heroic_axkva_kimaru creatures.tab:2157 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table
--   heroic_axkva_lelli_hi creatures.tab:2158 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table
--   heroic_axkva_nandina creatures.tab:2159 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table
--   heroic_axkva_suin_chalo creatures.tab:2160 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table
--   heroic_echo_imp_assassin creatures.tab:6157 roll=12 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_echo_probe_droid creatures.tab:6176 roll=6 columns=col_holo_emitter_01
--   heroic_echo_snowtrooper creatures.tab:6154 roll=12 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_echo_snowtrooper_interior creatures.tab:6155 roll=12 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_echo_stormcommando creatures.tab:6156 roll=12 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_echo_wampa_boss creatures.tab:6207 roll=10 columns=echo_base_wampa_boss
--   heroic_exar_caretaker creatures.tab:5897 roll=25 columns=heroic_exar_caretaker
--   heroic_exar_gackle_bat creatures.tab:5906 roll=5 columns=heroic_exar_gackle_bat
--   heroic_exar_gackle_bat_boss creatures.tab:5907 roll=5 columns=heroic_exar_gackle_bat
--   heroic_exar_hate_fist creatures.tab:5895 roll=25 columns=heroic_exar_hate_fist
--   heroic_exar_kun creatures.tab:5887 roll=25 columns=heroic_exar_kun
--   heroic_exar_minder creatures.tab:5902 roll=25 columns=heroic_exar_minder
--   heroic_exar_open_hand creatures.tab:5896 roll=25 columns=heroic_exar_open_hand
--   heroic_ig88_droideka creatures.tab:2167 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   heroic_ig88_ig88_rocket creatures.tab:2168 roll=7 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   heroic_ig88_normal_droideka creatures.tab:2170 roll=7 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   heroic_ig88_super_battle_droid creatures.tab:2171 roll=7 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   heroic_sd_captain_sait creatures.tab:5813 roll=15 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_sd_commander_kenkirk creatures.tab:5814 roll=15 columns=col_shattered_shard_02,col_shattered_shard_04,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_sd_krix_swiftshadow creatures.tab:5834 roll=10 columns=col_shattered_shard_02,col_shattered_shard_04,col_glass_shelving_01,col_glass_shelving_02
--   heroic_sd_stormtrooper creatures.tab:5817 roll=12 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_sd_stormtrooper_grenadier creatures.tab:5835 roll=7 columns=col_shattered_shard_02,col_shattered_shard_04,col_glass_shelving_01,col_glass_shelving_02
--   heroic_sd_stormtrooper_squad_leader creatures.tab:5836 roll=7 columns=col_shattered_shard_02,col_shattered_shard_04,col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01
--   heroic_sd_watch_captain_prat creatures.tab:5816 roll=15 columns=col_shattered_shard_01,col_shattered_shard_03,col_glass_shelving_01,col_glass_shelving_02,heroic_sd_junk
--   heroic_tusken_blood_hunter creatures.tab:2175 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_story_count_dooku_set_3,col_aurebesh_tiles,col_tusken_valuables,col_shattered_shard_02
--   heroic_tusken_king creatures.tab:2182 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_story_count_dooku_set_3,col_aurebesh_tiles,col_tusken_valuables,heroic_tusken_junk
--   heroic_tusken_raid_leader creatures.tab:2194 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_story_count_dooku_set_3,col_aurebesh_tiles,col_tusken_valuables,col_shattered_shard_02,heroic_tusken_junk
--   heroic_tusken_war_master creatures.tab:2198 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_story_count_dooku_set_3,col_aurebesh_tiles,col_tusken_valuables,col_shattered_shard_02,heroic_tusken_junk
--   heroic_tusken_warlord creatures.tab:2199 roll=7 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_story_count_dooku_set_3,col_aurebesh_tiles,col_tusken_valuables,col_shattered_shard_02,heroic_tusken_junk
--   legacy_lin34_droid creatures.tab:2639 roll=2 columns=col_holo_emitter_01
--   legacy_r3_droid creatures.tab:2648 roll=2 columns=col_holo_emitter_01
--   legacy_ra_droid creatures.tab:2649 roll=2 columns=col_holo_emitter_01
--   mand_bunker_crazed_scientist creatures.tab:2784 roll=1 columns=col_contraband_set_04
--   mand_bunker_dthwatch_gold creatures.tab:2785 roll=6 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_contraband_set_04
--   mand_bunker_medical_droid creatures.tab:2790 roll=7 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_contraband_set_04,col_holo_emitter_01
--   mand_bunker_workshop_droid creatures.tab:2794 roll=6 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_holo_emitter_01
--   meatlump_outpost_guard_donk creatures.tab:6034 roll=4 columns=col_shattered_shard_02,col_shattered_shard_03,col_contraband_set_04,col_contraband_set_01
--   meatlump_outpost_guard_dunder creatures.tab:6035 roll=4 columns=col_shattered_shard_01,col_shattered_shard_04,col_contraband_set_02,col_contraband_set_03
--   mtp_delivery_ambush_ragtag_blackjack creatures.tab:6118 roll=4 columns=col_contraband_set_01,col_contraband_set_02
--   mtp_hideout_quest_ragtag_anita_bath creatures.tab:6113 roll=7 columns=col_contraband_set_03,col_contraband_set_04
--   mtp_hideout_quest_ragtag_box_orox creatures.tab:6112 roll=7 columns=col_contraband_set_03,col_contraband_set_04
--   mtp_instance_aggro_security_droid_01 creatures.tab:6096 roll=2 columns=col_holo_emitter_01
--   mtp_instance_aggro_security_droid_02 creatures.tab:6097 roll=2 columns=col_holo_emitter_01
--   mtp_instance_blastromech creatures.tab:6092 roll=2 columns=col_holo_emitter_01
--   mtp_instance_mouse_droid creatures.tab:6091 roll=2 columns=col_holo_emitter_01
--   mtp_instance_power_droid creatures.tab:6090 roll=2 columns=col_holo_emitter_01
--   mtp_instance_r5 creatures.tab:6093 roll=2 columns=col_holo_emitter_01
--   mtp_quest_stephax_dain_high creatures.tab:6031 roll=4 columns=col_shattered_shard_02,col_shattered_shard_03,col_contraband_set_04,col_contraband_set_01
--   mtp_quest_stephax_meatlump_high creatures.tab:6029 roll=4 columns=col_shattered_shard_01,col_shattered_shard_04,col_contraband_set_03,col_contraband_set_02
--   mtp_recruiter_corsec_agent creatures.tab:6140 roll=7 columns=housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   mtp_recruiter_corsec_detective creatures.tab:6120 roll=7 columns=housing_improvement_01,housing_improvement_02,housing_improvement_03,housing_improvement_04,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   mtp_recruiter_corsec_investigator creatures.tab:6121 roll=7 columns=housing_improvement_01,col_aurebesh_tiles,col_shattered_shard_01
--   naboo_beachcomber_smuggler creatures.tab:3510 roll=4 columns=col_contraband_set_01
--   naboo_pirate_butcher creatures.tab:3601 roll=4 columns=col_contraband_set_01
--   naboo_pirate_mugger creatures.tab:3605 roll=4 columns=col_contraband_set_01
--   naboo_pirate_raider creatures.tab:3606 roll=4 columns=col_contraband_set_01
--   naboo_pirate_savage creatures.tab:3607 roll=4 columns=col_contraband_set_01
--   naboo_pirate_swashbuckler creatures.tab:3608 roll=4 columns=col_contraband_set_01
--   naboo_stonewall_labs_battle_droid_blue creatures.tab:3633 roll=2 columns=col_holo_emitter_01
--   naboo_stonewall_labs_battle_droid_green creatures.tab:3634 roll=2 columns=col_holo_emitter_01
--   naboo_stonewall_labs_battle_droid_yellow creatures.tab:3635 roll=2 columns=col_holo_emitter_01
--   naboo_ultragungan_blastromech creatures.tab:3658 roll=2 columns=col_holo_emitter_01
--   naboo_ultragungan_flawed_battle_droid creatures.tab:3660 roll=2 columns=col_holo_emitter_01
--   nightsister_sentinal creatures.tab:3716 roll=4 columns=col_nightsister_valuables,col_sith_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   nym_goodie_dispenser creatures.tab:3854 roll=6 columns=col_shattered_shard_02
--   peko_peko_albatross_high creatures.tab:3927 roll=7 columns=col_feather_peko_peko
--   rebel_detainment_blastromech creatures.tab:6312 roll=2 columns=col_holo_emitter_01
--   rebel_detainment_cww89_battle_droid creatures.tab:6317 roll=2 columns=col_holo_emitter_01
--   rebel_detainment_cww89a_battle_droid creatures.tab:6320 roll=2 columns=col_holo_emitter_01
--   rebel_detainment_cww89a_battle_droid_normal creatures.tab:6324 roll=2 columns=col_holo_emitter_01
--   rebel_detainment_d270_droid creatures.tab:6318 roll=2 columns=col_holo_emitter_01
--   scavenger_punk creatures.tab:5795 roll=100 columns=inv_publish_datapad_component_02
--   scavenger_thief creatures.tab:5796 roll=100 columns=inv_publish_datapad_component_03
--   scavenger_thug creatures.tab:4323 roll=100 columns=inv_publish_datapad_component_01
--   scavenger_thug_elite creatures.tab:4324 roll=100 columns=inv_publish_datapad_component_01,inv_publish_datapad_component_02,inv_publish_datapad_component_03
--   smuggler_patrol_jabba_1 creatures.tab:4570 roll=4 columns=housing_improvement_05,col_aurebesh_tiles,col_shattered_shard_03
--   som_crystal_flats_salvage_bandit_enforcer creatures.tab:4676 roll=4 columns=col_contraband_set_03,col_shattered_shard_03
--   som_crystal_flats_salvage_bandit_king creatures.tab:4677 roll=6 columns=col_contraband_set_03,col_shattered_shard_03
--   som_crystal_flats_salvage_bandit_thug creatures.tab:4678 roll=4 columns=col_contraband_set_03,col_shattered_shard_03
--   som_crystal_flats_treasure_hunter_merc creatures.tab:4680 roll=4 columns=col_contraband_set_03,col_shattered_shard_03
--   som_crystal_flats_treasure_hunter_thug creatures.tab:4681 roll=4 columns=col_contraband_set_03,col_shattered_shard_03
--   som_kenobi_ancient_guardian_droideka creatures.tab:4709 roll=4 columns=col_holo_emitter_01
--   som_kenobi_ancient_guardian_ig creatures.tab:4710 roll=4 columns=col_holo_emitter_01
--   som_kenobi_dark_jedi_minion_1 creatures.tab:4716 roll=4 columns=housing_improvement_05,col_shattered_shard_03
--   som_kenobi_dark_jedi_minion_2 creatures.tab:4717 roll=4 columns=housing_improvement_05,col_sith_holocron,col_shattered_shard_03
--   som_kenobi_dark_jedi_minion_3 creatures.tab:4718 roll=4 columns=housing_improvement_05,col_shattered_shard_03
--   som_kenobi_dark_jedi_minion_4 creatures.tab:4719 roll=4 columns=housing_improvement_05,col_sith_holocron,col_shattered_shard_03
--   som_kenobi_dark_jedi_minion_5 creatures.tab:4720 roll=4 columns=housing_improvement_05,col_shattered_shard_03
--   som_kenobi_dark_jedi_minion_mix creatures.tab:4721 roll=4 columns=housing_improvement_05,col_sith_holocron,col_shattered_shard_03
--   som_kenobi_finale_minion_melee creatures.tab:4724 roll=4 columns=housing_improvement_05,col_sith_holocron,col_shattered_shard_03
--   som_kenobi_finale_minion_mix creatures.tab:4725 roll=4 columns=housing_improvement_05,col_sith_holocron,col_shattered_shard_03
--   som_kenobi_pwwoz_pwwa creatures.tab:4731 roll=4 columns=col_sith_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   som_kenobi_pwwoz_thug_1 creatures.tab:4732 roll=4 columns=col_aurebesh_tiles,col_contraband_set_03,col_shattered_shard_03
--   som_kenobi_pwwoz_thug_2 creatures.tab:4733 roll=4 columns=col_aurebesh_tiles,col_contraband_set_03,col_shattered_shard_03
--   som_kenobi_trinity_assassin_ithorian_male creatures.tab:4744 roll=4 columns=housing_improvement_05,col_sith_holocron,col_aurebesh_tiles,col_shattered_shard_03
--   som_kenobi_trinity_assassin_nightsister_female creatures.tab:4745 roll=4 columns=housing_improvement_05,col_sith_holocron,col_aurebesh_tiles,col_shattered_shard_03
--   som_kenobi_trinity_assassin_zabrak_female creatures.tab:4746 roll=4 columns=housing_improvement_05,col_aurebesh_tiles,col_shattered_shard_03
--   spider_nightsister_crawler creatures.tab:4920 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_elder creatures.tab:4921 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   spider_nightsister_initiate creatures.tab:4922 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_protector creatures.tab:4923 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_sentinel creatures.tab:4924 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_sentry creatures.tab:4925 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_spell_weaver creatures.tab:4926 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_stalker creatures.tab:4927 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   spider_nightsister_web_dancer creatures.tab:4928 roll=4 columns=col_jedi_holocron,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_03
--   talus_nashal_binary_lifter creatures.tab:5163 roll=2 columns=col_holo_emitter_01
--   talus_nashal_power_droid creatures.tab:5172 roll=2 columns=col_holo_emitter_01
--   tatooine_wayfar_spy creatures.tab:5294 roll=50 columns=col_new_player_wayfar_spy
--   township_nightsister_aranei creatures.tab:5789 roll=6 columns=col_rancor_parts,housing_improvement_05,col_dejarik_holomonster,col_dejarik_table,col_shattered_shard_02
--   treasure_guard_droid creatures.tab:5399 roll=3 columns=col_holo_emitter_01
--   treasure_guard_jedi_boss creatures.tab:5401 roll=6 columns=housing_improvement_03,housing_improvement_04,housing_improvement_05,col_jedi_holocron,col_contraband_set_04,col_shattered_shard_02
--   treasure_guard_jedi_elder creatures.tab:5402 roll=4 columns=housing_improvement_05,col_jedi_holocron,col_aurebesh_tiles,col_shattered_shard_03
--   tusken_fort_tusken_treasure_guardian creatures.tab:5427 roll=6 columns=col_tusken_valuables,housing_improvement_01,housing_improvement_02,col_shattered_shard_01
--   tusken_raider_18 creatures.tab:5435 roll=3 columns=col_tusken_valuables,col_kill_tusken_activation_loot
--   tusken_raider_19 creatures.tab:5436 roll=3 columns=col_tusken_valuables,col_kill_tusken_activation_loot
--   tusken_raider_20 creatures.tab:5437 roll=3 columns=col_tusken_valuables,col_kill_tusken_activation_loot
--   tusken_raider_21 creatures.tab:5438 roll=3 columns=col_tusken_valuables,col_kill_tusken_activation_loot
--   tusken_raider_ambusher creatures.tab:5439 roll=7 columns=col_tusken_valuables,col_shattered_shard_02
--   tusken_raider_marauder creatures.tab:5440 roll=7 columns=col_tusken_valuables,col_shattered_shard_02
--   tusken_raider_scout_newbie creatures.tab:5441 roll=3 columns=col_tusken_valuables
--   tusken_raider_soldier creatures.tab:5442 roll=3 columns=col_tusken_valuables
--   tusken_raider_warrior creatures.tab:5443 roll=3 columns=col_tusken_valuables
--   tusken_raider_wildman creatures.tab:5444 roll=3 columns=col_tusken_valuables
--   tusken_raider_worshiper creatures.tab:5445 roll=6 columns=col_tusken_valuables,col_dejarik_holomonster,col_dejarik_table
--   tusken_raider_zealot creatures.tab:5446 roll=3 columns=col_tusken_valuables
--   u13_garyn_shiv creatures.tab:6389 roll=6 columns=housing_improvement_03,col_aurebesh_tiles,col_shattered_shard_04,col_glass_shelving_01
--   yavin_smuggler_bully_elite creatures.tab:5747 roll=4 columns=col_contraband_set_03,col_shattered_shard_03,col_glass_shelving_02
--   yavin_smuggler_henchmen_elite creatures.tab:5748 roll=4 columns=col_contraband_set_03,col_shattered_shard_03,col_glass_shelving_02
--   yavin_smuggler_member creatures.tab:5751 roll=4 columns=col_story_count_dooku_set_1,col_story_count_dooku_set_2,col_aurebesh_tiles,col_contraband_set_03,col_shattered_shard_03,col_glass_shelving_02
--   yavin_smuggler_muscle creatures.tab:5752 roll=4 columns=col_story_count_dooku_set_1,col_story_count_dooku_set_2,col_aurebesh_tiles,col_contraband_set_03,col_shattered_shard_03,col_glass_shelving_02

-- OPEN: static items in used columns that are not consume-grantable
-- (empty slot / consumeLoot=false). 29 items.
--   col_trophy_bane_back_spider_02_01
--   col_ig_88_wooden_dowel_02_01
--   col_trophy_finned_blaggart_02_01
--   col_stormtrooper_wooden_dowel_02_01
--   col_trophy_murra_blanca_02_01
--   col_trophy_mutant_acklay_02_01
--   col_trader_dom_gem_bead_02_01
--   col_trader_dom_gold_wire_02_01
--   col_trader_dom_green_bead_02_01
--   col_trader_dom_jewelry_clasp_02_01
--   col_trader_dom_gold_bead_02_01
--   col_trophy_painted_spat_02_01
--   col_trophy_scorpion_kliknik_02_01
--   col_trophy_spiketail_blurrg_02_01
--   item_heroic_backpack_tauntaun_skull_01_01
--   item_wampa_snow_globe
--   item_heroic_exar_broach_02_01
--   item_heroic_exar_excavation_toolchest_02_01
--   item_heroic_exar_artifact_crate_02_01
--   item_heroic_exar_artifact_scroll_02_01
--   item_heroic_exar_artifact_02_01
--   item_heroic_exar_gackle_bat_wing_02_01
--   item_heroic_exar_kun_ultra_rare_02_01
--   item_heroic_sd_missile_crate_02_01
--   item_heroic_sd_poison_canister_02_01
--   item_heroic_sd_pressure_pump_02_01
--   item_heroic_tusken_disabled_beacon_02_01
--   item_heroic_tusken_medic_kit_02_01
--   item_heroic_tusken_old_capacitor_02_01

-- Duplicate display names that map to the SAME slot (resolved).
--   object/tangible/collection/reward/col_reward_feather_duster.iff name=A Feather Duster slot=(empty) col_reward_feather_duster_02_01,col_reward_feather_duster_02_02,col_reward_feather_duster_02_03,col_reward_feather_duster_02_04,col_reward_feather_duster_02_05
--   object/tangible/loot/generic_usable/generic_storage_increase.iff name=A Crate for Increased Building Storage slot=(empty) item_storage_increase_05_03,item_storage_increase_05_04

-- OPEN (resolved by choice, not by guess): duplicate display names on a
-- shared template that map to different slots. slotOf returns those slots
-- joined with `|` (consume_loot.java:216 multi-slot form). onUse offers
-- still-open collections via collection_list_title / collection_list_prompt;
-- one still-open entry fills without asking (onUse #avail == 1 ->
-- confirmConsume).
--   object/tangible/loot/creature_loot/collections/jedi_holocron_01.iff name=Strange Jedi Holocron 1/5 item_collection_jedi_holocron_01_01=inv_holocron_collection_01:jedi_holocron_01_01,item_collection_jedi_holocron_02_01=inv_holocron_collection_02:jedi_holocron_02_01
--   object/tangible/loot/creature_loot/collections/jedi_holocron_01.iff name=Strange Jedi Holocron 2/5 item_collection_jedi_holocron_01_02=inv_holocron_collection_01:jedi_holocron_01_02,item_collection_jedi_holocron_02_02=inv_holocron_collection_02:jedi_holocron_02_02
--   object/tangible/loot/creature_loot/collections/jedi_holocron_01.iff name=Strange Jedi Holocron 3/5 item_collection_jedi_holocron_01_03=inv_holocron_collection_01:jedi_holocron_01_03,item_collection_jedi_holocron_02_03=inv_holocron_collection_02:jedi_holocron_02_03
--   object/tangible/loot/creature_loot/collections/jedi_holocron_01.iff name=Strange Jedi Holocron 4/5 item_collection_jedi_holocron_01_04=inv_holocron_collection_01:jedi_holocron_01_04,item_collection_jedi_holocron_02_04=inv_holocron_collection_02:jedi_holocron_02_04
--   object/tangible/loot/creature_loot/collections/jedi_holocron_01.iff name=Strange Jedi Holocron 5/5 item_collection_jedi_holocron_01_05=inv_holocron_collection_01:jedi_holocron_01_05,item_collection_jedi_holocron_02_05=inv_holocron_collection_02:jedi_holocron_02_05
--   object/tangible/loot/creature_loot/collections/sith_holocron_01.iff name=Strange Sith Holocron 1/5 item_collection_sith_holocron_01_01=inv_holocron_collection_01:sith_holocron_01_01,item_collection_sith_holocron_02_01=inv_holocron_collection_02:sith_holocron_02_01
--   object/tangible/loot/creature_loot/collections/sith_holocron_01.iff name=Strange Sith Holocron 2/5 item_collection_sith_holocron_01_02=inv_holocron_collection_01:sith_holocron_01_02,item_collection_sith_holocron_02_02=inv_holocron_collection_02:sith_holocron_02_02
--   object/tangible/loot/creature_loot/collections/sith_holocron_01.iff name=Strange Sith Holocron 3/5 item_collection_sith_holocron_01_03=inv_holocron_collection_01:sith_holocron_01_03,item_collection_sith_holocron_02_03=inv_holocron_collection_02:sith_holocron_02_03
--   object/tangible/loot/creature_loot/collections/sith_holocron_01.iff name=Strange Sith Holocron 4/5 item_collection_sith_holocron_01_04=inv_holocron_collection_01:sith_holocron_01_04,item_collection_sith_holocron_02_04=inv_holocron_collection_02:sith_holocron_02_04
--   object/tangible/loot/creature_loot/collections/sith_holocron_01.iff name=Strange Sith Holocron 5/5 item_collection_sith_holocron_01_05=inv_holocron_collection_01:sith_holocron_01_05,item_collection_sith_holocron_02_05=inv_holocron_collection_02:sith_holocron_02_05

-- Collection lootGroups are on the 67 in-fork creature templates under mobile/.

registerScreenPlay("CollectionLoot", true)

function CollectionLoot.attachLootItemComponent(pItem)
	if (pItem == nil) then
		return
	end

	-- OURS: Core3 ObjectMenuComponent instead of consume_loot.java on the static-item script.
	SceneObject(pItem):setObjectMenuComponent("CollectionLootItemMenuComponent")
end

local function buildTemplateMap()
	local map = {}

	if (CollectionStaticItems == nil) then
		return map
	end

	for name, info in pairs(CollectionStaticItems) do
		if (info ~= nil and info.template ~= nil and info.template ~= "") then
			local template = info.template

			if (string.sub(template, -4) ~= ".iff") then
				template = template .. ".iff"
			end

			if (map[template] == nil) then
				map[template] = {}
			end

			local list = map[template]
			list[#list + 1] = {name = name, slot = info.slot or "", displayName = info.displayName or ""}
		end
	end

	return map
end

CollectionLoot.templateMap = buildTemplateMap()

function CollectionLoot:start()
	self:printAmbiguousTemplates()
end

function CollectionLoot:printAmbiguousTemplates()
	local names = {}

	for template, list in pairs(self.templateMap) do
		if (list ~= nil and #list > 1) then
			local byName = {}

			for i = 1, #list do
				local dn = list[i].displayName or ""

				if (byName[dn] == nil) then
					byName[dn] = {}
				end

				local bucket = byName[dn]
				bucket[#bucket + 1] = list[i]
			end

			for dn, rows in pairs(byName) do
				if (#rows > 1) then
					local slot = rows[1].slot or ""
					local same = true

					for j = 2, #rows do
						if ((rows[j].slot or "") ~= slot) then
							same = false
							break
						end
					end

					if (not same) then
						names[#names + 1] = {template = template, displayName = dn, rows = rows}
					end
				end
			end
		end
	end

	table.sort(names, function(a, b)
		if (a.template == b.template) then
			return a.displayName < b.displayName
		end

		return a.template < b.template
	end)

	for i = 1, #names do
		local rec = names[i]
		local parts = {}

		for j = 1, #rec.rows do
			parts[#parts + 1] = rec.rows[j].name .. "=" .. (rec.rows[j].slot or "")
		end

		print("CollectionLoot: OPEN ambiguous name " .. rec.displayName .. " on " .. rec.template .. " (" .. table.concat(parts, ", ") .. ")")
	end
end

function CollectionLoot:slotOf(pItem)
	if (pItem == nil) then
		return nil
	end

	-- OURS: Core3 has no per-object item_stats; grant path stores the slot in shared memory.
	local stored = readStringData(SceneObject(pItem):getObjectID() .. ":collection.slot")

	if (stored ~= nil and stored ~= "") then
		return stored
	end

	local template = SceneObject(pItem):getTemplateObjectPath()
	local list = self.templateMap[template]

	if (list == nil or #list == 0) then
		return nil
	end

	-- OURS: match SceneObject:getCustomObjectName() (LuaSceneObject.cpp:74) to
	-- CollectionStaticItems.displayName among rows sharing this template.
	local customName = SceneObject(pItem):getCustomObjectName()

	if (customName ~= nil and customName ~= "") then
		local matches = {}

		for i = 1, #list do
			if (list[i].displayName == customName) then
				matches[#matches + 1] = list[i]
			end
		end

		if (#matches == 1) then
			local slot = matches[1].slot

			if (slot == nil or slot == "") then
				return nil
			end

			return slot
		end

		if (#matches > 1) then
			-- OURS: shared name, different slots -> consume_loot.java:216 `a|b|c`.
			local joined = {}
			local seen = {}

			for i = 1, #matches do
				local s = matches[i].slot or ""

				if (s ~= "" and seen[s] == nil) then
					seen[s] = true
					joined[#joined + 1] = s
				end
			end

			if (#joined == 0) then
				return nil
			end

			table.sort(joined)
			return table.concat(joined, "|")
		end
	end

	if (#list == 1) then
		local slot = list[1].slot

		if (slot == nil or slot == "") then
			return nil
		end

		return slot
	end

	return nil
end

function CollectionLoot:parseSlotPairs(full)
	local out = {}

	if (full == nil or full == "") then
		return out
	end

	for part in string.gmatch(full, "[^|]+") do
		local parts = {}

		for piece in string.gmatch(part, "[^:]+") do
			parts[#parts + 1] = piece
		end

		if (#parts == 1) then
			out[#out + 1] = {collection = nil, slot = parts[1]}
		else
			local j = 1

			while (j < #parts) do
				out[#out + 1] = {collection = parts[j], slot = parts[j + 1]}
				j = j + 2
			end
		end
	end

	return out
end

function CollectionLoot:availablePairs(pPlayer, slotPairs)
	local avail = {}

	for i = 1, #slotPairs do
		local pair = slotPairs[i]

		if (pair.slot ~= nil and pair.slot ~= "") then
			local finishedCol = pair.collection ~= nil and CollectionManager.hasCompletedCollection(pPlayer, pair.collection)
			local haveSlot = CollectionManager.hasCompletedCollectionSlot(pPlayer, pair.slot)
			local prereq = CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, pair.slot)

			if ((not finishedCol) and (not haveSlot) and prereq) then
				avail[#avail + 1] = pair
			end
		end
	end

	return avail
end

function CollectionLoot:sendClosedMessage(pPlayer, slotPairs)
	if (#slotPairs == 1) then
		local pair = slotPairs[1]

		if (pair.collection ~= nil and CollectionManager.hasCompletedCollection(pPlayer, pair.collection)) then
			CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
			return
		end

		if (CollectionManager.hasCompletedCollectionSlot(pPlayer, pair.slot)) then
			CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
			return
		end
	end

	CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
end

function CollectionLoot:onUse(pPlayer, pItem)
	if (pPlayer == nil or pItem == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pItem):isASubChildOf(pPlayer) == false) then
		return
	end

	local full = self:slotOf(pItem)

	if (full == nil) then
		return
	end

	local slotPairs = self:parseSlotPairs(full)

	if (#slotPairs == 0) then
		return
	end

	local avail = self:availablePairs(pPlayer, slotPairs)

	if (#avail == 0) then
		self:sendClosedMessage(pPlayer, slotPairs)
		return
	end

	if (#avail == 1) then
		self:confirmConsume(pPlayer, pItem, avail[1])
		return
	end

	self:showCollectionList(pPlayer, pItem, avail)
end

function CollectionLoot:confirmConsume(pPlayer, pItem, pair)
	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":CollectionLoot:oid", SceneObject(pItem):getObjectID())
	writeStringData(playerID .. ":CollectionLoot:slot", pair.slot)
	writeStringData(playerID .. ":CollectionLoot:collection", pair.collection or "")

	local sui = SuiMessageBox.new("CollectionLoot", "confirmCallback")
	sui.setTitle("@collection:consume_item_title")
	sui.setPrompt("@collection:consume_item_prompt")
	sui.setTargetNetworkId(SceneObject(pItem):getObjectID())
	sui.sendTo(pPlayer)
end

function CollectionLoot:confirmCallback(pPlayer, pSui, eventIndex)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	self:finishConsume(pPlayer)
end

function CollectionLoot:showCollectionList(pPlayer, pItem, avail)
	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":CollectionLoot:oid", SceneObject(pItem):getObjectID())

	local sui = SuiListBox.new("CollectionLoot", "listCallback")
	sui.setTitle("@collection:collection_list_title")
	sui.setPrompt("@collection:collection_list_prompt")
	sui.setTargetNetworkId(SceneObject(pItem):getObjectID())
	sui.setOkButtonText("@ui:ok")

	for i = 1, #avail do
		local label = avail[i].collection

		if (label == nil or label == "") then
			label = avail[i].slot
		end

		sui.add("@collection:" .. label, avail[i].slot)
	end

	sui.sendTo(pPlayer)
end

function CollectionLoot:listCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	local selected = ""
	local row = tonumber(args)

	if (row ~= nil) then
		local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

		if (pPageData ~= nil) then
			selected = LuaSuiPageData(pPageData):getStoredData(tostring(row)) or ""
		end
	end

	if (selected == "") then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	writeStringData(playerID .. ":CollectionLoot:slot", selected)
	self:finishConsume(pPlayer)
end

function CollectionLoot:finishConsume(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = readData(playerID .. ":CollectionLoot:oid")
	local slotName = readStringData(playerID .. ":CollectionLoot:slot")
	local pItem = getSceneObject(oid)

	if (pItem == nil or slotName == nil or slotName == "") then
		return
	end

	if (SceneObject(pItem):isASubChildOf(pPlayer) == false) then
		return
	end

	if (not CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
		return
	end

	local slotInfo = CollectionManager.getCollectionSlotInfo(slotName)

	if (slotInfo ~= nil and CollectionManager.hasCompletedCollection(pPlayer, slotInfo[3])) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
		return
	end

	if (CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
		return
	end

	if (not CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:report_consume_item_fail")
		return
	end

	SceneObject(pItem):destroyObjectFromWorld()
	SceneObject(pItem):destroyObjectFromDatabase()
end

CollectionLootItemMenuComponent = { }

function CollectionLootItemMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	if (SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
		return
	end

	-- OURS: ITEM_USE radial (20) is this fork's Lua menu; java consume_loot.java:28 uses SERVER_MENU3.
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@collection:consume_item")
end

function CollectionLootItemMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	CollectionLoot:onUse(pPlayer, pSceneObject)
	return 0
end

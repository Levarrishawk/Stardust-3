
includeFile("conversations/space/default_ship_conv.lua")

-- Chassis Dealers
includeFile("conversations/space/chassis_dealer_conv.lua")

-- Space Stations
includeFile("conversations/space/spacestation_corellia.lua")
includeFile("conversations/space/spacestation_dantooine.lua")
includeFile("conversations/space/spacestation_dathomir.lua")
includeFile("conversations/space/spacestation_endor.lua")
includeFile("conversations/space/spacestation_imperial.lua")
includeFile("conversations/space/spacestation_lok.lua")
includeFile("conversations/space/spacestation_naboo.lua")
includeFile("conversations/space/spacestation_rebel.lua")
includeFile("conversations/space/spacestation_rori.lua")
includeFile("conversations/space/spacestation_talus.lua")
includeFile("conversations/space/spacestation_tatooine.lua")
includeFile("conversations/space/spacestation_yavin4.lua")

-- Kashyyyk Space Stations
includeFile("conversations/space/spacestation_kashyyyk.lua")
includeFile("conversations/space/spacestation_kash_rebel.lua")
includeFile("conversations/space/spacestation_kash_imperial.lua")
includeFile("conversations/space/spacestation_rodian_base.lua")
includeFile("conversations/space/spacestation_rodian_tripp_base.lua")
includeFile("conversations/space/spacestation_indie_slaver.lua")
includeFile("conversations/space/spacestation_avatar_platform.lua")

-- Kashyyyk comm-hailable ship givers (Civilian Protection Guild patrols).
-- These are ShipAgents, not stations: NpcConversationStartCommand.h starts a conversation with any
-- ShipAiAgent, and both agents already ship a client comm portrait.
includeFile("conversations/space/ep3_cpg_veteran.lua")
includeFile("conversations/space/ep3_cpg_ace.lua")

-- Deep Space - Kessel jump stations
includeFile("conversations/space/jumpstation_rebel.lua")
includeFile("conversations/space/jumpstation_imperial.lua")
includeFile("conversations/space/jumpstation_neutral.lua")

-- Coordinators

-- Neutral
includeFile("conversations/space/neutral/gil_burtin_convo.lua")

-- Rebel
includeFile("conversations/space/rebel/j_pai_brek_convo.lua")

-- Imperial
includeFile("conversations/space/imperial/imperial_broker_convo.lua")


-- Greeters

-- Theed
includeFile("conversations/space/greeters/kulton_woodle_convo.lua")
includeFile("conversations/space/greeters/j1_p0_convo.lua")

-- Mos Eisley
includeFile("conversations/space/greeters/vincie_kalhoon_convo.lua")
includeFile("conversations/space/greeters/mooch_davoney_convo.lua")
includeFile("conversations/space/greeters/guillo_parootchie_convo.lua")

-- Coronet
includeFile("conversations/space/greeters/io_tsomcren_convo.lua")
includeFile("conversations/space/greeters/ral_mundi_convo.lua")
includeFile("conversations/space/greeters/tarth_jaxx_convo.lua")

-- Mining Outpost, Dantooine
includeFile("conversations/space/greeters/rane_yarrow_convo.lua")
includeFile("conversations/space/greeters/fern_yarrow_convo.lua")
includeFile("conversations/space/greeters/kess_yarrow_convo.lua")

-- Neutral Pilot

-- Corsec Squadron
includeFile("conversations/space/neutral/corsec_squadron/rhea_convo.lua")
includeFile("conversations/space/neutral/corsec_squadron/rikkh_convo.lua")
includeFile("conversations/space/neutral/corsec_squadron/ramna_convo.lua")
includeFile("conversations/space/neutral/corsec_squadron/turoldine_convo.lua")

-- Kashyyyk hunting chain (ground givers for space quests registered in
-- screenplays/space/squadrons/KashyyykHuntingScreenplay.lua)
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_kerssoc_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_kara_corlon_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_tripp_rar_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_chrilooc_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_banol_starkiller_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_ziven_tissak_convo.lua")

-- Kashyyyk mining chain (ground giver for space quests registered in
-- screenplays/space/squadrons/KashyyykMiningScreenplay.lua)
includeFile("conversations/space/neutral/kashyyyk_mining/ep3_mining_captain_koh_convo.lua")

-- Kashyyyk slaver chain (ground givers for space quests registered in
-- screenplays/space/squadrons/KashyyykSlaverScreenplay.lua)
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_boshaz_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_lesnorr_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_mssikss_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_fezrik_bendledon_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_musolium_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_belga_daeri_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_kymayrr_convo.lua")
includeFile("conversations/space/neutral/kashyyyk_slaver/ep3_gursan_bryes_convo.lua")

-- Kashyyyk station chain (ground giver for space quests registered in
-- screenplays/space/squadrons/KashyyykStationScreenplay.lua)
includeFile("conversations/space/neutral/kashyyyk_station/ep3_eyma_convo.lua")

-- Kashyyyk bowcaster chain (ground giver for the space quest registered in
-- screenplays/space/squadrons/KashyyykHuntingScreenplay.lua)
includeFile("conversations/space/neutral/kashyyyk_bowcaster/ep3_wke_lolo_convo.lua")

-- Clone relics chain (ground givers for the Boba Fett space quest registered in
-- screenplays/space/squadrons/KesselDutyScreenplay.lua, and for the Jedi Starfighter space quests
-- registered in screenplays/space/squadrons/KashyyykMiningScreenplay.lua)
includeFile("conversations/space/neutral/clone_relics/ep3_clone_relics_kkrax_convo.lua")
includeFile("conversations/space/neutral/clone_relics/ep3_clone_relics_darth_vader_convo.lua")

-- Smuggler Squadron
includeFile("conversations/space/neutral/smuggler_squadron/dravis_convo.lua")

-- RSF Squadron
includeFile("conversations/space/neutral/rsf_squadron/dinge_convo.lua")
includeFile("conversations/space/neutral/rsf_squadron/kaydine_convo.lua")
includeFile("conversations/space/neutral/rsf_squadron/dulios_convo.lua")

-- Rebel Pilot

-- Crimson Phoenix Squadron
includeFile("conversations/space/rebel/crimson_phoenix_squadron/da_la_socuna_convo.lua")
--includeFile("conversations/space/rebel/crimson_phoenix_squadron/eker_convo.lua")
--includeFile("conversations/space/rebel/crimson_phoenix_squadron/ulvawop_convo.lua")
--includeFile("conversations/space/rebel/crimson_phoenix_squadron/ufwol_convo.lua")

-- Havoc Squadron (Arkon)
includeFile("conversations/space/rebel/havoc_squadron/kreezo_convo.lua")
includeFile("conversations/space/rebel/havoc_squadron/viopa_convo.lua")
includeFile("conversations/space/rebel/havoc_squadron/vrak_convo.lua")
includeFile("conversations/space/rebel/havoc_squadron/aqzow_convo.lua")
--includeFile("conversations/space/rebel/havoc_squadron/arkon_convo.lua")

-- Vortex Squadron
includeFile("conversations/space/rebel/vortex_squadron/v3_fx_convo.lua")
--includeFile("conversations/space/rebel/vortex_squadron/evin_convo.lua")
--includeFile("conversations/space/rebel/vortex_squadron/ezkiel_convo.lua")
--includeFile("conversations/space/rebel/vortex_squadron/vrovel_convo.lua")

-- Imperial Pilot

-- Black Epsilon Squadron
includeFile("conversations/space/imperial/black_epsilon_squadron/hakassha_sireen_convo.lua")

-- Imperial Inquisition Squadron
includeFile("conversations/space/imperial/inquisition_squadron/barn_sinkko_convo.lua")

-- Storm Squadron
includeFile("conversations/space/imperial/storm_squadron/akal_colzet_convo.lua")
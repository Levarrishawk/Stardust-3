-- Space Screenplays & Conversation Handlers

includeFile("space/SpaceQuestLogic.lua")
includeFile("space/SpaceAssassinateScreenplay.lua")
includeFile("space/SpaceBattleScreenplay.lua")
includeFile("space/SpaceConvoyScreenplay.lua")
includeFile("space/SpaceDeliveryScreenplay.lua")
includeFile("space/SpaceDeliveryNoPickupScreenplay.lua")
includeFile("space/SpaceDestroyScreenplay.lua")
includeFile("space/SpaceEscortScreenplay.lua")
includeFile("space/SpaceInspectScreenplay.lua")
includeFile("space/SpaceMiningDestroyScreenplay.lua")
includeFile("space/SpacePatrolScreenplay.lua")
includeFile("space/SpaceRecoveryScreenplay.lua")
includeFile("space/SpaceRescueScreenplay.lua")
includeFile("space/SpaceSurpriseAttackScreenplay.lua")
includeFile("space/SpaceSurvivalScreenplay.lua")

-- Duty Screenplays
includeFile("space/SpaceDutyDestroyScreenplay.lua")
includeFile("space/SpaceDutyEscortScreenplay.lua")
includeFile("space/SpaceDutyPatrolScreenplay.lua")
includeFile("space/SpaceDutyRecoveryScreenplay.lua")
includeFile("space/SpaceDutyRescueScreenplay.lua")

-- Master-tier Kessel Corvette encounter (defines destroy_master_{imperial,rebel}_{1,2}).
-- Must load BEFORE the squadron screenplays, which reference these master objects.
includeFile("space/squadrons/KesselMasterEncounterScreenplay.lua")

-- Kessel duty quests (Kessel System / space_light1).
includeFile("space/squadrons/KesselDutyScreenplay.lua")

includeFile("space/chassis_dealer.lua")

--[[
	Space Stations
]]

includeFile("space/spacestations/spacestation.lua")
includeFile("space/spacestations/spacestation_corellia_conv_handler.lua")
includeFile("space/spacestations/spacestation_dantooine_conv_handler.lua")
includeFile("space/spacestations/spacestation_dathomir_conv_handler.lua")
includeFile("space/spacestations/spacestation_endor_conv_handler.lua")
includeFile("space/spacestations/spacestation_imperial_conv_handler.lua")
includeFile("space/spacestations/spacestation_lok_conv_handler.lua")
includeFile("space/spacestations/spacestation_naboo_conv_handler.lua")
includeFile("space/spacestations/spacestation_rebel_conv_handler.lua")
includeFile("space/spacestations/spacestation_rori_conv_handler.lua")
includeFile("space/spacestations/spacestation_talus_conv_handler.lua")
includeFile("space/spacestations/spacestation_tatooine_conv_handler.lua")
includeFile("space/spacestations/spacestation_yavin4_conv_handler.lua")

-- Kashyyyk space quests. These define the quest globals the Kashyyyk station
-- conversation handlers below call :startQuest on, so they must load FIRST.
-- They also construct from SpaceConvoyScreenplay / SpaceMiningDestroyScreenplay,
-- which are included in the base-class block at the top of this file.
includeFile("space/squadrons/KashyyykStationScreenplay.lua")
includeFile("space/squadrons/KashyyykHuntingScreenplay.lua")
includeFile("space/squadrons/KashyyykSlaverScreenplay.lua")
includeFile("space/squadrons/KashyyykMiningScreenplay.lua")

-- Kashyyyk space stations
includeFile("space/spacestations/spacestation_kashyyyk_conv_handler.lua")
includeFile("space/spacestations/spacestation_kash_rebel_conv_handler.lua")
includeFile("space/spacestations/spacestation_kash_imperial_conv_handler.lua")
includeFile("space/spacestations/spacestation_rodian_base_conv_handler.lua")
includeFile("space/spacestations/spacestation_rodian_tripp_base_conv_handler.lua")
includeFile("space/spacestations/spacestation_indie_slaver_conv_handler.lua")
includeFile("space/spacestations/spacestation_avatar_platform_conv_handler.lua")

-- Deep Space - Kessel jump stations (prestige-gated Deep Space access)
includeFile("space/spacestations/deep_space_jump.lua")
includeFile("space/spacestations/jumpstation_rebel_conv_handler.lua")
includeFile("space/spacestations/jumpstation_imperial_conv_handler.lua")
includeFile("space/spacestations/jumpstation_neutral_conv_handler.lua")


--[[
	Ship Components
]]

includeFile("space/ship_components/escape_pod_hatch_menu_component.lua")
includeFile("space/ship_components/pilot_seat_menu_component.lua")
includeFile("space/ship_components/ship_operations_menu_component.lua")
includeFile("space/ship_components/ship_turret_menu_component.lua")
includeFile("space/ship_components/ship_interior_component_menu_component.lua")


--[[
	Conversation Handlers
]]

includeFile("space/conversations/defaultShipConvoHandler.lua")
includeFile("space/conversations/chassisDealerConvoHandler.lua")

-- Greeters

-- Theed
includeFile("space/conversations/greeters/kultonWoodleConvoHandler.lua")
includeFile("space/conversations/greeters/j1p0ConvoHandler.lua")

-- Mos Eisley
includeFile("space/conversations/greeters/vincieKalhoonConvoHandler.lua")
includeFile("space/conversations/greeters/moochDavoneyConvoHandler.lua")
includeFile("space/conversations/greeters/guilloParootchieConvoHandler.lua")

-- Coronet
includeFile("space/conversations/greeters/ioTsomcrenConvoHandler.lua")
includeFile("space/conversations/greeters/ralMundiConvoHandler.lua")
includeFile("space/conversations/greeters/tarthJaxxConvoHandler.lua")

-- Mining Outpost, Dantooine
includeFile("space/conversations/greeters/raneYarrowConvoHandler.lua")
includeFile("space/conversations/greeters/fernYarrowConvoHandler.lua")
includeFile("space/conversations/greeters/kessYarrowConvoHandler.lua")

-- Squadrons


-- Neutral
includeFile("space/conversations/neutral/gilBurtinConvoHandler.lua")

-- Kashyyyk CPG comm patrols (conversable ShipAiAgents, not stations).
-- Quest globals come from KashyyykStationScreenplay.lua above; the stage key
-- comes from spacestation_kashyyyk_conv_handler.lua above. Both already loaded.
includeFile("space/conversations/neutral/cpg_patrol/ep3CpgVeteranConvoHandler.lua")
includeFile("space/conversations/neutral/cpg_patrol/ep3CpgAceConvoHandler.lua")

-- Kashyyyk ground quest givers. They grant the space quests registered in
-- space/squadrons/Kashyyyk*Screenplay.lua above, so they must load after those.
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyKerssocConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyKaraCorlonConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyTrippRarConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyChriloocConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyBanolStarkillerConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_hunting/ep3EtyyyZivenTissakConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_mining/ep3MiningCaptainKohConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3BoshazConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3LesnorrConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3MssikssConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3FezrikBendledonConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3MusoliumConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3BelgaDaeriConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3KymayrrConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_slaver/ep3GursanBryesConvoHandler.lua")
includeFile("space/conversations/neutral/kashyyyk_station/ep3EymaConvoHandler.lua")

-- Kachirho bowcaster ground giver (Lolo). Grants inspect_ep3_wke_bowcaster_crafting, whose global
-- comes from space/squadrons/KashyyykHuntingScreenplay.lua above.
includeFile("space/conversations/neutral/kashyyyk_bowcaster/ep3WkeLoloConvoHandler.lua")

-- Clone Relics ground givers.
--   Kkrax grants recovery_ep3_clone_relics_boba_fett_2, which auto-chains
--   destroy_surpriseattack_ep3_clone_relics_boba_fett_3 on completion. Its quest global comes from
--   space/squadrons/KesselDutyScreenplay.lua above.
--   Darth Vader grants space_battle_ep3_clone_relics_jedi_starfighter_4, which auto-chains
--   space_battle_ep3_clone_relics_jedi_starfighter_5 on completion. Both globals come from
--   space/squadrons/KashyyykMiningScreenplay.lua above.
includeFile("space/conversations/neutral/clone_relics/ep3CloneRelicsKkraxConvoHandler.lua")
includeFile("space/conversations/neutral/clone_relics/ep3CloneRelicsDarthVaderConvoHandler.lua")

-- Corsec
includeFile("space/squadrons/CorsecSquadronScreenplay.lua")

includeFile("space/conversations/neutral/corsec_squadron/rheaConvoHandler.lua")
includeFile("space/conversations/neutral/corsec_squadron/rikkhConvoHandler.lua")
includeFile("space/conversations/neutral/corsec_squadron/ramnaConvoHandler.lua")
includeFile("space/conversations/neutral/corsec_squadron/turoldineConvoHandler.lua")

-- Smuggler Squadron
includeFile("space/squadrons/SmugglerSquadronScreenplay.lua")

includeFile("space/conversations/neutral/smuggler_squadron/dravisConvoHandler.lua")

-- RSF Squadron
includeFile("space/squadrons/RsfSquadronScreenplay.lua")

includeFile("space/conversations/neutral/rsf_squadron/dingeConvoHandler.lua")
includeFile("space/conversations/neutral/rsf_squadron/kaydineConvoHandler.lua")
includeFile("space/conversations/neutral/rsf_squadron/duliosConvoHandler.lua")


-- Rebel
includeFile("space/conversations/rebel/jPaiBrekConvoHandler.lua")

-- Crimson Phoenix Squadron
includeFile("space/squadrons/CrimsonPhoenixSquadronScreenplay.lua")

includeFile("space/conversations/rebel/crimson_phoenix_squadron/daLaSocunaConvoHandler.lua")
--includeFile("space/conversations/rebel/crimson_phoenix_squadron/ekerConvoHandler.lua")
--includeFile("space/conversations/rebel/crimson_phoenix_squadron/ulvawopConvoHandler.lua")
--includeFile("space/conversations/rebel/crimson_phoenix_squadron/ufwolConvoHandler.lua")

-- Havoc Squadron (Arkon)
includeFile("space/squadrons/HavocSquadronScreenplay.lua")

includeFile("space/conversations/rebel/havoc_squadron/kreezoConvoHandler.lua")
includeFile("space/conversations/rebel/havoc_squadron/viopaConvoHandler.lua")
includeFile("space/conversations/rebel/havoc_squadron/vrakConvoHandler.lua")
includeFile("space/conversations/rebel/havoc_squadron/aqzowConvoHandler.lua")
--includeFile("space/conversations/rebel/havoc_squadron/arkonConvoHandler.lua")

-- Vortex Squadron
includeFile("space/squadrons/VortexSquadronScreenplay.lua")

includeFile("space/conversations/rebel/vortex_squadron/v3fxConvoHandler.lua")
--includeFile("space/conversations/rebel/vortex_squadron/evinConvoHandler.lua")
--includeFile("space/conversations/rebel/vortex_squadron/ezkielConvoHandler.lua")
--includeFile("space/conversations/rebel/vortex_squadron/vrovelConvoHandler.lua")


-- Imperial
includeFile("space/conversations/imperial/imperialBrokerConvoHandler.lua")

-- Black Epsilon Squadron
includeFile("space/squadrons/BlackEpsilonSquadronScreenplay.lua")

includeFile("space/conversations/imperial/black_epsilon_squadron/hakasshaSireenConvoHandler.lua")

-- Imperial Inquisition Squadron
includeFile("space/squadrons/InquisitionSquadronScreenplay.lua")

includeFile("space/conversations/imperial/inquisition_squadron/barnSinkkoConvoHandler.lua")
includeFile("space/conversations/imperial/inquisition_squadron/barlowInquisitionConvoHandler.lua")

-- Storm Squadron
includeFile("space/squadrons/StormSquadronScreenplay.lua")

includeFile("space/conversations/imperial/storm_squadron/akalColzetConvoHandler.lua")


-- Spawning Sub Folder
includeFile("space/spawning/screenplays.lua")

SpaceKashyyykSpawner = SpaceSpawnerScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "SpaceKashyyykSpawner",

	spaceZone = "space_kashyyyk",

	shipSpawns = {
		-- Ghrag Mercenaries. The zone's primary antagonist, so they get the widest
		-- coverage and the boss/ace tiers. The Tyyyn Nebula is their home ground.
		{spawnName = "kash_ghrag_tyyyn_1", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = -3500, y = -4500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_tyyyn_1_00", "kash_ghrag_tyyyn_1_01", "kash_ghrag_tyyyn_1_02", "kash_ghrag_tyyyn_1_03", "kash_ghrag_tyyyn_1_04", "kash_ghrag_tyyyn_1_05", "kash_ghrag_tyyyn_1_06", "kash_ghrag_tyyyn_1_07"},
			shipSpawns = {"ghrag_merc_tier5", "ghrag_persuader_tier5", "ghrag_specialist_tier5", "ghrag_assassin_tier5"}
		},
		{spawnName = "kash_ghrag_tyyyn_2", spawnType = SHIP_SPAWN_SINGLE, x = -6800, z = -3900, y = -3600, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 120, maxRespawn = 320, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_tyyyn_2_00", "kash_ghrag_tyyyn_2_01", "kash_ghrag_tyyyn_2_02", "kash_ghrag_tyyyn_2_03", "kash_ghrag_tyyyn_2_04", "kash_ghrag_tyyyn_2_05", "kash_ghrag_tyyyn_2_06"},
			shipSpawns = {"ghrag_merc_tier4", "ghrag_persuader_tier4", "ghrag_specialist_tier4", "ghrag_assassin_tier4"}
		},
		{spawnName = "kash_ghrag_tyyyn_ambush_1", spawnType = SHIP_SPAWN_SQUADRON, x = -5700, z = -3100, y = -5200, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_nebula_ambush"}
		},
		{spawnName = "kash_ghrag_tyyyn_ambush_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6400, z = -2800, y = -5300, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 603, maxRespawn = 1207, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_merc_tier5"}
		},
		{spawnName = "kash_ghrag_tyyyn_traitor", spawnType = SHIP_SPAWN_SQUADRON, x = -6100, z = -4200, y = -4900, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 1800, maxRespawn = 3600, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_traitor_tier5"}
		},
		{spawnName = "kash_ghrag_tyyyn_rim_1", spawnType = SHIP_SPAWN_SINGLE, x = -7400, z = -2600, y = -2800, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 608, maxRespawn = 1209, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_tyyyn_rim_1_00", "kash_ghrag_tyyyn_rim_1_01", "kash_ghrag_tyyyn_rim_1_02", "kash_ghrag_tyyyn_rim_1_03", "kash_ghrag_tyyyn_rim_1_04", "kash_ghrag_tyyyn_rim_1_05", "kash_ghrag_tyyyn_rim_1_06"},
			shipSpawns = {"ghrag_merc_tier4", "ghrag_merc_tier5", "ghrag_persuader_tier5", "ghrag_avenger_tier4"}
		},
		{spawnName = "kash_ghrag_deep_south_1", spawnType = SHIP_SPAWN_SINGLE, x = -3000, z = -6200, y = -6400, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1206, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_deep_south_1_00", "kash_ghrag_deep_south_1_01", "kash_ghrag_deep_south_1_02", "kash_ghrag_deep_south_1_03", "kash_ghrag_deep_south_1_04", "kash_ghrag_deep_south_1_05", "kash_ghrag_deep_south_1_06"},
			shipSpawns = {"ghrag_merc_tier5", "ghrag_specialist_tier5", "ghrag_assassin_tier5", "ghrag_avenger_tier5"}
		},
		{spawnName = "kash_ghrag_belt_raid_1", spawnType = SHIP_SPAWN_SQUADRON, x = 3340, z = 2308, y = 3473, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 606, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_avenger_tier5"}
		},
		{spawnName = "kash_ghrag_belt_raid_2", spawnType = SHIP_SPAWN_SQUADRON, x = 3011, z = 1962, y = 4304, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 607, maxRespawn = 1211, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_assassin_tier5"}
		},
		{spawnName = "kash_ghrag_station_approach", spawnType = SHIP_SPAWN_SQUADRON, x = -4400, z = 600, y = -4300, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 768, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_avenger_tier4"}
		},
		{spawnName = "kash_ghrag_station_ambush", spawnType = SHIP_SPAWN_SQUADRON, x = -5600, z = -200, y = -5700, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 602, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 768, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_merc_tier5"}
		},
		{spawnName = "kash_ghrag_north_1", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 4800, y = -2000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1213, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_north_1_00", "kash_ghrag_north_1_01", "kash_ghrag_north_1_02", "kash_ghrag_north_1_03", "kash_ghrag_north_1_04", "kash_ghrag_north_1_05", "kash_ghrag_north_1_06"},
			shipSpawns = {"ghrag_merc_tier3", "ghrag_persuader_tier3", "ghrag_specialist_tier3"}
		},
		{spawnName = "kash_ghrag_east_1", spawnType = SHIP_SPAWN_SINGLE, x = 5600, z = -1200, y = 1400, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1208, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_east_1_00", "kash_ghrag_east_1_01", "kash_ghrag_east_1_02", "kash_ghrag_east_1_03", "kash_ghrag_east_1_04", "kash_ghrag_east_1_05", "kash_ghrag_east_1_06"},
			shipSpawns = {"ghrag_merc_tier4", "ghrag_persuader_tier4", "ghrag_specialist_tier4"}
		},
		{spawnName = "kash_ghrag_west_1", spawnType = SHIP_SPAWN_SINGLE, x = -7200, z = 1500, y = -1200, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 610, maxRespawn = 1212, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_west_1_00", "kash_ghrag_west_1_01", "kash_ghrag_west_1_02", "kash_ghrag_west_1_03", "kash_ghrag_west_1_04", "kash_ghrag_west_1_05", "kash_ghrag_west_1_06"},
			shipSpawns = {"ghrag_merc_tier5", "ghrag_persuader_tier5", "ghrag_avenger_tier5"}
		},
		{spawnName = "kash_ghrag_methane_1", spawnType = SHIP_SPAWN_SQUADRON, x = -824, z = -2002, y = -999, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 604, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 384, totalSpawns = 1,
			shipSpawns = {"squad_kash_ghrag_merc_tier3"}
		},
		{spawnName = "kash_ghrag_corridor_1", spawnType = SHIP_SPAWN_SINGLE, x = 2200, z = -3400, y = -5600, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1214, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_ghrag_corridor_1_00", "kash_ghrag_corridor_1_01", "kash_ghrag_corridor_1_02", "kash_ghrag_corridor_1_03", "kash_ghrag_corridor_1_04", "kash_ghrag_corridor_1_05", "kash_ghrag_corridor_1_06"},
			shipSpawns = {"ghrag_merc_tier3", "ghrag_merc_tier4", "ghrag_specialist_tier4", "ghrag_persuader_tier3"}
		},

		-- Gotal Pirates, anchored on The Gotal Pirates' Base (-5950, 2700, 4575).
		{spawnName = "kash_gotal_base_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -5950, z = 2700, y = 4575, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 100, maxPatrol = 600, totalSpawns = 6,
			shipSpawns = {"gotal_bandit_tier5", "gotal_bandit_tier4", "gotal_warlord_tier4"}
		},
		{spawnName = "kash_gotal_base_patrol_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6100, z = 2900, y = 4400, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_gotal_warlord_tier5"}
		},
		{spawnName = "kash_gotal_base_approach", spawnType = SHIP_SPAWN_SINGLE, x = -5100, z = 3400, y = 5400, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1206, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_gotal_base_approach_00", "kash_gotal_base_approach_01", "kash_gotal_base_approach_02", "kash_gotal_base_approach_03", "kash_gotal_base_approach_04", "kash_gotal_base_approach_05", "kash_gotal_base_approach_06"},
			shipSpawns = {"gotal_bandit_tier4", "gotal_bandit_tier5", "gotal_warlord_tier4"}
		},
		{spawnName = "kash_gotal_raid_1", spawnType = SHIP_SPAWN_SQUADRON, x = -3800, z = 3600, y = 5900, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 603, maxRespawn = 1203, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_gotal_bandit_tier4"}
		},
		{spawnName = "kash_gotal_raid_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6900, z = 3900, y = 2900, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 606, maxRespawn = 1207, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_gotal_bandit_tier5"}
		},
		{spawnName = "kash_gotal_outer_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -4200, z = 1900, y = 6600, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 608, maxRespawn = 1210, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_gotal_outer_patrol_1_00", "kash_gotal_outer_patrol_1_01", "kash_gotal_outer_patrol_1_02", "kash_gotal_outer_patrol_1_03", "kash_gotal_outer_patrol_1_04", "kash_gotal_outer_patrol_1_05", "kash_gotal_outer_patrol_1_06"},
			shipSpawns = {"gotal_bandit_tier3", "gotal_bandit_tier4"}
		},
		{spawnName = "kash_gotal_belt_raid", spawnType = SHIP_SPAWN_SQUADRON, x = -5951, z = -14, y = 1034, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 604, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 384, totalSpawns = 1,
			shipSpawns = {"squad_kash_gotal_bandit_tier3"}
		},

		-- Chiss Poachers, anchored on the Chiss Poachers' Base (-6825, 763, 2065).
		{spawnName = "kash_chiss_base_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -6825, z = 763, y = 2065, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 100, maxPatrol = 600, totalSpawns = 6,
			shipSpawns = {"chiss_poacher_tier5", "chiss_poacher_tier4", "chiss_poacher_bomber_tier5"}
		},
		{spawnName = "kash_chiss_base_patrol_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6700, z = 900, y = 2200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_chiss_hunting_party"}
		},
		{spawnName = "kash_chiss_hunt_1", spawnType = SHIP_SPAWN_SINGLE, x = -5900, z = 300, y = 1300, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_chiss_hunt_1_00", "kash_chiss_hunt_1_01", "kash_chiss_hunt_1_02", "kash_chiss_hunt_1_03", "kash_chiss_hunt_1_04", "kash_chiss_hunt_1_05", "kash_chiss_hunt_1_06"},
			shipSpawns = {"chiss_poacher_tier4", "chiss_poacher_tier5", "chiss_poacher_bomber_tier4"}
		},
		{spawnName = "kash_chiss_hunt_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6100, z = -1200, y = 900, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 605, maxRespawn = 1206, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_chiss_poacher_tier4"}
		},
		{spawnName = "kash_chiss_asteroid_1", spawnType = SHIP_SPAWN_SQUADRON, x = -5951, z = -14, y = 1034, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 604, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 384, totalSpawns = 1,
			shipSpawns = {"squad_kash_chiss_poacher_tier5"}
		},
		{spawnName = "kash_chiss_settler_1", spawnType = SHIP_SPAWN_SINGLE, x = -7300, z = 1800, y = 3100, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1211, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 4,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_chiss_settler_1_00", "kash_chiss_settler_1_01", "kash_chiss_settler_1_02", "kash_chiss_settler_1_03", "kash_chiss_settler_1_04", "kash_chiss_settler_1_05", "kash_chiss_settler_1_06"},
			shipSpawns = {"chiss_poacher_settler_tier4", "chiss_poacher_tier3", "chiss_poacher_tier4"}
		},

		-- Independent Slavers, anchored on the Independent Slavers' Base (-6830, -350, 4200).
		{spawnName = "kash_slaver_base_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -6830, z = -350, y = 4200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 100, maxPatrol = 600, totalSpawns = 6,
			shipSpawns = {"trn_slaver_fighter_tier5", "trn_slaver_fighter_tier4", "trn_slaver_enforcer_tier5"}
		},
		{spawnName = "kash_slaver_base_patrol_2", spawnType = SHIP_SPAWN_SQUADRON, x = -6700, z = -500, y = 4350, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_slaver_raid_tier5"}
		},
		{spawnName = "kash_slaver_convoy_1", spawnType = SHIP_SPAWN_SQUADRON, x = -6200, z = -900, y = 5200, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_slaver_convoy_1_00", "kash_slaver_convoy_1_01", "kash_slaver_convoy_1_02", "kash_slaver_convoy_1_03", "kash_slaver_convoy_1_04", "kash_slaver_convoy_1_05", "kash_slaver_convoy_1_06", "kash_slaver_convoy_1_07"},
			shipSpawns = {"squad_kash_slaver_convoy_tier5"}
		},
		{spawnName = "kash_slaver_raid_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4700, z = -1500, y = 4900, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 603, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_slaver_raid_tier4"}
		},
		{spawnName = "kash_slaver_raid_2", spawnType = SHIP_SPAWN_SQUADRON, x = -3300, z = -800, y = 3300, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 606, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_slaver_raid_tier3"}
		},
		{spawnName = "kash_slaver_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -7500, z = -1800, y = 3000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1207, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_slaver_patrol_1_00", "kash_slaver_patrol_1_01", "kash_slaver_patrol_1_02", "kash_slaver_patrol_1_03", "kash_slaver_patrol_1_04", "kash_slaver_patrol_1_05", "kash_slaver_patrol_1_06"},
			shipSpawns = {"trn_slaver_fighter_tier4", "trn_slaver_fighter_tier5", "trn_slaver_enforcer_tier5"}
		},
		{spawnName = "kash_slaver_barge_run_1", spawnType = SHIP_SPAWN_SINGLE, x = -4600, z = -2600, y = 5900, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1215, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 4,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_slaver_barge_run_1_00", "kash_slaver_barge_run_1_01", "kash_slaver_barge_run_1_02", "kash_slaver_barge_run_1_03", "kash_slaver_barge_run_1_04", "kash_slaver_barge_run_1_05", "kash_slaver_barge_run_1_06", "kash_slaver_barge_run_1_07"},
			shipSpawns = {"trn_slaver_barge_tier3", "trn_slaver_barge_tier4", "trn_slaver_barge_tier5"}
		},

		-- Rodian Protectors. Sordaan's and Tripp's outposts sit on the far side of
		-- the asteroid belt (station_kashyyyk.stf), so their patrols work the belt.
		{spawnName = "kash_rodian_sordaan_guard_1", spawnType = SHIP_SPAWN_SINGLE, x = 2556, z = 3225, y = 3890, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 100, maxPatrol = 600, totalSpawns = 6,
			shipSpawns = {"rod_protector_tier5", "rod_protector_tier4", "rod_protector_ace_tier5"}
		},
		{spawnName = "kash_rodian_sordaan_guard_2", spawnType = SHIP_SPAWN_SQUADRON, x = 2700, z = 3100, y = 4000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_rodian_sordaan_guard"}
		},
		{spawnName = "kash_rodian_sordaan_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = 3200, z = 2800, y = 4600, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_rodian_sordaan_patrol_1_00", "kash_rodian_sordaan_patrol_1_01", "kash_rodian_sordaan_patrol_1_02", "kash_rodian_sordaan_patrol_1_03", "kash_rodian_sordaan_patrol_1_04", "kash_rodian_sordaan_patrol_1_05", "kash_rodian_sordaan_patrol_1_06", "kash_rodian_sordaan_patrol_1_07"},
			shipSpawns = {"rod_protector_tier5", "rod_protector_tier4", "rod_protector_ace_tier5"}
		},
		{spawnName = "kash_rodian_tripp_guard_1", spawnType = SHIP_SPAWN_SINGLE, x = -2618, z = 70, y = 2624, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 100, maxPatrol = 600, totalSpawns = 6,
			shipSpawns = {"rod_protector_tier4", "rod_protector_tier5", "rod_protector_tier3"}
		},
		{spawnName = "kash_rodian_tripp_guard_2", spawnType = SHIP_SPAWN_SQUADRON, x = -2500, z = 200, y = 2750, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_rodian_tripp_guard"}
		},
		{spawnName = "kash_rodian_tripp_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -2000, z = 400, y = 3200, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 607, maxRespawn = 1206, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_rodian_tripp_patrol_1_00", "kash_rodian_tripp_patrol_1_01", "kash_rodian_tripp_patrol_1_02", "kash_rodian_tripp_patrol_1_03", "kash_rodian_tripp_patrol_1_04", "kash_rodian_tripp_patrol_1_05", "kash_rodian_tripp_patrol_1_06"},
			shipSpawns = {"rod_protector_tier4", "rod_protector_tier3", "rod_protector_tier5"}
		},
		{spawnName = "kash_rodian_belt_patrol_1", spawnType = SHIP_SPAWN_SQUADRON, x = 3011, z = 1962, y = 4304, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 604, maxRespawn = 1207, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_rodian_protector_tier5"}
		},
		{spawnName = "kash_rodian_belt_patrol_2", spawnType = SHIP_SPAWN_SQUADRON, x = 3340, z = 2308, y = 3473, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 605, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_rodian_protector_tier4"}
		},

		-- Wookiee pirates working the belt, and the Wookiee resistance near the station.
		{spawnName = "kash_wke_pirate_belt_1", spawnType = SHIP_SPAWN_SQUADRON, x = -824, z = -2002, y = -999, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 606, maxRespawn = 1206, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_wookiee_pirate_tier5"}
		},
		{spawnName = "kash_wke_pirate_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = 1500, z = -1800, y = -2400, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 608, maxRespawn = 1211, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_wke_pirate_patrol_1_00", "kash_wke_pirate_patrol_1_01", "kash_wke_pirate_patrol_1_02", "kash_wke_pirate_patrol_1_03", "kash_wke_pirate_patrol_1_04", "kash_wke_pirate_patrol_1_05", "kash_wke_pirate_patrol_1_06"},
			shipSpawns = {"wke_pirate_tier3", "wke_pirate_tier4", "wke_pirate_tier5"}
		},
		{spawnName = "kash_wke_pirate_belt_2", spawnType = SHIP_SPAWN_SQUADRON, x = 2400, z = -2400, y = -3600, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 607, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_wookiee_pirate_tier3"}
		},
		{spawnName = "kash_wke_resist_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -1200, z = 1600, y = -3400, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 606, maxRespawn = 1209, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_wke_resist_patrol_1_00", "kash_wke_resist_patrol_1_01", "kash_wke_resist_patrol_1_02", "kash_wke_resist_patrol_1_03", "kash_wke_resist_patrol_1_04", "kash_wke_resist_patrol_1_05", "kash_wke_resist_patrol_1_06"},
			shipSpawns = {"wke_resist_tier4", "wke_resist_tier5", "wke_resist_tier3"}
		},
		{spawnName = "kash_wke_resist_station_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4600, z = 900, y = -4400, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 605, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 768, totalSpawns = 1,
			shipSpawns = {"squad_kash_wookiee_resist_tier5"}
		},
		{spawnName = "kash_wke_resist_south_1", spawnType = SHIP_SPAWN_SQUADRON, x = -2800, z = -4200, y = -1500, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 609, maxRespawn = 1212, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_wookiee_resist_tier4"}
		},
		-- The bowcaster-parts courier for inspect/ep3_wke_bowcaster_crafting. SpaceInspectScreenplay
		-- does not spawn its own target -- the corsec inspect target is a plain world spawn too
		-- (space_dathomir_spawner.lua:127, "corellia_privateer_tier3_2_inspect") -- so the target has
		-- to be standing in the world for the quest to be completable. Placed on the quest's own
		-- targetLocation (-1800, 500, 900) and given the same shape as the corsec entry: SINGLE,
		-- random patrol, fast respawn, one ship.
		{spawnName = "kash_wke_bowcaster_parts_inspect", spawnType = SHIP_SPAWN_SINGLE, x = -1800, z = 500, y = 900, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 45, maxRespawn = 60, minSpawnDistance = 10, maxSpawnDistance = 120, minPatrol = 200, maxPatrol = 500, totalSpawns = 1,
			shipSpawns = {"wke_resist_tier3_bowcaster_parts"}
		},

		-- Corellian Privateer Group. Aces hold the Kashyyyk Space Station; the CPG
		-- Veteran's YT-1300 works the civilian traffic lane out to the asteroid belt.
		{spawnName = "kash_cpg_station_guard_1", spawnType = SHIP_SPAWN_SINGLE, x = -5000, z = 250, y = -5000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 160, minPatrol = 150, maxPatrol = 700, totalSpawns = 6,
			shipSpawns = {"ep3_cpg_ace_tier5", "ep3_cpg_ace_tier4"}
		},
		{spawnName = "kash_cpg_station_guard_2", spawnType = SHIP_SPAWN_SQUADRON, x = -5150, z = 400, y = -4850, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 96, minPatrol = 128, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kash_cpg_station_guard"}
		},
		{spawnName = "kash_cpg_station_patrol_1", spawnType = SHIP_SPAWN_SINGLE, x = -4600, z = 700, y = -4500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 300, maxRespawn = 900, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_cpg_station_patrol_1_00", "kash_cpg_station_patrol_1_01", "kash_cpg_station_patrol_1_02", "kash_cpg_station_patrol_1_03", "kash_cpg_station_patrol_1_04", "kash_cpg_station_patrol_1_05", "kash_cpg_station_patrol_1_06", "kash_cpg_station_patrol_1_07"},
			shipSpawns = {"ep3_cpg_ace_tier5", "ep3_cpg_ace_tier4"}
		},
		{spawnName = "kash_cpg_veteran_escort_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4400, z = 600, y = -4100, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 600, maxRespawn = 1200, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_cpg_veteran_escort_1_00", "kash_cpg_veteran_escort_1_01", "kash_cpg_veteran_escort_1_02", "kash_cpg_veteran_escort_1_03", "kash_cpg_veteran_escort_1_04", "kash_cpg_veteran_escort_1_05", "kash_cpg_veteran_escort_1_06", "kash_cpg_veteran_escort_1_07"},
			shipSpawns = {"squad_kash_cpg_veteran_escort"}
		},
		{spawnName = "kash_cpg_veteran_belt_1", spawnType = SHIP_SPAWN_SQUADRON, x = 3340, z = 2308, y = 3473, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_cpg_veteran_belt"}
		},
		{spawnName = "kash_cpg_belt_patrol_2", spawnType = SHIP_SPAWN_SINGLE, x = 2400, z = 2000, y = 3800, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 606, maxRespawn = 1208, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_cpg_belt_patrol_2_00", "kash_cpg_belt_patrol_2_01", "kash_cpg_belt_patrol_2_02", "kash_cpg_belt_patrol_2_03", "kash_cpg_belt_patrol_2_04", "kash_cpg_belt_patrol_2_05", "kash_cpg_belt_patrol_2_06"},
			shipSpawns = {"ep3_cpg_ace_tier4", "ep3_cpg_veteran_tier4"}
		},
		{spawnName = "kash_cpg_tyyyn_response", spawnType = SHIP_SPAWN_SQUADRON, x = -5400, z = -2400, y = -4600, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 604, maxRespawn = 1206, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kash_cpg_ace_tier5"}
		},
		{spawnName = "kash_cpg_methane_patrol", spawnType = SHIP_SPAWN_SQUADRON, x = -824, z = -2002, y = -999, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 768, totalSpawns = 1,
			shipSpawns = {"squad_kash_cpg_ace_tier4"}
		},

		-- Civilian traffic. The scrapbook puts CPG civilian traffic through the belt,
		-- and the shipped mission text puts transports in distress in the Tyyyn Nebula.
		{spawnName = "kash_civilian_belt_traffic_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4700, z = 400, y = -4600, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 600, maxRespawn = 1200, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_civilian_belt_traffic_1_00", "kash_civilian_belt_traffic_1_01", "kash_civilian_belt_traffic_1_02", "kash_civilian_belt_traffic_1_03", "kash_civilian_belt_traffic_1_04", "kash_civilian_belt_traffic_1_05", "kash_civilian_belt_traffic_1_06", "kash_civilian_belt_traffic_1_07"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kash_civilian_belt_traffic_2", spawnType = SHIP_SPAWN_SQUADRON, x = 3340, z = 2308, y = 3473, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_civilian_belt_traffic_2_00", "kash_civilian_belt_traffic_2_01", "kash_civilian_belt_traffic_2_02", "kash_civilian_belt_traffic_2_03", "kash_civilian_belt_traffic_2_04", "kash_civilian_belt_traffic_2_05", "kash_civilian_belt_traffic_2_06"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kash_civilian_tyyyn_distress", spawnType = SHIP_SPAWN_SQUADRON, x = -6200, z = -3500, y = -4500, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 384, totalSpawns = 1,
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
	},
}

registerScreenPlay("SpaceKashyyykSpawner", true)

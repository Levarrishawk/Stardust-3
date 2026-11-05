SpaceKashyyykSpawner = SpaceSpawnerScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "SpaceKashyyykSpawner",

	spaceZone = "space_kashyyyk",

	primarySpawns = {
		{spawnName = "kashyyyk_station_star_destroyer", shipName = "star_destroyer", x = -2500, z = 250, y = -5000, minRespawn = 7200, maxRespawn = 10800},
	},

	shipSpawns = {
		-- Positions and patrol routes from DSRC space_zones/buildout/space_kashyyyk.tab.
		-- Avatar Platform defenses and Blackscale patrols
		{spawnName = "ep3_ap_turret_mine_general_05", spawnType = SHIP_SPAWN_SINGLE, x = 1582.81, z = 1014.92, y = -3608.26, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 9, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "avatar_platform_patrol_bravo", spawnType = SHIP_SPAWN_SINGLE, x = 1123.60, z = 1109.85, y = -3431.31, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 8, maxRespawn = 24, minSpawnDistance = 12, maxSpawnDistance = 64, totalSpawns = 5,
			patrolsToAssign = 8, fixedPatrolPoints = {"avatar_platform_patrol_bravo_00", "avatar_platform_patrol_bravo_01", "avatar_platform_patrol_bravo_02", "avatar_platform_patrol_bravo_03", "avatar_platform_patrol_bravo_04", "avatar_platform_patrol_bravo_05", "avatar_platform_patrol_bravo_06", "avatar_platform_patrol_bravo_07"},
			shipSpawns = {"ep3_trandoshan_fighter"}
		},
		{spawnName = "ep3_ap_turret_mine_general_01", spawnType = SHIP_SPAWN_SINGLE, x = 2581.38, z = 38.09, y = -1752.98, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 8, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier2"}
		},
		{spawnName = "ep3_ap_turret_mine_general_02", spawnType = SHIP_SPAWN_SINGLE, x = 2420.00, z = 160.65, y = -2099.43, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 9, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier4"}
		},
		{spawnName = "ep3_ap_turret_mine_general_03", spawnType = SHIP_SPAWN_SINGLE, x = 2072.57, z = 399.18, y = -2655.35, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 9, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier2"}
		},
		{spawnName = "ep3_ap_turret_mine_general_04", spawnType = SHIP_SPAWN_SINGLE, x = 1751.76, z = 603.05, y = -3080.17, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 9, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier1"}
		},
		{spawnName = "avatar_platform_patrol_alpha", spawnType = SHIP_SPAWN_SINGLE, x = 3013.94, z = 574.37, y = -3575.55, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 24, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 2,
			patrolsToAssign = 6, fixedPatrolPoints = {"avatar_platform_patrol_alpha_00", "avatar_platform_patrol_alpha_01", "avatar_platform_patrol_alpha_02", "avatar_platform_patrol_alpha_03", "avatar_platform_patrol_alpha_04", "avatar_platform_patrol_alpha_05"},
			shipSpawns = {"ep3_trandoshan_fighter"}
		},
		{spawnName = "ep3_ap_turret_mine_general_06", spawnType = SHIP_SPAWN_SINGLE, x = 2099.19, z = 926.54, y = -3693.47, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 2, maxSpawnDistance = 6, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "avatar_platform_slave_shuttles", spawnType = SHIP_SPAWN_SINGLE, x = 3208.84, z = 464.86, y = -3235.94, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 4, maxRespawn = 12, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 4, fixedPatrolPoints = {"avatar_platform_slave_shuttles_00", "avatar_platform_slave_shuttles_01", "avatar_platform_slave_shuttles_02", "avatar_platform_slave_shuttles_03"},
			shipSpawns = {"ep3_trandoshan_slave_shuttle"}
		},
		{spawnName = "ep3_ap_turret_mine_general_07", spawnType = SHIP_SPAWN_SINGLE, x = 2561.11, z = 594.74, y = -3474.23, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 2, maxSpawnDistance = 8, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier5"}
		},
		{spawnName = "ep3_ap_turret_mine_general_08", spawnType = SHIP_SPAWN_SINGLE, x = 3343.36, z = 117.68, y = -2736.41, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 2, maxSpawnDistance = 6, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier5"}
		},
		{spawnName = "ep3_ap_turret_mine_general_10", spawnType = SHIP_SPAWN_SINGLE, x = 2615.80, z = 657.73, y = -2636.31, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 10, maxRespawn = 59, minSpawnDistance = 2, maxSpawnDistance = 6, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "ep3_ap_turret_mine_general_09", spawnType = SHIP_SPAWN_SINGLE, x = 2750.33, z = 229.26, y = -2914.64, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 2, maxSpawnDistance = 6, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "ep3_trando_mosolium_blackscale_leader", spawnType = SHIP_SPAWN_SINGLE, x = 4434.92, z = -929.23, y = -4334.19, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 8, maxRespawn = 12, minSpawnDistance = 32, maxSpawnDistance = 82, totalSpawns = 1,
			minPatrol = 128, maxPatrol = 212,
			shipSpawns = {"ep3_trandoshan_blackscale_leader"}
		},
		{spawnName = "ep3_trando_mosolium_blackscale_fighters_01", spawnType = SHIP_SPAWN_SINGLE, x = 3978.30, z = -992.79, y = -4867.89, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 24, minSpawnDistance = 64, maxSpawnDistance = 92, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"ep3_trando_mosolium_blackscale_fighters_01_00", "ep3_trando_mosolium_blackscale_fighters_01_01", "ep3_trando_mosolium_blackscale_fighters_01_02", "ep3_trando_mosolium_blackscale_fighters_01_03", "ep3_trando_mosolium_blackscale_fighters_01_04"},
			shipSpawns = {"ep3_trandoshan_blackscale_fighter", "ep3_trandoshan_blackscale_fighter", "ep3_trandoshan_blackscale_bomber"}
		},
		{spawnName = "ep3_trando_mosolium_blackscale_fighters_02", spawnType = SHIP_SPAWN_SINGLE, x = 3476.56, z = -947.05, y = -5011.27, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 24, minSpawnDistance = 24, maxSpawnDistance = 48, totalSpawns = 5,
			patrolsToAssign = 4, fixedPatrolPoints = {"ep3_trando_mosolium_blackscale_fighters_02_00", "ep3_trando_mosolium_blackscale_fighters_02_01", "ep3_trando_mosolium_blackscale_fighters_02_02", "ep3_trando_mosolium_blackscale_fighters_02_03"},
			shipSpawns = {"ep3_trandoshan_blackscale_fighter", "ep3_trandoshan_blackscale_bomber", "ep3_trandoshan_blackscale_bomber"}
		},
		{spawnName = "ep3_ap_turret_mine_entrance_01", spawnType = SHIP_SPAWN_SINGLE, x = 764.92, z = 1037.63, y = -2338.45, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 22, maxRespawn = 49, minSpawnDistance = 2, maxSpawnDistance = 6, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "ep3_ap_turret_mine_entrance_03", spawnType = SHIP_SPAWN_SINGLE, x = 2002.50, z = 372.08, y = -1387.74, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 8, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier3"}
		},
		{spawnName = "ep3_ap_turret_spawner_entrance_02", spawnType = SHIP_SPAWN_SINGLE, x = 1285.68, z = 662.13, y = -1845.27, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 20, maxRespawn = 49, minSpawnDistance = 4, maxSpawnDistance = 8, totalSpawns = 1,
			minPatrol = 10, maxPatrol = 20,
			shipSpawns = {"ep3_avatar_platform_turret_mine_tier5"}
		},

		-- Imperial outpost and Overseer patrols
		{spawnName = "ep3_imperial_spacestation_tie_patrol_01", spawnType = SHIP_SPAWN_SQUADRON, x = 5266.60, z = 2340.74, y = -7402.56, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 42, minSpawnDistance = 14, maxSpawnDistance = 34, totalSpawns = 1,
			patrolsToAssign = 7, fixedPatrolPoints = {"ep3_imperial_spacestation_tie_patrol_01_00", "ep3_imperial_spacestation_tie_patrol_01_01", "ep3_imperial_spacestation_tie_patrol_01_02", "ep3_imperial_spacestation_tie_patrol_01_03", "ep3_imperial_spacestation_tie_patrol_01_04", "ep3_imperial_spacestation_tie_patrol_01_05", "ep3_imperial_spacestation_tie_patrol_01_06"},
			shipSpawns = {"squad_tie_standard_average"}
		},
		{spawnName = "ep3_imperial_spacestation_tie_patrol_basement", spawnType = SHIP_SPAWN_SQUADRON, x = 5154.84, z = 2539.87, y = -6269.54, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 15, maxRespawn = 38, minSpawnDistance = 32, maxSpawnDistance = 68, totalSpawns = 1,
			patrolsToAssign = 10, fixedPatrolPoints = {"ep3_imperial_spacestation_tie_patrol_basement_00", "ep3_imperial_spacestation_tie_patrol_basement_01", "ep3_imperial_spacestation_tie_patrol_basement_02", "ep3_imperial_spacestation_tie_patrol_basement_03", "ep3_imperial_spacestation_tie_patrol_basement_04", "ep3_imperial_spacestation_tie_patrol_basement_05", "ep3_imperial_spacestation_tie_patrol_basement_06", "ep3_imperial_spacestation_tie_patrol_basement_07", "ep3_imperial_spacestation_tie_patrol_basement_08", "ep3_imperial_spacestation_tie_patrol_basement_09"},
			shipSpawns = {"squad_tie_standard_average"}
		},
		{spawnName = "ep3_imperial_spacestation_transport_orbit", spawnType = SHIP_SPAWN_SQUADRON, x = 5547.40, z = 1986.90, y = -6293.42, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 15, maxRespawn = 42, minSpawnDistance = 12, maxSpawnDistance = 67, totalSpawns = 1,
			patrolsToAssign = 6, fixedPatrolPoints = {"ep3_imperial_spacestation_transport_orbit_00", "ep3_imperial_spacestation_transport_orbit_01", "ep3_imperial_spacestation_transport_orbit_02", "ep3_imperial_spacestation_transport_orbit_03", "ep3_imperial_spacestation_transport_orbit_04", "ep3_imperial_spacestation_transport_orbit_05"},
			shipSpawns = {"squad_civilian_traffic_light"}
		},
		{spawnName = "ep3_imperial_spacestation_tie_patrol_halo", spawnType = SHIP_SPAWN_SQUADRON, x = 5264.42, z = 1720.04, y = -6457.06, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 14, maxRespawn = 42, minSpawnDistance = 12, maxSpawnDistance = 34, totalSpawns = 1,
			patrolsToAssign = 6, fixedPatrolPoints = {"ep3_imperial_spacestation_tie_patrol_halo_00", "ep3_imperial_spacestation_tie_patrol_halo_01", "ep3_imperial_spacestation_tie_patrol_halo_02", "ep3_imperial_spacestation_tie_patrol_halo_03", "ep3_imperial_spacestation_tie_patrol_halo_04", "ep3_imperial_spacestation_tie_patrol_halo_05"},
			shipSpawns = {"squad_tie_standard_average"}
		},
		{spawnName = "ep3_imperial_overseer_squad_01", spawnType = SHIP_SPAWN_SQUADRON, x = -2737.88, z = -2565.51, y = -1063.26, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 29, minSpawnDistance = 4, maxSpawnDistance = 12, totalSpawns = 1,
			patrolsToAssign = 12, fixedPatrolPoints = {"ep3_imperial_overseer_squad_01_00", "ep3_imperial_overseer_squad_01_01", "ep3_imperial_overseer_squad_01_02", "ep3_imperial_overseer_squad_01_03", "ep3_imperial_overseer_squad_01_04", "ep3_imperial_overseer_squad_01_05", "ep3_imperial_overseer_squad_01_06", "ep3_imperial_overseer_squad_01_07", "ep3_imperial_overseer_squad_01_08", "ep3_imperial_overseer_squad_01_09", "ep3_imperial_overseer_squad_01_10", "ep3_imperial_overseer_squad_01_11"},
			shipSpawns = {"squad_tie_standard_average"}
		},
		{spawnName = "ep3_imperial_overseer_squad_01_ace", spawnType = SHIP_SPAWN_SQUADRON, x = -2737.88, z = -2565.51, y = -1063.26, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 29, minSpawnDistance = 4, maxSpawnDistance = 12, totalSpawns = 1,
			patrolsToAssign = 12, fixedPatrolPoints = {"ep3_imperial_overseer_squad_01_00", "ep3_imperial_overseer_squad_01_01", "ep3_imperial_overseer_squad_01_02", "ep3_imperial_overseer_squad_01_03", "ep3_imperial_overseer_squad_01_04", "ep3_imperial_overseer_squad_01_05", "ep3_imperial_overseer_squad_01_06", "ep3_imperial_overseer_squad_01_07", "ep3_imperial_overseer_squad_01_08", "ep3_imperial_overseer_squad_01_09", "ep3_imperial_overseer_squad_01_10", "ep3_imperial_overseer_squad_01_11"},
			shipSpawns = {"squad_tie_standard_ace"}
		},
		{spawnName = "imperial_overseer_patrol_alpha", spawnType = SHIP_SPAWN_SINGLE, x = -2545.24, z = -2480.79, y = -1237.59, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 8, maxRespawn = 14, minSpawnDistance = 4, maxSpawnDistance = 32, totalSpawns = 2,
			patrolsToAssign = 6, fixedPatrolPoints = {"imperial_overseer_patrol_alpha_00", "imperial_overseer_patrol_alpha_01", "imperial_overseer_patrol_alpha_02", "imperial_overseer_patrol_alpha_03", "imperial_overseer_patrol_alpha_04", "imperial_overseer_patrol_alpha_05"},
			shipSpawns = {"imp_tie_interceptor_tier3"}
		},

		-- Landing station and Tripp outpost traffic
		{spawnName = "ep3_tripp_base_traffic_02", spawnType = SHIP_SPAWN_SQUADRON, x = -2537.66, z = -918.70, y = 2057.76, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 9, maxRespawn = 21, minSpawnDistance = 4, maxSpawnDistance = 16, totalSpawns = 1,
			patrolsToAssign = 7, fixedPatrolPoints = {"ep3_tripp_base_traffic_02_00", "ep3_tripp_base_traffic_02_01", "ep3_tripp_base_traffic_02_02", "ep3_tripp_base_traffic_02_03", "ep3_tripp_base_traffic_02_04", "ep3_tripp_base_traffic_02_05", "ep3_tripp_base_traffic_02_06"},
			shipSpawns = {"squad_civilian_traffic_light"}
		},
		{spawnName = "ep3_tripp_base_traffic_01", spawnType = SHIP_SPAWN_SQUADRON, x = -2092.42, z = 384.07, y = 3159.80, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 6, maxRespawn = 18, minSpawnDistance = 2, maxSpawnDistance = 16, totalSpawns = 1,
			patrolsToAssign = 7, fixedPatrolPoints = {"ep3_tripp_base_traffic_01_00", "ep3_tripp_base_traffic_01_01", "ep3_tripp_base_traffic_01_02", "ep3_tripp_base_traffic_01_03", "ep3_tripp_base_traffic_01_04", "ep3_tripp_base_traffic_01_05", "ep3_tripp_base_traffic_01_06"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kashyyyk_landing_station_traffic_gamma", spawnType = SHIP_SPAWN_SINGLE, x = -4999.18, z = 176.03, y = -3629.51, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 12, maxRespawn = 24, minSpawnDistance = 21, maxSpawnDistance = 42, totalSpawns = 1,
			patrolsToAssign = 9, fixedPatrolPoints = {"kashyyyk_landing_station_traffic_gamma_00", "kashyyyk_landing_station_traffic_gamma_01", "kashyyyk_landing_station_traffic_gamma_02", "kashyyyk_landing_station_traffic_gamma_03", "kashyyyk_landing_station_traffic_gamma_04", "kashyyyk_landing_station_traffic_gamma_05", "kashyyyk_landing_station_traffic_gamma_06", "kashyyyk_landing_station_traffic_gamma_07", "kashyyyk_landing_station_traffic_gamma_08"},
			shipSpawns = {"civtransport", "civspeeder", "civilian_science_transport_tier1"}
		},
		{spawnName = "ep3_landing_traffic_asteroid_patrol_02", spawnType = SHIP_SPAWN_SQUADRON, x = -5571.16, z = 749.31, y = -5158.28, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 9, maxRespawn = 33, minSpawnDistance = 12, maxSpawnDistance = 32, totalSpawns = 2,
			patrolsToAssign = 11, fixedPatrolPoints = {"ep3_landing_traffic_asteroid_patrol_02_00", "ep3_landing_traffic_asteroid_patrol_02_01", "ep3_landing_traffic_asteroid_patrol_02_02", "ep3_landing_traffic_asteroid_patrol_02_03", "ep3_landing_traffic_asteroid_patrol_02_04", "ep3_landing_traffic_asteroid_patrol_02_05", "ep3_landing_traffic_asteroid_patrol_02_06", "ep3_landing_traffic_asteroid_patrol_02_07", "ep3_landing_traffic_asteroid_patrol_02_08", "ep3_landing_traffic_asteroid_patrol_02_09", "ep3_landing_traffic_asteroid_patrol_02_10"},
			shipSpawns = {"squad_civilian_traffic_light"}
		},
		{spawnName = "kashyyyk_landing_station_traffic_alpha", spawnType = SHIP_SPAWN_SINGLE, x = -5675.47, z = 490.74, y = -5377.12, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 6, maxRespawn = 17, minSpawnDistance = 8, maxSpawnDistance = 16, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kashyyyk_landing_station_traffic_alpha_00", "kashyyyk_landing_station_traffic_alpha_01", "kashyyyk_landing_station_traffic_alpha_02", "kashyyyk_landing_station_traffic_alpha_03", "kashyyyk_landing_station_traffic_alpha_04"},
			shipSpawns = {"civilian_science_transport_tier1"}
		},
		{spawnName = "ep3_landing_traffic_asteroid_patrol_01", spawnType = SHIP_SPAWN_SQUADRON, x = -4974.76, z = -36.62, y = -5337.81, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 6, maxRespawn = 22, minSpawnDistance = 4, maxSpawnDistance = 24, totalSpawns = 1,
			patrolsToAssign = 10, fixedPatrolPoints = {"ep3_landing_traffic_asteroid_patrol_01_00", "ep3_landing_traffic_asteroid_patrol_01_01", "ep3_landing_traffic_asteroid_patrol_01_02", "ep3_landing_traffic_asteroid_patrol_01_03", "ep3_landing_traffic_asteroid_patrol_01_04", "ep3_landing_traffic_asteroid_patrol_01_05", "ep3_landing_traffic_asteroid_patrol_01_06", "ep3_landing_traffic_asteroid_patrol_01_07", "ep3_landing_traffic_asteroid_patrol_01_08", "ep3_landing_traffic_asteroid_patrol_01_09"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kashyyyk_landing_station_traffic_bravo", spawnType = SHIP_SPAWN_SINGLE, x = -4889.07, z = 125.49, y = -5918.88, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 9, maxRespawn = 18, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 4, fixedPatrolPoints = {"kashyyyk_landing_station_traffic_bravo_00", "kashyyyk_landing_station_traffic_bravo_01", "kashyyyk_landing_station_traffic_bravo_02", "kashyyyk_landing_station_traffic_bravo_03"},
			shipSpawns = {"civtransport"}
		},

		-- Resistance flights and capital convoys
		{spawnName = "ep3_nebulon_xwing_escort", spawnType = SHIP_SPAWN_SQUADRON, x = -1248.82, z = -1332.56, y = -7311.99, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 6, maxRespawn = 19, minSpawnDistance = 4, maxSpawnDistance = 24, totalSpawns = 1,
			patrolsToAssign = 4, fixedPatrolPoints = {"ep3_nebulon_xwing_escort_00", "ep3_nebulon_xwing_escort_01", "ep3_nebulon_xwing_escort_02", "ep3_nebulon_xwing_escort_03"},
			shipSpawns = {"squad_wookiee_resistance_fighters"}
		},
		{spawnName = "ep3_wookiee_resistance_02", spawnType = SHIP_SPAWN_SINGLE, x = 4294.02, z = 33.69, y = 1297.50, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 12, maxRespawn = 32, minSpawnDistance = 69, maxSpawnDistance = 94, totalSpawns = 5,
			patrolsToAssign = 4, fixedPatrolPoints = {"ep3_wookiee_resistance_02_00", "ep3_wookiee_resistance_02_01", "ep3_wookiee_resistance_02_02", "ep3_wookiee_resistance_02_03"},
			shipSpawns = {"ep3_wookiee_resistance_fighter", "ep3_wookiee_resistance_bomber", "ep3_wookiee_resistance_bomber"}
		},
		{spawnName = "ep3_wookiee_resistance_01", spawnType = SHIP_SPAWN_SINGLE, x = 4266.91, z = 273.49, y = 1100.11, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 20, maxRespawn = 30, minSpawnDistance = 24, maxSpawnDistance = 48, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"ep3_wookiee_resistance_01_00", "ep3_wookiee_resistance_01_01", "ep3_wookiee_resistance_01_02", "ep3_wookiee_resistance_01_03", "ep3_wookiee_resistance_01_04"},
			shipSpawns = {"ep3_wookiee_resistance_fighter", "ep3_wookiee_resistance_fighter", "ep3_wookiee_resistance_bomber"}
		},
		{spawnName = "ep3_wookiee_resistance_commander", spawnType = SHIP_SPAWN_SINGLE, x = -1230.69, z = -143.80, y = 2231.67, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 12, maxRespawn = 24, minSpawnDistance = 48, maxSpawnDistance = 92, totalSpawns = 1,
			minPatrol = 128, maxPatrol = 256,
			shipSpawns = {"ep3_wookiee_resistance_commander"}
		},
		{spawnName = "collection_hiddendaggers_corvette_01", spawnType = SHIP_SPAWN_SQUADRON, x = 7109.94, z = 4366.37, y = 360.45, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 600, minSpawnDistance = 100, maxSpawnDistance = 300, totalSpawns = 2,
			patrolsToAssign = 9, fixedPatrolPoints = {"collection_hiddendaggers_corvette_01_00", "collection_hiddendaggers_corvette_01_01", "collection_hiddendaggers_corvette_01_02", "collection_hiddendaggers_corvette_01_03", "collection_hiddendaggers_corvette_01_04", "collection_hiddendaggers_corvette_01_05", "collection_hiddendaggers_corvette_01_06", "collection_hiddendaggers_corvette_01_07", "collection_hiddendaggers_corvette_01_08"},
			shipSpawns = {"squad_capital_ship_convoy_hidden_daggers"}
		},
		{spawnName = "collection_voidwing_corvette_01", spawnType = SHIP_SPAWN_SQUADRON, x = -6378.06, z = -6593.63, y = -6823.55, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 600, minSpawnDistance = 100, maxSpawnDistance = 300, totalSpawns = 2,
			patrolsToAssign = 9, fixedPatrolPoints = {"collection_voidwing_corvette_01_00", "collection_voidwing_corvette_01_01", "collection_voidwing_corvette_01_02", "collection_voidwing_corvette_01_03", "collection_voidwing_corvette_01_04", "collection_voidwing_corvette_01_05", "collection_voidwing_corvette_01_06", "collection_voidwing_corvette_01_07", "collection_voidwing_corvette_01_08"},
			shipSpawns = {"squad_capital_ship_convoy_void_wing"}
		},

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
		{spawnName = "kash_slaver_convoy_1", spawnType = SHIP_SPAWN_SQUADRON, x = -6200, z = -900, y = 5200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 900, maxRespawn = 1800, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
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
		{spawnName = "kash_wke_bowcaster_parts_inspect", spawnType = SHIP_SPAWN_SINGLE, x = 5952, z = 5432, y = -3024, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 15, maxRespawn = 45, minSpawnDistance = 32, maxSpawnDistance = 128, minPatrol = 100, maxPatrol = 400, totalSpawns = 1,
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
		{spawnName = "kash_cpg_veteran_escort_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4400, z = 600, y = -4100, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 600, maxRespawn = 1200, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
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
		{spawnName = "kash_civilian_belt_traffic_1", spawnType = SHIP_SPAWN_SQUADRON, x = -4700, z = 400, y = -4600, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 600, maxRespawn = 1200, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_civilian_belt_traffic_1_00", "kash_civilian_belt_traffic_1_01", "kash_civilian_belt_traffic_1_02", "kash_civilian_belt_traffic_1_03", "kash_civilian_belt_traffic_1_04", "kash_civilian_belt_traffic_1_05", "kash_civilian_belt_traffic_1_06", "kash_civilian_belt_traffic_1_07"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kash_civilian_belt_traffic_2", spawnType = SHIP_SPAWN_SQUADRON, x = 3340, z = 2308, y = 3473, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kash_civilian_belt_traffic_2_00", "kash_civilian_belt_traffic_2_01", "kash_civilian_belt_traffic_2_02", "kash_civilian_belt_traffic_2_03", "kash_civilian_belt_traffic_2_04", "kash_civilian_belt_traffic_2_05", "kash_civilian_belt_traffic_2_06"},
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
		{spawnName = "kash_civilian_tyyyn_distress", spawnType = SHIP_SPAWN_SQUADRON, x = -6200, z = -3500, y = -4500, patrolType = SHIP_AI_RANDOM_PATROL, minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 384, totalSpawns = 1,
			shipSpawns = {"squad_civilian_traffic_heavy"}
		},
	},
}

registerScreenPlay("SpaceKashyyykSpawner", true)

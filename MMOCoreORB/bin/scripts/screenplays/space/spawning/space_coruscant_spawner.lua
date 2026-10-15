SpaceCoruscantSpawner = SpaceSpawnerScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "SpaceCoruscantSpawner",
	spaceZone = "space_coruscant",

	-- Coordinates are x, z (height), y. The station is loaded by SpaceManager.
	-- The inner Venators' origins are 1.4 km from the station. Capital ships
	-- retain their stationary chassis and spawn in a layered defensive formation.
	primarySpawns = {
		{spawnName = "coruscant_venator_inner_port", shipName = "imperial_venator", x = -1400, z = 0, y = 0, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_venator_inner_starboard", shipName = "imperial_venator", x = 1400, z = 0, y = 0, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_venator_outer_port", shipName = "imperial_venator", x = -4200, z = 350, y = 0, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_venator_outer_starboard", shipName = "imperial_venator", x = 4200, z = 350, y = 0, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_aft_port", shipName = "star_destroyer", x = -2000, z = 400, y = -3600, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_aft_starboard", shipName = "star_destroyer", x = 2000, z = 400, y = -3600, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_forward_port", shipName = "star_destroyer", x = -2000, z = 400, y = 3600, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_forward_starboard", shipName = "star_destroyer", x = 2000, z = 400, y = 3600, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_flank_port", shipName = "star_destroyer", x = -5400, z = 400, y = 3600, minRespawn = 1800, maxRespawn = 3600},
		{spawnName = "coruscant_isd_flank_starboard", shipName = "star_destroyer", x = 5400, z = 400, y = 3600, minRespawn = 1800, maxRespawn = 3600},
	},

	shipSpawns = {
		-- Inner orbital security, above the capital-ship decks.
		{spawnName = "coruscant_security_inner_north", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 2200, y = 2400, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 45, maxRespawn = 90, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_interceptor_tier5", "imp_tie_advanced_tier5"}
		},
		{spawnName = "coruscant_security_inner_south", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 2200, y = -2400, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 45, maxRespawn = 90, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_interceptor_tier5", "imp_tie_bomber_tier5"}
		},
		{spawnName = "coruscant_security_inner_west", spawnType = SHIP_SPAWN_SINGLE, x = -3000, z = 2200, y = 0, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 45, maxRespawn = 90, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5", "imp_tie_aggressor_tier5"}
		},
		{spawnName = "coruscant_security_inner_east", spawnType = SHIP_SPAWN_SINGLE, x = 3000, z = 2200, y = 0, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 45, maxRespawn = 90, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_advanced_tier5", "imp_tie_oppressor_tier5"}
		},
		-- Outer checkpoints, including all quadrants and the vertical approaches.
		{spawnName = "coruscant_security_northwest", spawnType = SHIP_SPAWN_SINGLE, x = -6000, z = 3200, y = 6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier4", "imp_tie_interceptor_tier5", "imp_tie_bomber_tier4"}
		},
		{spawnName = "coruscant_security_northeast", spawnType = SHIP_SPAWN_SINGLE, x = 6000, z = 3200, y = 6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_interceptor_tier4", "imp_tie_advanced_tier4"}
		},
		{spawnName = "coruscant_security_southwest", spawnType = SHIP_SPAWN_SINGLE, x = -6000, z = 3200, y = -6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier4", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier4"}
		},
		{spawnName = "coruscant_security_southeast", spawnType = SHIP_SPAWN_SINGLE, x = 6000, z = 3200, y = -6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_bomber_tier4", "imp_tie_oppressor_tier4"}
		},
		{spawnName = "coruscant_security_west", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = 3200, y = 0, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_interceptor_tier5", "imp_tie_advanced_tier5", "imp_tie_fighter_tier4"}
		},
		{spawnName = "coruscant_security_east", spawnType = SHIP_SPAWN_SINGLE, x = 6200, z = 3200, y = 0, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_interceptor_tier4", "imp_tie_oppressor_tier5", "imp_tie_fighter_tier5"}
		},
		{spawnName = "coruscant_security_north", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 3200, y = 6200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_interceptor_tier5", "imp_tie_bomber_tier5"}
		},
		{spawnName = "coruscant_security_south", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 3200, y = -6200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier4", "imp_tie_interceptor_tier5", "imp_tie_advanced_tier5"}
		},
		{spawnName = "coruscant_security_upper_west", spawnType = SHIP_SPAWN_SINGLE, x = -3200, z = 4500, y = 3200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_interceptor_tier5", "imp_tie_advanced_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "coruscant_security_upper_east", spawnType = SHIP_SPAWN_SINGLE, x = 3200, z = 4500, y = -3200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_bomber_tier5", "imp_tie_interceptor_tier5"}
		},
		{spawnName = "coruscant_security_lower_west", spawnType = SHIP_SPAWN_SINGLE, x = -3200, z = -4600, y = -3200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier4", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5"}
		},
		{spawnName = "coruscant_security_lower_east", spawnType = SHIP_SPAWN_SINGLE, x = 3200, z = -4600, y = 3200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, minPatrol = 400, maxPatrol = 850, totalSpawns = 6,
			shipSpawns = {"imp_tie_fighter_tier5", "imp_tie_advanced_tier4", "imp_tie_oppressor_tier5"}
		},
		-- Six-ship gunboat-led response wings use the existing Imperial squadrons.
		{spawnName = "coruscant_response_west_north", spawnType = SHIP_SPAWN_SQUADRON, x = -6000, z = 1800, y = 2800, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier5_patrol_01"}},
		{spawnName = "coruscant_response_west_south", spawnType = SHIP_SPAWN_SQUADRON, x = -6000, z = 1800, y = -2800, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier5_patrol_02"}},
		{spawnName = "coruscant_response_east_north", spawnType = SHIP_SPAWN_SQUADRON, x = 6000, z = 1800, y = 2800, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier5_patrol_01"}},
		{spawnName = "coruscant_response_east_south", spawnType = SHIP_SPAWN_SQUADRON, x = 6000, z = 1800, y = -2800, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier5_patrol_02"}},
		{spawnName = "coruscant_response_north_west", spawnType = SHIP_SPAWN_SQUADRON, x = -2800, z = 1800, y = 6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier4_patrol_01"}},
		{spawnName = "coruscant_response_north_east", spawnType = SHIP_SPAWN_SQUADRON, x = 2800, z = 1800, y = 6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier4_patrol_02"}},
		{spawnName = "coruscant_response_south_west", spawnType = SHIP_SPAWN_SQUADRON, x = -2800, z = 1800, y = -6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier4_patrol_01"}},
		{spawnName = "coruscant_response_south_east", spawnType = SHIP_SPAWN_SQUADRON, x = 2800, z = 1800, y = -6000, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 120, maxRespawn = 240, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 500, maxPatrol = 900, totalSpawns = 1, shipSpawns = {"squad_imperial_tier4_patrol_02"}},
		-- Civilian lanes run below the fleet, with crossing lanes at another height.
		{spawnName = "coruscant_civilian_eastwest_1", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = -1600, y = -6000, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_1_00", "coruscant_eastwest_1_01", "coruscant_eastwest_1_02", "coruscant_eastwest_1_03", "coruscant_eastwest_1_04", "coruscant_eastwest_1_05", "coruscant_eastwest_1_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_eastwest_2", spawnType = SHIP_SPAWN_SINGLE, x = 6200, z = -1600, y = -3600, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_2_00", "coruscant_eastwest_2_01", "coruscant_eastwest_2_02", "coruscant_eastwest_2_03", "coruscant_eastwest_2_04", "coruscant_eastwest_2_05", "coruscant_eastwest_2_06"},
			shipSpawns = {"freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_eastwest_3", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = -1600, y = -1200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_3_00", "coruscant_eastwest_3_01", "coruscant_eastwest_3_02", "coruscant_eastwest_3_03", "coruscant_eastwest_3_04", "coruscant_eastwest_3_05", "coruscant_eastwest_3_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_eastwest_4", spawnType = SHIP_SPAWN_SINGLE, x = 6200, z = -1600, y = 1200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_4_00", "coruscant_eastwest_4_01", "coruscant_eastwest_4_02", "coruscant_eastwest_4_03", "coruscant_eastwest_4_04", "coruscant_eastwest_4_05", "coruscant_eastwest_4_06"},
			shipSpawns = {"freighterlight_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_eastwest_5", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = -1600, y = 3600, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_5_00", "coruscant_eastwest_5_01", "coruscant_eastwest_5_02", "coruscant_eastwest_5_03", "coruscant_eastwest_5_04", "coruscant_eastwest_5_05", "coruscant_eastwest_5_06"},
			shipSpawns = {"freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_eastwest_6", spawnType = SHIP_SPAWN_SINGLE, x = 6200, z = -1600, y = 6000, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_eastwest_6_00", "coruscant_eastwest_6_01", "coruscant_eastwest_6_02", "coruscant_eastwest_6_03", "coruscant_eastwest_6_04", "coruscant_eastwest_6_05", "coruscant_eastwest_6_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_1", spawnType = SHIP_SPAWN_SINGLE, x = -6000, z = -2800, y = -6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_1_00", "coruscant_northsouth_1_01", "coruscant_northsouth_1_02", "coruscant_northsouth_1_03", "coruscant_northsouth_1_04", "coruscant_northsouth_1_05", "coruscant_northsouth_1_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_2", spawnType = SHIP_SPAWN_SINGLE, x = -3600, z = -2800, y = 6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_2_00", "coruscant_northsouth_2_01", "coruscant_northsouth_2_02", "coruscant_northsouth_2_03", "coruscant_northsouth_2_04", "coruscant_northsouth_2_05", "coruscant_northsouth_2_06"},
			shipSpawns = {"freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_3", spawnType = SHIP_SPAWN_SINGLE, x = -1200, z = -2800, y = -6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_3_00", "coruscant_northsouth_3_01", "coruscant_northsouth_3_02", "coruscant_northsouth_3_03", "coruscant_northsouth_3_04", "coruscant_northsouth_3_05", "coruscant_northsouth_3_06"},
			shipSpawns = {"freighterlight_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_4", spawnType = SHIP_SPAWN_SINGLE, x = 1200, z = -2800, y = 6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_4_00", "coruscant_northsouth_4_01", "coruscant_northsouth_4_02", "coruscant_northsouth_4_03", "coruscant_northsouth_4_04", "coruscant_northsouth_4_05", "coruscant_northsouth_4_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_5", spawnType = SHIP_SPAWN_SINGLE, x = 3600, z = -2800, y = -6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_5_00", "coruscant_northsouth_5_01", "coruscant_northsouth_5_02", "coruscant_northsouth_5_03", "coruscant_northsouth_5_04", "coruscant_northsouth_5_05", "coruscant_northsouth_5_06"},
			shipSpawns = {"freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		{spawnName = "coruscant_civilian_northsouth_6", spawnType = SHIP_SPAWN_SINGLE, x = 6000, z = -2800, y = 6200, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 60, maxRespawn = 120, minSpawnDistance = 100, maxSpawnDistance = 250, totalSpawns = 5, patrolsToAssign = 7,
			fixedPatrolPoints = {"coruscant_northsouth_6_00", "coruscant_northsouth_6_01", "coruscant_northsouth_6_02", "coruscant_northsouth_6_03", "coruscant_northsouth_6_04", "coruscant_northsouth_6_05", "coruscant_northsouth_6_06"},
			shipSpawns = {"freighterlight_tier1", "freightermedium_tier1", "freighterheavy_tier1", "civilian_science_transport_tier1"}
		},
		-- Military couriers and logistics shuttles circulate above the fleet.
		{spawnName = "coruscant_logistics_northwest", spawnType = SHIP_SPAWN_SINGLE, x = -3200, z = 1900, y = 2200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 90, maxRespawn = 180, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 250, maxPatrol = 600, totalSpawns = 3, shipSpawns = {"imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier5"}},
		{spawnName = "coruscant_logistics_northeast", spawnType = SHIP_SPAWN_SINGLE, x = 3200, z = 1900, y = 2200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 90, maxRespawn = 180, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 250, maxPatrol = 600, totalSpawns = 3, shipSpawns = {"imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier5"}},
		{spawnName = "coruscant_logistics_southwest", spawnType = SHIP_SPAWN_SINGLE, x = -3200, z = 1900, y = -2200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 90, maxRespawn = 180, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 250, maxPatrol = 600, totalSpawns = 3, shipSpawns = {"imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier5"}},
		{spawnName = "coruscant_logistics_southeast", spawnType = SHIP_SPAWN_SINGLE, x = 3200, z = 1900, y = -2200, patrolType = SHIP_AI_GUARD_PATROL, minRespawn = 90, maxRespawn = 180, minSpawnDistance = 100, maxSpawnDistance = 200, minPatrol = 250, maxPatrol = 600, totalSpawns = 3, shipSpawns = {"imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier5"}},
	},
}

registerScreenPlay("SpaceCoruscantSpawner", true)

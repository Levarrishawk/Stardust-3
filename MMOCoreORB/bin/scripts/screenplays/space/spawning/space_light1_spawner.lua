SpaceLight1Spawner = SpaceSpawnerScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "SpaceLight1Spawner",

	spaceZone = "space_light1",

	primarySpawns = {
	},

	shipSpawns = {
		{spawnName = "rebel_tier5Patrol_12", spawnType = SHIP_SPAWN_SINGLE, x = -3199, z = -6013, y = 5343, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_12_00", "rebel_tier5Patrol_12_01", "rebel_tier5Patrol_12_02", "rebel_tier5Patrol_12_03", "rebel_tier5Patrol_12_04", "rebel_tier5Patrol_12_05", "rebel_tier5Patrol_12_06", "rebel_tier5Patrol_12_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_12", spawnType = SHIP_SPAWN_SINGLE, x = -2448, z = 6000, y = -864, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_12_00", "imperial_tier5Patrol_12_01", "imperial_tier5Patrol_12_02", "imperial_tier5Patrol_12_03", "imperial_tier5Patrol_12_04", "imperial_tier5Patrol_12_05", "imperial_tier5Patrol_12_06", "imperial_tier5Patrol_12_07"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_11", spawnType = SHIP_SPAWN_SINGLE, x = 6000, z = -2058, y = -2060, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_11_00", "imperial_tier5Patrol_11_01", "imperial_tier5Patrol_11_02", "imperial_tier5Patrol_11_03", "imperial_tier5Patrol_11_04", "imperial_tier5Patrol_11_05", "imperial_tier5Patrol_11_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_09", spawnType = SHIP_SPAWN_SINGLE, x = -2763, z = -2983, y = -6000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_09_00", "rebel_tier5Patrol_09_01", "rebel_tier5Patrol_09_02", "rebel_tier5Patrol_09_03", "rebel_tier5Patrol_09_04", "rebel_tier5Patrol_09_05", "rebel_tier5Patrol_09_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_follow_reb_01", spawnType = SHIP_SPAWN_SQUADRON, x = -4338, z = -4211, y = -2065, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 603, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_reb_01_00", "kessel_lootship_follow_reb_01_01", "kessel_lootship_follow_reb_01_02", "kessel_lootship_follow_reb_01_03", "kessel_lootship_follow_reb_01_04", "kessel_lootship_follow_reb_01_05"},
			shipSpawns = {"squad_kessel_lootship_w2_reb"}
		},
		{spawnName = "rebel_tier5Patrol_05", spawnType = SHIP_SPAWN_SINGLE, x = -4400, z = -4200, y = -2100, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1202, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_05_00", "rebel_tier5Patrol_05_01", "rebel_tier5Patrol_05_02", "rebel_tier5Patrol_05_03", "rebel_tier5Patrol_05_04", "rebel_tier5Patrol_05_05", "rebel_tier5Patrol_05_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_imp_01", spawnType = SHIP_SPAWN_SQUADRON, x = -4933, z = -1457, y = -3966, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "rebel_tier5Patrol_10", spawnType = SHIP_SPAWN_SINGLE, x = -6000, z = 6000, y = -5999, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_10_00", "rebel_tier5Patrol_10_01", "rebel_tier5Patrol_10_02", "rebel_tier5Patrol_10_03", "rebel_tier5Patrol_10_04", "rebel_tier5Patrol_10_05", "rebel_tier5Patrol_10_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_01", spawnType = SHIP_SPAWN_SINGLE, x = -6200, z = 5800, y = -6800, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 590, maxRespawn = 1215, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_01_00", "rebel_tier5Patrol_01_01", "rebel_tier5Patrol_01_02", "rebel_tier5Patrol_01_03", "rebel_tier5Patrol_01_04", "rebel_tier5Patrol_01_05", "rebel_tier5Patrol_01_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_derelict_reb", spawnType = SHIP_SPAWN_SQUADRON, x = -4951, z = 2514, y = -6009, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 603, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 63, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w1_reb"}
		},
		{spawnName = "corvette_convoy_rebel", spawnType = SHIP_SPAWN_SQUADRON, x = 7479, z = -7520, y = -7482, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 1200, maxRespawn = 2400, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"corvette_convoy_rebel_00", "corvette_convoy_rebel_01", "corvette_convoy_rebel_02", "corvette_convoy_rebel_03", "corvette_convoy_rebel_04", "corvette_convoy_rebel_05", "corvette_convoy_rebel_06", "corvette_convoy_rebel_07", "corvette_convoy_rebel_08", "corvette_convoy_rebel_09", "corvette_convoy_rebel_10"},
			shipSpawns = {"squad_corvette_convoy_reb"}
		},
		{spawnName = "rebel_tier5Patrol_03", spawnType = SHIP_SPAWN_SINGLE, x = 6500, z = 0, y = -7000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1209, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_03_00", "rebel_tier5Patrol_03_01", "rebel_tier5Patrol_03_02", "rebel_tier5Patrol_03_03", "rebel_tier5Patrol_03_04", "rebel_tier5Patrol_03_05", "rebel_tier5Patrol_03_06", "rebel_tier5Patrol_03_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_imp_02", spawnType = SHIP_SPAWN_SQUADRON, x = 3494, z = 1030, y = -5941, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 2048, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "imperial_tier5Patrol_06", spawnType = SHIP_SPAWN_SINGLE, x = -5000, z = 0, y = 6000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 606, maxRespawn = 1208, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_06_00", "imperial_tier5Patrol_06_01", "imperial_tier5Patrol_06_02", "imperial_tier5Patrol_06_03", "imperial_tier5Patrol_06_04", "imperial_tier5Patrol_06_05"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_asteroid_imp", spawnType = SHIP_SPAWN_SQUADRON, x = 3104, z = 2224, y = 3632, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "rebel_tier5Patrol_11", spawnType = SHIP_SPAWN_SINGLE, x = -1951, z = 5999, y = 4552, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_11_00", "rebel_tier5Patrol_11_01", "rebel_tier5Patrol_11_02", "rebel_tier5Patrol_11_03", "rebel_tier5Patrol_11_04", "rebel_tier5Patrol_11_05", "rebel_tier5Patrol_11_06", "rebel_tier5Patrol_11_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_01", spawnType = SHIP_SPAWN_SINGLE, x = -6046, z = 5987, y = 6452, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_01_00", "imperial_tier5Patrol_01_01", "imperial_tier5Patrol_01_02", "imperial_tier5Patrol_01_03", "imperial_tier5Patrol_01_04", "imperial_tier5Patrol_01_05", "imperial_tier5Patrol_01_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_02", spawnType = SHIP_SPAWN_SINGLE, x = -5006, z = 7247, y = -274, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_02_00", "imperial_tier5Patrol_02_01", "imperial_tier5Patrol_02_02", "imperial_tier5Patrol_02_03", "imperial_tier5Patrol_02_04", "imperial_tier5Patrol_02_05", "imperial_tier5Patrol_02_06", "imperial_tier5Patrol_02_07"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_pirate_imp", spawnType = SHIP_SPAWN_SQUADRON, x = 6604, z = -5720, y = 5100, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1212, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_pirate_imp_00", "kessel_lootship_pirate_imp_01", "kessel_lootship_pirate_imp_02", "kessel_lootship_pirate_imp_03", "kessel_lootship_pirate_imp_04", "kessel_lootship_pirate_imp_05", "kessel_lootship_pirate_imp_06", "kessel_lootship_pirate_imp_07"},
			shipSpawns = {"squad_kessel_lootship_w1_imp"}
		},
		{spawnName = "rebel_tier5Patrol_07", spawnType = SHIP_SPAWN_SINGLE, x = -2000, z = -6500, y = -4000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1214, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_07_00", "rebel_tier5Patrol_07_01", "rebel_tier5Patrol_07_02", "rebel_tier5Patrol_07_03", "rebel_tier5Patrol_07_04"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_02", spawnType = SHIP_SPAWN_SINGLE, x = -201, z = -7225, y = -1976, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1221, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_02_00", "rebel_tier5Patrol_02_01", "rebel_tier5Patrol_02_02", "rebel_tier5Patrol_02_03", "rebel_tier5Patrol_02_04"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_05", spawnType = SHIP_SPAWN_SINGLE, x = 5500, z = 5500, y = 0, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1204, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_05_00", "imperial_tier5Patrol_05_01", "imperial_tier5Patrol_05_02", "imperial_tier5Patrol_05_03", "imperial_tier5Patrol_05_04", "imperial_tier5Patrol_05_05", "imperial_tier5Patrol_05_06"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_follow_reb_02", spawnType = SHIP_SPAWN_SQUADRON, x = -948, z = 4576, y = -1078, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 608, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_reb_02_00", "kessel_lootship_follow_reb_02_01", "kessel_lootship_follow_reb_02_02", "kessel_lootship_follow_reb_02_03", "kessel_lootship_follow_reb_02_04", "kessel_lootship_follow_reb_02_05", "kessel_lootship_follow_reb_02_06", "kessel_lootship_follow_reb_02_07", "kessel_lootship_follow_reb_02_08"},
			shipSpawns = {"squad_kessel_lootship_w2b_reb"}
		},
		{spawnName = "rebel_tier5Patrol_08", spawnType = SHIP_SPAWN_SINGLE, x = -963, z = 4520, y = -1077, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1211, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_08_00", "rebel_tier5Patrol_08_01", "rebel_tier5Patrol_08_02", "rebel_tier5Patrol_08_03", "rebel_tier5Patrol_08_04", "rebel_tier5Patrol_08_05", "rebel_tier5Patrol_08_06", "rebel_tier5Patrol_08_07", "rebel_tier5Patrol_08_08", "rebel_tier5Patrol_08_09"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_reb_01", spawnType = SHIP_SPAWN_SQUADRON, x = -2790, z = 4495, y = 1739, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 604, maxRespawn = 1206, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_attackgroup_reb_02", spawnType = SHIP_SPAWN_SQUADRON, x = 3415, z = 4891, y = 1989, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_rebel_attack"}
		},
		{spawnName = "kessel_lootship_rebattack_imp_02", spawnType = SHIP_SPAWN_SQUADRON, x = 3510, z = 4964, y = 1989, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2b_imp"}
		},
		{spawnName = "kessel_lootship_escort_reb", spawnType = SHIP_SPAWN_SQUADRON, x = 1983, z = 5962, y = 2442, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_escort_reb_00", "kessel_lootship_escort_reb_01", "kessel_lootship_escort_reb_02", "kessel_lootship_escort_reb_03", "kessel_lootship_escort_reb_04", "kessel_lootship_escort_reb_05"},
			shipSpawns = {"squad_kessel_lootship_w2_and_w2b_reb"}
		},
		{spawnName = "rebel_tier5Patrol_04", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 6000, y = 4500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 607, maxRespawn = 1207, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_04_00", "rebel_tier5Patrol_04_01", "rebel_tier5Patrol_04_02", "rebel_tier5Patrol_04_03", "rebel_tier5Patrol_04_04", "rebel_tier5Patrol_04_05"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_impattack_reb_02", spawnType = SHIP_SPAWN_SQUADRON, x = -2977, z = 5986, y = -3472, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2b_reb"}
		},
		{spawnName = "kessel_attackgroup_imp_02", spawnType = SHIP_SPAWN_SQUADRON, x = -2903, z = 6000, y = -3448, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_imperial_attack"}
		},
		{spawnName = "imperial_tier5Patrol_07", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = 5500, y = -6000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1203, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_07_00", "imperial_tier5Patrol_07_01", "imperial_tier5Patrol_07_02", "imperial_tier5Patrol_07_03", "imperial_tier5Patrol_07_04"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_10", spawnType = SHIP_SPAWN_SINGLE, x = 6002, z = 6004, y = 5999, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_10_00", "imperial_tier5Patrol_10_01", "imperial_tier5Patrol_10_02", "imperial_tier5Patrol_10_03", "imperial_tier5Patrol_10_04", "imperial_tier5Patrol_10_05", "imperial_tier5Patrol_10_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "corvette_convoy_imperial", spawnType = SHIP_SPAWN_SQUADRON, x = 7400, z = 7500, y = 7384, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 1200, maxRespawn = 2400, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"corvette_convoy_imperial_00", "corvette_convoy_imperial_01", "corvette_convoy_imperial_02", "corvette_convoy_imperial_03", "corvette_convoy_imperial_04", "corvette_convoy_imperial_05", "corvette_convoy_imperial_06", "corvette_convoy_imperial_07", "corvette_convoy_imperial_08"},
			shipSpawns = {"squad_corvette_convoy_imp"}
		},
		{spawnName = "kessel_lootship_lost_reb_02", spawnType = SHIP_SPAWN_SQUADRON, x = 3451, z = -5448, y = 5950, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 603, maxRespawn = 1201, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 2048, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_attackgroup_imp_01", spawnType = SHIP_SPAWN_SQUADRON, x = 2418, z = -6518, y = 3016, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_imperial_attack"}
		},
		{spawnName = "kessel_lootship_impattack_reb_01", spawnType = SHIP_SPAWN_SQUADRON, x = 2485, z = -6453, y = 3040, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2_reb"}
		},
		{spawnName = "kessel_lootship_follow_imp_02", spawnType = SHIP_SPAWN_SQUADRON, x = 2501, z = -5446, y = 1474, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1203, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_imp_02_00", "kessel_lootship_follow_imp_02_01", "kessel_lootship_follow_imp_02_02", "kessel_lootship_follow_imp_02_03", "kessel_lootship_follow_imp_02_04", "kessel_lootship_follow_imp_02_05", "kessel_lootship_follow_imp_02_06", "kessel_lootship_follow_imp_02_07"},
			shipSpawns = {"squad_kessel_lootship_w2b_imp"}
		},
		{spawnName = "imperial_tier5Patrol_08", spawnType = SHIP_SPAWN_SINGLE, x = 2500, z = -5400, y = 1500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 617, maxRespawn = 1218, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_08_00", "imperial_tier5Patrol_08_01", "imperial_tier5Patrol_08_02", "imperial_tier5Patrol_08_03", "imperial_tier5Patrol_08_04", "imperial_tier5Patrol_08_05", "imperial_tier5Patrol_08_06", "imperial_tier5Patrol_08_07", "imperial_tier5Patrol_08_08"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "kessel_lootship_escort_imp", spawnType = SHIP_SPAWN_SQUADRON, x = 3486, z = -3978, y = 2475, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_escort_imp_00", "kessel_lootship_escort_imp_01", "kessel_lootship_escort_imp_02", "kessel_lootship_escort_imp_03", "kessel_lootship_escort_imp_04", "kessel_lootship_escort_imp_05", "kessel_lootship_escort_imp_06", "kessel_lootship_escort_imp_07"},
			shipSpawns = {"squad_kessel_lootship_w2_and_w2b_imp"}
		},
		{spawnName = "kessel_lootship_asteroid_reb", spawnType = SHIP_SPAWN_SQUADRON, x = -737, z = -2886, y = 4397, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 604, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "imperial_tier5Patrol_04", spawnType = SHIP_SPAWN_SINGLE, x = 0, z = -5000, y = 4500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1201, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_04_00", "imperial_tier5Patrol_04_01", "imperial_tier5Patrol_04_02", "imperial_tier5Patrol_04_03", "imperial_tier5Patrol_04_04", "imperial_tier5Patrol_04_05"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_attackgroup_reb_01", spawnType = SHIP_SPAWN_SQUADRON, x = -5906, z = -4433, y = -3570, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_rebel_attack"}
		},
		{spawnName = "kessel_lootship_rebattack_imp_01", spawnType = SHIP_SPAWN_SQUADRON, x = -5826, z = -4455, y = -3505, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2_imp"}
		},
		{spawnName = "kessel_lootship_pirate_reb", spawnType = SHIP_SPAWN_SQUADRON, x = -5021, z = -6586, y = -4203, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_pirate_reb_00", "kessel_lootship_pirate_reb_01", "kessel_lootship_pirate_reb_02", "kessel_lootship_pirate_reb_03", "kessel_lootship_pirate_reb_04", "kessel_lootship_pirate_reb_05", "kessel_lootship_pirate_reb_06"},
			shipSpawns = {"squad_kessel_lootship_w1_reb"}
		},
		{spawnName = "kessel_lootship_nebula_reb", spawnType = SHIP_SPAWN_SQUADRON, x = -6990, z = -6947, y = -6935, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 609, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 128, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_lootship_nebula_imp", spawnType = SHIP_SPAWN_SQUADRON, x = -6957, z = -6972, y = -6960, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 609, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 128, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "kessel_pirateattack_imp", spawnType = SHIP_SPAWN_SQUADRON, x = -2458, z = -629, y = -1886, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kessel_pirate_attack_imp"}
		},
		{spawnName = "kessel_pirateattack_reb", spawnType = SHIP_SPAWN_SQUADRON, x = -2508, z = -680, y = -1836, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kessel_pirate_attack_reb"}
		},
		{spawnName = "kessel_lootship_derelict_imp", spawnType = SHIP_SPAWN_SQUADRON, x = 2288, z = -3456, y = 1456, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 605, maxRespawn = 1203, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w1_imp"}
		},
		{spawnName = "kessel_lootship_follow_imp_01", spawnType = SHIP_SPAWN_SQUADRON, x = 2504, z = -45, y = 6486, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_imp_01_00", "kessel_lootship_follow_imp_01_01", "kessel_lootship_follow_imp_01_02", "kessel_lootship_follow_imp_01_03", "kessel_lootship_follow_imp_01_04", "kessel_lootship_follow_imp_01_05"},
			shipSpawns = {"squad_kessel_lootship_w2_imp"}
		},
		{spawnName = "imperial_tier5Patrol_03", spawnType = SHIP_SPAWN_SINGLE, x = 2500, z = 0, y = 6500, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_03_00", "imperial_tier5Patrol_03_01", "imperial_tier5Patrol_03_02", "imperial_tier5Patrol_03_03", "imperial_tier5Patrol_03_04", "imperial_tier5Patrol_03_05", "imperial_tier5Patrol_03_06"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_06", spawnType = SHIP_SPAWN_SINGLE, x = 4000, z = 0, y = 5000, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 603, maxRespawn = 1200, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_06_00", "rebel_tier5Patrol_06_01", "rebel_tier5Patrol_06_02", "rebel_tier5Patrol_06_03", "rebel_tier5Patrol_06_04", "rebel_tier5Patrol_06_05", "rebel_tier5Patrol_06_06", "rebel_tier5Patrol_06_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_09", spawnType = SHIP_SPAWN_SINGLE, x = 2646, z = -1060, y = 7095, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_09_00", "imperial_tier5Patrol_09_01", "imperial_tier5Patrol_09_02", "imperial_tier5Patrol_09_03", "imperial_tier5Patrol_09_04", "imperial_tier5Patrol_09_05", "imperial_tier5Patrol_09_06", "imperial_tier5Patrol_09_07", "imperial_tier5Patrol_09_08"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_imperial_gunboat_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_01", spawnType = SHIP_SPAWN_SQUADRON, x = 519, z = 1248, y = -4554, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_01_00", "collection_rebel_smuggler_tier5_01_01", "collection_rebel_smuggler_tier5_01_02", "collection_rebel_smuggler_tier5_01_03", "collection_rebel_smuggler_tier5_01_04", "collection_rebel_smuggler_tier5_01_05", "collection_rebel_smuggler_tier5_01_06", "collection_rebel_smuggler_tier5_01_07"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_02", spawnType = SHIP_SPAWN_SQUADRON, x = -4936, z = -7520, y = 1573, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_02_00", "collection_rebel_smuggler_tier5_02_01", "collection_rebel_smuggler_tier5_02_02", "collection_rebel_smuggler_tier5_02_03", "collection_rebel_smuggler_tier5_02_04", "collection_rebel_smuggler_tier5_02_05", "collection_rebel_smuggler_tier5_02_06", "collection_rebel_smuggler_tier5_02_07"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_03", spawnType = SHIP_SPAWN_SQUADRON, x = 2231, z = -7520, y = 85, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_03_00", "collection_rebel_smuggler_tier5_03_01", "collection_rebel_smuggler_tier5_03_02", "collection_rebel_smuggler_tier5_03_03", "collection_rebel_smuggler_tier5_03_04", "collection_rebel_smuggler_tier5_03_05", "collection_rebel_smuggler_tier5_03_06"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_12_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -177, z = -6540, y = -5445, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_12_00", "rebel_tier5Patrol_12_01", "rebel_tier5Patrol_12_02", "rebel_tier5Patrol_12_03", "rebel_tier5Patrol_12_04", "rebel_tier5Patrol_12_05", "rebel_tier5Patrol_12_06", "rebel_tier5Patrol_12_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_12_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -4932, z = 5044, y = 4563, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_12_00", "imperial_tier5Patrol_12_01", "imperial_tier5Patrol_12_02", "imperial_tier5Patrol_12_03", "imperial_tier5Patrol_12_04", "imperial_tier5Patrol_12_05", "imperial_tier5Patrol_12_06", "imperial_tier5Patrol_12_07"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_11_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -3451, z = 4944, y = 3272, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_11_00", "imperial_tier5Patrol_11_01", "imperial_tier5Patrol_11_02", "imperial_tier5Patrol_11_03", "imperial_tier5Patrol_11_04", "imperial_tier5Patrol_11_05", "imperial_tier5Patrol_11_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_09_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -4661, z = 2432, y = 2216, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_09_00", "rebel_tier5Patrol_09_01", "rebel_tier5Patrol_09_02", "rebel_tier5Patrol_09_03", "rebel_tier5Patrol_09_04", "rebel_tier5Patrol_09_05", "rebel_tier5Patrol_09_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_follow_reb_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -1115, z = -5268, y = -387, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 603, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_reb_01_00", "kessel_lootship_follow_reb_01_01", "kessel_lootship_follow_reb_01_02", "kessel_lootship_follow_reb_01_03", "kessel_lootship_follow_reb_01_04", "kessel_lootship_follow_reb_01_05"},
			shipSpawns = {"squad_kessel_lootship_w2_reb"}
		},
		{spawnName = "rebel_tier5Patrol_05_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 5533, z = 909, y = 6703, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1202, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_05_00", "rebel_tier5Patrol_05_01", "rebel_tier5Patrol_05_02", "rebel_tier5Patrol_05_03", "rebel_tier5Patrol_05_04", "rebel_tier5Patrol_05_05", "rebel_tier5Patrol_05_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_imp_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -2648, z = -2941, y = 726, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "rebel_tier5Patrol_10_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -2561, z = -5541, y = -2255, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_10_00", "rebel_tier5Patrol_10_01", "rebel_tier5Patrol_10_02", "rebel_tier5Patrol_10_03", "rebel_tier5Patrol_10_04", "rebel_tier5Patrol_10_05", "rebel_tier5Patrol_10_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_01_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -825, z = 6844, y = 5387, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 590, maxRespawn = 1215, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_01_00", "rebel_tier5Patrol_01_01", "rebel_tier5Patrol_01_02", "rebel_tier5Patrol_01_03", "rebel_tier5Patrol_01_04", "rebel_tier5Patrol_01_05", "rebel_tier5Patrol_01_06"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_derelict_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -6358, z = -42, y = -3485, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 603, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 63, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w1_reb"}
		},
		{spawnName = "corvette_convoy_rebel_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -1406, z = -1045, y = 1730, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 1200, maxRespawn = 2400, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"corvette_convoy_rebel_00", "corvette_convoy_rebel_01", "corvette_convoy_rebel_02", "corvette_convoy_rebel_03", "corvette_convoy_rebel_04", "corvette_convoy_rebel_05", "corvette_convoy_rebel_06", "corvette_convoy_rebel_07", "corvette_convoy_rebel_08", "corvette_convoy_rebel_09", "corvette_convoy_rebel_10"},
			shipSpawns = {"squad_corvette_convoy_reb"}
		},
		{spawnName = "rebel_tier5Patrol_03_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -5870, z = 2825, y = 512, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1209, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_03_00", "rebel_tier5Patrol_03_01", "rebel_tier5Patrol_03_02", "rebel_tier5Patrol_03_03", "rebel_tier5Patrol_03_04", "rebel_tier5Patrol_03_05", "rebel_tier5Patrol_03_06", "rebel_tier5Patrol_03_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_imp_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 871, z = -867, y = -3470, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 2048, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "imperial_tier5Patrol_06_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 4943, z = 2068, y = 4961, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 606, maxRespawn = 1208, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_06_00", "imperial_tier5Patrol_06_01", "imperial_tier5Patrol_06_02", "imperial_tier5Patrol_06_03", "imperial_tier5Patrol_06_04", "imperial_tier5Patrol_06_05"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_asteroid_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -5138, z = 2407, y = -703, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 607, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "rebel_tier5Patrol_11_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -1541, z = -2867, y = -6104, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_11_00", "rebel_tier5Patrol_11_01", "rebel_tier5Patrol_11_02", "rebel_tier5Patrol_11_03", "rebel_tier5Patrol_11_04", "rebel_tier5Patrol_11_05", "rebel_tier5Patrol_11_06", "rebel_tier5Patrol_11_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_01_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 1449, z = -3360, y = 2818, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_01_00", "imperial_tier5Patrol_01_01", "imperial_tier5Patrol_01_02", "imperial_tier5Patrol_01_03", "imperial_tier5Patrol_01_04", "imperial_tier5Patrol_01_05", "imperial_tier5Patrol_01_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_02_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -6912, z = -4530, y = 3402, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_02_00", "imperial_tier5Patrol_02_01", "imperial_tier5Patrol_02_02", "imperial_tier5Patrol_02_03", "imperial_tier5Patrol_02_04", "imperial_tier5Patrol_02_05", "imperial_tier5Patrol_02_06", "imperial_tier5Patrol_02_07"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_pirate_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 830, z = -3588, y = -770, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 612, maxRespawn = 1212, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_pirate_imp_00", "kessel_lootship_pirate_imp_01", "kessel_lootship_pirate_imp_02", "kessel_lootship_pirate_imp_03", "kessel_lootship_pirate_imp_04", "kessel_lootship_pirate_imp_05", "kessel_lootship_pirate_imp_06", "kessel_lootship_pirate_imp_07"},
			shipSpawns = {"squad_kessel_lootship_w1_imp"}
		},
		{spawnName = "rebel_tier5Patrol_07_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 6177, z = -4093, y = -2014, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1214, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_07_00", "rebel_tier5Patrol_07_01", "rebel_tier5Patrol_07_02", "rebel_tier5Patrol_07_03", "rebel_tier5Patrol_07_04"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_02_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -243, z = 3746, y = -3523, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1221, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_02_00", "rebel_tier5Patrol_02_01", "rebel_tier5Patrol_02_02", "rebel_tier5Patrol_02_03", "rebel_tier5Patrol_02_04"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_05_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -6515, z = -2245, y = -1093, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1204, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_05_00", "imperial_tier5Patrol_05_01", "imperial_tier5Patrol_05_02", "imperial_tier5Patrol_05_03", "imperial_tier5Patrol_05_04", "imperial_tier5Patrol_05_05", "imperial_tier5Patrol_05_06"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_lootship_follow_reb_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 6102, z = -2339, y = -5225, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 608, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_reb_02_00", "kessel_lootship_follow_reb_02_01", "kessel_lootship_follow_reb_02_02", "kessel_lootship_follow_reb_02_03", "kessel_lootship_follow_reb_02_04", "kessel_lootship_follow_reb_02_05", "kessel_lootship_follow_reb_02_06", "kessel_lootship_follow_reb_02_07", "kessel_lootship_follow_reb_02_08"},
			shipSpawns = {"squad_kessel_lootship_w2b_reb"}
		},
		{spawnName = "rebel_tier5Patrol_08_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 3173, z = -590, y = 1992, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1211, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_08_00", "rebel_tier5Patrol_08_01", "rebel_tier5Patrol_08_02", "rebel_tier5Patrol_08_03", "rebel_tier5Patrol_08_04", "rebel_tier5Patrol_08_05", "rebel_tier5Patrol_08_06", "rebel_tier5Patrol_08_07", "rebel_tier5Patrol_08_08", "rebel_tier5Patrol_08_09"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_lost_reb_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 2766, z = -4423, y = -947, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 604, maxRespawn = 1206, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 1024, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_attackgroup_reb_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 5448, z = -6284, y = 2711, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_rebel_attack"}
		},
		{spawnName = "kessel_lootship_rebattack_imp_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 4491, z = -807, y = -3682, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2b_imp"}
		},
		{spawnName = "kessel_lootship_escort_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 5329, z = 301, y = -587, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1204, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_escort_reb_00", "kessel_lootship_escort_reb_01", "kessel_lootship_escort_reb_02", "kessel_lootship_escort_reb_03", "kessel_lootship_escort_reb_04", "kessel_lootship_escort_reb_05"},
			shipSpawns = {"squad_kessel_lootship_w2_and_w2b_reb"}
		},
		{spawnName = "rebel_tier5Patrol_04_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -5718, z = 2748, y = 3240, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 607, maxRespawn = 1207, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_04_00", "rebel_tier5Patrol_04_01", "rebel_tier5Patrol_04_02", "rebel_tier5Patrol_04_03", "rebel_tier5Patrol_04_04", "rebel_tier5Patrol_04_05"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "kessel_lootship_impattack_reb_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -26, z = 2106, y = 5662, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2b_reb"}
		},
		{spawnName = "kessel_attackgroup_imp_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -4180, z = -2026, y = 6378, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_imperial_attack"}
		},
		{spawnName = "imperial_tier5Patrol_07_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 1989, z = 2348, y = 5979, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1203, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_07_00", "imperial_tier5Patrol_07_01", "imperial_tier5Patrol_07_02", "imperial_tier5Patrol_07_03", "imperial_tier5Patrol_07_04"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_10_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -5591, z = 5064, y = -6165, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_10_00", "imperial_tier5Patrol_10_01", "imperial_tier5Patrol_10_02", "imperial_tier5Patrol_10_03", "imperial_tier5Patrol_10_04", "imperial_tier5Patrol_10_05", "imperial_tier5Patrol_10_06"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "corvette_convoy_imperial_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -6824, z = 6676, y = 2177, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 1200, maxRespawn = 2400, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"corvette_convoy_imperial_00", "corvette_convoy_imperial_01", "corvette_convoy_imperial_02", "corvette_convoy_imperial_03", "corvette_convoy_imperial_04", "corvette_convoy_imperial_05", "corvette_convoy_imperial_06", "corvette_convoy_imperial_07", "corvette_convoy_imperial_08"},
			shipSpawns = {"squad_corvette_convoy_imp"}
		},
		{spawnName = "kessel_lootship_lost_reb_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -4511, z = -5315, y = 3714, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 603, maxRespawn = 1201, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 2048, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_attackgroup_imp_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -5332, z = 6059, y = -1759, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_imperial_attack"}
		},
		{spawnName = "kessel_lootship_impattack_reb_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 6993, z = -4844, y = 4455, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2_reb"}
		},
		{spawnName = "kessel_lootship_follow_imp_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 6494, z = 4820, y = 1913, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1203, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_imp_02_00", "kessel_lootship_follow_imp_02_01", "kessel_lootship_follow_imp_02_02", "kessel_lootship_follow_imp_02_03", "kessel_lootship_follow_imp_02_04", "kessel_lootship_follow_imp_02_05", "kessel_lootship_follow_imp_02_06", "kessel_lootship_follow_imp_02_07"},
			shipSpawns = {"squad_kessel_lootship_w2b_imp"}
		},
		{spawnName = "imperial_tier5Patrol_08_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -1465, z = -2158, y = 644, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 617, maxRespawn = 1218, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_08_00", "imperial_tier5Patrol_08_01", "imperial_tier5Patrol_08_02", "imperial_tier5Patrol_08_03", "imperial_tier5Patrol_08_04", "imperial_tier5Patrol_08_05", "imperial_tier5Patrol_08_06", "imperial_tier5Patrol_08_07", "imperial_tier5Patrol_08_08"},
			shipSpawns = {"imp_imperial_gunboat_tier5", "imp_tie_advanced_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "kessel_lootship_escort_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -4170, z = -4209, y = 471, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 605, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_escort_imp_00", "kessel_lootship_escort_imp_01", "kessel_lootship_escort_imp_02", "kessel_lootship_escort_imp_03", "kessel_lootship_escort_imp_04", "kessel_lootship_escort_imp_05", "kessel_lootship_escort_imp_06", "kessel_lootship_escort_imp_07"},
			shipSpawns = {"squad_kessel_lootship_w2_and_w2b_imp"}
		},
		{spawnName = "kessel_lootship_asteroid_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 392, z = 2627, y = 2743, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 604, maxRespawn = 1209, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "imperial_tier5Patrol_04_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 3333, z = -4499, y = 3846, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 611, maxRespawn = 1201, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_04_00", "imperial_tier5Patrol_04_01", "imperial_tier5Patrol_04_02", "imperial_tier5Patrol_04_03", "imperial_tier5Patrol_04_04", "imperial_tier5Patrol_04_05"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "kessel_attackgroup_reb_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -2661, z = 6656, y = -5412, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_rebel_attack"}
		},
		{spawnName = "kessel_lootship_rebattack_imp_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 424, z = 3920, y = 2237, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 602, maxRespawn = 1202, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 128, maxPatrol = 256, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w2_imp"}
		},
		{spawnName = "kessel_lootship_pirate_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -1422, z = -5895, y = 3073, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 604, maxRespawn = 1205, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_pirate_reb_00", "kessel_lootship_pirate_reb_01", "kessel_lootship_pirate_reb_02", "kessel_lootship_pirate_reb_03", "kessel_lootship_pirate_reb_04", "kessel_lootship_pirate_reb_05", "kessel_lootship_pirate_reb_06"},
			shipSpawns = {"squad_kessel_lootship_w1_reb"}
		},
		{spawnName = "kessel_lootship_nebula_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -5937, z = -4160, y = 4081, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 609, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 128, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_reb"}
		},
		{spawnName = "kessel_lootship_nebula_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 2447, z = -1695, y = 3047, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 609, maxRespawn = 1208, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 128, totalSpawns = 1,
			shipSpawns = {"squad_kessel_loot_gunboat_solo_imp"}
		},
		{spawnName = "kessel_pirateattack_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 420, z = -4173, y = -4183, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kessel_pirate_attack_imp"}
		},
		{spawnName = "kessel_pirateattack_reb_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -5077, z = 2496, y = 4528, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 610, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 256, maxPatrol = 512, totalSpawns = 1,
			shipSpawns = {"squad_kessel_pirate_attack_reb"}
		},
		{spawnName = "kessel_lootship_derelict_imp_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -2935, z = -4493, y = 6074, patrolType = SHIP_AI_RANDOM_PATROL,  minRespawn = 605, maxRespawn = 1203, minSpawnDistance = 32, maxSpawnDistance = 64, minPatrol = 64, maxPatrol = 160, totalSpawns = 1,
			shipSpawns = {"squad_kessel_lootship_w1_imp"}
		},
		{spawnName = "kessel_lootship_follow_imp_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -4584, z = 5579, y = 2273, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 609, maxRespawn = 1210, minSpawnDistance = 32, maxSpawnDistance = 64, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"kessel_lootship_follow_imp_01_00", "kessel_lootship_follow_imp_01_01", "kessel_lootship_follow_imp_01_02", "kessel_lootship_follow_imp_01_03", "kessel_lootship_follow_imp_01_04", "kessel_lootship_follow_imp_01_05"},
			shipSpawns = {"squad_kessel_lootship_w2_imp"}
		},
		{spawnName = "imperial_tier5Patrol_03_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 6435, z = -843, y = 6185, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_03_00", "imperial_tier5Patrol_03_01", "imperial_tier5Patrol_03_02", "imperial_tier5Patrol_03_03", "imperial_tier5Patrol_03_04", "imperial_tier5Patrol_03_05", "imperial_tier5Patrol_03_06"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"}
		},
		{spawnName = "rebel_tier5Patrol_06_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = 6869, z = 4330, y = 6404, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 603, maxRespawn = 1200, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 6,
			patrolsToAssign = 5, fixedPatrolPoints = {"rebel_tier5Patrol_06_00", "rebel_tier5Patrol_06_01", "rebel_tier5Patrol_06_02", "rebel_tier5Patrol_06_03", "rebel_tier5Patrol_06_04", "rebel_tier5Patrol_06_05", "rebel_tier5Patrol_06_06", "rebel_tier5Patrol_06_07"},
			shipSpawns = {"reb_awing_tier5", "reb_ywing_tier5", "reb_gunboat_tier5", "reb_xwing_tier5", "reb_ywing_tier5", "reb_z95_tier5"}
		},
		{spawnName = "imperial_tier5Patrol_09_duplicate", spawnType = SHIP_SPAWN_SINGLE, x = -4783, z = 916, y = 3714, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"imperial_tier5Patrol_09_00", "imperial_tier5Patrol_09_01", "imperial_tier5Patrol_09_02", "imperial_tier5Patrol_09_03", "imperial_tier5Patrol_09_04", "imperial_tier5Patrol_09_05", "imperial_tier5Patrol_09_06", "imperial_tier5Patrol_09_07", "imperial_tier5Patrol_09_08"},
			shipSpawns = {"imp_tie_advanced_tier5", "imp_imperial_gunboat_tier5", "imp_tie_aggressor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_01_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 4424, z = 6972, y = -200, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_01_00", "collection_rebel_smuggler_tier5_01_01", "collection_rebel_smuggler_tier5_01_02", "collection_rebel_smuggler_tier5_01_03", "collection_rebel_smuggler_tier5_01_04", "collection_rebel_smuggler_tier5_01_05", "collection_rebel_smuggler_tier5_01_06", "collection_rebel_smuggler_tier5_01_07"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_02_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = -75, z = 1409, y = 6, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_02_00", "collection_rebel_smuggler_tier5_02_01", "collection_rebel_smuggler_tier5_02_02", "collection_rebel_smuggler_tier5_02_03", "collection_rebel_smuggler_tier5_02_04", "collection_rebel_smuggler_tier5_02_05", "collection_rebel_smuggler_tier5_02_06", "collection_rebel_smuggler_tier5_02_07"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
		{spawnName = "collection_rebel_smuggler_tier5_03_duplicate", spawnType = SHIP_SPAWN_SQUADRON, x = 6318, z = -6727, y = 4148, patrolType = SHIP_AI_SINGLE_PATROL_ROTATION, minRespawn = 100, maxRespawn = 300, minSpawnDistance = 64, maxSpawnDistance = 128, totalSpawns = 1,
			patrolsToAssign = 5, fixedPatrolPoints = {"collection_rebel_smuggler_tier5_03_00", "collection_rebel_smuggler_tier5_03_01", "collection_rebel_smuggler_tier5_03_02", "collection_rebel_smuggler_tier5_03_03", "collection_rebel_smuggler_tier5_03_04", "collection_rebel_smuggler_tier5_03_05", "collection_rebel_smuggler_tier5_03_06"},
			shipSpawns = {"squad_rebel_smuggler_tier5"}
		},
	},
}

registerScreenPlay("SpaceLight1Spawner", true)

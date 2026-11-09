-- DSRC spacequest/<type>/<name>.tab and npe/reworked_quests.tab (Stella Bellum / Cekis).
-- Staged data for the NPE mission port. The first row carries mission settings; later rows extend objectives.
-- The legacy ground-quest associations are source references for designing Stardust quest grants.
return {
	questZone = "space_ord_mantell",

	navPoints = {
		easy_main_1_stuff = {x = 222.27, z = -0.98, y = 12.16},
		easy_main_home_1 = {x = -9.77, z = 430.92, y = 3275.73},
		easy_main_home_2 = {x = 220.47, z = 224.62, y = 1592.58},
		emergence_1 = {x = 531.27, z = -1133.82, y = 1971.25},
		emergence_2 = {x = 774.93, z = -1637.5, y = 2842.37},
		emergence_3 = {x = 1211.22, z = -2532.3, y = 4404.19},
		med_main_home_1 = {x = -2230.54, z = 1010.04, y = 1255.41},
		med_main_home_2 = {x = -1152.62, z = 491.71, y = 831.32},
		npe_easy_main_delivery_miners = {x = 2466.87, z = -1997.13, y = -3166.6},
		npe_easy_main_delivery_nova = {x = 333.2, z = -294.2, y = 575.04},
		npe_easy_main_escort_1 = {x = -2268.87, z = 869.9, y = -2248.6},
		npe_easy_main_escort_2 = {x = -1086.95, z = 454.36, y = -1124.55},
		npe_easy_main_escort_3 = {x = -284.43, z = 138.92, y = 45.66},
		npe_easy_main_escort_4 = {x = 1182.61, z = 116.7, y = 483.76},
		npe_easy_main_escort_5 = {x = 2020.8, z = 533.22, y = 1662.35},
		npe_easy_main_escort_6 = {x = 3360.45, z = 1646.53, y = 3126.8},
		npe_easy_main_patrol_1 = {x = 870.88, z = -337.17, y = 421.15},
		npe_easy_main_patrol_2 = {x = 1665.82, z = -1190.95, y = 1048.13},
		npe_easy_main_patrol_3 = {x = 2362.38, z = -1962.95, y = 1627.25},
		npe_easy_main_patrol_4 = {x = 2964.45, z = 1428.27, y = 2744.22},
		npe_easy_main_patrol_5 = {x = 1288.61, z = 611.84, y = 1167.52},
		npe_easy_main_patrol_6 = {x = 97.17, z = 207.04, y = 64.7},
		npe_easy_main_patrol_7 = {x = -1633.59, z = 671.41, y = 1517.87},
		npe_easy_main_patrol_8 = {x = -811.79, z = 1062.78, y = 2153.63},
		npe_easy_main_patrol_9 = {x = -115.24, z = 559.1, y = 4266.98},
		npe_hard_final_battle = {x = -2276.68, z = 2131.66, y = 1316.69},
		npe_hard_main_assassin_1 = {x = -3972.78, z = -1750.3, y = 2639.48},
		npe_hard_main_assassin_2 = {x = -3775.26, z = 830.35, y = 1147.74},
		npe_hard_main_assassin_3 = {x = -3637.56, z = 2677.33, y = 176.03},
		npe_hard_main_assassin_4 = {x = -3246.19, z = -1106.48, y = -3510.12},
		npe_hard_main_assassin_5 = {x = -3463.97, z = 1432.66, y = -1458.54},
		npe_hard_main_assassin_6 = {x = -3570.67, z = 2986.18, y = -317.64},
		npe_hard_main_assassin_7 = {x = -2967.13, z = 2803.31, y = -197.27},
		npe_hard_main_assassin_8 = {x = -1110.87, z = 1129.67, y = -81.79},
		npe_hard_main_assassin_9 = {x = 321.79, z = -54.69, y = 59.57},
		npe_hulk_1 = {x = 1613.82, z = 1214.64, y = 2311.11},
		npe_med_main_escort_1 = {x = -1087.44, z = 1522.02, y = 3085.06},
		npe_med_main_escort_2 = {x = 1100.13, z = -393.57, y = 12.45},
		npe_med_main_escort_3 = {x = 2712, z = -1866.51, y = -2269.11},
		npe_med_main_patrol_1 = {x = -354.02, z = -565.2, y = -2589.68},
		npe_med_main_patrol_2 = {x = -1709.04, z = 1015.66, y = 364.26},
		npe_med_main_patrol_3 = {x = -2468.65, z = 1659.76, y = 2024.86},
		npe_med_main_patrol_4 = {x = -3465.93, z = 1843.32, y = 2646.08},
		npe_med_main_patrol_5 = {x = -1824.76, z = 982.7, y = 1397.26},
		npe_med_main_patrol_6 = {x = -433.61, z = 357.19, y = 370.62},
		npe_med_main_recovery_1 = {x = -1621.39, z = 614.28, y = -3418.32},
		npe_med_main_recovery_10 = {x = -3951.05, z = 2829.43, y = 438.98},
		npe_med_main_recovery_11 = {x = -1730.77, z = 1224.65, y = 186.29},
		npe_med_main_recovery_12 = {x = 304.45, z = 932.65, y = -720.24},
		npe_med_main_recovery_2 = {x = -3159.28, z = 1027.38, y = -1695.36},
		npe_med_main_recovery_3 = {x = -3536.73, z = 2878.02, y = -314.22},
		npe_med_main_recovery_4 = {x = -3075.29, z = 1188.51, y = -1481.25},
		npe_med_main_recovery_5 = {x = -1349.89, z = 546.16, y = -552.75},
		npe_med_main_recovery_6 = {x = -147.95, z = 214.12, y = -87.4},
		npe_med_main_recovery_7 = {x = -3095.55, z = 651.14, y = -1846.74},
		npe_med_main_recovery_8 = {x = -3137.72, z = 1200.72, y = 28.4},
		npe_med_main_recovery_9 = {x = -2920.57, z = 1955.87, y = 705.84},
		npe_train_1 = {x = 477.31, z = -966.59, y = 1949.46},
		npe_train_escort_1 = {x = 1938.54, z = 807.15, y = 1391.89},
		npe_train_escort_2 = {x = 3282.81, z = 1560.59, y = 2984.71},
	},

	legacyGroundQuestLinks = {
		npe_smuggler_try = "patrol:npe_training_1",
		npe_officer_try = "patrol:npe_training_1b",
		npe_spy_try_2 = "patrol:npe_training_2",
		npe_boba = "destroy:npe_training_2a",
		npe_commando = "patrol:npe_training_2b",
		npe_frelka_transition = "escort:npe_training_3",
		npe_frelka_transition_2 = "patrol:npe_training_3a",
		npe_frelka_quest = "patrol:npe_easy_main_1",
		npe_side_dungeon_dna = "inspect:npe_easy_main_1a",
		npe_side_dungeon_soldier = "destroy_surpriseattack:npe_easy_main_1b",
		npe_rebel_2 = "delivery_no_pickup:npe_easy_main_1c",
		npe_imperial_1 = "patrol:npe_easy_main_1d",
		npe_pilot_first_mission_no_ground = "escort:npe_easy_main_2",
		npe_scout_1 = "patrol:npe_easy_main_2b",
		npe_scout_1a = "delivery_no_pickup:npe_easy_main_3",
		npe_brawler_2 = "delivery_no_pickup:npe_easy_main_3a",
		npe_brawler_2a = "patrol:npe_easy_main_3b",
		npe_side_smuggle = "patrol:npe_easy_main_4",
		npe_runequest = "destroy_surpriseattack:npe_easy_main_4a",
	},

	missions = {
		["assassinate:npe_hard_main_2a"] = {
			{
				escortPath = "space_ord_mantell:npe_hard_main_assassin_1", targetShipType = "npe_blacksun_chaen",
				targetArrivalDelay = 0, targetEscort = "npe_blacksun_guard_tier1", targetAttackMode = "attackfreely",
				mustDestroyEscort = 0, triggerEvent = "splitquest", triggerSplitCondition = "triggerOn",
				triggerArg = "destroy:npe_hard_main_2b", triggerOn = -1, autoReward = 0, questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_2", targetEscort = "npe_blacksun_guard_tier1"},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_3", targetEscort = "npe_blacksun_guard_tier1"},
			{targetEscort = "npe_blacksun_guard_tier1"},
		},
		["assassinate:npe_hard_main_2c"] = {
			{
				escortPath = "space_ord_mantell:npe_hard_main_assassin_4", targetShipType = "npe_blacksun_ondara",
				targetArrivalDelay = 0, targetEscort = "npe_blacksun_guard_tier1", targetAttackMode = "attackfreely",
				mustDestroyEscort = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_hard_main_2d", triggerOn = 0, autoReward = 0, questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_5", targetEscort = "npe_blacksun_guard_tier1"},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_6", targetEscort = "npe_blacksun_guard_tier1"},
			{targetEscort = "npe_blacksun_guard_tier1"},
		},
		["assassinate:npe_hard_main_3a"] = {
			{
				escortPath = "space_ord_mantell:npe_hard_main_assassin_7", targetShipType = "npe_blacksun_rilis",
				targetArrivalDelay = 0, targetEscort = "npe_hard_blacksun_fighter_tier2", targetAttackMode = "attackfreely",
				mustDestroyEscort = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "destroy_surpriseattack:npe_hard_main_3b", triggerOn = -1, autoReward = 0, questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_8", targetEscort = "npe_hard_blacksun_bomber_tier2"},
			{escortPath = "space_ord_mantell:npe_hard_main_assassin_9"},
		},
		["delivery_no_pickup:npe_easy_main_1c"] = {
			{
				deliveryPoint = "space_ord_mantell:npe_easy_main_delivery_nova", deliveryShip = "npe_main_cardas_agent",
				numAttackShipLists = 1, attackShips1 = "npe_easy_main_blacksun_assassin", attackPeriod = 180,
				attackListType = "sequential", triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_easy_main_1d", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["delivery_no_pickup:npe_easy_main_3"] = {
			{
				deliveryPoint = "space_ord_mantell:npe_easy_main_delivery_miners", deliveryShip = "npe_easy_main_dynath_agent",
				numAttackShipLists = 1, attackShips1 = "npe_blacksun_stalker_tier1", attackPeriod = 120,
				attackListType = "sequential", triggerEvent = "splitquest", triggerSplitCondition = "triggerOn",
				triggerArg = "delivery_no_pickup:npe_easy_main_3a", triggerOn = -1, triggerEndsMission = 0, triggerDelay = 0,
				autoReward = 0, questDelay = 0,
			},
			{attackShips1 = "npe_blacksun_hunter_tier1"},
		},
		["delivery_no_pickup:npe_easy_main_3a"] = {
			{
				deliveryPoint = "space_ord_mantell:npe_easy_main_delivery_nova", deliveryShip = "npe_main_cardas_agent",
				numAttackShipLists = 1, attackShips1 = "npe_easy_main_blacksun_assassin", attackPeriod = 180,
				attackListType = "sequential", triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_easy_main_3b", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
			{attackShips1 = "npe_easy_main_blacksun_assassin"},
		},
		["delivery_no_pickup:npe_smuggler_2"] = {
			{
				deliveryPoint = "space_ord_mantell:npe_med_main_recovery_2", deliveryShip = "npe_smuggle_buyer",
				numAttackShipLists = 0, attackPeriod = 0, attackListType = "sequential", triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_smuggler_3a", triggerOn = -1, triggerEndsMission = 0,
				triggerDelay = 5, autoReward = 0, questDelay = 0,
			},
		},
		["destroy:npe_hard_main_1"] = {
			{
				shipList = "npe_hard_blacksun_hunter_tier1", validSpawns = "space_ord_mantell:npe_hard_main_fighters",
				giveSpawnWaypoint = 1, spawnsForWaypointsOnly = 0, killCount = 4, killVariance = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "destroy:npe_hard_main_1a", triggerOn = -1, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_hard_blacksun_stalker_tier1"},
		},
		["destroy:npe_hard_main_1a"] = {
			{
				shipList = "npe_hard_blacksun_spy", validSpawns = "space_ord_mantell:npe_hard_main_spies", giveSpawnWaypoint = 1,
				spawnsForWaypointsOnly = 0, killCount = 4, killVariance = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_hard_main_1b", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
		},
		["destroy:npe_hard_main_2"] = {
			{
				shipList = "npe_hard_blacksun_stalker_tier1", validSpawns = "space_ord_mantell:npe_hard_main_attack_1",
				giveSpawnWaypoint = 1, spawnsForWaypointsOnly = 0, killCount = 5, killVariance = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "assassinate:npe_hard_main_2a", triggerOn = -1,
				triggerEndsMission = 1, triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_hard_blacksun_hunter_tier1"},
			{shipList = "npe_hard_blacksun_bomber_tier1"},
		},
		["destroy:npe_hard_main_2b"] = {
			{
				shipList = "npe_hard_blacksun_hunter_tier1", validSpawns = "space_ord_mantell:npe_hard_main_attack_2",
				giveSpawnWaypoint = 1, spawnsForWaypointsOnly = 0, killCount = 5, killVariance = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "assassinate:npe_hard_main_2c", triggerOn = -1,
				triggerEndsMission = 1, triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_hard_blacksun_bomber_tier1"},
			{shipList = "npe_hard_blacksun_stalker_tier1"},
		},
		["destroy:npe_hard_main_3"] = {
			{
				shipList = "npe_hard_blacksun_bomber_tier2", validSpawns = "space_ord_mantell:npe_hard_main_attack_3",
				giveSpawnWaypoint = 1, spawnsForWaypointsOnly = 0, killCount = 2, killVariance = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "assassinate:npe_hard_main_3a", triggerOn = -1,
				triggerEndsMission = 1, triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_hard_blacksun_fighter_tier2"},
		},
		["destroy:npe_med_main_1a"] = {
			{
				shipList = "npe_hard_blacksun_stalker_tier1", giveSpawnWaypoint = 0, spawnsForWaypointsOnly = 1, killCount = 4,
				killVariance = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_med_main_1b", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
			{shipList = "npe_med_blacksun_stalker_tier1"},
			{shipList = "npe_blacksun_stalker_tier1"},
		},
		["destroy:npe_med_main_3"] = {
			{
				shipList = "npe_med_blacksun_hunter_tier1", validSpawns = "space_ord_mantell:npe_med_main_destroy",
				giveSpawnWaypoint = 1, spawnsForWaypointsOnly = 1, killCount = 4, killVariance = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "rescue:npe_med_main_3a", triggerOn = -1, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_med_blacksun_stalker_tier1"},
		},
		["destroy:npe_med_main_4"] = {
			{
				shipList = "npe_med_blacksun_hunter_tier1", giveSpawnWaypoint = 0, spawnsForWaypointsOnly = 1, killCount = 2,
				triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "destroy_surpriseattack:npe_med_main_4a", triggerEndsMission = 0, triggerDelay = 30, autoReward = 0,
				questDelay = 0,
			},
			{shipList = "npe_med_blacksun_stalker_tier1"},
			{shipList = "npe_blacksun_hunter_tier1"},
			{shipList = "npe_hard_blacksun_hunter_tier1"},
			{shipList = "npe_hard_blacksun_stalker_tier1"},
			{shipList = "npe_blacksun_stalker_tier1"},
		},
		["destroy:npe_training_2a"] = {
			{
				shipList = "npe_blacksun_hunter_tier1", validSpawns = "space_ord_mantell:hulk_fluff_1", giveSpawnWaypoint = 1,
				spawnsForWaypointsOnly = 0, killCount = 2, killVariance = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_training_2b", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{shipList = "npe_blacksun_stalker_tier1"},
		},
		["destroy_surpriseattack:npe_easy_main_1b"] = {
			{
				shipType = "npe_easy_main_blacksun_assassin", shipCount = 3, behavior = "attack", questDelay = 0,
				leaveEarlyTimer = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "delivery_no_pickup:npe_easy_main_1c", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 2,
			},
		},
		["destroy_surpriseattack:npe_easy_main_4a"] = {
			{
				shipType = "npe_easy_main_blacksun_assassin", shipCount = 4, behavior = "attack", questDelay = 0,
				leaveEarlyTimer = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "destroy_surpriseattack:npe_easy_main_4b", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 2,
			},
		},
		["destroy_surpriseattack:npe_easy_main_4b"] = {
			{
				shipType = "npe_talonbane_cobra_tier1", shipCount = 1, behavior = "attack", questDelay = 0, leaveEarlyTimer = 0,
				triggerEvent = "splitquest", triggerSplitCondition = "success", triggerArg = "patrol:npe_easy_main_4c",
				triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0,
			},
		},
		["destroy_surpriseattack:npe_hard_main_3b"] = {
			{
				shipType = "npe_hard_blacksun_fighter_tier1", shipCount = 4, behavior = "attack", questDelay = 0,
				leaveEarlyTimer = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "space_battle:npe_hard_main_3c", triggerOn = 4, triggerEndsMission = 0, triggerDelay = 0,
			},
		},
		["destroy_surpriseattack:npe_med_main_2c"] = {
			{
				shipType = "npe_med_blacksun_hunter_tier1", shipCount = 6, behavior = "attack", questDelay = 0, leaveEarlyTimer = 0,
				triggerEvent = "none", triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0,
			},
		},
		["destroy_surpriseattack:npe_med_main_4a"] = {
			{
				shipType = "npe_med_blacksun_bomber_tier1", shipCount = 4, behavior = "attack", questDelay = 0, leaveEarlyTimer = 0,
				triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "destroy_surpriseattack:npe_med_main_4b", triggerOn = 4, triggerEndsMission = 0, triggerDelay = 5,
			},
		},
		["destroy_surpriseattack:npe_med_main_4b"] = {
			{
				shipType = "npe_blacksun_demonrunner_tier1", shipCount = 1, behavior = "attack", questDelay = 0, leaveEarlyTimer = 0,
				triggerEvent = "splitquest", triggerSplitCondition = "success", triggerArg = "patrol:npe_med_main_4c", triggerOn = 0,
				triggerEndsMission = 0, triggerDelay = 0,
			},
		},
		["destroy_surpriseattack:npe_training_1a"] = {
			{
				shipType = "npe_easy_main_blacksun_assassin", shipCount = 2, behavior = "attack", questDelay = 0,
				leaveEarlyTimer = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_training_1b", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0,
			},
		},
		["escort:npe_easy_main_2"] = {
			{
				escortShipType = "npe_easy_main_dynath_miner", escortPath = "space_ord_mantell:npe_easy_main_escort_1",
				numAttackShipLists = 1, attackShips1 = "npe_blacksun_hunter_tier1", attackPeriod = 80, attackListType = "sequential",
				numResponses = 2, damageMultiplier = 0, hateModifier = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_easy_main_2b", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, noDistancePolling = 0, customDistanceMessages = 0, destroyIsSuccess = 0, autoReward = 0,
				questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_easy_main_escort_2", attackShips1 = "npe_blacksun_hunter_tier1"},
			{escortPath = "space_ord_mantell:npe_easy_main_escort_3"},
		},
		["escort:npe_easy_main_2a"] = {
			{
				escortShipType = "npe_easy_main_dynath_miner", escortPath = "space_ord_mantell:npe_easy_main_escort_4",
				numAttackShipLists = 1, attackShips1 = "npe_blacksun_hunter_tier1", attackPeriod = 80, attackListType = "sequential",
				numResponses = 2, damageMultiplier = 0, hateModifier = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_easy_main_2b", triggerEndsMission = 1, triggerDelay = 5,
				noDistancePolling = 0, customDistanceMessages = 0, destroyIsSuccess = 0, autoReward = 0, questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_easy_main_escort_5", attackShips1 = "npe_blacksun_stalker_tier1"},
			{escortPath = "space_ord_mantell:npe_easy_main_escort_6"},
		},
		["escort:npe_med_main_3b"] = {
			{
				escortShipType = "npe_easy_main_dynath_miner", escortPath = "space_ord_mantell:npe_med_main_escort_1",
				numAttackShipLists = 2, attackShips1 = "npe_med_blacksun_assassin_tier1",
				attackShips2 = "npe_med_blacksun_bomber_tier1", attackPeriod = 80, attackListType = "sequential", numResponses = 2,
				damageMultiplier = 0, hateModifier = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_med_main_3c", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0,
				noDistancePolling = 0, customDistanceMessages = 0, destroyIsSuccess = 0, autoReward = 0, questDelay = 0,
			},
			{
				escortPath = "space_ord_mantell:npe_med_main_escort_2", attackShips1 = "npe_med_blacksun_assassin_tier1",
				attackShips2 = "npe_med_blacksun_bomber_tier1",
			},
			{
				escortPath = "space_ord_mantell:npe_med_main_escort_3", attackShips1 = "npe_med_blacksun_bomber_tier1",
				attackShips2 = "npe_med_blacksun_hunter_tier1",
			},
			{attackShips2 = "npe_med_blacksun_stalker_tier1"},
		},
		["escort:npe_training_3"] = {
			{
				escortShipType = "npe_evn_cardas_police", escortPath = "space_ord_mantell:npe_easy_main_escort_4",
				numAttackShipLists = 1, attackShips1 = "npe_easy_main_blacksun_assassin", attackPeriod = 40,
				attackListType = "sequential", numResponses = 2, damageMultiplier = 0, hateModifier = 0, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "patrol:npe_training_3a", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, noDistancePolling = 0, customDistanceMessages = 0, destroyIsSuccess = 0, autoReward = 0,
				questDelay = 0,
			},
			{escortPath = "space_ord_mantell:npe_train_escort_1", attackShips1 = "npe_easy_main_blacksun_assassin"},
			{escortPath = "space_ord_mantell:npe_train_escort_2"},
		},
		["inspect:npe_easy_main_1a"] = {
			{
				shipList = "npe_easy_main_blacksun_spy", validSpawns = "space_ord_mantell:npe_easy_main_1a_inspect",
				giveSpawnWaypoint = 1, cargo = "encoded_information", triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "destroy_surpriseattack:npe_easy_main_1b", triggerOn = 0, triggerEndsMission = 0, triggerDelay = 2,
				autoReward = 0, questDelay = 0,
			},
		},
		["patrol:npe_easy_main_1"] = {
			{
				navPoints = "space_ord_mantell:npe_easy_main_patrol_1", navRadius = 150, laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "inspect:npe_easy_main_1a", triggerOn = -1, triggerEndsMission = 1,
				triggerDelay = 5, autoReward = 0, questDelay = 0,
			},
			{navPoints = "space_ord_mantell:npe_easy_main_patrol_2"},
			{navPoints = "space_ord_mantell:npe_easy_main_patrol_3"},
		},
		["patrol:npe_easy_main_1d"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_easy_main_2b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_easy_main_3b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_easy_main_4"] = {
			{
				navPoints = "space_ord_mantell:npe_easy_main_patrol_7", laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "destroy_surpriseattack:npe_easy_main_4a", triggerOn = 2,
				triggerEndsMission = 1, triggerDelay = 5, autoReward = 0, questDelay = 0,
			},
			{navPoints = "space_ord_mantell:npe_easy_main_patrol_8"},
			{navPoints = "space_ord_mantell:npe_easy_main_patrol_9"},
		},
		["patrol:npe_easy_main_4c"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_emergence"] = {
			{
				navPoints = "space_ord_mantell:npe_train_1", laps = 1, triggerEvent = "none", triggerSplitCondition = "triggerOn",
				triggerOn = 0, triggerEndsMission = 0, triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
		},
		["patrol:npe_hard_main_1b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_hard_main_2d"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_hard_main_3d"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_med_main_1"] = {
			{
				navPoints = "space_ord_mantell:npe_med_main_patrol_1", laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "destroy:npe_med_main_1a", triggerOn = -1, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
			{navPoints = "space_ord_mantell:npe_med_main_patrol_2"},
			{navPoints = "space_ord_mantell:npe_med_main_patrol_3"},
		},
		["patrol:npe_med_main_1b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_med_main_2b"] = {
			{
				navPoints = "space_ord_mantell:npe_med_main_patrol_4", navRadius = 400, laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "destroy_surpriseattack:npe_med_main_2c", triggerOn = 2,
				triggerEndsMission = 0, triggerDelay = 3, autoReward = 0, questDelay = 0,
			},
			{navPoints = "space_ord_mantell:npe_med_main_patrol_5"},
			{navPoints = "space_ord_mantell:npe_med_main_patrol_6"},
		},
		["patrol:npe_med_main_2d"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_med_main_3c"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_med_main_4c"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_smuggler_1"] = {
			{
				navPoints = "space_ord_mantell:npe_med_main_recovery_5", navRadius = 100, laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "triggerOn", triggerArg = "delivery_no_pickup:npe_smuggler_2", triggerOn = -1,
				triggerEndsMission = 0, triggerDelay = 5, autoReward = 0, questDelay = 0,
			},
			{navPoints = "space_ord_mantell:npe_hard_main_assassin_5"},
		},
		["patrol:npe_smuggler_3a"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 450, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_training_1"] = {
			{
				navPoints = "space_ord_mantell:npe_train_1", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerArg = "patrol:npe_training_1b", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
		},
		["patrol:npe_training_1b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_training_2"] = {
			{
				navPoints = "space_ord_mantell:npe_hulk_1", navRadius = 150, laps = 1, triggerEvent = "splitquest",
				triggerSplitCondition = "success", triggerArg = "destroy:npe_training_2a", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
		},
		["patrol:npe_training_2b"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_training_3a"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["patrol:npe_training_gamma"] = {
			{
				navPoints = "space_ord_mantell:npe_train_1", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerArg = "patrol:npe_training_1b", triggerOn = 0, triggerEndsMission = 0,
				triggerDelay = 0, autoReward = 0, questDelay = 0,
			},
		},
		["patrol:npe_training_tansarii"] = {
			{
				navPoints = "space_ord_mantell:easy_main_1_stuff", navRadius = 400, laps = 1, triggerEvent = "none",
				triggerSplitCondition = "triggerOn", triggerOn = 0, triggerEndsMission = 1, triggerDelay = 0, autoReward = 0,
				questDelay = 0,
			},
		},
		["recovery:npe_med_main_2"] = {
			{
				escortPath = "space_ord_mantell:npe_med_main_recovery_1", recoveryPath = "space_ord_mantell:npe_med_main_recovery_4",
				targetShipType = "npe_waris_kallor", targetArrivalDelay = 10, targetRecoverTime = 5, recoverFaction = "unattackable",
				targetEscort = "npe_med_blacksun_hunter_tier1", damageMultiplier = 0, hateModifier = 0, numAttackShipLists = 1,
				attackShips1 = "npe_med_blacksun_stalker_tier1", attackPeriod = 60, attackListType = "sequential", numResponses = 2,
				triggerEvent = "splitquest", triggerSplitCondition = "triggerOn", triggerArg = "rescue:npe_med_main_2a",
				triggerOn = -1, autoReward = 0, questDelay = 0,
			},
			{
				escortPath = "space_ord_mantell:npe_med_main_recovery_2", recoveryPath = "space_ord_mantell:npe_med_main_recovery_5",
				attackShips1 = "npe_med_blacksun_stalker_tier1",
			},
			{escortPath = "space_ord_mantell:npe_med_main_recovery_3", recoveryPath = "space_ord_mantell:npe_med_main_recovery_6"},
		},
		["rescue:npe_med_main_2a"] = {
			{
				recoveryPath = "space_ord_mantell:npe_med_main_recovery_7", targetShipType = "npe_sulale_kallor",
				targetArrivalDelay = 0, damageMultiplier = 0, hateModifier = 0, numAttackShipLists = 1,
				attackShips1 = "npe_med_blacksun_stalker_tier1", attackPeriod = 60, attackListType = "sequential", numResponses = 2,
				autoReward = 0, questDelay = 0, triggerEvent = "splitquest", triggerSplitCondition = "triggerOn",
				triggerArg = "patrol:npe_med_main_2b", triggerOn = -1,
			},
			{recoveryPath = "space_ord_mantell:npe_med_main_recovery_8", attackShips1 = "npe_med_blacksun_stalker_tier1"},
			{recoveryPath = "space_ord_mantell:npe_med_main_recovery_9"},
		},
		["rescue:npe_med_main_3a"] = {
			{
				recoveryPath = "space_ord_mantell:npe_med_main_recovery_10", targetShipType = "npe_atris", targetArrivalDelay = 0,
				damageMultiplier = 0, hateModifier = 0, numAttackShipLists = 2, attackShips1 = "npe_blacksun_hunter_tier1",
				attackShips2 = "npe_med_blacksun_stalker_tier1", attackPeriod = 80, attackListType = "sequential", numResponses = 2,
				autoReward = 0, questDelay = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "escort:npe_med_main_3b", triggerOn = -1,
			},
			{
				recoveryPath = "space_ord_mantell:npe_med_main_recovery_11", attackShips1 = "npe_blacksun_hunter_tier1",
				attackShips2 = "npe_med_blacksun_stalker_tier1",
			},
			{attackShips1 = "npe_med_blacksun_stalker_tier1", attackShips2 = "npe_med_blacksun_bomber_tier1"},
			{attackShips1 = "npe_med_blacksun_stalker_tier1"},
		},
		["space_battle:npe_hard_main_3c"] = {
			{
				battlePoint = "space_ord_mantell:npe_hard_final_battle", damageMultiplier = 0, allyArrivalDelay = 5,
				enemyArrivalDelay = 5, allyOriginDist = 2, enemyOriginDist = -1, allyArrivalDist = 0, enemyArrivalDist = 0,
				allyForce = "npe_cardas_destroyer_tier1", enemyForce = "npe_hard_blacksun_bomber_tier1", useConversation = 0,
				convo_delay = 0, triggerEvent = "splitquest", triggerSplitCondition = "success",
				triggerArg = "patrol:npe_hard_main_3d", triggerOn = 0, autoReward = 0, questDelay = 0,
			},
			{allyForce = "npe_cardas_destroyer_tier1", enemyForce = "npe_hard_blacksun_fighter_tier1", convo_delay = 0},
			{allyForce = "npe_cardas_fighter_tier1", enemyForce = "npe_hard_blacksun_fighter_tier1", convo_delay = 0},
			{allyForce = "npe_cardas_fighter_tier1", enemyForce = "npe_hard_blacksun_fighter_tier1", convo_delay = 0},
			{allyForce = "npe_cardas_fighter_tier1", convo_delay = 0},
			{convo_delay = 0},
			{convo_delay = 0},
			{convo_delay = 0},
		},
	},
}

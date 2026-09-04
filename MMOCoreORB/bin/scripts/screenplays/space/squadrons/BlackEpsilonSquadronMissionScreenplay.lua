-- Black Epsilon Squadron missions, reconstructed from the Pre-CU client quest data.

local function blackEpsilonMission(name, base, data)
	data.className = name
	_G[name] = base:new(data)
	registerScreenPlay(name, true)
end

local function chain(data, nextType, nextName, parentClass, parentType, parentName)
	data.sideQuest = nextType ~= nil
	data.sideQuestType = nextType or ""
	data.sideQuestName = nextName or ""
	data.sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION
	data.sideQuestDelay = 5
	data.parentQuest = parentClass or ""
	data.parentQuestType = parentType or ""
	data.parentQuestName = parentName or ""
	return data
end

local corellia = "space_corellia"
local yavin = "space_yavin4"
local lok = "space_lok"
local dantooine = "space_dantooine"
local dathomir = "space_dathomir"

-- Tier 1: Hakasha Sireen.
blackEpsilonMission("patrol_corellia_imperial_1", SpacePatrolScreenplay, chain({
	questName = "corellia_imperial_1", questType = "patrol", questZone = corellia, creditReward = 100,
	patrolPoints = {
		{patrolPointName = "black_epsilon_t1_1_patrol_1", x = -5200, z = -900, y = 3900, patrolNumber = 1, radius = 200},
		{patrolPointName = "black_epsilon_t1_1_patrol_2", x = -3100, z = -300, y = 2100, patrolNumber = 2, radius = 200},
		{patrolPointName = "black_epsilon_t1_1_patrol_3", x = -900, z = 500, y = 300, patrolNumber = 3, radius = 200},
	},
}, "destroy_surpriseattack", "corellia_imperial_1"))

blackEpsilonMission("destroy_surpriseattack_corellia_imperial_1", SpaceSurpriseAttackScreenplay, chain({
	questName = "corellia_imperial_1", questType = "destroy_surpriseattack", questZone = corellia,
	surpriseAttackShips = {zone = corellia, spawns = {{count = 2, shipName = "reb_z95_tier1"}}},
}, nil, nil, "patrol_corellia_imperial_1", "patrol", "corellia_imperial_1"))

blackEpsilonMission("destroy_corellia_imperial_2", SpaceDestroyScreenplay, chain({
	questName = "corellia_imperial_2", questType = "destroy", questZone = corellia, creditReward = 200,
	killsRequired = 4, shipTypes = {"reb_z95_tier1"},
	shipLocations = {{x = 4300, z = 600, y = -3700}, {x = 1700, z = -500, y = -500}, {x = -2400, z = 800, y = 3200}},
}))

blackEpsilonMission("escort_corellia_imperial_3", SpaceEscortScreenplay, chain({
	questName = "corellia_imperial_3", questType = "escort", questZone = corellia, creditReward = 500, escortSpeed = 65,
	escortShips = {"imp_freightermedium_tier1"},
	escortPoints = {
		{patrolPointName = "black_epsilon_t1_3_escort_1", zoneName = corellia, x = -5000, z = 900, y = -3100, escortNumber = 1, radius = 250},
		{patrolPointName = "black_epsilon_t1_3_escort_2", zoneName = corellia, x = -1800, z = 300, y = -900, escortNumber = 2, radius = 250},
		{patrolPointName = "black_epsilon_t1_3_escort_3", zoneName = corellia, x = 2100, z = -400, y = 1700, escortNumber = 3, radius = 250},
	},
	attackDelay = 15, attackShips = {{"reb_z95_tier1", "reb_z95_tier1"}, {"reb_z95_tier1"}},
}))

blackEpsilonMission("assassinate_corellia_imperial_4", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_4", questType = "assassinate", questZone = corellia, creditReward = 1000, arrivalDelay = 5,
	assassinateSpawns = {target = "reb_bwing_tier2", escorts = {"reb_z95_tier1"}},
	targetPatrols = {
		{patrolPointName = "black_epsilon_t1_4_prototype_1", zoneName = corellia, x = -4700, z = 1600, y = 4700},
		{patrolPointName = "black_epsilon_t1_4_prototype_2", zoneName = corellia, x = -1600, z = 900, y = 2200},
		{patrolPointName = "black_epsilon_t1_4_prototype_3", zoneName = corellia, x = 2100, z = 200, y = -800},
	},
}))

-- Tier 2: Prisk Kith'Vys. Four trainer assignments contain all six wiki operations.
blackEpsilonMission("recovery_corellia_imperial_16", SpaceRecoveryScreenplay, chain({
	questName = "corellia_imperial_16", questType = "recovery", questZone = corellia, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 70,
	recoverShip = "reb_freighterheavy_tier2", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"reb_z95_tier2"},
	preRecoveryPoints = {{patrolPointName = "black_epsilon_t2_torton_capture", zoneName = corellia, x = -5500, z = 600, y = 3900, escortNumber = 1, radius = 250}},
	recoveryPoints = {{patrolPointName = "black_epsilon_t2_torton_escape", zoneName = corellia, x = -2800, z = 200, y = 1300, escortNumber = 1, radius = 250}},
	attackDelay = 15, attackShips = {{"reb_z95_tier2"}},
}, "assassinate", "corellia_imperial_12"))

blackEpsilonMission("assassinate_corellia_imperial_12", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_12", questType = "assassinate", questZone = corellia, creditReward = 5000, arrivalDelay = 5,
	assassinateSpawns = {target = "reb_freightermedium_tier3", escorts = {"reb_z95_tier2", "reb_z95_tier2", "reb_z95_tier2", "reb_z95_tier2"}},
	targetPatrols = {{patrolPointName = "black_epsilon_t2_diplomat", zoneName = corellia, x = 3900, z = -1100, y = -4200}},
}, nil, nil, "recovery_corellia_imperial_16", "recovery", "corellia_imperial_16"))

blackEpsilonMission("assassinate_corellia_imperial_14", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_14", questType = "assassinate", questZone = corellia, creditReward = 5000, arrivalDelay = 5,
	assassinateSpawns = {target = "reb_ywing_tier3", escorts = {"reb_ywing_tier2", "reb_ywing_tier2", "reb_ywing_tier2", "reb_ywing_tier2", "reb_ywing_tier2"}},
	targetPatrols = {{patrolPointName = "black_epsilon_t2_bomber_leader", zoneName = corellia, x = -800, z = 1800, y = -5200}},
}))

blackEpsilonMission("patrol_corellia_imperial_15", SpacePatrolScreenplay, chain({
	questName = "corellia_imperial_15", questType = "patrol", questZone = corellia, creditReward = 5000,
	patrolPoints = {
		{patrolPointName = "black_epsilon_t2_patrol_1", x = 5100, z = 1000, y = 3900, patrolNumber = 1, radius = 200},
		{patrolPointName = "black_epsilon_t2_patrol_2", x = 2400, z = 300, y = 1300, patrolNumber = 2, radius = 200},
		{patrolPointName = "black_epsilon_t2_patrol_3", x = -300, z = -500, y = -1200, patrolNumber = 3, radius = 200},
	},
}, "destroy_surpriseattack", "corellia_imperial_15_split"))

blackEpsilonMission("destroy_surpriseattack_corellia_imperial_15_split", SpaceSurpriseAttackScreenplay, chain({
	questName = "corellia_imperial_15_split", questType = "destroy_surpriseattack", questZone = corellia,
	surpriseAttackShips = {zone = corellia, spawns = {{count = 2, shipName = "reb_z95_tier2"}}},
}, nil, nil, "patrol_corellia_imperial_15", "patrol", "corellia_imperial_15"))

blackEpsilonMission("inspect_corellia_imperial_13", SpaceInspectScreenplay, chain({
	questName = "corellia_imperial_13", questType = "inspect", questZone = corellia,
	inspectTargets = {"reb_freightermedium_tier2"}, inspectCargo = "rebel_personnel_dossier", spawnInspectTarget = true,
	targetLocation = {x = -4100, z = -700, y = -4300},
}, "assassinate", "corellia_imperial_17"))

blackEpsilonMission("assassinate_corellia_imperial_17", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_17", questType = "assassinate", questZone = corellia, arrivalDelay = 5,
	assassinateSpawns = {target = "reb_z95_tier2", escorts = {}},
	targetPatrols = {{patrolPointName = "black_epsilon_t2_drone", zoneName = corellia, x = 900, z = 1200, y = 5100}},
}, "destroy", "corellia_imperial_17", "inspect_corellia_imperial_13", "inspect", "corellia_imperial_13"))

blackEpsilonMission("destroy_corellia_imperial_17", SpaceDestroyScreenplay, chain({
	questName = "corellia_imperial_17", questType = "destroy", questZone = corellia,
	killsRequired = 8, shipTypes = {"reb_z95_tier1", "reb_z95_tier2", "reb_ywing_tier1", "reb_ywing_tier2", "reb_awing_tier1", "reb_bwing_tier1"},
	shipLocations = {{x = 3700, z = 900, y = 1000}},
}, nil, nil, "assassinate_corellia_imperial_17", "assassinate", "corellia_imperial_17"))

-- Tier 3: Haymir Rendundi.
blackEpsilonMission("patrol_corellia_imperial_tier3_1", SpacePatrolScreenplay, chain({
	questName = "corellia_imperial_tier3_1", questType = "patrol", questZone = yavin, creditReward = 25000,
	patrolPoints = {{patrolPointName = "black_epsilon_t3_1_patrol_1", x = -5200, z = 1200, y = 4200, patrolNumber = 1, radius = 200}, {patrolPointName = "black_epsilon_t3_1_patrol_2", x = -2100, z = 600, y = 1700, patrolNumber = 2, radius = 200}, {patrolPointName = "black_epsilon_t3_1_patrol_3", x = 900, z = -100, y = -700, patrolNumber = 3, radius = 200}},
}, "inspect", "corellia_imperial_tier3_1_a"))

blackEpsilonMission("inspect_corellia_imperial_tier3_1_a", SpaceInspectScreenplay, chain({
	questName = "corellia_imperial_tier3_1_a", questType = "inspect", questZone = yavin, inspectTargets = {"reb_z95_tier3"}, inspectCargo = "rebel_spy_data", spawnInspectTarget = true, targetLocation = {x = 2200, z = 500, y = -2900},
}, "delivery_no_pickup", "corellia_imperial_tier3_1_b", "patrol_corellia_imperial_tier3_1", "patrol", "corellia_imperial_tier3_1"))

blackEpsilonMission("delivery_no_pickup_corellia_imperial_tier3_1_b", SpaceDeliveryNoPickupScreenplay, chain({
	questName = "corellia_imperial_tier3_1_b", questType = "delivery_no_pickup", questZone = yavin, deliveryShip = "imp_freightermedium_tier3", deliveryPoint = {x = 4700, z = -800, y = -4200}, attackShips = {},
}, "recovery", "corellia_imperial_tier3_1_c", "inspect_corellia_imperial_tier3_1_a", "inspect", "corellia_imperial_tier3_1_a"))

blackEpsilonMission("recovery_corellia_imperial_tier3_1_c", SpaceRecoveryScreenplay, chain({
	questName = "corellia_imperial_tier3_1_c", questType = "recovery", questZone = yavin, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "reb_ywing_tier3", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {"reb_z95_tier3", "reb_z95_tier3"}, preRecoveryPoints = {{patrolPointName = "black_epsilon_t3_1_c_capture", zoneName = yavin, x = 5100, z = 1200, y = 2100, escortNumber = 1, radius = 250}}, recoveryPoints = {{patrolPointName = "black_epsilon_t3_1_c_escape", zoneName = yavin, x = 2800, z = 500, y = 200, escortNumber = 1, radius = 250}}, attackDelay = 15, attackShips = {{"reb_z95_tier3"}},
}, nil, nil, "delivery_no_pickup_corellia_imperial_tier3_1_b", "delivery_no_pickup", "corellia_imperial_tier3_1_b"))

blackEpsilonMission("recovery_corellia_imperial_tier3_2", SpaceRecoveryScreenplay, chain({
	questName = "corellia_imperial_tier3_2", questType = "recovery", questZone = yavin, creditReward = 25000, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "nym_freightermedium_tier3", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {"nym_fighter_tier3", "nym_fighter_tier3"}, preRecoveryPoints = {{patrolPointName = "black_epsilon_t3_2_capture", zoneName = yavin, x = -4400, z = -700, y = 3300, escortNumber = 1, radius = 250}}, recoveryPoints = {{patrolPointName = "black_epsilon_t3_2_escape", zoneName = yavin, x = -1800, z = -200, y = 900, escortNumber = 1, radius = 250}}, attackDelay = 15, attackShips = {{"nym_fighter_tier3"}},
}, "survival", "corellia_imperial_tier3_2_a"))

blackEpsilonMission("survival_corellia_imperial_tier3_2_a", SpaceSurvivalScreenplay, chain({
	questName = "corellia_imperial_tier3_2_a", questType = "survival", questZone = lok, survivalTime = 600, survivalUpdateInterval = 60, survivalPoint = {x = -3600, z = 700, y = 3900}, survivalAreaRadius = 500, attackDelay = 30, attackShips = {{"nym_fighter_tier3", "nym_fighter_tier3"}, {"nym_fighter_tier3", "nym_fighter_tier3", "nym_fighter_tier3"}},
}, "escort", "corellia_imperial_tier3_2_b", "recovery_corellia_imperial_tier3_2", "recovery", "corellia_imperial_tier3_2"))

blackEpsilonMission("escort_corellia_imperial_tier3_2_b", SpaceEscortScreenplay, chain({
	questName = "corellia_imperial_tier3_2_b", questType = "escort", questZone = lok, escortSpeed = 75, escortShips = {"nym_freightermedium_tier3"}, escortPoints = {{patrolPointName = "black_epsilon_t3_2_b_1", zoneName = lok, x = -4300, z = 600, y = 2600, escortNumber = 1, radius = 250}, {patrolPointName = "black_epsilon_t3_2_b_2", zoneName = lok, x = -900, z = 100, y = 300, escortNumber = 2, radius = 250}, {patrolPointName = "black_epsilon_t3_2_b_3", zoneName = lok, x = 2800, z = -600, y = -2200, escortNumber = 3, radius = 250}}, attackDelay = 20, attackShips = {{"nym_fighter_tier3", "nym_fighter_tier3"}, {"nym_fighter_tier3", "nym_fighter_tier3"}},
}, "space_battle", "corellia_imperial_tier3_2_c", "survival_corellia_imperial_tier3_2_a", "survival", "corellia_imperial_tier3_2_a"))

blackEpsilonMission("space_battle_corellia_imperial_tier3_2_c", SpaceBattleScreenplay, chain({
	questName = "corellia_imperial_tier3_2_c", questType = "space_battle", questZone = lok, battleLocation = {x = 3900, z = 500, y = 3600}, allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -700, enemyOriginDist = 900, allyArrivalDist = -100, enemyArrivalDist = 0, alliedShips = {{"imp_tie_fighter_tier3"}, {"imp_tie_fighter_tier3"}, {"imp_tie_bomber_tier3"}}, enemyShips = {{"nym_fighter_tier3"}, {"nym_fighter_tier3"}, {"nym_fighter_tier3"}, {"nym_fighter_tier3"}, {"nym_freightermedium_tier3"}},
}, nil, nil, "escort_corellia_imperial_tier3_2_b", "escort", "corellia_imperial_tier3_2_b"))

blackEpsilonMission("rescue_corellia_imperial_tier3_3", SpaceRescueScreenplay, chain({
	questName = "corellia_imperial_tier3_3", questType = "rescue", questZone = yavin, creditReward = 25000, arrivalDelay = 5, rescueShip = "imp_freightermedium_tier3", rescueLocation = {x = -4900, z = 900, y = -3600}, repairDelay = 20, escortSpeed = 75, escortPoints = {{patrolPointName = "black_epsilon_t3_3_escape", zoneName = yavin, x = -1800, z = 200, y = -900, escortNumber = 1, radius = 250}}, escortAttackDelay = 15, escortAttackShips = {{{count = 2, shipName = "reb_z95_tier3"}}},
}, "assassinate", "corellia_imperial_tier3_3_a"))

blackEpsilonMission("assassinate_corellia_imperial_tier3_3_a", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_tier3_3_a", questType = "assassinate", questZone = yavin, arrivalDelay = 5, assassinateSpawns = {target = "reb_freighterlight_tier3", escorts = {"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3"}}, targetPatrols = {{patrolPointName = "black_epsilon_t3_3_emissary", zoneName = yavin, x = 3800, z = 1400, y = 4600}},
}, nil, nil, "rescue_corellia_imperial_tier3_3", "rescue", "corellia_imperial_tier3_3"))

blackEpsilonMission("recovery_corellia_imperial_tier3_4", SpaceRecoveryScreenplay, chain({
	questName = "corellia_imperial_tier3_4", questType = "recovery", questZone = lok, creditReward = 25000, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "nym_freightermedium_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {"nym_fighter_tier3", "nym_fighter_tier3"}, preRecoveryPoints = {{patrolPointName = "black_epsilon_t3_4_capture", zoneName = lok, x = -5300, z = 800, y = -3300, escortNumber = 1, radius = 250}}, recoveryPoints = {{patrolPointName = "black_epsilon_t3_4_escape", zoneName = lok, x = -2300, z = 300, y = -600, escortNumber = 1, radius = 250}}, attackDelay = 15, attackShips = {{"nym_fighter_tier3"}},
}, "assassinate", "corellia_imperial_tier3_4_a"))

blackEpsilonMission("assassinate_corellia_imperial_tier3_4_a", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_tier3_4_a", questType = "assassinate", questZone = lok, arrivalDelay = 5, assassinateSpawns = {target = "nym_freighterlight_tier4", escorts = {"nym_fighter_tier3", "nym_fighter_tier3", "nym_fighter_tier3", "nym_fighter_tier3", "nym_fighter_tier3"}}, targetPatrols = {{patrolPointName = "black_epsilon_t3_4_patrol_craft", zoneName = lok, x = 1000, z = 1200, y = -4900}},
}, "survival", "corellia_imperial_tier3_4_b", "recovery_corellia_imperial_tier3_4", "recovery", "corellia_imperial_tier3_4"))

blackEpsilonMission("survival_corellia_imperial_tier3_4_b", SpaceSurvivalScreenplay, chain({
	questName = "corellia_imperial_tier3_4_b", questType = "survival", questZone = lok, survivalTime = 600, survivalUpdateInterval = 60, survivalPoint = {x = 3300, z = 200, y = -500}, survivalAreaRadius = 500, attackDelay = 30, attackShips = {{"nym_fighter_tier3", "nym_fighter_tier3"}, {"nym_fighter_tier3", "nym_fighter_tier3", "nym_fighter_tier3"}},
}, "assassinate", "corellia_imperial_tier3_4_c", "assassinate_corellia_imperial_tier3_4_a", "assassinate", "corellia_imperial_tier3_4_a"))

blackEpsilonMission("assassinate_corellia_imperial_tier3_4_c", SpaceAssassinateScreenplay, chain({
	questName = "corellia_imperial_tier3_4_c", questType = "assassinate", questZone = lok, arrivalDelay = 5, assassinateSpawns = {target = "nym_enforcer_tier4", escorts = {"nym_fighter_tier4", "nym_fighter_tier4", "nym_fighter_tier4"}}, targetPatrols = {{patrolPointName = "black_epsilon_t3_4_queen", zoneName = lok, x = 5200, z = -900, y = 3800}},
}, nil, nil, "survival_corellia_imperial_tier3_4_b", "survival", "corellia_imperial_tier3_4_b"))

-- Tier 4: Insurgent.
blackEpsilonMission("patrol_corellia_imperial_tier4_1", SpacePatrolScreenplay, chain({questName = "corellia_imperial_tier4_1", questType = "patrol", questZone = dantooine, creditReward = 10000, patrolPoints = {{patrolPointName = "black_epsilon_t4_1_patrol_1", x = -5000, z = 1400, y = 3900, patrolNumber = 1, radius = 200}, {patrolPointName = "black_epsilon_t4_1_patrol_2", x = -2200, z = 700, y = 1200, patrolNumber = 2, radius = 200}, {patrolPointName = "black_epsilon_t4_1_patrol_3", x = 800, z = 0, y = -1500, patrolNumber = 3, radius = 200}}}, "inspect", "corellia_imperial_tier4_1_a"))
blackEpsilonMission("inspect_corellia_imperial_tier4_1_a", SpaceInspectScreenplay, chain({questName = "corellia_imperial_tier4_1_a", questType = "inspect", questZone = dantooine, inspectTargets = {"blacksun_fighter_s02_tier4"}, inspectCargo = "velocity_orders", spawnInspectTarget = true, targetLocation = {x = 2700, z = 500, y = -3400}}, "survival", "corellia_imperial_tier4_1_b", "patrol_corellia_imperial_tier4_1", "patrol", "corellia_imperial_tier4_1"))
blackEpsilonMission("survival_corellia_imperial_tier4_1_b", SpaceSurvivalScreenplay, chain({questName = "corellia_imperial_tier4_1_b", questType = "survival", questZone = dantooine, survivalTime = 600, survivalUpdateInterval = 60, survivalPoint = {x = 4700, z = 300, y = 800}, survivalAreaRadius = 500, attackDelay = 30, attackShips = {{"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}, {"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4"}}}, nil, nil, "inspect_corellia_imperial_tier4_1_a", "inspect", "corellia_imperial_tier4_1_a"))

blackEpsilonMission("recovery_corellia_imperial_tier4_2", SpaceRecoveryScreenplay, chain({questName = "corellia_imperial_tier4_2", questType = "recovery", questZone = dantooine, creditReward = 10000, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "reb_freightermedium_tier3", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}, preRecoveryPoints = {{patrolPointName = "black_epsilon_t4_2_capture", zoneName = dantooine, x = -4800, z = -500, y = 4200, escortNumber = 1, radius = 250}}, recoveryPoints = {{patrolPointName = "black_epsilon_t4_2_escape", zoneName = dantooine, x = -1700, z = 0, y = 1200, escortNumber = 1, radius = 250}}, attackDelay = 15, attackShips = {{"blacksun_fighter_s02_tier4"}}}, "inspect", "corellia_imperial_tier4_2_a"))
blackEpsilonMission("inspect_corellia_imperial_tier4_2_a", SpaceInspectScreenplay, chain({questName = "corellia_imperial_tier4_2_a", questType = "inspect", questZone = dantooine, inspectTargets = {"blacksun_fighter_s03_tier4"}, inspectCargo = "velocity_group_orders", spawnInspectTarget = true, targetLocation = {x = 1600, z = 1000, y = 3900}}, "delivery_no_pickup", "corellia_imperial_tier4_2_b", "recovery_corellia_imperial_tier4_2", "recovery", "corellia_imperial_tier4_2"))
blackEpsilonMission("delivery_no_pickup_corellia_imperial_tier4_2_b", SpaceDeliveryNoPickupScreenplay, chain({questName = "corellia_imperial_tier4_2_b", questType = "delivery_no_pickup", questZone = dantooine, deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = 4900, z = -700, y = -3000}, attackShips = {}}, nil, nil, "inspect_corellia_imperial_tier4_2_a", "inspect", "corellia_imperial_tier4_2_a"))

blackEpsilonMission("escort_corellia_imperial_tier4_3", SpaceEscortScreenplay, chain({questName = "corellia_imperial_tier4_3", questType = "escort", questZone = dathomir, creditReward = 10000, escortSpeed = 75, escortShips = {"imp_lambda_shuttle_tier4"}, escortPoints = {{patrolPointName = "black_epsilon_t4_3_escort_1", zoneName = dathomir, x = -5100, z = 1800, y = -3900, escortNumber = 1, radius = 250}, {patrolPointName = "black_epsilon_t4_3_escort_2", zoneName = dathomir, x = -1700, z = 900, y = -900, escortNumber = 2, radius = 250}, {patrolPointName = "black_epsilon_t4_3_escort_3", zoneName = dathomir, x = 2600, z = -300, y = 2600, escortNumber = 3, radius = 250}}, attackDelay = 20, attackShips = {{"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}, {"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"}}}, "rescue", "corellia_imperial_tier4_3_a"))
blackEpsilonMission("rescue_corellia_imperial_tier4_3_a", SpaceRescueScreenplay, chain({questName = "corellia_imperial_tier4_3_a", questType = "rescue", questZone = dathomir, arrivalDelay = 5, rescueShip = "imp_lambda_shuttle_tier4", rescueLocation = {x = 4300, z = -1200, y = 3900}, repairDelay = 20, escortSpeed = 75, escortPoints = {{patrolPointName = "black_epsilon_t4_3_a_escape", zoneName = dathomir, x = 1800, z = -500, y = 1400, escortNumber = 1, radius = 250}}, escortAttackDelay = 15, escortAttackShips = {{{count = 3, shipName = "blacksun_fighter_s02_tier4"}}}}, "patrol", "corellia_imperial_tier4_3_b", "escort_corellia_imperial_tier4_3", "escort", "corellia_imperial_tier4_3"))
blackEpsilonMission("patrol_corellia_imperial_tier4_3_b", SpacePatrolScreenplay, chain({questName = "corellia_imperial_tier4_3_b", questType = "patrol", questZone = dathomir, patrolPoints = {{patrolPointName = "black_epsilon_t4_3_b_patrol_1", x = 900, z = 1500, y = -4500, patrolNumber = 1, radius = 200}, {patrolPointName = "black_epsilon_t4_3_b_patrol_2", x = -1900, z = 700, y = -1800, patrolNumber = 2, radius = 200}, {patrolPointName = "black_epsilon_t4_3_b_patrol_3", x = -4600, z = -100, y = 1000, patrolNumber = 3, radius = 200}}}, "inspect", "corellia_imperial_tier4_3_c", "rescue_corellia_imperial_tier4_3_a", "rescue", "corellia_imperial_tier4_3_a"))
blackEpsilonMission("inspect_corellia_imperial_tier4_3_c", SpaceInspectScreenplay, chain({questName = "corellia_imperial_tier4_3_c", questType = "inspect", questZone = dathomir, inspectTargets = {"blacksun_fighter_s03_tier4"}, inspectCargo = "velocity_commander_orders", spawnInspectTarget = true, targetLocation = {x = -5100, z = 900, y = 3800}}, nil, nil, "patrol_corellia_imperial_tier4_3_b", "patrol", "corellia_imperial_tier4_3_b"))

blackEpsilonMission("assassinate_corellia_imperial_tier4_4", SpaceAssassinateScreenplay, chain({questName = "corellia_imperial_tier4_4", questType = "assassinate", questZone = dathomir, creditReward = 10000, arrivalDelay = 5, assassinateSpawns = {target = "blacksun_fighter_s03_tier4", escorts = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}}, targetPatrols = {{patrolPointName = "black_epsilon_t4_4_neja", zoneName = dathomir, x = -5000, z = 1500, y = -4000}}}, "recovery", "corellia_imperial_tier4_4_a"))
blackEpsilonMission("recovery_corellia_imperial_tier4_4_a", SpaceRecoveryScreenplay, chain({questName = "corellia_imperial_tier4_4_a", questType = "recovery", questZone = dathomir, arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "blacksun_marauder_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}, preRecoveryPoints = {{patrolPointName = "black_epsilon_t4_4_a_capture", zoneName = dathomir, x = -1800, z = 800, y = -900, escortNumber = 1, radius = 250}}, recoveryPoints = {{patrolPointName = "black_epsilon_t4_4_a_escape", zoneName = dathomir, x = 1300, z = 100, y = 1700, escortNumber = 1, radius = 250}}, attackDelay = 15, attackShips = {{"blacksun_fighter_s02_tier4"}}}, "destroy_surpriseattack", "corellia_imperial_tier4_4_b", "assassinate_corellia_imperial_tier4_4", "assassinate", "corellia_imperial_tier4_4"))
blackEpsilonMission("destroy_surpriseattack_corellia_imperial_tier4_4_b", SpaceSurpriseAttackScreenplay, chain({questName = "corellia_imperial_tier4_4_b", questType = "destroy_surpriseattack", questZone = dathomir, surpriseAttackShips = {zone = dathomir, spawns = {{count = 5, shipName = "blacksun_fighter_s02_tier4"}}}}, "space_battle", "corellia_imperial_tier4_4_c", "recovery_corellia_imperial_tier4_4_a", "recovery", "corellia_imperial_tier4_4_a"))
blackEpsilonMission("space_battle_corellia_imperial_tier4_4_c", SpaceBattleScreenplay, chain({questName = "corellia_imperial_tier4_4_c", questType = "space_battle", questZone = dathomir, battleLocation = {x = 3500, z = 600, y = -3100}, allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -700, enemyOriginDist = 900, allyArrivalDist = -100, enemyArrivalDist = 0, alliedShips = {{"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_bomber_tier4"}}, enemyShips = {{"blacksun_fighter_s01_tier4"}, {"blacksun_fighter_s01_tier4"}, {"blacksun_fighter_s02_tier4"}, {"blacksun_fighter_s02_tier4"}, {"blacksun_fighter_s03_tier4"}, {"blacksun_marauder_tier4"}}}, "assassinate", "corellia_imperial_tier4_4_d", "destroy_surpriseattack_corellia_imperial_tier4_4_b", "destroy_surpriseattack", "corellia_imperial_tier4_4_b"))
blackEpsilonMission("assassinate_corellia_imperial_tier4_4_d", SpaceAssassinateScreenplay, chain({questName = "corellia_imperial_tier4_4_d", questType = "assassinate", questZone = dathomir, arrivalDelay = 5, assassinateSpawns = {target = "blacksun_vehement_tier4", escorts = {"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}}, targetPatrols = {{patrolPointName = "black_epsilon_t4_4_onli", zoneName = dathomir, x = 5400, z = -1000, y = 4100}}}, nil, nil, "space_battle_corellia_imperial_tier4_4_c", "space_battle", "corellia_imperial_tier4_4_c"))

-- Compatibility aliases used by the existing trainer conversation actions/rewards.
inspect_corellia_imperial_tier2_1 = assassinate_corellia_imperial_12
escort_corellia_imperial_tier2_2 = assassinate_corellia_imperial_14
recovery_corellia_imperial_tier2_3 = patrol_corellia_imperial_15
assassinate_corellia_imperial_tier2_4 = inspect_corellia_imperial_13
recovery_corellia_imperial_tier3_1 = patrol_corellia_imperial_tier3_1
inspect_corellia_imperial_tier3_2 = recovery_corellia_imperial_tier3_2
delivery_corellia_imperial_tier3_3 = rescue_corellia_imperial_tier3_3
assassinate_corellia_imperial_tier3_4 = recovery_corellia_imperial_tier3_4
survival_corellia_imperial_tier4_1 = patrol_corellia_imperial_tier4_1
assassinate_corellia_imperial_tier4_2 = recovery_corellia_imperial_tier4_2
space_battle_corellia_imperial_tier4_3 = escort_corellia_imperial_tier4_3
recovery_corellia_imperial_tier4_4 = assassinate_corellia_imperial_tier4_4
patrol_corellia_imperial_3 = escort_corellia_imperial_3

-- Duty missions use their own client rows and remain repeatable.
blackEpsilonMission("destroy_duty_corellia_imperial_6", SpaceDutyDestroyScreenplay, {
	questName = "corellia_imperial_6", questType = "destroy_duty", questZone = corellia, creditReward = 100,
	sideQuest = false, sideQuestType = "", totalLevels = 5, totalRounds = 2, totalWaves = 3,
	minDistance = 12500, maxDistance = 17500, bossShip = "reb_bwing_tier2", shipTypes = {{"reb_z95_tier1"}},
})
blackEpsilonMission("escort_duty_corellia_imperial_7", SpaceDutyEscortScreenplay, {
	questName = "corellia_imperial_7", questType = "escort_duty", questZone = corellia, creditReward = 1000, creditKillBonus = 100,
	itemReward = {}, sideQuest = false, sideQuestType = "", escortShips = {"imp_transport_tier1", "imp_freightermedium_tier1", "imp_freighterlight_tier1"}, escortSpeed = 65,
	escortPoints = {{patrolPointName = "black_epsilon_t1_duty_escort_1", zoneName = corellia, x = -5200, z = 500, y = -3500, escortNumber = 1, radius = 250}, {patrolPointName = "black_epsilon_t1_duty_escort_2", zoneName = corellia, x = -900, z = 100, y = -400, escortNumber = 2, radius = 250}, {patrolPointName = "black_epsilon_t1_duty_escort_3", zoneName = corellia, x = 3700, z = -500, y = 2900, escortNumber = 3, radius = 250}},
	attackDelay = 25, attackShips = {{"reb_z95_tier1", "reb_z95_tier1"}, {"reb_z95_tier1", "reb_z95_tier1"}},
})

local function tier2DestroyDuty(name, boss, ships)
	blackEpsilonMission("destroy_duty_" .. name, SpaceDutyDestroyScreenplay, {questName = name, questType = "destroy_duty", questZone = corellia, creditReward = 200, sideQuest = false, sideQuestType = "", totalLevels = 5, totalRounds = 2, totalWaves = 3, minDistance = 12500, maxDistance = 17500, bossShip = boss, shipTypes = ships})
end
tier2DestroyDuty("corellia_imperial_8", "blacksun_bomber_s01_tier2", {{"blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier2"}})
tier2DestroyDuty("corellia_imperial_10", "reb_ywing_tier3", {{"reb_z95_tier2", "reb_ywing_tier2"}})

local function tier2EscortDuty(name, ships)
	blackEpsilonMission("escort_duty_" .. name, SpaceDutyEscortScreenplay, {questName = name, questType = "escort_duty", questZone = corellia, creditReward = 2500, creditKillBonus = 200, itemReward = {}, sideQuest = false, sideQuestType = "", escortShips = ships, escortSpeed = 70, escortPoints = {{patrolPointName = name .. "_route_1", zoneName = corellia, x = -4800, z = 800, y = 3800, escortNumber = 1, radius = 250}, {patrolPointName = name .. "_route_2", zoneName = corellia, x = -1000, z = 100, y = 500, escortNumber = 2, radius = 250}, {patrolPointName = name .. "_route_3", zoneName = corellia, x = 3500, z = -700, y = -3100, escortNumber = 3, radius = 250}}, attackDelay = 25, attackShips = {{"reb_z95_tier2", "reb_z95_tier2"}, {"reb_ywing_tier2", "reb_z95_tier2"}}})
end
tier2EscortDuty("corellia_imperial_9", {"imp_freighterlight_tier2", "imp_freightermedium_tier2"})
tier2EscortDuty("corellia_imperial_11", {"imp_transport_tier2", "imp_freightermedium_tier2"})

destroy_duty_corellia_imperial_tier2_destroyduty = destroy_duty_corellia_imperial_8
recovery_duty_corellia_imperial_tier2_recoveryduty = escort_duty_corellia_imperial_9
escort_duty_corellia_imperial_tier2_escortduty = destroy_duty_corellia_imperial_10

blackEpsilonMission("destroy_duty_corellia_imperial_tier4_1", SpaceDutyDestroyScreenplay, {questName = "corellia_imperial_tier4_1", questType = "destroy_duty", questZone = dantooine, creditReward = 500, sideQuest = false, sideQuestType = "", totalLevels = 5, totalRounds = 2, totalWaves = 4, minDistance = 12500, maxDistance = 17500, bossShip = "blacksun_marauder_tier4", shipTypes = {{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4"}}})
blackEpsilonMission("escort_duty_corellia_imperial_tier4_2", SpaceDutyEscortScreenplay, {questName = "corellia_imperial_tier4_2", questType = "escort_duty", questZone = dantooine, creditReward = 5000, creditKillBonus = 300, itemReward = {}, sideQuest = false, sideQuestType = "", escortShips = {"imp_freighterheavy_tier4", "imp_freightermedium_tier4"}, escortSpeed = 75, escortPoints = {{patrolPointName = "black_epsilon_t4_duty_escort_1", zoneName = dantooine, x = -5000, z = 900, y = -3700, escortNumber = 1, radius = 250}, {patrolPointName = "black_epsilon_t4_duty_escort_2", zoneName = dantooine, x = -900, z = 100, y = -300, escortNumber = 2, radius = 250}, {patrolPointName = "black_epsilon_t4_duty_escort_3", zoneName = dantooine, x = 3900, z = -700, y = 3300, escortNumber = 3, radius = 250}}, attackDelay = 25, attackShips = {{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4"}, {"blacksun_fighter_s02_tier4", "blacksun_fighter_s03_tier4"}}})

blackEpsilonMission("recovery_duty_corellia_imperial_tier4_3", SpaceDutyRecoveryScreenplay, {
	questName = "corellia_imperial_tier4_3", questType = "recovery_duty", questZone = dantooine, creditReward = 5000, creditKillBonus = 300,
	sideQuest = false, sideQuestType = "", arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75,
	recoverShip = "blacksun_marauder_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"blacksun_fighter_s02_tier4"},
	preRecoveryPoints = {{patrolPointName = "black_epsilon_t4_duty_recovery_capture", zoneName = dantooine, x = -4200, z = 600, y = 3300, escortNumber = 1, radius = 250}},
	recoveryPoints = {{patrolPointName = "black_epsilon_t4_duty_recovery_escape", zoneName = dantooine, x = -900, z = 100, y = 300, escortNumber = 1, radius = 250}},
	attackDelay = 20, attackShips = {{"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}},
})
blackEpsilonMission("rescue_duty_corellia_imperial_tier4_4", SpaceDutyRescueScreenplay, {
	questName = "corellia_imperial_tier4_4", questType = "rescue_duty", questZone = dantooine, creditReward = 5000, creditKillBonus = 300,
	sideQuest = false, sideQuestType = "", arrivalDelay = 5, rescueShip = "imp_freightermedium_tier4",
	rescueLocation = {x = 4300, z = -600, y = -3500}, repairDelay = 20, escortSpeed = 75,
	escortPoints = {{patrolPointName = "black_epsilon_t4_duty_rescue_escape", zoneName = dantooine, x = 1200, z = 0, y = -700, escortNumber = 1, radius = 250}},
	escortAttackDelay = 15, escortAttackShips = {{{count = 3, shipName = "blacksun_fighter_s02_tier4"}}},
})

-- Compatibility names retained for old conversation screen IDs.
escort_duty_corellia_imperial_tier4_1 = destroy_duty_corellia_imperial_tier4_1
rescue_duty_corellia_imperial_tier4_1 = escort_duty_corellia_imperial_tier4_2
recovery_duty_corellia_imperial_tier4_1 = recovery_duty_corellia_imperial_tier4_3

-- Storm Squadron tier 4: Admiral Kilnstrider's Endor/Dantooine campaign.
-- Every quest type/name pair below exists in the Pre-CU client data.

local function stormT4(name, base, data)
	data.className = name
	_G[name] = base:new(data)
	registerScreenPlay(name, true)
end

local function links(data, nextType, nextName, parentClass, parentType, parentName)
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

-- Mission 1: satellite patrol, ambush, fleet battle, inspection and delivery.
stormT4("patrol_tatooine_imperial_tier4_1", SpacePatrolScreenplay, links({
	questName = "tatooine_imperial_tier4_1", questType = "patrol", questZone = "space_endor", creditReward = 10000,
	patrolPoints = {
		{patrolPointName = "storm_t4_1_satellite_1", x = -5520, z = 1850, y = 4680, patrolNumber = 1, radius = 200},
		{patrolPointName = "storm_t4_1_satellite_2", x = -3400, z = 1320, y = 2810, patrolNumber = 2, radius = 200},
		{patrolPointName = "storm_t4_1_satellite_3", x = -1120, z = 650, y = 750, patrolNumber = 3, radius = 200},
	},
}, "destroy_surpriseattack", "tatooine_imperial_tier4_1_a"))

stormT4("destroy_surpriseattack_tatooine_imperial_tier4_1_a", SpaceSurpriseAttackScreenplay, links({
	questName = "tatooine_imperial_tier4_1_a", questType = "destroy_surpriseattack", questZone = "space_endor",
	surpriseAttackShips = {zone = "space_endor", spawns = {{count = 5, shipName = "reb_awing_tier4"}}},
}, "space_battle", "tatooine_imperial_tier4_1_b", "patrol_tatooine_imperial_tier4_1", "patrol", "tatooine_imperial_tier4_1"))

stormT4("space_battle_tatooine_imperial_tier4_1_b", SpaceBattleScreenplay, links({
	questName = "tatooine_imperial_tier4_1_b", questType = "space_battle", questZone = "space_endor", battleLocation = {x = 850, z = 400, y = -900},
	allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -700, enemyOriginDist = 900, allyArrivalDist = -100, enemyArrivalDist = 0,
	alliedShips = {{"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_oppressor_tier4"}, {"imp_tie_oppressor_tier4"}, {"imp_decimator_tier4"}},
	enemyShips = {{"reb_ywing_tier4"}, {"reb_ywing_tier4"}, {"reb_ywing_tier4"}, {"reb_ywing_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_ykl37r_tier4"}, {"reb_ykl37r_tier4"}},
}, "inspect", "tatooine_imperial_tier4_1_c", "destroy_surpriseattack_tatooine_imperial_tier4_1_a", "destroy_surpriseattack", "tatooine_imperial_tier4_1_a"))

stormT4("inspect_tatooine_imperial_tier4_1_c", SpaceInspectScreenplay, links({
	questName = "tatooine_imperial_tier4_1_c", questType = "inspect", questZone = "space_endor",
	inspectTargets = {"reb_awing_tier4"}, inspectCargo = "rebel_plans", spawnInspectTarget = true, targetLocation = {x = 1825, z = 250, y = -1750},
}, "delivery_no_pickup", "tatooine_imperial_tier4_1_d", "space_battle_tatooine_imperial_tier4_1_b", "space_battle", "tatooine_imperial_tier4_1_b"))

stormT4("delivery_no_pickup_tatooine_imperial_tier4_1_d", SpaceDeliveryNoPickupScreenplay, links({
	questName = "tatooine_imperial_tier4_1_d", questType = "delivery_no_pickup", questZone = "space_endor",
	deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = 3650, z = 1200, y = -4250}, attackShips = {},
}, nil, nil, "inspect_tatooine_imperial_tier4_1_c", "inspect", "tatooine_imperial_tier4_1_c"))

-- Mission 2: recover both engineers and protect both satellite deliveries.
local function engineerRecovery(name, nextType, nextName, parentClass, parentName, point, escape, attacker)
	stormT4("recovery_" .. name, SpaceRecoveryScreenplay, links({
		questName = name, questType = "recovery", questZone = "space_endor", creditReward = parentClass == nil and 10000 or 0,
		arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75, recoverShip = "reb_transport_tier4",
		recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
		escortShips = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"},
		preRecoveryPoints = {{patrolPointName = name .. "_capture", zoneName = "space_endor", x = point[1], z = point[2], y = point[3], escortNumber = 1, radius = 250}},
		recoveryPoints = {{patrolPointName = name .. "_escape", zoneName = "space_endor", x = escape[1], z = escape[2], y = escape[3], escortNumber = 1, radius = 250}},
		attackDelay = 20, attackShips = {{attacker}},
	}, nextType, nextName, parentClass, parentClass and "recovery" or nil, parentName))
end

engineerRecovery("tatooine_imperial_tier4_2", "recovery", "tatooine_imperial_tier4_2_a", nil, nil, {-6100, -1800, 4100}, {-3600, -1300, 2450}, "reb_z95_tier4")
engineerRecovery("tatooine_imperial_tier4_2_a", "delivery", "tatooine_imperial_tier4_2_b", "recovery_tatooine_imperial_tier4_2", "tatooine_imperial_tier4_2", {4200, 800, 5100}, {2100, 500, 3150}, "reb_awing_tier4")

stormT4("delivery_tatooine_imperial_tier4_2_b", SpaceDeliveryScreenplay, links({
	questName = "tatooine_imperial_tier4_2_b", questType = "delivery", questZone = "space_endor",
	pickupShip = "imp_freightermedium_tier4", deliveryShip = "reb_transport_tier4", pickupPoint = {x = -750, z = 900, y = -5100}, deliveryPoint = {x = -3600, z = -1300, y = 2450},
	attackDelay = 35, waitForAttackShips = true,
	attackShips = {{"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_ywing_tier4", "reb_ywing_tier4"}, {"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4"}, {"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_bwing_tier4", "reb_bwing_tier4"}},
}, "recovery", "tatooine_imperial_tier4_2_c", "recovery_tatooine_imperial_tier4_2_a", "recovery", "tatooine_imperial_tier4_2_a"))

stormT4("recovery_tatooine_imperial_tier4_2_c", SpaceRecoveryScreenplay, links({
	questName = "tatooine_imperial_tier4_2_c", questType = "recovery", questZone = "space_endor", arrivalDelay = 5, recoveryDelay = 10, escortSpeed = 75,
	recoverShip = "reb_transport_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff", escortShips = {},
	preRecoveryPoints = {{patrolPointName = "storm_t4_2_c_engineer", zoneName = "space_endor", x = 2100, z = 500, y = 3150, escortNumber = 1, radius = 250}},
	recoveryPoints = {
		{patrolPointName = "storm_t4_2_c_route_1", zoneName = "space_endor", x = 3000, z = 250, y = 1800, escortNumber = 1, radius = 250},
		{patrolPointName = "storm_t4_2_c_route_2", zoneName = "space_endor", x = 4100, z = -150, y = 200, escortNumber = 2, radius = 250},
		{patrolPointName = "storm_t4_2_c_route_3", zoneName = "space_endor", x = 5200, z = -600, y = -1600, escortNumber = 3, radius = 250},
	},
	attackDelay = 35, attackShips = {{"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_ywing_tier4", "reb_ywing_tier4"}, {"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_bwing_tier4", "reb_bwing_tier4"}, {"reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4"}},
}, nil, nil, "delivery_tatooine_imperial_tier4_2_b", "delivery", "tatooine_imperial_tier4_2_b"))

-- Mission 3: escort, rescue, fleet battle.
stormT4("escort_tatooine_imperial_tier4_3", SpaceEscortScreenplay, links({
	questName = "tatooine_imperial_tier4_3", questType = "escort", questZone = "space_endor", creditReward = 10000,
	escortShips = {"imp_lambda_shuttle_tier4"}, escortSpeed = 75,
	escortPoints = {
		{patrolPointName = "storm_t4_3_escort_1", zoneName = "space_endor", x = -5200, z = 3400, y = -4000, escortNumber = 1, radius = 250},
		{patrolPointName = "storm_t4_3_escort_2", zoneName = "space_endor", x = -2600, z = 2500, y = -2100, escortNumber = 2, radius = 250},
		{patrolPointName = "storm_t4_3_escort_3", zoneName = "space_endor", x = 300, z = 1500, y = -300, escortNumber = 3, radius = 250},
		{patrolPointName = "storm_t4_3_escort_4", zoneName = "space_endor", x = 3200, z = 700, y = 1800, escortNumber = 4, radius = 250},
	},
	attackDelay = 45, attackShips = {{"reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4"}, {"reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4"}, {"reb_ywing_tier4", "reb_ywing_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4"}, {"reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_awing_tier4"}},
}, "rescue", "tatooine_imperial_tier4_3_a"))

stormT4("rescue_tatooine_imperial_tier4_3_a", SpaceRescueScreenplay, links({
	questName = "tatooine_imperial_tier4_3_a", questType = "rescue", questZone = "space_endor", arrivalDelay = 5,
	rescueShip = "imp_lambda_shuttle_tier4", rescueLocation = {x = 5000, z = -2100, y = -4400}, repairDelay = 20, escortSpeed = 75,
	escortPoints = {{patrolPointName = "storm_t4_3_a_escape", zoneName = "space_endor", x = 2700, z = -1200, y = -2300, escortNumber = 1, radius = 250}},
	escortAttackDelay = 15, escortAttackShips = {{{count = 1, shipName = "reb_z95_tier4"}}},
}, "space_battle", "tatooine_imperial_tier4_3_b", "escort_tatooine_imperial_tier4_3", "escort", "tatooine_imperial_tier4_3"))

stormT4("space_battle_tatooine_imperial_tier4_3_b", SpaceBattleScreenplay, links({
	questName = "tatooine_imperial_tier4_3_b", questType = "space_battle", questZone = "space_endor", battleLocation = {x = 600, z = -800, y = 5600},
	allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -700, enemyOriginDist = 900, allyArrivalDist = -100, enemyArrivalDist = 0,
	alliedShips = {{"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_imperial_gunboat_tier4"}},
	enemyShips = {{"reb_bwing_tier4"}, {"reb_bwing_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_z95_tier4"}, {"reb_awing_tier4"}, {"reb_awing_tier4"}, {"reb_gunboat_tier4"}, {"reb_gunboat_tier4"}},
}, nil, nil, "rescue_tatooine_imperial_tier4_3_a", "rescue", "tatooine_imperial_tier4_3_a"))

-- Mission 4: destroy two transports, recover the third, destroy Nova Holiday.
stormT4("assassinate_tatooine_imperial_tier4_4", SpaceAssassinateScreenplay, links({
	questName = "tatooine_imperial_tier4_4", questType = "assassinate", questZone = "space_dantooine", creditReward = 10000,
	arrivalDelay = 5,
	assassinateSpawns = {target = "reb_transport_tier4", escorts = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}},
	targetPatrols = {{patrolPointName = "storm_t4_4_first_transport", zoneName = "space_dantooine", x = -6100, z = 3100, y = 900}},
}, "assassinate", "tatooine_imperial_tier4_4_a"))

stormT4("assassinate_tatooine_imperial_tier4_4_a", SpaceAssassinateScreenplay, links({
	questName = "tatooine_imperial_tier4_4_a", questType = "assassinate", questZone = "space_dantooine", arrivalDelay = 5,
	assassinateSpawns = {target = "reb_transport_tier4", escorts = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"}},
	targetPatrols = {{patrolPointName = "storm_t4_4_a_target", zoneName = "space_dantooine", x = -3900, z = 2400, y = 3600}},
}, "recovery", "tatooine_imperial_tier4_4_b", "assassinate_tatooine_imperial_tier4_4", "assassinate", "tatooine_imperial_tier4_4"))

stormT4("recovery_tatooine_imperial_tier4_4_b", SpaceRecoveryScreenplay, links({
	questName = "tatooine_imperial_tier4_4_b", questType = "recovery", questZone = "space_dantooine", arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 75,
	recoverShip = "reb_transport_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"},
	preRecoveryPoints = {{patrolPointName = "storm_t4_4_b_capture", zoneName = "space_dantooine", x = 1600, z = 1800, y = -4700, escortNumber = 1, radius = 250}},
	recoveryPoints = {{patrolPointName = "storm_t4_4_b_escape", zoneName = "space_dantooine", x = 4200, z = 1100, y = -2200, escortNumber = 1, radius = 250}}, attackDelay = 20, attackShips = {{"reb_z95_tier4"}},
}, "assassinate", "tatooine_imperial_tier4_4_c", "assassinate_tatooine_imperial_tier4_4_a", "assassinate", "tatooine_imperial_tier4_4_a"))

stormT4("assassinate_tatooine_imperial_tier4_4_c", SpaceAssassinateScreenplay, links({
	questName = "tatooine_imperial_tier4_4_c", questType = "assassinate", questZone = "space_dantooine", arrivalDelay = 5,
	assassinateSpawns = {target = "reb_gunboat_tier4", escorts = {"reb_ykl37r_tier3", "reb_ykl37r_tier3", "reb_z95_tier4", "reb_z95_tier4", "reb_z95_tier4", "reb_ywing_tier4", "reb_ywing_tier4", "reb_ywing_tier4", "reb_bwing_tier3", "reb_bwing_tier3", "reb_bwing_tier3"}},
	targetPatrols = {{patrolPointName = "storm_t4_4_c_nova_holiday", zoneName = "space_dantooine", x = 5600, z = -800, y = 4900}},
}, nil, nil, "recovery_tatooine_imperial_tier4_4_b", "recovery", "tatooine_imperial_tier4_4_b"))

-- Storm Squadron tier 3 missions: Captain Denner's Endor campaign.
-- Quest type/name pairs mirror the client datatables and STF files exactly.

local function stormTier3Quest(globalName, baseClass, data)
	data.className = globalName
	_G[globalName] = baseClass:new(data)
	registerScreenPlay(globalName, true)
	return _G[globalName]
end

local rebelFighters3 = {"reb_z95_tier3", "reb_awing_tier3", "reb_ywing_tier3"}
local rebelFighters4 = {"reb_z95_tier4", "reb_awing_tier4", "reb_ywing_tier4"}

-- Field Commander Alozen's Yavin assignments. These use the original client
-- quest identifiers rather than overloading Captain Denner's tier3 chains.
inspect_imperial_ss_4 = stormTier3Quest("inspect_imperial_ss_4", SpaceInspectScreenplay, {
	questName = "imperial_ss_4", questType = "inspect", questZone = "space_yavin4", creditReward = 5000,
	sideQuest = false, sideQuestType = "", inspectTargets = {"rebel_agent_tier3"},
	inspectCargo = "rebel_activity_log", spawnInspectTarget = true, targetLocation = {x = -3200, z = -3000, y = 6000},
})

escort_imperial_ss_5 = stormTier3Quest("escort_imperial_ss_5", SpaceEscortScreenplay, {
	questName = "imperial_ss_5", questType = "escort", questZone = "space_yavin4", creditReward = 5000,
	sideQuest = false, sideQuestType = "", escortShips = {"imperial_scan_freighter_tier2"}, escortSpeed = 65,
	escortPoints = {
		{patrolPointName = "yavin_rebel_region_scan_1", zoneName = "space_yavin4", x = 5000, z = -1220, y = 4300, escortNumber = 1, radius = 250},
		{patrolPointName = "yavin_rebel_region_scan_2", zoneName = "space_yavin4", x = 6563, z = -605, y = 4839, escortNumber = 2, radius = 250},
		{patrolPointName = "yavin_rebel_region_scan_3", zoneName = "space_yavin4", x = 5498, z = -1466, y = 2835, escortNumber = 3, radius = 250},
		{patrolPointName = "yavin_rebel_region_scan_4", zoneName = "space_yavin4", x = 4237, z = -3105, y = 2589, escortNumber = 4, radius = 250},
		{patrolPointName = "yavin_rebel_region_scan_5", zoneName = "space_yavin4", x = 2247, z = -3184, y = 1569, escortNumber = 5, radius = 250},
	},
	attackDelay = 55, attackShips = {{"reb_z95_tier3", "reb_ywing_tier3"}, {"reb_z95_tier3", "reb_awing_tier3"}},
})

recovery_imperial_ss_6 = stormTier3Quest("recovery_imperial_ss_6", SpaceRecoveryScreenplay, {
	questName = "imperial_ss_6", questType = "recovery", questZone = "space_yavin4", creditReward = 5000,
	sideQuest = false, sideQuestType = "", arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 65,
	recoverShip = "twilight_sun_tier1", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"reb_z95_tier2", "reb_z95_tier2", "reb_z95_tier2", "reb_z95_tier2"},
	preRecoveryPoints = {{patrolPointName = "tatooine_imperial_twilight_1", zoneName = "space_yavin4", x = -5464, z = 3200, y = -6088, escortNumber = 1, radius = 250}},
	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_twilight_2", zoneName = "space_yavin4", x = -1316, z = 2300, y = -5012, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_twilight_3", zoneName = "space_yavin4", x = 4784, z = 1400, y = -5136, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_twilight_4", zoneName = "space_yavin4", x = 3876, z = 900, y = -4400, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_twilight_5", zoneName = "space_yavin4", x = 4608, z = 200, y = -2712, escortNumber = 4, radius = 250},
		{patrolPointName = "tatooine_imperial_twilight_6", zoneName = "space_yavin4", x = 5568, z = -800, y = -148, escortNumber = 5, radius = 250},
	},
	attackDelay = 45, attackShips = {{"reb_z95_tier3", "reb_ywing_tier3"}, {"reb_awing_tier3", "reb_z95_tier3"}},
})

-- 3-1: escort the engineer transport, recapture it, inspect the recon fighter,
-- rescue the Imperial freighter, then deliver the recovered intelligence.
escort_tatooine_imperial_tier3_1 = stormTier3Quest("escort_tatooine_imperial_tier3_1", SpaceEscortScreenplay, {
	questName = "tatooine_imperial_tier3_1", questType = "escort", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "recovery", sideQuestName = "tatooine_imperial_tier3_1_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	escortShips = {"imp_freightermedium_tier3"}, escortSpeed = 70,
	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier3_escort1_1", zoneName = "space_endor", x = 2340, z = -4531, y = 7123, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_escort1_2", zoneName = "space_endor", x = -3468, z = -4500, y = 3945, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_escort1_3", zoneName = "space_endor", x = -3809, z = -1542, y = -558, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_escort1_4", zoneName = "space_endor", x = 2909, z = 774, y = -4383, escortNumber = 4, radius = 250},
	},
	attackDelay = 55, attackShips = {
		{"reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier3"},
		{"reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier3"},
		{"reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier3"},
	},
})

recovery_tatooine_imperial_tier3_1_a = stormTier3Quest("recovery_tatooine_imperial_tier3_1_a", SpaceRecoveryScreenplay, {
	questName = "tatooine_imperial_tier3_1_a", questType = "recovery", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "tatooine_imperial_tier3_1_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "escort_tatooine_imperial_tier3_1", parentQuestType = "escort", parentQuestName = "tatooine_imperial_tier3_1",
	arrivalDelay = 5, recoveryDelay = 20, recoverShip = "reb_freightermedium_tier3",
	recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3"},
	preRecoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier3_recovery1_1", zoneName = "space_endor", x = -6736, z = 1000, y = 5728, escortNumber = 1, radius = 250},
	},
	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier3_recovery1_2", zoneName = "space_endor", x = -485, z = -3573, y = -4328, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_recovery1_3", zoneName = "space_endor", x = -3234, z = -4013, y = -919, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_recovery1_4", zoneName = "space_endor", x = -4015, z = -4056, y = -1966, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_recovery1_5", zoneName = "space_endor", x = -4384, z = -3809, y = -3174, escortNumber = 4, radius = 250},
	},
	attackDelay = 55, attackShips = {{"reb_z95_tier3", "reb_ywing_tier3"}, {"reb_z95_tier3", "reb_ywing_tier3"}},
})

inspect_tatooine_imperial_tier3_1_b = stormTier3Quest("inspect_tatooine_imperial_tier3_1_b", SpaceInspectScreenplay, {
	questName = "tatooine_imperial_tier3_1_b", questType = "inspect", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "rescue", sideQuestName = "tatooine_imperial_tier3_1_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "recovery_tatooine_imperial_tier3_1_a", parentQuestType = "recovery", parentQuestName = "tatooine_imperial_tier3_1_a",
	inspectTargets = {"reb_awing_tier3"}, inspectCargo = "rebel_recon_data", spawnInspectTarget = true,
	targetLocation = {x = -2450, z = -3052, y = 1234},
})

rescue_tatooine_imperial_tier3_1_c = stormTier3Quest("rescue_tatooine_imperial_tier3_1_c", SpaceRescueScreenplay, {
	questName = "tatooine_imperial_tier3_1_c", questType = "rescue", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "tatooine_imperial_tier3_1_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "inspect_tatooine_imperial_tier3_1_b", parentQuestType = "inspect", parentQuestName = "tatooine_imperial_tier3_1_b",
	arrivalDelay = 5, rescueShip = "imp_freightermedium_tier3", rescueLocation = {x = 1000, z = -4000, y = -1500},
	repairDelay = 20, escortSpeed = 70,
	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier3_rescue1_2", zoneName = "space_endor", x = 4054, z = -6049, y = -3682, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_rescue1_3", zoneName = "space_endor", x = 3070, z = -6422, y = -6716, escortNumber = 2, radius = 250},
	},
	escortAttackDelay = 15, escortAttackShips = {{{count = 1, shipName = "reb_ywing_tier3"}}},
})

delivery_no_pickup_tatooine_imperial_tier3_1_d = stormTier3Quest("delivery_no_pickup_tatooine_imperial_tier3_1_d", SpaceDeliveryNoPickupScreenplay, {
	questName = "tatooine_imperial_tier3_1_d", questType = "delivery_no_pickup", questZone = "space_endor", creditReward = 0,
	sideQuest = false, sideQuestType = "",
	parentQuest = "rescue_tatooine_imperial_tier3_1_c", parentQuestType = "rescue", parentQuestName = "tatooine_imperial_tier3_1_c",
	deliveryShip = "imp_lambda_shuttle_tier3", deliveryPoint = {x = 4300, z = 2948, y = -5400},
	attackDelay = 45, attackShips = {{"reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3"}},
})

-- 3-2: recon inspection, counterstrike, scout inspection, data drop,
-- patrol, and the final fleet engagement.
inspect_tatooine_imperial_tier3_2 = stormTier3Quest("inspect_tatooine_imperial_tier3_2", SpaceInspectScreenplay, {
	questName = "tatooine_imperial_tier3_2", questType = "inspect", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "tatooine_imperial_tier3_2_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	inspectTargets = {"reb_awing_tier3"}, inspectCargo = "advanced_recon_data", spawnInspectTarget = true,
	targetLocation = {x = -5009, z = 4104, y = 6001},
})

destroy_surpriseattack_tatooine_imperial_tier3_2_a = stormTier3Quest("destroy_surpriseattack_tatooine_imperial_tier3_2_a", SpaceSurpriseAttackScreenplay, {
	questName = "tatooine_imperial_tier3_2_a", questType = "destroy_surpriseattack", questZone = "space_endor",
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "tatooine_imperial_tier3_2_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "inspect_tatooine_imperial_tier3_2", parentQuestType = "inspect", parentQuestName = "tatooine_imperial_tier3_2",
	surpriseAttackShips = {zone = "space_endor", spawns = {{count = 5, shipName = "reb_awing_tier3"}}},
})

inspect_tatooine_imperial_tier3_2_b = stormTier3Quest("inspect_tatooine_imperial_tier3_2_b", SpaceInspectScreenplay, {
	questName = "tatooine_imperial_tier3_2_b", questType = "inspect", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "tatooine_imperial_tier3_2_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "destroy_surpriseattack_tatooine_imperial_tier3_2_a", parentQuestType = "destroy_surpriseattack", parentQuestName = "tatooine_imperial_tier3_2_a",
	inspectTargets = {"reb_freighterlight_tier3"}, inspectCargo = "rebel_scout_data", spawnInspectTarget = true,
	targetLocation = {x = 6009, z = -7001, y = -1095},
})

delivery_no_pickup_tatooine_imperial_tier3_2_c = stormTier3Quest("delivery_no_pickup_tatooine_imperial_tier3_2_c", SpaceDeliveryNoPickupScreenplay, {
	questName = "tatooine_imperial_tier3_2_c", questType = "delivery_no_pickup", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "patrol", sideQuestName = "tatooine_imperial_tier3_2_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "inspect_tatooine_imperial_tier3_2_b", parentQuestType = "inspect", parentQuestName = "tatooine_imperial_tier3_2_b",
	deliveryShip = "imp_lambda_shuttle_tier3", deliveryPoint = {x = 90, z = -69, y = -1106}, attackShips = {},
})

patrol_tatooine_imperial_tier3_2_d = stormTier3Quest("patrol_tatooine_imperial_tier3_2_d", SpacePatrolScreenplay, {
	questName = "tatooine_imperial_tier3_2_d", questType = "patrol", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "space_battle", sideQuestName = "tatooine_imperial_tier3_2_e",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "delivery_no_pickup_tatooine_imperial_tier3_2_c", parentQuestType = "delivery_no_pickup", parentQuestName = "tatooine_imperial_tier3_2_c",
	patrolPoints = {
		{patrolPointName = "tatooine_imperial_tier3_patrol1_1", x = 554, z = -706, y = 2191, patrolNumber = 1, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_patrol1_2", x = 659, z = -2035, y = 3506, patrolNumber = 2, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_patrol1_3", x = -385, z = -2351, y = 5481, patrolNumber = 3, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_patrol1_4", x = -1032, z = -1624, y = 7179, patrolNumber = 4, radius = 150},
	},
})

space_battle_tatooine_imperial_tier3_2_e = stormTier3Quest("space_battle_tatooine_imperial_tier3_2_e", SpaceBattleScreenplay, {
	questName = "tatooine_imperial_tier3_2_e", questType = "space_battle", questZone = "space_endor", creditReward = 0,
	sideQuest = false, sideQuestType = "",
	parentQuest = "patrol_tatooine_imperial_tier3_2_d", parentQuestType = "patrol", parentQuestName = "tatooine_imperial_tier3_2_d",
	battleLocation = {x = 1477, z = -2315, y = 5545}, allyArrivalDelay = 10, enemyArrivalDelay = 15,
	allyOriginDist = -600, enemyOriginDist = 800, allyArrivalDist = -100, enemyArrivalDist = 0,
	alliedShips = {{"imp_tie_fighter_tier3"}, {"imp_tie_interceptor_tier3"}, {"imp_tie_fighter_tier3"}},
	enemyShips = {{"reb_awing_tier3"}, {"reb_awing_tier3"}, {"reb_z95_tier3"}, {"reb_z95_tier3"}, {"reb_ywing_tier3"}, {"reb_ykl37r_tier3"}},
})

-- 3-3: deliver the false plan, escort the decoy, destroy the strike force,
-- survive the scanning ambush, and eliminate its final wave.
delivery_tatooine_imperial_tier3_3 = stormTier3Quest("delivery_tatooine_imperial_tier3_3", SpaceDeliveryScreenplay, {
	questName = "tatooine_imperial_tier3_3", questType = "delivery", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "escort", sideQuestName = "tatooine_imperial_tier3_3_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	pickupShip = "imp_lambda_shuttle_tier3", deliveryShip = "imp_lambda_shuttle_tier3",
	pickupPoint = {x = -5657, z = -3287, y = -6482}, deliveryPoint = {x = -1000, z = -100, y = -500},
	attackDelay = 45, attackShips = {{"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier4"}},
})

escort_tatooine_imperial_tier3_3_a = stormTier3Quest("escort_tatooine_imperial_tier3_3_a", SpaceEscortScreenplay, {
	questName = "tatooine_imperial_tier3_3_a", questType = "escort", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy", sideQuestName = "tatooine_imperial_tier3_3_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "delivery_tatooine_imperial_tier3_3", parentQuestType = "delivery", parentQuestName = "tatooine_imperial_tier3_3",
	escortShips = {"imp_freightermedium_tier3"}, escortSpeed = 70,
	escortPoints = {
		{patrolPointName = "storm_tier3_3_a_escort_1", zoneName = "space_endor", x = -5250, z = -850, y = 2000, escortNumber = 1, radius = 250},
		{patrolPointName = "storm_tier3_3_a_escort_2", zoneName = "space_endor", x = -3632, z = -680, y = 1552, escortNumber = 2, radius = 250},
		{patrolPointName = "storm_tier3_3_a_escort_3", zoneName = "space_endor", x = -2813, z = -400, y = 1793, escortNumber = 3, radius = 250},
	},
	attackDelay = 45, attackShips = {{"reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier3"}, {"reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier3"}},
})

destroy_tatooine_imperial_tier3_3_b = stormTier3Quest("destroy_tatooine_imperial_tier3_3_b", SpaceDestroyScreenplay, {
	questName = "tatooine_imperial_tier3_3_b", questType = "destroy", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "survival", sideQuestName = "tatooine_imperial_tier3_3_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "escort_tatooine_imperial_tier3_3_a", parentQuestType = "escort", parentQuestName = "tatooine_imperial_tier3_3_a",
	killsRequired = 6, shipTypes = {"reb_awing_tier3"},
})

survival_tatooine_imperial_tier3_3_c = stormTier3Quest("survival_tatooine_imperial_tier3_3_c", SpaceSurvivalScreenplay, {
	questName = "tatooine_imperial_tier3_3_c", questType = "survival", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "tatooine_imperial_tier3_3_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "destroy_tatooine_imperial_tier3_3_b", parentQuestType = "destroy", parentQuestName = "tatooine_imperial_tier3_3_b",
	survivalTime = 360, survivalUpdateInterval = 60, survivalPoint = {x = 2090, z = 514, y = 306}, delayToFirstAttack = 5,
	attackDelay = 55, attackShips = {
		{"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier4"},
		{"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier4"},
		{"reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier3", "reb_awing_tier4"},
		{"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_ywing_tier4"},
	},
})

destroy_surpriseattack_tatooine_imperial_tier3_3_d = stormTier3Quest("destroy_surpriseattack_tatooine_imperial_tier3_3_d", SpaceSurpriseAttackScreenplay, {
	questName = "tatooine_imperial_tier3_3_d", questType = "destroy_surpriseattack", questZone = "space_endor",
	sideQuest = false, sideQuestType = "",
	parentQuest = "survival_tatooine_imperial_tier3_3_c", parentQuestType = "survival", parentQuestName = "tatooine_imperial_tier3_3_c",
	surpriseAttackShips = {zone = "space_endor", spawns = {{count = 4, shipName = "reb_z95_tier3"}, {count = 1, shipName = "reb_z95_tier4"}}},
})

-- 3-4: destroy the patrol, rescue the Lambda, inspect the command shuttle,
-- then assassinate the Rebel command crew.
destroy_tatooine_imperial_tier3_4 = stormTier3Quest("destroy_tatooine_imperial_tier3_4", SpaceDestroyScreenplay, {
	questName = "tatooine_imperial_tier3_4", questType = "destroy", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "rescue", sideQuestName = "tatooine_imperial_tier3_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	killsRequired = 6, shipTypes = {"reb_z95_tier3"},
})

rescue_tatooine_imperial_tier3_4_a = stormTier3Quest("rescue_tatooine_imperial_tier3_4_a", SpaceRescueScreenplay, {
	questName = "tatooine_imperial_tier3_4_a", questType = "rescue", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "tatooine_imperial_tier3_4_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "destroy_tatooine_imperial_tier3_4", parentQuestType = "destroy", parentQuestName = "tatooine_imperial_tier3_4",
	arrivalDelay = 5, rescueShip = "imp_lambda_shuttle_tier3", rescueLocation = {x = 825, z = -3312, y = 2052},
	repairDelay = 20, escortSpeed = 70,
	escortPoints = {{patrolPointName = "tatooine_imperial_tier3_rescue2_3", zoneName = "space_endor", x = -3703, z = -374, y = 144, escortNumber = 1, radius = 250}},
	escortAttackDelay = 15, escortAttackShips = {{{count = 1, shipName = "reb_z95_tier3"}}},
})

inspect_tatooine_imperial_tier3_4_b = stormTier3Quest("inspect_tatooine_imperial_tier3_4_b", SpaceInspectScreenplay, {
	questName = "tatooine_imperial_tier3_4_b", questType = "inspect", questZone = "space_endor", creditReward = 0,
	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "tatooine_imperial_tier3_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "rescue_tatooine_imperial_tier3_4_a", parentQuestType = "rescue", parentQuestName = "tatooine_imperial_tier3_4_a",
	inspectTargets = {"reb_ykl37r_tier4"}, inspectCargo = "rebel_command_data", spawnInspectTarget = true,
	targetLocation = {x = 2000, z = 6500, y = 1200},
})

assassinate_tatooine_imperial_tier3_4_c = stormTier3Quest("assassinate_tatooine_imperial_tier3_4_c", SpaceAssassinateScreenplay, {
	questName = "tatooine_imperial_tier3_4_c", questType = "assassinate", questZone = "space_endor", creditReward = 0, itemReward = {},
	sideQuest = false, sideQuestType = "",
	parentQuest = "inspect_tatooine_imperial_tier3_4_b", parentQuestType = "inspect", parentQuestName = "tatooine_imperial_tier3_4_b",
	arrivalDelay = 5, failTimer = 30,
	assassinateSpawns = {target = "reb_ykl37r_tier4", escorts = {"reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3", "reb_z95_tier3"}},
	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier3_assassinate4_01", zoneName = "space_endor", x = 552, z = 5144, y = -4984},
		{patrolPointName = "tatooine_imperial_tier3_assassinate4_02", zoneName = "space_endor", x = 3996, z = 500, y = -1498},
		{patrolPointName = "tatooine_imperial_tier3_assassinate4_03", zoneName = "space_endor", x = 3984, z = -3744, y = 4468},
		{patrolPointName = "tatooine_imperial_tier3_assassinate4_04", zoneName = "space_endor", x = -2988, z = -4004, y = 6386},
	},
})

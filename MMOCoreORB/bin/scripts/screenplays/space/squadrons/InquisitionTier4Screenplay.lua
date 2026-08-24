-- Grand Inquisitor Ja'ce Yiaso -- original Inquisition Tier 4 campaign.
-- Quest types and names deliberately match the shipped naboo_imperial_tier4 STFs.

-- Mission 1: patrol Dathomir and recover the glowing crystals.
patrol_naboo_imperial_tier4_1 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_imperial_tier4_1", questName = "naboo_imperial_tier4_1", questType = "patrol", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "naboo_imperial_tier4_1_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	patrolPoints = {
		{patrolPointName = "naboo_imperial_tier4_patrol1_1", x = 4262, z = 1755, y = -2347, patrolNumber = 1, radius = 150},
		{patrolPointName = "naboo_imperial_tier4_patrol1_2", x = 5506, z = 2853, y = -2063, patrolNumber = 2, radius = 150},
		{patrolPointName = "naboo_imperial_tier4_patrol1_3", x = 7049, z = 4215, y = -1712, patrolNumber = 3, radius = 150},
	},
}
registerScreenPlay("patrol_naboo_imperial_tier4_1", true)

inspect_naboo_imperial_tier4_1_a = SpaceInspectScreenplay:new {
	className = "inspect_naboo_imperial_tier4_1_a", questName = "naboo_imperial_tier4_1_a", questType = "inspect", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "naboo_imperial_tier4_1_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "patrol_naboo_imperial_tier4_1", parentQuestType = "patrol", parentQuestName = "naboo_imperial_tier4_1",
	inspectTargets = {"crystal_smuggler_yt1300_tier4"}, inspectCargo = "glowing_crystals", targetLocation = {x = 7606, z = 4673, y = -1681}, spawnInspectTarget = true,
}
registerScreenPlay("inspect_naboo_imperial_tier4_1_a", true)

destroy_surpriseattack_naboo_imperial_tier4_1_b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_tier4_1_b", questName = "naboo_imperial_tier4_1_b", questType = "destroy_surpriseattack", questZone = "space_dathomir",
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "naboo_imperial_tier4_1_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "inspect_naboo_imperial_tier4_1_a", parentQuestType = "inspect", parentQuestName = "naboo_imperial_tier4_1_a",
	surpriseAttackShips = {zone = "space_dathomir", spawns = {{count = 6, shipName = "coynite_merc_pulsar_tier4"}}},
}
registerScreenPlay("destroy_surpriseattack_naboo_imperial_tier4_1_b", true)

delivery_no_pickup_naboo_imperial_tier4_1_c = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_naboo_imperial_tier4_1_c", questName = "naboo_imperial_tier4_1_c", questType = "delivery_no_pickup", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "destroy_surpriseattack_naboo_imperial_tier4_1_b", parentQuestType = "destroy_surpriseattack", parentQuestName = "naboo_imperial_tier4_1_b",
	deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = 6312, z = 6992, y = -5062}, attackDelay = 45,
	attackShips = {{"coynite_merc_neutron_tier4", "coynite_merc_neutron_tier4", "coynite_merc_neutron_tier4", "coynite_merc_neutron_tier4"}},
}
registerScreenPlay("delivery_no_pickup_naboo_imperial_tier4_1_c", true)

-- Mission 2: capture the crystal smuggler, rescue the recon shuttle, and capture a Coynite.
recovery_naboo_imperial_tier4_2 = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_imperial_tier4_2", questName = "naboo_imperial_tier4_2", questType = "recovery", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "rescue", sideQuestName = "naboo_imperial_tier4_2_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	arrivalDelay = 10, recoveryDelay = 20, escortSpeed = 60, recoverShip = "crystal_smuggler_heavy_tier4", recoveryConversationMobile = "object/mobile/dressed_coynite_pilot_hum_m_01.iff",
	escortShips = {"coynite_merc_neutron_tier4"},
	preRecoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery1_1", zoneName = "space_dathomir", x = 6480, z = -506, y = -2013, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_2", zoneName = "space_dathomir", x = 5932, z = -978, y = 2960, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_3", zoneName = "space_dathomir", x = 2864, z = -1390, y = 4050, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_4", zoneName = "space_dathomir", x = -2176, z = -1720, y = 5470, escortNumber = 4, radius = 250},
	},
	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery1_5", zoneName = "space_dathomir", x = -28, z = -1930, y = 6578, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_6", zoneName = "space_dathomir", x = 975, z = 225, y = 3781, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_7", zoneName = "space_dathomir", x = -2095, z = 2334, y = 3374, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_8", zoneName = "space_dathomir", x = -4455, z = 2935, y = 4075, escortNumber = 4, radius = 250},
	},
	attackDelay = 60, attackShips = {{"coynite_merc_neutron_tier4"}},
}
registerScreenPlay("recovery_naboo_imperial_tier4_2", true)

rescue_naboo_imperial_tier4_2_a = SpaceRescueScreenplay:new {
	className = "rescue_naboo_imperial_tier4_2_a", questName = "naboo_imperial_tier4_2_a", questType = "rescue", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "naboo_imperial_tier4_2_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "recovery_naboo_imperial_tier4_2", parentQuestType = "recovery", parentQuestName = "naboo_imperial_tier4_2",
	arrivalDelay = 5, rescueShip = "imp_lambda_shuttle_tier4", rescueLocation = {x = -5889, z = 2454, y = 5119}, repairDelay = 20, escortSpeed = 60,
	escortPoints = {
		{patrolPointName = "naboo_imperial_tier4_rescue1_2", zoneName = "space_dathomir", x = -6996, z = 1990, y = 1981, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_rescue1_3", zoneName = "space_dathomir", x = -7528, z = 2452, y = -685, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_rescue1_4", zoneName = "space_dathomir", x = -7505, z = 2904, y = -2924, escortNumber = 3, radius = 250},
	},
	attackDelay = 60, attackShips = {{"coynite_merc_quasar_tier4"}},
}
registerScreenPlay("rescue_naboo_imperial_tier4_2_a", true)

destroy_surpriseattack_naboo_imperial_tier4_2_b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_tier4_2_b", questName = "naboo_imperial_tier4_2_b", questType = "destroy_surpriseattack", questZone = "space_dathomir",
	sideQuest = true, sideQuestType = "recovery", sideQuestName = "naboo_imperial_tier4_2_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "rescue_naboo_imperial_tier4_2_a", parentQuestType = "rescue", parentQuestName = "naboo_imperial_tier4_2_a",
	surpriseAttackShips = {zone = "space_dathomir", spawns = {{count = 6, shipName = "coynite_merc_pulsar_tier4"}}},
}
registerScreenPlay("destroy_surpriseattack_naboo_imperial_tier4_2_b", true)

recovery_naboo_imperial_tier4_2_c = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_imperial_tier4_2_c", questName = "naboo_imperial_tier4_2_c", questType = "recovery", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "destroy_surpriseattack_naboo_imperial_tier4_2_b", parentQuestType = "destroy_surpriseattack", parentQuestName = "naboo_imperial_tier4_2_b",
	arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 60, recoverShip = "coynite_merc_neutron_tier5", recoveryConversationMobile = "object/mobile/dressed_coynite_pilot_hum_m_01.iff",
	escortShips = {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
	preRecoveryPoints = {{patrolPointName = "naboo_imperial_tier4_recovery2_1", zoneName = "space_dathomir", x = -7238, z = 2332, y = -1848, escortNumber = 1, radius = 250}},
	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery2_5", zoneName = "space_dathomir", x = -6263, z = 3140, y = 1529, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery2_6", zoneName = "space_dathomir", x = -4648, z = 2991, y = 4029, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery2_7", zoneName = "space_dathomir", x = -3618, z = 2711, y = 7068, escortNumber = 3, radius = 250},
	},
	attackDelay = 60, attackShips = {{"coynite_merc_pulsar_tier4"}},
}
registerScreenPlay("recovery_naboo_imperial_tier4_2_c", true)

-- Mission 3: intercept and deliver the transmission, then destroy the mothership.
survival_naboo_imperial_tier4_3 = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_imperial_tier4_3", questName = "naboo_imperial_tier4_3", questType = "survival", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "naboo_imperial_tier4_3_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	survivalTime = 420, survivalPoint = "space_dathomir:naboo_imperial_tier4_survival1", delayToFirstAttack = 5, attackDelay = 45,
	attackShips = {
		{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
		{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
		{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
		{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
		{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
	},
}
registerScreenPlay("survival_naboo_imperial_tier4_3", true)

delivery_no_pickup_naboo_imperial_tier4_3_a = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_naboo_imperial_tier4_3_a", questName = "naboo_imperial_tier4_3_a", questType = "delivery_no_pickup", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "naboo_imperial_tier4_3_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "survival_naboo_imperial_tier4_3", parentQuestType = "survival", parentQuestName = "naboo_imperial_tier4_3",
	deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = -2651, z = -334, y = -4012}, attackDelay = 45,
	attackShips = {{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}},
}
registerScreenPlay("delivery_no_pickup_naboo_imperial_tier4_3_a", true)

assassinate_naboo_imperial_tier4_3_b = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier4_3_b", questName = "naboo_imperial_tier4_3_b", questType = "assassinate", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "delivery_no_pickup_naboo_imperial_tier4_3_a", parentQuestType = "delivery_no_pickup", parentQuestName = "naboo_imperial_tier4_3_a",
	arrivalDelay = 5, failTimer = 10, assassinateSpawns = {target = "coynite_mothership_tier4", escorts = {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}},
	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier4_assassinate1_1", zoneName = "space_dathomir", x = -141, z = -3283, y = -3310},
		{patrolPointName = "naboo_imperial_tier4_assassinate1_2", zoneName = "space_dathomir", x = 1392, z = -5247, y = -2647},
		{patrolPointName = "naboo_imperial_tier4_assassinate1_3", zoneName = "space_dathomir", x = 2124, z = -6185, y = -2330},
		{patrolPointName = "naboo_imperial_tier4_assassinate1_4", zoneName = "space_dathomir", x = 4735, z = -7420, y = -1572},
	},
}
registerScreenPlay("assassinate_naboo_imperial_tier4_3_b", true)

-- Mission 4: prison shuttle escort, capture, two interceptions, and the 701st battle.
escort_naboo_imperial_tier4_4 = SpaceEscortScreenplay:new {
	className = "escort_naboo_imperial_tier4_4", questName = "naboo_imperial_tier4_4", questType = "escort", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "recovery", sideQuestName = "naboo_imperial_tier4_4_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	escortShips = {"dathomir_prison_shuttle_tier4"}, escortSpeed = 60,
	escortPoints = {
		{patrolPointName = "naboo_imperial_tier4_escort1_1", zoneName = "space_dathomir", x = 3787, z = -6425, y = 49, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_2", zoneName = "space_dathomir", x = 3065, z = -5248, y = 1760, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_3", zoneName = "space_dathomir", x = 2200, z = -4231, y = 2864, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_4", zoneName = "space_dathomir", x = 1502, z = -3172, y = 4240, escortNumber = 4, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_5", zoneName = "space_dathomir", x = 336, z = -1027, y = 7007, escortNumber = 5, radius = 250},
	},
	attackDelay = 55, attackShips = {{"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_quasar_tier4", "coynite_merc_quasar_tier4"}, {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_neutron_tier4", "coynite_merc_neutron_tier4"}},
}
registerScreenPlay("escort_naboo_imperial_tier4_4", true)

recovery_naboo_imperial_tier4_4_a = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_imperial_tier4_4_a", questName = "naboo_imperial_tier4_4_a", questType = "recovery", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "naboo_imperial_tier4_4_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "escort_naboo_imperial_tier4_4", parentQuestType = "escort", parentQuestName = "naboo_imperial_tier4_4",
	arrivalDelay = 5, recoveryDelay = 20, escortSpeed = 60, recoverShip = "dathomir_prison_break_shuttle_tier4", recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m.iff",
	escortShips = {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"},
	preRecoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery3_1", zoneName = "space_dathomir", x = 2520, z = 1785, y = 4899, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery3_2", zoneName = "space_dathomir", x = 4471, z = 351, y = -482, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery3_3", zoneName = "space_dathomir", x = 1534, z = -2167, y = -3967, escortNumber = 3, radius = 250},
	},
	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery3_4", zoneName = "space_dathomir", x = -5949, z = -3151, y = -4944, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery3_5", zoneName = "space_dathomir", x = 2072, z = -835, y = 2749, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery3_6", zoneName = "space_dathomir", x = 2193, z = -1002, y = 5820, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery3_7", zoneName = "space_dathomir", x = 2243, z = -944, y = 7076, escortNumber = 4, radius = 250},
	},
	attackDelay = 55, attackShips = {{"coynite_merc_pulsar_tier4"}},
}
registerScreenPlay("recovery_naboo_imperial_tier4_4_a", true)

assassinate_naboo_imperial_tier4_4_b = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier4_4_b", questName = "naboo_imperial_tier4_4_b", questType = "assassinate", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "naboo_imperial_tier4_4_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "recovery_naboo_imperial_tier4_4_a", parentQuestType = "recovery", parentQuestName = "naboo_imperial_tier4_4_a", arrivalDelay = 5, failTimer = 10,
	assassinateSpawns = {target = "dathomir_prison_break_shuttle_tier4", escorts = {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}},
	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier4_assassinate2_1", zoneName = "space_dathomir", x = 2795, z = -5791, y = 6336}, {patrolPointName = "naboo_imperial_tier4_assassinate2_2", zoneName = "space_dathomir", x = 2631, z = -7584, y = 4070},
		{patrolPointName = "naboo_imperial_tier4_assassinate2_3", zoneName = "space_dathomir", x = 3072, z = -6658, y = 5858}, {patrolPointName = "naboo_imperial_tier4_assassinate2_4", zoneName = "space_dathomir", x = 3613, z = -5613, y = 7149},
	},
}
registerScreenPlay("assassinate_naboo_imperial_tier4_4_b", true)

assassinate_naboo_imperial_tier4_4_c = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier4_4_c", questName = "naboo_imperial_tier4_4_c", questType = "assassinate", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "space_battle", sideQuestName = "naboo_imperial_tier4_4_d", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "assassinate_naboo_imperial_tier4_4_b", parentQuestType = "assassinate", parentQuestName = "naboo_imperial_tier4_4_b", arrivalDelay = 5, failTimer = 10,
	assassinateSpawns = {target = "dathomir_prison_break_shuttle_tier4", escorts = {"coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4", "coynite_merc_pulsar_tier4"}},
	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier4_assassinate3_1", zoneName = "space_dathomir", x = 4423, z = -5952, y = 4998}, {patrolPointName = "naboo_imperial_tier4_assassinate3_2", zoneName = "space_dathomir", x = 4497, z = -4930, y = 2766},
		{patrolPointName = "naboo_imperial_tier4_assassinate3_3", zoneName = "space_dathomir", x = 4424, z = -3818, y = 943}, {patrolPointName = "naboo_imperial_tier4_assassinate3_4", zoneName = "space_dathomir", x = 4351, z = -2709, y = -874},
	},
}
registerScreenPlay("assassinate_naboo_imperial_tier4_4_c", true)

space_battle_naboo_imperial_tier4_4_d = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_imperial_tier4_4_d", questName = "naboo_imperial_tier4_4_d", questType = "space_battle", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "assassinate_naboo_imperial_tier4_4_c", parentQuestType = "assassinate", parentQuestName = "naboo_imperial_tier4_4_c",
	battleLocation = {x = -160, z = 2428, y = -2525}, allyArrivalDelay = 20, enemyArrivalDelay = 35, allyOriginDist = -600, enemyOriginDist = 800, allyArrivalDist = -100, enemyArrivalDist = 0,
	alliedShips = {{"imp_tie_fighter_tier4"}, {"imp_tie_fighter_tier4"}, {"imp_tie_interceptor_tier4"}, {"imp_tie_bomber_tier4"}, {"imp_imperial_gunboat_tier4"}},
	enemyShips = {{"coynite_coynfury_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}, {"coynite_merc_pulsar_tier4"}},
}
registerScreenPlay("space_battle_naboo_imperial_tier4_4_d", true)

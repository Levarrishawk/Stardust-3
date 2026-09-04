local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Inquisition Squadron Missions (Imperial - Naboo)

]]

--[[
	Tier 1 -- Lt. Barn Sinkko Main Missions (Naboo)
]]

-- Mission 1: Patrol with surprise attack
patrol_naboo_imperial_1 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_imperial_1",

	questName = "naboo_imperial_1",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_imperial_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "inquisition_tier1_mission1_patrol_1", x = -3153, z = 302, y = -6442, patrolNumber = 1, radius = 150},
		{patrolPointName = "inquisition_tier1_mission1_patrol_2", x = -3971, z = -471, y = -6364, patrolNumber = 2, radius = 150},
		{patrolPointName = "inquisition_tier1_mission1_patrol_3", x = -5771, z = -1066, y = -5197, patrolNumber = 3, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_imperial_1", true)

destroy_surpriseattack_naboo_imperial_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_1",

	questName = "naboo_imperial_1",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_imperial_1",
	parentQuestType = "patrol",
	parentQuestName = "naboo_imperial_1",

	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 3, shipName = "rogue_droid_fighter_tier1_naboo"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_imperial_1", true)

-- Mission 2: Destroy
destroy_naboo_imperial_2 = SpaceDestroyScreenplay:new {
	className = "destroy_naboo_imperial_2",

	questName = "naboo_imperial_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "imperial_patrol_1", x = 590, z = -3500, y = -6000},
		{patrolPointName = "imperial_patrol_2", x = -2500, z = 4000, y = 3500},
		{patrolPointName = "imperial_patrol_3", x = -3800, z = 2500, y = 5000},
	},

	shipTypes = {
		"rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo",
	},
}

registerScreenPlay("destroy_naboo_imperial_2", true)

-- Mission 3: Patrol with escort side quest
patrol_naboo_imperial_3 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_imperial_3",

	questName = "naboo_imperial_3",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 500,
	itemReward = {
		{species = {SPECIES_WOOKIEE}, item = "object/tangible/wearables/bandolier/multipocket_bandolier.iff"},
		{species = {SPECIES_ITHORIAN}, item = "object/tangible/wearables/bandolier/ith_multipocket_bandolier.iff"},
		{species = {-1}, item = "object/tangible/wearables/bodysuit/bodysuit_tie_fighter.iff"},
	},

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_imperial_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "inquisition_tier1_mission3_patrol_1", x = -2448, z = 879, y = -1221, patrolNumber = 1, radius = 150},
		{patrolPointName = "inquisition_tier1_mission3_patrol_2", x = -1792, z = 1559, y = -1193, patrolNumber = 2, radius = 150},
		{patrolPointName = "inquisition_tier1_mission3_patrol_3", x = -288, z = 1479, y = -1395, patrolNumber = 3, radius = 150},
		{patrolPointName = "inquisition_tier1_mission3_patrol_4", x = 39, z = 1753, y = 294, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_imperial_3", true)

escort_naboo_imperial_3 = SpaceEscortScreenplay:new {
	className = "escort_naboo_imperial_3",

	questName = "naboo_imperial_3",
	questType = "escort",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_imperial_3",
	parentQuestType = "patrol",
	parentQuestName = "naboo_imperial_3",

	escortShips = {"imp_freightermedium_tier1"},

	escortPoints = {
		{patrolPointName = "inquisition_tier1_mission3_escort_1", zoneName = "space_naboo", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "inquisition_tier1_mission3_escort_2", zoneName = "space_naboo", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "inquisition_tier1_mission3_escort_3", zoneName = "space_naboo", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "inquisition_tier1_mission3_escort_4", zoneName = "space_naboo", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"rogue_droid_fighter_tier1_naboo"},
		{"rogue_droid_fighter_tier1_naboo"},
		{"rogue_droid_fighter_tier1_naboo"},
	}
}

registerScreenPlay("escort_naboo_imperial_3", true)

-- Mission 4: Assassinate
assassinate_naboo_imperial_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_4",

	questType = "assassinate",
	questName = "naboo_imperial_4",

	questZone = "space_naboo",

	creditReward = 1000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/armor/arm_mission_reward_rebel_incom_ultralight.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 6,
	failTimer = 20,

	assassinateSpawns = {
		target = "rogue_droid_fighter_tier2_naboo",
		escorts = {"rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo", "rogue_droid_fighter_tier1_naboo"},
	},

	targetPatrols = {
		{patrolPointName = "inquisition_tier1_mission4_target_1", x = 3933, z = -3285, y = -3098},
		{patrolPointName = "naboo_privateer_tier3_leg_2_rescue_egress_4", x = 1156, z = -7106, y = -2482},
		{patrolPointName = "trade_escort_4", x = 895, z = 210, y = 695},
		{patrolPointName = "military_escort_2", x = 2915, z = 3828, y = 2887},
		{patrolPointName = "corellia_imperial_tier3_leg_1_recovery_recover_1", x = 752, z = -2678, y = -1479},
	},
}

registerScreenPlay("assassinate_naboo_imperial_4", true)

-- Sinkko Duty Missions
destroy_duty_naboo_imperial_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_imperial_6",

	questName = "naboo_imperial_6",
	questType = "destroy_duty",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "rogue_droid_fighter_tier2_naboo",
	shipTypes = {
		{"rogue_droid_fighter_tier1_naboo"},
	},
}

registerScreenPlay("destroy_duty_naboo_imperial_6", true)

escort_duty_naboo_imperial_7 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_imperial_7",

	questName = "naboo_imperial_7",
	questType = "escort_duty",

	questZone = "space_naboo",

	creditReward = 1000,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier1", "imp_freightermedium_tier1", "imp_freighterlight_tier1", "imp_freighterheavy_tier1"},

	escortPoints = {
		{patrolPointName = "inquisition_tier1_escort_duty_1", zoneName = "space_naboo", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "inquisition_tier1_escort_duty_2", zoneName = "space_naboo", x = 1085, z = 4064, y = -7316, escortNumber = 2, radius = 250},
		{patrolPointName = "inquisition_tier1_escort_duty_3", zoneName = "space_naboo", x = 6439, z = -5021, y = -2217, escortNumber = 3, radius = 250},
		{patrolPointName = "inquisition_tier1_escort_duty_4", zoneName = "space_naboo", x = 4891, z = -3215, y = -1345, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"borvo_fighter_tier1_naboo"},
		{"borvo_fighter_tier1_naboo"},
		{"borvo_fighter_tier1_naboo"},
	},

	creditKillBonus = 100,
}

registerScreenPlay("escort_duty_naboo_imperial_7", true)

--[[
	Tier 2 -- naboo_imperial_tier2 Main Missions
]]

-- Mission 1: Inspect with surprise attack side quest
inspect_naboo_imperial_tier2_1 = SpaceInspectScreenplay:new {
	className = "inspect_naboo_imperial_tier2_1",

	questName = "naboo_imperial_tier2_1",
	questType = "inspect",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_imperial_tier2_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	inspectTargets = {"viopa_mission_1_shuttle"},
	inspectCargo = "imperial_data",

	targetLocation = {x = 1992, z = 800, y = 2716},
}

registerScreenPlay("inspect_naboo_imperial_tier2_1", true)

destroy_surpriseattack_naboo_imperial_tier2_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_tier2_1",

	questName = "naboo_imperial_tier2_1",
	questType = "destroy_surpriseattack",

	questZone = "space_lok",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "inspect_naboo_imperial_tier2_1",
	parentQuestType = "inspect",
	parentQuestName = "naboo_imperial_tier2_1",

	surpriseAttackShips = {
		zone = "space_lok",
		spawns = {{count = 3, shipName = "bloodrazor_berzerker_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_imperial_tier2_1", true)

-- Mission 2: Escort (in Dantooine)
escort_naboo_imperial_tier2_2 = SpaceEscortScreenplay:new {
	className = "escort_naboo_imperial_tier2_2",

	questName = "naboo_imperial_tier2_2",
	questType = "escort",

	questZone = "space_dantooine",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier3"},

	escortPoints = {
		{patrolPointName = "naboo_imperial_tier2_2_1", zoneName = "space_dantooine", x = 1000, z = -900, y = -2100, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_2_2", zoneName = "space_dantooine", x = -28, z = -908, y = -2207, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_2_3", zoneName = "space_dantooine", x = -1158, z = -952, y = -2363, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_2_4", zoneName = "space_dantooine", x = -2566, z = -1057, y = -2599, escortNumber = 4, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_2_5", zoneName = "space_dantooine", x = -2436, z = -1574, y = -3167, escortNumber = 5, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_2_6", zoneName = "space_dantooine", x = -2129, z = -1970, y = -3738, escortNumber = 6, radius = 250},
	},

	attackDelay = 70,

	attackShips = {
		{"bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2", "bloodrazor_cutthroat_tier2"},
		{"bloodrazor_berzerker_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2"},
		{"bloodrazor_destroyer_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2"},
	}
}

registerScreenPlay("escort_naboo_imperial_tier2_2", true)

-- Mission 3: Recovery
recovery_naboo_imperial_tier2_3 = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_imperial_tier2_3",

	questName = "naboo_imperial_tier2_3",
	questType = "recovery",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 15,
	recoveryDelay = 30,

	recoverShip = "viopa_mission_3_shuttle",
	recoveryConversationMobile = "object/mobile/shared_dressed_nym_patrol_elite_nikto_m.iff",

	escortShips = {"bloodrazor_cutthroat_tier2"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_imperial_tier2_3_target_1", zoneName = "space_lok", x = -5500, z = 3900, y = 3600, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_target_2", zoneName = "space_lok", x = -4775, z = 3294, y = 3140, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_target_3", zoneName = "space_lok", x = -3923, z = 2964, y = 2395, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_target_4", zoneName = "space_lok", x = -3191, z = 2904, y = 1706, escortNumber = 4, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_target_5", zoneName = "space_lok", x = -2496, z = 2865, y = 751, escortNumber = 5, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_target_6", zoneName = "space_lok", x = -1540, z = 2528, y = -1100, escortNumber = 6, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier2_3_recover_1", zoneName = "space_lok", x = -3381, z = 2517, y = 877, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_recover_2", zoneName = "space_lok", x = -3512, z = 1885, y = -192, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_recover_3", zoneName = "space_lok", x = -3723, z = 1223, y = -989, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_3_recover_4", zoneName = "space_lok", x = -4257, z = -227, y = -2707, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"bloodrazor_cutthroat_tier2", "bloodrazor_berzerker_tier2"},
		{"bloodrazor_destroyer_tier2", "bloodrazor_berzerker_tier2"},
	},
}

registerScreenPlay("recovery_naboo_imperial_tier2_3", true)

-- Mission 4: Assassinate
assassinate_naboo_imperial_tier2_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier2_4",

	questType = "assassinate",
	questName = "naboo_imperial_tier2_4",

	questZone = "space_lok",

	creditReward = 0,
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "viopa_mission_3_shuttle",
		escorts = {"bloodrazor_berzerker_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2", "bloodrazor_cutthroat_tier2", "bloodrazor_cutthroat_tier2", "bloodrazor_destroyer_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier2_four_1", x = 2800, z = 2400, y = 2800},
		{patrolPointName = "naboo_imperial_tier2_four_2", x = 1662, z = 2407, y = 2790},
		{patrolPointName = "naboo_imperial_tier2_four_3", x = 533, z = 2411, y = 3116},
		{patrolPointName = "naboo_imperial_tier2_four_4", x = -1109, z = 2414, y = 3581},
		{patrolPointName = "naboo_imperial_tier2_four_5", x = -2303, z = 2415, y = 4011},
		{patrolPointName = "naboo_imperial_tier2_four_6", x = -3674, z = 2416, y = 4444},
	},
}

registerScreenPlay("assassinate_naboo_imperial_tier2_4", true)

-- Tier 2 Duty Missions
destroy_duty_naboo_imperial_tier2_destroyduty = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_imperial_tier2_destroyduty",

	questName = "naboo_imperial_tier2_destroyduty",
	questType = "destroy_duty",

	questZone = "space_lok",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "bloodrazor_destroyer_tier3",
	shipTypes = {
		{"bloodrazor_berzerker_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2"},
		{"bloodrazor_cutthroat_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_berzerker_tier2"},
		{"bloodrazor_destroyer_tier2", "bloodrazor_cutthroat_tier2", "bloodrazor_berzerker_tier2"},
	},
}

registerScreenPlay("destroy_duty_naboo_imperial_tier2_destroyduty", true)

recovery_duty_naboo_imperial_tier2_recoveryduty = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_naboo_imperial_tier2_recoveryduty",

	questName = "naboo_imperial_tier2_recoveryduty",
	questType = "recovery_duty",

	questZone = "space_lok",

	creditReward = 2500,
	creditKillBonus = 200,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 15,
	recoveryDelay = 30,

	recoverShips = {"corsair_manowar_tier2", "corsair_behemoth_tier2"},
	recoveryConversationMobile = "object/mobile/shared_dressed_nym_patrol_elite_nikto_m.iff",

	escortShips = {"corsair_sloop_tier2"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_1", zoneName = "space_lok", x = -5007, z = -5499, y = -3499, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_2", zoneName = "space_lok", x = -6466, z = -6879, y = -4229, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_3", zoneName = "space_lok", x = -6974, z = -7081, y = -1544, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_4", zoneName = "space_lok", x = -7169, z = -6943, y = 1241, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_5", zoneName = "space_lok", x = -5700, z = -5955, y = -2034, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_6", zoneName = "space_lok", x = -5033, z = -4822, y = -3028, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_7", zoneName = "space_lok", x = -4768, z = -3941, y = -3678, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier2_recovery_duty_8", zoneName = "space_lok", x = -4757, z = -3078, y = -3964, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"corsair_raider_tier2", "corsair_sloop_tier2"},
		{"corsair_sloop_tier2", "corsair_sloop_tier2"},
	},
}

registerScreenPlay("recovery_duty_naboo_imperial_tier2_recoveryduty", true)

escort_duty_naboo_imperial_tier2_escortduty = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_imperial_tier2_escortduty",

	questName = "naboo_imperial_tier2_escortduty",
	questType = "escort_duty",

	questZone = "space_lok",

	creditReward = 2500,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier2", "imp_freighterlight_tier2", "imp_freightermedium_tier2"},

	escortPoints = {
		{patrolPointName = "lok_imp_escort_duty_1", zoneName = "space_lok", x = 2700, z = 200, y = 2700, escortNumber = 1, radius = 250},
		{patrolPointName = "lok_imp_escort_duty_2", zoneName = "space_lok", x = 1927, z = 285, y = 1901, escortNumber = 2, radius = 250},
		{patrolPointName = "lok_imp_escort_duty_3", zoneName = "space_lok", x = 1564, z = 970, y = 1211, escortNumber = 3, radius = 250},
		{patrolPointName = "lok_imp_escort_duty_4", zoneName = "space_lok", x = 814, z = 429, y = 1053, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"bloodrazor_berzerker_tier2", "bloodrazor_destroyer_tier2", "bloodrazor_cutthroat_tier2"},
		{"bloodrazor_berzerker_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2"},
		{"bloodrazor_destroyer_tier2", "bloodrazor_berzerker_tier2", "bloodrazor_cutthroat_tier2"},
	},

	creditKillBonus = 200,
}

registerScreenPlay("escort_duty_naboo_imperial_tier2_escortduty", true)

--[[
	Tier 3 -- naboo_imperial_tier3 Main Missions (missions-only tier)
]]

-- Mission 1: Recovery (Space Yavin4 - recover an Imperial agent carrying pirate fleet intelligence)
recovery_naboo_imperial_tier3_1 = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_imperial_tier3_1",

	questName = "naboo_imperial_tier3_1",
	questType = "recovery",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_imperial_tier3_1_A",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 20,
	recoveryDelay = 30,

	recoverShip = "tier_3_1_a_spy",
	recoveryConversationMobile = "object/mobile/ig_assassin_droid.iff",

	escortShips = {},

	preRecoveryPoints = {
		{patrolPointName = "spy_flight_path_2", zoneName = "space_yavin4", x = 4793, z = -5425, y = 4509, escortNumber = 1, radius = 250},
		{patrolPointName = "spy_flight_path_3", zoneName = "space_yavin4", x = 4358, z = -4600, y = 4097, escortNumber = 2, radius = 250},
		{patrolPointName = "spy_flight_path_4", zoneName = "space_yavin4", x = 4040, z = -3996, y = 3796, escortNumber = 3, radius = 250},
		{patrolPointName = "spy_flight_path_5", zoneName = "space_yavin4", x = 3589, z = -3140, y = 3370, escortNumber = 4, radius = 250},
		{patrolPointName = "spy_flight_path_6", zoneName = "space_yavin4", x = 3280, z = -2554, y = 3078, escortNumber = 5, radius = 250},
		{patrolPointName = "spy_flight_path_7", zoneName = "space_yavin4", x = 2073, z = -2087, y = 2117, escortNumber = 6, radius = 250},
		{patrolPointName = "spy_flight_path_1", zoneName = "space_yavin4", x = 5199, z = -6199, y = 4893, escortNumber = 7, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "spy_recovery_path_1", zoneName = "space_yavin4", x = 3463, z = -2741, y = 2867, escortNumber = 1, radius = 250},
		{patrolPointName = "spy_recovery_path_2", zoneName = "space_yavin4", x = 3367, z = -2354, y = 2296, escortNumber = 2, radius = 250},
		{patrolPointName = "spy_recovery_path_3", zoneName = "space_yavin4", x = 3282, z = -2008, y = 1786, escortNumber = 3, radius = 250},
		{patrolPointName = "spy_recovery_path_4", zoneName = "space_yavin4", x = 3143, z = -1446, y = 956, escortNumber = 4, radius = 250},
	},

	attackDelay = 70,

	attackShips = {
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s01_tier2"},
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s02_tier2"},
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier2", "blacksun_bomber_s02_tier2"},
	},
}

registerScreenPlay("recovery_naboo_imperial_tier3_1", true)

-- Mission 1 Side Quest A: Patrol (Space Yavin4 - clear a pirate pursuit route)
patrol_naboo_imperial_tier3_1_A = SpacePatrolScreenplay:new {
	className = "patrol_naboo_imperial_tier3_1_A",

	questName = "naboo_imperial_tier3_1_A",
	questType = "patrol",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_imperial_tier3_1_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 3,
	sideQuestDelay = 5,

	parentQuest = "recovery_naboo_imperial_tier3_1",
	parentQuestType = "recovery",
	parentQuestName = "naboo_imperial_tier3_1",

	patrolPoints = {
		{patrolPointName = "inquisition_tier3_mission1a_patrol_1", x = 2793, z = -276, y = -1231, patrolNumber = 1, radius = 150},
		{patrolPointName = "inquisition_tier3_mission1a_patrol_2", x = 3215, z = -695, y = -1854, patrolNumber = 2, radius = 150},
		{patrolPointName = "inquisition_tier3_mission1a_patrol_3", x = 3680, z = -853, y = -2726, patrolNumber = 3, radius = 150},
		{patrolPointName = "inquisition_tier3_mission1a_patrol_4", x = 3975, z = -1404, y = -3805, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_imperial_tier3_1_A", true)

-- Mission 1 Side Quest B: Destroy Surprise Attack (Space Yavin4 - destroy a Black Sun ambush)
destroy_surpriseattack_naboo_imperial_tier3_1_b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_tier3_1_b",

	questName = "naboo_imperial_tier3_1_b",
	questType = "destroy_surpriseattack",

	questZone = "space_yavin4",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_imperial_tier3_1_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "patrol_naboo_imperial_tier3_1_A",
	parentQuestType = "patrol",
	parentQuestName = "naboo_imperial_tier3_1_A",

	surpriseAttackShips = {
		zone = "space_yavin4",
		spawns = {{count = 3, shipName = "blacksun_fighter_s01_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_imperial_tier3_1_b", true)

-- Mission 1 Side Quest C: Assassinate (Space Yavin4 - stop a Black Sun scout from escaping)
assassinate_naboo_imperial_tier3_1_c = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier3_1_c",

	questType = "assassinate",
	questName = "naboo_imperial_tier3_1_c",

	questZone = "space_yavin4",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_imperial_tier3_1_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "destroy_surpriseattack_naboo_imperial_tier3_1_b",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_imperial_tier3_1_b",

	arrivalDelay = 2,
	failTimer = 20,

	assassinateSpawns = {
		target = "blacksun_marauder_tier3",
		escorts = {"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2"},
	},

	targetPatrols = {
		{patrolPointName = "imperial_scout_flight_path_1", zoneName = "space_yavin4", x = 3593, z = -1050, y = -3060},
		{patrolPointName = "imperial_scout_flight_path_2", zoneName = "space_yavin4", x = 3255, z = -758, y = -2450},
		{patrolPointName = "imperial_scout_flight_path_3", zoneName = "space_yavin4", x = 2804, z = -215, y = -1382},
		{patrolPointName = "imperial_scout_flight_path_4", zoneName = "space_yavin4", x = 2290, z = 302, y = -266},
	},
}

registerScreenPlay("assassinate_naboo_imperial_tier3_1_c", true)

-- Mission 1 Side Quest D: Space Battle (Space Yavin4 - assist an Imperial patrol against Black Sun)
space_battle_naboo_imperial_tier3_1_d = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_imperial_tier3_1_d",

	questName = "naboo_imperial_tier3_1_d",
	questType = "space_battle",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_naboo_imperial_tier3_1_c",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_imperial_tier3_1_c",

	battlePoint = "space_yavin4:rebel_tier3_1_d_space_battle",
	allyArrivalDelay = 20,
	enemyArrivalDelay = 35,
	allyOriginDist = -600,
	enemyOriginDist = 800,
	allyArrivalDist = -100,
	enemyArrivalDist = 0,

	alliedShips = {
		{"imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3"},
		{"imp_tie_interceptor_tier3"},
	},

	enemyShips = {
		{"blacksun_fighter_s01_tier3"},
		{"blacksun_fighter_s01_tier3"},
		{"blacksun_fighter_s02_tier3"},
		{"blacksun_bomber_s01_tier3"},
		{"blacksun_bomber_s02_tier3"},
		{"blacksun_marauder_tier3"},
	},
}

registerScreenPlay("space_battle_naboo_imperial_tier3_1_d", true)

-- Mission 2: Inspect (Space Yavin4 - inspect Doctor Shinss' yacht)
inspect_naboo_imperial_tier3_2 = SpaceInspectScreenplay:new {
	className = "inspect_naboo_imperial_tier3_2",

	questName = "naboo_imperial_tier3_2",
	questType = "inspect",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "delivery",
	sideQuestName = "naboo_imperial_tier3_2_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	inspectTargets = {"shinss_yacht_tier3"},
	inspectCargo = "shinss_personal_logs",

	targetLocation = {x = 3196, z = -6203, y = -5010},
}

registerScreenPlay("inspect_naboo_imperial_tier3_2", true)

-- Mission 2 Side Quest A: Delivery (Space Lok - deliver the intelligence to the Imperial Navy)
delivery_naboo_imperial_tier3_2_a = SpaceDeliveryScreenplay:new {
	className = "delivery_naboo_imperial_tier3_2_a",

	questName = "naboo_imperial_tier3_2_a",
	questType = "delivery",

	questZone = "space_lok",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_imperial_tier3_2_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 3,

	parentQuest = "inspect_naboo_imperial_tier3_2",
	parentQuestType = "inspect",
	parentQuestName = "naboo_imperial_tier3_2",

	pickupShip = "imp_tie_fighter_tier2",
	deliveryShip = "imp_transport_tier3",

	pickupPoint = {x = -3000, z = -2000, y = -2600}, -- space_lok:rebel_tier3_2_a_meeting
	deliveryPoint = {x = 1000, z = -2000, y = -3452}, -- space_lok:rebel_tier3_2_a_delivery

	attackDelay = 70,

	attackShips = {
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s01_tier2"},
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier2", "blacksun_bomber_s02_tier2"},
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier2", "blacksun_marauder_tier2"},
	},
}

registerScreenPlay("delivery_naboo_imperial_tier3_2_a", true)

-- Mission 2 Side Quest B: Survival (Space Endor - hold against a Black Sun counterattack)
survival_naboo_imperial_tier3_2_b = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_imperial_tier3_2_b",

	questName = "naboo_imperial_tier3_2_b",
	questType = "survival",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_imperial_tier3_2_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "delivery_naboo_imperial_tier3_2_a",
	parentQuestType = "delivery",
	parentQuestName = "naboo_imperial_tier3_2_a",

	survivalTime = 600,
	survivalUpdateInterval = 60,
	survivalPoint = {x = -153, z = 3803, y = 3265},
	delayToFirstAttack = 5,

	attackDelay = 100,

	attackShips = {
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s01_tier2", "blacksun_bomber_s02_tier2"},
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s01_tier2", "blacksun_marauder_tier2"},
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3", "blacksun_bomber_s01_tier3"},
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3", "blacksun_marauder_tier3"},
		{"blacksun_vehement_tier3", "blacksun_marauder_tier3"},
	},
}

registerScreenPlay("survival_naboo_imperial_tier3_2_b", true)

-- Mission 2 Side Quest C: Escort (Space Endor - escort an Imperial intelligence freighter)
escort_naboo_imperial_tier3_2_c = SpaceEscortScreenplay:new {
	className = "escort_naboo_imperial_tier3_2_c",

	questName = "naboo_imperial_tier3_2_c",
	questType = "escort",

	questZone = "space_endor",

	creditReward = 0,
	completionSystemMessage = "Mission complete. Return to Inquisitor Vrke for further orders.",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "survival_naboo_imperial_tier3_2_b",
	parentQuestType = "survival",
	parentQuestName = "naboo_imperial_tier3_2_b",

	escortShips = {"imp_freighterlight_tier3"},

	escortPoints = {
		{patrolPointName = "inquisition_tier3_mission2c_escort_1", zoneName = "space_endor", x = -239, z = 3935, y = 3280, escortNumber = 1, radius = 250},
		{patrolPointName = "inquisition_tier3_mission2c_escort_2", zoneName = "space_endor", x = -549, z = 3180, y = 3238, escortNumber = 2, radius = 250},
		{patrolPointName = "inquisition_tier3_mission2c_escort_3", zoneName = "space_endor", x = -1251, z = 1477, y = 3143, escortNumber = 3, radius = 250},
		{patrolPointName = "inquisition_tier3_mission2c_escort_4", zoneName = "space_endor", x = -1996, z = -330, y = 3042, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3"},
		{"blacksun_bomber_s01_tier3", "blacksun_marauder_tier3"},
	},
}

registerScreenPlay("escort_naboo_imperial_tier3_2_c", true)

-- Mission 3: Delivery (Space Dathomir - transfer pirate intelligence from a Nym informant)
delivery_naboo_imperial_tier3_3 = SpaceDeliveryScreenplay:new {
	className = "delivery_naboo_imperial_tier3_3",

	questName = "naboo_imperial_tier3_3",
	questType = "delivery",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_imperial_tier3_3_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	pickupShip = "nym_smuggler_freightermedium",
	deliveryShip = "imp_transport_tier3",

	pickupPoint = {x = 4824, z = -1000, y = 264}, -- space_dathomir:naboo_imperial_tier3_delivery3_pickup
	deliveryPoint = {x = -3608, z = 5628, y = 5256}, -- space_dathomir:naboo_imperial_tier3_delivery3_dropoff

	attackDelay = 80,

	attackShips = {
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3"},
		{"blacksun_bomber_s01_tier3", "blacksun_fighter_s02_tier3"},
		{"blacksun_marauder_tier3", "blacksun_vehement_tier3"},
	},
}

registerScreenPlay("delivery_naboo_imperial_tier3_3", true)

-- Mission 3 Side Quest A: Destroy Surprise Attack (Space Dathomir - destroy the late Black Sun fighters)
destroy_surpriseattack_naboo_imperial_tier3_3_a = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_imperial_tier3_3_a",

	questType = "destroy_surpriseattack",
	questName = "naboo_imperial_tier3_3_a",

	questZone = "space_dathomir",

	sideQuest = true,
	sideQuestType = "rescue",
	sideQuestName = "naboo_imperial_tier3_3_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "delivery_naboo_imperial_tier3_3",
	parentQuestType = "delivery",
	parentQuestName = "naboo_imperial_tier3_3",

	surpriseAttackShips = {
		zone = "space_dathomir",
		spawns = {
			{count = 4, shipName = "blacksun_fighter_s01_tier3"},
			{count = 3, shipName = "blacksun_fighter_s02_tier3"},
		},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_imperial_tier3_3_a", true)

-- Mission 3 Side Quest B: Rescue (Space Dathomir - repair and escort a damaged Imperial shuttle)
rescue_naboo_imperial_tier3_3_b = SpaceRescueScreenplay:new {
	className = "rescue_naboo_imperial_tier3_3_b",

	questName = "naboo_imperial_tier3_3_b",
	questType = "rescue",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "inspect",
	sideQuestName = "naboo_imperial_tier3_3_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "destroy_surpriseattack_naboo_imperial_tier3_3_a",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_imperial_tier3_3_a",

	arrivalDelay = 3,
	rescueShip = "imp_lambda_shuttle_tier3",
	rescueLocation = {x = 4300, z = 6400, y = -4900}, -- space_dathomir:naboo_imperial_tier3_rescue1_1
	repairDelay = 30,
	escortSpeed = 60,

	escortPoints = {
		{patrolPointName = "naboo_imperial_tier3_rescue1_2", zoneName = "space_dathomir", x = 222, z = 6250, y = -4778, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier3_rescue1_3", zoneName = "space_dathomir", x = -1638, z = 3789, y = -6552, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier3_rescue1_4", zoneName = "space_dathomir", x = -3555, z = 3445, y = -6578, escortNumber = 3, radius = 250},
	},

	escortAttackDelay = 10,
	escortAttackShips = {
		{{count = 1, shipName = "blacksun_fighter_s01_tier3"}},
	},
}

registerScreenPlay("rescue_naboo_imperial_tier3_3_b", true)

-- Mission 3 Side Quest C: Inspect (Space Dathomir - inspect the Black Sun command vessel)
inspect_naboo_imperial_tier3_3_c = SpaceInspectScreenplay:new {
	className = "inspect_naboo_imperial_tier3_3_c",

	questName = "naboo_imperial_tier3_3_c",
	questType = "inspect",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "naboo_imperial_tier3_3_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 5,

	parentQuest = "rescue_naboo_imperial_tier3_3_b",
	parentQuestType = "rescue",
	parentQuestName = "naboo_imperial_tier3_3_b",

	inspectTargets = {"nym_patrol_craft_tier3"},
	inspectCargo = "conspirator_command_data",
	spawnInspectTarget = true,

	targetLocation = {x = 1936, z = 2300, y = 4704}, -- space_dathomir:naboo_imperial_tier3_recovery2_1
}

registerScreenPlay("inspect_naboo_imperial_tier3_3_c", true)

-- Mission 3 Side Quest D: Delivery No Pickup (Space Naboo - deliver the recovered plans to command)
delivery_no_pickup_naboo_imperial_tier3_3_d = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_naboo_imperial_tier3_3_d",

	questName = "naboo_imperial_tier3_3_d",
	questType = "delivery_no_pickup",

	questZone = "space_naboo",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "inspect_naboo_imperial_tier3_3_c",
	parentQuestType = "inspect",
	parentQuestName = "naboo_imperial_tier3_3_c",

	deliveryShip = "imp_lambda_shuttle_tier3",
	deliveryPoint = {x = 1069, z = 1110, y = 263}, -- space_naboo:naboo_imperial_tier3_delivery4

	attackDelay = 45,

	attackShips = {
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3", "blacksun_fighter_s02_tier3"},
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3"},
	},
}

registerScreenPlay("delivery_no_pickup_naboo_imperial_tier3_3_d", true)

-- Mission 4: Assassinate (Space Dathomir - stop a Black Sun commander reaching pirate reinforcements)
assassinate_naboo_imperial_tier3_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier3_4",

	questType = "assassinate",
	questName = "naboo_imperial_tier3_4",

	questZone = "space_dathomir",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_imperial_tier3_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 15,
	failTimer = 20,

	assassinateSpawns = {
		target = "inquisition_traitor_lambda_tier3",
		escorts = {"inquisition_traitor_tie_interceptor_tier3", "inquisition_traitor_tie_interceptor_tier3", "inquisition_traitor_tie_interceptor_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier3_assassinate1_1", zoneName = "space_dathomir", x = -1879, z = -110, y = -1881},
		{patrolPointName = "naboo_imperial_tier3_assassinate1_2", zoneName = "space_dathomir", x = 19, z = -2029, y = -411},
		{patrolPointName = "naboo_imperial_tier3_assassinate1_3", zoneName = "space_dathomir", x = 2767, z = -3788, y = 1500},
		{patrolPointName = "naboo_imperial_tier3_assassinate1_4", zoneName = "space_dathomir", x = 4998, z = -4963, y = 2982},
	},
}

registerScreenPlay("assassinate_naboo_imperial_tier3_4", true)

-- Mission 4 Side Quest A: Escort (Space Dathomir - escort Doctor Shinss's prison transport)
escort_naboo_imperial_tier3_4_a = SpaceEscortScreenplay:new {
	className = "escort_naboo_imperial_tier3_4_a",

	questName = "naboo_imperial_tier3_4_a",
	questType = "escort",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_imperial_tier3_4_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 5,

	parentQuest = "assassinate_naboo_imperial_tier3_4",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_imperial_tier3_4",

	escortShips = {"dathomir_prison_shuttle_tier4"},
	escortSpeed = 60,

	escortPoints = {
		{patrolPointName = "naboo_imperial_tier3_4_a_escort_1", zoneName = "space_dathomir", x = -3960, z = -400, y = -4950, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier3_4_a_escort_2", zoneName = "space_dathomir", x = -3758, z = 345, y = -4588, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier3_4_a_escort_3", zoneName = "space_dathomir", x = -3460, z = 37, y = -3563, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier3_4_a_escort_4", zoneName = "space_dathomir", x = -2777, z = 778, y = -3350, escortNumber = 4, radius = 250},
	},

	attackDelay = 55,

	attackShips = {
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3", "blacksun_fighter_s02_tier3"},
	},
}

registerScreenPlay("escort_naboo_imperial_tier3_4_a", true)

-- Mission 4 Side Quest B: Space Battle (Space Dathomir - assist the Imperial TIE wing)
space_battle_naboo_imperial_tier3_4_b = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_imperial_tier3_4_b",

	questName = "naboo_imperial_tier3_4_b",
	questType = "space_battle",

	questZone = "space_dathomir",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_imperial_tier3_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "escort_naboo_imperial_tier3_4_a",
	parentQuestType = "escort",
	parentQuestName = "naboo_imperial_tier3_4_a",

	-- The former named battle point was never present in the server patrol-point
	-- registry. SpaceBattleScreenplay requires explicit coordinates in order to
	-- create the approach waypoint and arrival area.
	battleLocation = {x = -160, z = 2428, y = -2525}, -- naboo_imperial_tier4_spacebattle1
	allyArrivalDelay = 60,
	enemyArrivalDelay = 80,
	allyOriginDist = 800,
	enemyOriginDist = -800,
	allyArrivalDist = 100,
	enemyArrivalDist = -50,

	alliedShips = {
		{"imp_tie_interceptor_tier3"},
		{"imp_tie_interceptor_tier3"},
		{"imp_tie_interceptor_tier3"},
		{"imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3"},
	},

	enemyShips = {
		{"reb_ywing_tier3"},
		{"reb_xwing_tier3"},
		{"reb_xwing_tier3"},
		{"reb_xwing_tier3"},
		{"reb_xwing_tier3"},
		{"reb_awing_tier3"},
		{"reb_awing_tier3"},
		{"reb_awing_tier3"},
		{"reb_awing_tier3"},
		{"reb_awing_tier3"},
	},
}

registerScreenPlay("space_battle_naboo_imperial_tier3_4_b", true)

-- Mission 4 Side Quest C: Assassinate (Space Dathomir - destroy the Price of Liberty and its escort)
assassinate_naboo_imperial_tier3_4_c = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_imperial_tier3_4_c",

	questName = "naboo_imperial_tier3_4_c",
	questType = "assassinate",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_naboo_imperial_tier3_4_b",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_imperial_tier3_4_b",

	arrivalDelay = 15,
	failTimer = 20,

	assassinateSpawns = {
		target = "reb_priceofliberty_tier3",
		escorts = {"reb_xwing_tier3", "reb_xwing_tier3", "reb_xwing_tier3", "reb_xwing_tier3", "reb_xwing_tier3", "reb_xwing_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_imperial_tier3_4_c_price_of_liberty", zoneName = "space_dathomir", x = 2005, z = 4299, y = -3566},
	},
}

registerScreenPlay("assassinate_naboo_imperial_tier3_4_c", true)

--[[
	Tier 4 -- naboo_imperial_tier4 Main Missions
]]

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
	deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = 6312, z = 6992, y = -5062},
	waitForAttackShips = true, postDeliveryAttackDelay = 2,
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
		{patrolPointName = "naboo_imperial_tier4_recovery1_1", zoneName = "space_dathomir", x = -7000, z = -5000, y = 7000, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_2", zoneName = "space_dathomir", x = -6000, z = -5500, y = 7000, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_3", zoneName = "space_dathomir", x = -5000, z = -6000, y = 7000, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_4", zoneName = "space_dathomir", x = -4000, z = -6500, y = 7000, escortNumber = 4, radius = 250},
	},
	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery1_5", zoneName = "space_dathomir", x = -3500, z = -7000, y = 6500, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_6", zoneName = "space_dathomir", x = -4500, z = -7000, y = 5500, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_7", zoneName = "space_dathomir", x = -5500, z = -6500, y = 4500, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery1_8", zoneName = "space_dathomir", x = -6500, z = -6000, y = 3500, escortNumber = 4, radius = 250},
	},
	attackDelay = 60, attackShips = {{"coynite_merc_neutron_tier4"}},
}
registerScreenPlay("recovery_naboo_imperial_tier4_2", true)

rescue_naboo_imperial_tier4_2_a = SpaceRescueScreenplay:new {
	className = "rescue_naboo_imperial_tier4_2_a", questName = "naboo_imperial_tier4_2_a", questType = "rescue", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "naboo_imperial_tier4_2_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	parentQuest = "recovery_naboo_imperial_tier4_2", parentQuestType = "recovery", parentQuestName = "naboo_imperial_tier4_2",
	arrivalDelay = 5, rescueShip = "imp_lambda_shuttle_tier4", rescueLocation = {x = -7000, z = 6000, y = 7000}, repairDelay = 20, escortSpeed = 60,
	escortPoints = {
		{patrolPointName = "naboo_imperial_tier4_rescue1_2", zoneName = "space_dathomir", x = -6000, z = 6500, y = 7000, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_rescue1_3", zoneName = "space_dathomir", x = -5000, z = 7000, y = 6500, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_rescue1_4", zoneName = "space_dathomir", x = -4000, z = 7000, y = 5500, escortNumber = 3, radius = 250},
	},
	attackDelay = 60, attackShips = {{{count = 1, shipName = "coynite_merc_quasar_tier4"}}},
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
	preRecoveryPoints = {{patrolPointName = "naboo_imperial_tier4_recovery2_1", zoneName = "space_dathomir", x = -6500, z = -3500, y = 5000, escortNumber = 1, radius = 250}},
	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_recovery2_5", zoneName = "space_dathomir", x = -5500, z = -4000, y = 5500, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery2_6", zoneName = "space_dathomir", x = -4500, z = -4500, y = 6000, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_recovery2_7", zoneName = "space_dathomir", x = -3500, z = -5000, y = 6500, escortNumber = 3, radius = 250},
	},
	attackDelay = 60, attackShips = {{"coynite_merc_pulsar_tier4"}},
}
registerScreenPlay("recovery_naboo_imperial_tier4_2_c", true)

-- Mission 3: intercept and deliver the transmission, then destroy the mothership.
survival_naboo_imperial_tier4_3 = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_imperial_tier4_3", questName = "naboo_imperial_tier4_3", questType = "survival", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "naboo_imperial_tier4_3_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	survivalTime = 420, survivalUpdateInterval = 60, survivalPoint = "space_dathomir:naboo_imperial_tier4_survival1", delayToFirstAttack = 5, attackDelay = 45,
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
	escortShips = {"dathomir_prison_shuttle_tier5"}, escortSpeed = 60,
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

-- Master Mission (two-stage Kessel encounter): destroy_master_imperial_1 (Kessel:
-- destroy 30 Rebel fighters) and destroy_master_imperial_2 (Kessel: destroy the Rebel
-- Corellian Corvette command vessel) are defined in
-- screenplays/space/squadrons/KesselMasterEncounterScreenplay.lua (loaded first).

-- Tier 4 Duty Missions

-- Escort Duty (Space Dathomir - escort Imperial supply freighters through pirate territory)
escort_duty_naboo_imperial_tier4_1 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_imperial_tier4_1",

	questName = "naboo_imperial_tier4_1",
	questType = "escort_duty",

	questZone = "space_dathomir",

	creditReward = 5000,
	creditKillBonus = 300,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_freighterheavy_tier4", "imp_freighterlight_tier4", "imp_freightermedium_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_imperial_tier4_escort1_1", zoneName = "space_dathomir", x = 3787, z = -6425, y = 49, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_2", zoneName = "space_dathomir", x = 3065, z = -5248, y = 1760, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_3", zoneName = "space_dathomir", x = 2200, z = -4231, y = 2864, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_escort1_4", zoneName = "space_dathomir", x = 1502, z = -3172, y = 4240, escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4", "blacksun_bomber_s01_tier4", "blacksun_marauder_tier4"},
		{"blacksun_fighter_s02_tier4", "blacksun_fighter_s03_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4"},
		{"blacksun_fighter_s01_tier4", "blacksun_bomber_s02_tier4", "blacksun_gunship_tier4", "blacksun_marauder_tier4"},
		{"blacksun_fighter_s03_tier4", "blacksun_bomber_s03_tier4", "blacksun_vehement_tier4", "blacksun_gunship_tier4"},
	},
}

registerScreenPlay("escort_duty_naboo_imperial_tier4_1", true)

-- Rescue Duty (Space Dantooine - rescue disabled Imperial ships after pirate attacks)
rescue_duty_naboo_imperial_tier4_1 = SpaceDutyRescueScreenplay:new {
	className = "rescue_duty_naboo_imperial_tier4_1",

	questName = "naboo_imperial_tier4_1",
	questType = "rescue_duty",

	questZone = "space_dantooine",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	targetShips = {"imp_tie_fighter_tier4", "imp_lambda_shuttle_tier4", "imp_tie_bomber_tier4", "imp_transport_tier4", "imp_freightermedium_tier4", "imp_freighterheavy_tier4", "imp_freighterlight_tier4"},

	targetArrivalDelay = 3,

	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_1_rescue_duty_1", zoneName = "space_dantooine", x = -471, z = -1739, y = 1798, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_rescue_duty_2", zoneName = "space_dantooine", x = 294, z = 509, y = 3594, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_rescue_duty_3", zoneName = "space_dantooine", x = 1562, z = 97, y = 5577, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_rescue_duty_4", zoneName = "space_dantooine", x = 2910, z = -386, y = 7314, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_rescue_duty_5", zoneName = "space_dantooine", x = -6362, z = -477, y = 3393, radius = 250},
	},

	attackDelay = 60,

	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4", "blacksun_bomber_s01_tier4"},
		{"blacksun_fighter_s03_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4"},
		{"blacksun_bomber_s02_tier4", "blacksun_gunship_tier4", "blacksun_vehement_tier4"},
	},
}

registerScreenPlay("rescue_duty_naboo_imperial_tier4_1", true)

-- Recovery Duty (Space Endor - Nym pirates infiltrate Imperial troop transports)
recovery_duty_naboo_imperial_tier4_1 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_naboo_imperial_tier4_1",

	questName = "naboo_imperial_tier4_1",
	questType = "recovery_duty",

	questZone = "space_endor",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	recoverShip = "lambdashuttle_troop_transport_ace",
	targetArrivalDelay = 10,
	recoveryDelay = 30,

	recoveryFaction = "nym",
	recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff",

	escortShips = {"blacksun_fighter_s02_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_1", zoneName = "space_endor", x = -778, z = 1426, y = -905, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_2", zoneName = "space_endor", x = -1454, z = 3074, y = -1580, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_3", zoneName = "space_endor", x = -2232, z = 4616, y = -2283, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_4", zoneName = "space_endor", x = -2849, z = 6172, y = -2900, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_5", zoneName = "space_endor", x = 70, z = 3633, y = -2133, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_6", zoneName = "space_endor", x = 2045, z = 4717, y = -3428, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_7", zoneName = "space_endor", x = 3980, z = 5779, y = -4704, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_imperial_tier4_1_recovery_duty_8", zoneName = "space_endor", x = 6111, z = 7006, y = -6049, escortNumber = 4, radius = 250},
	},

	attackDelay = 45,

	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4", "blacksun_bomber_s01_tier4", "blacksun_marauder_tier4"},
		{"blacksun_fighter_s02_tier4", "blacksun_fighter_s03_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4"},
		{"blacksun_bomber_s02_tier4", "blacksun_gunship_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4"},
	},
}

registerScreenPlay("recovery_duty_naboo_imperial_tier4_1", true)

-- Destroy Duty (Space Dantooine - suppress Black Sun raiding forces)
destroy_duty_naboo_imperial_tier4_1 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_imperial_tier4_1",

	questName = "naboo_imperial_tier4_1",
	questType = "destroy_duty",

	questZone = "space_dantooine",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 5,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "blacksun_marauder_tier4",
	shipTypes = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
		{"blacksun_fighter_s01_tier4"},
		{"blacksun_vehement_tier4"},
	},
}

registerScreenPlay("destroy_duty_naboo_imperial_tier4_1", true)

--[[

	InquisitionSquadronScreenplay

]]

InquisitionSquadronScreenplay = ScreenPlay:new {
	screenplayName = "InquisitionSquadronScreenplay",

	-- Tier 1 (Lt. Barn Sinkko)
	QUEST_STRING_1 = {type = "patrol", name = "naboo_imperial_1"},
	QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "naboo_imperial_1"},
	QUEST_STRING_2 = {type = "destroy", name = "naboo_imperial_2"},
	QUEST_STRING_3 = {type = "patrol", name = "naboo_imperial_3"},
	QUEST_STRING_3_SIDE = {type = "escort", name = "naboo_imperial_3"},
	QUEST_STRING_4 = {type = "assassinate", name = "naboo_imperial_4"},
	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_imperial_6"},
	QUEST_STRING_DUTY_2 = {type = "escort_duty", name = "naboo_imperial_7"},

	-- Tier 2
	TIER2_QUEST_STRING_1 = {type = "inspect", name = "naboo_imperial_tier2_1"},
	TIER2_QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "naboo_imperial_tier2_1"},
	TIER2_QUEST_STRING_2 = {type = "escort", name = "naboo_imperial_tier2_2"},
	TIER2_QUEST_STRING_3 = {type = "recovery", name = "naboo_imperial_tier2_3"},
	TIER2_QUEST_STRING_4 = {type = "assassinate", name = "naboo_imperial_tier2_4"},
	TIER2_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_imperial_tier2_destroyduty"},
	TIER2_QUEST_STRING_DUTY_2 = {type = "recovery_duty", name = "naboo_imperial_tier2_recoveryduty"},
	TIER2_QUEST_STRING_DUTY_3 = {type = "escort_duty", name = "naboo_imperial_tier2_escortduty"},

	-- Tier 3
	TIER3_QUEST_STRING_1 = {type = "recovery", name = "naboo_imperial_tier3_1"},
	TIER3_QUEST_STRING_1_SIDE1 = {type = "patrol", name = "naboo_imperial_tier3_1_A"},
	TIER3_QUEST_STRING_1_SIDE2 = {type = "destroy_surpriseattack", name = "naboo_imperial_tier3_1_b"},
	TIER3_QUEST_STRING_1_SIDE3 = {type = "assassinate", name = "naboo_imperial_tier3_1_c"},
	TIER3_QUEST_STRING_1_SIDE4 = {type = "space_battle", name = "naboo_imperial_tier3_1_d"},
	TIER3_QUEST_STRING_2 = {type = "inspect", name = "naboo_imperial_tier3_2"},
	TIER3_QUEST_STRING_2_SIDE1 = {type = "delivery", name = "naboo_imperial_tier3_2_a"},
	TIER3_QUEST_STRING_2_SIDE2 = {type = "survival", name = "naboo_imperial_tier3_2_b"},
	TIER3_QUEST_STRING_2_SIDE3 = {type = "escort", name = "naboo_imperial_tier3_2_c"},
	TIER3_QUEST_STRING_3 = {type = "delivery", name = "naboo_imperial_tier3_3"},
	TIER3_QUEST_STRING_3_SIDE1 = {type = "destroy_surpriseattack", name = "naboo_imperial_tier3_3_a"},
	TIER3_QUEST_STRING_3_SIDE2 = {type = "rescue", name = "naboo_imperial_tier3_3_b"},
	TIER3_QUEST_STRING_3_SIDE3 = {type = "inspect", name = "naboo_imperial_tier3_3_c"},
	TIER3_QUEST_STRING_3_SIDE4 = {type = "delivery_no_pickup", name = "naboo_imperial_tier3_3_d"},
	TIER3_QUEST_STRING_4 = {type = "assassinate", name = "naboo_imperial_tier3_4"},
	TIER3_QUEST_STRING_4_SIDE1 = {type = "escort", name = "naboo_imperial_tier3_4_a"},
	TIER3_QUEST_STRING_4_SIDE2 = {type = "space_battle", name = "naboo_imperial_tier3_4_b"},
	TIER3_QUEST_STRING_4_SIDE3 = {type = "assassinate", name = "naboo_imperial_tier3_4_c"},

	-- Tier 4
	TIER4_QUEST_STRING_1 = {type = "patrol", name = "naboo_imperial_tier4_1"},
	TIER4_QUEST_STRING_1_SIDE1 = {type = "inspect", name = "naboo_imperial_tier4_1_a"},
	TIER4_QUEST_STRING_1_SIDE2 = {type = "destroy_surpriseattack", name = "naboo_imperial_tier4_1_b"},
	TIER4_QUEST_STRING_1_SIDE3 = {type = "delivery_no_pickup", name = "naboo_imperial_tier4_1_c"},
	TIER4_QUEST_STRING_2 = {type = "recovery", name = "naboo_imperial_tier4_2"},
	TIER4_QUEST_STRING_2_SIDE1 = {type = "rescue", name = "naboo_imperial_tier4_2_a"},
	TIER4_QUEST_STRING_2_SIDE2 = {type = "destroy_surpriseattack", name = "naboo_imperial_tier4_2_b"},
	TIER4_QUEST_STRING_2_SIDE3 = {type = "recovery", name = "naboo_imperial_tier4_2_c"},
	TIER4_QUEST_STRING_3 = {type = "survival", name = "naboo_imperial_tier4_3"},
	TIER4_QUEST_STRING_3_SIDE1 = {type = "delivery_no_pickup", name = "naboo_imperial_tier4_3_a"},
	TIER4_QUEST_STRING_3_SIDE2 = {type = "assassinate", name = "naboo_imperial_tier4_3_b"},
	TIER4_QUEST_STRING_4 = {type = "escort", name = "naboo_imperial_tier4_4"},
	TIER4_QUEST_STRING_4_SIDE1 = {type = "recovery", name = "naboo_imperial_tier4_4_a"},
	TIER4_QUEST_STRING_4_SIDE2 = {type = "assassinate", name = "naboo_imperial_tier4_4_b"},
	TIER4_QUEST_STRING_4_SIDE3 = {type = "assassinate", name = "naboo_imperial_tier4_4_c"},
	TIER4_QUEST_STRING_4_SIDE4 = {type = "space_battle", name = "naboo_imperial_tier4_4_d"},
	TIER4_QUEST_STRING_MASTER = {type = "destroy", name = "master_imperial_1"},
	TIER4_QUEST_STRING_MASTER_2 = {type = "destroy", name = "master_imperial_2"},
	TIER4_QUEST_STRING_DUTY_1 = {type = "escort_duty", name = "naboo_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_2 = {type = "rescue_duty", name = "naboo_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_3 = {type = "recovery_duty", name = "naboo_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_4 = {type = "destroy_duty", name = "naboo_imperial_tier4_1"},
}

registerScreenPlay("InquisitionSquadronScreenplay", false)

function InquisitionSquadronScreenplay:start()
end

-- Reset functions for quest clearing

-- A failed or deleted campaign mission restarts at the beginning of its chain.
-- Clear every stage before starting the parent so stale waypoints, observers,
-- mission ships, journal flags, and duplicate datapad objects cannot leak into
-- the new attempt.
function InquisitionSquadronScreenplay:prepareMissionChainAttempt(pPlayer, missionScreenplays, missionQuests)
	if (pPlayer == nil) then
		return
	end

	-- Reset deepest stages first so their runtime state is gone before the parent.
	for i = #missionScreenplays, 1, -1 do
		missionScreenplays[i]:resetQuest(pPlayer)
	end

	for i = 1, #missionQuests do
		SpaceHelpers:clearSpaceQuest(pPlayer, missionQuests[i].type, missionQuests[i].name, false)
	end
end

function InquisitionSquadronScreenplay:resetSinkkoQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	patrol_naboo_imperial_1:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_imperial_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1.type, self.QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1_SIDE.type, self.QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	destroy_naboo_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_2.type, self.QUEST_STRING_2.name, false)

	-- Mission 3
	patrol_naboo_imperial_3:resetQuest(pPlayer)
	escort_naboo_imperial_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3.type, self.QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3_SIDE.type, self.QUEST_STRING_3_SIDE.name, false)

	-- Mission 4
	assassinate_naboo_imperial_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_4.type, self.QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "InquisitionSquadronScreenplay:sinkko_finished")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.QUEST_STRING_4.name .. ":reward")
end

function InquisitionSquadronScreenplay:resetTier2Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	inspect_naboo_imperial_tier2_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1.type, self.TIER2_QUEST_STRING_1.name, false)
	destroy_surpriseattack_naboo_imperial_tier2_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1_SIDE.type, self.TIER2_QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	escort_naboo_imperial_tier2_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_2.type, self.TIER2_QUEST_STRING_2.name, false)

	-- Mission 3
	recovery_naboo_imperial_tier2_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_3.type, self.TIER2_QUEST_STRING_3.name, false)

	-- Mission 4
	assassinate_naboo_imperial_tier2_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_4.type, self.TIER2_QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":introduced")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward")
	removeQuestStatus(playerID .. "InquisitionSquadron:tier2Smuggler")
end

function InquisitionSquadronScreenplay:resetTier3Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	recovery_naboo_imperial_tier3_1:resetQuest(pPlayer)
	patrol_naboo_imperial_tier3_1_A:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_imperial_tier3_1_b:resetQuest(pPlayer)
	assassinate_naboo_imperial_tier3_1_c:resetQuest(pPlayer)
	space_battle_naboo_imperial_tier3_1_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1.type, self.TIER3_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE1.type, self.TIER3_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE2.type, self.TIER3_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE3.type, self.TIER3_QUEST_STRING_1_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE4.type, self.TIER3_QUEST_STRING_1_SIDE4.name, false)

	-- Mission 2
	inspect_naboo_imperial_tier3_2:resetQuest(pPlayer)
	delivery_naboo_imperial_tier3_2_a:resetQuest(pPlayer)
	survival_naboo_imperial_tier3_2_b:resetQuest(pPlayer)
	escort_naboo_imperial_tier3_2_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2.type, self.TIER3_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE1.type, self.TIER3_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE2.type, self.TIER3_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE3.type, self.TIER3_QUEST_STRING_2_SIDE3.name, false)

	-- Mission 3
	delivery_naboo_imperial_tier3_3:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_imperial_tier3_3_a:resetQuest(pPlayer)
	rescue_naboo_imperial_tier3_3_b:resetQuest(pPlayer)
	inspect_naboo_imperial_tier3_3_c:resetQuest(pPlayer)
	delivery_no_pickup_naboo_imperial_tier3_3_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3.type, self.TIER3_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE1.type, self.TIER3_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE2.type, self.TIER3_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE3.type, self.TIER3_QUEST_STRING_3_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE4.type, self.TIER3_QUEST_STRING_3_SIDE4.name, false)

	-- Mission 4
	assassinate_naboo_imperial_tier3_4:resetQuest(pPlayer)
	escort_naboo_imperial_tier3_4_a:resetQuest(pPlayer)
	space_battle_naboo_imperial_tier3_4_b:resetQuest(pPlayer)
	assassinate_naboo_imperial_tier3_4_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4.type, self.TIER3_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE1.type, self.TIER3_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE2.type, self.TIER3_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE3.type, self.TIER3_QUEST_STRING_4_SIDE3.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward")
end

function InquisitionSquadronScreenplay:resetTier4Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	patrol_naboo_imperial_tier4_1:resetQuest(pPlayer)
	inspect_naboo_imperial_tier4_1_a:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_imperial_tier4_1_b:resetQuest(pPlayer)
	delivery_no_pickup_naboo_imperial_tier4_1_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1.type, self.TIER4_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE1.type, self.TIER4_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE2.type, self.TIER4_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE3.type, self.TIER4_QUEST_STRING_1_SIDE3.name, false)

	-- Mission 2
	recovery_naboo_imperial_tier4_2:resetQuest(pPlayer)
	rescue_naboo_imperial_tier4_2_a:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_imperial_tier4_2_b:resetQuest(pPlayer)
	recovery_naboo_imperial_tier4_2_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2.type, self.TIER4_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE1.type, self.TIER4_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE2.type, self.TIER4_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE3.type, self.TIER4_QUEST_STRING_2_SIDE3.name, false)

	-- Mission 3
	survival_naboo_imperial_tier4_3:resetQuest(pPlayer)
	delivery_no_pickup_naboo_imperial_tier4_3_a:resetQuest(pPlayer)
	assassinate_naboo_imperial_tier4_3_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3.type, self.TIER4_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE1.type, self.TIER4_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE2.type, self.TIER4_QUEST_STRING_3_SIDE2.name, false)

	-- Mission 4
	escort_naboo_imperial_tier4_4:resetQuest(pPlayer)
	recovery_naboo_imperial_tier4_4_a:resetQuest(pPlayer)
	assassinate_naboo_imperial_tier4_4_b:resetQuest(pPlayer)
	assassinate_naboo_imperial_tier4_4_c:resetQuest(pPlayer)
	space_battle_naboo_imperial_tier4_4_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4.type, self.TIER4_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE1.type, self.TIER4_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2.type, self.TIER4_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE3.type, self.TIER4_QUEST_STRING_4_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE4.type, self.TIER4_QUEST_STRING_4_SIDE4.name, false)

	-- Master (two-stage Kessel corvette encounter)
	destroy_master_imperial_1:resetQuest(pPlayer)
	destroy_master_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER.type, self.TIER4_QUEST_STRING_MASTER.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER_2.type, self.TIER4_QUEST_STRING_MASTER_2.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "InquisitionSquadronScreenplay:StartedTier4")

	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward")
end

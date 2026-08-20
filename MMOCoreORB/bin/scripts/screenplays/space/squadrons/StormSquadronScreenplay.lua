local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Storm Squadron Missions (Imperial - Tatooine)

]]

--[[
	Tier 1 -- Lt. Akal Colzet Main Missions (Tatooine)
]]

-- Mission 1: Patrol with surprise attack
patrol_tatooine_imperial_1 = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_imperial_1",

	questName = "tatooine_imperial_1",
	questType = "patrol",

	questZone = "space_tatooine",

	creditReward = 100,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_imperial_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "rebel_patrol_1", x = 6439, z = -5021, y = -2217, patrolNumber = 1, radius = 150},
		{patrolPointName = "rebel_patrol_2", x = 6031, z = -4540, y = -1962, patrolNumber = 2, radius = 150},
		{patrolPointName = "rebel_patrol_3", x = 4891, z = -3215, y = -1345, patrolNumber = 3, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_imperial_1", true)

destroy_surpriseattack_tatooine_imperial_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_imperial_1",

	questName = "tatooine_imperial_1",
	questType = "destroy_surpriseattack",

	questZone = "space_tatooine",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_tatooine_imperial_1",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_imperial_1",

	surpriseAttackShips = {
		zone = "space_tatooine",
		spawns = {{count = 3, shipName = "borvo_fighter_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_tatooine_imperial_1", true)

-- Mission 2: Destroy
destroy_tatooine_imperial_2 = SpaceDestroyScreenplay:new {
	className = "destroy_tatooine_imperial_2",

	questName = "tatooine_imperial_2",
	questType = "destroy",

	questZone = "space_tatooine",

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
		"borvo_fighter_tier1", "borvo_fighter_tier1", "borvo_fighter_tier1", "borvo_fighter_tier1",
	},
}

registerScreenPlay("destroy_tatooine_imperial_2", true)

-- Mission 3: Patrol with escort side quest
patrol_tatooine_imperial_3 = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_imperial_3",

	questName = "tatooine_imperial_3",
	questType = "patrol",

	questZone = "space_tatooine",

	creditReward = 500,
	itemReward = {
		{species = {SPECIES_WOOKIEE}, item = "object/tangible/wearables/bandolier/multipocket_bandolier.iff"},
		{species = {SPECIES_ITHORIAN}, item = "object/tangible/wearables/bandolier/ith_multipocket_bandolier.iff"},
		{species = {-1}, item = "object/tangible/wearables/bodysuit/bodysuit_s14.iff"},
	},

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "tatooine_imperial_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "rebel_security_patrol_1", x = 5024, z = -3710, y = -1723, patrolNumber = 1, radius = 150},
		{patrolPointName = "rebel_security_patrol_2", x = 3933, z = -3285, y = -3098, patrolNumber = 2, radius = 150},
		{patrolPointName = "rebel_security_patrol_3", x = 3574, z = -2819, y = -4741, patrolNumber = 3, radius = 150},
		{patrolPointName = "rebel_security_patrol_4", x = 4496, z = -1657, y = -6222, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_imperial_3", true)

escort_tatooine_imperial_3 = SpaceEscortScreenplay:new {
	className = "escort_tatooine_imperial_3",

	questName = "tatooine_imperial_3",
	questType = "escort",

	questZone = "space_tatooine",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_tatooine_imperial_3",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_imperial_3",

	escortShips = {"imp_freightermedium_tier1"},

	escortPoints = {
		{patrolPointName = "rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "rebel_escort_2", zoneName = "space_tatooine", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "rebel_escort_3", zoneName = "space_tatooine", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"borvo_fighter_tier1"},
		{"borvo_fighter_tier1"},
		{"borvo_fighter_tier1"},
	}
}

registerScreenPlay("escort_tatooine_imperial_3", true)

-- Mission 4: Assassinate
assassinate_tatooine_imperial_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_4",

	questType = "assassinate",
	questName = "tatooine_imperial_4",

	questZone = "space_tatooine",

	creditReward = 1000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/armor/arm_mission_reward_rebel_incom_ultralight.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 6,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_boss_tier2",
		escorts = {"borvo_fighter_tier1", "borvo_fighter_tier1", "borvo_fighter_tier1", "borvo_fighter_tier1"},
	},

	targetPatrols = {
		{patrolPointName = "rebel_security_patrol_2", x = 3933, z = -3285, y = -3098},
		{patrolPointName = "naboo_privateer_tier3_leg_2_rescue_egress_4", x = 1156, z = -7106, y = -2482},
		{patrolPointName = "trade_escort_4", x = 895, z = 210, y = 695},
		{patrolPointName = "military_escort_2", x = 2915, z = 3828, y = 2887},
		{patrolPointName = "corellia_imperial_tier3_leg_1_recovery_recover_1", x = 752, z = -2678, y = -1479},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_4", true)

-- Sinkko Duty Missions
destroy_duty_tatooine_imperial_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_imperial_6",

	questName = "tatooine_imperial_6",
	questType = "destroy_duty",

	questZone = "space_tatooine",

	creditReward = 100,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "borvo_boss_tier2",
	shipTypes = {
		{"borvo_fighter_tier1"},
	},
}

registerScreenPlay("destroy_duty_tatooine_imperial_6", true)

escort_duty_tatooine_imperial_7 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_imperial_7",

	questName = "tatooine_imperial_7",
	questType = "escort_duty",

	questZone = "space_tatooine",

	creditReward = 1000,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier1", "imp_freightermedium_tier1", "imp_freighterlight_tier1", "imp_freighterheavy_tier1"},

	escortPoints = {
		{patrolPointName = "rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 2, radius = 250},
		{patrolPointName = "rebel_patrol_1", zoneName = "space_tatooine", x = 6439, z = -5021, y = -2217, escortNumber = 3, radius = 250},
		{patrolPointName = "rebel_patrol_3", zoneName = "space_tatooine", x = 4891, z = -3215, y = -1345, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"borvo_fighter_tier1_naboo"},
		{"borvo_fighter_tier1_naboo"},
		{"borvo_fighter_tier1_naboo"},
	},

	creditKillBonus = 100,
}

registerScreenPlay("escort_duty_tatooine_imperial_7", true)

--[[
	Tier 2 -- tatooine_imperial_tier2 Main Missions
]]

-- Mission 1: Inspect with surprise attack side quest
inspect_tatooine_imperial_tier2_1 = SpaceInspectScreenplay:new {
	className = "inspect_tatooine_imperial_tier2_1",

	questName = "tatooine_imperial_tier2_1",
	questType = "inspect",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_imperial_tier2_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	inspectTargets = {"viopa_mission_1_shuttle"},
	inspectCargo = "imperial_data",

	targetLocation = {x = 1992, z = 800, y = 2716},
}

registerScreenPlay("inspect_tatooine_imperial_tier2_1", true)

destroy_surpriseattack_tatooine_imperial_tier2_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_imperial_tier2_1",

	questName = "tatooine_imperial_tier2_1",
	questType = "destroy_surpriseattack",

	questZone = "space_lok",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "inspect_tatooine_imperial_tier2_1",
	parentQuestType = "inspect",
	parentQuestName = "tatooine_imperial_tier2_1",

	surpriseAttackShips = {
		zone = "space_lok",
		spawns = {{count = 3, shipName = "bloodrazor_berzerker_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_tatooine_imperial_tier2_1", true)

-- Mission 2: Escort (in Dantooine)
escort_tatooine_imperial_tier2_2 = SpaceEscortScreenplay:new {
	className = "escort_tatooine_imperial_tier2_2",

	questName = "tatooine_imperial_tier2_2",
	questType = "escort",

	questZone = "space_dantooine",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier3"},

	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier2_2_1", zoneName = "space_dantooine", x = 1000, z = -900, y = -2100, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_2_2", zoneName = "space_dantooine", x = -28, z = -908, y = -2207, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_2_3", zoneName = "space_dantooine", x = -1158, z = -952, y = -2363, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_2_4", zoneName = "space_dantooine", x = -2566, z = -1057, y = -2599, escortNumber = 4, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_2_5", zoneName = "space_dantooine", x = -2436, z = -1574, y = -3167, escortNumber = 5, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_2_6", zoneName = "space_dantooine", x = -2129, z = -1970, y = -3738, escortNumber = 6, radius = 250},
	},

	attackDelay = 70,

	attackShips = {
		{"borvo_bomber_tier2", "borvo_fighter_tier2", "borvo_fighter_tier2"},
		{"borvo_bomber_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2"},
		{"borvo_defender_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2"},
	}
}

registerScreenPlay("escort_tatooine_imperial_tier2_2", true)

-- Mission 3: Recovery
recovery_tatooine_imperial_tier2_3 = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_imperial_tier2_3",

	questName = "tatooine_imperial_tier2_3",
	questType = "recovery",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 15,
	recoveryDelay = 30,

	recoverShip = "viopa_mission_3_shuttle",
	recoveryConversationMobile = "object/mobile/shared_dressed_nym_patrol_elite_nikto_m.iff",

	escortShips = {"borvo_fighter_tier2"},

	preRecoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier2_3_target_1", zoneName = "space_lok", x = -5500, z = 3900, y = 3600, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_target_2", zoneName = "space_lok", x = -4775, z = 3294, y = 3140, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_target_3", zoneName = "space_lok", x = -3923, z = 2964, y = 2395, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_target_4", zoneName = "space_lok", x = -3191, z = 2904, y = 1706, escortNumber = 4, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_target_5", zoneName = "space_lok", x = -2496, z = 2865, y = 751, escortNumber = 5, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_target_6", zoneName = "space_lok", x = -1540, z = 2528, y = -1100, escortNumber = 6, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier2_3_recover_1", zoneName = "space_lok", x = -3381, z = 2517, y = 877, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_recover_2", zoneName = "space_lok", x = -3512, z = 1885, y = -192, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_recover_3", zoneName = "space_lok", x = -3723, z = 1223, y = -989, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_3_recover_4", zoneName = "space_lok", x = -4257, z = -227, y = -2707, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"borvo_fighter_tier2", "borvo_bomber_tier2"},
		{"borvo_defender_tier2", "borvo_bomber_tier2"},
	},
}

registerScreenPlay("recovery_tatooine_imperial_tier2_3", true)

-- Mission 4: Assassinate
assassinate_tatooine_imperial_tier2_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier2_4",

	questType = "assassinate",
	questName = "tatooine_imperial_tier2_4",

	questZone = "space_lok",

	creditReward = 0,
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_defender_tier2",
		escorts = {"borvo_bomber_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2", "borvo_fighter_tier2", "borvo_fighter_tier2", "borvo_defender_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier2_four_1", x = 2800, z = 2400, y = 2800},
		{patrolPointName = "tatooine_imperial_tier2_four_2", x = 1662, z = 2407, y = 2790},
		{patrolPointName = "tatooine_imperial_tier2_four_3", x = 533, z = 2411, y = 3116},
		{patrolPointName = "tatooine_imperial_tier2_four_4", x = -1109, z = 2414, y = 3581},
		{patrolPointName = "tatooine_imperial_tier2_four_5", x = -2303, z = 2415, y = 4011},
		{patrolPointName = "tatooine_imperial_tier2_four_6", x = -3674, z = 2416, y = 4444},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier2_4", true)

-- Tier 2 Duty Missions
destroy_duty_tatooine_imperial_tier2_destroyduty = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_imperial_tier2_destroyduty",

	questName = "tatooine_imperial_tier2_destroyduty",
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

	bossShip = "borvo_defender_tier3",
	shipTypes = {
		{"borvo_bomber_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2"},
		{"borvo_fighter_tier2", "borvo_bomber_tier2", "borvo_bomber_tier2"},
		{"borvo_defender_tier2", "borvo_fighter_tier2", "borvo_bomber_tier2"},
	},
}

registerScreenPlay("destroy_duty_tatooine_imperial_tier2_destroyduty", true)

recovery_duty_tatooine_imperial_tier2_recoveryduty = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_tatooine_imperial_tier2_recoveryduty",

	questName = "tatooine_imperial_tier2_recoveryduty",
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
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_1", zoneName = "space_lok", x = -5007, z = -5499, y = -3499, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_2", zoneName = "space_lok", x = -6466, z = -6879, y = -4229, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_3", zoneName = "space_lok", x = -6974, z = -7081, y = -1544, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_4", zoneName = "space_lok", x = -7169, z = -6943, y = 1241, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_5", zoneName = "space_lok", x = -5700, z = -5955, y = -2034, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_6", zoneName = "space_lok", x = -5033, z = -4822, y = -3028, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_7", zoneName = "space_lok", x = -4768, z = -3941, y = -3678, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier2_recovery_duty_8", zoneName = "space_lok", x = -4757, z = -3078, y = -3964, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"corsair_raider_tier2", "corsair_sloop_tier2"},
		{"corsair_sloop_tier2", "corsair_sloop_tier2"},
	},
}

registerScreenPlay("recovery_duty_tatooine_imperial_tier2_recoveryduty", true)

escort_duty_tatooine_imperial_tier2_escortduty = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_imperial_tier2_escortduty",

	questName = "tatooine_imperial_tier2_escortduty",
	questType = "escort_duty",

	questZone = "space_lok",

	creditReward = 2500,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier2", "imp_freighterlight_tier2", "imp_freightermedium_tier2"},

	escortPoints = {
		{patrolPointName = "vortex_mission_1_4", zoneName = "space_lok", x = -1009, z = -1075, y = -2900, escortNumber = 1, radius = 250},
		{patrolPointName = "lok_imp_pirate_9", zoneName = "space_lok", x = 1492, z = 662, y = -2814, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_mission_1_1", zoneName = "space_lok", x = 2241, z = -1210, y = -2943, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_mission_1_5", zoneName = "space_lok", x = -2464, z = -1051, y = -2900, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"borvo_bomber_tier2", "borvo_defender_tier2", "borvo_fighter_tier2"},
		{"borvo_bomber_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2"},
		{"borvo_defender_tier2", "borvo_bomber_tier2", "borvo_fighter_tier2"},
	},

	creditKillBonus = 200,
}

registerScreenPlay("escort_duty_tatooine_imperial_tier2_escortduty", true)

--[[
	Tier 3 -- tatooine_imperial_tier3 Main Missions (missions-only tier)
]]

-- Mission 1: Recovery (Space Yavin4 - recover an Imperial agent carrying pirate fleet intelligence)
recovery_tatooine_imperial_tier3_1 = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_imperial_tier3_1",

	questName = "tatooine_imperial_tier3_1",
	questType = "recovery",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "tatooine_imperial_tier3_1_A",
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
		{"borvo_fighter_tier2", "borvo_defender_tier2", "borvo_bomber_tier2"},
		{"borvo_fighter_tier2", "borvo_defender_tier2", "borvo_bomber_tier2"},
		{"borvo_fighter_tier3", "borvo_defender_tier2", "borvo_bomber_tier2"},
	},
}

registerScreenPlay("recovery_tatooine_imperial_tier3_1", true)

-- Mission 1 Side Quest A: Patrol (Space Yavin4 - clear a pirate pursuit route)
patrol_tatooine_imperial_tier3_1_A = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_imperial_tier3_1_A",

	questName = "tatooine_imperial_tier3_1_A",
	questType = "patrol",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_imperial_tier3_1_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 3,
	sideQuestDelay = 5,

	parentQuest = "recovery_tatooine_imperial_tier3_1",
	parentQuestType = "recovery",
	parentQuestName = "tatooine_imperial_tier3_1",

	patrolPoints = {
		{patrolPointName = "rebel_tier_three_patrol_1", x = 2793, z = -276, y = -1231, patrolNumber = 1, radius = 150},
		{patrolPointName = "rebel_tier_three_patrol_2", x = 3215, z = -695, y = -1854, patrolNumber = 2, radius = 150},
		{patrolPointName = "rebel_tier_three_patrol_3", x = 3680, z = -853, y = -2726, patrolNumber = 3, radius = 150},
		{patrolPointName = "rebel_tier_three_patrol_4", x = 3975, z = -1404, y = -3805, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_imperial_tier3_1_A", true)

-- Mission 1 Side Quest B: Destroy Surprise Attack (Space Yavin4 - destroy a Borvo syndicate ambush)
destroy_surpriseattack_tatooine_imperial_tier3_1_b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_imperial_tier3_1_b",

	questName = "tatooine_imperial_tier3_1_b",
	questType = "destroy_surpriseattack",

	questZone = "space_yavin4",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_imperial_tier3_1_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "patrol_tatooine_imperial_tier3_1_A",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_imperial_tier3_1_A",

	surpriseAttackShips = {
		zone = "space_yavin4",
		spawns = {{count = 3, shipName = "borvo_fighter_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_tatooine_imperial_tier3_1_b", true)

-- Mission 1 Side Quest C: Assassinate (Space Yavin4 - stop a Borvo syndicate scout from escaping)
assassinate_tatooine_imperial_tier3_1_c = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier3_1_c",

	questType = "assassinate",
	questName = "tatooine_imperial_tier3_1_c",

	questZone = "space_yavin4",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier3_1_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "destroy_surpriseattack_tatooine_imperial_tier3_1_b",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "tatooine_imperial_tier3_1_b",

	arrivalDelay = 2,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_defender_tier3",
		escorts = {"borvo_fighter_tier2", "borvo_defender_tier2"},
	},

	targetPatrols = {
		{patrolPointName = "imperial_scout_flight_path_1", zoneName = "space_yavin4", x = 3593, z = -1050, y = -3060},
		{patrolPointName = "imperial_scout_flight_path_2", zoneName = "space_yavin4", x = 3255, z = -758, y = -2450},
		{patrolPointName = "imperial_scout_flight_path_3", zoneName = "space_yavin4", x = 2804, z = -215, y = -1382},
		{patrolPointName = "imperial_scout_flight_path_4", zoneName = "space_yavin4", x = 2290, z = 302, y = -266},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier3_1_c", true)

-- Mission 1 Side Quest D: Space Battle (Space Yavin4 - assist an Imperial patrol against Borvo syndicate)
space_battle_tatooine_imperial_tier3_1_d = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier3_1_d",

	questName = "tatooine_imperial_tier3_1_d",
	questType = "space_battle",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_tatooine_imperial_tier3_1_c",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_imperial_tier3_1_c",

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
		{"borvo_fighter_tier3"},
		{"borvo_fighter_tier3"},
		{"borvo_defender_tier3"},
		{"borvo_bomber_tier3"},
		{"borvo_bomber_tier3"},
		{"borvo_defender_tier3"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier3_1_d", true)

-- Mission 2: Inspect (Space Endor - locate a Hutt smuggler carrying pirate fleet intelligence)
inspect_tatooine_imperial_tier3_2 = SpaceInspectScreenplay:new {
	className = "inspect_tatooine_imperial_tier3_2",

	questName = "tatooine_imperial_tier3_2",
	questType = "inspect",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "delivery",
	sideQuestName = "tatooine_imperial_tier3_2_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	inspectTargets = {"huttsmuggler"},
	inspectCargo = "sector_recon_data",

	targetLocation = {x = 4249, z = 2899, y = 3799},
}

registerScreenPlay("inspect_tatooine_imperial_tier3_2", true)

-- Mission 2 Side Quest A: Delivery (Space Lok - deliver the intelligence to the Imperial Navy)
delivery_tatooine_imperial_tier3_2_a = SpaceDeliveryScreenplay:new {
	className = "delivery_tatooine_imperial_tier3_2_a",

	questName = "tatooine_imperial_tier3_2_a",
	questType = "delivery",

	questZone = "space_lok",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "tatooine_imperial_tier3_2_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 3,

	parentQuest = "inspect_tatooine_imperial_tier3_2",
	parentQuestType = "inspect",
	parentQuestName = "tatooine_imperial_tier3_2",

	pickupShip = "imp_tie_fighter_tier2",
	deliveryShip = "imp_transport_tier3",

	pickupPoint = {x = -3000, z = -2000, y = -2600}, -- space_lok:rebel_tier3_2_a_meeting
	deliveryPoint = {x = 1000, z = -2000, y = -3452}, -- space_lok:rebel_tier3_2_a_delivery

	attackDelay = 70,

	attackShips = {
		{"borvo_fighter_tier2", "borvo_defender_tier2", "borvo_bomber_tier2"},
		{"borvo_fighter_tier2", "borvo_fighter_tier2", "borvo_bomber_tier2"},
		{"borvo_fighter_tier3", "borvo_defender_tier2", "borvo_defender_tier2"},
	},
}

registerScreenPlay("delivery_tatooine_imperial_tier3_2_a", true)

-- Mission 2 Side Quest B: Survival (Space Endor - hold against a Borvo syndicate counterattack)
survival_tatooine_imperial_tier3_2_b = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_imperial_tier3_2_b",

	questName = "tatooine_imperial_tier3_2_b",
	questType = "survival",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "tatooine_imperial_tier3_2_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "delivery_tatooine_imperial_tier3_2_a",
	parentQuestType = "delivery",
	parentQuestName = "tatooine_imperial_tier3_2_a",

	survivalTime = 600,
	survivalPoint = "space_endor:rebel_tier3_2_b_defend_point",
	delayToFirstAttack = 5,

	attackDelay = 100,

	attackShips = {
		{"borvo_fighter_tier2", "borvo_defender_tier2", "borvo_bomber_tier2", "borvo_bomber_tier2"},
		{"borvo_fighter_tier2", "borvo_defender_tier2", "borvo_bomber_tier2", "borvo_defender_tier2"},
		{"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_bomber_tier3"},
		{"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_defender_tier3"},
		{"borvo_boss_tier3", "borvo_defender_tier3"},
	},
}

registerScreenPlay("survival_tatooine_imperial_tier3_2_b", true)

-- Mission 2 Side Quest C: Escort (Space Endor - escort an Imperial intelligence freighter)
escort_tatooine_imperial_tier3_2_c = SpaceEscortScreenplay:new {
	className = "escort_tatooine_imperial_tier3_2_c",

	questName = "tatooine_imperial_tier3_2_c",
	questType = "escort",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "survival_tatooine_imperial_tier3_2_b",
	parentQuestType = "survival",
	parentQuestName = "tatooine_imperial_tier3_2_b",

	escortShips = {"imp_freighterlight_tier3"},

	escortPoints = {
		{patrolPointName = "rebel_tier3_2_c_escort_1", zoneName = "space_endor", x = -239, z = 3935, y = 3280, escortNumber = 1, radius = 250},
		{patrolPointName = "rebel_tier3_2_c_escort_2", zoneName = "space_endor", x = -549, z = 3180, y = 3238, escortNumber = 2, radius = 250},
		{patrolPointName = "rebel_tier3_2_c_escort_3", zoneName = "space_endor", x = -1251, z = 1477, y = 3143, escortNumber = 3, radius = 250},
		{patrolPointName = "rebel_tier3_2_c_escort_4", zoneName = "space_endor", x = -1996, z = -330, y = 3042, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"borvo_fighter_tier3", "borvo_defender_tier3"},
		{"borvo_bomber_tier3", "borvo_defender_tier3"},
	},
}

registerScreenPlay("escort_tatooine_imperial_tier3_2_c", true)

-- Mission 3: Delivery (Space Endor - transfer pirate intelligence from a Nym informant)
delivery_tatooine_imperial_tier3_3 = SpaceDeliveryScreenplay:new {
	className = "delivery_tatooine_imperial_tier3_3",

	questName = "tatooine_imperial_tier3_3",
	questType = "delivery",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_imperial_tier3_3_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	pickupShip = "nym_smuggler",
	deliveryShip = "imp_transport_tier3",

	pickupPoint = "space_endor:tatooine_imperial_tier_3_3_pickup",
	deliveryPoint = "space_endor:tatooine_imperial_tier_3_3_deliver",

	attackDelay = 80,

	attackShips = {
		{"borvo_fighter_tier3", "borvo_defender_tier3"},
		{"borvo_bomber_tier3", "borvo_defender_tier3"},
		{"borvo_defender_tier3", "borvo_boss_tier3"},
	},
}

registerScreenPlay("delivery_tatooine_imperial_tier3_3", true)

-- Mission 3 Side Quest A: Assassinate (Space Endor - destroy a Borvo syndicate command ship)
assassinate_tatooine_imperial_tier3_3_a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier3_3_a",

	questType = "assassinate",
	questName = "tatooine_imperial_tier3_3_a",

	questZone = "space_endor",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier3_3_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "delivery_tatooine_imperial_tier3_3",
	parentQuestType = "delivery",
	parentQuestName = "tatooine_imperial_tier3_3",

	arrivalDelay = 20,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_boss_tier3",
		escorts = {"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_defender_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_1", zoneName = "space_endor", x = 2940, z = -4680, y = 1200},
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_2", zoneName = "space_endor", x = 2922, z = -3692, y = 1654},
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_3", zoneName = "space_endor", x = 2900, z = -2445, y = 2228},
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_4", zoneName = "space_endor", x = 2892, z = -1093, y = 2859},
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_5", zoneName = "space_endor", x = 2892, z = 55, y = 3394},
		{patrolPointName = "tatooine_imperial_tier3_3_a_spyship_6", zoneName = "space_endor", x = 2892, z = 1122, y = 3890},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier3_3_a", true)

-- Mission 3 Side Quest B: Space Battle (Space Endor - assist an Imperial squadron against Borvo syndicate)
space_battle_tatooine_imperial_tier3_3_b = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier3_3_b",

	questName = "tatooine_imperial_tier3_3_b",
	questType = "space_battle",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "tatooine_imperial_tier3_3_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "assassinate_tatooine_imperial_tier3_3_a",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_imperial_tier3_3_a",

	battlePoint = "space_endor:tatooine_imperial_tier3_3_b_battlepoint",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 85,
	allyOriginDist = 500,
	enemyOriginDist = -750,
	allyArrivalDist = 50,
	enemyArrivalDist = -200,

	alliedShips = {
		{"imp_tie_fighter_tier3"},
		{"imp_tie_bomber_tier3"},
		{"imp_tie_interceptor_tier3"},
	},

	enemyShips = {
		{"borvo_fighter_tier3"},
		{"borvo_fighter_tier3"},
		{"borvo_defender_tier3"},
		{"borvo_bomber_tier3"},
		{"borvo_defender_tier3"},
		{"borvo_boss_tier3"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier3_3_b", true)

-- Mission 3 Side Quest C: Escort (Space Endor - escort an Imperial logistics vessel)
escort_tatooine_imperial_tier3_3_c = SpaceEscortScreenplay:new {
	className = "escort_tatooine_imperial_tier3_3_c",

	questName = "tatooine_imperial_tier3_3_c",
	questType = "escort",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_tatooine_imperial_tier3_3_b",
	parentQuestType = "space_battle",
	parentQuestName = "tatooine_imperial_tier3_3_b",

	escortShips = {"imp_freightermedium_tier3"},

	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier3_3_c_escort_1", zoneName = "space_endor", x = -5250, z = -850, y = 2000, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_3_c_escort_2", zoneName = "space_endor", x = -4323, z = -525, y = 2310, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_3_c_escort_3", zoneName = "space_endor", x = -3632, z = -680, y = 1552, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier3_3_c_escort_4", zoneName = "space_endor", x = -2813, z = -400, y = 1793, escortNumber = 4, radius = 250},
	},

	attackDelay = 55,

	attackShips = {
		{"borvo_fighter_tier3", "borvo_defender_tier3"},
		{"borvo_bomber_tier3", "borvo_defender_tier3"},
	},
}

registerScreenPlay("escort_tatooine_imperial_tier3_3_c", true)

-- Mission 4: Assassinate (Space Dathomir - stop a Borvo syndicate commander reaching pirate reinforcements)
assassinate_tatooine_imperial_tier3_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier3_4",

	questType = "assassinate",
	questName = "tatooine_imperial_tier3_4",

	questZone = "space_dathomir",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "tatooine_imperial_tier3_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 15,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_boss_tier3",
		escorts = {"borvo_defender_tier3", "borvo_defender_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier3_4_assassin_1", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier3_4_assassin_2", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier3_4_assassin_3", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier3_4_assassin_4", zoneName = "space_dathomir"},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier3_4", true)

-- Mission 4 Side Quest A: Patrol (Space Endor - search for a missing Imperial patrol)
patrol_tatooine_imperial_tier3_4_a = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_imperial_tier3_4_a",

	questName = "tatooine_imperial_tier3_4_a",
	questType = "patrol",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_imperial_tier3_4_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 3,
	sideQuestDelay = 5,

	parentQuest = "assassinate_tatooine_imperial_tier3_4",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_imperial_tier3_4",

	patrolPoints = {
		{patrolPointName = "tatooine_imperial_tier3_4_a_patrol_1", x = -3960, z = -400, y = -4950, patrolNumber = 1, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_4_a_patrol_2", x = -3758, z = 345, y = -4588, patrolNumber = 2, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_4_a_patrol_3", x = -3460, z = 37, y = -3563, patrolNumber = 3, radius = 150},
		{patrolPointName = "tatooine_imperial_tier3_4_a_patrol_4", x = -2777, z = 778, y = -3350, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_imperial_tier3_4_a", true)

-- Mission 4 Side Quest B: Destroy Surprise Attack (Space Endor - Borvo syndicate elite ambush)
destroy_surpriseattack_tatooine_imperial_tier3_4_b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_imperial_tier3_4_b",

	questName = "tatooine_imperial_tier3_4_b",
	questType = "destroy_surpriseattack",

	questZone = "space_endor",

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier3_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "patrol_tatooine_imperial_tier3_4_a",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_imperial_tier3_4_a",

	surpriseAttackShips = {
		zone = "space_endor",
		spawns = {{count = 6, shipName = "borvo_defender_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_tatooine_imperial_tier3_4_b", true)

-- Mission 4 Side Quest C: Space Battle (Space Endor - assist Imperial bombers against Borvo syndicate)
space_battle_tatooine_imperial_tier3_4_c = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier3_4_c",

	questName = "tatooine_imperial_tier3_4_c",
	questType = "space_battle",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "tatooine_imperial_tier3_4_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "destroy_surpriseattack_tatooine_imperial_tier3_4_b",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "tatooine_imperial_tier3_4_b",

	battlePoint = "space_endor:tatooine_imperial_tier3_4_c_battlepoint",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 80,
	allyOriginDist = 800,
	enemyOriginDist = -800,
	allyArrivalDist = 100,
	enemyArrivalDist = -50,

	alliedShips = {
		{"imp_tie_bomber_tier3"},
		{"imp_tie_bomber_tier3"},
		{"imp_tie_fighter_tier3"},
		{"imp_tie_interceptor_tier3"},
	},

	enemyShips = {
		{"borvo_bomber_tier3"},
		{"borvo_bomber_tier3"},
		{"borvo_fighter_tier3"},
		{"borvo_defender_tier3"},
		{"borvo_defender_tier3"},
		{"borvo_boss_tier3"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier3_4_c", true)

-- Mission 4 Side Quest D: Survival (Space Endor - guard the Imperial formation during withdrawal)
survival_tatooine_imperial_tier3_4_d = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_imperial_tier3_4_d",

	questName = "tatooine_imperial_tier3_4_d",
	questType = "survival",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_tatooine_imperial_tier3_4_c",
	parentQuestType = "space_battle",
	parentQuestName = "tatooine_imperial_tier3_4_c",

	survivalTime = 300,
	survivalPoint = "space_endor:tatooine_imperial_tier3_4_c_survival",
	delayToFirstAttack = 5,

	attackDelay = 60,

	attackShips = {
		{"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_bomber_tier3"},
		{"borvo_defender_tier3", "borvo_defender_tier3", "borvo_bomber_tier3"},
		{"borvo_boss_tier3", "borvo_defender_tier3", "borvo_fighter_tier3"},
	},
}

registerScreenPlay("survival_tatooine_imperial_tier3_4_d", true)

--[[
	Tier 4 -- tatooine_imperial_tier4 Main Missions
]]

-- Mission 1: Survival (Space Dathomir - Hold off Borvo syndicate assault on Nym miners)
survival_tatooine_imperial_tier4_1 = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_imperial_tier4_1",

	questName = "tatooine_imperial_tier4_1",
	questType = "survival",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier4_1_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	survivalTime = 300,
	survivalPoint = "space_dathomir:tatooine_imperial_tier4_1_survival_point",
	delayToFirstAttack = 5,

	attackDelay = 60,

	attackShips = {
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4"},
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4"},
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4"},
	},
}

registerScreenPlay("survival_tatooine_imperial_tier4_1", true)

-- Mission 1 Side Quest A: Space Battle (Space Dathomir - Counter attack against Borvo syndicate)
space_battle_tatooine_imperial_tier4_1_a = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier4_1_a",

	questName = "tatooine_imperial_tier4_1_a",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier4_1_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	parentQuest = "survival_tatooine_imperial_tier4_1",
	parentQuestType = "survival",
	parentQuestName = "tatooine_imperial_tier4_1",

	battlePoint = "space_dathomir:tatooine_imperial_tier4_1_a_battle_point",
	allyArrivalDelay = 85,
	enemyArrivalDelay = 60,
	allyOriginDist = 600,
	enemyOriginDist = -850,
	allyArrivalDist = 50,
	enemyArrivalDist = -100,

	alliedShips = {
		{"nym_enforcer_tier4"},
		{"nym_enforcer_tier4"},
		{"nym_enforcer_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4"},
	},

	enemyShips = {
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_bomber_tier4"},
		{"borvo_bomber_tier4"},
		{"borvo_bomber_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_boss_tier4"},
		{"borvo_defender_tier4"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier4_1_a", true)

-- Mission 1 Side Quest B: Space Battle (Space Dathomir - Save Nym freighters from Borvo syndicate)
space_battle_tatooine_imperial_tier4_1_b = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier4_1_b",

	questName = "tatooine_imperial_tier4_1_b",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_tatooine_imperial_tier4_1_a",
	parentQuestType = "space_battle",
	parentQuestName = "tatooine_imperial_tier4_1_a",

	battlePoint = "space_dathomir:corellia_rebe_tier4_1_b_battle_point",
	allyArrivalDelay = 30,
	enemyArrivalDelay = 45,
	allyOriginDist = 600,
	enemyOriginDist = -850,
	allyArrivalDist = 50,
	enemyArrivalDist = -100,

	alliedShips = {
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
		{"nym_freighterheavy_tier4"},
		{"nym_freighterlight_tier4"},
		{"nym_freightermedium_tier4"},
	},

	enemyShips = {
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_defender_tier4"},
		{"borvo_boss_tier4"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier4_1_b", true)

-- Mission 2: Assassinate (Space Dathomir - terminate a Borvo syndicate Vigo before reinforcements arrive)
assassinate_tatooine_imperial_tier4_2 = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier4_2",

	questType = "assassinate",
	questName = "tatooine_imperial_tier4_2",

	questZone = "space_dathomir",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "tatooine_imperial_tier4_2_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 5,
	failTimer = 20,

	assassinateSpawns = {
		target = "borvo_boss_tier4",
		escorts = {"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_1", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_2", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_3", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_4", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_5", zoneName = "space_dathomir"},
		{patrolPointName = "tatooine_imperial_tier4_2_assassin_6", zoneName = "space_dathomir"},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier4_2", true)

-- Mission 2 Side Quest A: Delivery No Pickup (Space Dathomir - deliver captured Borvo syndicate records)
delivery_no_pickup_tatooine_imperial_tier4_2_a = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_tatooine_imperial_tier4_2_a",

	questName = "tatooine_imperial_tier4_2_a",
	questType = "delivery_no_pickup",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "rescue",
	sideQuestName = "tatooine_imperial_tier4_2_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	parentQuest = "assassinate_tatooine_imperial_tier4_2",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_imperial_tier4_2",

	deliveryShip = "imp_transport_tier3",
	deliveryPoint = "space_dathomir:tatooine_imperial_tier4_2_a_delivery",

	attackDelay = 45,

	attackShips = {
		{"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4"},
		{"borvo_defender_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4"},
		{"borvo_defender_tier4", "borvo_fighter_tier4", "borvo_defender_tier4"},
		{"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_defender_tier4"},
		{"borvo_boss_tier3", "borvo_defender_tier3", "borvo_bomber_tier4"},
		{"borvo_boss_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_tatooine_imperial_tier4_2_a", true)

-- Mission 2 Side Quest B: Rescue (Space Dathomir - rescue an Imperial envoy ambushed by Borvo syndicate)
rescue_tatooine_imperial_tier4_2_b = SpaceRescueScreenplay:new {
	className = "rescue_tatooine_imperial_tier4_2_b",

	questName = "tatooine_imperial_tier4_2_b",
	questType = "rescue",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "delivery_no_pickup_tatooine_imperial_tier4_2_a",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "tatooine_imperial_tier4_2_a",

	rescueShip = "imp_lambda_shuttle_tier4",
	rescueArrivalDelay = 3,

	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier4_2_b_rescue_1", zoneName = "space_dathomir", x = 3872, z = 4158, y = -2791, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_2_b_rescue_2", zoneName = "space_dathomir", x = 2827, z = 3579, y = -4145, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_2_b_rescue_3", zoneName = "space_dathomir", x = 2103, z = 3204, y = -5079, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_2_b_rescue_4", zoneName = "space_dathomir", x = 1424, z = 2853, y = -5956, escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4"},
		{"borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4"},
		{"borvo_fighter_tier4", "borvo_bomber_tier4", "borvo_boss_tier4"},
		{"borvo_fighter_tier3", "borvo_defender_tier3", "borvo_defender_tier3"},
		{"borvo_boss_tier3", "borvo_defender_tier3", "borvo_bomber_tier4"},
		{"borvo_boss_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
	},
}

registerScreenPlay("rescue_tatooine_imperial_tier4_2_b", true)

-- Mission 3: Space Battle (Space Dathomir - repel the first coordinated Rebel strike)
space_battle_tatooine_imperial_tier4_3 = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier4_3",

	questName = "tatooine_imperial_tier4_3",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier4_3_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	battlePoint = "space_dathomir:tatooine_imperial_tier4_3_battle_point",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 30,
	allyOriginDist = 600,
	enemyOriginDist = -1100,
	allyArrivalDist = 50,
	enemyArrivalDist = -200,

	alliedShips = {
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_bomber_tier4"},
		{"imp_imperial_gunboat_tier4"},
	},

	enemyShips = {
		{"reb_xwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_awing_tier4"},
		{"reb_ywing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_awing_tier4"},
		{"reb_ywing_tier4"},
		{"reb_bwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_ywing_tier4"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier4_3", true)

-- Mission 3 Side Quest A: Space Battle (Space Dathomir - reinforce an ambushed Imperial squadron)
space_battle_tatooine_imperial_tier4_3_a = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier4_3_a",

	questName = "tatooine_imperial_tier4_3_a",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "tatooine_imperial_tier4_3_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	parentQuest = "space_battle_tatooine_imperial_tier4_3",
	parentQuestType = "space_battle",
	parentQuestName = "tatooine_imperial_tier4_3",

	battlePoint = "space_dathomir:tatooine_imperial_tier4_3_a_battle_point",
	allyArrivalDelay = 30,
	enemyArrivalDelay = 45,
	allyOriginDist = 600,
	enemyOriginDist = -700,
	allyArrivalDist = 50,
	enemyArrivalDist = -150,

	alliedShips = {
		{"imp_tie_bomber_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4"},
	},

	enemyShips = {
		{"reb_bwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_awing_tier4"},
		{"reb_awing_tier4"},
		{"reb_ywing_tier4"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier4_3_a", true)

-- Mission 3 Side Quest B: Survival (Space Dathomir - hold the line against Rebel reinforcements)
survival_tatooine_imperial_tier4_3_b = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_imperial_tier4_3_b",

	questName = "tatooine_imperial_tier4_3_b",
	questType = "survival",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_tatooine_imperial_tier4_3_a",
	parentQuestType = "space_battle",
	parentQuestName = "tatooine_imperial_tier4_3_a",

	survivalTime = 480,
	survivalPoint = "space_dathomir:tatooine_imperial_tier4_3_b_survival",
	delayToFirstAttack = 5,

	attackDelay = 45,

	attackShips = {
		{"reb_xwing_tier4", "reb_awing_tier4", "reb_ywing_tier4", "reb_bwing_tier4"},
		{"reb_xwing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_ywing_tier4"},
		{"reb_xwing_tier4", "reb_ywing_tier4", "reb_bwing_tier4", "reb_awing_tier4"},
		{"reb_xwing_tier4", "reb_xwing_tier4", "reb_awing_tier4", "reb_ywing_tier4"},
		{"reb_bwing_tier4", "reb_ywing_tier4", "reb_xwing_tier4", "reb_awing_tier4"},
	},
}

registerScreenPlay("survival_tatooine_imperial_tier4_3_b", true)

-- Mission 4: Recovery (Space Dantooine - capture a Rebel courier carrying fleet intelligence)
recovery_tatooine_imperial_tier4_4 = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_imperial_tier4_4",

	questName = "tatooine_imperial_tier4_4",
	questType = "recovery",

	questZone = "space_dantooine",

	creditReward = 0,

	sideQuest = true,
	-- The leg parentQuest chain is strictly serial here: _b's parent is this head,
	-- _a's parent is _b, and _c's parent is _a. So this head hands off to _b, and
	-- _b already COMPLETION-splits onto _a. The head previously pointed at _a with
	-- no split type at all (default NONE), so no leg ever started.
	sideQuestType = "rescue",
	sideQuestName = "tatooine_imperial_tier4_4_b",

	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 10,
	recoveryDelay = 30,

	recoverShip = "reb_transport_tier4",
	recoveryConversationMobile = "object/mobile/dressed_rebel_commando_moncal_male_01.iff",

	escortShips = {"reb_xwing_tier4", "reb_xwing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_ywing_tier4", "reb_bwing_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_1", zoneName = "space_dantooine", x = -4000, z = 3100, y = 2700, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_2", zoneName = "space_dantooine", x = -4400, z = 4410, y = 3481, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_3", zoneName = "space_dantooine", x = -4742, z = 5529, y = 4148, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_4", zoneName = "space_dantooine", x = -5049, z = 6532, y = 4746, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_5", zoneName = "space_dantooine", x = -5330, z = 5655, y = 5488, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_6", zoneName = "space_dantooine", x = -5758, z = 5051, y = 6420, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_7", zoneName = "space_dantooine", x = -6046, z = 4645, y = 7048, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_recovery_8", zoneName = "space_dantooine", x = -7031, z = 4120, y = 6583, escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"reb_xwing_tier4", "reb_awing_tier4", "reb_ywing_tier4"},
		{"reb_xwing_tier4", "reb_xwing_tier4", "reb_awing_tier4"},
		{"reb_bwing_tier4", "reb_ywing_tier4", "reb_awing_tier4"},
	},
}

registerScreenPlay("recovery_tatooine_imperial_tier4_4", true)

-- Mission 4 Side Quest A: Assassinate (Space Endor - destroy Rebel freighters carrying war materiel)
assassinate_tatooine_imperial_tier4_4_a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_imperial_tier4_4_a",

	questType = "assassinate",
	questName = "tatooine_imperial_tier4_4_a",

	questZone = "space_endor",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "tatooine_imperial_tier4_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "rescue_tatooine_imperial_tier4_4_b",
	parentQuestType = "rescue",
	parentQuestName = "tatooine_imperial_tier4_4_b",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "reb_freighterheavy_tier4",
		escorts = {"reb_xwing_tier4", "reb_xwing_tier4", "reb_awing_tier4", "reb_awing_tier4", "reb_ywing_tier4", "reb_bwing_tier4", "reb_xwing_tier4", "reb_freighterlight_tier3", "reb_freightermedium_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_1", zoneName = "space_endor", x = 19, z = 5591, y = 1371},
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_2", zoneName = "space_endor", x = 552, z = 5543, y = -5},
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_3", zoneName = "space_endor", x = 2059, z = 5543, y = -1021},
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_4", zoneName = "space_endor", x = 2632, z = 5518, y = -2724},
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_5", zoneName = "space_endor", x = 4049, z = 5491, y = -4471},
		{patrolPointName = "tatooine_imperial_tier4_4_a_assassinate_6", zoneName = "space_endor", x = 7162, z = 5467, y = -4481},
	},
}

registerScreenPlay("assassinate_tatooine_imperial_tier4_4_a", true)

-- Mission 4 Side Quest B: Rescue (Space Endor - escort an Imperial intelligence operative to safety)
rescue_tatooine_imperial_tier4_4_b = SpaceRescueScreenplay:new {
	className = "rescue_tatooine_imperial_tier4_4_b",

	questName = "tatooine_imperial_tier4_4_b",
	questType = "rescue",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_imperial_tier4_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "recovery_tatooine_imperial_tier4_4",
	parentQuestType = "recovery",
	parentQuestName = "tatooine_imperial_tier4_4",

	rescueShip = "imp_lambda_shuttle_tier4",
	rescueArrivalDelay = 5,

	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_1", zoneName = "space_endor", x = -961, z = -5548, y = 513, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_2", zoneName = "space_endor", x = -1637, z = -5535, y = 354, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_3", zoneName = "space_endor", x = -2330, z = -5523, y = 191, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_4", zoneName = "space_endor", x = -3110, z = -5509, y = 7, escortNumber = 4, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_5", zoneName = "space_endor", x = -3915, z = -5494, y = -182, escortNumber = 5, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_4_b_rescue_6", zoneName = "space_endor", x = -4794, z = -5884, y = -52, escortNumber = 6, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"reb_xwing_tier4", "reb_awing_tier4", "reb_ywing_tier4"},
		{"reb_xwing_tier4", "reb_xwing_tier4", "reb_awing_tier4"},
		{"reb_bwing_tier4", "reb_ywing_tier4", "reb_awing_tier4"},
		{"reb_xwing_tier4", "reb_xwing_tier4", "reb_xwing_tier4"},
		{"reb_awing_tier4", "reb_awing_tier4", "reb_ywing_tier4"},
		{"reb_bwing_tier4", "reb_ywing_tier4", "reb_xwing_tier4"},
	},
}

registerScreenPlay("rescue_tatooine_imperial_tier4_4_b", true)

-- Mission 4 Side Quest C: Space Battle (Space Endor - break the Rebel counterattack)
space_battle_tatooine_imperial_tier4_4_c = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_imperial_tier4_4_c",

	questName = "tatooine_imperial_tier4_4_c",
	questType = "space_battle",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_tatooine_imperial_tier4_4_a",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_imperial_tier4_4_a",

	battlePoint = "space_endor:tatooine_imperial_tier4_4_c_battle_point",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 85,
	allyOriginDist = 800,
	enemyOriginDist = -850,
	allyArrivalDist = 150,
	enemyArrivalDist = -200,

	alliedShips = {
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_bomber_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_advanced_tier4"},
	},

	enemyShips = {
		{"reb_xwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_awing_tier4"},
		{"reb_awing_tier4"},
		{"reb_ywing_tier4"},
		{"reb_ywing_tier4"},
		{"reb_bwing_tier4"},
		{"reb_bwing_tier4"},
		{"reb_transport_tier4"},
	},
}

registerScreenPlay("space_battle_tatooine_imperial_tier4_4_c", true)

-- Master Mission (two-stage Kessel encounter): destroy_master_imperial_1 (Kessel:
-- destroy 30 Rebel fighters) and destroy_master_imperial_2 (Kessel: destroy the Rebel
-- Corellian Corvette command vessel) are defined in
-- screenplays/space/squadrons/KesselMasterEncounterScreenplay.lua (loaded first).

-- Tier 4 Duty Missions

-- Escort Duty (Space Dathomir - escort Imperial supply freighters through pirate territory)
escort_duty_tatooine_imperial_tier4_1 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_imperial_tier4_1",

	questName = "tatooine_imperial_tier4_1",
	questType = "escort_duty",

	questZone = "space_dathomir",

	creditReward = 5000,
	creditKillBonus = 300,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_freighterheavy_tier4", "imp_freighterlight_tier4", "imp_freightermedium_tier4"},

	escortPoints = {
		{patrolPointName = "tatooine_imperial_tier4_1_escort_duty_1", zoneName = "space_dathomir", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_escort_duty_2", zoneName = "space_dathomir", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_escort_duty_3", zoneName = "space_dathomir", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_escort_duty_4", zoneName = "space_dathomir", escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4"},
		{"borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
		{"borvo_fighter_tier4", "borvo_bomber_tier4", "borvo_boss_tier4", "borvo_defender_tier4"},
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_boss_tier4", "borvo_boss_tier4"},
	},
}

registerScreenPlay("escort_duty_tatooine_imperial_tier4_1", true)

-- Rescue Duty (Space Dantooine - rescue disabled Imperial ships after pirate attacks)
rescue_duty_tatooine_imperial_tier4_1 = SpaceDutyRescueScreenplay:new {
	className = "rescue_duty_tatooine_imperial_tier4_1",

	questName = "tatooine_imperial_tier4_1",
	questType = "rescue_duty",

	questZone = "space_dantooine",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	targetShips = {"imp_tie_fighter_tier4", "imp_lambda_shuttle_tier4", "imp_tie_bomber_tier4", "imp_transport_tier4", "imp_freightermedium_tier4", "imp_freighterheavy_tier4", "imp_freighterlight_tier4"},

	targetArrivalDelay = 3,

	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier4_1_rescue_duty_1", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_rescue_duty_2", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_rescue_duty_3", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_rescue_duty_4", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_rescue_duty_5", zoneName = "space_dantooine", radius = 250},
	},

	attackDelay = 60,

	attackShips = {
		{"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4"},
		{"borvo_bomber_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
		{"borvo_bomber_tier4", "borvo_boss_tier4", "borvo_boss_tier4"},
	},
}

registerScreenPlay("rescue_duty_tatooine_imperial_tier4_1", true)

-- Recovery Duty (Space Endor - Nym pirates infiltrate Imperial troop transports)
recovery_duty_tatooine_imperial_tier4_1 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_tatooine_imperial_tier4_1",

	questName = "tatooine_imperial_tier4_1",
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

	escortShips = {"borvo_defender_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_1", zoneName = "space_endor", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_2", zoneName = "space_endor", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_3", zoneName = "space_endor", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_4", zoneName = "space_endor", escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_5", zoneName = "space_endor", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_6", zoneName = "space_endor", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_7", zoneName = "space_endor", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_imperial_tier4_1_recovery_duty_8", zoneName = "space_endor", escortNumber = 4, radius = 250},
	},

	attackDelay = 45,

	attackShips = {
		{"borvo_fighter_tier4", "borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4"},
		{"borvo_defender_tier4", "borvo_bomber_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
		{"borvo_bomber_tier4", "borvo_boss_tier4", "borvo_defender_tier4", "borvo_boss_tier4"},
	},
}

registerScreenPlay("recovery_duty_tatooine_imperial_tier4_1", true)

-- Destroy Duty (Space Dantooine - suppress Borvo syndicate raiding forces)
destroy_duty_tatooine_imperial_tier4_1 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_imperial_tier4_1",

	questName = "tatooine_imperial_tier4_1",
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

	bossShip = "borvo_defender_tier4",
	shipTypes = {
		{"borvo_fighter_tier4", "borvo_fighter_tier4"},
		{"borvo_fighter_tier4", "borvo_fighter_tier4"},
		{"borvo_fighter_tier4", "borvo_fighter_tier4"},
		{"borvo_fighter_tier4"},
		{"borvo_boss_tier4"},
	},
}

registerScreenPlay("destroy_duty_tatooine_imperial_tier4_1", true)

--[[

	StormSquadronScreenplay

]]

StormSquadronScreenplay = ScreenPlay:new {
	screenplayName = "StormSquadronScreenplay",

	-- Tier 1 (Lt. Barn Sinkko)
	QUEST_STRING_1 = {type = "patrol", name = "tatooine_imperial_1"},
	QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "tatooine_imperial_1"},
	QUEST_STRING_2 = {type = "destroy", name = "tatooine_imperial_2"},
	QUEST_STRING_3 = {type = "patrol", name = "tatooine_imperial_3"},
	QUEST_STRING_3_SIDE = {type = "escort", name = "tatooine_imperial_3"},
	QUEST_STRING_4 = {type = "assassinate", name = "tatooine_imperial_4"},
	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "tatooine_imperial_6"},
	QUEST_STRING_DUTY_2 = {type = "escort_duty", name = "tatooine_imperial_7"},

	-- Tier 2
	TIER2_QUEST_STRING_1 = {type = "inspect", name = "tatooine_imperial_tier2_1"},
	TIER2_QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "tatooine_imperial_tier2_1"},
	TIER2_QUEST_STRING_2 = {type = "escort", name = "tatooine_imperial_tier2_2"},
	TIER2_QUEST_STRING_3 = {type = "recovery", name = "tatooine_imperial_tier2_3"},
	TIER2_QUEST_STRING_4 = {type = "assassinate", name = "tatooine_imperial_tier2_4"},
	TIER2_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "tatooine_imperial_tier2_destroyduty"},
	TIER2_QUEST_STRING_DUTY_2 = {type = "recovery_duty", name = "tatooine_imperial_tier2_recoveryduty"},
	TIER2_QUEST_STRING_DUTY_3 = {type = "escort_duty", name = "tatooine_imperial_tier2_escortduty"},

	-- Tier 3
	TIER3_QUEST_STRING_1 = {type = "recovery", name = "tatooine_imperial_tier3_1"},
	TIER3_QUEST_STRING_1_SIDE1 = {type = "patrol", name = "tatooine_imperial_tier3_1_A"},
	TIER3_QUEST_STRING_1_SIDE2 = {type = "destroy_surpriseattack", name = "tatooine_imperial_tier3_1_b"},
	TIER3_QUEST_STRING_1_SIDE3 = {type = "assassinate", name = "tatooine_imperial_tier3_1_c"},
	TIER3_QUEST_STRING_1_SIDE4 = {type = "space_battle", name = "tatooine_imperial_tier3_1_d"},
	TIER3_QUEST_STRING_2 = {type = "inspect", name = "tatooine_imperial_tier3_2"},
	TIER3_QUEST_STRING_2_SIDE1 = {type = "delivery", name = "tatooine_imperial_tier3_2_a"},
	TIER3_QUEST_STRING_2_SIDE2 = {type = "survival", name = "tatooine_imperial_tier3_2_b"},
	TIER3_QUEST_STRING_2_SIDE3 = {type = "escort", name = "tatooine_imperial_tier3_2_c"},
	TIER3_QUEST_STRING_3 = {type = "delivery", name = "tatooine_imperial_tier3_3"},
	TIER3_QUEST_STRING_3_SIDE1 = {type = "assassinate", name = "tatooine_imperial_tier3_3_a"},
	TIER3_QUEST_STRING_3_SIDE2 = {type = "space_battle", name = "tatooine_imperial_tier3_3_b"},
	TIER3_QUEST_STRING_3_SIDE3 = {type = "escort", name = "tatooine_imperial_tier3_3_c"},
	TIER3_QUEST_STRING_4 = {type = "assassinate", name = "tatooine_imperial_tier3_4"},
	TIER3_QUEST_STRING_4_SIDE1 = {type = "patrol", name = "tatooine_imperial_tier3_4_a"},
	TIER3_QUEST_STRING_4_SIDE2 = {type = "destroy_surpriseattack", name = "tatooine_imperial_tier3_4_b"},
	TIER3_QUEST_STRING_4_SIDE3 = {type = "space_battle", name = "tatooine_imperial_tier3_4_c"},
	TIER3_QUEST_STRING_4_SIDE4 = {type = "survival", name = "tatooine_imperial_tier3_4_d"},

	-- Tier 4
	TIER4_QUEST_STRING_1 = {type = "survival", name = "tatooine_imperial_tier4_1"},
	TIER4_QUEST_STRING_1_SIDE1 = {type = "space_battle", name = "tatooine_imperial_tier4_1_a"},
	TIER4_QUEST_STRING_1_SIDE2 = {type = "space_battle", name = "tatooine_imperial_tier4_1_b"},
	TIER4_QUEST_STRING_2 = {type = "assassinate", name = "tatooine_imperial_tier4_2"},
	TIER4_QUEST_STRING_2_SIDE1 = {type = "delivery_no_pickup", name = "tatooine_imperial_tier4_2_a"},
	TIER4_QUEST_STRING_2_SIDE2 = {type = "rescue", name = "tatooine_imperial_tier4_2_b"},
	TIER4_QUEST_STRING_3 = {type = "space_battle", name = "tatooine_imperial_tier4_3"},
	TIER4_QUEST_STRING_3_SIDE1 = {type = "space_battle", name = "tatooine_imperial_tier4_3_a"},
	TIER4_QUEST_STRING_3_SIDE2 = {type = "survival", name = "tatooine_imperial_tier4_3_b"},
	TIER4_QUEST_STRING_4 = {type = "recovery", name = "tatooine_imperial_tier4_4"},
	TIER4_QUEST_STRING_4_SIDE1 = {type = "assassinate", name = "tatooine_imperial_tier4_4_a"},
	TIER4_QUEST_STRING_4_SIDE2 = {type = "rescue", name = "tatooine_imperial_tier4_4_b"},
	TIER4_QUEST_STRING_4_SIDE3 = {type = "space_battle", name = "tatooine_imperial_tier4_4_c"},
	TIER4_QUEST_STRING_MASTER = {type = "destroy", name = "master_imperial_1"},
	TIER4_QUEST_STRING_MASTER_2 = {type = "destroy", name = "master_imperial_2"},
	TIER4_QUEST_STRING_DUTY_1 = {type = "escort_duty", name = "tatooine_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_2 = {type = "rescue_duty", name = "tatooine_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_3 = {type = "recovery_duty", name = "tatooine_imperial_tier4_1"},
	TIER4_QUEST_STRING_DUTY_4 = {type = "destroy_duty", name = "tatooine_imperial_tier4_1"},
}

registerScreenPlay("StormSquadronScreenplay", false)

function StormSquadronScreenplay:start()
end

-- Reset functions for quest clearing

function StormSquadronScreenplay:resetColzetQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	patrol_tatooine_imperial_1:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_imperial_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1.type, self.QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1_SIDE.type, self.QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	destroy_tatooine_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_2.type, self.QUEST_STRING_2.name, false)

	-- Mission 3
	patrol_tatooine_imperial_3:resetQuest(pPlayer)
	escort_tatooine_imperial_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3.type, self.QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3_SIDE.type, self.QUEST_STRING_3_SIDE.name, false)

	-- Mission 4
	assassinate_tatooine_imperial_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_4.type, self.QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "StormSquadronScreenplay:colzet_finished")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.QUEST_STRING_4.name .. ":reward")
end

function StormSquadronScreenplay:resetTier2Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	inspect_tatooine_imperial_tier2_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1.type, self.TIER2_QUEST_STRING_1.name, false)
	destroy_surpriseattack_tatooine_imperial_tier2_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1_SIDE.type, self.TIER2_QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	escort_tatooine_imperial_tier2_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_2.type, self.TIER2_QUEST_STRING_2.name, false)

	-- Mission 3
	recovery_tatooine_imperial_tier2_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_3.type, self.TIER2_QUEST_STRING_3.name, false)

	-- Mission 4
	assassinate_tatooine_imperial_tier2_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_4.type, self.TIER2_QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":introduced")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward")
	removeQuestStatus(playerID .. "StormSquadron:tier2Smuggler")
end

function StormSquadronScreenplay:resetTier3Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	recovery_tatooine_imperial_tier3_1:resetQuest(pPlayer)
	patrol_tatooine_imperial_tier3_1_A:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_imperial_tier3_1_b:resetQuest(pPlayer)
	assassinate_tatooine_imperial_tier3_1_c:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier3_1_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1.type, self.TIER3_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE1.type, self.TIER3_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE2.type, self.TIER3_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE3.type, self.TIER3_QUEST_STRING_1_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE4.type, self.TIER3_QUEST_STRING_1_SIDE4.name, false)

	-- Mission 2
	inspect_tatooine_imperial_tier3_2:resetQuest(pPlayer)
	delivery_tatooine_imperial_tier3_2_a:resetQuest(pPlayer)
	survival_tatooine_imperial_tier3_2_b:resetQuest(pPlayer)
	escort_tatooine_imperial_tier3_2_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2.type, self.TIER3_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE1.type, self.TIER3_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE2.type, self.TIER3_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE3.type, self.TIER3_QUEST_STRING_2_SIDE3.name, false)

	-- Mission 3
	delivery_tatooine_imperial_tier3_3:resetQuest(pPlayer)
	assassinate_tatooine_imperial_tier3_3_a:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier3_3_b:resetQuest(pPlayer)
	escort_tatooine_imperial_tier3_3_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3.type, self.TIER3_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE1.type, self.TIER3_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE2.type, self.TIER3_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE3.type, self.TIER3_QUEST_STRING_3_SIDE3.name, false)

	-- Mission 4
	assassinate_tatooine_imperial_tier3_4:resetQuest(pPlayer)
	patrol_tatooine_imperial_tier3_4_a:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_imperial_tier3_4_b:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier3_4_c:resetQuest(pPlayer)
	survival_tatooine_imperial_tier3_4_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4.type, self.TIER3_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE1.type, self.TIER3_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE2.type, self.TIER3_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE3.type, self.TIER3_QUEST_STRING_4_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE4.type, self.TIER3_QUEST_STRING_4_SIDE4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward")
end

function StormSquadronScreenplay:resetTier4Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	survival_tatooine_imperial_tier4_1:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier4_1_a:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier4_1_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1.type, self.TIER4_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE1.type, self.TIER4_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE2.type, self.TIER4_QUEST_STRING_1_SIDE2.name, false)

	-- Mission 2
	assassinate_tatooine_imperial_tier4_2:resetQuest(pPlayer)
	delivery_no_pickup_tatooine_imperial_tier4_2_a:resetQuest(pPlayer)
	rescue_tatooine_imperial_tier4_2_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2.type, self.TIER4_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE1.type, self.TIER4_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE2.type, self.TIER4_QUEST_STRING_2_SIDE2.name, false)

	-- Mission 3
	space_battle_tatooine_imperial_tier4_3:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier4_3_a:resetQuest(pPlayer)
	survival_tatooine_imperial_tier4_3_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3.type, self.TIER4_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE1.type, self.TIER4_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE2.type, self.TIER4_QUEST_STRING_3_SIDE2.name, false)

	-- Mission 4
	recovery_tatooine_imperial_tier4_4:resetQuest(pPlayer)
	assassinate_tatooine_imperial_tier4_4_a:resetQuest(pPlayer)
	rescue_tatooine_imperial_tier4_4_b:resetQuest(pPlayer)
	space_battle_tatooine_imperial_tier4_4_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4.type, self.TIER4_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE1.type, self.TIER4_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2.type, self.TIER4_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE3.type, self.TIER4_QUEST_STRING_4_SIDE3.name, false)

	-- Master (two-stage Kessel corvette encounter)
	destroy_master_imperial_1:resetQuest(pPlayer)
	destroy_master_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER.type, self.TIER4_QUEST_STRING_MASTER.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER_2.type, self.TIER4_QUEST_STRING_MASTER_2.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "StormSquadronScreenplay:StartedTier4")

	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. StormSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward")
end

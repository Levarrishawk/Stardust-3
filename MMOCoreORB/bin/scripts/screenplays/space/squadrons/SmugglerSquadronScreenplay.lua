local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Smuggler Alliance Squadron Missions (Neutral - Tatooine)

]]

--[[
	Tier 1 -- Nym Contact Dravis Main Missions (Tatooine)
]]

-- Mission 1: Patrol with surprise attack
patrol_tatooine_privateer_1 = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_privateer_1",

	questName = "tatooine_privateer_1",
	questType = "patrol",

	questZone = "space_tatooine",

	creditReward = 100,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_privateer_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "smuggler_rebel_patrol_1", x = 6439, z = -5021, y = -2217, patrolNumber = 1, radius = 150},
		{patrolPointName = "smuggler_rebel_patrol_2", x = 6031, z = -4540, y = -1962, patrolNumber = 2, radius = 150},
		{patrolPointName = "smuggler_rebel_patrol_3", x = 4891, z = -3215, y = -1345, patrolNumber = 3, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_privateer_1", true)

destroy_surpriseattack_tatooine_privateer_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_privateer_1",

	questName = "tatooine_privateer_1",
	questType = "destroy_surpriseattack",

	questZone = "space_tatooine",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_tatooine_privateer_1",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_privateer_1",

	surpriseAttackShips = {
		zone = "space_tatooine",
		spawns = {{count = 3, shipName = "blacksun_aggressor_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_tatooine_privateer_1", true)

-- Mission 2: Destroy
destroy_tatooine_privateer_2 = SpaceDestroyScreenplay:new {
	className = "destroy_tatooine_privateer_2",

	questName = "tatooine_privateer_2",
	questType = "destroy",

	questZone = "space_tatooine",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "smuggler_imperial_patrol_1", x = 590, z = -3500, y = -6000},
		{patrolPointName = "smuggler_imperial_patrol_2", x = -2500, z = 4000, y = 3500},
		{patrolPointName = "smuggler_imperial_patrol_3", x = -3800, z = 2500, y = 5000},
	},

	shipTypes = {
		"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1", "blacksun_aggressor_tier1", "blacksun_vehement_tier1",
	},
}

registerScreenPlay("destroy_tatooine_privateer_2", true)

-- Mission 3: Patrol with escort side quest
patrol_tatooine_privateer_3 = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_privateer_3",

	questName = "tatooine_privateer_3",
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
	sideQuestName = "tatooine_privateer_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "smuggler_rebel_security_patrol_1", x = 5024, z = -3710, y = -1723, patrolNumber = 1, radius = 150},
		{patrolPointName = "smuggler_rebel_security_patrol_2", x = 3933, z = -3285, y = -3098, patrolNumber = 2, radius = 150},
		{patrolPointName = "smuggler_rebel_security_patrol_3", x = 3574, z = -2819, y = -4741, patrolNumber = 3, radius = 150},
		{patrolPointName = "smuggler_rebel_security_patrol_4", x = 4496, z = -1657, y = -6222, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_tatooine_privateer_3", true)

escort_tatooine_privateer_3 = SpaceEscortScreenplay:new {
	className = "escort_tatooine_privateer_3",

	questName = "tatooine_privateer_3",
	questType = "escort",

	questZone = "space_tatooine",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_tatooine_privateer_3",
	parentQuestType = "patrol",
	parentQuestName = "tatooine_privateer_3",

	escortShips = {"imp_freightermedium_tier1"},

	escortPoints = {
		{patrolPointName = "smuggler_rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_2", zoneName = "space_tatooine", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_3", zoneName = "space_tatooine", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1"},
		{"blacksun_aggressor_tier1", "blacksun_fighter_s01_tier1"},
		{"blacksun_vehement_tier1", "blacksun_fighter_s02_tier1", "blacksun_aggressor_tier1"},
	}
}

registerScreenPlay("escort_tatooine_privateer_3", true)

-- Mission 4: Assassinate
assassinate_tatooine_privateer_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_4",

	questType = "assassinate",
	questName = "tatooine_privateer_tier1_4a",

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
		target = "blacksun_ace_s04_tier2",
		escorts = {"blacksun_aggressor_tier1", "blacksun_vehement_tier1"},
	},

	targetPatrols = {
		{patrolPointName = "smuggler_rebel_security_patrol_2", x = 3933, z = -3285, y = -3098},
		{patrolPointName = "smuggler_naboo_privateer_tier3_leg_2_rescue_egress_4", x = 1156, z = -7106, y = -2482},
		{patrolPointName = "smuggler_trade_escort_4", x = 895, z = 210, y = 695},
		{patrolPointName = "smuggler_military_escort_2", x = 2915, z = 3828, y = 2887},
		{patrolPointName = "smuggler_corellia_imperial_tier3_leg_1_recovery_recover_1", x = 752, z = -2678, y = -1479},
	},
}

registerScreenPlay("assassinate_tatooine_privateer_4", true)

-- Tier 1 transition: Talon Karrde's rendezvous with Nym's contact
patrol_tat_priv_quest_trans = SpacePatrolScreenplay:new {
	className = "patrol_tat_priv_quest_trans",

	questName = "tat_priv_quest_trans",
	questType = "patrol",

	questZone = "space_lok",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tat_priv_quest_trans",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	patrolPoints = {
		{patrolPointName = "smuggler_talon_nym_rendezvous", x = 5200, z = 1250, y = -750, patrolNumber = 1, radius = 200},
	},
}

registerScreenPlay("patrol_tat_priv_quest_trans", true)

assassinate_tat_priv_quest_trans = SpaceAssassinateScreenplay:new {
	className = "assassinate_tat_priv_quest_trans",

	questName = "tat_priv_quest_trans",
	questType = "assassinate",

	questZone = "space_lok",

	creditReward = 0,

	parentQuest = "patrol_tat_priv_quest_trans",
	parentQuestType = "patrol",
	parentQuestName = "tat_priv_quest_trans",

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 5,
	failTimer = 20,

	assassinateSpawns = {
		target = "corsair_behemoth_tier2",
		escorts = {"corsair_manowar_tier1", "corsair_manowar_tier1", "corsair_manowar_tier1"},
	},

	targetPatrols = {
		{patrolPointName = "smuggler_talon_corsair_1", x = 4750, z = 1100, y = -900},
		{patrolPointName = "smuggler_talon_corsair_2", x = 4300, z = 900, y = -1250},
		{patrolPointName = "smuggler_talon_corsair_3", x = 3900, z = 700, y = -900},
		{patrolPointName = "smuggler_talon_corsair_4", x = 4300, z = 1000, y = -500},
	},
}

registerScreenPlay("assassinate_tat_priv_quest_trans", true)

-- Dravis Duty Missions
recovery_duty_tatooine_privateer_5 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_tatooine_privateer_5",

	questName = "tatooine_privateer_5",
	questType = "recovery_duty",

	questZone = "space_tatooine",

	creditReward = 1000,
	creditKillBonus = 100,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	recoveryDelay = 20,

	recoverShip = "valarian_freighterlight_mining_tier1",
	recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff",

	escortShips = {"valarian_fighter_tier1", "valarian_fighter_tier1"},

	preRecoveryPoints = {
		{patrolPointName = "smuggler_rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_2", zoneName = "space_tatooine", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "smuggler_rebel_escort_3", zoneName = "space_tatooine", x = 4453, z = 3127, y = -7150, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 2, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"valarian_fighter_tier1"},
		{"valarian_fighter_tier1", "valarian_bomber_tier1"},
	},
}

registerScreenPlay("recovery_duty_tatooine_privateer_5", true)

destroy_duty_tatooine_privateer_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_privateer_6",

	questName = "tatooine_privateer_6",
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

	bossShip = "blacksun_ace_s04_tier2",
	shipTypes = {
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1"},
		{"blacksun_aggressor_tier1", "blacksun_vehement_tier1"},
	},
}

registerScreenPlay("destroy_duty_tatooine_privateer_6", true)

escort_duty_tatooine_privateer_7 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_privateer_7",

	questName = "tatooine_privateer_7",
	questType = "escort_duty",

	questZone = "space_tatooine",

	creditReward = 1000,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"imp_transport_tier1", "imp_freightermedium_tier1", "imp_freighterlight_tier1", "imp_freighterheavy_tier1"},

	escortPoints = {
		{patrolPointName = "smuggler_rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_2", zoneName = "space_tatooine", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_3", zoneName = "space_tatooine", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1"},
		{"blacksun_aggressor_tier1", "blacksun_fighter_s01_tier1"},
		{"blacksun_vehement_tier1", "blacksun_fighter_s02_tier1"},
	},

	creditKillBonus = 100,
}

registerScreenPlay("escort_duty_tatooine_privateer_7", true)

destroy_duty_tatooine_privateer_8 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_privateer_8",

	questName = "tatooine_privateer_8",
	questType = "destroy_duty",

	questZone = "space_tatooine",

	creditReward = 150,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "blacksun_ace_s04_tier2",
	shipTypes = {
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1", "blacksun_bomber_s01_tier1"},
		{"blacksun_aggressor_tier1", "blacksun_vehement_tier1", "blacksun_bomber_s01_tier1"},
	},
}

registerScreenPlay("destroy_duty_tatooine_privateer_8", true)

--[[
	Tier 2 -- tatooine_privateer_tier2 Main Missions
]]

-- Mission 1: Destroy the Corsair Behemoth in Lok
assassinate_tatooine_privateer_tier2_1a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier2_1a",

	questName = "tatooine_privateer_tier2_1a",
	questType = "assassinate",

	questZone = "space_lok",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/booster/bst_mission_reward_neutral_mandal_m_series.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "corsair_behemoth_tier3",
		escorts = {"corsair_raider_tier2", "corsair_raider_tier2"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_privateer_tier2_four_1", x = 2800, z = 2400, y = 2800},
		{patrolPointName = "tatooine_privateer_tier2_four_2", x = 1662, z = 2407, y = 2790},
		{patrolPointName = "tatooine_privateer_tier2_four_3", x = 533, z = 2411, y = 3116},
		{patrolPointName = "tatooine_privateer_tier2_four_4", x = -1109, z = 2414, y = 3581},
	},
}

registerScreenPlay("assassinate_tatooine_privateer_tier2_1a", true)

-- Client quest tier2_2a: Destroy the Imperial patrol in Dantooine (story mission 4)
assassinate_tatooine_privateer_tier2_2a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier2_2a",

	questName = "tatooine_privateer_tier2_2a",
	questType = "assassinate",

	questZone = "space_dantooine",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/weapon/wpn_mission_reward_neutral_hk_military_blaster.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "smuggler_imperial_patrol_interceptor_tier3",
		escorts = {"smuggler_imperial_patrol_fighter_tier2", "smuggler_imperial_patrol_fighter_tier2", "smuggler_imperial_patrol_fighter_tier2"},
	},

	targetPatrols = {
		{patrolPointName = "tatooine_privateer_tier2_2_1", x = 1000, z = -900, y = -2100},
		{patrolPointName = "tatooine_privateer_tier2_2_2", x = -28, z = -908, y = -2207},
		{patrolPointName = "tatooine_privateer_tier2_2_3", x = -1158, z = -952, y = -2363},
		{patrolPointName = "tatooine_privateer_tier2_2_4", x = -2566, z = -1057, y = -2599},
	}
}

registerScreenPlay("assassinate_tatooine_privateer_tier2_2a", true)

-- Client quest tier2_3a: Destroy the Black Sun Ace in Yavin (story mission 2)
assassinate_tatooine_privateer_tier2_3a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier2_3a",

	questName = "tatooine_privateer_tier2_3a",
	questType = "assassinate",

	questZone = "space_yavin4",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/shield_generator/shd_mission_reward_neutral_koensayr_ds23.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		-- This mobile uses the tier 3 Kihraxz ship and pilot templates. The
		-- similarly named tier3 mobile is internally configured as tier 4.
		target = "blacksun_ace_s04_tier2",
		escorts = {"blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier2"},
	},

	targetPatrols = {
		{patrolPointName = "tier3_privateer_target_path_01", x = 3658, z = -1769, y = -657},
		{patrolPointName = "smuggler_imperial_scout_flight_path_1", x = 3593, z = -1050, y = -3060},
		{patrolPointName = "smuggler_imperial_scout_flight_path_2", x = 3255, z = -758, y = -2450},
		{patrolPointName = "smuggler_rebel_tier_three_patrol_3", x = 3680, z = -853, y = -2726},
	},
}

registerScreenPlay("assassinate_tatooine_privateer_tier2_3a", true)

-- Client quest tier2_4a: Escort the Valarian freighter through Tatooine (story mission 3)
escort_tatooine_privateer_tier2_4a = SpaceEscortScreenplay:new {
	className = "escort_tatooine_privateer_tier2_4a",

	questType = "escort",
	questName = "tatooine_privateer_tier2_4a",

	questZone = "space_tatooine",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/droid_interface/ddi_mission_reward_neutral_sorosuub_w19.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"valarian_freighterlight_mining_tier3"},

	escortPoints = {
		{patrolPointName = "smuggler_rebel_escort_1", zoneName = "space_tatooine", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_2", zoneName = "space_tatooine", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_3", zoneName = "space_tatooine", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_rebel_escort_4", zoneName = "space_tatooine", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"hutt_fighter_s01_tier2", "hutt_fighter_s02_tier2"},
		{"hutt_fighter_s01_tier2", "hutt_pirate_s01_tier2"},
		{"hutt_fighter_s02_tier2", "hutt_pirate_s02_tier2", "hutt_fighter_s01_tier2"},
	},
}

registerScreenPlay("escort_tatooine_privateer_tier2_4a", true)

-- Tier 2 Duty Missions
destroy_duty_tatooine_privateer_tier2_destroyduty = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_privateer_tier2_destroyduty",

	questName = "tatooine_privateer_tier2_1",
	questType = "destroy_duty",

	questZone = "space_yavin4",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "blacksun_aggressor_tier3",
	shipTypes = {
		{"blacksun_fighter_s01_tier2", "blacksun_aggressor_tier2"},
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier2", "blacksun_aggressor_tier2"},
		{"blacksun_aggressor_tier2", "blacksun_aggressor_tier2", "blacksun_fighter_s01_tier2"},
	},
}

registerScreenPlay("destroy_duty_tatooine_privateer_tier2_destroyduty", true)

recovery_duty_tatooine_privateer_tier2_recoveryduty = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_tatooine_privateer_tier2_recoveryduty",

	questName = "tatooine_privateer_tier2_1",
	questType = "recovery_duty",

	questZone = "space_dantooine",

	creditReward = 2500,
	creditKillBonus = 200,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 15,
	recoveryDelay = 30,

	recoverShip = "freighterlight_tier2",
	recoveryConversationMobile = "object/mobile/shared_dressed_nym_patrol_elite_nikto_m.iff",

	escortShips = {"imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},

	preRecoveryPoints = {
		{patrolPointName = "tatooine_privateer_tier2_2_1", zoneName = "space_dantooine", x = 1000, z = -900, y = -2100, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_2", zoneName = "space_dantooine", x = -28, z = -908, y = -2207, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_3", zoneName = "space_dantooine", x = -1158, z = -952, y = -2363, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_4", zoneName = "space_dantooine", x = -2566, z = -1057, y = -2599, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_privateer_tier2_2_3", zoneName = "space_dantooine", x = -1158, z = -952, y = -2363, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_4", zoneName = "space_dantooine", x = -2566, z = -1057, y = -2599, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_5", zoneName = "space_dantooine", x = -2436, z = -1574, y = -3167, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier2_2_6", zoneName = "space_dantooine", x = -2129, z = -1970, y = -3738, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"imp_tie_fighter_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
	},
}

registerScreenPlay("recovery_duty_tatooine_privateer_tier2_recoveryduty", true)

escort_duty_tatooine_privateer_tier2_escortduty = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_privateer_tier2_escortduty",

	questName = "tatooine_privateer_tier2_1",
	questType = "escort_duty",

	questZone = "space_lok",

	creditReward = 2500,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"freighterlight_tier2", "freightermedium_tier2", "freighterheavy_tier2"},

	escortPoints = {
		{patrolPointName = "smuggler_vortex_mission_1_5", zoneName = "space_lok", x = -2464, z = -1051, y = -2900, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_vortex_mission_1_4", zoneName = "space_lok", x = -1009, z = -1075, y = -2900, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_lok_imp_pirate_9", zoneName = "space_lok", x = 1492, z = 662, y = -2814, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_vortex_mission_1_1", zoneName = "space_lok", x = 2241, z = -1210, y = -2943, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"corsair_manowar_tier2", "corsair_sloop_tier2", "corsair_raider_tier2"},
		{"corsair_manowar_tier2", "corsair_manowar_tier2", "corsair_raider_tier2"},
		{"corsair_sloop_tier2", "corsair_manowar_tier2", "corsair_raider_tier2"},
	},

	creditKillBonus = 200,
}

registerScreenPlay("escort_duty_tatooine_privateer_tier2_escortduty", true)

--[[
	Tier 3 -- tatooine_privateer_tier3 Main Missions (missions-only tier)
]]

-- Mission 1: Recover Jabba's stolen weapons shipment, then eliminate Valarian replacements.
recovery_tatooine_privateer_tier3_1 = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_privateer_tier3_1",

	questName = "tatooine_privateer_tier3_1",
	questType = "recovery",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_privateer_tier3_1_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 20,
	recoveryDelay = 30,

	recoverShip = "valarian_weapons_freighter_tier3",
	recoveryConversationMobile = "object/mobile/ig_assassin_droid.iff",

	escortShips = {"valarian_replacement_1_tier3", "valarian_replacement_1_tier3", "valarian_replacement_1_tier3"},

	preRecoveryPoints = {
		{patrolPointName = "smuggler_spy_flight_path_2", zoneName = "space_yavin4", x = 4793, z = -5425, y = 4509, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_3", zoneName = "space_yavin4", x = 4358, z = -4600, y = 4097, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_4", zoneName = "space_yavin4", x = 4040, z = -3996, y = 3796, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_5", zoneName = "space_yavin4", x = 3589, z = -3140, y = 3370, escortNumber = 4, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_6", zoneName = "space_yavin4", x = 3280, z = -2554, y = 3078, escortNumber = 5, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_7", zoneName = "space_yavin4", x = 2073, z = -2087, y = 2117, escortNumber = 6, radius = 250},
		{patrolPointName = "smuggler_spy_flight_path_1", zoneName = "space_yavin4", x = 5199, z = -6199, y = 4893, escortNumber = 7, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "smuggler_spy_recovery_path_1", zoneName = "space_yavin4", x = 3463, z = -2741, y = 2867, escortNumber = 1, radius = 250},
		{patrolPointName = "smuggler_spy_recovery_path_2", zoneName = "space_yavin4", x = 3367, z = -2354, y = 2296, escortNumber = 2, radius = 250},
		{patrolPointName = "smuggler_spy_recovery_path_3", zoneName = "space_yavin4", x = 3282, z = -2008, y = 1786, escortNumber = 3, radius = 250},
		{patrolPointName = "smuggler_spy_recovery_path_4", zoneName = "space_yavin4", x = 3143, z = -1446, y = 956, escortNumber = 4, radius = 250},
	},

	attackDelay = 70,

	attackShips = {
		{"valarian_replacement_1_tier3", "valarian_replacement_1_tier3"},
		{"valarian_replacement_1_tier3", "valarian_replacement_1_tier3", "valarian_replacement_1_tier3"},
		{"valarian_replacement_1_tier3", "valarian_replacement_1_tier3"},
	},
}

registerScreenPlay("recovery_tatooine_privateer_tier3_1", true)

-- Mission 1 Side Quest A: First Valarian replacement (Kimogila with two Kimogila escorts).
assassinate_tatooine_privateer_tier3_1_a = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier3_1_a",

	questName = "tatooine_privateer_tier3_1_a",
	questType = "assassinate",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_privateer_tier3_1_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 0,

	parentQuest = "recovery_tatooine_privateer_tier3_1",
	parentQuestType = "recovery",
	parentQuestName = "tatooine_privateer_tier3_1",
	arrivalDelay = 5,
	failTimer = 30,
	assassinateSpawns = {target = "valarian_replacement_1_tier3", escorts = {"valarian_replacement_1_tier3", "valarian_replacement_1_tier3"}},
	targetPatrols = {{patrolPointName = "tatooine_privateer_tier3_1_a_target", zoneName = "space_yavin4", x = 2793, z = -276, y = -1231}},
}

registerScreenPlay("assassinate_tatooine_privateer_tier3_1_a", true)

-- Mission 1 Side Quest B: Second Valarian replacement (Ixiyen with three Kimogila escorts).
assassinate_tatooine_privateer_tier3_1_b = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier3_1_b",

	questName = "tatooine_privateer_tier3_1_b",
	questType = "assassinate",

	questZone = "space_yavin4",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "tatooine_privateer_tier3_1_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "assassinate_tatooine_privateer_tier3_1_a",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_privateer_tier3_1_a",
	arrivalDelay = 5,
	failTimer = 30,
	assassinateSpawns = {target = "valarian_replacement_2_tier3", escorts = {"valarian_replacement_1_tier3", "valarian_replacement_1_tier3", "valarian_replacement_1_tier3"}},
	targetPatrols = {{patrolPointName = "tatooine_privateer_tier3_1_b_target", zoneName = "space_yavin4", x = 3680, z = -853, y = -2726}},
}

registerScreenPlay("assassinate_tatooine_privateer_tier3_1_b", true)

-- Mission 1 Side Quest C: Decoy Valarian replacement (Scyk with two Kimogila escorts).
assassinate_tatooine_privateer_tier3_1_c = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier3_1_c",

	questType = "assassinate",
	questName = "tatooine_privateer_tier3_1_c",

	questZone = "space_yavin4",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "tatooine_privateer_tier3_1_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "assassinate_tatooine_privateer_tier3_1_b",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_privateer_tier3_1_b",

	arrivalDelay = 5,
	failTimer = 30,

	assassinateSpawns = {
		target = "valarian_fighter_replacement",
		escorts = {"valarian_replacement_1_tier3", "valarian_replacement_1_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "smuggler_imperial_scout_flight_path_1", zoneName = "space_yavin4", x = 3593, z = -1050, y = -3060},
		{patrolPointName = "smuggler_imperial_scout_flight_path_2", zoneName = "space_yavin4", x = 3255, z = -758, y = -2450},
		{patrolPointName = "smuggler_imperial_scout_flight_path_3", zoneName = "space_yavin4", x = 2804, z = -215, y = -1382},
		{patrolPointName = "smuggler_imperial_scout_flight_path_4", zoneName = "space_yavin4", x = 2290, z = 302, y = -266},
	},
}

registerScreenPlay("assassinate_tatooine_privateer_tier3_1_c", true)

-- Mission 1 Side Quest D: The real replacement launches a surprise attack in a Z-95.
destroy_surpriseattack_tatooine_privateer_tier3_1_d = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_privateer_tier3_1_d",

	questName = "tatooine_privateer_tier3_1_d",
	questType = "destroy_surpriseattack",

	questZone = "space_yavin4",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_tatooine_privateer_tier3_1_c",
	parentQuestType = "assassinate",
	parentQuestName = "tatooine_privateer_tier3_1_c",

	surpriseAttackShips = {zone = "space_yavin4", spawns = {{count = 1, shipName = "valarian_replacement_3_tier3"}}},
}

registerScreenPlay("destroy_surpriseattack_tatooine_privateer_tier3_1_d", true)

-- Mission 2: Locate the Witchblood burial ground and hold it for Jabba's infiltrators.
inspect_tatooine_privateer_tier3_2 = SpaceInspectScreenplay:new {
	className = "inspect_tatooine_privateer_tier3_2", questName = "tatooine_privateer_tier3_2", questType = "inspect", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "tatooine_privateer_tier3_2_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	inspectTargets = {"dath_witchblood_clan_soldier_tier3"}, inspectCargo = "witchblood_rallyinfo", spawnInspectTarget = true,
	targetLocation = {x = 4249, z = 2899, y = 3799},
}
registerScreenPlay("inspect_tatooine_privateer_tier3_2", true)

inspect_tatooine_privateer_tier3_2_a = SpaceInspectScreenplay:new {
	className = "inspect_tatooine_privateer_tier3_2_a", questName = "tatooine_privateer_tier3_2_a", questType = "inspect", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "survival", sideQuestName = "tatooine_privateer_tier3_2_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "inspect_tatooine_privateer_tier3_2", parentQuestType = "inspect", parentQuestName = "tatooine_privateer_tier3_2",
	inspectTargets = {"dath_witchblood_clan_punisher_tier3"}, inspectCargo = "witchblood_baseinfo", spawnInspectTarget = true,
	targetLocation = {x = 1000, z = -2000, y = -3452},
}
registerScreenPlay("inspect_tatooine_privateer_tier3_2_a", true)

survival_tatooine_privateer_tier3_2_b = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_privateer_tier3_2_b", questName = "tatooine_privateer_tier3_2_b", questType = "survival", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "",
	parentQuest = "inspect_tatooine_privateer_tier3_2_a", parentQuestType = "inspect", parentQuestName = "tatooine_privateer_tier3_2_a",
	survivalTime = 420, survivalUpdateInterval = 30, survivalPoint = {x = -1200, z = 400, y = 2600}, survivalAreaRadius = 750,
	delayToFirstAttack = 5, attackDelay = 120,
	attackShips = {
		{"dath_witchblood_clan_soldier_tier3", "dath_witchblood_clan_soldier_tier3", "dath_witchblood_clan_soldier_tier3"},
		{"dath_witchblood_clan_punisher_tier3", "dath_witchblood_clan_punisher_tier3", "dath_witchblood_clan_punisher_tier3"},
		{"dath_witchblood_clan_punisher_tier4", "dath_witchblood_clan_punisher_tier4"},
	},
}
registerScreenPlay("survival_tatooine_privateer_tier3_2_b", true)

-- Mission 3: Deliver three gifts to Imperial contacts, then escort their VIP shuttle.
delivery_no_pickup_tatooine_privateer_tier3_3 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_tatooine_privateer_tier3_3", questName = "tatooine_privateer_tier3_3", questType = "delivery_no_pickup", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "tatooine_privateer_tier3_3_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3, verifySideQuestStart = true,
	deliveryShip = "imp_lambda_shuttle_tier3", deliveryPoint = {x = -4200, z = 800, y = 3200}, attackDelay = 45,
	attackShips = {{"death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3"}},
}
registerScreenPlay("delivery_no_pickup_tatooine_privateer_tier3_3", true)

delivery_no_pickup_tatooine_privateer_tier3_3_a = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_tatooine_privateer_tier3_3_a", questName = "tatooine_privateer_tier3_3_a", questType = "delivery_no_pickup", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "tatooine_privateer_tier3_3_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3, verifySideQuestStart = true,
	parentQuest = "delivery_no_pickup_tatooine_privateer_tier3_3", parentQuestType = "delivery_no_pickup", parentQuestName = "tatooine_privateer_tier3_3",
	deliveryShip = "imp_lambda_shuttle_tier3", deliveryPoint = {x = -400, z = -900, y = 800}, attackDelay = 45,
	attackShips = {{"death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3"}},
}
registerScreenPlay("delivery_no_pickup_tatooine_privateer_tier3_3_a", true)

delivery_no_pickup_tatooine_privateer_tier3_3_b = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_tatooine_privateer_tier3_3_b", questName = "tatooine_privateer_tier3_3_b", questType = "delivery_no_pickup", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "escort", sideQuestName = "tatooine_privateer_tier3_3_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3, verifySideQuestStart = true,
	parentQuest = "delivery_no_pickup_tatooine_privateer_tier3_3_a", parentQuestType = "delivery_no_pickup", parentQuestName = "tatooine_privateer_tier3_3_a",
	deliveryShip = "imp_lambda_shuttle_tier4", deliveryPoint = {x = 3200, z = -500, y = -2600}, attackDelay = 45,
	attackShips = {{"death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3", "death_watch_eradicator_tier3"}},
}
registerScreenPlay("delivery_no_pickup_tatooine_privateer_tier3_3_b", true)

escort_tatooine_privateer_tier3_3_c = SpaceEscortScreenplay:new {
	className = "escort_tatooine_privateer_tier3_3_c", questName = "tatooine_privateer_tier3_3_c", questType = "escort", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "",
	parentQuest = "delivery_no_pickup_tatooine_privateer_tier3_3_b", parentQuestType = "delivery_no_pickup", parentQuestName = "tatooine_privateer_tier3_3_b",
	escortShips = {"imp_lambda_shuttle_tier4"}, escortSpeed = 45, orderedEscortRoute = true,
	escortPoints = {
		{patrolPointName = "tatooine_privateer_tier3_3_c_escort_1", zoneName = "space_dathomir", x = -5250, z = -850, y = 2000, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier3_3_c_escort_2", zoneName = "space_dathomir", x = -4323, z = -525, y = 2310, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier3_3_c_escort_3", zoneName = "space_dathomir", x = -3632, z = -680, y = 1552, escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier3_3_c_escort_4", zoneName = "space_dathomir", x = -2813, z = -400, y = 1793, escortNumber = 4, radius = 250},
	},
	attackDelay = 55,
	attackShips = {{"dath_freelance_killer_tier3", "dath_freelance_killer_tier3", "dath_freelance_killer_tier3"}, {"dath_freelance_killer_tier3", "dath_freelance_killer_tier3"}},
}
registerScreenPlay("escort_tatooine_privateer_tier3_3_c", true)

-- Mission 4: Patrol for the Rancor Clan, win two battles, locate and rescue the Hutt VIP.
patrol_tatooine_privateer_tier3_4 = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_privateer_tier3_4", questName = "tatooine_privateer_tier3_4", questType = "patrol", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "space_battle", sideQuestName = "tatooine_privateer_tier3_4_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	patrolPoints = {
		{patrolPointName = "tatooine_privateer_tier3_4_patrol_1", x = -3960, z = -400, y = -4950, patrolNumber = 1, radius = 150},
		{patrolPointName = "tatooine_privateer_tier3_4_patrol_2", x = -3460, z = 37, y = -3563, patrolNumber = 2, radius = 150},
		{patrolPointName = "tatooine_privateer_tier3_4_patrol_3", x = -2777, z = 778, y = -3350, patrolNumber = 3, radius = 150},
	},
}
registerScreenPlay("patrol_tatooine_privateer_tier3_4", true)

space_battle_tatooine_privateer_tier3_4_a = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_privateer_tier3_4_a", questName = "tatooine_privateer_tier3_4_a", questType = "space_battle", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "space_battle", sideQuestName = "tatooine_privateer_tier3_4_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "patrol_tatooine_privateer_tier3_4", parentQuestType = "patrol", parentQuestName = "tatooine_privateer_tier3_4",
	battleLocation = {x = -500, z = 600, y = 2200}, allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -600, enemyOriginDist = 700, allyArrivalDist = -100, enemyArrivalDist = 100,
	alliedShips = {{"hutt_fighter_s01_tier4"}, {"hutt_fighter_s02_tier4"}, {"hutt_bomber_s01_tier4"}},
	enemyShips = {{"rancor_clan_elite_tier4"}, {"rancor_clan_elite_tier4"}, {"rancor_clan_gunship_tier4"}, {"rancor_clan_gunship_tier4"}, {"rancor_clan_ace_tier3"}, {"rancor_clan_ace_tier3"}},
}
registerScreenPlay("space_battle_tatooine_privateer_tier3_4_a", true)

space_battle_tatooine_privateer_tier3_4_b = SpaceBattleScreenplay:new {
	className = "space_battle_tatooine_privateer_tier3_4_b", questName = "tatooine_privateer_tier3_4_b", questType = "space_battle", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "patrol", sideQuestName = "tatooine_privateer_tier3_4_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "space_battle_tatooine_privateer_tier3_4_a", parentQuestType = "space_battle", parentQuestName = "tatooine_privateer_tier3_4_a",
	battleLocation = {x = 2700, z = -400, y = -1800}, allyArrivalDelay = 10, enemyArrivalDelay = 15, allyOriginDist = -600, enemyOriginDist = 700, allyArrivalDist = -100, enemyArrivalDist = 100,
	alliedShips = {{"hutt_fighter_s01_tier4"}, {"hutt_fighter_s02_tier4"}, {"hutt_bomber_s01_tier4"}},
	enemyShips = {{"rancor_clan_soldier_tier3"}, {"rancor_clan_soldier_tier3"}, {"rancor_clan_soldier_tier3"}, {"rancor_clan_gunship_tier5"}, {"rancor_clan_gunship_tier5"}, {"rancor_clan_gunship_tier5"}, {"rancor_clan_ace_tier3"}},
}
registerScreenPlay("space_battle_tatooine_privateer_tier3_4_b", true)

patrol_tatooine_privateer_tier3_4_c = SpacePatrolScreenplay:new {
	className = "patrol_tatooine_privateer_tier3_4_c", questName = "tatooine_privateer_tier3_4_c", questType = "patrol", questZone = "space_dathomir", creditReward = 0,
	sideQuest = true, sideQuestType = "rescue", sideQuestName = "tatooine_privateer_tier3_4_d", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "space_battle_tatooine_privateer_tier3_4_b", parentQuestType = "space_battle", parentQuestName = "tatooine_privateer_tier3_4_b",
	patrolPoints = {
		{patrolPointName = "tatooine_privateer_tier3_4_c_patrol_1", x = 2900, z = -2400, y = 1500, patrolNumber = 1, radius = 150},
		{patrolPointName = "tatooine_privateer_tier3_4_c_patrol_2", x = 1500, z = -1200, y = 500, patrolNumber = 2, radius = 150},
		{patrolPointName = "tatooine_privateer_tier3_4_c_patrol_3", x = 200, z = -300, y = -900, patrolNumber = 3, radius = 150},
	},
}
registerScreenPlay("patrol_tatooine_privateer_tier3_4_c", true)

rescue_tatooine_privateer_tier3_4_d = SpaceRescueScreenplay:new {
	className = "rescue_tatooine_privateer_tier3_4_d", questName = "tatooine_privateer_tier3_4_d", questType = "rescue", questZone = "space_dathomir", creditReward = 0,
	sideQuest = false, sideQuestType = "",
	parentQuest = "patrol_tatooine_privateer_tier3_4_c", parentQuestType = "patrol", parentQuestName = "tatooine_privateer_tier3_4_c",
	arrivalDelay = 5, rescueShip = "imp_lambda_shuttle_tier4", rescueLocation = {x = -3600, z = 1200, y = 1800}, repairDelay = 20, escortSpeed = 45,
	escortPoints = {
		{patrolPointName = "tatooine_privateer_tier3_4_d_escape_1", zoneName = "space_dathomir", x = -4300, z = 800, y = 800, escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier3_4_d_escape_2", zoneName = "space_dathomir", x = -5000, z = 300, y = -500, escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier3_4_d_escape_3", zoneName = "space_dathomir", x = -5700, z = -200, y = -1800, escortNumber = 3, radius = 250},
	},
	escortAttackDelay = 45, escortAttackShips = {{{count = 3, shipName = "rancor_clan_soldier_tier3"}}, {{count = 2, shipName = "rancor_clan_ace_tier3"}}},
}
registerScreenPlay("rescue_tatooine_privateer_tier3_4_d", true)

--[[
	Tier 4 -- canonical Nirame Sakute mission chains
]]

-- Mission 1: move Nym spice from Lok to Dantooine, then finish the Hutt delivery.
delivery_tatooine_privateer_tier4_1a = SpaceDeliveryScreenplay:new {
	className = "delivery_tatooine_privateer_tier4_1a", questName = "tatooine_privateer_tier4_1a", questType = "delivery",
	questZone = "space_lok", pickupZone = "space_lok", deliveryZone = "space_dantooine", creditReward = 10000,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "tatooine_privateer_tier4_1b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	pickupShip = "nym_freightermedium_tier4", deliveryShip = "hutt_transport_tier4",
	pickupPoint = {x = -5706, z = 875, y = -3291}, deliveryPoint = {x = -6319, z = -3042, y = -5225},
	attackDelay = 20, attackShips = {{"imp_tie_advanced_tier4", "imp_tie_advanced_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"}},
}
registerScreenPlay("delivery_tatooine_privateer_tier4_1a", true)

delivery_no_pickup_tatooine_privateer_tier4_1b = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_tatooine_privateer_tier4_1b", questName = "tatooine_privateer_tier4_1b", questType = "delivery_no_pickup", questZone = "space_dantooine", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "delivery_tatooine_privateer_tier4_1a", parentQuestType = "delivery", parentQuestName = "tatooine_privateer_tier4_1a",
	deliveryShip = "hutt_transport_tier4", deliveryPoint = {x = 642, z = 2454, y = 2561}, attackDelay = 20,
	attackShips = {{"corsec_interceptor_tier4", "corsec_interceptor_tier4", "corsec_interceptor_tier4", "corsec_interdiction_craft_tier4", "corsec_interdiction_craft_tier4", "corsec_interdiction_craft_tier4", "corsec_fighter_tier3", "corsec_fighter_tier3", "corsec_gunship_tier4"}},
}
registerScreenPlay("delivery_no_pickup_tatooine_privateer_tier4_1b", true)

-- Mission 2: recover the captured Black Sun freighter, steal an Imperial shuttle, and escape the ambush.
recovery_tatooine_privateer_tier4_2a = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_privateer_tier4_2a", questName = "tatooine_privateer_tier4_2a", questType = "recovery", questZone = "space_dantooine", creditReward = 10000,
	sideQuest = true, sideQuestType = "recovery", sideQuestName = "tatooine_privateer_tier4_2b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	arrivalDelay = 5, recoveryDelay = 20, recoverShip = "blacksun_transport_tier4", recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff",
	escortShips = {"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
	preRecoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_recovery_one_escort_1",zoneName="space_dantooine",x=1687,z=-2715,y=6961,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_escort_2",zoneName="space_dantooine",x=3717,z=509,y=5476,escortNumber=2,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_escort_3",zoneName="space_dantooine",x=4629,z=3005,y=3978,escortNumber=3,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_escort_4",zoneName="space_dantooine",x=5973,z=5760,y=2392,escortNumber=4,radius=250},
	},
	recoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_recovery_one_egress_1",zoneName="space_dantooine",x=5741,z=3896,y=2564,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_egress_2",zoneName="space_dantooine",x=5402,z=1274,y=2831,escortNumber=2,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_egress_3",zoneName="space_dantooine",x=4791,z=-2205,y=3186,escortNumber=3,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_one_egress_4",zoneName="space_dantooine",x=4310,z=-5914,y=3532,escortNumber=4,radius=250},
	},
	attackDelay = 25, attackShips = {{"imp_tie_interceptor_tier4"}},
}
registerScreenPlay("recovery_tatooine_privateer_tier4_2a", true)

recovery_tatooine_privateer_tier4_2b = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_privateer_tier4_2b", questName = "tatooine_privateer_tier4_2b", questType = "recovery", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "survival", sideQuestName = "tatooine_privateer_tier4_2c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "recovery_tatooine_privateer_tier4_2a", parentQuestType = "recovery", parentQuestName = "tatooine_privateer_tier4_2a",
	arrivalDelay = 5, recoveryDelay = 20, recoverShip = "imp_lambda_shuttle_tier4", recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff", escortShips = {},
	preRecoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_recovery_two_escort_1",zoneName="space_dantooine",x=1277,z=2941,y=-460,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_escort_2",zoneName="space_dantooine",x=503,z=4568,y=2673,escortNumber=2,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_escort_3",zoneName="space_dantooine",x=-92,z=5799,y=5096,escortNumber=3,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_escort_4",zoneName="space_dantooine",x=-1677,z=7401,y=7455,escortNumber=4,radius=250},
	},
	recoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_recovery_two_egress_1",zoneName="space_dantooine",x=-1136,z=5676,y=7396,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_egress_2",zoneName="space_dantooine",x=-381,z=2578,y=7313,escortNumber=2,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_egress_3",zoneName="space_dantooine",x=395,z=-609,y=7228,escortNumber=3,radius=250},
		{patrolPointName="tatooine_privateer_tier4_recovery_two_egress_4",zoneName="space_dantooine",x=1050,z=-3779,y=7179,escortNumber=4,radius=250},
	},
	attackDelay = 25, attackShips = {{"imp_tie_aggressor_tier4"}},
}
registerScreenPlay("recovery_tatooine_privateer_tier4_2b", true)

survival_tatooine_privateer_tier4_2c = SpaceSurvivalScreenplay:new {
	className = "survival_tatooine_privateer_tier4_2c", questName = "tatooine_privateer_tier4_2c", questType = "survival", questZone = "space_dantooine", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "recovery_tatooine_privateer_tier4_2b", parentQuestType = "recovery", parentQuestName = "tatooine_privateer_tier4_2b",
	survivalTime = 60, survivalUpdateInterval = 30, survivalPoint = {x=1800,z=-1200,y=6100}, survivalAreaRadius = 750, retainWaypointDuringSurvival = true,
	delayToFirstAttack = 5, attackDelay = 120, attackShips = {{"imp_imperial_gunboat_tier4", "imp_imperial_gunboat_tier4"}},
}
registerScreenPlay("survival_tatooine_privateer_tier4_2c", true)

-- Mission 3: take Valarian freight plans, destroy the operatives, survive their trick, and capture the mining freighter.
inspect_tatooine_privateer_tier4_3a = SpaceInspectScreenplay:new {
	className = "inspect_tatooine_privateer_tier4_3a", questName = "tatooine_privateer_tier4_3a", questType = "inspect", questZone = "space_dantooine", creditReward = 10000,
	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "tatooine_privateer_tier4_3b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	inspectTargets = {"valarian_gunship_inspect_tier4"}, inspectEscortShips = {"valarian_bomber_tier3", "valarian_bomber_tier3"}, inspectCargo = "valarian_freight_plans",
	spawnInspectTarget = true, targetLocation = {x=6348,z=4225,y=4381},
}
registerScreenPlay("inspect_tatooine_privateer_tier4_3a", true)

assassinate_tatooine_privateer_tier4_3b = SpaceAssassinateScreenplay:new {
	className = "assassinate_tatooine_privateer_tier4_3b", questName = "tatooine_privateer_tier4_3b", questType = "assassinate", questZone = "space_tatooine", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "tatooine_privateer_tier4_3c_sa", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "inspect_tatooine_privateer_tier4_3a", parentQuestType = "inspect", parentQuestName = "tatooine_privateer_tier4_3a",
	arrivalDelay = 5, failTimer = 30, assassinateSpawns = {target="valarian_gunship_tier5",escorts={"valarian_bomber_tier4","valarian_bomber_tier4","valarian_bomber_tier4","valarian_bomber_tier4"}},
	targetPatrols = {{patrolPointName="tatooine_privateer_tier4_3b_target",zoneName="space_tatooine",x=-1607,z=6008,y=-240}},
}
registerScreenPlay("assassinate_tatooine_privateer_tier4_3b", true)

destroy_surpriseattack_tatooine_privateer_tier4_3c_sa = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_tatooine_privateer_tier4_3c_sa", questName = "tatooine_privateer_tier4_3c_sa", questType = "destroy_surpriseattack", questZone = "space_tatooine",
	sideQuest = true, sideQuestType = "recovery", sideQuestName = "tatooine_privateer_tier4_3c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 3,
	parentQuest = "assassinate_tatooine_privateer_tier4_3b", parentQuestType = "assassinate", parentQuestName = "tatooine_privateer_tier4_3b",
	surpriseAttackShips = {zone="space_tatooine",spawns={{count=2,shipName="valarian_gunship_tier4"},{count=2,shipName="valarian_bomber_tier5"}}},
}
registerScreenPlay("destroy_surpriseattack_tatooine_privateer_tier4_3c_sa", true)

recovery_tatooine_privateer_tier4_3c = SpaceRecoveryScreenplay:new {
	className = "recovery_tatooine_privateer_tier4_3c", questName = "tatooine_privateer_tier4_3c", questType = "recovery", questZone = "space_endor", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "destroy_surpriseattack_tatooine_privateer_tier4_3c_sa", parentQuestType = "destroy_surpriseattack", parentQuestName = "tatooine_privateer_tier4_3c_sa",
	arrivalDelay = 5, recoveryDelay = 20, recoverShip = "valarian_freighterlight_mining_tier4", recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff",
	escortShips = {}, preRecoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_3c_capture_1",zoneName="space_endor",x=4200,z=-1200,y=5100,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_3c_capture_2",zoneName="space_endor",x=3500,z=-800,y=3900,escortNumber=2,radius=250},
	},
	recoveryPoints = {
		{patrolPointName="tatooine_privateer_tier4_3c_escape_1",zoneName="space_endor",x=2500,z=-500,y=2500,escortNumber=1,radius=250},
		{patrolPointName="tatooine_privateer_tier4_3c_escape_2",zoneName="space_endor",x=900,z=-100,y=800,escortNumber=2,radius=250},
		{patrolPointName="tatooine_privateer_tier4_3c_escape_3",zoneName="space_endor",x=-1200,z=300,y=-1400,escortNumber=3,radius=250},
	},
	attackDelay = 30, attackShips = {{"valarian_gunship_tier4", "valarian_bomber_tier4"}},
}
registerScreenPlay("recovery_tatooine_privateer_tier4_3c", true)

-- Mission 4: remove an Imperial ace, a CorSec patrol leader, and an RSF ace.
assassinate_tatooine_privateer_tier4_4a = SpaceAssassinateScreenplay:new {
	className="assassinate_tatooine_privateer_tier4_4a",questName="tatooine_privateer_tier4_4a",questType="assassinate",questZone="space_lok",creditReward=10000,
	sideQuest=true,sideQuestType="assassinate",sideQuestName="tatooine_privateer_tier4_4b",sideQuestSplitType=SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,sideQuestDelay=3,
	arrivalDelay=5,failTimer=30,assassinateSpawns={target="imp_tie_oppressor_tier5",escorts={"imp_tie_advanced_tier4","imp_tie_advanced_tier4","imp_tie_advanced_tier4","imp_tie_advanced_tier4"}},
	targetPatrols={{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_one_1",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_one_2",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_one_3",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_one_4",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_one_5",zoneName="space_lok"}},
}
registerScreenPlay("assassinate_tatooine_privateer_tier4_4a", true)

assassinate_tatooine_privateer_tier4_4b = SpaceAssassinateScreenplay:new {
	className="assassinate_tatooine_privateer_tier4_4b",questName="tatooine_privateer_tier4_4b",questType="assassinate",questZone="space_lok",creditReward=0,
	sideQuest=true,sideQuestType="assassinate",sideQuestName="tatooine_privateer_tier4_4c",sideQuestSplitType=SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,sideQuestDelay=3,
	parentQuest="assassinate_tatooine_privateer_tier4_4a",parentQuestType="assassinate",parentQuestName="tatooine_privateer_tier4_4a",
	arrivalDelay=5,failTimer=30,assassinateSpawns={target="corsec_gunship_tier4",escorts={"corsec_interdiction_craft_tier4","corsec_interdiction_craft_tier4","corsec_interdiction_craft_tier4"}},
	targetPatrols={{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_two_1",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_two_2",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_two_3",zoneName="space_lok"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_two_4",zoneName="space_lok"}},
}
registerScreenPlay("assassinate_tatooine_privateer_tier4_4b", true)

assassinate_tatooine_privateer_tier4_4c = SpaceAssassinateScreenplay:new {
	className="assassinate_tatooine_privateer_tier4_4c",questName="tatooine_privateer_tier4_4c",questType="assassinate",questZone="space_dantooine",creditReward=0,
	sideQuest=false,sideQuestType="",parentQuest="assassinate_tatooine_privateer_tier4_4b",parentQuestType="assassinate",parentQuestName="tatooine_privateer_tier4_4b",
	arrivalDelay=5,failTimer=30,assassinateSpawns={target="rsf_ace_tier5",escorts={"rsf_stinger_tier4","rsf_stinger_tier4","rsf_stinger_tier4","rsf_stinger_tier4"}},
	targetPatrols={{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_three_1",zoneName="space_dantooine"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_three_2",zoneName="space_dantooine"},{patrolPointName="tatooine_privateer_tier4_leg_4_assassinate_three_3",zoneName="space_dantooine"}},
}
registerScreenPlay("assassinate_tatooine_privateer_tier4_4c", true)

-- Master Mission (two-stage Kessel encounter): temporary Imperial service culminates
-- in destroy_master_imperial_1 (disrupt the emerging Rebel fighter screen) and
-- destroy_master_imperial_2 (destroy its Corellian Corvette command vessel), defined in
-- screenplays/space/squadrons/KesselMasterEncounterScreenplay.lua (loaded first).

-- Tier 4 Duty Missions

-- Escort Duty (Space Lok - escort Nym freighters through Imperial attacks)
escort_duty_tatooine_privateer_tier4_1 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_tatooine_privateer_tier4_1",

	questName = "tatooine_privateer_tier4_1",
	questType = "escort_duty",

	questZone = "space_lok",

	creditReward = 5000,
	creditKillBonus = 300,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"nym_freightermedium_tier4"},

	escortPoints = {
		{patrolPointName = "tatooine_privateer_tier4_duty_escort_1", zoneName = "space_lok", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_duty_escort_2", zoneName = "space_lok", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_duty_escort_3", zoneName = "space_lok", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_duty_escort_4", zoneName = "space_lok", escortNumber = 4, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_duty_escort_5", zoneName = "space_lok", escortNumber = 5, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_advanced_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_advanced_tier4", "imp_tie_advanced_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_advanced_tier4", "imp_tie_aggressor_tier4"},
	},
}

registerScreenPlay("escort_duty_tatooine_privateer_tier4_1", true)

-- Rescue Duty (Space Lok - rescue disabled Nym ships from CorSec and RSF attackers)
rescue_duty_tatooine_privateer_tier4_1 = SpaceDutyRescueScreenplay:new {
	className = "rescue_duty_tatooine_privateer_tier4_1",

	questName = "tatooine_privateer_tier4_1",
	questType = "rescue_duty",

	questZone = "space_lok",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	targetShips = {"nym_freightermedium_tier4"},

	targetArrivalDelay = 3,

	recoveryPoints = {
		{patrolPointName = "tatooine_privateer_tier4_rescue_duty_1", zoneName = "space_lok", radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_rescue_duty_2", zoneName = "space_lok", radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_rescue_duty_3", zoneName = "space_lok", radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_rescue_duty_4", zoneName = "space_lok", radius = 250},
	},

	attackDelay = 60,

	attackShips = {
		{"corsec_interceptor_tier4", "corsec_interceptor_tier4", "corsec_interdiction_craft_tier4"},
		{"corsec_interdiction_craft_tier4", "corsec_interdiction_craft_tier4", "corsec_gunship_tier4"},
		{"rsf_stinger_tier4", "rsf_stinger_tier4", "corsec_gunship_tier4"},
	},
}

registerScreenPlay("rescue_duty_tatooine_privateer_tier4_1", true)

-- Recovery Duty (Space Dantooine - capture an Imperial freighter and escape its patrols)
recovery_duty_tatooine_privateer_tier4_1 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_tatooine_privateer_tier4_1",

	questName = "tatooine_privateer_tier4_1",
	questType = "recovery_duty",

	questZone = "space_dantooine",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	recoverShip = "imp_freighterheavy_tier4",
	targetArrivalDelay = 10,
	recoveryDelay = 30,

	recoveryFaction = "nym",
	recoveryConversationMobile = "object/mobile/dressed_nym_brawler_tran_m.iff",

	escortShips = {"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_escort_1", zoneName = "space_dantooine", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_escort_2", zoneName = "space_dantooine", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_escort_3", zoneName = "space_dantooine", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_escort_4", zoneName = "space_dantooine", escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_egress_1", zoneName = "space_dantooine", escortNumber = 1, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_egress_2", zoneName = "space_dantooine", escortNumber = 2, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_egress_3", zoneName = "space_dantooine", escortNumber = 3, radius = 250},
		{patrolPointName = "tatooine_privateer_tier4_recovery_duty_egress_4", zoneName = "space_dantooine", escortNumber = 4, radius = 250},
	},

	attackDelay = 45,

	attackShips = {
		{"imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_advanced_tier4"},
	},
}

registerScreenPlay("recovery_duty_tatooine_privateer_tier4_1", true)

-- Destroy Duty (Space Dantooine - disrupt RSF and Imperial patrols)
destroy_duty_tatooine_privateer_tier4_1 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_privateer_tier4_1",

	questName = "tatooine_privateer_tier4_1",
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

	bossShip = "imp_tie_aggressor_tier4",
	shipTypes = {
		{"corsec_interdiction_craft_tier4", "corsec_interdiction_craft_tier4"},
		{"imp_tie_advanced_tier4", "imp_tie_advanced_tier4"},
		{"corsec_interdiction_craft_tier4", "imp_tie_advanced_tier4"},
		{"corsec_interdiction_craft_tier4"},
		{"imp_tie_advanced_tier4"},
	},
}

registerScreenPlay("destroy_duty_tatooine_privateer_tier4_1", true)

--[[

	SmugglerSquadronScreenplay

]]

SmugglerSquadronScreenplay = ScreenPlay:new {
	screenplayName = "SmugglerSquadronScreenplay",

	-- Tier 1 (Lt. Barn Sinkko)
	QUEST_STRING_1 = {type = "patrol", name = "tatooine_privateer_1"},
	QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "tatooine_privateer_1"},
	QUEST_STRING_2 = {type = "destroy", name = "tatooine_privateer_2"},
	QUEST_STRING_3 = {type = "patrol", name = "tatooine_privateer_3"},
	QUEST_STRING_3_SIDE = {type = "escort", name = "tatooine_privateer_3"},
	QUEST_STRING_4 = {type = "assassinate", name = "tatooine_privateer_tier1_4a"},
	QUEST_STRING_TRANS_PATROL = {type = "patrol", name = "tat_priv_quest_trans"},
	QUEST_STRING_TRANS_ASSASSINATE = {type = "assassinate", name = "tat_priv_quest_trans"},
	QUEST_STRING_DUTY_1 = {type = "recovery_duty", name = "tatooine_privateer_5"},
	QUEST_STRING_DUTY_2 = {type = "destroy_duty", name = "tatooine_privateer_6"},
	QUEST_STRING_DUTY_3 = {type = "escort_duty", name = "tatooine_privateer_7"},
	QUEST_STRING_DUTY_4 = {type = "destroy_duty", name = "tatooine_privateer_8"},

	-- Tier 2
	TIER2_QUEST_STRING_1 = {type = "assassinate", name = "tatooine_privateer_tier2_1a"},
	TIER2_QUEST_STRING_2 = {type = "assassinate", name = "tatooine_privateer_tier2_3a"},
	TIER2_QUEST_STRING_3 = {type = "escort", name = "tatooine_privateer_tier2_4a"},
	TIER2_QUEST_STRING_4 = {type = "assassinate", name = "tatooine_privateer_tier2_2a"},
	TIER2_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "tatooine_privateer_tier2_1"},
	TIER2_QUEST_STRING_DUTY_2 = {type = "recovery_duty", name = "tatooine_privateer_tier2_1"},
	TIER2_QUEST_STRING_DUTY_3 = {type = "escort_duty", name = "tatooine_privateer_tier2_1"},

	-- Tier 3
	TIER3_QUEST_STRING_1 = {type = "recovery", name = "tatooine_privateer_tier3_1"},
	TIER3_QUEST_STRING_1_SIDE1 = {type = "assassinate", name = "tatooine_privateer_tier3_1_a"},
	TIER3_QUEST_STRING_1_SIDE2 = {type = "assassinate", name = "tatooine_privateer_tier3_1_b"},
	TIER3_QUEST_STRING_1_SIDE3 = {type = "assassinate", name = "tatooine_privateer_tier3_1_c"},
	TIER3_QUEST_STRING_1_SIDE4 = {type = "destroy_surpriseattack", name = "tatooine_privateer_tier3_1_d"},
	TIER3_QUEST_STRING_2 = {type = "inspect", name = "tatooine_privateer_tier3_2"},
	TIER3_QUEST_STRING_2_SIDE1 = {type = "inspect", name = "tatooine_privateer_tier3_2_a"},
	TIER3_QUEST_STRING_2_SIDE2 = {type = "survival", name = "tatooine_privateer_tier3_2_b"},
	TIER3_QUEST_STRING_3 = {type = "delivery_no_pickup", name = "tatooine_privateer_tier3_3"},
	TIER3_QUEST_STRING_3_SIDE1 = {type = "delivery_no_pickup", name = "tatooine_privateer_tier3_3_a"},
	TIER3_QUEST_STRING_3_SIDE2 = {type = "delivery_no_pickup", name = "tatooine_privateer_tier3_3_b"},
	TIER3_QUEST_STRING_3_SIDE3 = {type = "escort", name = "tatooine_privateer_tier3_3_c"},
	TIER3_QUEST_STRING_4 = {type = "patrol", name = "tatooine_privateer_tier3_4"},
	TIER3_QUEST_STRING_4_SIDE1 = {type = "space_battle", name = "tatooine_privateer_tier3_4_a"},
	TIER3_QUEST_STRING_4_SIDE2 = {type = "space_battle", name = "tatooine_privateer_tier3_4_b"},
	TIER3_QUEST_STRING_4_SIDE3 = {type = "patrol", name = "tatooine_privateer_tier3_4_c"},
	TIER3_QUEST_STRING_4_SIDE4 = {type = "rescue", name = "tatooine_privateer_tier3_4_d"},

	-- Tier 4
	TIER4_QUEST_STRING_1 = {type = "delivery", name = "tatooine_privateer_tier4_1a"},
	TIER4_QUEST_STRING_1_SIDE1 = {type = "delivery_no_pickup", name = "tatooine_privateer_tier4_1b"},
	TIER4_QUEST_STRING_2 = {type = "recovery", name = "tatooine_privateer_tier4_2a"},
	TIER4_QUEST_STRING_2_SIDE1 = {type = "recovery", name = "tatooine_privateer_tier4_2b"},
	TIER4_QUEST_STRING_2_SIDE2 = {type = "survival", name = "tatooine_privateer_tier4_2c"},
	TIER4_QUEST_STRING_3 = {type = "inspect", name = "tatooine_privateer_tier4_3a"},
	TIER4_QUEST_STRING_3_SIDE1 = {type = "assassinate", name = "tatooine_privateer_tier4_3b"},
	TIER4_QUEST_STRING_3_SIDE2 = {type = "destroy_surpriseattack", name = "tatooine_privateer_tier4_3c_sa"},
	TIER4_QUEST_STRING_3_SIDE3 = {type = "recovery", name = "tatooine_privateer_tier4_3c"},
	TIER4_QUEST_STRING_4 = {type = "assassinate", name = "tatooine_privateer_tier4_4a"},
	TIER4_QUEST_STRING_4_SIDE1 = {type = "assassinate", name = "tatooine_privateer_tier4_4b"},
	TIER4_QUEST_STRING_4_SIDE2 = {type = "assassinate", name = "tatooine_privateer_tier4_4c"},
	TIER4_QUEST_STRING_MASTER = {type = "destroy", name = "master_imperial_1"},
	TIER4_QUEST_STRING_MASTER_2 = {type = "destroy", name = "master_imperial_2"},
	TIER4_QUEST_STRING_DUTY_1 = {type = "escort_duty", name = "tatooine_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_2 = {type = "rescue_duty", name = "tatooine_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_3 = {type = "recovery_duty", name = "tatooine_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_4 = {type = "destroy_duty", name = "tatooine_privateer_tier4_1"},
}

registerScreenPlay("SmugglerSquadronScreenplay", false)

function SmugglerSquadronScreenplay:start()
end

-- Reset functions for quest clearing

function SmugglerSquadronScreenplay:resetDravisQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	patrol_tatooine_privateer_1:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_privateer_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1.type, self.QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1_SIDE.type, self.QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	destroy_tatooine_privateer_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_2.type, self.QUEST_STRING_2.name, false)

	-- Mission 3
	patrol_tatooine_privateer_3:resetQuest(pPlayer)
	escort_tatooine_privateer_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3.type, self.QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3_SIDE.type, self.QUEST_STRING_3_SIDE.name, false)

	-- Mission 4
	assassinate_tatooine_privateer_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_4.type, self.QUEST_STRING_4.name, false)

	-- Talon Karrde transition mission
	assassinate_tat_priv_quest_trans:resetQuest(pPlayer)
	patrol_tat_priv_quest_trans:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_TRANS_PATROL.type, self.QUEST_STRING_TRANS_PATROL.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_TRANS_ASSASSINATE.type, self.QUEST_STRING_TRANS_ASSASSINATE.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:dravis_finished")
	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_finished")
	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:shamdon_started")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":reward")
end

function SmugglerSquadronScreenplay:resetTier2Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	assassinate_tatooine_privateer_tier2_1a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1.type, self.TIER2_QUEST_STRING_1.name, false)

	-- Mission 2
	assassinate_tatooine_privateer_tier2_2a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_2.type, self.TIER2_QUEST_STRING_2.name, false)

	-- Mission 3
	assassinate_tatooine_privateer_tier2_3a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_3.type, self.TIER2_QUEST_STRING_3.name, false)

	-- Mission 4
	escort_tatooine_privateer_tier2_4a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_4.type, self.TIER2_QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":introduced")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward")
	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:shamdon_finished")
	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_tier3_handoff")
	removeQuestStatus(playerID .. "SmugglerSquadron:tier2Smuggler")
end

function SmugglerSquadronScreenplay:resetTier3Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	recovery_tatooine_privateer_tier3_1:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier3_1_a:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier3_1_b:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier3_1_c:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_privateer_tier3_1_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1.type, self.TIER3_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE1.type, self.TIER3_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE2.type, self.TIER3_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE3.type, self.TIER3_QUEST_STRING_1_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE4.type, self.TIER3_QUEST_STRING_1_SIDE4.name, false)

	-- Mission 2
	inspect_tatooine_privateer_tier3_2:resetQuest(pPlayer)
	inspect_tatooine_privateer_tier3_2_a:resetQuest(pPlayer)
	survival_tatooine_privateer_tier3_2_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2.type, self.TIER3_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE1.type, self.TIER3_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE2.type, self.TIER3_QUEST_STRING_2_SIDE2.name, false)

	-- Mission 3
	delivery_no_pickup_tatooine_privateer_tier3_3:resetQuest(pPlayer)
	delivery_no_pickup_tatooine_privateer_tier3_3_a:resetQuest(pPlayer)
	delivery_no_pickup_tatooine_privateer_tier3_3_b:resetQuest(pPlayer)
	escort_tatooine_privateer_tier3_3_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3.type, self.TIER3_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE1.type, self.TIER3_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE2.type, self.TIER3_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE3.type, self.TIER3_QUEST_STRING_3_SIDE3.name, false)

	-- Mission 4
	patrol_tatooine_privateer_tier3_4:resetQuest(pPlayer)
	space_battle_tatooine_privateer_tier3_4_a:resetQuest(pPlayer)
	space_battle_tatooine_privateer_tier3_4_b:resetQuest(pPlayer)
	patrol_tatooine_privateer_tier3_4_c:resetQuest(pPlayer)
	rescue_tatooine_privateer_tier3_4_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4.type, self.TIER3_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE1.type, self.TIER3_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE2.type, self.TIER3_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE3.type, self.TIER3_QUEST_STRING_4_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE4.type, self.TIER3_QUEST_STRING_4_SIDE4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward")
end

function SmugglerSquadronScreenplay:resetTier4Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	delivery_tatooine_privateer_tier4_1a:resetQuest(pPlayer)
	delivery_no_pickup_tatooine_privateer_tier4_1b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1.type, self.TIER4_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE1.type, self.TIER4_QUEST_STRING_1_SIDE1.name, false)

	-- Mission 2
	recovery_tatooine_privateer_tier4_2a:resetQuest(pPlayer)
	recovery_tatooine_privateer_tier4_2b:resetQuest(pPlayer)
	survival_tatooine_privateer_tier4_2c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2.type, self.TIER4_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE1.type, self.TIER4_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE2.type, self.TIER4_QUEST_STRING_2_SIDE2.name, false)

	-- Mission 3
	inspect_tatooine_privateer_tier4_3a:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier4_3b:resetQuest(pPlayer)
	destroy_surpriseattack_tatooine_privateer_tier4_3c_sa:resetQuest(pPlayer)
	recovery_tatooine_privateer_tier4_3c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3.type, self.TIER4_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE1.type, self.TIER4_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE2.type, self.TIER4_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE3.type, self.TIER4_QUEST_STRING_3_SIDE3.name, false)

	-- Mission 4
	assassinate_tatooine_privateer_tier4_4a:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier4_4b:resetQuest(pPlayer)
	assassinate_tatooine_privateer_tier4_4c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4.type, self.TIER4_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE1.type, self.TIER4_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2.type, self.TIER4_QUEST_STRING_4_SIDE2.name, false)

	-- Master (two-stage Kessel corvette encounter)
	destroy_master_imperial_1:resetQuest(pPlayer)
	destroy_master_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER.type, self.TIER4_QUEST_STRING_MASTER.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER_2.type, self.TIER4_QUEST_STRING_MASTER_2.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "SmugglerSquadronScreenplay:StartedTier4")

	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward")
end

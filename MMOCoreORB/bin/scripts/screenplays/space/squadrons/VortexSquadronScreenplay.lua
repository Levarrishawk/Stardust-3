local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Inquisition Squadron Missions (Imperial - Naboo)

]]

--[[
	Tier 1 -- Lt. Barn Sinkko Main Missions (Naboo)
]]

-- Mission 1: Patrol with surprise attack
patrol_naboo_rebel_1 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_1",

	questName = "naboo_rebel_1",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_rebel_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "vortex_rebel_patrol_1", x = 6439, z = -5021, y = -2217, patrolNumber = 1, radius = 150},
		{patrolPointName = "vortex_rebel_patrol_2", x = 6031, z = -4540, y = -1962, patrolNumber = 2, radius = 150},
		{patrolPointName = "vortex_rebel_patrol_3", x = 4891, z = -3215, y = -1345, patrolNumber = 3, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_rebel_1", true)

destroy_surpriseattack_naboo_rebel_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_rebel_1",

	questName = "naboo_rebel_1",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_rebel_1",
	parentQuestType = "patrol",
	parentQuestName = "naboo_rebel_1",

	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 3, shipName = "imp_tie_fighter_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_rebel_1", true)

-- Mission 2: Destroy
destroy_naboo_rebel_2 = SpaceDestroyScreenplay:new {
	className = "destroy_naboo_rebel_2",

	questName = "naboo_rebel_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "vortex_imperial_patrol_1", x = 590, z = -3500, y = -6000},
		{patrolPointName = "vortex_imperial_patrol_2", x = -2500, z = 4000, y = 3500},
		{patrolPointName = "vortex_imperial_patrol_3", x = -3800, z = 2500, y = 5000},
	},

	shipTypes = {
		"imp_tie_fighter_tier1", "imp_tie_fighter_tier2", "imp_tie_fighter_tier3", "imp_tie_fighter_tier4",
	},
}

registerScreenPlay("destroy_naboo_rebel_2", true)

-- Mission 3: Patrol with escort side quest
patrol_naboo_rebel_3 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_3",

	questName = "naboo_rebel_3",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 500,
	itemReward = {
		{species = {SPECIES_WOOKIEE}, item = "object/tangible/wearables/bandolier/multipocket_bandolier.iff"},
		{species = {SPECIES_ITHORIAN}, item = "object/tangible/wearables/bandolier/ith_multipocket_bandolier.iff"},
		{species = {-1}, item = "object/tangible/wearables/bodysuit/bodysuit_s14.iff"},
	},

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_rebel_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	patrolPoints = {
		{patrolPointName = "vortex_rebel_security_patrol_1", x = 5024, z = -3710, y = -1723, patrolNumber = 1, radius = 150},
		{patrolPointName = "vortex_rebel_security_patrol_2", x = 3933, z = -3285, y = -3098, patrolNumber = 2, radius = 150},
		{patrolPointName = "vortex_rebel_security_patrol_3", x = 3574, z = -2819, y = -4741, patrolNumber = 3, radius = 150},
		{patrolPointName = "vortex_rebel_security_patrol_4", x = 4496, z = -1657, y = -6222, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_rebel_3", true)

escort_naboo_rebel_3 = SpaceEscortScreenplay:new {
	className = "escort_naboo_rebel_3",

	questName = "naboo_rebel_3",
	questType = "escort",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_rebel_3",
	parentQuestType = "patrol",
	parentQuestName = "naboo_rebel_3",

	escortShips = {"reb_freightermedium_tier1"},

	escortPoints = {
		{patrolPointName = "vortex_rebel_escort_1", zoneName = "space_naboo", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_rebel_escort_2", zoneName = "space_naboo", x = 6446, z = 2694, y = -5694, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_rebel_escort_3", zoneName = "space_naboo", x = 4453, z = 3127, y = -7150, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_rebel_escort_4", zoneName = "space_naboo", x = 1085, z = 4064, y = -7316, escortNumber = 4, radius = 250},
	},
	orderedEscortRoute = true,

	attackDelay = 80,

	attackShips = {
		{"imp_tie_fighter_tier1"},
		{"imp_tie_fighter_tier1"},
		{"imp_tie_fighter_tier1"},
	}
}

registerScreenPlay("escort_naboo_rebel_3", true)

-- Mission 4: Assassinate
assassinate_naboo_rebel_4 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_rebel_4",

	questType = "assassinate",
	questName = "naboo_rebel_4",

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
		target = "imp_tie_fighter_veteran_tier2",
		escorts = {"imp_tie_fighter_tier1", "imp_tie_fighter_tier1", "imp_tie_fighter_tier1", "imp_tie_fighter_tier1"},
	},

	targetPatrols = {
		{patrolPointName = "vortex_rebel_security_patrol_2", x = 3933, z = -3285, y = -3098},
		{patrolPointName = "vortex_naboo_privateer_tier3_leg_2_rescue_egress_4", x = 1156, z = -7106, y = -2482},
		{patrolPointName = "vortex_trade_escort_4", x = 895, z = 210, y = 695},
		{patrolPointName = "vortex_military_escort_2", x = 2915, z = 3828, y = 2887},
		{patrolPointName = "vortex_corellia_imperial_tier3_leg_1_recovery_recover_1", x = 752, z = -2678, y = -1479},
	},
}

registerScreenPlay("assassinate_naboo_rebel_4", true)

-- Sinkko Duty Missions
destroy_duty_naboo_rebel_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_rebel_6",

	questName = "naboo_rebel_6",
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

	bossShip = "imp_tie_fighter_tier2",
	shipTypes = {
		{"imp_tie_fighter_tier1"},
	},
}

registerScreenPlay("destroy_duty_naboo_rebel_6", true)

escort_duty_naboo_rebel_7 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_rebel_7",

	questName = "naboo_rebel_7",
	questType = "escort_duty",

	questZone = "space_naboo",

	creditReward = 1000,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"reb_transport_tier1", "reb_freightermedium_tier1", "reb_freighterlight_tier1", "reb_freighterheavy_tier1"},

	escortPoints = {
		{patrolPointName = "vortex_rebel_escort_1", zoneName = "space_naboo", x = 7188, z = 1899, y = -2831, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_rebel_escort_4", zoneName = "space_naboo", x = 1085, z = 4064, y = -7316, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_rebel_patrol_1", zoneName = "space_naboo", x = 6439, z = -5021, y = -2217, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_rebel_patrol_3", zoneName = "space_naboo", x = 4891, z = -3215, y = -1345, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"imp_tie_fighter_tier1"},
		{"imp_tie_fighter_tier1"},
		{"imp_tie_fighter_tier1"},
	},

	creditKillBonus = 100,
}

registerScreenPlay("escort_duty_naboo_rebel_7", true)

--[[
	Tier 2 -- naboo_rebel_tier2 Main Missions
]]

-- Compatibility cleanup for characters holding the obsolete placeholder tier-2
-- quests. Persisted observers resolve their screenplay by global class name, so
-- removing these objects caused a Lua panic before the replacement mission could
-- clean the character's journal.
local function clearLegacyVortexTier2Quest(pPlayer, questType, questName, className)
	if (pPlayer == nil) then
		return 0
	end

	dropObserver(ZONESWITCHED, className, "enteredZone", pPlayer)
	dropObserver(INSPECTEDSHIP, className, "inspectedShip", pPlayer)
	dropObserver(SHIPDOCKED, className, "dockedShip", pPlayer)
	SpaceHelpers:clearQuestWaypoint(pPlayer, className)
	SpaceHelpers:clearSpaceQuest(pPlayer, questType, questName, false)

	return 1
end

inspect_naboo_rebel_tier2_1 = {enteredZone = function(self, pPlayer) return clearLegacyVortexTier2Quest(pPlayer, "inspect", "naboo_rebel_tier2_1", "inspect_naboo_rebel_tier2_1") end}
destroy_surpriseattack_naboo_rebel_tier2_1 = {enteredZone = function(self, pPlayer) return clearLegacyVortexTier2Quest(pPlayer, "destroy_surpriseattack", "naboo_rebel_tier2_1", "destroy_surpriseattack_naboo_rebel_tier2_1") end}
escort_naboo_rebel_tier2_2 = {enteredZone = function(self, pPlayer) return clearLegacyVortexTier2Quest(pPlayer, "escort", "naboo_rebel_tier2_2", "escort_naboo_rebel_tier2_2") end}
recovery_naboo_rebel_tier2_3 = {enteredZone = function(self, pPlayer) return clearLegacyVortexTier2Quest(pPlayer, "recovery", "naboo_rebel_tier2_3", "recovery_naboo_rebel_tier2_3") end}
assassinate_naboo_rebel_tier2_4 = {enteredZone = function(self, pPlayer) return clearLegacyVortexTier2Quest(pPlayer, "assassinate", "naboo_rebel_tier2_4", "assassinate_naboo_rebel_tier2_4") end}

-- Mission 1: Escort Finn Darktrin, inspect the Imperial shuttle, then escape the trap
escort_vortex_mission_1 = SpaceEscortScreenplay:new {
	className = "escort_vortex_mission_1",

	questName = "vortex_mission_1",
	questType = "escort",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = true,
	sideQuestType = "inspect",
	sideQuestName = "vortex_mission_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	escortShips = {"vortex_mission_1_finn_darktrin"},
	orderedEscortRoute = true,

	escortPoints = {
		{patrolPointName = "vortex_mission_1_1", zoneName = "space_lok", x = 2241, z = -1210, y = -2943, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_mission_1_2", zoneName = "space_lok", x = 694, z = -1147, y = -2899, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_mission_1_3", zoneName = "space_lok", x = -145, z = -1077, y = -2900, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_mission_1_4", zoneName = "space_lok", x = -1009, z = -1075, y = -2900, escortNumber = 4, radius = 250},
		{patrolPointName = "vortex_mission_1_5", zoneName = "space_lok", x = -2464, z = -1051, y = -2900, escortNumber = 5, radius = 250},
	},

	attackDelay = 45,

	attackShips = {
		{"corsair_raider_tier2", "corsair_sloop_tier2"},
	}
}

registerScreenPlay("escort_vortex_mission_1", true)

inspect_vortex_mission_1 = SpaceInspectScreenplay:new {
	className = "inspect_vortex_mission_1",

	questName = "vortex_mission_1",
	questType = "inspect",

	questZone = "space_lok",

	creditReward = 5000,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "vortex_mission_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	parentQuest = "escort_vortex_mission_1",
	parentQuestType = "escort",
	parentQuestName = "vortex_mission_1",

	inspectTargets = {"vortex_mission_1_shuttle"},
	inspectCargo = "vortex_mission_1",

	targetLocation = {x = -3745, z = -3124, y = -658},
	spawnInspectTarget = true,
}

function inspect_vortex_mission_1:inspectedShip(pPlayer, pTargetShip, cargoHash)
	if (pPlayer == nil or pTargetShip == nil or not self:veryifyShipTargetAndCargo(pTargetShip, cargoHash)) then
		return 0
	end

	-- The original client task explicitly warns the pilot not to dock with the trap.
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 1, false)
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)
	createEvent(1000, self.className, "completeQuest", pPlayer, "true")

	return 1
end

registerScreenPlay("inspect_vortex_mission_1", true)

destroy_surpriseattack_vortex_mission_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_vortex_mission_1",

	questName = "vortex_mission_1",
	questType = "destroy_surpriseattack",

	questZone = "space_lok",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "inspect_vortex_mission_1",
	parentQuestType = "inspect",
	parentQuestName = "vortex_mission_1",

	surpriseAttackShips = {
		zone = "space_lok",
		spawns = {{count = 3, shipName = "imp_tie_fighter_tier2"}},
	},
}

registerScreenPlay("destroy_surpriseattack_vortex_mission_1", true)

-- Mission 2: Deliver the research data and escort the scientist out of Yavin
escort_vortex_mission_2 = SpaceEscortScreenplay:new {
	className = "escort_vortex_mission_2",

	questName = "vortex_mission_2",
	questType = "escort",

	questZone = "space_yavin4",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"vortex_mission_2_scientist"},
	orderedEscortRoute = true,

	escortPoints = {
		{patrolPointName = "vortex_mission_2_1", zoneName = "space_yavin4", x = -3100, z = -1800, y = 600, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_mission_2_2", zoneName = "space_yavin4", x = -2596, z = 126, y = 3005, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_mission_2_3", zoneName = "space_yavin4", x = -990, z = 331, y = 3100, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_mission_2_4", zoneName = "space_yavin4", x = 323, z = 348, y = 3303, escortNumber = 4, radius = 250},
	},

	attackDelay = 70,

	attackShips = {
		{"imp_tie_fighter_tier2", "imp_tie_interceptor_tier2", "imp_tie_interceptor_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_interceptor_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_interceptor_tier2"},
	}
}

registerScreenPlay("escort_vortex_mission_2", true)

-- Mission 3: Disable the prison transport and escort the freed prisoners
recovery_vortex_mission_3 = SpaceRecoveryScreenplay:new {
	className = "recovery_vortex_mission_3",

	questName = "vortex_mission_3",
	questType = "recovery",

	questZone = "space_yavin4",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	arrivalDelay = 15,
	recoveryDelay = 30,

	recoverShip = "vortex_mission_3_transport",
	recoveryConversationMobile = "object/mobile/shared_dressed_rebel_commando_rodian_male_01.iff",

	escortShips = {"imp_tie_fighter_tier2"},

	preRecoveryPoints = {
		{patrolPointName = "vortex_mission_3_1", zoneName = "space_yavin4", x = -3100, z = -1800, y = 600, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_mission_3_2", zoneName = "space_yavin4", x = -2596, z = 126, y = 3005, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_mission_3_3", zoneName = "space_yavin4", x = -990, z = 331, y = 3100, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_mission_3_4", zoneName = "space_yavin4", x = 323, z = 348, y = 3303, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "vortex_mission_3_recovery_1", zoneName = "space_yavin4", x = 2437, z = -873, y = 2907, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_mission_3_recovery_2", zoneName = "space_yavin4", x = 1893, z = -808, y = -39, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_mission_3_recovery_3", zoneName = "space_yavin4", x = 2101, z = 2448, y = -2498, escortNumber = 3, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"imp_tie_interceptor_tier2", "imp_tie_fighter_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
	},
}

registerScreenPlay("recovery_vortex_mission_3", true)

-- Mission 4: Disable, inspect, and dock with the Imperial officer's shuttle
inspect_vortex_mission_4 = SpaceInspectScreenplay:new {
	className = "inspect_vortex_mission_4",

	questType = "inspect",
	questName = "vortex_mission_4",

	questZone = "space_dantooine",

	creditReward = 0,
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	inspectTargets = {"vortex_mission_4_shuttle"},
	inspectCargo = "vortex_mission_4",

	targetLocation = {x = -3658, z = -3132, y = -3045},
	spawnInspectTarget = true,
}

registerScreenPlay("inspect_vortex_mission_4", true)

-- Tier 2 Duty Missions
destroy_duty_naboo_rebel_tier2_destroyduty = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_rebel_tier2_destroyduty",

	questName = "naboo_rebel_tier2_destroyduty",
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

	bossShip = "imp_tie_interceptor_tier3",
	shipTypes = {
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
		{"imp_tie_interceptor_tier2", "imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
	},
}

registerScreenPlay("destroy_duty_naboo_rebel_tier2_destroyduty", true)

recovery_duty_naboo_rebel_tier2_recoveryduty = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_naboo_rebel_tier2_recoveryduty",

	questName = "naboo_rebel_tier2_recoveryduty",
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
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_1", zoneName = "space_lok", x = -5007, z = -5499, y = -3499, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_2", zoneName = "space_lok", x = -6466, z = -6879, y = -4229, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_3", zoneName = "space_lok", x = -6974, z = -7081, y = -1544, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_4", zoneName = "space_lok", x = -7169, z = -6943, y = 1241, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_5", zoneName = "space_lok", x = -5700, z = -5955, y = -2034, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_6", zoneName = "space_lok", x = -5033, z = -4822, y = -3028, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_7", zoneName = "space_lok", x = -4768, z = -3941, y = -3678, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier2_recovery_duty_8", zoneName = "space_lok", x = -4757, z = -3078, y = -3964, escortNumber = 4, radius = 250},
	},

	attackDelay = 100,

	attackShips = {
		{"corsair_raider_tier2", "corsair_sloop_tier2"},
		{"corsair_sloop_tier2", "corsair_sloop_tier2"},
	},
}

registerScreenPlay("recovery_duty_naboo_rebel_tier2_recoveryduty", true)

escort_duty_naboo_rebel_tier2_escortduty = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_rebel_tier2_escortduty",

	questName = "naboo_rebel_tier2_escortduty",
	questType = "escort_duty",

	questZone = "space_lok",

	creditReward = 2500,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"nym_smuggle_vessel", "reb_smuggler_ykl37r_tier2", "reb_smuggler_yt1300_tier2"},

	escortPoints = {
		{patrolPointName = "vortex_vortex_mission_1_4", zoneName = "space_lok", x = -1009, z = -1075, y = -2900, escortNumber = 1, radius = 250},
		{patrolPointName = "vortex_lok_imp_pirate_9", zoneName = "space_lok", x = 1492, z = 662, y = -2814, escortNumber = 2, radius = 250},
		{patrolPointName = "vortex_vortex_mission_1_1", zoneName = "space_lok", x = 2241, z = -1210, y = -2943, escortNumber = 3, radius = 250},
		{patrolPointName = "vortex_vortex_mission_1_5", zoneName = "space_lok", x = -2464, z = -1051, y = -2900, escortNumber = 4, radius = 250},
	},

	attackDelay = 80,

	attackShips = {
		{"imp_tie_fighter_tier2", "imp_tie_bomber_tier2", "imp_tie_interceptor_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
		{"imp_tie_fighter_tier2", "imp_tie_fighter_tier2", "imp_tie_fighter_tier2"},
	},

	creditKillBonus = 200,
}

registerScreenPlay("escort_duty_naboo_rebel_tier2_escortduty", true)

--[[
	Tier 3 -- naboo_rebel_tier3 Main Missions (missions-only tier)
]]

-- Mission 1: terminate the Inquisitor, escort the defector, survive the attack,
-- capture the spy's data, and deliver it to Vortex intelligence.
assassinate_naboo_rebel_tier3_1 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_rebel_tier3_1", questName = "naboo_rebel_tier3_1", questType = "assassinate", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "escort", sideQuestName = "naboo_rebel_tier3_1_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	arrivalDelay = 10, failTimer = 30,
	assassinateSpawns = {target = "tieadvanced_inquisitor_tier3", escorts = {"tieinterceptor_inquisitor_tier3", "tieinterceptor_inquisitor_tier3"}},
	targetPatrols = {{patrolPointName = "naboo_rebel_tier3_point_1", zoneName = "space_dantooine"}, {patrolPointName = "naboo_rebel_tier3_point_2", zoneName = "space_dantooine"}, {patrolPointName = "naboo_rebel_tier3_point_3", zoneName = "space_dantooine"}, {patrolPointName = "naboo_rebel_tier3_point_4", zoneName = "space_dantooine"}},
}
registerScreenPlay("assassinate_naboo_rebel_tier3_1", true)

escort_naboo_rebel_tier3_1_a = SpaceEscortScreenplay:new {
	className = "escort_naboo_rebel_tier3_1_a", questName = "naboo_rebel_tier3_1_a", questType = "escort", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "survival", sideQuestName = "naboo_rebel_tier3_1_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "assassinate_naboo_rebel_tier3_1", parentQuestType = "assassinate", parentQuestName = "naboo_rebel_tier3_1",
	escortShips = {"lambdashuttle_rebel_tier3_1_officer"}, escortSpeed = 60, orderedEscortRoute = true,
	escortPoints = {
		{patrolPointName = "naboo_rebel_tier3_point_1", zoneName = "space_dantooine", x = 4957, z = 3250, y = 4698, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_point_2", zoneName = "space_dantooine", x = 2568, z = 3857, y = 2000, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_point_3", zoneName = "space_dantooine", x = -15, z = 4452, y = -618, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_point_4", zoneName = "space_dantooine", x = -2585, z = 5075, y = -3250, escortNumber = 4, radius = 250},
	},
	attackDelay = 60, attackShips = {{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"}, {"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"}},
}
registerScreenPlay("escort_naboo_rebel_tier3_1_a", true)

survival_naboo_rebel_tier3_1_b = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_rebel_tier3_1_b", questName = "naboo_rebel_tier3_1_b", questType = "survival", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "naboo_rebel_tier3_1_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "escort_naboo_rebel_tier3_1_a", parentQuestType = "escort", parentQuestName = "naboo_rebel_tier3_1_a",
	survivalTime = 420, survivalUpdateInterval = 60, survivalPoint = "space_dantooine:naboo_rebel_tier3_survival_point", delayToFirstAttack = 5, attackDelay = 70,
	attackShips = {{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3"}, {"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"}, {"imp_tie_fighter_tier3", "imp_tie_bomber_tier3"}, {"imp_tie_interceptor_tier3", "imp_tie_bomber_tier3"}, {"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"}, {"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"}},
}
registerScreenPlay("survival_naboo_rebel_tier3_1_b", true)

inspect_naboo_rebel_tier3_1_c = SpaceInspectScreenplay:new {
	className = "inspect_naboo_rebel_tier3_1_c", questName = "naboo_rebel_tier3_1_c", questType = "inspect", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "delivery_no_pickup", sideQuestName = "naboo_rebel_tier3_1_d", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "survival_naboo_rebel_tier3_1_b", parentQuestType = "survival", parentQuestName = "naboo_rebel_tier3_1_b",
	inspectTargets = {"naboo_tier3_imperial_spy"}, inspectCargo = "naboo_rebel_tier3_1_c", targetLocation = {x = -3838, z = 5840, y = -3806}, spawnInspectTarget = true,
}
registerScreenPlay("inspect_naboo_rebel_tier3_1_c", true)

delivery_no_pickup_naboo_rebel_tier3_1_d = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_naboo_rebel_tier3_1_d", questName = "naboo_rebel_tier3_1_d", questType = "delivery_no_pickup", questZone = "space_dantooine", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "inspect_naboo_rebel_tier3_1_c", parentQuestType = "inspect", parentQuestName = "naboo_rebel_tier3_1_c",
	deliveryShip = "reb_freighterlight_tier3", deliveryPoint = "space_dantooine:naboo_rebel_tier3_delivery_point_1",
}
registerScreenPlay("delivery_no_pickup_naboo_rebel_tier3_1_d", true)

-- Mission 2: assist SpyNet, rescue Kt'lya, patrol Blacklight territory,
-- defeat the ambush, and inspect the survivors for the leader's location.
space_battle_naboo_rebel_tier3_2 = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier3_2", questName = "naboo_rebel_tier3_2", questType = "space_battle", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "rescue", sideQuestName = "naboo_rebel_tier3_2_a", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	battlePoint = "space_dantooine:naboo_rebel_tier3_battle_point", allyArrivalDelay = 15, enemyArrivalDelay = 25, allyOriginDist = -600, enemyOriginDist = 700, allyArrivalDist = -100, enemyArrivalDist = 100,
	alliedShips = {{"spynet_fighter_tier3"}, {"spynet_bomber_tier3"}, {"spynet_fighter_tier3"}},
	enemyShips = {{"blacklight_fighter_tier3"}, {"blacklight_fighter_tier3"}, {"blacklight_bomber_tier3"}, {"blacklight_assassin_tier3"}},
}
registerScreenPlay("space_battle_naboo_rebel_tier3_2", true)

rescue_naboo_rebel_tier3_2_a = SpaceRescueScreenplay:new {
	className = "rescue_naboo_rebel_tier3_2_a", questName = "naboo_rebel_tier3_2_a", questType = "rescue", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "patrol", sideQuestName = "naboo_rebel_tier3_2_b", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "space_battle_naboo_rebel_tier3_2", parentQuestType = "space_battle", parentQuestName = "naboo_rebel_tier3_2",
	rescueShip = "spynet_runner_tier3", rescueLocation = {x = -2257, z = -3938, y = -1441}, repairDelay = 20, escortSpeed = 60, orderedEscortRoute = true,
	escortPoints = {
		{patrolPointName = "naboo_rebel_tier3_rescue_1", zoneName = "space_dantooine", x = -2257, z = -3938, y = -1441, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_rescue_2", zoneName = "space_dantooine", x = -1722, z = -2498, y = 1940, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_rescue_3", zoneName = "space_dantooine", x = -996, z = -2105, y = 4791, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_rescue_4", zoneName = "space_dantooine", x = 378, z = -1904, y = 6544, escortNumber = 4, radius = 250},
	},
	attackDelay = 55, attackShips = {{"blacklight_fighter_tier3", "blacklight_bomber_tier3"}, {"blacklight_fighter_tier3", "blacklight_assassin_tier3"}},
}
registerScreenPlay("rescue_naboo_rebel_tier3_2_a", true)

patrol_naboo_rebel_tier3_2_b = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_tier3_2_b", questName = "naboo_rebel_tier3_2_b", questType = "patrol", questZone = "space_dantooine", creditReward = 0,
	sideQuest = true, sideQuestType = "destroy_surpriseattack", sideQuestName = "naboo_rebel_tier3_2_c", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "rescue_naboo_rebel_tier3_2_a", parentQuestType = "rescue", parentQuestName = "naboo_rebel_tier3_2_a",
	patrolPoints = {{patrolPointName = "naboo_rebel_tier3_patrol_1", patrolNumber = 1, radius = 150}, {patrolPointName = "naboo_rebel_tier3_patrol_2", patrolNumber = 2, radius = 150}, {patrolPointName = "naboo_rebel_tier3_patrol_3", patrolNumber = 3, radius = 150}, {patrolPointName = "naboo_rebel_tier3_patrol_4", patrolNumber = 4, radius = 150}},
}
registerScreenPlay("patrol_naboo_rebel_tier3_2_b", true)

destroy_surpriseattack_naboo_rebel_tier3_2_c = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_rebel_tier3_2_c", questName = "naboo_rebel_tier3_2_c", questType = "destroy_surpriseattack", questZone = "space_dantooine",
	sideQuest = true, sideQuestType = "inspect", sideQuestName = "naboo_rebel_tier3_2_d", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,
	parentQuest = "patrol_naboo_rebel_tier3_2_b", parentQuestType = "patrol", parentQuestName = "naboo_rebel_tier3_2_b",
	surpriseAttackShips = {zone = "space_dantooine", spawns = {{count = 4, shipName = "blacklight_assassin_tier3"}}},
}
registerScreenPlay("destroy_surpriseattack_naboo_rebel_tier3_2_c", true)

inspect_naboo_rebel_tier3_2_d = SpaceInspectScreenplay:new {
	className = "inspect_naboo_rebel_tier3_2_d", questName = "naboo_rebel_tier3_2_d", questType = "inspect", questZone = "space_dantooine", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "destroy_surpriseattack_naboo_rebel_tier3_2_c", parentQuestType = "destroy_surpriseattack", parentQuestName = "naboo_rebel_tier3_2_c",
	inspectTargets = {"blacklight_leader_tier3"}, inspectCargo = "naboo_rebel_tier3_2_d", targetLocation = {x = -711, z = -5678, y = 1064}, spawnInspectTarget = true,
}
registerScreenPlay("inspect_naboo_rebel_tier3_2_d", true)

-- Mission 3: locate the Blacklight base and eliminate its leader.
patrol_naboo_rebel_tier3_3 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_tier3_3",

	questName = "naboo_rebel_tier3_3",
	questType = "patrol",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_rebel_tier3_3_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	patrolPoints = {
		{patrolPointName = "naboo_rebel_tier3_patrol3_1", patrolNumber = 1, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_patrol3_2", patrolNumber = 2, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_patrol3_3", patrolNumber = 3, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_patrol3_4", patrolNumber = 4, radius = 150},
	},

	pickupShip = "nym_smuggler",
	deliveryShip = "reb_gunboat_tier3",

	pickupPoint = "space_endor:naboo_rebel_tier_3_3_pickup",
	deliveryPoint = "space_endor:naboo_rebel_tier_3_3_deliver",

	attackDelay = 80,

	attackShips = {
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"},
		{"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"},
	},
}

registerScreenPlay("patrol_naboo_rebel_tier3_3", true)

destroy_surpriseattack_naboo_rebel_tier3_3_a = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_rebel_tier3_3_a",

	questType = "destroy_surpriseattack",
	questName = "naboo_rebel_tier3_3_a",

	questZone = "space_endor",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_rebel_tier3_3_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "patrol_naboo_rebel_tier3_3",
	parentQuestType = "patrol",
	parentQuestName = "naboo_rebel_tier3_3",

	surpriseAttackShips = {zone = "space_endor", spawns = {{count = 4, shipName = "blacklight_assassin_tier3"}}},

	arrivalDelay = 20,
	failTimer = 20,

	assassinateSpawns = {
		target = "lambdashuttle_advanced_recon",
		escorts = {"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_1", zoneName = "space_endor", x = 2940, z = -4680, y = 1200},
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_2", zoneName = "space_endor", x = 2922, z = -3692, y = 1654},
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_3", zoneName = "space_endor", x = 2900, z = -2445, y = 2228},
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_4", zoneName = "space_endor", x = 2892, z = -1093, y = 2859},
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_5", zoneName = "space_endor", x = 2892, z = 55, y = 3394},
		{patrolPointName = "naboo_rebel_tier3_3_a_spyship_6", zoneName = "space_endor", x = 2892, z = 1122, y = 3890},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_rebel_tier3_3_a", true)

survival_naboo_rebel_tier3_3_b = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_rebel_tier3_3_b",

	questName = "naboo_rebel_tier3_3_b",
	questType = "survival",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_rebel_tier3_3_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "destroy_surpriseattack_naboo_rebel_tier3_3_a",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_rebel_tier3_3_a",

	survivalTime = 420, survivalUpdateInterval = 60, survivalPoint = "space_endor:naboo_rebel_tier3_blacklight_point", delayToFirstAttack = 5, attackDelay = 70,
	attackShips = {{"blacklight_fighter_tier3", "blacklight_bomber_tier3"}, {"blacklight_fighter_tier3", "blacklight_assassin_tier3"}, {"blacklight_bomber_tier3", "blacklight_fighter_tier3"}, {"blacklight_assassin_tier3", "blacklight_assassin_tier3"}, {"blacklight_fighter_tier3", "blacklight_bomber_tier3"}, {"blacklight_fighter_tier3", "blacklight_assassin_tier3"}},

	battlePoint = "space_endor:naboo_rebel_tier3_3_b_battlepoint",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 85,
	allyOriginDist = 500,
	enemyOriginDist = -750,
	allyArrivalDist = 50,
	enemyArrivalDist = -200,

	alliedShips = {
		{"reb_ywing_tier3"},
		{"reb_ywing_tier3"},
		{"reb_ywing_tier3"},
	},

	enemyShips = {
		{"imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3"},
		{"imp_tie_interceptor_tier3"},
		{"imp_tie_interceptor_tier3"},
		{"imp_tie_interceptor_tier3"},
	},
}

registerScreenPlay("survival_naboo_rebel_tier3_3_b", true)

patrol_naboo_rebel_tier3_3_c = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_tier3_3_c",

	questName = "naboo_rebel_tier3_3_c",
	questType = "patrol",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true, sideQuestType = "assassinate", sideQuestName = "naboo_rebel_tier3_3_d", sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, sideQuestDelay = 5,

	parentQuest = "survival_naboo_rebel_tier3_3_b",
	parentQuestType = "survival",
	parentQuestName = "naboo_rebel_tier3_3_b",

	patrolPoints = {{patrolPointName = "naboo_rebel_tier3_leader_patrol_1", patrolNumber = 1, radius = 150}, {patrolPointName = "naboo_rebel_tier3_leader_patrol_2", patrolNumber = 2, radius = 150}, {patrolPointName = "naboo_rebel_tier3_leader_patrol_3", patrolNumber = 3, radius = 150}, {patrolPointName = "naboo_rebel_tier3_leader_patrol_4", patrolNumber = 4, radius = 150}},

	escortShips = {"rebel_smuggler_tier3"},

	escortPoints = {
		{patrolPointName = "naboo_rebel_tier3_3_c_escort_1", zoneName = "space_endor", x = -5250, z = -850, y = 2000, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_3_c_escort_2", zoneName = "space_endor", x = -4323, z = -525, y = 2310, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_3_c_escort_3", zoneName = "space_endor", x = -3632, z = -680, y = 1552, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_3_c_escort_4", zoneName = "space_endor", x = -2813, z = -400, y = 1793, escortNumber = 4, radius = 250},
	},

	attackDelay = 55,

	attackShips = {
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"},
	},
}

registerScreenPlay("patrol_naboo_rebel_tier3_3_c", true)

assassinate_naboo_rebel_tier3_3_d = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_rebel_tier3_3_d", questName = "naboo_rebel_tier3_3_d", questType = "assassinate", questZone = "space_endor", creditReward = 0,
	sideQuest = false, sideQuestType = "", parentQuest = "patrol_naboo_rebel_tier3_3_c", parentQuestType = "patrol", parentQuestName = "naboo_rebel_tier3_3_c",
	arrivalDelay = 10, failTimer = 30, assassinateSpawns = {target = "blacklight_leader_tier3", escorts = {"blacklight_assassin_tier3", "blacklight_fighter_tier3", "blacklight_fighter_tier3"}},
	targetPatrols = {{patrolPointName = "naboo_rebel_tier3_assassin_path_1", zoneName = "space_endor"}, {patrolPointName = "naboo_rebel_tier3_assassin_path_2", zoneName = "space_endor"}, {patrolPointName = "naboo_rebel_tier3_assassin_path_3", zoneName = "space_endor"}, {patrolPointName = "naboo_rebel_tier3_assassin_path_4", zoneName = "space_endor"}},
}
registerScreenPlay("assassinate_naboo_rebel_tier3_3_d", true)

-- Mission 4: counter the Inquisition attack and capture its experimental fighter.
space_battle_naboo_rebel_tier3_4 = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier3_4",

	questType = "space_battle",
	questName = "naboo_rebel_tier3_4",

	questZone = "space_dathomir",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_rebel_tier3_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	battlePoint = "space_dathomir:naboo_rebel_tier3_rebel_vs_imperial", allyArrivalDelay = 15, enemyArrivalDelay = 25, allyOriginDist = -600, enemyOriginDist = 700, allyArrivalDist = -100, enemyArrivalDist = 100,
	alliedShips = {{"reb_ywing_tier3"}, {"reb_ywing_tier3"}, {"reb_xwing_tier3"}}, enemyShips = {{"imp_tie_fighter_tier3"}, {"imp_tie_interceptor_tier3"}, {"imp_tie_bomber_tier3"}, {"imp_tie_fighter_tier3"}},

	arrivalDelay = 15,
	failTimer = 20,

	assassinateSpawns = {
		target = "tieadvanced_quest_officer_rebel_t3",
		escorts = {"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_rebel_tier3_4_assassin_1", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier3_4_assassin_2", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier3_4_assassin_3", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier3_4_assassin_4", zoneName = "space_dathomir"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier3_4", true)

-- Mission 4 Side Quest A: Patrol (Space Dathomir - Search for lone Imperial ships)
patrol_naboo_rebel_tier3_4_a = SpacePatrolScreenplay:new {
	className = "patrol_naboo_rebel_tier3_4_a",

	questName = "naboo_rebel_tier3_4_a",
	questType = "patrol",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_rebel_tier3_4_b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 3,
	sideQuestDelay = 5,

	parentQuest = "space_battle_naboo_rebel_tier3_4",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_rebel_tier3_4",

	patrolPoints = {
		{patrolPointName = "naboo_rebel_tier3_4_a_patrol_1", x = -3960, z = -400, y = -4950, patrolNumber = 1, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_4_a_patrol_2", x = -3758, z = 345, y = -4588, patrolNumber = 2, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_4_a_patrol_3", x = -3460, z = 37, y = -3563, patrolNumber = 3, radius = 150},
		{patrolPointName = "naboo_rebel_tier3_4_a_patrol_4", x = -2777, z = 778, y = -3350, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_rebel_tier3_4_a", true)

survival_naboo_rebel_tier3_4_b = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_rebel_tier3_4_b",

	questName = "naboo_rebel_tier3_4_b",
	questType = "survival",

	questZone = "space_dathomir",

	sideQuest = true,
	sideQuestType = "recovery",
	sideQuestName = "naboo_rebel_tier3_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "patrol_naboo_rebel_tier3_4_a",
	parentQuestType = "patrol",
	parentQuestName = "naboo_rebel_tier3_4_a",
	survivalTime = 180, survivalUpdateInterval = 60, survivalPoint = {x = 609, z = -5349, y = -7366}, delayToFirstAttack = 5, attackDelay = 45,
	attackShips = {{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"}, {"imp_tie_bomber_tier3", "imp_tie_interceptor_tier3"}, {"imp_tie_fighter_tier3", "imp_tie_fighter_tier3"}},
}

registerScreenPlay("survival_naboo_rebel_tier3_4_b", true)

-- Mission 4 Side Quest C: Recovery (Space Dathomir - Capture the experimental fighter)
recovery_naboo_rebel_tier3_4_c = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_rebel_tier3_4_c",

	questName = "naboo_rebel_tier3_4_c",
	questType = "recovery",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "delivery",
	sideQuestName = "naboo_rebel_tier3_4_d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "survival_naboo_rebel_tier3_4_b",
	parentQuestType = "survival",
	parentQuestName = "naboo_rebel_tier3_4_b",
	arrivalDelay = 15, recoveryDelay = 30, escortSpeed = 60,
	recoverShip = "imp_tie_experimental_fighter_tier3",
	recoveryConversationMobile = "object/mobile/dressed_imperial_officer_m_1.iff",
	escortShips = {"imp_tie_interceptor_tier3", "imp_tie_interceptor_tier3"},
	preRecoveryPoints = {
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_1", zoneName = "space_dathomir", x = 3000, z = 1500, y = -3000, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_2", zoneName = "space_dathomir", x = 3500, z = 900, y = -3200, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_3", zoneName = "space_dathomir", x = 4000, z = 100, y = -3450, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_4", zoneName = "space_dathomir", x = 4500, z = -700, y = -3650, escortNumber = 4, radius = 250},
	},
	recoveryPoints = {
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_5", zoneName = "space_dathomir", x = 4807, z = -1349, y = -3781, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_6", zoneName = "space_dathomir", x = 2150, z = -3082, y = -1761, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_7", zoneName = "space_dathomir", x = 111, z = -4412, y = -211, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier3_recover_imperial_8", zoneName = "space_dathomir", x = -2691, z = -6240, y = 1919, escortNumber = 4, radius = 250},
	},
	attackDelay = 45,
	attackShips = {
		{"imp_tie_fighter_tier3", "imp_tie_bomber_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3"},
	},
}

registerScreenPlay("recovery_naboo_rebel_tier3_4_c", true)

-- Mission 4 Side Quest D: Survival (Space Endor - Guard fleet flank during hyperspace evacuation)
delivery_naboo_rebel_tier3_4_d = SpaceDeliveryScreenplay:new {
	className = "delivery_naboo_rebel_tier3_4_d",

	questName = "naboo_rebel_tier3_4_d",
	questType = "delivery",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "recovery_naboo_rebel_tier3_4_c",
	parentQuestType = "recovery",
	parentQuestName = "naboo_rebel_tier3_4_c",
	pickupShip = "reb_freighterheavy_tier3", deliveryShip = "reb_gunboat_tier3", pickupPoint = "space_dathomir:naboo_rebel_tier3_pickup", deliveryPoint = "space_dathomir:naboo_rebel_tier3_delivery",

	survivalTime = 300,
	survivalPoint = "space_endor:naboo_rebel_tier3_4_c_survival",
	delayToFirstAttack = 5,

	attackDelay = 60,

	attackShips = {
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3", "imp_tie_bomber_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3", "imp_tie_bomber_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_interceptor_tier3", "imp_tie_bomber_tier3"},
	},
}

registerScreenPlay("delivery_naboo_rebel_tier3_4_d", true)

--[[
	Tier 4 -- naboo_rebel_tier4 Main Missions
]]

-- Mission 1: Survival (Space Dathomir - Hold off Black Sun assault on Nym miners)
survival_naboo_rebel_tier4_1 = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_rebel_tier4_1",

	questName = "naboo_rebel_tier4_1",
	questType = "survival",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_rebel_tier4_1_a",
	sideQuestType2 = "space_battle",
	sideQuestName2 = "naboo_rebel_tier4_1_b",

	-- sideQuestSplitType = "both",

	survivalTime = 300,
	survivalPoint = "space_dathomir:naboo_rebel_tier4_1_survival_point",
	delayToFirstAttack = 5,

	attackDelay = 60,

	attackShips = {
		{"blacksun_fighter_s03_tier4", "blacksun_bomber_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4"},
		{"blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4"},
		{"blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4"},
		{"blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4"},
	},
}

registerScreenPlay("survival_naboo_rebel_tier4_1", true)

-- Mission 1 Side Quest A: Space Battle (Space Dathomir - Counter attack against Black Sun)
space_battle_naboo_rebel_tier4_1_a = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier4_1_a",

	questName = "naboo_rebel_tier4_1_a",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "survival_naboo_rebel_tier4_1",
	parentQuestType = "survival",
	parentQuestName = "naboo_rebel_tier4_1",

	battlePoint = "space_dathomir:naboo_rebel_tier4_1_a_battle_point",
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
		{"reb_xwing_tier4"},
		{"reb_xwing_tier4"},
	},

	enemyShips = {
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s03_tier4"},
		{"blacksun_fighter_s03_tier4"},
		{"blacksun_fighter_s03_tier4"},
		{"blacksun_marauder_tier4"},
		{"blacksun_vehement_tier4"},
		{"blacksun_marauder_tier4"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier4_1_a", true)

-- Mission 1 Side Quest B: Space Battle (Space Dathomir - Save Nym freighters from Black Sun)
space_battle_naboo_rebel_tier4_1_b = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier4_1_b",

	questName = "naboo_rebel_tier4_1_b",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "survival_naboo_rebel_tier4_1",
	parentQuestType = "survival",
	parentQuestName = "naboo_rebel_tier4_1",

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
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4"},
		{"blacksun_gunship_tier4"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier4_1_b", true)

-- Mission 2: Assassinate (Space Dathomir - Terminate Imperial Inquisitor before he reaches the fleet)
assassinate_naboo_rebel_tier4_2 = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_rebel_tier4_2",

	questType = "assassinate",
	questName = "naboo_rebel_tier4_2",

	questZone = "space_dathomir",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "naboo_rebel_tier4_2_a",
	sideQuestType2 = "rescue",
	sideQuestName2 = "naboo_rebel_tier4_2_b",

	-- sideQuestSplitType = "both",

	arrivalDelay = 5,
	failTimer = 20,

	assassinateSpawns = {
		target = "tieadvanced_inquisitor_tier4",
		escorts = {"tieinterceptor_inquisitor_guard", "tieinterceptor_inquisitor_guard", "tieinterceptor_inquisitor_guard", "tieinterceptor_inquisitor_guard", "tieinterceptor_inquisitor_guard", "tieinterceptor_inquisitor_guard"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_rebel_tier4_2_assassin_1", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier4_2_assassin_2", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier4_2_assassin_3", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier4_2_assassin_4", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier4_2_assassin_5", zoneName = "space_dathomir"},
		{patrolPointName = "naboo_rebel_tier4_2_assassin_6", zoneName = "space_dathomir"},
	},
}

registerScreenPlay("assassinate_naboo_rebel_tier4_2", true)

-- Mission 2 Side Quest A: Delivery No Pickup (Space Dathomir - Deliver Inquisitor wreck data)
delivery_no_pickup_naboo_rebel_tier4_2_a = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_naboo_rebel_tier4_2_a",

	questName = "naboo_rebel_tier4_2_a",
	questType = "delivery_no_pickup",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_naboo_rebel_tier4_2",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_rebel_tier4_2",

	deliveryShip = "rebel_smuggler_tier3",
	deliveryPoint = "space_dathomir:naboo_rebel_tier4_2_a_delivery",

	attackDelay = 45,

	attackShips = {
		{"imp_tie_interceptor_tier4", "imp_tie_advanced_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_naboo_rebel_tier4_2_a", true)

-- Mission 2 Side Quest B: Rescue (Space Dathomir - Rescue Rebel diplomat ambushed by Imperials)
rescue_naboo_rebel_tier4_2_b = SpaceRescueScreenplay:new {
	className = "rescue_naboo_rebel_tier4_2_b",

	questName = "naboo_rebel_tier4_2_b",
	questType = "rescue",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_naboo_rebel_tier4_2",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_rebel_tier4_2",

	rescueShip = "reb_diplomat_tier4",
	rescueArrivalDelay = 3,

	escortPoints = {
		{patrolPointName = "naboo_rebel_tier4_2_b_rescue_1", zoneName = "space_dathomir", x = 3872, z = 4158, y = -2791, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_2_b_rescue_2", zoneName = "space_dathomir", x = 2827, z = 3579, y = -4145, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_2_b_rescue_3", zoneName = "space_dathomir", x = 2103, z = 3204, y = -5079, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_2_b_rescue_4", zoneName = "space_dathomir", x = 1424, z = 2853, y = -5956, escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_bomber_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier3"},
		{"imp_tie_fighter_tier3", "imp_tie_fighter_tier3", "imp_tie_fighter_tier3"},
	},
}

registerScreenPlay("rescue_naboo_rebel_tier4_2_b", true)

-- Mission 3: Space Battle (Space Dathomir - Guerilla strike on Imperial space station)
space_battle_naboo_rebel_tier4_3 = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier4_3",

	questName = "naboo_rebel_tier4_3",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_rebel_tier4_3_a",
	sideQuestType2 = "survival",
	sideQuestName2 = "naboo_rebel_tier4_3_b",

	-- sideQuestSplitType = "both",

	battlePoint = "space_dathomir:naboo_rebel_tier4_3_battle_point",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 30,
	allyOriginDist = 600,
	enemyOriginDist = -1100,
	allyArrivalDist = 50,
	enemyArrivalDist = -200,

	alliedShips = {
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
		{"nym_enforcer_tier5"},
	},

	enemyShips = {
		{"imp_imperial_gunboat_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier4_3", true)

-- Mission 3 Side Quest A: Space Battle (Space Dathomir - Help ambushed B-Wing squadrons)
space_battle_naboo_rebel_tier4_3_a = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier4_3_a",

	questName = "naboo_rebel_tier4_3_a",
	questType = "space_battle",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_naboo_rebel_tier4_3",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_rebel_tier4_3",

	battlePoint = "space_dathomir:naboo_rebel_tier4_3_a_battle_point",
	allyArrivalDelay = 30,
	enemyArrivalDelay = 45,
	allyOriginDist = 600,
	enemyOriginDist = -700,
	allyArrivalDist = 50,
	enemyArrivalDist = -150,

	alliedShips = {
		{"reb_bwing_tier4"},
		{"reb_bwing_tier4"},
		{"reb_bwing_tier4"},
	},

	enemyShips = {
		{"imp_tie_aggressor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier4_3_a", true)

-- Mission 3 Side Quest B: Survival (Space Dathomir - Defend Rebel bombers retreat after failed station attack)
survival_naboo_rebel_tier4_3_b = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_rebel_tier4_3_b",

	questName = "naboo_rebel_tier4_3_b",
	questType = "survival",

	questZone = "space_dathomir",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_naboo_rebel_tier4_3",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_rebel_tier4_3",

	survivalTime = 480,
	survivalPoint = "space_dathomir:naboo_rebel_tier4_3_b_survival",
	delayToFirstAttack = 5,

	attackDelay = 45,

	attackShips = {
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_advanced_tier4", "imp_tie_aggressor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
	},
}

registerScreenPlay("survival_naboo_rebel_tier4_3_b", true)

-- Mission 4: Recovery (Space Dantooine - Kidnap Imperial technician building space station)
recovery_naboo_rebel_tier4_4 = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_rebel_tier4_4",

	questName = "naboo_rebel_tier4_4",
	questType = "recovery",

	questZone = "space_dantooine",

	creditReward = 0,

	sideQuest = true,
	-- The leg parentQuest chain is strictly serial here: _b's parent is this head,
	-- _a's parent is _b, and _c's parent is _a. So this head hands off to _b, and
	-- _b already COMPLETION-splits onto _a. The head previously pointed at _a with
	-- no split type at all (default NONE), so no leg ever started.
	sideQuestType = "rescue",
	sideQuestName = "naboo_rebel_tier4_4_b",

	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	arrivalDelay = 10,
	recoveryDelay = 30,

	recoverShip = "imp_lambda_shuttle_tier4",
	recoveryConversationMobile = "object/mobile/dressed_rebel_commando_moncal_male_01.iff",

	escortShips = {"imp_tie_aggressor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_rebel_tier4_4_recovery_1", zoneName = "space_dantooine", x = -4000, z = 3100, y = 2700, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_2", zoneName = "space_dantooine", x = -4400, z = 4410, y = 3481, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_3", zoneName = "space_dantooine", x = -4742, z = 5529, y = 4148, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_4", zoneName = "space_dantooine", x = -5049, z = 6532, y = 4746, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_rebel_tier4_4_recovery_5", zoneName = "space_dantooine", x = -5330, z = 5655, y = 5488, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_6", zoneName = "space_dantooine", x = -5758, z = 5051, y = 6420, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_7", zoneName = "space_dantooine", x = -6046, z = 4645, y = 7048, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_recovery_8", zoneName = "space_dantooine", x = -7031, z = 4120, y = 6583, escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"imp_tie_advanced_tier4", "imp_tie_aggressor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_oppressor_tier4"},
	},
}

registerScreenPlay("recovery_naboo_rebel_tier4_4", true)

-- Mission 4 Side Quest A: Assassinate (Space Endor - Destroy Imperial freighters carrying station materials)
assassinate_naboo_rebel_tier4_4_a = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_rebel_tier4_4_a",

	questType = "assassinate",
	questName = "naboo_rebel_tier4_4_a",

	questZone = "space_endor",

	creditReward = 0,
	itemReward = {},

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_rebel_tier4_4_c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "rescue_naboo_rebel_tier4_4_b",
	parentQuestType = "rescue",
	parentQuestName = "naboo_rebel_tier4_4_b",

	arrivalDelay = 10,
	failTimer = 20,

	assassinateSpawns = {
		target = "imp_freighterheavy_tier4",
		escorts = {"imp_tie_aggressor_tier4", "imp_tie_aggressor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_oppressor_tier4", "imp_tie_aggressor_tier4", "freighterlight_naboo_rebel_mission", "freightermedium_naboo_rebel_mission"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_1", zoneName = "space_endor", x = 19, z = 5591, y = 1371},
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_2", zoneName = "space_endor", x = 552, z = 5543, y = -5},
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_3", zoneName = "space_endor", x = 2059, z = 5543, y = -1021},
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_4", zoneName = "space_endor", x = 2632, z = 5518, y = -2724},
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_5", zoneName = "space_endor", x = 4049, z = 5491, y = -4471},
		{patrolPointName = "naboo_rebel_tier4_4_a_assassinate_6", zoneName = "space_endor", x = 7162, z = 5467, y = -4481},
	},
}

registerScreenPlay("assassinate_naboo_rebel_tier4_4_a", true)

-- Mission 4 Side Quest B: Rescue (Space Endor - Escort SpyNet operative to safety for freighter route intel)
rescue_naboo_rebel_tier4_4_b = SpaceRescueScreenplay:new {
	className = "rescue_naboo_rebel_tier4_4_b",

	questName = "naboo_rebel_tier4_4_b",
	questType = "rescue",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_rebel_tier4_4_a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	sideQuestDelay = 0,

	parentQuest = "recovery_naboo_rebel_tier4_4",
	parentQuestType = "recovery",
	parentQuestName = "naboo_rebel_tier4_4",

	rescueShip = "spynet_spy_tier4",
	rescueArrivalDelay = 5,

	escortPoints = {
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_1", zoneName = "space_endor", x = -961, z = -5548, y = 513, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_2", zoneName = "space_endor", x = -1637, z = -5535, y = 354, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_3", zoneName = "space_endor", x = -2330, z = -5523, y = 191, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_4", zoneName = "space_endor", x = -3110, z = -5509, y = 7, escortNumber = 4, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_5", zoneName = "space_endor", x = -3915, z = -5494, y = -182, escortNumber = 5, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_4_b_rescue_6", zoneName = "space_endor", x = -4794, z = -5884, y = -52, escortNumber = 6, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"imp_tie_advanced_tier4", "imp_tie_aggressor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier4", "imp_tie_oppressor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
	},
}

registerScreenPlay("rescue_naboo_rebel_tier4_4_b", true)

-- Mission 4 Side Quest C: Space Battle (Space Endor - Imperial retaliation for freighter attack)
space_battle_naboo_rebel_tier4_4_c = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_rebel_tier4_4_c",

	questName = "naboo_rebel_tier4_4_c",
	questType = "space_battle",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_naboo_rebel_tier4_4_a",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_rebel_tier4_4_a",

	battlePoint = "space_endor:naboo_rebel_tier4_4_c_battle_point",
	allyArrivalDelay = 60,
	enemyArrivalDelay = 85,
	allyOriginDist = 800,
	enemyOriginDist = -850,
	allyArrivalDist = 150,
	enemyArrivalDist = -200,

	alliedShips = {
		{"reb_xwing_tier4"},
		{"reb_xwing_tier4"},
		{"reb_bwing_tier4"},
		{"nym_fighter_tier4"},
		{"nym_fighter_tier4"},
	},

	enemyShips = {
		{"imp_decimator_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_interceptor_tier4"},
		{"imp_tie_oppressor_tier4"},
		{"imp_tie_advanced_tier4"},
	},
}

registerScreenPlay("space_battle_naboo_rebel_tier4_4_c", true)

-- Master Mission (two-stage Kessel encounter): destroy_master_rebel_1 (Kessel: destroy
-- 30 Imperial fighters) and destroy_master_rebel_2 (Kessel: destroy the Imperial
-- Corellian Corvette / Star Ravager command vessel) are defined in
-- screenplays/space/squadrons/KesselMasterEncounterScreenplay.lua (loaded first).

-- Tier 4 Duty Missions

-- Escort Duty (Space Dathomir - Escort Nym freighters carrying loot from Imperial outpost raid)
escort_duty_naboo_rebel_tier4_1 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_rebel_tier4_1",

	questName = "naboo_rebel_tier4_1",
	questType = "escort_duty",

	questZone = "space_dathomir",

	creditReward = 5000,
	creditKillBonus = 300,

	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	escortShips = {"nym_freighterheavy_tier4", "nym_freighterlight_tier4", "nym_freightermedium_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_rebel_tier4_1_escort_duty_1", zoneName = "space_dathomir", escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_escort_duty_2", zoneName = "space_dathomir", escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_escort_duty_3", zoneName = "space_dathomir", escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_escort_duty_4", zoneName = "space_dathomir", escortNumber = 4, radius = 250},
	},

	attackDelay = 50,

	attackShips = {
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_bomber_tier4", "imp_tie_advanced_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_interceptor_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_interceptor_tier4"},
	},
}

registerScreenPlay("escort_duty_naboo_rebel_tier4_1", true)

-- Rescue Duty (Space Dantooine - Rescue disabled Rebel ships left after Imperial attack)
rescue_duty_naboo_rebel_tier4_1 = SpaceDutyRescueScreenplay:new {
	className = "rescue_duty_naboo_rebel_tier4_1",

	questName = "naboo_rebel_tier4_1",
	questType = "rescue_duty",

	questZone = "space_dantooine",

	creditReward = 5000,
	creditKillBonus = 300,

	sideQuest = false,
	sideQuestType = "",

	targetShips = {"reb_xwing_tier4", "reb_transport_tier4", "reb_ywing_tier4", "reb_ykl37r_tier4", "reb_freightermedium_tier4", "reb_freighterheavy_tier4", "reb_freighterlight_tier4"},

	targetArrivalDelay = 3,

	recoveryPoints = {
		{patrolPointName = "naboo_rebel_tier4_1_rescue_duty_1", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_rescue_duty_2", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_rescue_duty_3", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_rescue_duty_4", zoneName = "space_dantooine", radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_rescue_duty_5", zoneName = "space_dantooine", radius = 250},
	},

	attackDelay = 60,

	attackShips = {
		{"imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier4", "imp_lambda_shuttle_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_advanced_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_advanced_tier4"},
	},
}

registerScreenPlay("rescue_duty_naboo_rebel_tier4_1", true)

-- Recovery Duty (Space Endor - Nym pirates infiltrate Imperial troop transports)
recovery_duty_naboo_rebel_tier4_1 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_naboo_rebel_tier4_1",

	questName = "naboo_rebel_tier4_1",
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

	escortShips = {"imp_tie_interceptor_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_1", zoneName = "space_endor", escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_2", zoneName = "space_endor", escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_3", zoneName = "space_endor", escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_4", zoneName = "space_endor", escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_5", zoneName = "space_endor", escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_6", zoneName = "space_endor", escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_7", zoneName = "space_endor", escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier4_1_recovery_duty_8", zoneName = "space_endor", escortNumber = 4, radius = 250},
	},

	attackDelay = 45,

	attackShips = {
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_bomber_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_fighter_tier4"},
		{"imp_tie_fighter_tier4", "imp_tie_interceptor_tier4", "imp_tie_fighter_tier4", "imp_tie_advanced_tier4"},
	},
}

registerScreenPlay("recovery_duty_naboo_rebel_tier4_1", true)

-- Destroy Duty (Space Dantooine - Nym/Rebel alliance putting the squeeze on the Black Sun)
destroy_duty_naboo_rebel_tier4_1 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_rebel_tier4_1",

	questName = "naboo_rebel_tier4_1",
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

registerScreenPlay("destroy_duty_naboo_rebel_tier4_1", true)

--[[

	VortexSquadronScreenplay

]]

VortexSquadronScreenplay = ScreenPlay:new {
	screenplayName = "VortexSquadronScreenplay",

	-- Tier 1 (Lt. Barn Sinkko)
	QUEST_STRING_1 = {type = "patrol", name = "naboo_rebel_1"},
	QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "naboo_rebel_1"},
	QUEST_STRING_2 = {type = "destroy", name = "naboo_rebel_2"},
	QUEST_STRING_3 = {type = "patrol", name = "naboo_rebel_3"},
	QUEST_STRING_3_SIDE = {type = "escort", name = "naboo_rebel_3"},
	QUEST_STRING_4 = {type = "assassinate", name = "naboo_rebel_4"},
	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_rebel_6"},
	QUEST_STRING_DUTY_2 = {type = "escort_duty", name = "naboo_rebel_7"},

	-- Tier 2
	TIER2_QUEST_STRING_1 = {type = "destroy_surpriseattack", name = "vortex_mission_1"},
	TIER2_QUEST_STRING_2 = {type = "escort", name = "vortex_mission_2"},
	TIER2_QUEST_STRING_3 = {type = "recovery", name = "vortex_mission_3"},
	TIER2_QUEST_STRING_4 = {type = "inspect", name = "vortex_mission_4"},
	TIER2_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_rebel_tier2_destroyduty"},
	TIER2_QUEST_STRING_DUTY_2 = {type = "recovery_duty", name = "naboo_rebel_tier2_recoveryduty"},
	TIER2_QUEST_STRING_DUTY_3 = {type = "escort_duty", name = "naboo_rebel_tier2_escortduty"},

	-- Tier 3
	TIER3_QUEST_STRING_1 = {type = "assassinate", name = "naboo_rebel_tier3_1"},
	TIER3_QUEST_STRING_1_SIDE1 = {type = "escort", name = "naboo_rebel_tier3_1_a"},
	TIER3_QUEST_STRING_1_SIDE2 = {type = "survival", name = "naboo_rebel_tier3_1_b"},
	TIER3_QUEST_STRING_1_SIDE3 = {type = "inspect", name = "naboo_rebel_tier3_1_c"},
	TIER3_QUEST_STRING_1_SIDE4 = {type = "delivery_no_pickup", name = "naboo_rebel_tier3_1_d"},
	TIER3_QUEST_STRING_2 = {type = "space_battle", name = "naboo_rebel_tier3_2"},
	TIER3_QUEST_STRING_2_SIDE1 = {type = "rescue", name = "naboo_rebel_tier3_2_a"},
	TIER3_QUEST_STRING_2_SIDE2 = {type = "patrol", name = "naboo_rebel_tier3_2_b"},
	TIER3_QUEST_STRING_2_SIDE3 = {type = "destroy_surpriseattack", name = "naboo_rebel_tier3_2_c"},
	TIER3_QUEST_STRING_2_SIDE4 = {type = "inspect", name = "naboo_rebel_tier3_2_d"},
	TIER3_QUEST_STRING_3 = {type = "patrol", name = "naboo_rebel_tier3_3"},
	TIER3_QUEST_STRING_3_SIDE1 = {type = "destroy_surpriseattack", name = "naboo_rebel_tier3_3_a"},
	TIER3_QUEST_STRING_3_SIDE2 = {type = "survival", name = "naboo_rebel_tier3_3_b"},
	TIER3_QUEST_STRING_3_SIDE3 = {type = "patrol", name = "naboo_rebel_tier3_3_c"},
	TIER3_QUEST_STRING_3_SIDE4 = {type = "assassinate", name = "naboo_rebel_tier3_3_d"},
	TIER3_QUEST_STRING_4 = {type = "space_battle", name = "naboo_rebel_tier3_4"},
	TIER3_QUEST_STRING_4_SIDE1 = {type = "patrol", name = "naboo_rebel_tier3_4_a"},
	TIER3_QUEST_STRING_4_SIDE2 = {type = "survival", name = "naboo_rebel_tier3_4_b"},
	TIER3_QUEST_STRING_4_SIDE3 = {type = "recovery", name = "naboo_rebel_tier3_4_c"},
	TIER3_QUEST_STRING_4_SIDE4 = {type = "delivery", name = "naboo_rebel_tier3_4_d"},

	-- Tier 4
	TIER4_QUEST_STRING_1 = {type = "survival", name = "naboo_rebel_tier4_1"},
	TIER4_QUEST_STRING_1_SIDE1 = {type = "space_battle", name = "naboo_rebel_tier4_1_a"},
	TIER4_QUEST_STRING_1_SIDE2 = {type = "space_battle", name = "naboo_rebel_tier4_1_b"},
	TIER4_QUEST_STRING_2 = {type = "assassinate", name = "naboo_rebel_tier4_2"},
	TIER4_QUEST_STRING_2_SIDE1 = {type = "delivery_no_pickup", name = "naboo_rebel_tier4_2_a"},
	TIER4_QUEST_STRING_2_SIDE2 = {type = "rescue", name = "naboo_rebel_tier4_2_b"},
	TIER4_QUEST_STRING_3 = {type = "space_battle", name = "naboo_rebel_tier4_3"},
	TIER4_QUEST_STRING_3_SIDE1 = {type = "space_battle", name = "naboo_rebel_tier4_3_a"},
	TIER4_QUEST_STRING_3_SIDE2 = {type = "survival", name = "naboo_rebel_tier4_3_b"},
	TIER4_QUEST_STRING_4 = {type = "recovery", name = "naboo_rebel_tier4_4"},
	TIER4_QUEST_STRING_4_SIDE1 = {type = "assassinate", name = "naboo_rebel_tier4_4_a"},
	TIER4_QUEST_STRING_4_SIDE2 = {type = "rescue", name = "naboo_rebel_tier4_4_b"},
	TIER4_QUEST_STRING_4_SIDE3 = {type = "space_battle", name = "naboo_rebel_tier4_4_c"},
	TIER4_QUEST_STRING_MASTER = {type = "destroy", name = "master_rebel_1"},
	TIER4_QUEST_STRING_MASTER_2 = {type = "destroy", name = "master_rebel_2"},
	TIER4_QUEST_STRING_DUTY_1 = {type = "escort_duty", name = "naboo_rebel_tier4_1"},
	TIER4_QUEST_STRING_DUTY_2 = {type = "rescue_duty", name = "naboo_rebel_tier4_1"},
	TIER4_QUEST_STRING_DUTY_3 = {type = "recovery_duty", name = "naboo_rebel_tier4_1"},
	TIER4_QUEST_STRING_DUTY_4 = {type = "destroy_duty", name = "naboo_rebel_tier4_1"},
}

registerScreenPlay("VortexSquadronScreenplay", false)

function VortexSquadronScreenplay:start()
end

function VortexSquadronScreenplay:prepareMissionChainAttempt(pPlayer, missionScreenplays, missionQuests)
	if (pPlayer == nil) then
		return
	end

	for i = #missionScreenplays, 1, -1 do
		missionScreenplays[i]:resetQuest(pPlayer)
	end

	for i = 1, #missionQuests do
		SpaceHelpers:clearSpaceQuest(pPlayer, missionQuests[i].type, missionQuests[i].name, false)
	end
end

-- Reset functions for quest clearing

function VortexSquadronScreenplay:resetV3fxQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	patrol_naboo_rebel_1:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_rebel_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1.type, self.QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1_SIDE.type, self.QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	destroy_naboo_rebel_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_2.type, self.QUEST_STRING_2.name, false)

	-- Mission 3
	patrol_naboo_rebel_3:resetQuest(pPlayer)
	escort_naboo_rebel_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3.type, self.QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3_SIDE.type, self.QUEST_STRING_3_SIDE.name, false)

	-- Mission 4
	assassinate_naboo_rebel_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_4.type, self.QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "VortexSquadronScreenplay:v3fx_finished")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":reward")
end

function VortexSquadronScreenplay:resetTier2Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Remove journal entries and observers left by the former placeholder chain.
	clearLegacyVortexTier2Quest(pPlayer, "inspect", "naboo_rebel_tier2_1", "inspect_naboo_rebel_tier2_1")
	clearLegacyVortexTier2Quest(pPlayer, "destroy_surpriseattack", "naboo_rebel_tier2_1", "destroy_surpriseattack_naboo_rebel_tier2_1")
	clearLegacyVortexTier2Quest(pPlayer, "escort", "naboo_rebel_tier2_2", "escort_naboo_rebel_tier2_2")
	clearLegacyVortexTier2Quest(pPlayer, "recovery", "naboo_rebel_tier2_3", "recovery_naboo_rebel_tier2_3")
	clearLegacyVortexTier2Quest(pPlayer, "assassinate", "naboo_rebel_tier2_4", "assassinate_naboo_rebel_tier2_4")

	-- Mission 1
	escort_vortex_mission_1:resetQuest(pPlayer)
	inspect_vortex_mission_1:resetQuest(pPlayer)
	destroy_surpriseattack_vortex_mission_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1.type, self.TIER2_QUEST_STRING_1.name, false)

	-- Mission 2
	escort_vortex_mission_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_2.type, self.TIER2_QUEST_STRING_2.name, false)

	-- Mission 3
	recovery_vortex_mission_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_3.type, self.TIER2_QUEST_STRING_3.name, false)

	-- Mission 4
	inspect_vortex_mission_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_4.type, self.TIER2_QUEST_STRING_4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":introduced")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward")
	removeQuestStatus(playerID .. "VortexSquadron:tier2Smuggler")
end

function VortexSquadronScreenplay:resetTier3Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	assassinate_naboo_rebel_tier3_1:resetQuest(pPlayer)
	escort_naboo_rebel_tier3_1_a:resetQuest(pPlayer)
	survival_naboo_rebel_tier3_1_b:resetQuest(pPlayer)
	inspect_naboo_rebel_tier3_1_c:resetQuest(pPlayer)
	delivery_no_pickup_naboo_rebel_tier3_1_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1.type, self.TIER3_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE1.type, self.TIER3_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE2.type, self.TIER3_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE3.type, self.TIER3_QUEST_STRING_1_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE4.type, self.TIER3_QUEST_STRING_1_SIDE4.name, false)

	-- Mission 2
	space_battle_naboo_rebel_tier3_2:resetQuest(pPlayer)
	rescue_naboo_rebel_tier3_2_a:resetQuest(pPlayer)
	patrol_naboo_rebel_tier3_2_b:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_rebel_tier3_2_c:resetQuest(pPlayer)
	inspect_naboo_rebel_tier3_2_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2.type, self.TIER3_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE1.type, self.TIER3_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE2.type, self.TIER3_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE3.type, self.TIER3_QUEST_STRING_2_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE4.type, self.TIER3_QUEST_STRING_2_SIDE4.name, false)

	-- Mission 3
	patrol_naboo_rebel_tier3_3:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_rebel_tier3_3_a:resetQuest(pPlayer)
	survival_naboo_rebel_tier3_3_b:resetQuest(pPlayer)
	patrol_naboo_rebel_tier3_3_c:resetQuest(pPlayer)
	assassinate_naboo_rebel_tier3_3_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3.type, self.TIER3_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE1.type, self.TIER3_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE2.type, self.TIER3_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE3.type, self.TIER3_QUEST_STRING_3_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE4.type, self.TIER3_QUEST_STRING_3_SIDE4.name, false)

	-- Mission 4
	space_battle_naboo_rebel_tier3_4:resetQuest(pPlayer)
	patrol_naboo_rebel_tier3_4_a:resetQuest(pPlayer)
	survival_naboo_rebel_tier3_4_b:resetQuest(pPlayer)
	recovery_naboo_rebel_tier3_4_c:resetQuest(pPlayer)
	delivery_naboo_rebel_tier3_4_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4.type, self.TIER3_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE1.type, self.TIER3_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE2.type, self.TIER3_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE3.type, self.TIER3_QUEST_STRING_4_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE4.type, self.TIER3_QUEST_STRING_4_SIDE4.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward")
end

function VortexSquadronScreenplay:resetTier4Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Mission 1
	survival_naboo_rebel_tier4_1:resetQuest(pPlayer)
	space_battle_naboo_rebel_tier4_1_a:resetQuest(pPlayer)
	space_battle_naboo_rebel_tier4_1_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1.type, self.TIER4_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE1.type, self.TIER4_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE2.type, self.TIER4_QUEST_STRING_1_SIDE2.name, false)

	-- Mission 2
	assassinate_naboo_rebel_tier4_2:resetQuest(pPlayer)
	delivery_no_pickup_naboo_rebel_tier4_2_a:resetQuest(pPlayer)
	rescue_naboo_rebel_tier4_2_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2.type, self.TIER4_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE1.type, self.TIER4_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE2.type, self.TIER4_QUEST_STRING_2_SIDE2.name, false)

	-- Mission 3
	space_battle_naboo_rebel_tier4_3:resetQuest(pPlayer)
	space_battle_naboo_rebel_tier4_3_a:resetQuest(pPlayer)
	survival_naboo_rebel_tier4_3_b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3.type, self.TIER4_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE1.type, self.TIER4_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE2.type, self.TIER4_QUEST_STRING_3_SIDE2.name, false)

	-- Mission 4
	recovery_naboo_rebel_tier4_4:resetQuest(pPlayer)
	assassinate_naboo_rebel_tier4_4_a:resetQuest(pPlayer)
	rescue_naboo_rebel_tier4_4_b:resetQuest(pPlayer)
	space_battle_naboo_rebel_tier4_4_c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4.type, self.TIER4_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE1.type, self.TIER4_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2.type, self.TIER4_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE3.type, self.TIER4_QUEST_STRING_4_SIDE3.name, false)

	-- Master (two-stage Kessel corvette encounter)
	destroy_master_rebel_1:resetQuest(pPlayer)
	destroy_master_rebel_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER.type, self.TIER4_QUEST_STRING_MASTER.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_MASTER_2.type, self.TIER4_QUEST_STRING_MASTER_2.name, false)

	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. "VortexSquadronScreenplay:StartedTier4")

	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. VortexSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward")
end

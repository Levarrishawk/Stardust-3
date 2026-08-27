local Logger = require("utils.logger")

--[[

	RSF Squadron Missions

]]

--[[
	Tier 1 -- Dinge Main Missions
]]

-- Mission 1: Patrol

patrol_naboo_privateer_1 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_privateer_1",

	questName = "naboo_privateer_1",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_1",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	-- Screenplay Specific Variables
	patrolPoints = {
		{patrolPointName = "rsf_privateer_patrol_1", x = 752, z = 659, y = -2444, patrolNumber = 1, radius = 150},
		{patrolPointName = "rsf_privateer_patrol_2", x = 2031, z = 887, y = -1759, patrolNumber = 2, radius = 150},
		{patrolPointName = "rsf_privateer_patrol_3", x = 2466, z = 854, y = -505, patrolNumber = 3, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_privateer_1", true)

destroy_surpriseattack_naboo_privateer_1 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_1",

	questName = "naboo_privateer_1",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_privateer_1",
	parentQuestType = "patrol",
	parentQuestName = "naboo_privateer_1",

	-- Screenplay Specific Variables
	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 1, shipName = "blacksun_fighter_s02_tier1"}, {count = 3, shipName = "blacksun_fighter_s01_tier1"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_1", true)

-- Mission 2: Destroy

destroy_naboo_privateer_2 = SpaceDestroyScreenplay:new {
	className = "destroy_naboo_privateer_2",

	questName = "naboo_privateer_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 200,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "rsf_privateer_patrol_1", x = 752, z = 659, y = -2444},
		{patrolPointName = "rsf_privateer_patrol_2", x = 2031, z = 887, y = -1759},
		{patrolPointName = "rsf_privateer_patrol_3", x = 2466, z = 854, y = -505},
	},

	shipTypes = {
		"blacksun_ace_s04_tier1", "blacksun_ace_s04_tier2", "blacksun_aggressor_tier1", "blacksun_aggressor_tier2",
		"blacksun_bomber_s01_tier1", "blacksun_bomber_s01_tier2", "blacksun_bomber_s02_tier1", "blacksun_bomber_s02_tier2",
		"blacksun_fighter_s01_tier1", "blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier1", "blacksun_fighter_s02_tier2",
		"blacksun_fighter_s03_tier1", "blacksun_fighter_s03_tier2", "blacksun_gunship_tier1", "blacksun_gunship_tier2",
	},
}

registerScreenPlay("destroy_naboo_privateer_2", true)

-- Mission 3: Patrol with Escort side quest

patrol_naboo_privateer_3 = SpacePatrolScreenplay:new {
	className = "patrol_naboo_privateer_3",

	questName = "naboo_privateer_3",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 500,
	itemReward = {
		{species = {SPECIES_ITHORIAN}, item = "object/tangible/wearables/bandolier/ith_mercenary_bandolier.iff"},
		{species = {-1}, item = "object/tangible/wearables/bandolier/mercenary_bandolier.iff"},
	},

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_privateer_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 2,
	sideQuestDelay = 20,

	-- Screenplay Specific Variables
	patrolPoints = {
		{patrolPointName = "rsf_privateer_security_patrol_1", x = 2479, z = -500, y = 1187, patrolNumber = 1, radius = 150},
		{patrolPointName = "rsf_privateer_security_patrol_2", x = 3251, z = -414, y = 2349, patrolNumber = 2, radius = 150},
		{patrolPointName = "rsf_privateer_security_patrol_3", x = 3039, z = -499, y = 3761, patrolNumber = 3, radius = 150},
		{patrolPointName = "rsf_privateer_security_patrol_4", x = 2500, z = -400, y = 4500, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_privateer_3", true)

escort_naboo_privateer_3 = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_3",

	questName = "naboo_privateer_3",
	questType = "escort",

	questZone = "space_naboo",

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "patrol_naboo_privateer_3",
	parentQuestType = "patrol",
	parentQuestName = "naboo_privateer_3",

	-- Screenplay Specific Variables
	escortShips = {"freighterheavy_tier1"},

	escortPoints = {
		{patrolPointName = "rsf_privateer_escort_1", zoneName = "space_naboo", x = 3200, z = -400, y = 2600, escortNumber = 1, radius = 250},
		{patrolPointName = "rsf_privateer_escort_2", zoneName = "space_naboo", x = 2800, z = -450, y = 3200, escortNumber = 2, radius = 250},
		{patrolPointName = "rsf_privateer_escort_3", zoneName = "space_naboo", x = 2400, z = -400, y = 4000, escortNumber = 3, radius = 250},
		{patrolPointName = "rsf_privateer_escort_4", zoneName = "space_naboo", x = 2000, z = -350, y = 4800, escortNumber = 4, radius = 250},
	},

	attackDelay = 90,

	attackShips = {
		{"blacksun_fighter_s02_tier1", "blacksun_fighter_s03_tier1", "blacksun_fighter_s02_tier1"},
	}
}

registerScreenPlay("escort_naboo_privateer_3", true)

-- Mission 4: Assassinate

assassinate_naboo_privateer_tier1_4a = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_privateer_tier1_4a",

	questType = "assassinate",
	questName = "naboo_privateer_tier1_4a",

	questZone = "space_naboo",

	creditReward = 1000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/weapon/wpn_mission_reward_neutral_mandal_light_blaster.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	arrivalDelay = 6,
	failTimer = 20,

	-- SpaceAssassinateScreenplay reads self.assassinateSpawns.target / .escorts (:188-189)
	-- and self.targetPatrols[1] for the spawn location (:197-200). The former
	-- assassinateTarget/assassinateWingmen shape was read by nothing, so this quest
	-- indexed a nil field on start. Ship, escort count and coordinates below are the
	-- ones that were already authored above -- nothing here is new content.
	assassinateSpawns = {
		target = "blacksun_ace_s04_tier1",
		escorts = {"blacksun_fighter_s02_tier1", "blacksun_fighter_s02_tier1"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_privateer_tier1_4a_assassinate_1", x = 1500, z = 500, y = -1000},
	},
}

registerScreenPlay("assassinate_naboo_privateer_tier1_4a", true)

-- Tier 1 Duty Missions

destroy_duty_naboo_privateer_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_privateer_6",

	questName = "naboo_privateer_6",
	questType = "destroy_duty",

	questZone = "space_naboo",

	creditReward = 50,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 1,

	shipLocations = {
		{patrolPointName = "rsf_privateer_patrol_1", x = 752, z = 659, y = -2444},
		{patrolPointName = "rsf_privateer_patrol_2", x = 2031, z = 887, y = -1759},
		{patrolPointName = "rsf_privateer_patrol_3", x = 2466, z = 854, y = -505},
	},

	shipTypes = {
		"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1", "blacksun_fighter_s03_tier1",
		"blacksun_bomber_s01_tier1", "blacksun_bomber_s02_tier1",
	},
}

registerScreenPlay("destroy_duty_naboo_privateer_6", true)

escort_duty_naboo_privateer_7 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_privateer_7",

	questName = "naboo_privateer_7",
	questType = "escort_duty",

	questZone = "space_naboo",

	creditReward = 75,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 1,

	escortShips = {"freighterheavy_tier1", "freighterlight_tier1"},

	escortPoints = {
		{patrolPointName = "stn_rori_rsf_escort_duty_1", zoneName = "space_naboo", x = 832, z = 2355, y = -6460, escortNumber = 1, radius = 250},
		{patrolPointName = "stn_rori_rsf_escort_duty_2", zoneName = "space_naboo", x = 5504, z = 1267, y = -4332, escortNumber = 2, radius = 250},
		{patrolPointName = "stn_rori_rsf_escort_duty_3", zoneName = "space_naboo", x = 6352, z = -220, y = 1363, escortNumber = 3, radius = 250},
	},

	attackShips = {
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1"},
		{"blacksun_fighter_s01_tier1", "blacksun_fighter_s02_tier1", "blacksun_fighter_s03_tier1"},
	}
}

registerScreenPlay("escort_duty_naboo_privateer_7", true)

--[[
	Tier 2 -- Captain Kaydine Main Missions
]]

-- Mission 1: Destroy (5 kills)

destroy_naboo_privateer_13a = SpaceDestroyScreenplay:new {
	className = "destroy_naboo_privateer_13a",

	questName = "naboo_privateer_13a",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/booster/bst_mission_reward_neutral_mandal_m_series.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	killsRequired = 5,

	shipLocations = {},

	shipTypes = {
		"blacksun_ace_s04_tier2", "blacksun_ace_s04_tier3", "blacksun_aggressor_tier2", "blacksun_aggressor_tier3",
		"blacksun_bomber_s01_tier2", "blacksun_bomber_s01_tier3", "blacksun_bomber_s02_tier2", "blacksun_bomber_s02_tier3",
		"blacksun_fighter_s01_tier2", "blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier2", "blacksun_fighter_s02_tier3",
		"blacksun_fighter_s03_tier2", "blacksun_fighter_s03_tier3", "blacksun_gunship_tier2", "blacksun_gunship_tier3",
	},
}

registerScreenPlay("destroy_naboo_privateer_13a", true)

-- Mission 2: Escort

escort_naboo_privateer_14 = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_14",

	questName = "naboo_privateer_14",
	questType = "escort",

	questZone = "space_naboo",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/weapon/wpn_mission_reward_neutral_hk_military_blaster.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	escortShips = {"freighterheavy_tier3"},

	escortPoints = {
		{patrolPointName = "rsf_tier2_escort_1", zoneName = "space_naboo", x = 3500, z = 500, y = -2000, escortNumber = 1, radius = 250},
		{patrolPointName = "rsf_tier2_escort_2", zoneName = "space_naboo", x = 4200, z = 300, y = -500, escortNumber = 2, radius = 250},
		{patrolPointName = "rsf_tier2_escort_3", zoneName = "space_naboo", x = 5000, z = 100, y = 1000, escortNumber = 3, radius = 250},
		{patrolPointName = "rsf_tier2_escort_4", zoneName = "space_naboo", x = 5500, z = -200, y = 2500, escortNumber = 4, radius = 250},
	},

	attackDelay = 180,

	attackShips = {
		{"blacksun_fighter_s02_tier2", "blacksun_fighter_s02_tier2", "blacksun_fighter_s03_tier2", "blacksun_bomber_s01_tier2"},
	}
}

registerScreenPlay("escort_naboo_privateer_14", true)

-- Mission 3: Inspect

inspect_naboo_privateer_15 = SpaceInspectScreenplay:new {
	className = "inspect_naboo_privateer_15",

	questName = "naboo_privateer_15",
	questType = "inspect",

	questZone = "space_naboo",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/shield_generator/shd_mission_reward_neutral_koensayr_ds23.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	inspectTargets = {"blacksun_gunship_tier2"},
	inspectCargo = "shipment_orders",

	targetLocation = {x = 2500, z = 400, y = -3000},
}

registerScreenPlay("inspect_naboo_privateer_15", true)

-- Mission 4: Assassinate

assassinate_naboo_privateer_tier2_4a = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_privateer_tier2_4a",

	questType = "assassinate",
	questName = "naboo_privateer_tier2_4a",

	questZone = "space_naboo",

	creditReward = 5000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/droid_interface/ddi_mission_reward_neutral_sorosuub_w19.iff"},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	arrivalDelay = 7,
	failTimer = 20,

	assassinateSpawns = {
		target = "blacksun_ace_s04_tier3",
		escorts = {"blacksun_fighter_s02_tier2", "blacksun_fighter_s02_tier2", "blacksun_bomber_s01_tier2", "blacksun_bomber_s01_tier2", "blacksun_fighter_s03_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "rsf_tier2_assassinate_1", x = 1500, z = 600, y = -1500},
		{patrolPointName = "rsf_tier2_assassinate_2", x = 2000, z = 400, y = -2000},
	},
}

registerScreenPlay("assassinate_naboo_privateer_tier2_4a", true)

-- Tier 2 Duty Missions

destroy_duty_naboo_privateer_9 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_privateer_9",

	questName = "naboo_privateer_9",
	questType = "destroy_duty",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 2,

	shipLocations = {
		{patrolPointName = "rsf_duty_patrol_1", x = 752, z = 659, y = -2444},
		{patrolPointName = "rsf_duty_patrol_2", x = 2031, z = 887, y = -1759},
		{patrolPointName = "rsf_duty_patrol_3", x = 2466, z = 854, y = -505},
	},

	shipTypes = {
		"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_fighter_s03_tier2",
		"blacksun_bomber_s01_tier2", "blacksun_bomber_s02_tier2",
	},
}

registerScreenPlay("destroy_duty_naboo_privateer_9", true)

escort_duty_naboo_privateer_10 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_privateer_10",

	questName = "naboo_privateer_10",
	questType = "escort_duty",

	questZone = "space_naboo",

	creditReward = 150,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 2,

	escortShips = {"freighterheavy_tier2", "freighterlight_tier2"},

	escortPoints = {
		{patrolPointName = "rsf_tier2_duty_escort_1", zoneName = "space_naboo", x = 1000, z = 500, y = -3000, escortNumber = 1, radius = 250},
		{patrolPointName = "rsf_tier2_duty_escort_2", zoneName = "space_naboo", x = 2500, z = 300, y = -1500, escortNumber = 2, radius = 250},
		{patrolPointName = "rsf_tier2_duty_escort_3", zoneName = "space_naboo", x = 4000, z = 100, y = 500, escortNumber = 3, radius = 250},
	},

	attackShips = {
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2"},
		{"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2", "blacksun_fighter_s03_tier2"},
	}
}

registerScreenPlay("escort_duty_naboo_privateer_10", true)

destroy_duty_naboo_privateer_11 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_privateer_11",

	questName = "naboo_privateer_11",
	questType = "destroy_duty",

	questZone = "space_naboo",

	creditReward = 125,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 2,

	shipLocations = {
		{patrolPointName = "rsf_duty_patrol_4", x = 3500, z = 400, y = -1000},
		{patrolPointName = "rsf_duty_patrol_5", x = 4000, z = 200, y = 500},
		{patrolPointName = "rsf_duty_patrol_6", x = 4500, z = -100, y = 2000},
	},

	shipTypes = {
		"blacksun_fighter_s02_tier2", "blacksun_fighter_s03_tier2",
		"blacksun_bomber_s01_tier2", "blacksun_aggressor_tier2",
	},
}

registerScreenPlay("destroy_duty_naboo_privateer_11", true)

-- Note: Recovery duty not fully implemented in base code
recovery_duty_naboo_privateer_12 = SpaceDutyDestroyScreenplay:new {
	className = "recovery_duty_naboo_privateer_12",

	questName = "naboo_privateer_12",
	questType = "recovery_duty",

	questZone = "space_naboo",

	creditReward = 175,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	dutyMissionLevel = 2,

	shipLocations = {
		{patrolPointName = "rsf_recovery_1", x = 2000, z = 300, y = -2500},
		{patrolPointName = "rsf_recovery_2", x = 3000, z = 500, y = -1500},
	},

	shipTypes = {
		"blacksun_fighter_s01_tier2", "blacksun_fighter_s02_tier2",
	},
}

registerScreenPlay("recovery_duty_naboo_privateer_12", true)

--[[
	Tier 3 -- Commander Dulios Main Missions
]]

-- Mission 1: Recovery -> Patrol -> Destroy_Surpriseattack -> Assassinate

recovery_naboo_privateer_tier3_1a = SpaceRecoveryScreenplay:new {
	className = "recovery_naboo_privateer_tier3_1a",

	questName = "naboo_privateer_tier3_1a",
	questType = "recovery",

	questZone = "space_dantooine",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_privateer_tier3_1b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	-- Screenplay Specific Variables
	arrivalDelay = 13,
	recoveryDelay = 15,

	-- Target: Saymonz Varg's ship Dru'Mdar (Black Sun Assassin)
	recoverShip = "dru_mdar_tier3",
	recoveryConversationMobile = "object/mobile/shared_dressed_noble_human_male.iff",

	-- Black Sun escorts protecting the Dru'Mdar
	escortShips = {"blacksun_fighter_s02_tier3_dantooine", "blacksun_fighter_s02_tier3_dantooine"},

	-- Pre-recovery patrol points in Dantooine space (friendly controlled area per STF)
	preRecoveryPoints = {
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_1", zoneName = "space_dantooine", x = -1500, z = 800, y = 2000, escortNumber = 1, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_2", zoneName = "space_dantooine", x = -1200, z = 600, y = 2500, escortNumber = 2, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_3", zoneName = "space_dantooine", x = -800, z = 400, y = 3000, escortNumber = 3, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_4", zoneName = "space_dantooine", x = -400, z = 200, y = 3500, escortNumber = 4, radius = 250},
	},

	-- Escort points after capture - route to hyperspace jump point
	recoveryPoints = {
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_5", zoneName = "space_dantooine", x = 0, z = 0, y = 3800, escortNumber = 1, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_6", zoneName = "space_dantooine", x = 500, z = -200, y = 4200, escortNumber = 2, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_7", zoneName = "space_dantooine", x = 1000, z = -400, y = 4600, escortNumber = 3, radius = 250},
		{patrolPointName = "dantooine_privateer_tier3_recovery_point_8", zoneName = "space_dantooine", x = 1500, z = -600, y = 5000, escortNumber = 4, radius = 250},
	},

	attackDelay = 110,

	-- Black Sun reinforcements attacking during escort
	attackShips = {
		{"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3", "blacksun_bomber_s01_tier3"},
	},
}

registerScreenPlay("recovery_naboo_privateer_tier3_1a", true)

patrol_naboo_privateer_tier3_1b = SpacePatrolScreenplay:new {
	className = "patrol_naboo_privateer_tier3_1b",

	questName = "naboo_privateer_tier3_1b",
	questType = "patrol",

	questZone = "space_dantooine",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_tier3_1c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.PATROL_POINT,

	sideQuestPatrolStart = 3,
	sideQuestDelay = 4,

	parentQuest = "recovery_naboo_privateer_tier3_1a",
	parentQuestType = "recovery",
	parentQuestName = "naboo_privateer_tier3_1a",

	-- Patrol route in Dantooine space (awaiting orders after Varg escaped)
	patrolPoints = {
		{patrolPointName = "dantooine_privateer_tier3_patrol_1", x = 2000, z = -500, y = 5500, patrolNumber = 1, radius = 150},
		{patrolPointName = "dantooine_privateer_tier3_patrol_2", x = 2500, z = -700, y = 6000, patrolNumber = 2, radius = 150},
		{patrolPointName = "dantooine_privateer_tier3_patrol_3", x = 3000, z = -900, y = 6500, patrolNumber = 3, radius = 150},
		{patrolPointName = "dantooine_privateer_tier3_patrol_4", x = 3500, z = -1100, y = 7000, patrolNumber = 4, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_privateer_tier3_1b", true)

destroy_surpriseattack_naboo_privateer_tier3_1c = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier3_1c",

	questName = "naboo_privateer_tier3_1c",
	questType = "destroy_surpriseattack",

	questZone = "space_dantooine",

	parentQuest = "patrol_naboo_privateer_tier3_1b",
	parentQuestType = "patrol",
	parentQuestName = "naboo_privateer_tier3_1b",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_privateer_tier3_1d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Black Sun ambush during patrol in Dantooine
	surpriseAttackShips = {
		zone = "space_dantooine",
		spawns = {{count = 4, shipName = "blacksun_fighter_s02_tier3_dantooine"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier3_1c", true)

assassinate_naboo_privateer_tier3_1d = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_privateer_tier3_1d",

	questType = "assassinate",
	questName = "naboo_privateer_tier3_1d",

	-- Saymonz Varg has fled to Naboo space after evading capture in Dantooine
	questZone = "space_naboo",

	creditReward = 25000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/reactor/rct_mission_reward_neutral_subpro_military.iff"},
	},

	parentQuest = "destroy_surpriseattack_naboo_privateer_tier3_1c",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_privateer_tier3_1c",

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	arrivalDelay = 7,
	failTimer = 20,

	-- Target: Saymonz Varg (Black Sun Assassin) - destroy since capture failed
	assassinateSpawns = {
		target = "blacksun_ace_s04_tier3",
		escorts = {"blacksun_fighter_s01_tier3", "blacksun_fighter_s02_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "naboo_privateer_tier3_assassinate_1", x = 3500, z = -3000, y = -2000},
		{patrolPointName = "naboo_privateer_tier3_assassinate_2", x = 4000, z = -2500, y = -1500},
	},
}

registerScreenPlay("assassinate_naboo_privateer_tier3_1d", true)

-- Mission 2: Escort -> Destroy_Surpriseattack -> Space_Battle -> Rescue

escort_naboo_privateer_tier3_2a = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_tier3_2a",

	questName = "naboo_privateer_tier3_2a",
	questType = "escort",

	questZone = "space_naboo",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_tier3_2c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	-- Escort the Cadamo Sun (decoy ship) to draw Ay'Nat pirate attack
	escortShips = {"freighterlight_tier3"},

	escortPoints = {
		{patrolPointName = "naboo_privateer_tier3_escort_1", zoneName = "space_naboo", x = 2799, z = -362, y = -19, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier3_escort_2", zoneName = "space_naboo", x = 3281, z = 295, y = -818, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier3_escort_3", zoneName = "space_naboo", x = 3775, z = 743, y = -925, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier3_escort_4", zoneName = "space_naboo", x = 3895, z = 1220, y = -1913, escortNumber = 4, radius = 250},
	},

	attackDelay = 110,

	-- Ay'Nat pirates attacking the decoy
	attackShips = {
		{"aynat_outlaw_tier3", "aynat_outlaw_tier3"},
		{"aynat_outlaw_tier3", "aynat_enforcer_tier3", "aynat_intimidator_tier3"},
	}
}

registerScreenPlay("escort_naboo_privateer_tier3_2a", true)

rescue_naboo_privateer_tier3_2e = SpaceRescueScreenplay:new {
	className = "rescue_naboo_privateer_tier3_2e",

	questName = "naboo_privateer_tier3_2e",
	questType = "rescue",

	questZone = "space_corellia",  -- STF: Corellia System

	creditReward = 25000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/engine/eng_mission_reward_neutral_mandal_inferno.iff"},
	},

	parentQuest = "space_battle_naboo_privateer_tier3_2d",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_privateer_tier3_2d",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- Screenplay Specific Variables
	arrivalDelay = 3,

	-- RSF Madersim - damaged heavy freighter needing rescue in Corellia
	rescueShip = "freighterheavy_tier3",
	rescueLocation = {x = 2500, z = 1200, y = -800},

	-- Repair timing (no attackers during repairs per wiki)
	repairDelay = 30, -- 30 seconds for repairs

	-- Escort points to hyperspace jump after repairs (in Corellia)
	escortPoints = {
		{patrolPointName = "corellia_privateer_tier3_rescue_escort_1", zoneName = "space_corellia", x = 3000, z = 1000, y = -500, escortNumber = 1, radius = 250},
		{patrolPointName = "corellia_privateer_tier3_rescue_escort_2", zoneName = "space_corellia", x = 3500, z = 800, y = -200, escortNumber = 2, radius = 250},
		{patrolPointName = "corellia_privateer_tier3_rescue_escort_3", zoneName = "space_corellia", x = 4000, z = 600, y = 100, escortNumber = 3, radius = 250},
	},

	escortSpeed = 25,

	-- Single Ay'Nat Vaporizer attacks during escort (per wiki)
	escortAttackDelay = 15,
	escortAttackShips = {
		{{count = 1, shipName = "aynat_vaporizer_tier3"}},
	},
}

registerScreenPlay("rescue_naboo_privateer_tier3_2e", true)

space_battle_naboo_privateer_tier3_2d = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_privateer_tier3_2d",

	questType = "space_battle",
	questName = "naboo_privateer_tier3_2d",

	questZone = "space_corellia",  -- STF: Corellia System

	creditReward = 0,
	itemReward = {},

	parentQuest = "destroy_surpriseattack_naboo_privateer_tier3_2c",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_privateer_tier3_2c",

	sideQuest = true,
	sideQuestType = "rescue",
	sideQuestName = "naboo_privateer_tier3_2e",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 1,

	-- Defend 3 RSF ships against Ay'Nat pirates in Corellia (per wiki)
	battleLocation = {patrolPointName = "corellia_privateer_tier3_space_battle_1", x = 4500, y = 400, z = -1000},

	supportShipsDelay = 60,
	enemyShipsDelay = 90,

	-- 3 RSF ships to defend (per wiki)
	supportShips = {"rsf_ace_tier3", "rsf_ace_tier3", "rsf_stinger_tier3"},
	-- 8 enemy vessels (per wiki)
	enemyShips = {"aynat_outlaw_tier3", "aynat_outlaw_tier3", "aynat_outlaw_tier3", "aynat_outlaw_tier3", "aynat_enforcer_tier3", "aynat_enforcer_tier3", "aynat_intimidator_tier3", "aynat_intimidator_tier3"},
}

registerScreenPlay("space_battle_naboo_privateer_tier3_2d", true)

destroy_surpriseattack_naboo_privateer_tier3_2c = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier3_2c",

	questName = "naboo_privateer_tier3_2c",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",

	parentQuest = "escort_naboo_privateer_tier3_2a",
	parentQuestType = "escort",
	parentQuestName = "naboo_privateer_tier3_2a",

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_privateer_tier3_2d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Ay'Nat pirate reinforcements
	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 5, shipName = "aynat_outlaw_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier3_2c", true)

-- Mission 3: Inspect -> Delivery -> Survival -> Destroy_Surpriseattack

inspect_naboo_privateer_tier3_3a = SpaceInspectScreenplay:new {
	className = "inspect_naboo_privateer_tier3_3a",

	questName = "naboo_privateer_tier3_3a",
	questType = "inspect",

	questZone = "space_naboo",  -- STF: Naboo System

	creditReward = 0,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = true,
	sideQuestType = "delivery",
	sideQuestName = "naboo_privateer_tier3_3b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	-- Screenplay Specific Variables
	inspectTargets = {"civshuttle"},
	inspectCargo = "naboo_priv_tier3_diplomat_cargo",

	targetLocation = {x = 2500, z = -1500, y = 1000},  -- Naboo space coordinates
}

registerScreenPlay("inspect_naboo_privateer_tier3_3a", true)

delivery_naboo_privateer_tier3_3b = SpaceDeliveryScreenplay:new {
	className = "delivery_naboo_privateer_tier3_3b",

	questName = "naboo_privateer_tier3_3b",
	questType = "delivery",

	questZone = "space_lok",  -- Wiki: Lok System delivery run

	creditReward = 0,

	parentQuest = "inspect_naboo_privateer_tier3_3a",
	parentQuestType = "inspect",
	parentQuestName = "naboo_privateer_tier3_3a",

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_privateer_tier3_3c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 4,

	-- Screenplay Specific Variables
}

registerScreenPlay("delivery_naboo_privateer_tier3_3b", true)

survival_naboo_privateer_tier3_3c = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_privateer_tier3_3c",

	questName = "naboo_privateer_tier3_3c",
	questType = "survival",

	questZone = "space_lok",  -- STF: Lok System

	creditReward = 25000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/weapon_capacitor/cap_mission_reward_neutral_sorosuub_v1.iff"},
	},

	parentQuest = "delivery_naboo_privateer_tier3_3b",
	parentQuestType = "delivery",
	parentQuestName = "naboo_privateer_tier3_3b",

	-- Mission 3 ends here - return to Dulios for reward (per wiki)
	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- Screenplay Specific Variables
}

registerScreenPlay("survival_naboo_privateer_tier3_3c", true)

destroy_surpriseattack_naboo_privateer_tier3_3e = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier3_3e",

	questName = "naboo_privateer_tier3_3e",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",  -- STF: Naboo System

	parentQuest = "survival_naboo_privateer_tier3_3c",
	parentQuestType = "survival",
	parentQuestName = "naboo_privateer_tier3_3c",

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables
	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 5, shipName = "blacksun_aggressor_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier3_3e", true)

-- Mission 4: Destroy_Surpriseattack (Naboo) -> Assassinate (Dantooine) -> Space_Battle (Lok) -> Survival (Lok) -> Assassinate (Lok)

-- Initial surprise attack upon launching from Theed - 5 Black Sun Marauders
destroy_surpriseattack_naboo_privateer_tier3_4_initial = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier3_4_initial",

	questName = "naboo_privateer_tier3_4_initial",
	questType = "destroy_surpriseattack",

	questZone = "space_naboo",

	creditReward = 0,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_privateer_tier3_4a",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- 5 Tier 3 Ixiyen Black Sun Marauder (per wiki)
	surpriseAttackShips = {
		zone = "space_naboo",
		spawns = {{count = 5, shipName = "blacksun_marauder_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier3_4_initial", true)

-- Dantooine assassinate - destroy Beldini and escorts
assassinate_naboo_privateer_tier3_4a = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_privateer_tier3_4a",

	questType = "assassinate",
	questName = "naboo_privateer_tier3_4a",

	questZone = "space_dantooine",

	creditReward = 0,
	itemReward = {},

	parentQuest = "destroy_surpriseattack_naboo_privateer_tier3_4_initial",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_privateer_tier3_4_initial",

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_privateer_tier3_4b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 1,

	-- Screenplay Specific Variables
	arrivalDelay = 12,
	failTimer = 20,

	-- Per wiki: 2 Tier 3 Rihkxyrk Black Sun Bomber, 2 Tier 3 Ixiyen Black Sun Vehement, 1 Tier 4 Kihraxz Beldini
	assassinateSpawns = {
		target = "blacksun_beldini_tier3",
		escorts = {"blacksun_bomber_s01_tier3", "blacksun_bomber_s01_tier3", "blacksun_vehement_tier3", "blacksun_vehement_tier3"},
	},

	targetPatrols = {
		{patrolPointName = "dantooine_privateer_tier3_beldini_1", x = -2673, z = -2332, y = -502},
		{patrolPointName = "dantooine_privateer_tier3_beldini_2", x = -4323, z = -3711, y = -844},
		{patrolPointName = "dantooine_privateer_tier3_beldini_3", x = -5818, z = -4961, y = -1155},
		{patrolPointName = "dantooine_privateer_tier3_beldini_4", x = -7473, z = -6718, y = -1559},
	},
}

registerScreenPlay("assassinate_naboo_privateer_tier3_4a", true)

-- Lok space battle - Crystal Snake at Voria's Ember
space_battle_naboo_privateer_tier3_4b = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_privateer_tier3_4b",

	questType = "space_battle",
	questName = "naboo_privateer_tier3_4b",

	questZone = "space_lok",

	creditReward = 0,
	itemReward = {},

	parentQuest = "assassinate_naboo_privateer_tier3_4a",
	parentQuestType = "assassinate",
	parentQuestName = "naboo_privateer_tier3_4a",

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_privateer_tier3_4c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Voria's Ember battle location in Lok
	battleLocation = {patrolPointName = "lok_privateer_tier3_crystal_snake_battle", x = 3500, y = -2000, z = 1500},

	supportShipsDelay = 30,
	enemyShipsDelay = 60,

	-- Per wiki: 3 Tier 3 KSE Firespray RSF Hunter
	supportShips = {"rsf_hunter_tier3", "rsf_hunter_tier3", "rsf_hunter_tier3"},
	-- Per wiki: 2 Tier 3 Kihraxz Black Sun Fighter, 1 Tier 3 Ixiyen Black Sun Marauder, 1 Tier 4 Kihraxz Crystal Snake
	enemyShips = {"blacksun_fighter_s01_tier3", "blacksun_fighter_s01_tier3", "blacksun_marauder_tier3", "blacksun_crystal_snake_tier3"},
}

registerScreenPlay("space_battle_naboo_privateer_tier3_4b", true)

-- Lok survival - 3 waves of Black Sun attackers
survival_naboo_privateer_tier3_4c = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_privateer_tier3_4c",

	questName = "naboo_privateer_tier3_4c",
	questType = "survival",

	questZone = "space_lok",

	creditReward = 0,

	parentQuest = "space_battle_naboo_privateer_tier3_4b",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_privateer_tier3_4b",

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "naboo_privateer_tier3_4f",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Screenplay Specific Variables
	survivalWaves = {
		-- Wave 1: 3 Tier 3 Ixiyen Black Sun Marauder
		{{count = 3, shipName = "blacksun_marauder_tier3"}},
		-- Wave 2: 4 Tier 3 Ixiyen Black Sun Vehement
		{{count = 4, shipName = "blacksun_vehement_tier3"}},
		-- Wave 3: 1 Tier 2 Assault Gunboat Black Sun Devastator (using gunship)
		{{count = 1, shipName = "blacksun_gunship_tier2"}},
	},
	waveDelay = 15,
}

registerScreenPlay("survival_naboo_privateer_tier3_4c", true)

-- Lok final assassinate - destroy Black Sun operative (Krayt's Bane)
assassinate_naboo_privateer_tier3_4f = SpaceAssassinateScreenplay:new {
	className = "assassinate_naboo_privateer_tier3_4f",

	questType = "assassinate",
	questName = "naboo_privateer_tier3_4f",

	questZone = "space_lok",

	creditReward = 25000,
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/components/armor/arm_mission_reward_neutral_kse_handcrafted.iff"},
	},

	parentQuest = "survival_naboo_privateer_tier3_4c",
	parentQuestType = "survival",
	parentQuestName = "naboo_privateer_tier3_4c",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- Screenplay Specific Variables
	arrivalDelay = 10,
	failTimer = 20,

	-- Per wiki: 2 Tier 4 Kihraxz Black Sun Wraith, 1 Tier 3 Rihkxyrk Krayt's Bane
	assassinateSpawns = {
		target = "blacksun_krayt_bane_tier3",
		escorts = {"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
	},

	targetPatrols = {
		{patrolPointName = "lok_privateer_tier3_krayt_bane_1", x = 2500, z = 1200, y = -1500},
		{patrolPointName = "lok_privateer_tier3_krayt_bane_2", x = 3000, z = 800, y = -1800},
		{patrolPointName = "lok_privateer_tier3_krayt_bane_3", x = 3500, z = 400, y = -2100},
		{patrolPointName = "lok_privateer_tier3_krayt_bane_4", x = 4000, z = 0, y = -2400},
	},
}

registerScreenPlay("assassinate_naboo_privateer_tier3_4f", true)

--[[
	Tier 4 -- Capt. Dinge Main Missions
]]

-- Mission 1: Escort (Endor) -> Escort (Endor)

-- Escort the RSF Scanner
escort_naboo_privateer_tier4_1a = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_tier4_1a",

	questName = "naboo_privateer_tier4_1a",
	questType = "escort",

	questZone = "space_endor",

	creditReward = 0,

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_privateer_tier4_1b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	-- Screenplay Specific Variables

	escortShips = {"rsf_scanner_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_one_1", zoneName = "space_endor", x = -239, z = 3935, y = 3280, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_one_2", zoneName = "space_endor", x = -549, z = 3180, y = 3238, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_one_3", zoneName = "space_endor", x = -1251, z = 1477, y = 3143, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_one_4", zoneName = "space_endor", x = -1996, z = -330, y = 3042, escortNumber = 4, radius = 250},
	},

	attackDelay = 85,

	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
		{"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_aggressor_tier4"},
	}
}

registerScreenPlay("escort_naboo_privateer_tier4_1a", true)

-- Escort the Imperial Official
escort_naboo_privateer_tier4_1b = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_tier4_1b",

	questName = "naboo_privateer_tier4_1b",
	questType = "escort",

	questZone = "space_endor",

	creditReward = 25000,

	parentQuest = "escort_naboo_privateer_tier4_1a",
	parentQuestType = "escort",
	parentQuestName = "naboo_privateer_tier4_1a",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.NONE,

	-- Screenplay Specific Variables

	escortShips = {"imp_lambda_shuttle_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_two_1", zoneName = "space_endor", x = 4249, z = 2899, y = 3799, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_two_2", zoneName = "space_endor", x = 3520, z = 2210, y = 3450, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_two_3", zoneName = "space_endor", x = 2680, z = 1495, y = 3120, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_1_escort_two_4", zoneName = "space_endor", x = 1770, z = 640, y = 2830, escortNumber = 4, radius = 250},
	},

	attackDelay = 85,

	attackShips = {
		{"blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4"},
		{"blacksun_bomber_s01_tier4", "blacksun_bomber_s01_tier4", "blacksun_aggressor_tier4"},
	}
}

registerScreenPlay("escort_naboo_privateer_tier4_1b", true)

-- Mission 2: Inspect -> Destroy_Surpriseattack -> Patrol -> Destroy_Surpriseattack -> Destroy_Surpriseattack (Endor)

-- Recover Industrial Cargo from the Mining Freighter
inspect_naboo_privateer_tier4_2a = SpaceInspectScreenplay:new {
	className = "inspect_naboo_privateer_tier4_2a",

	questName = "naboo_privateer_tier4_2a",
	questType = "inspect",

	questZone = "space_endor",

	creditReward = 0,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_tier4_2b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

	-- Screenplay Specific Variables

	inspectTargets = {"freighterheavy_mining"},
	inspectCargo = "general_cargo",

	targetLocation = {x = 2100, z = 3300, y = 2600},
}

registerScreenPlay("inspect_naboo_privateer_tier4_2a", true)

-- Survive the Black Sun Attack
destroy_surpriseattack_naboo_privateer_tier4_2b = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier4_2b",

	questName = "naboo_privateer_tier4_2b",
	questType = "destroy_surpriseattack",

	questZone = "space_endor",

	parentQuest = "inspect_naboo_privateer_tier4_2a",
	parentQuestType = "inspect",
	parentQuestName = "naboo_privateer_tier4_2a",

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_privateer_tier4_2c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Screenplay Specific Variables

	surpriseAttackShips = {
		zone = "space_endor",
		spawns = {{count = 2, shipName = "blacksun_fighter_s02_tier4"}, {count = 2, shipName = "blacksun_bomber_s01_tier4"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier4_2b", true)

-- Patrol for the Blacksun Presence
patrol_naboo_privateer_tier4_2c = SpacePatrolScreenplay:new {
	className = "patrol_naboo_privateer_tier4_2c",

	questName = "naboo_privateer_tier4_2c",
	questType = "patrol",

	questZone = "space_endor",

	creditReward = 0,

	parentQuest = "destroy_surpriseattack_naboo_privateer_tier4_2b",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_privateer_tier4_2b",

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_tier4_2c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Screenplay Specific Variables

	patrolPoints = {
		{patrolPointName = "naboo_privateer_tier4_leg_2_patrol_one_1", x = 1400, z = 2800, y = 2200, patrolNumber = 1, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_2_patrol_one_2", x = 480, z = 2160, y = 1750, patrolNumber = 2, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_2_patrol_one_3", x = -620, z = 1420, y = 1280, patrolNumber = 3, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_2_patrol_one_4", x = -1730, z = 590, y = 830, patrolNumber = 4, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_2_patrol_one_5", x = -2850, z = -280, y = 360, patrolNumber = 5, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_privateer_tier4_2c", true)

-- Defend from the Black Sun Assault
destroy_surpriseattack_naboo_privateer_tier4_2c = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier4_2c",

	questName = "naboo_privateer_tier4_2c",
	questType = "destroy_surpriseattack",

	questZone = "space_endor",

	parentQuest = "patrol_naboo_privateer_tier4_2c",
	parentQuestType = "patrol",
	parentQuestName = "naboo_privateer_tier4_2c",

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "naboo_privateer_tier4_2d",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Screenplay Specific Variables

	surpriseAttackShips = {
		zone = "space_endor",
		spawns = {{count = 3, shipName = "blacksun_fighter_s01_tier4"}, {count = 2, shipName = "blacksun_aggressor_tier4"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier4_2c", true)

-- Survive the Black Sun Attack
destroy_surpriseattack_naboo_privateer_tier4_2d = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_naboo_privateer_tier4_2d",

	questName = "naboo_privateer_tier4_2d",
	questType = "destroy_surpriseattack",

	questZone = "space_endor",

	creditReward = 25000,

	parentQuest = "destroy_surpriseattack_naboo_privateer_tier4_2c",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "naboo_privateer_tier4_2c",

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	surpriseAttackShips = {
		zone = "space_endor",
		spawns = {{count = 2, shipName = "blacksun_ace_s04_tier4"}, {count = 2, shipName = "blacksun_bomber_ace_s04_tier4"}},
	},
}

registerScreenPlay("destroy_surpriseattack_naboo_privateer_tier4_2d", true)

-- Mission 3: Delivery -> Patrol -> Survival (Yavin)

-- Deliver Imperial Goods
delivery_naboo_privateer_tier4_3a = SpaceDeliveryScreenplay:new {
	className = "delivery_naboo_privateer_tier4_3a",

	questName = "naboo_privateer_tier4_3a",
	questType = "delivery",

	questZone = "space_yavin4",

	creditReward = 0,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = true,
	sideQuestType = "patrol",
	sideQuestName = "naboo_privateer_tier4_3b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 4,

	-- Screenplay Specific Variables
}

registerScreenPlay("delivery_naboo_privateer_tier4_3a", true)

-- Fly a Decoy Patrol
patrol_naboo_privateer_tier4_3b = SpacePatrolScreenplay:new {
	className = "patrol_naboo_privateer_tier4_3b",

	questName = "naboo_privateer_tier4_3b",
	questType = "patrol",

	questZone = "space_yavin4",

	creditReward = 0,

	parentQuest = "delivery_naboo_privateer_tier4_3a",
	parentQuestType = "delivery",
	parentQuestName = "naboo_privateer_tier4_3a",

	sideQuest = true,
	sideQuestType = "survival",
	sideQuestName = "naboo_privateer_tier4_3c",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 3,

	-- Screenplay Specific Variables

	patrolPoints = {
		{patrolPointName = "naboo_privateer_tier4_leg_3_patrol_one_1", x = 4793, z = -5425, y = 4509, patrolNumber = 1, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_3_patrol_one_2", x = 4358, z = -4600, y = 4097, patrolNumber = 2, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_3_patrol_one_3", x = 4040, z = -3996, y = 3796, patrolNumber = 3, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_3_patrol_one_4", x = 3589, z = -3140, y = 3370, patrolNumber = 4, radius = 150},
		{patrolPointName = "naboo_privateer_tier4_leg_3_patrol_one_5", x = 3080, z = -2270, y = 2940, patrolNumber = 5, radius = 150},
	},
}

registerScreenPlay("patrol_naboo_privateer_tier4_3b", true)

-- Intercept the Black Sun Assault
survival_naboo_privateer_tier4_3c = SpaceSurvivalScreenplay:new {
	className = "survival_naboo_privateer_tier4_3c",

	questName = "naboo_privateer_tier4_3c",
	questType = "survival",

	questZone = "space_yavin4",

	creditReward = 25000,

	parentQuest = "patrol_naboo_privateer_tier4_3b",
	parentQuestType = "patrol",
	parentQuestName = "naboo_privateer_tier4_3b",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- Screenplay Specific Variables

	survivalWaves = {
		{{count = 3, shipName = "blacksun_fighter_s02_tier4"}},
		{{count = 4, shipName = "blacksun_bomber_s02_tier4"}},
		{{count = 1, shipName = "blacksun_gunship_tier4"}},
	},
	waveDelay = 15,
}

registerScreenPlay("survival_naboo_privateer_tier4_3c", true)

-- Mission 4: Space_Battle -> Escort -> Space_Battle win/lose (Yavin)

-- Assist the RSF Forces
space_battle_naboo_privateer_tier4_4a = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_privateer_tier4_4a",

	questType = "space_battle",
	questName = "naboo_privateer_tier4_4a",

	questZone = "space_yavin4",

	creditReward = 0,
	itemReward = {},

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "naboo_privateer_tier4_4b",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 1,

	-- Screenplay Specific Variables

	battleLocation = {patrolPointName = "naboo_privateer_tier4_leg_4_space_battle_one", x = -3200, y = 1400, z = 2600},

	supportShipsDelay = 60,
	enemyShipsDelay = 90,

	supportShips = {"rsf_ace_tier4", "rsf_ace_tier4", "rsf_hunter_tier4", "rsf_stinger_tier4"},
	enemyShips = {"blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_bomber_s01_tier4", "blacksun_bomber_s01_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"},
}

registerScreenPlay("space_battle_naboo_privateer_tier4_4a", true)

-- Escort the Deep Space Scan Ship
escort_naboo_privateer_tier4_4b = SpaceEscortScreenplay:new {
	className = "escort_naboo_privateer_tier4_4b",

	questName = "naboo_privateer_tier4_4b",
	questType = "escort",

	questZone = "space_yavin4",

	creditReward = 0,

	parentQuest = "space_battle_naboo_privateer_tier4_4a",
	parentQuestType = "space_battle",
	parentQuestName = "naboo_privateer_tier4_4a",

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "naboo_privateer_tier4_4c_win",
	sideFailQuestType = "space_battle",
	sideFailQuestName = "naboo_privateer_tier4_4c_lose",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL,
	sideQuestDelay = 1,

	-- Screenplay Specific Variables

	escortShips = {"rsf_scanner_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_privateer_tier4_leg_4_escort_1", zoneName = "space_yavin4", x = -2600, z = 1800, y = 2100, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_4_escort_2", zoneName = "space_yavin4", x = -1850, z = 2450, y = 1600, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_4_escort_3", zoneName = "space_yavin4", x = -1080, z = 3140, y = 1090, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_leg_4_escort_4", zoneName = "space_yavin4", x = -290, z = 3860, y = 540, escortNumber = 4, radius = 250},
	},

	attackDelay = 85,

	attackShips = {
		{"blacksun_fighter_s03_tier4", "blacksun_fighter_s03_tier4"},
		{"blacksun_marauder_tier4", "blacksun_marauder_tier4", "blacksun_aggressor_tier4"},
	}
}

registerScreenPlay("escort_naboo_privateer_tier4_4b", true)

-- Final Battle Against the Black Sun (scan ship survived)
space_battle_naboo_privateer_tier4_4c_win = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_privateer_tier4_4c_win",

	questType = "space_battle",
	questName = "naboo_privateer_tier4_4c_win",

	questZone = "space_yavin4",

	creditReward = 25000,
	itemReward = {},

	parentQuest = "escort_naboo_privateer_tier4_4b",
	parentQuestType = "escort",
	parentQuestName = "naboo_privateer_tier4_4b",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.NONE,
	sideQuestDelay = 1,

	-- Screenplay Specific Variables

	battleLocation = {patrolPointName = "naboo_privateer_tier4_leg_4_space_battle_two", x = 640, z = 4480, y = -120},

	supportShipsDelay = 30,
	enemyShipsDelay = 90,

	supportShips = {"rsf_ace_tier4", "rsf_hunter_tier4", "rsf_sentinel_tier4", "rsf_stinger_tier4"},
	enemyShips = {"blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_gunship_tier4", "blacksun_marauder_tier4", "blacksun_marauder_tier4", "blacksun_vehement_tier4", "blacksun_gunship_tier4"},
}

registerScreenPlay("space_battle_naboo_privateer_tier4_4c_win", true)

-- Final Battle Against the Black Sun (scan ship was lost)
space_battle_naboo_privateer_tier4_4c_lose = SpaceBattleScreenplay:new {
	className = "space_battle_naboo_privateer_tier4_4c_lose",

	questType = "space_battle",
	questName = "naboo_privateer_tier4_4c_lose",

	questZone = "space_yavin4",

	creditReward = 0,
	itemReward = {},

	parentQuest = "escort_naboo_privateer_tier4_4b",
	parentQuestType = "escort",
	parentQuestName = "naboo_privateer_tier4_4b",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.NONE,
	sideQuestDelay = 1,

	-- Screenplay Specific Variables

	battleLocation = {patrolPointName = "naboo_privateer_tier4_leg_4_space_battle_two", x = 640, z = 4480, y = -120},

	supportShipsDelay = 60,
	enemyShipsDelay = 90,

	supportShips = {"rsf_ace_tier4", "rsf_hunter_tier4", "rsf_sentinel_tier4", "rsf_stinger_tier4"},
	enemyShips = {"blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_bomber_s02_tier4", "blacksun_bomber_s02_tier4", "blacksun_gunship_tier4", "blacksun_marauder_tier4",
		"blacksun_marauder_tier4", "blacksun_vehement_tier4", "blacksun_vehement_tier4"
	},
}

registerScreenPlay("space_battle_naboo_privateer_tier4_4c_lose", true)

-- Dinge Tier 4 Duty Missions

destroy_duty_naboo_privateer_tier4_1 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_privateer_tier4_1",

	questName = "naboo_privateer_tier4_1",
	questType = "destroy_duty",

	questZone = "space_endor",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 2, -- Amount of levels a player has to complete to finish mission
	totalRounds = 4, -- Total Rounds for each of the levels
	totalWaves = 3, -- Total waves at each location that is not the boss ship

	minDistance = 12500, -- Minimum distance away for new location
	maxDistance = 17500, -- Maximum distance away for new location

	bossShip = "blacksun_ace_s04_tier4",
	shipTypes = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4", "blacksun_fighter_s01_tier4"},
		{"blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4", "blacksun_fighter_s02_tier4"},
		{"blacksun_bomber_s01_tier4", "blacksun_bomber_s01_tier4", "blacksun_bomber_s01_tier4", "blacksun_bomber_s01_tier4"},
		{"blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_aggressor_tier4", "blacksun_aggressor_tier4"},
	},
}

registerScreenPlay("destroy_duty_naboo_privateer_tier4_1", true)

escort_duty_naboo_privateer_tier4_1 = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_naboo_privateer_tier4_1",

	questName = "naboo_privateer_tier4_1",
	questType = "escort_duty",

	questZone = "space_endor",

	creditReward = 5000,

	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"freighterheavy_mining", "freighterlight_tier4"},

	escortPoints = {
		{patrolPointName = "naboo_privateer_tier4_escort_duty_1", zoneName = "space_endor", x = 3523, z = 400, y = -4024, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_escort_duty_2", zoneName = "space_endor", x = 2089, z = 4103, y = -4060, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_escort_duty_3", zoneName = "space_endor", x = 1396, z = 5751, y = -3946, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_escort_duty_4", zoneName = "space_endor", x = 817, z = 7127, y = -3851, escortNumber = 4, radius = 250},
	},

	attackDelay = 90, -- In Seconds

	attackShips = {
		{"borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4", "borvo_bomber_tier4"},
		{"borvo_defender_tier4", "borvo_defender_tier4", "borvo_defender_tier4", "borvo_defender_tier4"},
	},

	creditKillBonus = 300,
}

registerScreenPlay("escort_duty_naboo_privateer_tier4_1", true)

recovery_duty_naboo_privateer_tier4_1 = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_naboo_privateer_tier4_1",

	questName = "naboo_privateer_tier4_1",
	questType = "recovery_duty",

	questZone = "space_yavin4",

	creditReward = 5000,

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	arrivalDelay = 15,
	recoveryDelay = 24,

	recoverShip = "aynat_yacht_tier4",
	recoveryConversationMobile = "object/mobile/shared_dressed_nym_guard_elite_nikto_m.iff",

	escortShips = {"aynat_enforcer_tier4", "aynat_enforcer_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_escort_1", x = -397, z = 4235, y = 2013, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_escort_2", x = -1096, z = 2908, y = -340, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_escort_3", x = -1863, z = 2415, y = -2912, escortNumber = 3, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_escort_4", x = -3093, z = 1706, y = -6585, escortNumber = 4, radius = 250},
	},

	recoveryPoints = {
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_egress_1", x = -2157, z = -731, y = -5594, escortNumber = 1, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_egress_2", x = -491, z = -6021, y = -3466, escortNumber = 2, radius = 250},
		{patrolPointName = "naboo_privateer_tier4_recovery_duty_egress_3", x = 57, z = -7525, y = -2756, escortNumber = 3, radius = 250},
	},

	attackDelay = 90, -- In Seconds

	attackShips = {
		{"aynat_outlaw_tier4", "aynat_outlaw_tier4", "aynat_outlaw_tier4", "aynat_outlaw_tier4"},
		{"aynat_enforcer_tier4", "aynat_enforcer_tier4", "aynat_intimidator_tier4", "aynat_intimidator_tier4"},
		{"aynat_vaporizer_tier4", "aynat_vaporizer_tier4", "aynat_intimidator_tier4", "aynat_intimidator_tier4"},
	},

	killReward = 300,
}

registerScreenPlay("recovery_duty_naboo_privateer_tier4_1", true)

rescue_duty_naboo_privateer_tier4_1 = SpaceDutyRescueScreenplay:new {
	className = "rescue_duty_naboo_privateer_tier4_1",

	questName = "naboo_privateer_tier4_1",
	questType = "rescue_duty",

	questZone = "space_yavin4",

	creditReward = 0,

	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

}

registerScreenPlay("rescue_duty_naboo_privateer_tier4_1", true)

--[[
	RSF Squadron Screenplay
]]

RsfSquadronScreenplay = ScreenPlay:new {
	screenplayName = "RsfSquadronScreenplay",

	-- Tier 1 Quest Strings
	QUEST_STRING_1 = {type = "patrol", name = "naboo_privateer_1"},
	QUEST_STRING_1_SIDE = {type = "destroy_surpriseattack", name = "naboo_privateer_1"},
	QUEST_STRING_2 = {type = "destroy", name = "naboo_privateer_2"},
	QUEST_STRING_3 = {type = "patrol", name = "naboo_privateer_3"},
	QUEST_STRING_3_SIDE = {type = "escort", name = "naboo_privateer_3"},
	QUEST_STRING_4 = {type = "assassinate", name = "naboo_privateer_tier1_4a"},

	-- Tier 1 Duty Quest Strings
	QUEST_STRING_DUTY_4_1 = {type = "destroy_duty", name = "naboo_privateer_6"},
	QUEST_STRING_DUTY_4_2 = {type = "escort_duty", name = "naboo_privateer_7"},

	-- Tier 2 Quest Strings
	TIER2_QUEST_STRING_1 = {type = "destroy", name = "naboo_privateer_13a"},
	TIER2_QUEST_STRING_2 = {type = "escort", name = "naboo_privateer_14"},
	TIER2_QUEST_STRING_3 = {type = "inspect", name = "naboo_privateer_15"},
	TIER2_QUEST_STRING_4 = {type = "assassinate", name = "naboo_privateer_tier2_4a"},

	-- Tier 2 Duty Quest Strings
	TIER2_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_privateer_9"},
	TIER2_QUEST_STRING_DUTY_2 = {type = "escort_duty", name = "naboo_privateer_10"},
	TIER2_QUEST_STRING_DUTY_3 = {type = "destroy_duty", name = "naboo_privateer_11"},
	TIER2_QUEST_STRING_DUTY_4 = {type = "recovery_duty", name = "naboo_privateer_12"},

	-- Tier 3 Quest Strings
	TIER3_QUEST_STRING_1 = {type = "recovery", name = "naboo_privateer_tier3_1a"},
	TIER3_QUEST_STRING_1_SIDE1 = {type = "patrol", name = "naboo_privateer_tier3_1b"},
	TIER3_QUEST_STRING_1_SIDE2 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier3_1c"},
	TIER3_QUEST_STRING_1_SIDE3 = {type = "assassinate", name = "naboo_privateer_tier3_1d"},
	TIER3_QUEST_STRING_2 = {type = "escort", name = "naboo_privateer_tier3_2a"},
	TIER3_QUEST_STRING_2_SIDE1 = {type = "rescue", name = "naboo_privateer_tier3_2e"},
	TIER3_QUEST_STRING_2_SIDE2 = {type = "space_battle", name = "naboo_privateer_tier3_2d"},
	TIER3_QUEST_STRING_2_SIDE3 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier3_2c"},
	TIER3_QUEST_STRING_3 = {type = "inspect", name = "naboo_privateer_tier3_3a"},
	TIER3_QUEST_STRING_3_SIDE1 = {type = "delivery", name = "naboo_privateer_tier3_3b"},
	TIER3_QUEST_STRING_3_SIDE2 = {type = "survival", name = "naboo_privateer_tier3_3c"},
	TIER3_QUEST_STRING_3_SIDE3 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier3_3e"},
	TIER3_QUEST_STRING_4 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier3_4_initial"},
	TIER3_QUEST_STRING_4_SIDE1 = {type = "assassinate", name = "naboo_privateer_tier3_4a"},
	TIER3_QUEST_STRING_4_SIDE2 = {type = "space_battle", name = "naboo_privateer_tier3_4b"},
	TIER3_QUEST_STRING_4_SIDE3 = {type = "survival", name = "naboo_privateer_tier3_4c"},
	TIER3_QUEST_STRING_4_SIDE4 = {type = "assassinate", name = "naboo_privateer_tier3_4f"},

	-- Tier 4 Quest Strings
	TIER4_QUEST_STRING_1 = {type = "escort", name = "naboo_privateer_tier4_1a"},
	TIER4_QUEST_STRING_1_SIDE1 = {type = "escort", name = "naboo_privateer_tier4_1b"},
	TIER4_QUEST_STRING_2 = {type = "inspect", name = "naboo_privateer_tier4_2a"},
	TIER4_QUEST_STRING_2_SIDE1 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier4_2b"},
	TIER4_QUEST_STRING_2_SIDE2 = {type = "patrol", name = "naboo_privateer_tier4_2c"},
	TIER4_QUEST_STRING_2_SIDE3 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier4_2c"},
	TIER4_QUEST_STRING_2_SIDE4 = {type = "destroy_surpriseattack", name = "naboo_privateer_tier4_2d"},
	TIER4_QUEST_STRING_3 = {type = "delivery", name = "naboo_privateer_tier4_3a"},
	TIER4_QUEST_STRING_3_SIDE1 = {type = "patrol", name = "naboo_privateer_tier4_3b"},
	TIER4_QUEST_STRING_3_SIDE2 = {type = "survival", name = "naboo_privateer_tier4_3c"},
	TIER4_QUEST_STRING_4 = {type = "space_battle", name = "naboo_privateer_tier4_4a"},
	TIER4_QUEST_STRING_4_SIDE1 = {type = "escort", name = "naboo_privateer_tier4_4b"},
	TIER4_QUEST_STRING_4_SIDE2A = {type = "space_battle", name = "naboo_privateer_tier4_4c_win"},
	TIER4_QUEST_STRING_4_SIDE2B = {type = "space_battle", name = "naboo_privateer_tier4_4c_lose"},

	-- Tier 4 Duty Quest Strings
	TIER4_QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_2 = {type = "escort_duty", name = "naboo_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_3 = {type = "recovery_duty", name = "naboo_privateer_tier4_1"},
	TIER4_QUEST_STRING_DUTY_4 = {type = "rescue_duty", name = "naboo_privateer_tier4_1"},

	-- Master (Kessel corvette encounter -- RSF is Imperial-aligned, hunts the Rebel corvette)
	MASTER_QUEST_STRING = {type = "destroy", name = "master_imperial_1"},
	MASTER_QUEST_STRING_2 = {type = "destroy", name = "master_imperial_2"},
}

registerScreenPlay("RsfSquadronScreenplay", false)

function RsfSquadronScreenplay:start()
end

function RsfSquadronScreenplay:resetDingeQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):setPilotTier(1)

	-- Mission 1
	patrol_naboo_privateer_1:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1.type, self.QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_1_SIDE.type, self.QUEST_STRING_1_SIDE.name, false)

	-- Mission 2
	destroy_naboo_privateer_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_2.type, self.QUEST_STRING_2.name, false)

	-- Mission 3
	patrol_naboo_privateer_3:resetQuest(pPlayer)
	escort_naboo_privateer_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3.type, self.QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_3_SIDE.type, self.QUEST_STRING_3_SIDE.name, false)

	-- Mission 4
	assassinate_naboo_privateer_tier1_4a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_4.type, self.QUEST_STRING_4.name, false)

	-- Duty Missions
	destroy_duty_naboo_privateer_6:resetQuest(pPlayer)
	escort_duty_naboo_privateer_7:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DUTY_4_1.type, self.QUEST_STRING_DUTY_4_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DUTY_4_2.type, self.QUEST_STRING_DUTY_4_2.name, false)
end

function RsfSquadronScreenplay:resetKaydineQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local playerID = CreatureObject(pPlayer):getObjectID()

	PlayerObject(pGhost):setPilotTier(2)

	-- Mission 1
	destroy_naboo_privateer_13a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_1.type, self.TIER2_QUEST_STRING_1.name, false)

	-- Mission 2
	escort_naboo_privateer_14:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_2.type, self.TIER2_QUEST_STRING_2.name, false)

	-- Mission 3
	inspect_naboo_privateer_15:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_3.type, self.TIER2_QUEST_STRING_3.name, false)

	-- Mission 4
	assassinate_naboo_privateer_tier2_4a:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_4.type, self.TIER2_QUEST_STRING_4.name, false)

	-- Duty Missions
	destroy_duty_naboo_privateer_9:resetQuest(pPlayer)
	escort_duty_naboo_privateer_10:resetQuest(pPlayer)
	destroy_duty_naboo_privateer_11:resetQuest(pPlayer)
	recovery_duty_naboo_privateer_12:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_DUTY_1.type, self.TIER2_QUEST_STRING_DUTY_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_DUTY_2.type, self.TIER2_QUEST_STRING_DUTY_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_DUTY_3.type, self.TIER2_QUEST_STRING_DUTY_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER2_QUEST_STRING_DUTY_4.type, self.TIER2_QUEST_STRING_DUTY_4.name, false)

	-- Clear quest status tracking
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward")
end

function RsfSquadronScreenplay:resetDuliosQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local playerID = CreatureObject(pPlayer):getObjectID()

	PlayerObject(pGhost):setPilotTier(3)

	-- Mission 1
	recovery_naboo_privateer_tier3_1a:resetQuest(pPlayer)
	patrol_naboo_privateer_tier3_1b:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier3_1c:resetQuest(pPlayer)
	assassinate_naboo_privateer_tier3_1d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1.type, self.TIER3_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE1.type, self.TIER3_QUEST_STRING_1_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE2.type, self.TIER3_QUEST_STRING_1_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_1_SIDE3.type, self.TIER3_QUEST_STRING_1_SIDE3.name, false)

	-- Mission 2
	escort_naboo_privateer_tier3_2a:resetQuest(pPlayer)
	rescue_naboo_privateer_tier3_2e:resetQuest(pPlayer)
	space_battle_naboo_privateer_tier3_2d:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier3_2c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2.type, self.TIER3_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE1.type, self.TIER3_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE2.type, self.TIER3_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_2_SIDE3.type, self.TIER3_QUEST_STRING_2_SIDE3.name, false)

	-- Mission 3
	inspect_naboo_privateer_tier3_3a:resetQuest(pPlayer)
	delivery_naboo_privateer_tier3_3b:resetQuest(pPlayer)
	survival_naboo_privateer_tier3_3c:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier3_3e:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3.type, self.TIER3_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE1.type, self.TIER3_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE2.type, self.TIER3_QUEST_STRING_3_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_3_SIDE3.type, self.TIER3_QUEST_STRING_3_SIDE3.name, false)

	-- Mission 4
	destroy_surpriseattack_naboo_privateer_tier3_4_initial:resetQuest(pPlayer)
	assassinate_naboo_privateer_tier3_4a:resetQuest(pPlayer)
	space_battle_naboo_privateer_tier3_4b:resetQuest(pPlayer)
	survival_naboo_privateer_tier3_4c:resetQuest(pPlayer)
	assassinate_naboo_privateer_tier3_4f:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4.type, self.TIER3_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE1.type, self.TIER3_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE2.type, self.TIER3_QUEST_STRING_4_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE3.type, self.TIER3_QUEST_STRING_4_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER3_QUEST_STRING_4_SIDE4.type, self.TIER3_QUEST_STRING_4_SIDE4.name, false)

	-- Clear quest status tracking
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward")
end

function RsfSquadronScreenplay:resetDingeTier4Quests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):setPilotTier(4)

	-- Mission 1
	escort_naboo_privateer_tier4_1a:resetQuest(pPlayer)
	escort_naboo_privateer_tier4_1b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1.type, self.TIER4_QUEST_STRING_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_1_SIDE1.type, self.TIER4_QUEST_STRING_1_SIDE1.name, false)

	-- Mission 2
	inspect_naboo_privateer_tier4_2a:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier4_2b:resetQuest(pPlayer)
	patrol_naboo_privateer_tier4_2c:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier4_2c:resetQuest(pPlayer)
	destroy_surpriseattack_naboo_privateer_tier4_2d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2.type, self.TIER4_QUEST_STRING_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE1.type, self.TIER4_QUEST_STRING_2_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE2.type, self.TIER4_QUEST_STRING_2_SIDE2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE3.type, self.TIER4_QUEST_STRING_2_SIDE3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_2_SIDE4.type, self.TIER4_QUEST_STRING_2_SIDE4.name, false)

	-- Mission 3
	delivery_naboo_privateer_tier4_3a:resetQuest(pPlayer)
	patrol_naboo_privateer_tier4_3b:resetQuest(pPlayer)
	survival_naboo_privateer_tier4_3c:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3.type, self.TIER4_QUEST_STRING_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE1.type, self.TIER4_QUEST_STRING_3_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_3_SIDE2.type, self.TIER4_QUEST_STRING_3_SIDE2.name, false)

	-- Mission 4
	space_battle_naboo_privateer_tier4_4a:resetQuest(pPlayer)
	escort_naboo_privateer_tier4_4b:resetQuest(pPlayer)
	space_battle_naboo_privateer_tier4_4c_win:resetQuest(pPlayer)
	space_battle_naboo_privateer_tier4_4c_lose:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4.type, self.TIER4_QUEST_STRING_4.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE1.type, self.TIER4_QUEST_STRING_4_SIDE1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2A.type, self.TIER4_QUEST_STRING_4_SIDE2A.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.TIER4_QUEST_STRING_4_SIDE2B.type, self.TIER4_QUEST_STRING_4_SIDE2B.name, false)

	-- Master mission
	destroy_master_imperial_1:resetQuest(pPlayer)
	destroy_master_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.MASTER_QUEST_STRING.type, self.MASTER_QUEST_STRING.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.MASTER_QUEST_STRING_2.type, self.MASTER_QUEST_STRING_2.name, false)

	-- Clear quest status tracking
	local playerID = SceneObject(pPlayer):getObjectID()

	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward")
	removeQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward")
end

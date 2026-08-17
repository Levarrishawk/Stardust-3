local Logger = require("utils.logger")

--[[

	Kashyyyk Trandoshan Slaver Missions

]]

--[[
	Adjutant Rhosk chain -- space_battle -> destroy_surpriseattack -> recovery
]]

space_battle_ep3_slaver_rhosk_space_battle = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_slaver_rhosk_space_battle",

	questName = "ep3_slaver_rhosk_space_battle",
	questType = "space_battle",

	questZone = "space_kashyyyk",

	creditReward = 2500, -- ours, tier5 system pacing

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "ep3_slaver_rhosk_surprise_attack",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL,
	sideQuestDelay = 10,

	sideFailQuestType = "destroy_surpriseattack",
	sideFailQuestName = "ep3_slaver_rhosk_surprise_attack",

	-- Screenplay Specific Variables

	-- Intercept on the Kashyyyk -> Avatar Platform flightpath (all coordinates ours, no clientpoi row)
	battleLocation = {x = 2100, z = -450, y = -1200},

	supportShipsDelay = 30,
	enemyShipsDelay = 60,

	supportShips = {"wke_resist_tier4", "wke_resist_tier4", "wke_resist_tier4", "wke_resist_tier3"},
	enemyShips = {"trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier4", "trn_slaver_fighter_tier4", "trn_slaver_enforcer_tier5"},
}

registerScreenPlay("space_battle_ep3_slaver_rhosk_space_battle", true)

destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack",

	questName = "ep3_slaver_rhosk_surprise_attack",
	questType = "destroy_surpriseattack",

	questZone = "space_kashyyyk",

	creditReward = 1500, -- ours

	sideQuest = true,
	sideQuestType = "recovery",
	sideQuestName = "ep3_slaver_rhosk_recovery",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10,

	parentQuest = "space_battle_ep3_slaver_rhosk_space_battle",
	parentQuestType = "space_battle",
	parentQuestName = "ep3_slaver_rhosk_space_battle",

	-- Screenplay Specific Variables

	-- "One of the Adjutant's escort has responded" -- a single Blackscale house-guard element
	surpriseAttackShips = {
		zone = "space_kashyyyk",
		spawns = {{count = 1, shipName = "trn_slaver_enforcer_tier5"}, {count = 2, shipName = "trn_slaver_fighter_tier5"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack", true)

recovery_ep3_slaver_rhosk_recovery = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_slaver_rhosk_recovery",

	questName = "ep3_slaver_rhosk_recovery",
	questType = "recovery",

	questZone = "space_kashyyyk",

	creditReward = 4000, -- ours, chain terminus

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack",
	parentQuestType = "destroy_surpriseattack",
	parentQuestName = "ep3_slaver_rhosk_surprise_attack",

	-- Screenplay Specific Variables

	recoverShip = "trn_slaver_barge_tier5",
	recoveryConversationMobile = "object/mobile/shared_dressed_tatooine_trandoshan_slavemaster.iff",

	-- "Blackscale Rake" -- house guard, elite pilots
	escortShips = {"trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5"},

	-- attack_notify / attack_stopped ship blank in the client stf -- no reinforcement waves authored
	attackShips = {},

	arrivalDelay = 5,
	recoveryDelay = 5,

	escortSpeed = 20,
	testEscortSpeed = 40,

	-- Flightpath from Kashyyyk to the Avatar Platform (coordinates ours)
	preRecoveryPoints = {
		{patrolPointName = "rhosk_transport_1", zoneName = "space_kashyyyk", x = 4600, z = -1000, y = -2750, escortNumber = 1, radius = 150},
		{patrolPointName = "rhosk_transport_2", zoneName = "space_kashyyyk", x = 3400, z = -750, y = -2000, escortNumber = 2, radius = 150},
	},

	-- "Set the transport back on course to Kashyyyk"
	recoveryPoints = {
		{patrolPointName = "rhosk_return_1", zoneName = "space_kashyyyk", x = 2100, z = -450, y = -1200, escortNumber = 1, radius = 150},
		{patrolPointName = "rhosk_return_2", zoneName = "space_kashyyyk", x = 700, z = -150, y = -300, escortNumber = 2, radius = 150},
		{patrolPointName = "rhosk_return_3", zoneName = "space_kashyyyk", x = -2618, z = 70, y = 2624, escortNumber = 3, radius = 200},
	},
}

registerScreenPlay("recovery_ep3_slaver_rhosk_recovery", true)

--[[
	Commander Khrask / Slaver Lord Cyssc -- two parallel branches, named and unnamed
]]

space_battle_ep3_slaver_khrask_space_battle = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_slaver_khrask_space_battle",

	questName = "ep3_slaver_khrask_space_battle",
	questType = "space_battle",

	questZone = "space_kashyyyk",

	creditReward = 3000, -- ours

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "ep3_slaver_lord_cyssc_final",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL,
	sideQuestDelay = 10,

	sideFailQuestType = "assassinate",
	sideFailQuestName = "ep3_slaver_lord_cyssc_final",

	-- Screenplay Specific Variables

	-- "Ambush Point" -- calculated intercept on the Hss'kor inbound approach (coordinates ours)
	battleLocation = {x = 4200, z = 700, y = 2600},

	supportShipsDelay = 30,
	enemyShipsDelay = 60,

	-- "The last few resistance fighters in the system."
	supportShips = {"wke_resist_tier5", "wke_resist_tier4", "wke_resist_tier4"},

	-- "That is Commander Khrask. Watch your position, this is a trap!"
	enemyShips = {"trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5"},
}

registerScreenPlay("space_battle_ep3_slaver_khrask_space_battle", true)

space_battle_ep3_slaver_khrask_space_battle_alt = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_slaver_khrask_space_battle_alt",

	questName = "ep3_slaver_khrask_space_battle_alt",
	questType = "space_battle",

	questZone = "space_kashyyyk",

	creditReward = 3000, -- ours

	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "ep3_slaver_lord_cyssc_alt",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL,
	sideQuestDelay = 10,

	sideFailQuestType = "assassinate",
	sideFailQuestName = "ep3_slaver_lord_cyssc_alt",

	-- Screenplay Specific Variables

	-- Same ambush point, repeatable variant against the unnamed Blackscale Leader (coordinates ours)
	battleLocation = {x = 4200, z = 700, y = 2600},

	supportShipsDelay = 30,
	enemyShipsDelay = 60,

	supportShips = {"wke_resist_tier5", "wke_resist_tier4", "wke_resist_tier4"},

	-- "Blackscale Commander" -- unnamed counterpart of Khrask
	enemyShips = {"trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier4", "trn_slaver_fighter_tier4"},
}

registerScreenPlay("space_battle_ep3_slaver_khrask_space_battle_alt", true)

assassinate_ep3_slaver_lord_cyssc_final = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_slaver_lord_cyssc_final",

	questName = "ep3_slaver_lord_cyssc_final",
	questType = "assassinate",

	questZone = "space_kashyyyk",

	creditReward = 6000, -- ours, storyline terminus

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_ep3_slaver_khrask_space_battle",
	parentQuestType = "space_battle",
	parentQuestName = "ep3_slaver_khrask_space_battle",

	arrivalDelay = 6, -- Seconds
	failTimer = 25, -- Minutes

	-- Screenplay Specific Variables

	-- "Lord Cyssc travels in a modified heavy cruiser."
	-- "Commander Khrask and the Scale Guard" -- personal bodyguard, Khrask has joined for this journey
	assassinateSpawns = {
		target = "trn_slaver_barge_tier5",
		escorts = {"trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5"},
	},

	-- "Lord Cyssc will make for the Planets surface. He must not be allowed to land." (coordinates ours)
	targetPatrols = {
		{patrolPointName = "cyssc_approach_1", x = 5800, z = 1100, y = 3900},
		{patrolPointName = "cyssc_approach_2", x = 4200, z = 700, y = 2600},
		{patrolPointName = "cyssc_approach_3", x = 2600, z = 300, y = 1300},
		{patrolPointName = "cyssc_approach_4", x = 700, z = -150, y = -300},
	},
}

registerScreenPlay("assassinate_ep3_slaver_lord_cyssc_final", true)

assassinate_ep3_slaver_lord_cyssc_alt = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_slaver_lord_cyssc_alt",

	questName = "ep3_slaver_lord_cyssc_alt",
	questType = "assassinate",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours, repeatable variant

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "space_battle_ep3_slaver_khrask_space_battle_alt",
	parentQuestType = "space_battle",
	parentQuestName = "ep3_slaver_khrask_space_battle_alt",

	arrivalDelay = 6, -- Seconds
	failTimer = 25, -- Minutes

	-- Screenplay Specific Variables

	-- "The Blackscale Leader travels in a modified heavy cruiser."
	-- "A full wing of blackscale elite pilots will be escorting the blackscale leader to Kashyyyk."
	assassinateSpawns = {
		target = "trn_slaver_barge_tier5",
		escorts = {"trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5"},
	},

	targetPatrols = {
		{patrolPointName = "blackscale_approach_1", x = 5800, z = 1100, y = 3900},
		{patrolPointName = "blackscale_approach_2", x = 4200, z = 700, y = 2600},
		{patrolPointName = "blackscale_approach_3", x = 2600, z = 300, y = 1300},
		{patrolPointName = "blackscale_approach_4", x = 700, z = -150, y = -300},
	},
}

registerScreenPlay("assassinate_ep3_slaver_lord_cyssc_alt", true)

--[[
	Broodmaster Hss'kas -- Tatooine reinforcement intercept -> Kashyyyk arrival battle
]]

assassinate_ep3_slaver_trando_reinforcement_intercept = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_slaver_trando_reinforcement_intercept",

	-- Client stf titles this "Space Tatooine" and locates it at an old smuggler jump point
	-- at the far edge of the Tatooine system -- questZone follows the text, not the Kashyyyk default
	questName = "ep3_slaver_trando_reinforcement_intercept",
	questType = "assassinate",

	questZone = "space_tatooine",

	creditReward = 2500, -- ours

	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "ep3_slaver_hsskas_space_battle",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL,
	sideQuestDelay = 10,

	sideFailQuestType = "space_battle",
	sideFailQuestName = "ep3_slaver_hsskas_space_battle",

	arrivalDelay = 6, -- Seconds
	failTimer = 20, -- Minutes

	-- Screenplay Specific Variables

	-- "The flight leader has been destroyed, finish off the rest of his wing."
	assassinateSpawns = {
		target = "trn_slaver_fighter_tier5",
		escorts = {"trn_slaver_fighter_tier4", "trn_slaver_fighter_tier4", "trn_slaver_fighter_tier4", "trn_slaver_fighter_tier3"},
	},

	-- Far edge of the Tatooine system, old smuggler jump point (coordinates ours)
	targetPatrols = {
		{patrolPointName = "trando_reinforcement_1", x = 7100, z = 850, y = 6300},
		{patrolPointName = "trando_reinforcement_2", x = 6200, z = 700, y = 5400},
		{patrolPointName = "trando_reinforcement_3", x = 5300, z = 500, y = 4600},
	},
}

registerScreenPlay("assassinate_ep3_slaver_trando_reinforcement_intercept", true)

space_battle_ep3_slaver_hsskas_space_battle = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_slaver_hsskas_space_battle",

	questName = "ep3_slaver_hsskas_space_battle",
	questType = "space_battle",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours, chain terminus

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_ep3_slaver_trando_reinforcement_intercept",
	parentQuestType = "assassinate",
	parentQuestName = "ep3_slaver_trando_reinforcement_intercept",

	-- Screenplay Specific Variables

	-- "Hss'kas jumped close to the Avatar platform" -- no clientpoi row exists for the
	-- Avatar Platform, this position is ours
	battleLocation = {x = 5900, z = -1200, y = -3400},

	supportShipsDelay = 30,
	enemyShipsDelay = 45,

	-- "All resistance fighters that we were able to raise are moving in to attack."
	supportShips = {"wke_resist_tier5", "wke_resist_tier5", "wke_resist_tier4", "wke_resist_tier4", "wke_resist_tier3"},

	-- "this fight will be fierce" / "The resistance fighters will be outgunned"
	enemyShips = {"trn_slaver_barge_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5", "trn_slaver_fighter_tier5"},
}

registerScreenPlay("space_battle_ep3_slaver_hsskas_space_battle", true)

--[[
	Stren Dorn / Dorn Nerausu -- draw out the mining pirates, then collect
]]

assassinate_ep3_stren_dorn_lackey = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_stren_dorn_lackey",

	questName = "ep3_stren_dorn_lackey",
	questType = "assassinate",

	questZone = "space_kashyyyk",

	creditReward = 2000, -- ours

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "ep3_stren_dorn_bounty",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10,

	arrivalDelay = 6, -- Seconds
	failTimer = 20, -- Minutes

	-- Screenplay Specific Variables

	-- "Mining pirates suspected to be working with Dorn Nerausu."
	-- "The Pirates like to travel in packs. There is no telling how many you will encounter."
	assassinateSpawns = {
		target = "gotal_warlord_tier5",
		escorts = {"gotal_bandit_tier5", "gotal_bandit_tier5", "gotal_bandit_tier5", "gotal_bandit_tier4"},
	},

	-- "Track the pirates transponder signal in the Kashyyyk System."
	-- Endpoints are shipped clientpoi rows (Gotal Pirates' Base, organometallic asteroid);
	-- the two mid points are ours
	targetPatrols = {
		{patrolPointName = "dorn_lackey_1", x = -5950, z = 2700, y = 4575},
		{patrolPointName = "dorn_lackey_2", x = -5950, z = 1750, y = 3400},
		{patrolPointName = "dorn_lackey_3", x = -5950, z = 800, y = 2200},
		{patrolPointName = "dorn_lackey_4", x = -5951, z = -14, y = 1034},
	},
}

registerScreenPlay("assassinate_ep3_stren_dorn_lackey", true)

destroy_surpriseattack_ep3_stren_dorn_bounty = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_stren_dorn_bounty",

	questName = "ep3_stren_dorn_bounty",
	questType = "destroy_surpriseattack",

	questZone = "space_kashyyyk",

	creditReward = 4000, -- ours, bounty payout

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "assassinate_ep3_stren_dorn_lackey",
	parentQuestType = "assassinate",
	parentQuestName = "ep3_stren_dorn_lackey",

	-- Screenplay Specific Variables

	-- "The distress signal has brought Dorn out of hiding."
	surpriseAttackShips = {
		zone = "space_kashyyyk",
		spawns = {{count = 1, shipName = "gotal_warlord_tier5"}, {count = 2, shipName = "gotal_bandit_tier5"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_stren_dorn_bounty", true)

--[[
	Fezrik -- four leg smuggling run, Naboo -> Corellia -> Lok -> Lok
]]

--[[
	Fezrik smuggling chain.

	RESOLVED -- the three deliveryPoint values below were "<zone>:<point_name>" composite strings,
	which never resolve. Named space patrol points live in the ShipAgentTemplateManager Lua state
	(ShipAgentTemplateManager.cpp:22-23, loaded at :110) and DirectorManager registers no lookup
	binding, so a screenplay cannot turn that string into coordinates.
	SpaceDeliveryScreenplay:getLegLocation (:297-313) returns nil for a string and startLeg
	(:369-373) then spawns the freighter on the player after arrivalDelay -- completable, but with
	no approach waypoint and no rendezvous active area.

	They are now {x =, z =, y =} tables, taken from the patrol points that carry each quest's own
	name in each quest's own zone: ep3_trando_fezrik_01 (space_naboo.lua:157),
	ep3_trando_fezrik_02 (space_corellia.lua:105), ep3_trando_fezrik_03 (space_lok.lua:64).

	CAVEAT, STATED PLAINLY. Those three patrol points all carry the identical round coordinate
	(1000, 3000, -5000) and no "-- src:" provenance comment, unlike the Kashyyyk hunting points
	which do. They are our own placeholders, not Live-attested positions. The waypoint now works
	and the rendezvous sits in the correct system; the exact position is unverified.
]]

delivery_no_pickup_ep3_trando_fezrik_01 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_trando_fezrik_01",

	-- Client stf titles this "Naboo System" -- questZone follows the text
	questName = "ep3_trando_fezrik_01",
	questType = "delivery_no_pickup",

	questZone = "space_naboo",

	creditReward = 1000, -- ours

	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "ep3_trando_fezrik_02",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10,

	-- Screenplay Specific Variables

	-- "Meet the Rendal Trading Company's Ship" -- trade uller pelts for computer control chips
	deliveryShip = "freightermedium_tier3",
	deliveryPoint = {x = 1000, z = 3000, y = -5000}, -- space_naboo patrol point ep3_trando_fezrik_01 (space_naboo.lua:157); coords ours, not Live-attested

	attackDelay = 30,
	attackShips = {},
}

registerScreenPlay("delivery_no_pickup_ep3_trando_fezrik_01", true)

delivery_no_pickup_ep3_trando_fezrik_02 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_trando_fezrik_02",

	-- Client stf titles this "Corellian System" -- questZone follows the text
	questName = "ep3_trando_fezrik_02",
	questType = "delivery_no_pickup",

	questZone = "space_corellia",

	creditReward = 1200, -- ours

	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "ep3_trando_fezrik_03",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10,

	parentQuest = "delivery_no_pickup_ep3_trando_fezrik_01",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_trando_fezrik_01",

	-- Screenplay Specific Variables

	-- "Meet the Harkon Freighter" -- trade computer chips for blaster crystals
	deliveryShip = "freighterheavy_tier4",
	deliveryPoint = {x = 1000, z = 3000, y = -5000}, -- space_corellia patrol point ep3_trando_fezrik_02 (space_corellia.lua:105); coords ours, not Live-attested

	attackDelay = 30,
	attackShips = {},
}

registerScreenPlay("delivery_no_pickup_ep3_trando_fezrik_02", true)

delivery_no_pickup_ep3_trando_fezrik_03 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_trando_fezrik_03",

	-- Client stf titles this "Lok System" -- questZone follows the text
	questName = "ep3_trando_fezrik_03",
	questType = "delivery_no_pickup",

	questZone = "space_lok",

	creditReward = 1400, -- ours

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "ep3_trando_fezrik_04",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10,

	parentQuest = "delivery_no_pickup_ep3_trando_fezrik_02",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_trando_fezrik_02",

	-- Screenplay Specific Variables

	-- "Meet the Nym YT1300" -- trade blaster crystals for glitterdust with Nym's men
	deliveryShip = "yt1300_nym",
	deliveryPoint = {x = 1000, z = 3000, y = -5000}, -- space_lok patrol point ep3_trando_fezrik_03 (space_lok.lua:64); coords ours, not Live-attested

	attackDelay = 30,
	attackShips = {},
}

registerScreenPlay("delivery_no_pickup_ep3_trando_fezrik_03", true)

destroy_surpriseattack_ep3_trando_fezrik_04 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_trando_fezrik_04",

	-- Client stf titles this "Lok Space" -- questZone follows the text
	questName = "ep3_trando_fezrik_04",
	questType = "destroy_surpriseattack",

	questZone = "space_lok",

	creditReward = 3000, -- ours, chain terminus

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "delivery_no_pickup_ep3_trando_fezrik_03",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_trando_fezrik_03",

	-- Screenplay Specific Variables

	-- "a rival smuggling gang" / "Burch's men" -- no burch_* agents ship, so this uses the
	-- Lok native hostile family already spawned by the Lok spawner (ships ours)
	surpriseAttackShips = {
		zone = "space_lok",
		spawns = {{count = 1, shipName = "bloodrazor_destroyer_tier3"}, {count = 2, shipName = "bloodrazor_cutthroat_tier3"}, {count = 1, shipName = "blacksun_marauder_tier3"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_trando_fezrik_04", true)

--[[
	Boshaz -- escort a Zssik slave shuttle to the Avatar Platform
]]

escort_ep3_trando_boshaz_zssik_01 = SpaceEscortScreenplay:new {
	className = "escort_ep3_trando_boshaz_zssik_01",

	questName = "ep3_trando_boshaz_zssik_01",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 2500, -- ours

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- "protect a slave shuttle traveling between Kashyyyk and the Avatar Space Platform"
	escortShips = {"trn_slaver_barge_tier4"},

	escortRange = 1000,
	escortSpeed = 20,
	testEscortSpeed = 40,

	spawnAttackWaves = true,
	checkPlayerDistance = true,

	attackDelay = 30,

	-- Resistance interdiction of a slaver shuttle (ships and wave sizing ours)
	attackShips = {
		{"wke_resist_tier4", "wke_resist_tier4"},
		{"wke_resist_tier5", "wke_resist_tier4", "wke_resist_tier3"},
	},

	-- "The slave shuttle will meet you in orbit around Kashyyyk." then out to the Avatar's
	-- zone of control -- no clientpoi row exists for the Avatar Platform, positions are ours
	escortPoints = {
		{patrolPointName = "boshaz_escort_1", zoneName = "space_kashyyyk", x = 700, z = -150, y = -300, escortNumber = 1, radius = 150},
		{patrolPointName = "boshaz_escort_2", zoneName = "space_kashyyyk", x = 2100, z = -450, y = -1200, escortNumber = 2, radius = 150},
		{patrolPointName = "boshaz_escort_3", zoneName = "space_kashyyyk", x = 3400, z = -750, y = -2000, escortNumber = 3, radius = 150},
		{patrolPointName = "boshaz_escort_4", zoneName = "space_kashyyyk", x = 4600, z = -1000, y = -2750, escortNumber = 4, radius = 150},
		{patrolPointName = "boshaz_escort_5", zoneName = "space_kashyyyk", x = 5900, z = -1200, y = -3400, escortNumber = 5, radius = 200},
	},
}

registerScreenPlay("escort_ep3_trando_boshaz_zssik_01", true)

--[[
	Mosolium -- steal the Avatar Platform approach codes
]]

inspect_ep3_trando_mosolium_zssik_04 = SpaceInspectScreenplay:new {
	className = "inspect_ep3_trando_mosolium_zssik_04",

	questName = "ep3_trando_mosolium_zssik_04",
	questType = "inspect",

	questZone = "space_kashyyyk",

	creditReward = 3000, -- ours

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- "capture and inspect a Blackscale Flight Leader until you can locate one that has
	-- the approach codes for the Avatar Space Platform"
	inspectTargets = {"trn_slaver_fighter_tier5"},

	-- The gate is cargoString (NOT questLoot -- ShipAgentTemplate.h:169 getQuestLoot() has zero
	-- callers); trn_slaver_fighter_tier5.lua declares the matching cargoString.
	-- Key is CLIENT-ATTESTED: string/en/space/cargo.stf carries "avatar_landing_codes" =
	-- "Avatar Platform Landing Code" (no "avatar_approach_codes" row exists).
	inspectCargo = "avatar_landing_codes",

	-- Blackscale patrol short of the Avatar Platform (position ours)
	targetLocation = {x = 4600, z = -1000, y = -2750},
}

registerScreenPlay("inspect_ep3_trando_mosolium_zssik_04", true)

--[[
	Mssikss -- recover the collar freighter taken by the resistance
]]

recovery_ep3_trando_mssikss = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_trando_mssikss",

	questName = "ep3_trando_mssikss",
	questType = "recovery",

	questZone = "space_kashyyyk",

	creditReward = 3500, -- ours

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- "Mssikss has lost one of her freighters to the resistance fighters and wants it back."
	recoverShip = "trn_slaver_barge_tier4",
	recoveryConversationMobile = "object/mobile/shared_dressed_tatooine_trandoshan_slaver.iff",

	-- "I just want that freighter in one piece...kill everyone else."
	escortShips = {},

	attackDelay = 30,
	attackShips = {
		{"wke_resist_tier4", "wke_resist_tier4"},
		{"wke_resist_tier5", "wke_resist_tier4"},
	},

	arrivalDelay = 5,
	recoveryDelay = 5,

	escortSpeed = 20,
	testEscortSpeed = 40,

	-- Homing signal traced out past the Tyyyn cluster (positions ours except the
	-- shipped Kashyyyk Tyyyn Center and Tripp Outpost clientpoi rows)
	preRecoveryPoints = {
		{patrolPointName = "mssikss_signal_1", zoneName = "space_kashyyyk", x = -6200, z = -3500, y = -4500, escortNumber = 1, radius = 200},
		{patrolPointName = "mssikss_signal_2", zoneName = "space_kashyyyk", x = -4400, z = -2400, y = -2900, escortNumber = 2, radius = 150},
	},

	recoveryPoints = {
		{patrolPointName = "mssikss_return_1", zoneName = "space_kashyyyk", x = -3500, z = -1200, y = -800, escortNumber = 1, radius = 150},
		{patrolPointName = "mssikss_return_2", zoneName = "space_kashyyyk", x = -2618, z = 70, y = 2624, escortNumber = 2, radius = 200},
	},
}

registerScreenPlay("recovery_ep3_trando_mssikss", true)

--[[
	Lesnorr -- protect the slaver convoy to the Avatar Platform
]]

convoy_ep3_trando_lesnorr = SpaceConvoyScreenplay:new {
	className = "convoy_ep3_trando_lesnorr",

	questName = "ep3_trando_lesnorr",
	questType = "convoy",

	questZone = "space_kashyyyk",

	creditReward = 4000, -- ours

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- Multi vessel convoy -- the stf tracks per ship loss (convoy_ship_lost) and total
	-- loss (convoy_destroyed: "maybe losing one or two...but the whole thing?").
	-- SpaceConvoyScreenplay exists; convoyShips / convoyPoints are its own names (base table
	-- comment, SpaceConvoyScreenplay.lua:54-57) and are what getConvoyShips / getConvoyPoints
	-- prefer. escortShips / escortPoints remain accepted as aliases but are not used here.
	convoyShips = {"trn_slaver_barge_tier4", "trn_slaver_barge_tier4", "trn_slaver_barge_tier3"},

	escortRange = 1000,
	escortSpeed = 20,
	testEscortSpeed = 40,

	spawnAttackWaves = true,
	checkPlayerDistance = true,

	attackDelay = 30,

	-- Resistance ambush on the slaver convoy (ships and wave sizing ours)
	attackShips = {
		{"wke_resist_tier4", "wke_resist_tier4"},
		{"wke_resist_tier5", "wke_resist_tier4", "wke_resist_tier4"},
		{"wke_resist_tier5", "wke_resist_tier5"},
	},

	-- "on its way to the Avatar Space Platform" -- lane positions ours
	convoyPoints = {
		{patrolPointName = "lesnorr_convoy_1", zoneName = "space_kashyyyk", x = 700, z = -150, y = -300, escortNumber = 1, radius = 150},
		{patrolPointName = "lesnorr_convoy_2", zoneName = "space_kashyyyk", x = 2100, z = -450, y = -1200, escortNumber = 2, radius = 150},
		{patrolPointName = "lesnorr_convoy_3", zoneName = "space_kashyyyk", x = 3400, z = -750, y = -2000, escortNumber = 3, radius = 150},
		{patrolPointName = "lesnorr_convoy_4", zoneName = "space_kashyyyk", x = 4600, z = -1000, y = -2750, escortNumber = 4, radius = 150},
		{patrolPointName = "lesnorr_convoy_5", zoneName = "space_kashyyyk", x = 5900, z = -1200, y = -3400, escortNumber = 5, radius = 200},
	},
}

registerScreenPlay("convoy_ep3_trando_lesnorr", true)

--[[
	Independent Slavers -- duty contract, capture Trandoshan shuttles for the base
]]

recovery_duty_ep3_indie_slavers_recovery = SpaceDutyRecoveryScreenplay:new {
	className = "recovery_duty_ep3_indie_slavers_recovery",

	questName = "ep3_indie_slavers_recovery",
	questType = "recovery_duty",

	questZone = "space_kashyyyk",

	creditReward = 3000, -- ours

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- "Target one of the Trandoshan Slave Shuttle sub-components (engines or reactor)"
	recoverShip = "trn_slaver_barge_tier4",
	recoveryConversationMobile = "object/mobile/shared_dressed_tatooine_trandoshan_slaver.iff",

	-- "the Trandoshans aren't going to just let you do this. Expect a lot of resistance."
	escortShips = {"trn_slaver_fighter_tier4", "trn_slaver_fighter_tier4"},

	attackDelay = 30,
	attackShips = {
		{"trn_slaver_fighter_tier5", "trn_slaver_fighter_tier4"},
		{"trn_slaver_enforcer_tier5", "trn_slaver_fighter_tier5"},
	},

	arrivalDelay = 5,
	recoveryDelay = 5,

	escortSpeed = 20,
	testEscortSpeed = 40,

	-- "Head toward the Avatar Platform and intercept Trandoshan Slave Shuttles before
	-- they reach their destinations." (lane positions ours)
	preRecoveryPoints = {
		{patrolPointName = "indie_intercept_1", zoneName = "space_kashyyyk", x = 3400, z = -750, y = -2000, escortNumber = 1, radius = 150},
		{patrolPointName = "indie_intercept_2", zoneName = "space_kashyyyk", x = 4600, z = -1000, y = -2750, escortNumber = 2, radius = 150},
	},

	-- "Escort the Transport to the Independent Slavers' base" -- final point is the shipped
	-- kashyyyk_independent_slavers clientpoi row, the two lead in points are ours
	recoveryPoints = {
		{patrolPointName = "indie_return_1", zoneName = "space_kashyyyk", x = 0, z = -600, y = 500, escortNumber = 1, radius = 150},
		{patrolPointName = "indie_return_2", zoneName = "space_kashyyyk", x = -3500, z = -450, y = 2400, escortNumber = 2, radius = 150},
		{patrolPointName = "indie_return_3", zoneName = "space_kashyyyk", x = -6830, z = -350, y = 4200, escortNumber = 3, radius = 200},
	},
}

registerScreenPlay("recovery_duty_ep3_indie_slavers_recovery", true)

KashyyykSlaverScreenplay = ScreenPlay:new {
	screenplayName = "KashyyykSlaverScreenplay",

	DEBUG_KASH_SLAVER = false,

	-- Adjutant Rhosk
	QUEST_STRING_RHOSK_1 = {type = "space_battle", name = "ep3_slaver_rhosk_space_battle"},
	QUEST_STRING_RHOSK_2 = {type = "destroy_surpriseattack", name = "ep3_slaver_rhosk_surprise_attack"},
	QUEST_STRING_RHOSK_3 = {type = "recovery", name = "ep3_slaver_rhosk_recovery"},

	-- Commander Khrask / Slaver Lord Cyssc
	QUEST_STRING_CYSSC_1 = {type = "space_battle", name = "ep3_slaver_khrask_space_battle"},
	QUEST_STRING_CYSSC_2 = {type = "assassinate", name = "ep3_slaver_lord_cyssc_final"},
	QUEST_STRING_CYSSC_ALT_1 = {type = "space_battle", name = "ep3_slaver_khrask_space_battle_alt"},
	QUEST_STRING_CYSSC_ALT_2 = {type = "assassinate", name = "ep3_slaver_lord_cyssc_alt"},

	-- Broodmaster Hss'kas
	QUEST_STRING_HSSKAS_1 = {type = "assassinate", name = "ep3_slaver_trando_reinforcement_intercept"},
	QUEST_STRING_HSSKAS_2 = {type = "space_battle", name = "ep3_slaver_hsskas_space_battle"},

	-- Stren Dorn
	QUEST_STRING_DORN_1 = {type = "assassinate", name = "ep3_stren_dorn_lackey"},
	QUEST_STRING_DORN_2 = {type = "destroy_surpriseattack", name = "ep3_stren_dorn_bounty"},

	-- Fezrik
	QUEST_STRING_FEZRIK_1 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_01"},
	QUEST_STRING_FEZRIK_2 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_02"},
	QUEST_STRING_FEZRIK_3 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_03"},
	QUEST_STRING_FEZRIK_4 = {type = "destroy_surpriseattack", name = "ep3_trando_fezrik_04"},

	-- Standalone contracts
	QUEST_STRING_BOSHAZ = {type = "escort", name = "ep3_trando_boshaz_zssik_01"},
	QUEST_STRING_MOSOLIUM = {type = "inspect", name = "ep3_trando_mosolium_zssik_04"},
	QUEST_STRING_MSSIKSS = {type = "recovery", name = "ep3_trando_mssikss"},
	QUEST_STRING_LESNORR = {type = "convoy", name = "ep3_trando_lesnorr"},
	QUEST_STRING_INDIE = {type = "recovery_duty", name = "ep3_indie_slavers_recovery"},
}

registerScreenPlay("KashyyykSlaverScreenplay", false)

function KashyyykSlaverScreenplay:start()
end

function KashyyykSlaverScreenplay:resetRhoskQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	space_battle_ep3_slaver_rhosk_space_battle:resetQuest(pPlayer)
	destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack:resetQuest(pPlayer)
	recovery_ep3_slaver_rhosk_recovery:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_RHOSK_1.type, self.QUEST_STRING_RHOSK_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_RHOSK_2.type, self.QUEST_STRING_RHOSK_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_RHOSK_3.type, self.QUEST_STRING_RHOSK_3.name, false)
end

function KashyyykSlaverScreenplay:resetCysscQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	space_battle_ep3_slaver_khrask_space_battle:resetQuest(pPlayer)
	assassinate_ep3_slaver_lord_cyssc_final:resetQuest(pPlayer)
	space_battle_ep3_slaver_khrask_space_battle_alt:resetQuest(pPlayer)
	assassinate_ep3_slaver_lord_cyssc_alt:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_CYSSC_1.type, self.QUEST_STRING_CYSSC_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_CYSSC_2.type, self.QUEST_STRING_CYSSC_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_CYSSC_ALT_1.type, self.QUEST_STRING_CYSSC_ALT_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_CYSSC_ALT_2.type, self.QUEST_STRING_CYSSC_ALT_2.name, false)
end

function KashyyykSlaverScreenplay:resetHsskasQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	assassinate_ep3_slaver_trando_reinforcement_intercept:resetQuest(pPlayer)
	space_battle_ep3_slaver_hsskas_space_battle:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_HSSKAS_1.type, self.QUEST_STRING_HSSKAS_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_HSSKAS_2.type, self.QUEST_STRING_HSSKAS_2.name, false)
end

function KashyyykSlaverScreenplay:resetDornQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	assassinate_ep3_stren_dorn_lackey:resetQuest(pPlayer)
	destroy_surpriseattack_ep3_stren_dorn_bounty:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DORN_1.type, self.QUEST_STRING_DORN_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DORN_2.type, self.QUEST_STRING_DORN_2.name, false)
end

function KashyyykSlaverScreenplay:resetFezrikQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	delivery_no_pickup_ep3_trando_fezrik_01:resetQuest(pPlayer)
	delivery_no_pickup_ep3_trando_fezrik_02:resetQuest(pPlayer)
	delivery_no_pickup_ep3_trando_fezrik_03:resetQuest(pPlayer)
	destroy_surpriseattack_ep3_trando_fezrik_04:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_FEZRIK_1.type, self.QUEST_STRING_FEZRIK_1.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_FEZRIK_2.type, self.QUEST_STRING_FEZRIK_2.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_FEZRIK_3.type, self.QUEST_STRING_FEZRIK_3.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_FEZRIK_4.type, self.QUEST_STRING_FEZRIK_4.name, false)
end

function KashyyykSlaverScreenplay:resetContractQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	escort_ep3_trando_boshaz_zssik_01:resetQuest(pPlayer)
	inspect_ep3_trando_mosolium_zssik_04:resetQuest(pPlayer)
	recovery_ep3_trando_mssikss:resetQuest(pPlayer)
	convoy_ep3_trando_lesnorr:resetQuest(pPlayer)
	recovery_duty_ep3_indie_slavers_recovery:resetQuest(pPlayer)

	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_BOSHAZ.type, self.QUEST_STRING_BOSHAZ.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_MOSOLIUM.type, self.QUEST_STRING_MOSOLIUM.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_MSSIKSS.type, self.QUEST_STRING_MSSIKSS.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_LESNORR.type, self.QUEST_STRING_LESNORR.name, false)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_INDIE.type, self.QUEST_STRING_INDIE.name, false)
end

function KashyyykSlaverScreenplay:resetAllQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:resetRhoskQuests(pPlayer)
	self:resetCysscQuests(pPlayer)
	self:resetHsskasQuests(pPlayer)
	self:resetDornQuests(pPlayer)
	self:resetFezrikQuests(pPlayer)
	self:resetContractQuests(pPlayer)
end

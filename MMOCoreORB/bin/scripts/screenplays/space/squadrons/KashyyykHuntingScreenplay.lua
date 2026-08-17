--[[

	Kashyyyk Rodian Hunter Missions

	Kerssoc, Banol Starkiller, Ziven, Tripp, Chrilooc, Kara, Sordaan and Fordan Szholz,
	operating out of Sordaan's and Tripp's Rodian Hunter Outposts.

]]

--[[
	Kerssoc -- pelt smuggling chain

	delivery_no_pickup ep3_hunting_kerssoc_smuggle_goods
		-> escort ep3_hunting_kerssoc_supplies
		-> assassinate ep3_hunting_kerssoc_destroy_chiss_weapons

	Both links are attested by the :split_quest_alert strings in the client .stf files.

	KNOWN DEGRADE -- every deliveryPoint in this file is the in-tree "<zone>:<point_name>"
	composite string (same convention the upstream squadron files use). Named space patrol
	points are loaded by ShipAgentTemplateManager.cpp:110 into that manager's own Lua state
	(ShipAgentTemplateManager.cpp:22-23), and DirectorManager registers no lookup binding, so a
	screenplay cannot turn that string into coordinates. SpaceDeliveryScreenplay:getLegLocation
	(SpaceDeliveryScreenplay.lua:297-313) type-checks the point and returns nil for a string, and
	startLeg (SpaceDeliveryScreenplay.lua:369-373) then spawns the freighter on the player after
	arrivalDelay. Result: the quest is completable, but with no approach waypoint and no
	rendezvous active area. Replace the string with a {x =, z =, y =} table to restore the
	waypoint -- that path is already implemented and needs no code change.
]]

delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods",

	questName = "ep3_hunting_kerssoc_smuggle_goods",
	questType = "delivery_no_pickup",

	questZone = "space_corellia", -- STF quest_location_t: "Corellia system."

	creditReward = 8000, -- ours, .stf autoreward fields are empty

	-- STF split_quest_alert: "Kerssoc has another task for you. Head to the Kashyyyk system and escort some inbound supplies."
	sideQuest = true,
	sideQuestType = "escort",
	sideQuestName = "ep3_hunting_kerssoc_supplies",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	deliveryShip = "freightermedium_tier4",
	deliveryPoint = "space_corellia:ep3_hunting_kerssoc_smuggle_goods_delivery",

	attackDelay = 60, -- ours

	-- STF quest_rendezvous2_d: "Try to avoid any bandits or poachers in the area."
	attackShips = {
		{"chiss_poacher_tier4", "chiss_poacher_tier4"},
		{"chiss_poacher_tier4", "chiss_poacher_bomber_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods", true)

escort_ep3_hunting_kerssoc_supplies = SpaceEscortScreenplay:new {
	className = "escort_ep3_hunting_kerssoc_supplies",

	questName = "ep3_hunting_kerssoc_supplies",
	questType = "escort",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 10000, -- ours

	-- STF split_quest_alert: "Kerssoc wants you to destroy a shipment of weaponry for the Chiss poaches on Kashyyyk."
	sideQuest = true,
	sideQuestType = "assassinate",
	sideQuestName = "ep3_hunting_kerssoc_destroy_chiss_weapons",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	parentQuest = "delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_hunting_kerssoc_smuggle_goods",

	-- Screenplay Specific Variables

	-- STF title_d: "protect an inbound freighter bearing supplies"
	escortShips = {"freightermedium_tier4"},

	-- Inbound from the system edge to Kerssoc's zone of control at Tripp's Rodian Hunter Outpost.
	-- Kerssoc's affiliation with Tripp's outpost is ours; the .stf does not name an outpost.
	escortPoints = {
		{patrolPointName = "kash_hunting_kerssoc_supplies_1", zoneName = "space_kashyyyk", x = -6000, z = -800, y = -1200, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_kerssoc_supplies_2", zoneName = "space_kashyyyk", x = -4800, z = -500, y = 400, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_kerssoc_supplies_3", zoneName = "space_kashyyyk", x = -3600, z = -200, y = 1600, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_kerssoc_supplies_4", zoneName = "space_kashyyyk", x = -2618, z = 70, y = 2624, escortNumber = 4, radius = 250}, -- Tripp's Rodian Hunter Outpost (clientpoi)
	},

	attackDelay = 90, -- ours

	-- STF panic_1: "Incoming pirates!"; taunt_4 references the Rryatt Trail -- Wookiee pirates.
	attackShips = {
		{"wke_pirate_tier4", "wke_pirate_tier4", "wke_pirate_tier5"},
		{"wke_pirate_tier4", "wke_pirate_tier5"},
	},

	-- Counts match the populated numbered keys in the client .stf
	tauntData = {
		goodbyeCount = 1,
		reasonCount = 1,
		tauntCount = 4,
		thanksCount = 2,
	},
}

registerScreenPlay("escort_ep3_hunting_kerssoc_supplies", true)

assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons",

	questName = "ep3_hunting_kerssoc_destroy_chiss_weapons",
	questType = "assassinate",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System."

	creditReward = 12000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "escort_ep3_hunting_kerssoc_supplies",
	parentQuestType = "escort",
	parentQuestName = "ep3_hunting_kerssoc_supplies",

	-- Screenplay Specific Variables

	arrivalDelay = 6, -- ours
	failTimer = 20, -- Minutes, ours

	-- STF quest_target_t: "Destroy the Chiss Poacher Ace."; quest_escort_t: "Destroy the other Chiss fighters."
	assassinateSpawns = {
		target = "chiss_poacher_tier5",
		escorts = {"chiss_poacher_tier4", "chiss_poacher_tier4", "chiss_poacher_bomber_tier4"},
	},

	-- Weapons shipment inbound for the Chiss poachers on Kashyyyk; route terminates at their base.
	targetPatrols = {
		{patrolPointName = "kash_hunting_chiss_weapons_1", x = -3800, z = 1200, y = 1400}, -- ours, spawn point
		{patrolPointName = "kash_hunting_chiss_weapons_2", x = -5200, z = 1000, y = 1700}, -- ours
		{patrolPointName = "kash_hunting_chiss_weapons_3", x = -6825, z = 763, y = 2065}, -- Chiss Poachers' Base (clientpoi)
	},
}

registerScreenPlay("assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons", true)

--[[
	Kara -- poacher delivery chain

	delivery_no_pickup ep3_hunting_kara_poacher_delivery_01 (Dantooine)
		-> _02 (Tatooine)
		-> _03 (Dathomir)

	Sequenced by the :split_quest_alert strings, which name the next system explicitly.
]]

delivery_no_pickup_ep3_hunting_kara_poacher_delivery_01 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_hunting_kara_poacher_delivery_01",

	questName = "ep3_hunting_kara_poacher_delivery_01",
	questType = "delivery_no_pickup",

	questZone = "space_dantooine", -- STF quest_location_t: "Dantooine System."

	creditReward = 8000, -- ours

	-- STF split_quest_alert: "Your next delivery is in the Tatooine System."
	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "ep3_hunting_kara_poacher_delivery_02",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	deliveryShip = "freightermedium_tier4",
	deliveryPoint = "space_dantooine:ep3_hunting_kara_poacher_delivery_01_delivery",

	attackDelay = 60, -- ours

	-- STF quest_rendezvous2_d: "Try to avoid any bandits or pirates in the area."
	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_ep3_hunting_kara_poacher_delivery_01", true)

delivery_no_pickup_ep3_hunting_kara_poacher_delivery_02 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_hunting_kara_poacher_delivery_02",

	questName = "ep3_hunting_kara_poacher_delivery_02",
	questType = "delivery_no_pickup",

	questZone = "space_tatooine", -- STF quest_location_t: "Tatooine System."

	creditReward = 9000, -- ours

	-- STF split_quest_alert: "Your next delivery is in the Dathomir System."
	sideQuest = true,
	sideQuestType = "delivery_no_pickup",
	sideQuestName = "ep3_hunting_kara_poacher_delivery_03",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 5,

	parentQuest = "delivery_no_pickup_ep3_hunting_kara_poacher_delivery_01",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_hunting_kara_poacher_delivery_01",

	-- Screenplay Specific Variables

	deliveryShip = "freightermedium_tier4",
	deliveryPoint = "space_tatooine:ep3_hunting_kara_poacher_delivery_02_delivery",

	attackDelay = 60, -- ours

	attackShips = {
		{"blacksun_fighter_s01_tier4", "blacksun_fighter_s02_tier4"},
		{"blacksun_fighter_s02_tier4", "blacksun_bomber_s01_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_ep3_hunting_kara_poacher_delivery_02", true)

delivery_no_pickup_ep3_hunting_kara_poacher_delivery_03 = SpaceDeliveryNoPickupScreenplay:new {
	className = "delivery_no_pickup_ep3_hunting_kara_poacher_delivery_03",

	questName = "ep3_hunting_kara_poacher_delivery_03",
	questType = "delivery_no_pickup",

	questZone = "space_dathomir", -- STF quest_location_t: "Dathomir System."

	creditReward = 10000, -- ours

	-- Chain terminus. STF split_quest_alert is empty and docking_complete_delivery says
	-- "You should go speak to her yourself." -- the follow-up is a conversation, not a split.
	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "delivery_no_pickup_ep3_hunting_kara_poacher_delivery_02",
	parentQuestType = "delivery_no_pickup",
	parentQuestName = "ep3_hunting_kara_poacher_delivery_02",

	-- Screenplay Specific Variables

	deliveryShip = "freightermedium_tier4",
	deliveryPoint = "space_dathomir:ep3_hunting_kara_poacher_delivery_03_delivery",

	attackDelay = 60, -- ours

	attackShips = {
		{"blacksun_fighter_s02_tier4", "blacksun_marauder_tier4"},
		{"blacksun_fighter_s01_tier4", "blacksun_bomber_s01_tier4", "blacksun_marauder_tier4"},
	},
}

registerScreenPlay("delivery_no_pickup_ep3_hunting_kara_poacher_delivery_03", true)

--[[
	Tripp -- shipment protection
]]

escort_ep3_hunting_tripp_protect_shipment = SpaceEscortScreenplay:new {
	className = "escort_ep3_hunting_tripp_protect_shipment",

	questName = "ep3_hunting_tripp_protect_shipment",
	questType = "escort",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 10000, -- ours

	-- STF complete promises a further task but :split_quest_alert is EMPTY, so no split is wired.
	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF arrived_at_loc: "One of her ace pilots is carrying it."
	escortShips = {"rod_protector_ace_tier5"},

	-- Outbound from Tripp's Rodian Hunter Outpost until the shipment leaves the system.
	escortPoints = {
		{patrolPointName = "kash_hunting_tripp_shipment_1", zoneName = "space_kashyyyk", x = -2618, z = 70, y = 2624, escortNumber = 1, radius = 250}, -- Tripp's Rodian Hunter Outpost (clientpoi)
		{patrolPointName = "kash_hunting_tripp_shipment_2", zoneName = "space_kashyyyk", x = -1200, z = 500, y = 3600, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_tripp_shipment_3", zoneName = "space_kashyyyk", x = 600, z = 900, y = 4900, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_tripp_shipment_4", zoneName = "space_kashyyyk", x = 2400, z = 1300, y = 6200, escortNumber = 4, radius = 250}, -- ours
	},

	attackDelay = 90, -- ours

	-- STF title_d: "Prior shipments are being intercepted or destroyed." The .stf does not
	-- name the attacker; Banol's raids on Tripp's shipments make Sordaan's Rodians ours.
	attackShips = {
		{"rod_protector_tier4", "rod_protector_tier4"},
		{"rod_protector_tier5", "rod_protector_tier4"},
	},

	-- Every numbered taunt key in this .stf is blank; counts held at 1.
	tauntData = {
		goodbyeCount = 1,
		reasonCount = 1,
		tauntCount = 1,
		thanksCount = 1,
	},
}

registerScreenPlay("escort_ep3_hunting_tripp_protect_shipment", true)

--[[
	Banol Starkiller -- raids on Tripp, and the capture of Fordan Szholz for Sordaan
]]

assassinate_ep3_hunting_banol_destroy_tripps_goods = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_hunting_banol_destroy_tripps_goods",

	questName = "ep3_hunting_banol_destroy_tripps_goods",
	questType = "assassinate",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System."

	creditReward = 12000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 6, -- ours
	failTimer = 20, -- Minutes, ours

	-- STF quest_target_t: "Destroy Tripp's ace pilot."; quest_escort_t: "Destroy the escort ships."
	assassinateSpawns = {
		target = "rod_protector_ace_tier5",
		escorts = {"rod_protector_tier4", "rod_protector_tier4", "rod_protector_tier5"},
	},

	-- Tripp's outbound shipment of mouf pelts and incisors, leaving her outpost.
	targetPatrols = {
		{patrolPointName = "kash_hunting_tripps_goods_1", x = -2618, z = 70, y = 2624}, -- Tripp's Rodian Hunter Outpost (clientpoi), spawn point
		{patrolPointName = "kash_hunting_tripps_goods_2", x = -1400, z = 400, y = 3400}, -- ours
		{patrolPointName = "kash_hunting_tripps_goods_3", x = 200, z = 900, y = 4200}, -- ours
		{patrolPointName = "kash_hunting_tripps_goods_4", x = 1800, z = 1400, y = 5000}, -- ours
	},
}

registerScreenPlay("assassinate_ep3_hunting_banol_destroy_tripps_goods", true)

recovery_ep3_hunting_banol_capture_fordan = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_hunting_banol_capture_fordan",

	questName = "ep3_hunting_banol_capture_fordan",
	questType = "recovery",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk system."

	creditReward = 15000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 12, -- ours
	recoveryDelay = 18, -- ours

	-- STF: Fordan Szholz, a highly skilled Rodian hunter of Ziven's clan.
	recoverShip = "rod_protector_ace_tier5",
	recoveryConversationMobile = "object/mobile/shared_dressed_criminal_thug_rodian_male_01.iff", -- ours; no named Fordan mobile exists

	escortShips = {"rod_protector_tier4", "rod_protector_tier4"},

	-- STF quest_location_d: "Await the arrival of Fordan and his escort in the Kashyyyk System."
	preRecoveryPoints = {
		{patrolPointName = "kash_hunting_capture_fordan_1", x = -1000, z = 1800, y = 6400, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_capture_fordan_2", x = 0, z = 2200, y = 5800, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_capture_fordan_3", x = 1200, z = 2600, y = 5100, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_capture_fordan_4", x = 2000, z = 2900, y = 4500, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF title_d: "deliver them to Banol's agents in space" -- Banol works out of Sordaan's outpost.
	recoveryPoints = {
		{patrolPointName = "kash_hunting_capture_fordan_5", x = 2300, z = 3100, y = 4200, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_capture_fordan_6", x = 2556, z = 3225, y = 3890, escortNumber = 2, radius = 250}, -- Sordaan's Rodian Hunter Outpost (clientpoi)
		{patrolPointName = "kash_hunting_capture_fordan_7", x = 3400, z = 3400, y = 3200, escortNumber = 3, radius = 250}, -- ours; where the ship is stripped and abandoned
	},

	attackDelay = 75, -- ours

	-- STF quest_escort_d: "Fordan's fighters will attempt to again disable the ship"
	attackShips = {
		{"rod_protector_tier4", "rod_protector_tier4", "rod_protector_tier5"},
		{"rod_protector_tier4", "rod_protector_tier5"},
	},

	-- Counts match the populated numbered keys in the client .stf
	tauntData = {
		panicCount = 2,
		thanksCount = 2,
	},
}

registerScreenPlay("recovery_ep3_hunting_banol_capture_fordan", true)

--[[
	Ziven -- the search for Fordan, and reprisals against Sordaan
]]

rescue_ep3_hunting_ziven_fordans_ship = SpaceRescueScreenplay:new {
	className = "rescue_ep3_hunting_ziven_fordans_ship",

	questName = "ep3_hunting_ziven_fordans_ship",
	questType = "rescue",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 15000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- ours

	-- STF rescue_phase_1: "The ship looks abandoned and heavily damaged."
	rescueShip = "rod_protector_ace_tier5",
	-- Where Banol's agents stripped and abandoned her -- matches the last recoveryPoint of
	-- recovery_ep3_hunting_banol_capture_fordan. Coordinate is ours.
	rescueLocation = {x = 3400, z = 3400, y = 3200},

	repairDelay = 30, -- ours

	-- STF quest_escort_d: "Escort Fordan's ship to a safe location where a more thorough scan
	-- of it can be attempted." Ziven's people work out of Tripp's outpost (ours).
	escortPoints = {
		{patrolPointName = "kash_hunting_fordans_ship_1", zoneName = "space_kashyyyk", x = 1800, z = 2600, y = 3600, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_fordans_ship_2", zoneName = "space_kashyyyk", x = 0, z = 1600, y = 3200, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_fordans_ship_3", zoneName = "space_kashyyyk", x = -1400, z = 700, y = 2900, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_fordans_ship_4", zoneName = "space_kashyyyk", x = -2618, z = 70, y = 2624, escortNumber = 4, radius = 250}, -- Tripp's Rodian Hunter Outpost (clientpoi)
	},

	escortSpeed = 20,

	attackDelay = 20, -- ours

	-- The .stf names no attacker; taunt_1 "The stars belong to us! Die!" reads as pirates (ours).
	attackShips = {
		{{count = 2, shipName = "wke_pirate_tier4"}},
	},

	escortAttackDelay = 25, -- ours
	escortAttackShips = {
		{{count = 2, shipName = "wke_pirate_tier4"}, {count = 1, shipName = "wke_pirate_tier5"}},
	},

	-- Every numbered panic/thanks key in this .stf is blank; counts held at 1.
	tauntData = {
		panicCount = 1,
		thanksCount = 1,
	},
}

registerScreenPlay("rescue_ep3_hunting_ziven_fordans_ship", true)

assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01 = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01",

	questName = "ep3_hunting_ziven_vs_sordaans_freighter_01",
	questType = "assassinate",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System."

	creditReward = 12000, -- ours

	-- STF :split_quest_alert is empty; the step to _02 is a conversation, not an engine split.
	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 6, -- ours
	failTimer = 20, -- Minutes, ours

	-- STF quest_target_t: "Destroy Sordaan's freighter."; quest_escort_t: "Destroy the escort ships."
	assassinateSpawns = {
		target = "freighterheavy_tier4",
		escorts = {"rod_protector_tier4", "rod_protector_tier4"},
	},

	-- STF quest_location_d: "One of Sordaan's freighters is preparing to leave the system."
	targetPatrols = {
		{patrolPointName = "kash_hunting_sordaan_freighter_01_1", x = 2556, z = 3225, y = 3890}, -- Sordaan's Rodian Hunter Outpost (clientpoi), spawn point
		{patrolPointName = "kash_hunting_sordaan_freighter_01_2", x = 3600, z = 3000, y = 4800}, -- ours
		{patrolPointName = "kash_hunting_sordaan_freighter_01_3", x = 4900, z = 2600, y = 5700}, -- ours
		{patrolPointName = "kash_hunting_sordaan_freighter_01_4", x = 6200, z = 2200, y = 6400}, -- ours
	},
}

registerScreenPlay("assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01", true)

assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02 = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02",

	questName = "ep3_hunting_ziven_vs_sordaans_freighter_02",
	questType = "assassinate",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System."

	creditReward = 15000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01",
	parentQuestType = "assassinate",
	parentQuestName = "ep3_hunting_ziven_vs_sordaans_freighter_01",

	-- Screenplay Specific Variables

	arrivalDelay = 6, -- ours
	failTimer = 20, -- Minutes, ours

	-- STF title_d: "Be ready for a tougher fight this time. Sordaan is bounded to have
	-- increased his freighter's protection." -- heavier escort than _01.
	assassinateSpawns = {
		target = "freighterheavy_tier4",
		escorts = {"rod_protector_tier5", "rod_protector_tier5", "rod_protector_ace_tier5"},
	},

	-- STF quest_location_d: "Another of Sordaan's freighters is preparing to leave the system."
	targetPatrols = {
		{patrolPointName = "kash_hunting_sordaan_freighter_02_1", x = 2556, z = 3225, y = 3890}, -- Sordaan's Rodian Hunter Outpost (clientpoi), spawn point
		{patrolPointName = "kash_hunting_sordaan_freighter_02_2", x = 3300, z = 3600, y = 2900}, -- ours
		{patrolPointName = "kash_hunting_sordaan_freighter_02_3", x = 4400, z = 4000, y = 1700}, -- ours
		{patrolPointName = "kash_hunting_sordaan_freighter_02_4", x = 5800, z = 4300, y = 500}, -- ours
	},
}

registerScreenPlay("assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02", true)

--[[
	Chrilooc -- intercepting Gotal bandits
]]

recovery_ep3_hunting_chrilooc_medical_supplies = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_hunting_chrilooc_medical_supplies",

	questName = "ep3_hunting_chrilooc_medical_supplies",
	questType = "recovery",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk system."

	creditReward = 15000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 12, -- ours
	recoveryDelay = 18, -- ours

	-- STF quest_disable_t: "Disable the Gotal bandit ace's ship."
	recoverShip = "gotal_warlord_tier5",
	recoveryConversationMobile = "object/mobile/shared_dressed_criminal_thug_zabrak_male_01.iff", -- ours; no Gotal mobile exists in this tree

	escortShips = {"gotal_bandit_tier5", "gotal_bandit_tier4"},

	-- STF quest_location_d: "Await the Gotal bandit ace." Route out of the Gotal Pirates' Base.
	preRecoveryPoints = {
		{patrolPointName = "kash_hunting_chrilooc_medical_1", x = -5950, z = 2700, y = 4575, escortNumber = 1, radius = 250}, -- The Gotal Pirates' Base (clientpoi)
		{patrolPointName = "kash_hunting_chrilooc_medical_2", x = -4800, z = 2400, y = 3800, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_chrilooc_medical_3", x = -3600, z = 2000, y = 3000, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_chrilooc_medical_4", x = -2400, z = 1600, y = 2200, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF quest_escort_d: "Escort the captured ship to a safe hyperspace jump point."
	-- STF complete: "From here the medical supplies can be safely transported to the planet's surface."
	recoveryPoints = {
		{patrolPointName = "kash_hunting_chrilooc_medical_5", x = -3000, z = 1000, y = 800, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_chrilooc_medical_6", x = -3800, z = 700, y = -1400, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_chrilooc_medical_7", x = -4500, z = 400, y = -3400, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_hunting_chrilooc_medical_8", x = -5000, z = 250, y = -5000, escortNumber = 4, radius = 250}, -- Kashyyyk Space Station (clientpoi)
	},

	attackDelay = 75, -- ours

	-- STF quest_escort_d: "Other Gotal bandits fighters will attempt to again disable the ship"
	attackShips = {
		{"gotal_bandit_tier4", "gotal_bandit_tier4", "gotal_bandit_tier5"},
		{"gotal_bandit_tier5", "gotal_bandit_tier5"},
	},

	-- Counts match the populated numbered keys in the client .stf
	tauntData = {
		panicCount = 2,
		thanksCount = 2,
	},
}

registerScreenPlay("recovery_ep3_hunting_chrilooc_medical_supplies", true)

--[[
	Avatar Platform -- station defenses
]]

destroy_surpriseattack_ep3_avatar_defensive_attack = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_avatar_defensive_attack",

	questName = "ep3_avatar_defensive_attack",
	questType = "destroy_surpriseattack",

	questZone = "space_kashyyyk",

	creditReward = 0, -- no reward; this is a punishment encounter

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- STF title_d: triggered by failing to comply with the Avatar Space Platform's demands,
	-- which is a station conversation, not a predecessor quest.
	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF title_d: "an attack by the stations defensive fighters". The .stf does not name the
	-- ship type and no Avatar Platform ship agent exists; the Wookiee resistance agents are ours.
	surpriseAttackShips = {
		zone = "space_kashyyyk",
		spawns = {{count = 2, shipName = "wke_resist_tier4"}, {count = 1, shipName = "wke_resist_tier5"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_avatar_defensive_attack", true)

--[[
	Wookiee resistance -- the stolen bowcaster parts
]]

inspect_ep3_wke_bowcaster_crafting = SpaceInspectScreenplay:new {
	className = "inspect_ep3_wke_bowcaster_crafting",

	questName = "ep3_wke_bowcaster_crafting",
	questType = "inspect",

	questZone = "space_kashyyyk", -- STF title: "Kashyyyk System: Recover Missing Bowcaster Pieces"

	creditReward = 10000, -- ours

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF title_d: "a member of the Wookiee resistance stole a box of parts ... launched off of
	-- Kashyyyk but apparently is having some engine problems"
	-- wke_resist_tier3 is the shared Resistance B-wing used as filler in many attackShips lists and
	-- declares no cargoString, so the inspect could never pass veryifyShipTargetAndCargo(). The
	-- purpose-built courier wke_resist_tier3_bowcaster_parts.lua carries the matching cargoString.
	inspectTargets = {"wke_resist_tier3_bowcaster_parts"},
	inspectCargo = "ep3_wke_bowcaster_parts", -- ours; the .stf carries no cargo identifier

	targetLocation = {x = -1800, z = 500, y = 900}, -- ours; the .stf gives no coordinate
}

registerScreenPlay("inspect_ep3_wke_bowcaster_crafting", true)

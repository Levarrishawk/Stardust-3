local Logger = require("utils.logger")

--[[

	Kashyyyk System -- Mining Series, Corvette Recovery Series and Clone Relics Space Battles

	Every quest in this file was placed here because its own .stf string file names the Kashyyyk
	system in quest_location_t / quest_location_d. STF evidence is quoted inline above each entry.

	Anything not stated by the .stf text (exact coordinates, credit values, timers, ship agent
	choices) is marked "-- ours".

	Depends on base classes: SpaceConvoyScreenplay, SpaceMiningDestroyScreenplay, SpaceBattleScreenplay.

]]

--[[
	Mining Series -- Captain Koh (Kashyyyk)

	NOTE: the shipped string tree only contains kashyyyk_mining_quest_5, _8, _11 and _12 (plus
	kessel_mining_quest_13, handled in KesselDutyScreenplay.lua). The missing numbers were never
	shipped in this tree and are deliberately NOT invented here.
]]

-- kashyyyk_mining_quest_5
-- STF title: "Kashyyyk System:  Extract 500 Units of Organometallic Asteroid"
-- STF title_d: "The Kashyyyk system has a number of organometallic asteroids in it.  Mine 500 units
--               and return to Captain Koh on Kashyyyk."
-- STF quest_location_t: "Kashyyyk System"

space_mining_destroy_kashyyyk_mining_quest_5 = SpaceMiningDestroyScreenplay:new {
	className = "space_mining_destroy_kashyyyk_mining_quest_5",

	questName = "kashyyyk_mining_quest_5",
	questType = "space_mining_destroy",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 8000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	resourceType = "organometallic", -- STF title: "Organometallic Asteroid"
	unitsRequired = 500, -- STF title: "Extract 500 Units"

	asteroidLocations = {
		{patrolPointName = "kash_mining_5_field_1", x = -3200, z = 600, y = 4100}, -- ours
		{patrolPointName = "kash_mining_5_field_2", x = -1800, z = 1100, y = 5300}, -- ours
		{patrolPointName = "kash_mining_5_field_3", x = -400, z = 1500, y = 6200}, -- ours
	},

	attackDelay = 0, -- STF names no attackers for this quest
	attackShips = {},
}

registerScreenPlay("space_mining_destroy_kashyyyk_mining_quest_5", true)

-- kashyyyk_mining_quest_8
-- STF title: "Kashyyyk System:  Broad Sample Part I"
-- STF title_d: "...Your first target are the organometallic asteroids of Kashyyyk.  Harvest 125
--               units and proceed from there."
-- STF split_quest_alert: "Captain Koh:  < Well done, pilot.  Now head to Endor to collect 125 units
--                         of icy asteroid. >"
--   GAP: the follow-on Endor icy-asteroid quest ("Broad Sample Part II") does NOT exist in this
--   string tree. sideQuest is therefore left false rather than pointing at a non-existent quest.

space_mining_destroy_kashyyyk_mining_quest_8 = SpaceMiningDestroyScreenplay:new {
	className = "space_mining_destroy_kashyyyk_mining_quest_8",

	questName = "kashyyyk_mining_quest_8",
	questType = "space_mining_destroy",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 3000, -- ours
	itemReward = {},

	sideQuest = false, -- see GAP note above
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	resourceType = "organometallic", -- STF title_d: "the organometallic asteroids of Kashyyyk"
	unitsRequired = 125, -- STF title_d: "Harvest 125 units"

	asteroidLocations = {
		{patrolPointName = "kash_mining_8_field_1", x = 2400, z = -900, y = -3600}, -- ours
		{patrolPointName = "kash_mining_8_field_2", x = 3900, z = -400, y = -2200}, -- ours
	},

	attackDelay = 0, -- STF names no attackers for this quest
	attackShips = {},
}

registerScreenPlay("space_mining_destroy_kashyyyk_mining_quest_8", true)

-- kashyyyk_mining_quest_11
-- STF title: "Kashyyyk System:  Protect the Y-8 Convoy"
-- STF title_d: "Meet up with the Y-8 Mining Vessel convoy, and escort them through a dangerous area
--               of space to a convenient hyperspace beacon."
-- STF quest_escort_d: "Escort the Y-8 Convoy to their destination.  Be wary of attacking Gotal bandits."
-- STF quest_rendezvous_t: "Rendezvous with the Y-8 convoy."

convoy_kashyyyk_mining_quest_11 = SpaceConvoyScreenplay:new {
	className = "convoy_kashyyyk_mining_quest_11",

	questName = "kashyyyk_mining_quest_11",
	questType = "convoy",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 12000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF: "Y-8 Mining Vessel convoy" -- no Y-8 ship agent exists in this tree, so the convoy is
	-- built from the generic freighter agents. -- ours
	convoyShips = {"freighterheavy_tier4", "freightermedium_tier4", "freighterlight_tier4"},

	-- STF quest_rendezvous_d: "Head to the beginning waypoint to rendezvous with the Y-8 ship convoy."
	convoyPoints = {
		{patrolPointName = "kash_mining_11_convoy_1", zoneName = "space_kashyyyk", x = -5200, z = -700, y = -4600, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_mining_11_convoy_2", zoneName = "space_kashyyyk", x = -3400, z = -200, y = -3100, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_mining_11_convoy_3", zoneName = "space_kashyyyk", x = -1100, z = 400, y = -1500, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_mining_11_convoy_4", zoneName = "space_kashyyyk", x = 1600, z = 900, y = 200, escortNumber = 4, radius = 250}, -- ours
		{patrolPointName = "kash_mining_11_convoy_5", zoneName = "space_kashyyyk", x = 4300, z = 1300, y = 2000, escortNumber = 5, radius = 250}, -- ours; hyperspace beacon
	},

	escortSpeed = 20, -- ours
	testEscortSpeed = 40, -- ours

	attackDelay = 75, -- ours

	-- STF quest_escort_d: "Be wary of attacking Gotal bandits."
	attackShips = {
		{"gotal_bandit_tier4", "gotal_bandit_tier4", "gotal_bandit_tier5"},
		{"gotal_bandit_tier5", "gotal_warlord_tier4"},
	},

	-- STF has panic_1..5, panic_destroyed_1..5, taunt_1..5 and thanks_1..5, but NO goodbye_* or
	-- reason_* keys.
	tauntData = {
		panicCount = 5,
		panicDestroyedCount = 5,
		tauntCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("convoy_kashyyyk_mining_quest_11", true)

-- kashyyyk_mining_quest_12
-- STF title: "Kashyyyk System:  Intercept the Gilded Wookiee"
-- STF title_d: "Intercept the mining vessel 'The Gilded Wookiee' as it tries to use the path you
--               cleared previously for the mining convoy to leave the zone."
-- STF quest_escort_t: "Destroy The Gilded Wookiee's Escort"

assassinate_kashyyyk_mining_quest_12 = SpaceAssassinateScreenplay:new {
	className = "assassinate_kashyyyk_mining_quest_12",

	questName = "kashyyyk_mining_quest_12",
	questType = "assassinate",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk System"

	creditReward = 15000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 10, -- ours
	failTimer = 25, -- ours (minutes)

	assassinateSpawns = {
		-- STF: the target is a mining vessel, not a fighter. -- ours (no named Gilded Wookiee agent exists)
		target = "freighterheavy_tier4",
		-- STF quest_escort_d: "Destroy all the escort ships guarding the mining vessel."
		escorts = {"gotal_bandit_tier4", "gotal_bandit_tier4", "gotal_bandit_tier5"},
	},

	-- STF title_d: it uses "the path you cleared previously for the mining convoy", so the flight
	-- path deliberately re-uses the quest 11 corridor. -- ours
	targetPatrols = {
		{patrolPointName = "kash_mining_12_intercept_1", x = -3400, z = -200, y = -3100}, -- ours
		{patrolPointName = "kash_mining_12_intercept_2", x = -1100, z = 400, y = -1500}, -- ours
		{patrolPointName = "kash_mining_12_intercept_3", x = 1600, z = 900, y = 200}, -- ours
		{patrolPointName = "kash_mining_12_intercept_4", x = 4300, z = 1300, y = 2000}, -- ours
	},
}

registerScreenPlay("assassinate_kashyyyk_mining_quest_12", true)

--[[
	Stolen Corvette Recovery Series (Kashyyyk)

	All three of these are Corellian Corvette recoveries per their own .stf text. The quest NAMES
	("heavy_xwing", "blacksun_heavy", "red_tie") encode the original chassis reward, but the client
	strings themselves never mention a chassis -- see the reward notes on each entry.
]]

-- ep3_heavy_xwing_recovery
-- STF title: "Stolen Corvette - Help a skeleton crew of Alliance engineers recover a Corellian Corvette."
-- STF arrival_phase_1: "We have detected the Corellian corvette and its Ghrag mercenary escorts
--                       coming out of hyperspace..."
-- STF quest_escort_t: "Escort the Corvette to the Rebel Outpost"
--
-- REWARD: station_rebel_outpost.stf s_815 ("a heavy version of the X-wing fighter") / s_850 promise
-- the pilot the prototype heavy X-wing. The client ships that ship under the name "advanced_xwing":
-- shared_advanced_xwing_reward_deed.iff / shared_advanced_xwing_pcd.iff / shared_player_advanced_xwing.iff
-- all exist in the TREs, @space_crafting_n:advanced_xwing_reward_deed is "Advanced X-Wing Deed", and
-- the client's own badge table ties this quest to that ship
-- (collection_n.stf|bdg_kash_rebel_heavy_xwing|"Quest: Rebel Heavy X-Wing Starfighter").
-- The deed is granted here, on quest completion; species {-1} is the only entry because there is no
-- species axis to this reward. Chain: object/tangible/ship/crafted/chassis/advanced_xwing_reward_deed.lua
-- -> object/intangible/ship/advanced_xwing_pcd.lua -> object/ship/player/player_advanced_xwing.lua.

recovery_ep3_heavy_xwing_recovery = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_heavy_xwing_recovery",

	questName = "ep3_heavy_xwing_recovery",
	questType = "recovery",

	questZone = "space_kashyyyk", -- STF quest_location_t: "The Kashyyyk system"

	creditReward = 25000, -- ours
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/crafted/chassis/advanced_xwing_reward_deed.iff"},
	}, -- see REWARD above

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 14, -- ours
	recoveryDelay = 20, -- ours

	-- STF: the recovered vessel is a stolen Alliance Corellian Corvette.
	recoverShip = "reb_corellian_corvette_tier4",
	-- STF capture_started: "A handful of engineers are our only chance to re-take the bridge..."
	recoveryConversationMobile = "object/mobile/dressed_rebel_commando_moncal_male_01.iff", -- ours; no named engineer mobile exists

	-- STF arrival_phase_1: "...and its Ghrag mercenary escorts"
	escortShips = {"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "kash_heavy_xwing_recovery_1", x = 5100, z = -1200, y = 4400, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_heavy_xwing_recovery_2", x = 4200, z = -900, y = 3300, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_heavy_xwing_recovery_3", x = 3100, z = -500, y = 2100, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_heavy_xwing_recovery_4", x = 1900, z = -100, y = 900, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF quest_escort_d: "Escort the vessel to the Rebel Outpost."
	recoveryPoints = {
		{patrolPointName = "kash_heavy_xwing_recovery_5", x = 400, z = 300, y = -700, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_heavy_xwing_recovery_6", x = -1400, z = 700, y = -2200, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_heavy_xwing_recovery_7", x = -3100, z = 1000, y = -3600, escortNumber = 3, radius = 250}, -- ours; Rebel Outpost
	},

	escortSpeed = 20, -- ours
	testEscortSpeed = 40, -- ours

	attackDelay = 100, -- ours

	-- STF attack_notify: "Ghrag fighters incoming!"
	attackShips = {
		{"ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_persuader_tier4"},
		{"ghrag_assassin_tier5", "ghrag_avenger_tier5"},
	},

	-- STF has panic_1..5 and thanks_1..5.
	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("recovery_ep3_heavy_xwing_recovery", true)

-- ep3_blacksun_heavy_recovery
-- STF title: "Stolen Corvette - Prevent a Corellian Corvette from being used against the Civilian
--             Protection Guild"
-- STF quest_escort_t: "Escort the Corvette to the Kashyyyk Space Station"
-- STF quest_update: "Rian Ry: <%TO>"
--
-- REWARD NOTE: the .stf text never names a chassis reward. The quest NAME encodes a Black Sun heavy
-- chassis, and unlike the X-wing case that chassis DOES exist in this tree
-- (object/tangible/ship/crafted/chassis/blacksun_heavy_s01_deed.iff, registered in that folder's
-- serverobjects.lua; player_blacksun_heavy_s01 is in ChassisDealer.ships_table under
-- cert_starships_heavyblacksunfighter). Granting the deed is OURS, not client-attested.

recovery_ep3_blacksun_heavy_recovery = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_blacksun_heavy_recovery",

	questName = "ep3_blacksun_heavy_recovery",
	questType = "recovery",

	questZone = "space_kashyyyk", -- STF quest_location_t: "The Kashyyyk system"

	creditReward = 25000, -- ours
	itemReward = {
		-- ours; see REWARD NOTE above. Deed template verified present + registered.
		{species = {-1}, item = "object/tangible/ship/crafted/chassis/blacksun_heavy_s01_deed.iff"},
	},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 14, -- ours
	recoveryDelay = 20, -- ours

	recoverShip = "reb_corellian_corvette_tier4", -- STF: a stolen Corellian Corvette
	-- STF capture_started: "The chief engineer and few hands from the engine room..."
	recoveryConversationMobile = "object/mobile/dressed_rebel_commando_moncal_male_01.iff", -- ours; no named Rian Ry mobile exists

	-- STF arrival_phase_1: "...and its Ghrag mercenary escorts"
	escortShips = {"ghrag_merc_tier4", "ghrag_persuader_tier4", "ghrag_assassin_tier4"},

	preRecoveryPoints = {
		{patrolPointName = "kash_blacksun_heavy_recovery_1", x = -5600, z = 1400, y = 3800, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_blacksun_heavy_recovery_2", x = -4400, z = 1100, y = 2700, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_blacksun_heavy_recovery_3", x = -3100, z = 800, y = 1600, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_blacksun_heavy_recovery_4", x = -1800, z = 500, y = 500, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF quest_escort_d: "Escort the vessel to the Kashyyyk Space Station."
	recoveryPoints = {
		{patrolPointName = "kash_blacksun_heavy_recovery_5", x = -600, z = 200, y = -600, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_blacksun_heavy_recovery_6", x = 900, z = -100, y = -1900, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_blacksun_heavy_recovery_7", x = 2400, z = -400, y = -3200, escortNumber = 3, radius = 250}, -- ours; Kashyyyk Space Station approach
	},

	escortSpeed = 20, -- ours
	testEscortSpeed = 40, -- ours

	attackDelay = 100, -- ours

	-- STF attack_notify: "Ghrag fighters incoming!"
	attackShips = {
		{"ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_merc_tier5"},
		{"ghrag_avenger_tier5", "ghrag_assassin_tier5"},
	},

	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("recovery_ep3_blacksun_heavy_recovery", true)

-- ep3_red_tie_recovery
-- STF title: "Hidden Sabers - Help an Imperial Operative slice the navicomputer of an Alliance Corvette"
-- STF arrival_phase_1: "An Alliance Corvette Convoy is moving through this system. You must
--                       intercept and recover the command ship."
-- STF quest_escort_d: "Escort the ship to a strategic jump-point located near the Imperial Overseers base."
--
-- REWARD: station_imperial_base.stf s_356 / s_266 promise the "'Crimson Guard' TIE Interceptor". The
-- client ships that variant under the name "tieinterceptor_imperial_guard":
-- shared_tieinterceptor_imperial_guard_reward_deed.iff / shared_tieinterceptor_imperial_guard_pcd.iff
-- / shared_player_tieinterceptor_imperial_guard.iff all exist in the TREs,
-- @space_crafting_n:tieinterceptor_imperial_guard_reward_deed is "TIE Interceptor (Imperial Guard)
-- Deed", and the client's own badge table ties this quest to that ship
-- (collection_n.stf|bdg_kash_imperial_red_tie|"Quest: Imperial Guard TIE Interceptor").
-- The deed is granted here, on quest completion; species {-1} is the only entry because there is no
-- species axis to this reward. Chain:
-- object/tangible/ship/crafted/chassis/tieinterceptor_imperial_guard_reward_deed.lua ->
-- object/intangible/ship/tieinterceptor_imperial_guard_pcd.lua ->
-- object/ship/player/player_tieinterceptor_imperial_guard.lua.

recovery_ep3_red_tie_recovery = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_red_tie_recovery",

	questName = "ep3_red_tie_recovery",
	questType = "recovery",

	questZone = "space_kashyyyk", -- STF quest_location_t: "The Kashyyyk system"

	creditReward = 25000, -- ours (STF autorewardsubject: "Payment for an Outstanding Job!")
	itemReward = {
		{species = {-1}, item = "object/tangible/ship/crafted/chassis/tieinterceptor_imperial_guard_reward_deed.iff"},
	}, -- see REWARD above

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 14, -- ours
	recoveryDelay = 20, -- ours

	recoverShip = "reb_corellian_corvette_tier4", -- STF: the Alliance Corvette command ship
	-- STF capture_started: "I will make my way to the bridge" -- the hidden Imperial Operative (female).
	recoveryConversationMobile = "object/mobile/dressed_imperial_officer_f.iff", -- ours; no named Operative mobile exists

	-- STF arrival_phase_1: "An Alliance Corvette Convoy" -- the convoy elements escort the command ship.
	escortShips = {"reb_xwing_tier4", "reb_xwing_tier5", "reb_awing_tier5"},

	-- STF quest_location_d: "...they will try to use the asteroids and nebulae in Rodian-controlled
	-- space as camouflage."
	preRecoveryPoints = {
		{patrolPointName = "kash_red_tie_recovery_1", x = -2618, z = 70, y = 2624, escortNumber = 1, radius = 250}, -- ours; Rodian-controlled space
		{patrolPointName = "kash_red_tie_recovery_2", x = -1300, z = 500, y = 1500, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_red_tie_recovery_3", x = 100, z = 900, y = 400, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "kash_red_tie_recovery_4", x = 1500, z = 1200, y = -700, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF quest_escort_d: "...a strategic jump-point located near the Imperial Overseers base."
	recoveryPoints = {
		{patrolPointName = "kash_red_tie_recovery_5", x = 3000, z = 1500, y = -2000, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "kash_red_tie_recovery_6", x = 4600, z = 1800, y = -3400, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "kash_red_tie_recovery_7", x = 6100, z = 2000, y = -4700, escortNumber = 3, radius = 250}, -- ours; Imperial Overseer jump-point
	},

	escortSpeed = 20, -- ours
	testEscortSpeed = 40, -- ours

	attackDelay = 100, -- ours

	-- STF attack_notify: "Rebel Fighters incoming!"
	attackShips = {
		{"reb_xwing_tier5", "reb_awing_tier5", "reb_ywing_tier5"},
		{"reb_bwing_tier5", "reb_xwing_tier5"},
	},

	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("recovery_ep3_red_tie_recovery", true)

--[[
	Clone Relics -- Jedi Starfighter arc, phases IV and V

	ZONE FINDING: both of these are KASHYYYK quests, not Kessel. STF quest_location_t reads
	"Kashyyyk system." and quest_location_d reads "The Kashyyyk system is not heavily controlled by
	any force..." for both. They live in this file for that reason.
]]

-- ep3_clone_relics_jedi_starfighter_4
-- STF title: "Kashyyyk system: Defeating an invasion."
-- STF quest_findbattle_d: "Meet up with the Imperial fleet at these coordinates."
-- STF quest_helpallies_d: "Lord Vader has put you in command of the attack."
-- STF split_quest_alert: "Lord Vader: < Their transports are yours young one, destroy them. >"
--   -- this is the client-attested hand-off into jedi_starfighter_5.

space_battle_ep3_clone_relics_jedi_starfighter_4 = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_clone_relics_jedi_starfighter_4",

	questName = "ep3_clone_relics_jedi_starfighter_4",
	questType = "space_battle",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk system."

	creditReward = 20000, -- ours
	itemReward = {},

	-- STF split_quest_alert names the follow-on quest explicitly.
	sideQuest = true,
	sideQuestType = "space_battle",
	sideQuestName = "ep3_clone_relics_jedi_starfighter_5",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 10, -- ours (seconds)

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF found_loc: "Proceed to this location immediately."
	-- Coordinate order is the tree-wide (x, z, y) convention.
	battleLocation = {patrolPointName = "kash_relics_jedi_sf_4_battle", x = 2900, z = -1600, y = -5200}, -- ours

	supportShipsDelay = 60, -- ours
	enemyShipsDelay = 90, -- ours

	-- STF allies_arrived: "Your fleet has arrived young one, take command." (Imperial fleet)
	supportShips = {"imp_tie_interceptor_tier5", "imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5", "imp_tie_advanced_tier5"},

	-- STF quest_helpallies_d / title_d: "breach through the Rebel fighter defense"
	enemyShips = {"reb_xwing_tier5", "reb_xwing_tier5", "reb_awing_tier5", "reb_bwing_tier5", "reb_ywing_tier5"},
}

registerScreenPlay("space_battle_ep3_clone_relics_jedi_starfighter_4", true)

-- ep3_clone_relics_jedi_starfighter_5
-- STF title: "Kashyyyk system: Finishing the job."
-- STF found_loc: "The TIE Bomber squadron will be at this location."
-- STF allies_arrived: "Your TIE Bombers have arrived, finish the job."
-- STF enemies_remain: "Imperial Squadron Leader: < Transport destroyed. %DI more to go. >"

space_battle_ep3_clone_relics_jedi_starfighter_5 = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_clone_relics_jedi_starfighter_5",

	questName = "ep3_clone_relics_jedi_starfighter_5",
	questType = "space_battle",

	questZone = "space_kashyyyk", -- STF quest_location_t: "Kashyyyk system."

	creditReward = 25000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "space_battle_ep3_clone_relics_jedi_starfighter_4",
	parentQuestType = "space_battle",
	parentQuestName = "ep3_clone_relics_jedi_starfighter_4",

	-- Screenplay Specific Variables

	battleLocation = {patrolPointName = "kash_relics_jedi_sf_5_battle", x = 4400, z = -1900, y = -6300}, -- ours

	supportShipsDelay = 60, -- ours
	enemyShipsDelay = 90, -- ours

	-- STF: "Your TIE Bombers have arrived"
	supportShips = {"imp_tie_bomber_tier5", "imp_tie_bomber_tier5", "imp_tie_bomber_tier5", "imp_tie_interceptor_tier5"},

	-- STF: "destroy the troop transports"
	enemyShips = {"reb_transport_tier5", "reb_transport_tier5", "reb_transport_tier5", "reb_xwing_tier5", "reb_awing_tier5"},
}

registerScreenPlay("space_battle_ep3_clone_relics_jedi_starfighter_5", true)

local Logger = require("utils.logger")

--[[

	Kessel System -- Duty Missions and Mining, plus the Clone Relics quests that arrive via the
	Kessel chain but are set in OTHER systems.

	ZONE FINDINGS (all determined from each quest's own .stf quest_location_t / title):
	  * kessel_rebel_tier5, kessel_imperial_tier5, kessel_pirate_tier6, kessel_mining_quest_13
	    -> Kessel (space_light1).
	  * ep3_clone_relics_boba_fett_2      -> "Dantooine system."  -> space_dantooine  [NOT Kessel]
	  * ep3_clone_relics_boba_fett_3      -> "Dantooine system: Defeat the ambush." -> space_dantooine  [NOT Kessel]
	  * ep3_clone_relics_queen_3          -> "Dathomir system."   -> space_dathomir   [NOT Kessel]
	The three non-Kessel quests are kept in this file because they belong to the same delivered
	chain, but their questZone is set to the system their own text names.

	Anything not stated by the .stf text (coordinates, credits, timers, ship agent choices) is
	marked "-- ours".

	Depends on base classes: SpaceMiningDestroyScreenplay, SpaceBattleScreenplay.

]]

--[[
	Kessel Duty Missions
]]

-- kessel_rebel_tier5
-- STF title: "Kessel system: Duty mission: Attack Imperial patrols."
-- STF title_d: "Hunt down Imperial fighters in the Kessel System."
-- STF boss_title_1..5: "Imperial Ace Pilot"  -> five levels are client-attested.
-- STF level_boss: "One of the Empires Ace pilots is attacking; he's piloting one of their
--                  experimental fighters."

destroy_duty_kessel_rebel_tier5 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_kessel_rebel_tier5",

	questName = "kessel_rebel_tier5",
	questType = "destroy_duty",

	questZone = "space_light1", -- STF quest_location_t: "Kessel system."

	creditReward = 20000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- STF boss_title_1 .. boss_title_5
	totalRounds = 3, -- ours
	totalWaves = 3, -- ours

	minDistance = 12500, -- ours
	maxDistance = 17500, -- ours

	-- STF level_boss: an Imperial Ace in an experimental fighter.
	bossShip = "imp_tie_advanced_tier5",

	-- STF title_d: "Hunt down Imperial fighters"
	shipTypes = {
		{"imp_tie_interceptor_tier5", "imp_tie_aggressor_tier5"},
		{"imp_tie_oppressor_tier5", "imp_tie_interceptor_tier5"},
	},
}

registerScreenPlay("destroy_duty_kessel_rebel_tier5", true)

-- kessel_imperial_tier5
-- STF quest_location_t: "Travel to the Kessel System"; quest_location_d: "The Kessel system."
-- STF boss_title_1..5: "Rebel Veteran", "Rebel Raid Seeker", "Rebel Elite", "Rebel Raid Leader",
--                      "Rebel Captain"  -> five levels are client-attested.
-- STF duty_update: "Imperial High Command:<%TO>"

destroy_duty_kessel_imperial_tier5 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_kessel_imperial_tier5",

	questName = "kessel_imperial_tier5",
	questType = "destroy_duty",

	questZone = "space_light1", -- STF quest_location_d: "The Kessel system."

	creditReward = 20000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- STF boss_title_1 .. boss_title_5
	totalRounds = 3, -- ours
	totalWaves = 3, -- ours

	minDistance = 12500, -- ours
	maxDistance = 17500, -- ours

	-- STF boss_title_5: "Rebel Captain"
	bossShip = "reb_xwing_tier5",

	-- STF: Rebel activity in the sector.
	shipTypes = {
		{"reb_xwing_tier5", "reb_awing_tier5"},
		{"reb_ywing_tier5", "reb_bwing_tier5"},
	},
}

registerScreenPlay("destroy_duty_kessel_imperial_tier5", true)

-- kessel_pirate_tier6
-- STF title_d: "Hunt down Pirate fighters in the Kessel System."
-- STF boss_detected: "Incomming YT1300 detected. Get ready!"
-- STF level_boss: "We have a fix on a Pirate YT1300. Get ready to engage."
-- NOTE: the quest name says tier6, but no tier6 ship agents exist in this tree
-- (grep '_tier6' over ship_mobile/ships/serverobjects.lua returns nothing), so tier5 agents are
-- used with an extra wave for difficulty. -- ours

destroy_duty_kessel_pirate_tier6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_kessel_pirate_tier6",

	questName = "kessel_pirate_tier6",
	questType = "destroy_duty",

	questZone = "space_light1", -- STF quest_location_t: "Travel to the Kessel System"

	creditReward = 30000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- STF boss_title_1 .. boss_title_5 keys exist (values blank)
	totalRounds = 3, -- ours
	totalWaves = 4, -- ours

	minDistance = 12500, -- ours
	maxDistance = 17500, -- ours

	-- STF level_boss: "a Pirate YT1300"
	bossShip = "blacksun_yt1300_tier5",

	-- STF title_d: "Pirate fighters"
	shipTypes = {
		{"blacksun_fighter_s01_tier5", "blacksun_fighter_s02_tier5"},
		{"wke_pirate_tier5", "blacksun_fighter_s01_tier5"},
	},
}

registerScreenPlay("destroy_duty_kessel_pirate_tier6", true)

--[[
	Kessel Mining
]]

-- kessel_mining_quest_13
-- STF title: "Kessel System:  Space Diamonds"
-- STF title_d: "Mine 500 units of precious space diamonds from the Kessel system.  Watch out for
--               pirates!"

space_mining_destroy_kessel_mining_quest_13 = SpaceMiningDestroyScreenplay:new {
	className = "space_mining_destroy_kessel_mining_quest_13",

	questName = "kessel_mining_quest_13",
	questType = "space_mining_destroy",

	questZone = "space_light1", -- STF quest_location_t: "Kessel System"

	creditReward = 10000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	resourceType = "space_diamond", -- STF title: "Space Diamonds"
	unitsRequired = 500, -- STF title_d: "Mine 500 units"

	asteroidLocations = {
		{patrolPointName = "kessel_mining_13_field_1", x = -2900, z = 400, y = 3300}, -- ours
		{patrolPointName = "kessel_mining_13_field_2", x = -1200, z = 900, y = 4600}, -- ours
		{patrolPointName = "kessel_mining_13_field_3", x = 600, z = 1200, y = 5800}, -- ours
	},

	-- STF title_d: "Watch out for pirates!"
	attackDelay = 120, -- ours
	attackShips = {
		{"blacksun_fighter_s01_tier5", "blacksun_fighter_s02_tier5"},
	},
}

registerScreenPlay("space_mining_destroy_kessel_mining_quest_13", true)

--[[
	Clone Relics -- Boba Fett arc, phases II and III (DANTOOINE, not Kessel)
]]

-- ep3_clone_relics_boba_fett_2
-- STF title: "Dantooine system: Tracking down Ogveer."
-- STF quest_location_t: "Dantooine system."
-- STF quest_location_d: "The Dantooine system is largely unknown but rumored to have a high
--                        population of pirates."
-- STF quest_disable_d: "Your computer is tracking Ogveer's ship. Hunt him down and disable his engines."
-- STF quest_escort_d: "Escort Ogveer to where he was supposed to meet with Uff Wogo..."
-- STF complete: "You fool! You actually think I'd give up my friend to you? ... Get him boys!"
--   -- this is the client-attested hand-off into the boba_fett_3 ambush. boba_fett_2's
--   split_quest_alert key exists but is blank, so no alert text is shown on the hand-off.

recovery_ep3_clone_relics_boba_fett_2 = SpaceRecoveryScreenplay:new {
	className = "recovery_ep3_clone_relics_boba_fett_2",

	questName = "ep3_clone_relics_boba_fett_2",
	questType = "recovery",

	questZone = "space_dantooine", -- STF quest_location_t: "Dantooine system."  [NOT Kessel]

	creditReward = 15000, -- ours
	itemReward = {},

	sideQuest = true,
	sideQuestType = "destroy_surpriseattack",
	sideQuestName = "ep3_clone_relics_boba_fett_3",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,
	sideQuestDelay = 8, -- ours (seconds)

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 12, -- ours
	recoveryDelay = 16, -- ours

	-- STF: Ogveer, a Dantooine pirate. -- ours; no named Ogveer ship agent exists
	recoverShip = "dantooine_scavenger_boss_tier5",
	recoveryConversationMobile = "object/mobile/dressed_criminal_thug_zabrak_male_01.iff", -- ours; no named Ogveer mobile exists

	-- STF escort_remaining / escort_wiped_out: "Not applicable" -- Ogveer flies alone.
	escortShips = {},

	-- STF arrival_phase_1: "Scanning pre programmed route for ship signature now."
	preRecoveryPoints = {
		{patrolPointName = "relics_boba_fett_2_track_1", x = -4200, z = 800, y = -3100, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "relics_boba_fett_2_track_2", x = -2600, z = 500, y = -1800, escortNumber = 2, radius = 250}, -- ours
		{patrolPointName = "relics_boba_fett_2_track_3", x = -900, z = 200, y = -400, escortNumber = 3, radius = 250}, -- ours
		{patrolPointName = "relics_boba_fett_2_track_4", x = 700, z = -100, y = 1000, escortNumber = 4, radius = 250}, -- ours
	},

	-- STF quest_escort_d: "...to where he was supposed to meet with Uff Wogo and await his arrival."
	recoveryPoints = {
		{patrolPointName = "relics_boba_fett_2_meet_1", x = 2300, z = -400, y = 2400, escortNumber = 1, radius = 250}, -- ours
		{patrolPointName = "relics_boba_fett_2_meet_2", x = 3800, z = -700, y = 3700, escortNumber = 2, radius = 250}, -- ours; the Uff Wogo rendezvous
	},

	escortSpeed = 20, -- ours
	testEscortSpeed = 40, -- ours

	attackDelay = 0, -- STF attack_notify / attack_stopped are blank; no attack wave in this phase
	attackShips = {},

	-- STF panic_1..5 and thanks_1..5 keys exist but are blank; counts kept at the class default.
	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("recovery_ep3_clone_relics_boba_fett_2", true)

-- ep3_clone_relics_boba_fett_3
-- STF title: "Dantooine system: Defeat the ambush."
-- STF title_d: "Ogveer tricked you. Defeat the ambush that he lead you in to, maybe you can find
--               some clues in their debris."
-- STF complete: "Navigation droid: < Scan of intact data among debris indicate origin, labor
--                outpost, moon 4 of Yavin. >"

destroy_surpriseattack_ep3_clone_relics_boba_fett_3 = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_clone_relics_boba_fett_3",

	questName = "ep3_clone_relics_boba_fett_3",
	questType = "destroy_surpriseattack",

	questZone = "space_dantooine", -- STF title: "Dantooine system: ..."  [NOT Kessel]

	creditReward = 12000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "recovery_ep3_clone_relics_boba_fett_2",
	parentQuestType = "recovery",
	parentQuestName = "ep3_clone_relics_boba_fett_2",

	-- Screenplay Specific Variables

	-- STF complete: "Get him boys!" -- Ogveer's pirate friends.
	surpriseAttackShips = {
		zone = "space_dantooine",
		spawns = {
			{count = 1, shipName = "dantooine_scavenger_boss_tier5"}, -- ours
			{count = 3, shipName = "dantooine_scavenger_fighter_tier5"}, -- ours
			{count = 2, shipName = "dantooine_scavenger_bomber_tier5"}, -- ours
		},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_clone_relics_boba_fett_3", true)

--[[
	Clone Relics -- To the Queen's aid, phase III (DATHOMIR, not Kessel)
]]

-- ep3_clone_relics_queen_3
-- STF title: "To the Queen's aid, phase III"
-- STF quest_location_t: "Dathomir system."
-- STF quest_location_d: "The Dathomir system is heavily guarded by the Empire."
-- STF title_d: "...make a hole in the Imperial blockade around the planet for you all to escape.
--               Imarrra and Orrekazzapirr will meet you in their ship above the planet."

space_battle_ep3_clone_relics_queen_3 = SpaceBattleScreenplay:new {
	className = "space_battle_ep3_clone_relics_queen_3",

	questName = "ep3_clone_relics_queen_3",
	questType = "space_battle",

	questZone = "space_dathomir", -- STF quest_location_t: "Dathomir system."  [NOT Kessel]

	creditReward = 25000, -- ours
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- STF found_loc: "Meet up at these coordinates and let's make a break for it there."
	-- Coordinate order is the tree-wide (x, z, y) convention.
	battleLocation = {patrolPointName = "relics_queen_3_breach", x = -3600, z = 1100, y = 4900}, -- ours

	supportShipsDelay = 60, -- ours
	enemyShipsDelay = 90, -- ours

	-- STF allies_arrived: "We are here my friend. Let's do this!" -- Imarrra and Orrekazzapirr (Wookiees).
	supportShips = {"wke_resist_tier5", "wke_resist_tier5"},

	-- STF quest_helpallies_d: "Destroy the Imperial attackers fast before more of them arrive!"
	enemyShips = {"imp_tie_interceptor_tier5", "imp_tie_interceptor_tier5", "imp_tie_oppressor_tier5", "imp_imperial_gunboat_tier5"},
}

registerScreenPlay("space_battle_ep3_clone_relics_queen_3", true)

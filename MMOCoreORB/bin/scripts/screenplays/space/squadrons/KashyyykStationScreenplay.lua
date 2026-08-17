--[[

	Kashyyyk Station Missions

	The ep3_kash_station_* quest family, granted by the Kashyyyk system station NPCs:
	the Kashyyyk Space Station (Civilian Protection Guild, Rian Ry / Eyma), the Rebel
	Outpost, the Imperial Base, and the two Rodian Protector bases (Sordaan, Tripp).

	Quest text is client-supplied in string/en/spacequest/<questType>/<questName>.stf.
	Every enemy faction, target and destination below is taken from that text. Where the
	client text is silent (exact coordinates, credit values, tier of the ship agent used)
	the value is marked as ours on the line.

	Station positions referenced below come from bin/scripts/managers/space/space_manager.lua:
		Kashyyyk Space Station  -5000, 250, -5000    (clientpoi station_kashyyyk)
		Tyyyn Nebula            -6200, -3500, -4500  (clientpoi kashyyyk_tyyyn_center)
		Gotal Pirates' Base     -5950, 2700, 4575    (clientpoi kashyyyk_gotal_pirate_base)
		Rebel Outpost            1200, -2600, -6100  (no clientpoi row - position is ours)
		Imperial Base            6100, 2900, -1800   (no clientpoi row - position is ours)

]]

--[[
	Kashyyyk Space Station -- Civilian Protection Guild main missions
]]

-- STF: "The Kashyyyk space station has received an automated distress call from a freighter
-- nearby. Evidently the droid pilot of this freighter has been damaged by bandits and cannot
-- leave the system without help." Destination per arrived_at_loc: the Kashyyyk space station.
-- taunt_1 "That droid messed with the wrong bandits!" -> Gotal bandits are the attackers.

escort_ep3_kash_station_escort_alpha = SpaceEscortScreenplay:new {
	className = "escort_ep3_kash_station_escort_alpha",

	questName = "ep3_kash_station_escort_alpha",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 7500, -- ours; the STF names no credit value
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- STF calls it a "droid freighter"; no droid-piloted freighter agent exists in the tree,
	-- so a merchant light freighter stands in. Tier 4 is ours.
	escortShips = {"freighterlight_tier4"},

	-- Rendezvous is the western Kashyyyk asteroid (clientpoi kashyyyk_asteroid_organometallic,
	-- -5951, -14, 1034) per "lost somewhere in the Kashyyyk asteroid belt"; the run ends at the
	-- Kashyyyk space station. The two intermediate legs are ours.
	escortPoints = {
		{patrolPointName = "kash_station_escort_alpha_1", zoneName = "space_kashyyyk", x = -5951, z = -14, y = 1034, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_escort_alpha_2", zoneName = "space_kashyyyk", x = -5800, z = 100, y = -1600, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_escort_alpha_3", zoneName = "space_kashyyyk", x = -5500, z = 180, y = -3400, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_escort_alpha_4", zoneName = "space_kashyyyk", x = -5000, z = 250, y = -5000, escortNumber = 4, radius = 250},
	},

	attackDelay = 75, -- In Seconds; ours

	attackShips = {
		{"gotal_bandit_tier3", "gotal_bandit_tier3", "gotal_bandit_tier4"},
		{"gotal_bandit_tier4", "gotal_bandit_tier4", "gotal_warlord_tier4"},
	},
}

registerScreenPlay("escort_ep3_kash_station_escort_alpha", true)

-- STF: "The Kashyyyk space station has received a distress call from a civilian transport that
-- was damaged by Gotal bandits." quest_location_d places it "near the Gotal bandits stronghold";
-- arrived_at_loc sends it on to the Kashyyyk space station.

escort_ep3_kash_station_escort_bravo = SpaceEscortScreenplay:new {
	className = "escort_ep3_kash_station_escort_bravo",

	questName = "ep3_kash_station_escort_bravo",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 10000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- "Civilian Transport"; a faction-neutral merchant transport is the closest agent in-tree.
	-- The tier is ours.
	escortShips = {"freightermedium_tier4"},

	-- Leg 1 sits just outside the Gotal Pirates' Base (-5950, 2700, 4575); the run ends at the
	-- Kashyyyk space station. Intermediate legs are ours.
	escortPoints = {
		{patrolPointName = "kash_station_escort_bravo_1", zoneName = "space_kashyyyk", x = -5400, z = 2300, y = 4100, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_escort_bravo_2", zoneName = "space_kashyyyk", x = -5300, z = 1500, y = 1800, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_escort_bravo_3", zoneName = "space_kashyyyk", x = -5200, z = 700, y = -1500, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_escort_bravo_4", zoneName = "space_kashyyyk", x = -5000, z = 250, y = -5000, escortNumber = 4, radius = 250},
	},

	attackDelay = 60, -- In Seconds; ours

	attackShips = {
		{"gotal_bandit_tier4", "gotal_bandit_tier4", "gotal_bandit_tier5"},
		{"gotal_bandit_tier5", "gotal_bandit_tier5", "gotal_warlord_tier5"},
	},
}

registerScreenPlay("escort_ep3_kash_station_escort_bravo", true)

-- STF: "Eyma has made contact with a high-ranking Ghrag mercenary who wants to leave the
-- organization and join an order of monks on Tatooine." found_loc: "Head into the Tyyyn nebula
-- and rendezvous with the Ghrag contact." Attackers are Ghrag interceptors hunting a traitor
-- (taunt_1 "Traitor! Die!").

escort_ep3_kash_station_escort_ghrag = SpaceEscortScreenplay:new {
	className = "escort_ep3_kash_station_escort_ghrag",

	questName = "ep3_kash_station_escort_ghrag",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 15000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	-- The defecting mercenary. ghrag_traitor_tier5 carries spaceFaction "ghrag_traitor", which is
	-- exactly this encounter.
	escortShips = {"ghrag_traitor_tier5"},

	-- Leg 1 is the Tyyyn Nebula centre (clientpoi kashyyyk_tyyyn_center). The outbound legs and
	-- the jump point near the station are ours - no hyperspace-point coordinates ship for this zone.
	escortPoints = {
		{patrolPointName = "kash_station_escort_ghrag_1", zoneName = "space_kashyyyk", x = -6200, z = -3500, y = -4500, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_escort_ghrag_2", zoneName = "space_kashyyyk", x = -5900, z = -2300, y = -4700, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_escort_ghrag_3", zoneName = "space_kashyyyk", x = -5300, z = -900, y = -4400, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_escort_ghrag_4", zoneName = "space_kashyyyk", x = -4600, z = 500, y = -3200, escortNumber = 4, radius = 250},
	},

	attackDelay = 45, -- In Seconds; ours

	attackShips = {
		{"ghrag_merc_tier5", "ghrag_merc_tier5", "ghrag_assassin_tier5"},
		{"ghrag_assassin_tier5", "ghrag_persuader_tier5", "ghrag_merc_tier5"},
		{"ghrag_specialist_tier5", "ghrag_persuader_tier5", "ghrag_assassin_tier5"},
	},
}

registerScreenPlay("escort_ep3_kash_station_escort_ghrag", true)

--[[
	Rebel Outpost -- escort contract
]]

-- STF: "An Alliance transport carrying ceremonial statues, hologram awards, and various personal
-- items is on its way to the Rebel outpost in Kashyyyk." attack_notify "Incoming Ghrag fighters!"

escort_ep3_kash_station_rebel_escort_alpha = SpaceEscortScreenplay:new {
	className = "escort_ep3_kash_station_rebel_escort_alpha",

	questName = "ep3_kash_station_rebel_escort_alpha",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 12000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"reb_transport_tier4"},

	-- The final leg is the Kashyyyk Rebel Outpost (space_manager.lua spacestation_kash_rebel);
	-- that station position and the three approach legs are ours - no clientpoi row ships for it.
	escortPoints = {
		{patrolPointName = "kash_station_rebel_escort_alpha_1", zoneName = "space_kashyyyk", x = -1500, z = -1800, y = -4200, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_alpha_2", zoneName = "space_kashyyyk", x = -200, z = -2100, y = -4900, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_alpha_3", zoneName = "space_kashyyyk", x = 700, z = -2400, y = -5600, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_alpha_4", zoneName = "space_kashyyyk", x = 1200, z = -2600, y = -6100, escortNumber = 4, radius = 250},
	},

	attackDelay = 60, -- In Seconds; ours

	attackShips = {
		{"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},
		{"ghrag_persuader_tier4", "ghrag_merc_tier5", "ghrag_assassin_tier5"},
	},
}

registerScreenPlay("escort_ep3_kash_station_rebel_escort_alpha", true)

--[[
	Imperial Base -- escort contract
]]

-- STF: "An Imperial transport is in need of escort. Ghrag mercenaries have been no end of
-- trouble. Protect the transport as it departs the Kashyyyk system."

escort_ep3_kash_station_imperial_escort_alpha = SpaceEscortScreenplay:new {
	className = "escort_ep3_kash_station_imperial_escort_alpha",

	questName = "ep3_kash_station_imperial_escort_alpha",
	questType = "escort",

	questZone = "space_kashyyyk",

	creditReward = 12000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"imp_transport_tier4"},

	-- Leg 1 is the Kashyyyk Imperial Base (space_manager.lua spacestation_kash_imperial); the STF
	-- says the transport is departing the system, so the run heads outbound. That station position
	-- and the three outbound legs are ours - no clientpoi row ships for it.
	escortPoints = {
		{patrolPointName = "kash_station_imperial_escort_alpha_1", zoneName = "space_kashyyyk", x = 6100, z = 2900, y = -1800, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_alpha_2", zoneName = "space_kashyyyk", x = 5200, z = 2300, y = -2900, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_alpha_3", zoneName = "space_kashyyyk", x = 4100, z = 1600, y = -4100, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_alpha_4", zoneName = "space_kashyyyk", x = 3000, z = 900, y = -5200, escortNumber = 4, radius = 250},
	},

	attackDelay = 60, -- In Seconds; ours

	attackShips = {
		{"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},
		{"ghrag_persuader_tier4", "ghrag_merc_tier5", "ghrag_assassin_tier5"},
	},
}

registerScreenPlay("escort_ep3_kash_station_imperial_escort_alpha", true)

--[[
	Kashyyyk Space Station -- Rian Ry rescue missions
]]

-- STF: "The Ghrag mercenaries have boldly announced their intentions to disrupt civilian traffic
-- throughout Kashyyyk space." arrival_phase_1 "Fly to the Tyyyn nebula. A weak distress signal is
-- coming from there..."; quest_escort_t "Escort the Civilian Transport to the Kashyyyk space
-- station". Attackers are Ghrag (taunt_4 "The Ghrag rule Kashyyyk space!").

rescue_ep3_kash_station_rescue_alpha = SpaceRescueScreenplay:new {
	className = "rescue_ep3_kash_station_rescue_alpha",

	questName = "ep3_kash_station_rescue_alpha",
	questType = "rescue",

	questZone = "space_kashyyyk",

	creditReward = 15000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- ours

	-- "Civilian Transport"; faction-neutral merchant transport, tier ours.
	rescueShip = "freightermedium_tier4",
	-- The Tyyyn Nebula centre (clientpoi kashyyyk_tyyyn_center).
	rescueLocation = {x = -6200, z = -3500, y = -4500},

	repairDelay = 30, -- ours

	attackDelay = 12, -- ours
	attackShips = {
		{{count = 2, shipName = "ghrag_merc_tier4"}, {count = 1, shipName = "ghrag_assassin_tier4"}},
	},

	-- Egress to the Kashyyyk space station (-5000, 250, -5000). Intermediate legs are ours.
	escortPoints = {
		{patrolPointName = "kash_station_rescue_alpha_escort_1", zoneName = "space_kashyyyk", x = -5900, z = -2300, y = -4700, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_rescue_alpha_escort_2", zoneName = "space_kashyyyk", x = -5400, z = -1000, y = -4800, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_rescue_alpha_escort_3", zoneName = "space_kashyyyk", x = -5000, z = 250, y = -5000, escortNumber = 3, radius = 250},
	},

	escortSpeed = 20,

	escortAttackDelay = 15, -- ours
	escortAttackShips = {
		{{count = 2, shipName = "ghrag_merc_tier4"}, {count = 1, shipName = "ghrag_persuader_tier4"}},
	},
}

registerScreenPlay("rescue_ep3_kash_station_rescue_alpha", true)

-- STF: "Although you succeeded in frustrating the Ghrag mercenaries by rescuing that civilian
-- transport - you also succeeded in making them very vengeful. They have gone after yet another
-- civilian transport." arrival_phase_1 "The distress signal is coming from deep within the Tyyyn
-- nebula." Same egress to the Kashyyyk space station.

rescue_ep3_kash_station_rescue_bravo = SpaceRescueScreenplay:new {
	className = "rescue_ep3_kash_station_rescue_bravo",

	questName = "ep3_kash_station_rescue_bravo",
	questType = "rescue",

	questZone = "space_kashyyyk",

	creditReward = 20000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	-- The STF makes this the direct sequel to rescue_alpha.
	parentQuest = "rescue_ep3_kash_station_rescue_alpha",
	parentQuestType = "rescue",
	parentQuestName = "ep3_kash_station_rescue_alpha",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- ours

	rescueShip = "freightermedium_tier4",
	-- "deep within the Tyyyn nebula" - offset outward from the nebula centre; the offset is ours.
	rescueLocation = {x = -6900, z = -4200, y = -5100},

	repairDelay = 30, -- ours

	attackDelay = 10, -- ours
	attackShips = {
		{{count = 2, shipName = "ghrag_merc_tier5"}, {count = 2, shipName = "ghrag_assassin_tier5"}},
	},

	-- Egress to the Kashyyyk space station (-5000, 250, -5000). Intermediate legs are ours.
	escortPoints = {
		{patrolPointName = "kash_station_rescue_bravo_escort_1", zoneName = "space_kashyyyk", x = -6300, z = -3000, y = -5100, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_rescue_bravo_escort_2", zoneName = "space_kashyyyk", x = -5700, z = -1500, y = -5050, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_rescue_bravo_escort_3", zoneName = "space_kashyyyk", x = -5000, z = 250, y = -5000, escortNumber = 3, radius = 250},
	},

	escortSpeed = 20,

	escortAttackDelay = 15, -- ours
	escortAttackShips = {
		{{count = 2, shipName = "ghrag_merc_tier5"}, {count = 1, shipName = "ghrag_persuader_tier5"}},
	},
}

registerScreenPlay("rescue_ep3_kash_station_rescue_bravo", true)

--[[
	Weapons dealer intercepts -- one per faction alignment

	All three share arrival_phase_1 "Head out past the Tyyyn nebula. Intercept the arms dealer!"
	and are given by Eyma (quest_update "Eyma:"). The dealer flies under Ghrag armed escort.

	GAP: the client names a distinct dealer per variant - Faydo Sha (rebel), Kred-ka Sul (neutral),
	Vosc Traaer (imperial) - and comm portraits ship for all three, but no matching ship agent
	exists in bin/scripts/ship_mobile/ships. trn_slaver_barge_tier5 stands in for all three; that
	choice is client-supported only for the rebel variant, whose STF calls Faydo Sha a slave-trader.
]]

assassinate_ep3_kash_station_assassinate_rebel = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_kash_station_assassinate_rebel",

	questType = "assassinate",
	questName = "ep3_kash_station_assassinate_rebel",

	questZone = "space_kashyyyk",

	creditReward = 25000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- STF title_d: Eyma tracks the dealer using information from the Ghrag traitor the player
	-- escorted out of the system.
	parentQuest = "escort_ep3_kash_station_escort_ghrag",
	parentQuestType = "escort",
	parentQuestName = "ep3_kash_station_escort_ghrag",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- Seconds; ours
	failTimer = 20, -- Minutes

	assassinateSpawns = {
		target = "trn_slaver_barge_tier5",
		escorts = {"ghrag_merc_tier5", "ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_persuader_tier5"},
	},

	-- targetPatrols[1] is the spawn point: "past the Tyyyn nebula" (nebula centre is
	-- -6200, -3500, -4500). All four points are ours.
	targetPatrols = {
		{patrolPointName = "kash_station_assassinate_rebel_1", x = -7200, z = -4400, y = -5400},
		{patrolPointName = "kash_station_assassinate_rebel_2", x = -6400, z = -3600, y = -4800},
		{patrolPointName = "kash_station_assassinate_rebel_3", x = -5600, z = -2600, y = -4100},
		{patrolPointName = "kash_station_assassinate_rebel_4", x = -4800, z = -1600, y = -3300},
	},
}

registerScreenPlay("assassinate_ep3_kash_station_assassinate_rebel", true)

assassinate_ep3_kash_station_assassinate_imperial = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_kash_station_assassinate_imperial",

	questType = "assassinate",
	questName = "ep3_kash_station_assassinate_imperial",

	questZone = "space_kashyyyk",

	creditReward = 25000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "escort_ep3_kash_station_escort_ghrag",
	parentQuestType = "escort",
	parentQuestName = "ep3_kash_station_escort_ghrag",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- Seconds; ours
	failTimer = 20, -- Minutes

	assassinateSpawns = {
		target = "trn_slaver_barge_tier5",
		escorts = {"ghrag_merc_tier5", "ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_persuader_tier5"},
	},

	targetPatrols = {
		{patrolPointName = "kash_station_assassinate_imperial_1", x = -7200, z = -4400, y = -5400},
		{patrolPointName = "kash_station_assassinate_imperial_2", x = -6400, z = -3600, y = -4800},
		{patrolPointName = "kash_station_assassinate_imperial_3", x = -5600, z = -2600, y = -4100},
		{patrolPointName = "kash_station_assassinate_imperial_4", x = -4800, z = -1600, y = -3300},
	},
}

registerScreenPlay("assassinate_ep3_kash_station_assassinate_imperial", true)

assassinate_ep3_kash_station_assassinate_neutral = SpaceAssassinateScreenplay:new {
	className = "assassinate_ep3_kash_station_assassinate_neutral",

	questType = "assassinate",
	questName = "ep3_kash_station_assassinate_neutral",

	questZone = "space_kashyyyk",

	creditReward = 25000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "escort_ep3_kash_station_escort_ghrag",
	parentQuestType = "escort",
	parentQuestName = "ep3_kash_station_escort_ghrag",

	-- Screenplay Specific Variables

	arrivalDelay = 8, -- Seconds; ours
	failTimer = 20, -- Minutes

	assassinateSpawns = {
		target = "trn_slaver_barge_tier5",
		escorts = {"ghrag_merc_tier5", "ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_persuader_tier5"},
	},

	targetPatrols = {
		{patrolPointName = "kash_station_assassinate_neutral_1", x = -7200, z = -4400, y = -5400},
		{patrolPointName = "kash_station_assassinate_neutral_2", x = -6400, z = -3600, y = -4800},
		{patrolPointName = "kash_station_assassinate_neutral_3", x = -5600, z = -2600, y = -4100},
		{patrolPointName = "kash_station_assassinate_neutral_4", x = -4800, z = -1600, y = -3300},
	},
}

registerScreenPlay("assassinate_ep3_kash_station_assassinate_neutral", true)

--[[
	Ghrag ambushes

	STF (both files, identical body): "You are now death-marked by the Ghrag Mercenary clan! Ace
	fighters have been sent to destroy you!" The "_strong" variant differs only by name, so the
	stronger wave composition below is ours.
]]

destroy_surpriseattack_ep3_kash_station_ghrag_ambush = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_kash_station_ghrag_ambush",

	questName = "ep3_kash_station_ghrag_ambush",
	questType = "destroy_surpriseattack",

	questZone = "space_kashyyyk",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	-- No parent quest is named by the client text; the station conversation handler owns the
	-- trigger (spacestation_kashyyyk_ghrag_warning, "Ghrag ambush inbound").
	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	-- "Ace fighters from the Ghrag Mercenary Clan"; the counts are ours.
	surpriseAttackShips = {
		zone = "space_kashyyyk",
		spawns = {{count = 2, shipName = "ghrag_assassin_tier4"}, {count = 2, shipName = "ghrag_merc_tier4"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_kash_station_ghrag_ambush", true)

destroy_surpriseattack_ep3_kash_station_ghrag_ambush_strong = SpaceSurpriseAttackScreenplay:new {
	className = "destroy_surpriseattack_ep3_kash_station_ghrag_ambush_strong",

	questName = "ep3_kash_station_ghrag_ambush_strong",
	questType = "destroy_surpriseattack",

	questZone = "space_kashyyyk",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	-- Screenplay Specific Variables

	surpriseAttackShips = {
		zone = "space_kashyyyk",
		spawns = {{count = 2, shipName = "ghrag_assassin_tier5"}, {count = 2, shipName = "ghrag_persuader_tier5"}, {count = 2, shipName = "ghrag_merc_tier5"}},
	},
}

registerScreenPlay("destroy_surpriseattack_ep3_kash_station_ghrag_ambush_strong", true)

--[[
	Duty missions -- destroy

	The three Ghrag contracts (neutral / rebel / imperial) share one body of client text and list
	three boss titles (Ghrag Wing Commander, Ghrag Combat Ace, Ghrag Space Assassin), so each runs
	three levels. The Rodian and CPG Veteran contracts list five boss titles and run five levels.

	Note: SpaceDutyDestroyScreenplay only ever indexes shipTypes[1] (tableSet is hard-coded to 1 at
	SpaceDutyDestroyScreenplay.lua:452), so a single inner table is authored, matching Corsec.
]]

-- STF: "Now that their plans for system-wide domination have been quashed, the Ghrag are running
-- scared. Patrol the Kashyyyk system in search of their remaining numbers and eliminate them."
-- duty_update "Civilian Protection Guild:"

destroy_duty_ep3_kash_station_destroy_duty_neutral = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_neutral",

	questName = "ep3_kash_station_destroy_duty_neutral",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 3, -- Amount of levels a player has to complete to finish mission; three boss_title entries ship
	totalRounds = 2, -- Total Rounds for each of the levels; ours
	totalWaves = 2, -- Total waves at each location that is not the boss ship; ours

	minDistance = 2500, -- Minimum distance away for new location; ours
	maxDistance = 5000, -- Maximum distance away for new location; ours

	-- boss_title_3 is "Ghrag Space Assassin"; the tier is ours.
	bossShip = "ghrag_assassin_tier4",
	shipTypes = {
		{"ghrag_merc_tier4", "ghrag_specialist_tier4", "ghrag_persuader_tier4"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_neutral", true)

-- Same Ghrag contract, issued by the Rebel Outpost (duty_update "Rebel Outpost:").

destroy_duty_ep3_kash_station_destroy_duty_rebel = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_rebel",

	questName = "ep3_kash_station_destroy_duty_rebel",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 3, -- three boss_title entries ship
	totalRounds = 2, -- ours
	totalWaves = 2, -- ours

	minDistance = 2500, -- ours
	maxDistance = 5000, -- ours

	bossShip = "ghrag_assassin_tier4",
	shipTypes = {
		{"ghrag_merc_tier4", "ghrag_specialist_tier4", "ghrag_persuader_tier4"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_rebel", true)

-- Same Ghrag contract, issued by the Imperial Base (duty_update "Imperial Base:").

destroy_duty_ep3_kash_station_destroy_duty_imperial = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_imperial",

	questName = "ep3_kash_station_destroy_duty_imperial",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 3, -- three boss_title entries ship
	totalRounds = 2, -- ours
	totalWaves = 2, -- ours

	minDistance = 2500, -- ours
	maxDistance = 5000, -- ours

	bossShip = "ghrag_assassin_tier4",
	shipTypes = {
		{"ghrag_merc_tier4", "ghrag_specialist_tier4", "ghrag_persuader_tier4"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_imperial", true)

-- STF: "Rodian Protectors: Seek and Destroy Gotal Bandits" - "The Gotal have offended the Rodian
-- Warlord Sordaan by hunting in his hunting grounds without permission." duty_update
-- "Rodian Protector:". Five boss titles ship, topping out at "Gotal Admiral".

destroy_duty_ep3_kash_station_destroy_duty_rodian = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_rodian",

	questName = "ep3_kash_station_destroy_duty_rodian",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 7500, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- five boss_title entries ship
	totalRounds = 2, -- ours
	totalWaves = 2, -- ours

	minDistance = 2500, -- ours
	maxDistance = 5000, -- ours

	-- boss_title_1 is "Gotal Gunship"; gotal_warlord_tier5 is the Gotal turret ship.
	bossShip = "gotal_warlord_tier5",
	shipTypes = {
		{"gotal_bandit_tier5", "gotal_bandit_tier5", "gotal_bandit_tier4", "gotal_warlord_tier4"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_rodian", true)

-- STF: "Tripp's Rodian Protectors: Seek and Destroy Chiss Settlers" - "Seek and destroy all Chiss
-- Settlers and their Poacher Ace escorts!" Five boss titles ship, the third being
-- "Chiss Settler Command ship".

destroy_duty_ep3_kash_station_destroy_duty_rodian_tripp = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_rodian_tripp",

	questName = "ep3_kash_station_destroy_duty_rodian_tripp",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 7500, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- five boss_title entries ship
	totalRounds = 2, -- ours
	totalWaves = 2, -- ours

	minDistance = 2500, -- ours
	maxDistance = 5000, -- ours

	-- The settler ship is the objective ("destroying their settler ships") and boss_title_3 is the
	-- "Chiss Settler Command ship"; chiss_poacher_settler_tier4 is the only Chiss transport in-tree.
	bossShip = "chiss_poacher_settler_tier4",
	shipTypes = {
		{"chiss_poacher_tier5", "chiss_poacher_tier5", "chiss_poacher_bomber_tier5", "chiss_poacher_tier4"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_rodian_tripp", true)

-- STF: "CPG Veteran Duty - destroy the Ghrag reinforcements" - "a fleet of highly trained, highly
-- paid mercenaries is headed into Kashyyyk space." duty_update "CPG Veteran Pilot:". Five boss
-- titles ship, including "Ghrag Gunboat" and "Ghrag Turret Cruiser".

destroy_duty_ep3_kash_station_destroy_duty_veteran = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_ep3_kash_station_destroy_duty_veteran",

	questName = "ep3_kash_station_destroy_duty_veteran",
	questType = "destroy_duty",

	questZone = "space_kashyyyk",

	creditReward = 10000, -- ours
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	totalLevels = 5, -- five boss_title entries ship
	totalRounds = 2, -- ours
	totalWaves = 3, -- ours; this is the veteran-tier contract

	minDistance = 2500, -- ours
	maxDistance = 5000, -- ours

	-- boss_title_1 "Ghrag Gunboat" / boss_title_3 "Ghrag Turret Cruiser"; ghrag_avenger_tier5 is the
	-- Ghrag capital turret ship.
	bossShip = "ghrag_avenger_tier5",
	shipTypes = {
		{"ghrag_merc_tier5", "ghrag_assassin_tier5", "ghrag_specialist_tier5", "ghrag_persuader_tier5"},
	},
}

registerScreenPlay("destroy_duty_ep3_kash_station_destroy_duty_veteran", true)

--[[
	Duty missions -- escort

	All three share one body of client text; only quest_location_d, duty_update and title_d differ
	by faction. The escort target pool follows quest_location_d in each case.
]]

-- STF: "Protect merchant cruisers, civilian transports and freighters as they pass through the
-- Kashyyyk system en route to destinations throughout the galaxy." duty_update
-- "Civilian Protection Guild:".

escort_duty_ep3_kash_station_escort_duty = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_ep3_kash_station_escort_duty",

	questName = "ep3_kash_station_escort_duty",
	questType = "escort_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours

	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"freighterheavy_tier4", "freighterlight_tier4", "freightermedium_tier4"},

	-- A transit lane across the neutral middle of the zone. All four points are ours.
	escortPoints = {
		{patrolPointName = "kash_station_cpg_escort_duty_1", zoneName = "space_kashyyyk", x = -3400, z = 600, y = -3100, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_cpg_escort_duty_2", zoneName = "space_kashyyyk", x = -1200, z = 300, y = -1400, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_cpg_escort_duty_3", zoneName = "space_kashyyyk", x = 900, z = -200, y = 600, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_cpg_escort_duty_4", zoneName = "space_kashyyyk", x = 2900, z = -700, y = 2400, escortNumber = 4, radius = 250},
	},

	attackDelay = 90, -- In Seconds; ours

	-- title_d attributes the threat to the Ghrag; taunt_1 "No one is safe!" names no clan.
	attackShips = {
		{"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},
		{"ghrag_specialist_tier4", "ghrag_persuader_tier4", "ghrag_merc_tier4"},
	},

	creditKillBonus = 250, -- ours
}

registerScreenPlay("escort_duty_ep3_kash_station_escort_duty", true)

-- STF: "Protect Alliance transports and freighters as they pass through the Kashyyyk system."
-- duty_update "Rebel Outpost:".

escort_duty_ep3_kash_station_escort_duty_rebel = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_ep3_kash_station_escort_duty_rebel",

	questName = "ep3_kash_station_escort_duty_rebel",
	questType = "escort_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours

	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"reb_transport_tier4", "reb_transport_tier5", "freighterheavy_rebel_tier4"},

	-- Lane running in to the Kashyyyk Rebel Outpost (1200, -2600, -6100). All four points are ours.
	escortPoints = {
		{patrolPointName = "kash_station_rebel_escort_duty_1", zoneName = "space_kashyyyk", x = -2400, z = -1200, y = -3600, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_duty_2", zoneName = "space_kashyyyk", x = -1100, z = -1700, y = -4500, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_duty_3", zoneName = "space_kashyyyk", x = 200, z = -2200, y = -5300, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_rebel_escort_duty_4", zoneName = "space_kashyyyk", x = 1200, z = -2600, y = -6100, escortNumber = 4, radius = 250},
	},

	attackDelay = 90, -- In Seconds; ours

	attackShips = {
		{"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},
		{"ghrag_specialist_tier4", "ghrag_persuader_tier4", "ghrag_merc_tier4"},
	},

	creditKillBonus = 250, -- ours
}

registerScreenPlay("escort_duty_ep3_kash_station_escort_duty_rebel", true)

-- STF: "Protect Imperial transports and freighters as they pass through the Kashyyyk system."
-- duty_update "Imperial Base:".

escort_duty_ep3_kash_station_escort_duty_imperial = SpaceDutyEscortScreenplay:new {
	className = "escort_duty_ep3_kash_station_escort_duty_imperial",

	questName = "ep3_kash_station_escort_duty_imperial",
	questType = "escort_duty",

	questZone = "space_kashyyyk",

	creditReward = 5000, -- ours

	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",

	-- Screenplay Specific Variables

	escortShips = {"imp_transport_tier4", "imp_transport_tier5", "freighterheavy_imperial"},

	-- Lane running in to the Kashyyyk Imperial Base (6100, 2900, -1800). All four points are ours.
	escortPoints = {
		{patrolPointName = "kash_station_imperial_escort_duty_1", zoneName = "space_kashyyyk", x = 2600, z = 900, y = -4600, escortNumber = 1, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_duty_2", zoneName = "space_kashyyyk", x = 3800, z = 1600, y = -3700, escortNumber = 2, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_duty_3", zoneName = "space_kashyyyk", x = 5000, z = 2300, y = -2700, escortNumber = 3, radius = 250},
		{patrolPointName = "kash_station_imperial_escort_duty_4", zoneName = "space_kashyyyk", x = 6100, z = 2900, y = -1800, escortNumber = 4, radius = 250},
	},

	attackDelay = 90, -- In Seconds; ours

	attackShips = {
		{"ghrag_merc_tier4", "ghrag_merc_tier4", "ghrag_assassin_tier4"},
		{"ghrag_specialist_tier4", "ghrag_persuader_tier4", "ghrag_merc_tier4"},
	},

	creditKillBonus = 250, -- ours
}

registerScreenPlay("escort_duty_ep3_kash_station_escort_duty_imperial", true)

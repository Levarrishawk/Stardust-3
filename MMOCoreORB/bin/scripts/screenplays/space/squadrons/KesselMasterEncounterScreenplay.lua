local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Kessel Master Encounter -- Squadron Master Level Missions (live-faithful reconstruction)

	Sources:
	  * Authentic TRE quest data (mtg_patch_013_configurable_02.tre):
	      datatables/questtask|questlist/spacequest/destroy/master_{imperial,rebel}_{1,2}.iff
	      string/en/spacequest/destroy/master_{imperial,rebel}_{1,2}.stf
	  * Biophilia's PreCU Scrapbook v5.1 -- Pilot forum primary sources:
	      "Corvette Master Mission Spawn Information" (MonsofoLexius)
	      "[GUIDE]/[FAQ] to Completing the Corvette Master Level Mission v3.0b" (Zina)

	The Squadron Master tier is a TWO-STAGE chain (per TRE strings):

	  Stage 1  master_*_1 : travel to Kessel and destroy 30 enemy fighters/gunboats
	                        (NON-capital craft) to weaken the enemy battlegroup.
	  Stage 2  master_*_2 : travel to Kessel and destroy the enemy command vessel --
	                        a Corellian-Corvette-class capital ship -- by destroying
	                        each of its sub-components.

	Per-faction targets (from TRE strings + scrapbook):
	  * Rebel pilots (CrimsonPhoenix / Vortex) and Smuggler/Freelancer pilots who
	    chose the Rebel master trainer hunt the IMPERIAL corvette ("Star Ravager"),
	    represented here by ship agent imp_corellian_corvette_tier4.
	  * Imperial pilots (BlackEpsilon / Inquisition / Storm) hunt the REBEL corvette
	    ("Corellian Corvette"), represented here by reb_corellian_corvette_tier4.
	  * Smuggler/Freelancer pilots have no master trainer of their own; they take the
	    Rebel or Imperial master quest at the respective trainer (TRE/scrapbook), so
	    Smuggler squadron uses the Rebel-target chain (hunts the Imperial corvette).

	Escorts (scrapbook): the corvette spawns with TWO (2) tier-5 gunboats plus a few
	fighter escorts. The gunboats orbit the corvette's exit point. We spawn the 2
	tier-5 gunboats with the corvette here. (In Live the escorts could self-destruct
	a minute or two after being disabled -- see reconstruction notes; not reproduced.)

	Documented Kessel exit / spawn coordinates (Scylla/Naritus, scrapbook):
	  * Rebel  Corellian Corvette : -7260, 4873, 6341  (also reported ~4870,-5056,-4765)
	  * Imperial Star Ravager     : -6231, -259, -6059 (also reported  7340, 7550, 6268)

	RECONSTRUCTION NOTE -- ZONE:
	  Live ran this encounter in the "Kessel" Deep-Space instance. This server build
	  has NO space_kessel terrain/region/patrol zone (confirmed: terrain TREs contain
	  space_corellia/dantooine/dathomir/endor/naboo/tatooine/yavin4/lok/... but no
	  Kessel). To avoid fabricating an unsupported zone, the encounter spawns in each
	  squadron's existing (live, registered) questZone using the documented Kessel
	  geometry. The canonical target zone is recorded as "kessel" for fidelity. When a
	  space_kessel zone is added, set KESSEL_ZONE below and the encounter is Kessel-true.

]]

-- Canonical (Live) target zone. Empty string => spawn in the quest's own questZone
-- (current build lacks a space_kessel zone). Set to "space_kessel" once it exists.
KESSEL_TARGET_ZONE = ""

-- Documented Kessel spawn geometry (scrapbook). Used as relative spawn anchors.
KESSEL_REBEL_CORVETTE_SPAWN = { x = -7260, z = 4873, y = 6341 }   -- Rebel Corellian Corvette
KESSEL_IMPERIAL_CORVETTE_SPAWN = { x = -6231, z = -259, y = -6059 } -- Imperial Star Ravager

-- Authentic Kessel corvette spawn timing (Biophilia Pre-CU Scrapbook v5.1):
--   MonsofoLexius "Corvette Master Mission Spawn Information" (data/20070127185616)
--   Zina "Corvette Master Level Mission" FAQ v3.0b           (data/20070127191311)
-- The corvette stays in-system ~45 min then hyperspaces out; full per-faction cycle ~2h;
-- the two faction corvettes spawn ~1h apart; disabled gunboat escorts self-destruct ~1-2 min.
KESSEL_CORVETTE_DWELL_MS      = 2700 * 1000  -- ~45 min in-system, then hyperspace out (Zina)
KESSEL_CORVETTE_RESPAWN_MS    = 4500 * 1000  -- ~1h15m after exit until next spawn      (Zina)
KESSEL_CORVETTE_CYCLE_MS      = 7200 * 1000  -- ~2h full per-faction spawn cycle         (both guides)
KESSEL_CORVETTE_ALTERNATE_MS  = 3600 * 1000  -- two vettes spawn ~1h apart               (both guides)
KESSEL_ESCORT_SELFDESTRUCT_MS =   90 * 1000  -- disabled gunboat self-destructs ~1-2 min (MonsofoLexius)

--[[
	KesselCorvetteEncounter -- Stage 2 base.

	Extends SpaceDestroyScreenplay so completion reuses the proven, live-faithful gate:
	  * player must be IN the quest zone (Kessel) when the target is destroyed, and
	  * the destroyed ship must match the faction corvette agent (shipTypes).
	On zone entry it additionally spawns the corvette + 2 tier-5 gunboat escorts at the
	documented exit point.
]]
KesselCorvetteEncounter = SpaceDestroyScreenplay:new {
	className = "KesselCorvetteEncounter",

	questName = "",
	questType = "destroy",
	questZone = "",

	creditReward = 0,

	sideQuest = false,
	sideQuestType = "",

	-- Gate: destroy the single capital command vessel.
	killsRequired = 1,
	shipLocations = {},

	-- shipTypes holds the faction corvette agent name (set per subclass).
	shipTypes = {},

	-- Encounter spawn definition (set per subclass).
	corvetteAgent = "",
	escortAgents = {}, -- 2 tier-5 gunboats
	spawnAnchor = { x = 0, z = 0, y = 0 },

	DEBUG_KESSEL_ENCOUNTER = false,
}

registerScreenPlay("KesselCorvetteEncounter", false)

-- Override zone entry: run the base destroy bookkeeping, then spawn the encounter.
function KesselCorvetteEncounter:enteredZone(pPlayer, nill, zoneNameHash)
	if (pPlayer == nil) then
		return 0
	end

	-- Run base behavior (activates kill task, creates DESTROYEDSHIP observer, waypoints).
	SpaceDestroyScreenplay.enteredZone(self, pPlayer, nill, zoneNameHash)

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return 0
	end

	local spaceQuestHash = getHashCode(self.questZone)

	-- Only spawn when the player is in the correct zone and the corvette is not yet up.
	if (zoneNameHash == spaceQuestHash) then
		local playerID = SceneObject(pPlayer):getObjectID()

		if (readData(playerID .. ":" .. self.className .. ":corvetteUp") == 1) then
			return 0
		end

		self:spawnCorvetteEncounter(pPlayer)
		writeData(playerID .. ":" .. self.className .. ":corvetteUp", 1)
	end

	return 0
end

-- Spawn the command corvette plus its two tier-5 gunboat escorts.
function KesselCorvetteEncounter:spawnCorvetteEncounter(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pPilotShip = SceneObject(pPlayer):getRootParent()

	if (pPilotShip == nil or not SceneObject(pPilotShip):isShipObject()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	local spawnZone = self.questZone
	if (KESSEL_TARGET_ZONE ~= "") then
		spawnZone = KESSEL_TARGET_ZONE
	end

	-- Anchor the encounter at the documented Kessel exit geometry.
	local ax = self.spawnAnchor.x
	local az = self.spawnAnchor.z
	local ay = self.spawnAnchor.y

	-- Track every ship we spawn so the corvette + escorts can be despawned together
	-- when the corvette hyperspaces out (Gap 3 -- authentic ~45 min dwell).
	local spawnCount = 0

	-- Spawn the capital corvette (the mission target).
	local pCorvette = spawnShipAgent(self.corvetteAgent, spawnZone, ax, az, ay)

	if (pCorvette ~= nil) then
		ShipAiAgent(pCorvette):setMissionOwner(pPlayer)
		ShipAiAgent(pCorvette):setMinimumGuardPatrol(100)
		ShipAiAgent(pCorvette):setMaximumGuardPatrol(800)
		ShipAiAgent(pCorvette):setGuardPatrol()

		local corvetteID = SceneObject(pCorvette):getObjectID()
		writeData(corvetteID .. ":QuestOwner", SceneObject(pPlayer):getObjectID())
		CreatureObject(pPlayer):addSpaceMissionObject(corvetteID, true)

		spawnCount = spawnCount + 1
		writeData(playerID .. ":" .. self.className .. ":spawn:" .. spawnCount, corvetteID)

		if (self.DEBUG_KESSEL_ENCOUNTER) then
			print(self.className .. " -- spawned corvette " .. self.corvetteAgent .. " in " .. spawnZone)
		end
	else
		Logger:log(self.className .. " -- FAILED to spawn corvette agent: " .. self.corvetteAgent, LT_ERROR)
	end

	-- Spawn the two tier-5 gunboat escorts orbiting the corvette's exit point.
	for i = 1, #self.escortAgents, 1 do
		local pEscort = spawnShipAgent(self.escortAgents[i], spawnZone,
			ax + getRandomNumber(100, 200), az, ay + getRandomNumber(100, 200))

		if (pEscort ~= nil) then
			ShipAiAgent(pEscort):setMissionOwner(pPlayer)
			ShipAiAgent(pEscort):setMinimumGuardPatrol(100)
			ShipAiAgent(pEscort):setMaximumGuardPatrol(1000)
			ShipAiAgent(pEscort):setGuardPatrol()

			spawnCount = spawnCount + 1
			writeData(playerID .. ":" .. self.className .. ":spawn:" .. spawnCount, SceneObject(pEscort):getObjectID())
		end
	end

	writeData(playerID .. ":" .. self.className .. ":spawnCount", spawnCount)

	-- Authentic dwell: the corvette stays ~45 min then hyperspaces out (Zina FAQ).
	-- If the player has not destroyed it by then, this trip's corvette is lost; it can
	-- respawn on a later zone entry.
	createEvent(KESSEL_CORVETTE_DWELL_MS, self.className, "hyperspaceOutCorvette", pPlayer, "")

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")
	SpaceHelpers:sendQuestUpdate(pPlayer, "An enemy Corellian Corvette and its gunboat escorts have been detected. Destroy the corvette's sub-components to complete your mission.")
end

-- Authentic ~45-minute dwell expiry: despawn the corvette + its escorts (they "hyperspace
-- out") if the player has not destroyed the corvette, and clear the spawn flag so a later
-- zone entry can spawn a fresh corvette. (Gap 3 -- scrapbook-sourced timing.)
function KesselCorvetteEncounter:hyperspaceOutCorvette(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Already destroyed/cleared (quest completed or reset) -> nothing to hyperspace out.
	if (readData(playerID .. ":" .. self.className .. ":corvetteUp") ~= 1) then
		return
	end

	local spawnCount = readData(playerID .. ":" .. self.className .. ":spawnCount")

	for i = 1, spawnCount, 1 do
		local key = playerID .. ":" .. self.className .. ":spawn:" .. i
		local shipID = readData(key)

		if (shipID ~= nil and shipID ~= 0) then
			local pShip = getSceneObject(shipID)

			if (pShip ~= nil) then
				CreatureObject(pPlayer):removeSpaceMissionObject(shipID, true)
				SpaceHelpers:delayedDestroyShipAgent(pShip)
			end

			deleteData(key)
		end
	end

	deleteData(playerID .. ":" .. self.className .. ":spawnCount")
	deleteData(playerID .. ":" .. self.className .. ":corvetteUp")

	SpaceHelpers:sendQuestUpdate(pPlayer, "The enemy corvette has jumped to hyperspace before you could destroy it. Return to Kessel later to engage it again.")
end

-- Clear our spawn flag whenever the quest is reset/failed/completed.
function KesselCorvetteEncounter:clearEncounterState(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Clear the dwell spawn-tracking keys (Gap 3) along with the spawn flag.
	local spawnCount = readData(playerID .. ":" .. self.className .. ":spawnCount")
	for i = 1, spawnCount, 1 do
		deleteData(playerID .. ":" .. self.className .. ":spawn:" .. i)
	end
	deleteData(playerID .. ":" .. self.className .. ":spawnCount")

	deleteData(playerID .. ":" .. self.className .. ":corvetteUp")
end

function KesselCorvetteEncounter:resetQuest(pPlayer)
	self:clearEncounterState(pPlayer)
	SpaceDestroyScreenplay.resetQuest(self, pPlayer)
end

-- Authentic Kessel Master reward (Biophilia Pre-CU Scrapbook v5.1, Zina FAQ v3.0b §VI):
-- the "ace pilot" wearable title. Grants the faction + gender-appropriate ace-pilot necklace.
-- (Badge + faction helmet are additional documented components -- see fidelity doc.)
function KesselCorvetteEncounter:grantAcePilotReward(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local faction = self.aceRewardFaction

	if (faction == nil or faction == "") then
		return
	end

	local gender = "m"
	if (CreatureObject(pPlayer):getGender() ~= 0) then
		gender = "f"
	end

	-- Wookiee/Ithorian need their species mesh variant (the human-mesh necklace's playerRaces excludes them).
	local species = CreatureObject(pPlayer):getSpecies()
	local item

	if (species == SPECIES_WOOKIEE) then
		item = "object/tangible/wearables/necklace/necklace_ace_pilot_" .. faction .. "_wke_" .. gender .. ".iff"
	elseif (species == SPECIES_ITHORIAN) then
		item = "object/tangible/wearables/necklace/ith_necklace_ace_pilot_" .. faction .. "_" .. gender .. ".iff"
	else
		item = "object/tangible/wearables/necklace/necklace_ace_pilot_" .. faction .. "_" .. gender .. ".iff"
	end

	SpaceHelpers:spaceItemReward(pPlayer, item)
end

function KesselCorvetteEncounter:completeQuest(pPlayer, notifyClient)
	self:grantAcePilotReward(pPlayer)
	self:clearEncounterState(pPlayer)
	SpaceDestroyScreenplay.completeQuest(self, pPlayer, notifyClient)
end

function KesselCorvetteEncounter:failQuest(pPlayer, notifyClient)
	self:clearEncounterState(pPlayer)
	SpaceDestroyScreenplay.failQuest(self, pPlayer, notifyClient)
end

--[[ ====================================================================
	STAGE 1 -- master_*_1 : Kessel seek-and-destroy, 30 enemy fighters.
	Faithful to TRE strings (target lists) and the existing SpaceDestroy gate
	(must be in zone; destroy required number of matching ships).
==================================================================== ]]

-- Imperial pilots: weaken the Rebel battlegroup -- destroy 30 Rebel fighters/gunboats.
destroy_master_imperial_1 = SpaceDestroyScreenplay:new {
	className = "destroy_master_imperial_1",

	questName = "master_imperial_1",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 10000,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 30,

	shipLocations = {},

	-- TRE master_imperial_1: X-Wings, B-Wings, A-Wings, Y-Wings, and Rebel gunboats.
	shipTypes = {
		"reb_xwing_tier4", "reb_xwing_tier5",
		"reb_ywing_tier4", "reb_ywing_tier5",
		"reb_awing_tier4", "reb_awing_tier5",
		"reb_bwing_tier4", "reb_bwing_tier5",
		"reb_gunboat_tier4", "reb_gunboat_tier5",
	},
}

registerScreenPlay("destroy_master_imperial_1", true)

-- Rebel / Freelancer-rebel pilots: weaken the Imperial battlegroup -- 30 TIEs/gunboats.
destroy_master_rebel_1 = SpaceDestroyScreenplay:new {
	className = "destroy_master_rebel_1",

	questName = "master_rebel_1",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 10000,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 30,

	shipLocations = {},

	-- TRE master_rebel_1: Imperial Gunboats, TIE Advanced, TIE Aggressor, TIE
	-- Interceptor, TIE Oppressor variants.
	shipTypes = {
		"imp_tie_advanced_tier4", "imp_tie_advanced_tier5",
		"imp_tie_aggressor_tier4", "imp_tie_aggressor_tier5",
		"imp_tie_interceptor_tier4", "imp_tie_interceptor_tier5",
		"imp_tie_oppressor_tier4", "imp_tie_oppressor_tier5",
		"imp_imperial_gunboat_tier4", "imp_imperial_gunboat_tier5",
	},
}

registerScreenPlay("destroy_master_rebel_1", true)

--[[ ====================================================================
	STAGE 2 -- master_*_2 : Destroy the enemy Corellian Corvette command vessel.
==================================================================== ]]

-- Imperial pilots hunt the REBEL corvette ("Corellian Corvette").
destroy_master_imperial_2 = KesselCorvetteEncounter:new {
	className = "destroy_master_imperial_2",

	questName = "master_imperial_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 25000,
	-- Imperial pilots earn the Imperial "ace pilot" wearable (Zina FAQ §VI).
	aceRewardFaction = "empire",

	corvetteAgent = "reb_corellian_corvette_tier4",
	escortAgents = { "reb_gunboat_tier5", "reb_gunboat_tier5" },
	spawnAnchor = KESSEL_REBEL_CORVETTE_SPAWN,

	shipTypes = { "reb_corellian_corvette_tier4" },
}

registerScreenPlay("destroy_master_imperial_2", true)

-- Rebel / Freelancer-rebel pilots hunt the IMPERIAL corvette ("Star Ravager").
destroy_master_rebel_2 = KesselCorvetteEncounter:new {
	className = "destroy_master_rebel_2",

	questName = "master_rebel_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 25000,
	-- Rebel pilots earn the Rebel "ace pilot" wearable (Zina FAQ §VI).
	aceRewardFaction = "rebel",

	corvetteAgent = "imp_corellian_corvette_tier4",
	escortAgents = { "imp_imperial_gunboat_tier5", "imp_imperial_gunboat_tier5" },
	spawnAnchor = KESSEL_IMPERIAL_CORVETTE_SPAWN,

	shipTypes = { "imp_corellian_corvette_tier4" },
}

registerScreenPlay("destroy_master_rebel_2", true)

KesselMasterEncounterScreenplay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KesselMasterEncounterScreenplay",
}

registerScreenPlay("KesselMasterEncounterScreenplay", true)

function KesselMasterEncounterScreenplay:start()
end

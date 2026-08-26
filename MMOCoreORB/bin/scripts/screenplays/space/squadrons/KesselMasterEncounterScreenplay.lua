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
	fighter escorts. The gunboats orbit the corvette's exit point and only need to be
	DISABLED: a disabled Kessel escort self-destructs after ~90 seconds (per-agent
	override read by ShipAiAgent::scheduleDestroyDisabled). The corvette will NOT
	spawn while its previous escorts still sit at its exit point.

	Documented Kessel exit / spawn coordinates (Scylla/Naritus, scrapbook):
	  * Rebel  Corellian Corvette : -7260, 4873, 6341  (also reported ~4870,-5056,-4765)
	  * Imperial Star Ravager     : -6231, -259, -6059 (also reported  7340, 7550, 6268)

	ZONE:
	  space_light1 IS this build's Kessel sector (kessel lootship patrol points live
	  in ship_mobile/patrol_points/space_light1.lua; zone enabled in bin/conf/config.lua).
	  The Stage 2 master encounter runs there, at the documented Kessel exit geometry.
	  Stage 1 (master_*_1) stays in each chain's existing questZone.

]]

-- Canonical (Live) target zone: space_light1 is the Kessel sector in this build.
-- Empty string => fall back to the quest's own questZone.
KESSEL_TARGET_ZONE = "space_light1"

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

	-- Alternating-hour spawn window (the two faction corvettes spawn ~1h apart):
	-- 0 = even KESSEL_CORVETTE_ALTERNATE_MS window, 1 = odd window (set per subclass).
	spawnWindowParity = 0,

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

	-- Only attempt a spawn when the player enters the quest (Kessel) zone; the Live
	-- schedule gate decides whether the corvette can actually appear right now.
	if (zoneNameHash == spaceQuestHash) then
		self:trySpawnCorvette(pPlayer)
	end

	return 0
end

--[[
	Live spawn schedule gate (scrapbook: MonsofoLexius + Zina):
	  * KESSEL_CORVETTE_ALTERNATE_MS : the two faction corvettes spawn ~1h apart --
	    each corvette only spawns during its own alternating-hour wall-clock window
	    (spawnWindowParity).
	  * KESSEL_CORVETTE_RESPAWN_MS   : minimum gap after a hyperspace exit before
	    this corvette can spawn again.
	  * KESSEL_CORVETTE_CYCLE_MS     : full per-faction cycle -- minimum gap between
	    successive spawns of this corvette.
	  * The corvette will NOT spawn while its previous gunboat escorts still sit at
	    its exit point (disable them -- they self-destruct -- or destroy them).
	If blocked, ONE re-check event is scheduled for when the earliest gate could clear.
]]
function KesselCorvetteEncounter:trySpawnCorvette(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":corvetteUp") == 1) then
		return
	end

	-- Re-check events can fire after the player has left; only spawn while in-zone.
	local spawnZone = self.questZone

	if (KESSEL_TARGET_ZONE ~= "") then
		spawnZone = KESSEL_TARGET_ZONE
	end

	if (SceneObject(pPlayer):getZoneName() ~= spawnZone) then
		deleteData(playerID .. ":" .. self.className .. ":pendingSpawnCheck")
		return
	end

	local now = getTimestampMilli()
	local delay = 0

	if (self:escortsAtExitPoint(playerID)) then
		-- Escorts still hold the exit point; re-check on the self-destruct cadence.
		delay = KESSEL_ESCORT_SELFDESTRUCT_MS
	else
		-- Alternating-hour faction window.
		local windowIndex = math.floor(now / KESSEL_CORVETTE_ALTERNATE_MS) % 2

		if (windowIndex ~= self.spawnWindowParity) then
			delay = KESSEL_CORVETTE_ALTERNATE_MS - (now % KESSEL_CORVETTE_ALTERNATE_MS)
		end

		-- Minimum gap since the last hyperspace exit.
		local lastExit = readData(playerID .. ":" .. self.className .. ":lastExitMs")

		if (lastExit ~= nil and lastExit > 0 and (now - lastExit) < KESSEL_CORVETTE_RESPAWN_MS) then
			delay = math.max(delay, KESSEL_CORVETTE_RESPAWN_MS - (now - lastExit))
		end

		-- Full per-faction cycle since the last spawn.
		local lastSpawn = readData(playerID .. ":" .. self.className .. ":lastSpawnMs")

		if (lastSpawn ~= nil and lastSpawn > 0 and (now - lastSpawn) < KESSEL_CORVETTE_CYCLE_MS) then
			delay = math.max(delay, KESSEL_CORVETTE_CYCLE_MS - (now - lastSpawn))
		end
	end

	if (delay == 0) then
		deleteData(playerID .. ":" .. self.className .. ":pendingSpawnCheck")

		if (self:spawnCorvetteEncounter(pPlayer)) then
			writeData(playerID .. ":" .. self.className .. ":corvetteUp", 1)
			writeData(playerID .. ":" .. self.className .. ":lastSpawnMs", now)
		end

		return
	end

	-- Schedule a single pending re-check for when the earliest gate could clear.
	if (readData(playerID .. ":" .. self.className .. ":pendingSpawnCheck") == 1) then
		return
	end

	writeData(playerID .. ":" .. self.className .. ":pendingSpawnCheck", 1)
	createEvent(delay, self.className, "spawnCheckEvent", pPlayer, "")
end

function KesselCorvetteEncounter:spawnCheckEvent(pPlayer)
	if (pPlayer == nil) then
		return
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. ":" .. self.className .. ":pendingSpawnCheck")
	self:trySpawnCorvette(pPlayer)
end

-- True while any previous escort gunboat still exists at the corvette's exit point.
-- Escorts that are gone (disabled self-destruct, destroyed, despawned) are pruned.
function KesselCorvetteEncounter:escortsAtExitPoint(playerID)
	local escortCount = readData(playerID .. ":" .. self.className .. ":escortCount")

	if (escortCount == nil or escortCount == 0) then
		return false
	end

	local anyPresent = false

	for i = 1, escortCount, 1 do
		local key = playerID .. ":" .. self.className .. ":escort:" .. i
		local escortID = readData(key)

		if (escortID ~= nil and escortID ~= 0) then
			if (getSceneObject(escortID) ~= nil) then
				anyPresent = true
			else
				deleteData(escortID .. ":destroyDisabledOverrideMs")
				deleteData(key)
			end
		end
	end

	if (not anyPresent) then
		deleteData(playerID .. ":" .. self.className .. ":escortCount")
	end

	return anyPresent
end

-- Spawn the command corvette plus its two tier-5 gunboat escorts.
-- Returns true only if the corvette itself spawned.
function KesselCorvetteEncounter:spawnCorvetteEncounter(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pPilotShip = SceneObject(pPlayer):getRootParent()

	if (pPilotShip == nil or not SceneObject(pPilotShip):isShipObject()) then
		return false
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

	-- Spawn the capital corvette (the mission target).
	local pCorvette = spawnShipAgent(self.corvetteAgent, spawnZone, ax, az, ay)

	if (pCorvette == nil) then
		Logger:log(self.className .. " -- FAILED to spawn corvette agent: " .. self.corvetteAgent, LT_ERROR)
		return false
	end

	ShipAiAgent(pCorvette):setMissionOwner(pPlayer)
	ShipAiAgent(pCorvette):setMinimumGuardPatrol(100)
	ShipAiAgent(pCorvette):setMaximumGuardPatrol(800)
	ShipAiAgent(pCorvette):setGuardPatrol()

	local corvetteID = SceneObject(pCorvette):getObjectID()
	writeData(corvetteID .. ":QuestOwner", SceneObject(pPlayer):getObjectID())
	CreatureObject(pPlayer):addSpaceMissionObject(corvetteID, true)

	writeData(playerID .. ":" .. self.className .. ":corvetteID", corvetteID)

	-- Scope flag read by ShipManager::notifyDestruction (C++): only THIS spawned
	-- corvette counts for master credit, not convoy/station-squad corvettes that
	-- happen to share the same ship template.
	writeData(corvetteID .. ":kesselMasterCorvette", 1)

	if (self.DEBUG_KESSEL_ENCOUNTER) then
		print(self.className .. " -- spawned corvette " .. self.corvetteAgent .. " in " .. spawnZone)
	end

	-- Spawn the two tier-5 gunboat escorts orbiting the corvette's exit point.
	-- Escorts are tracked separately: they OUTLIVE the corvette's dwell and block
	-- its respawn while they still hold the exit point (scrapbook).
	local escortCount = 0

	for i = 1, #self.escortAgents, 1 do
		local pEscort = spawnShipAgent(self.escortAgents[i], spawnZone,
			ax + getRandomNumber(100, 200), az, ay + getRandomNumber(100, 200))

		if (pEscort ~= nil) then
			ShipAiAgent(pEscort):setMissionOwner(pPlayer)
			ShipAiAgent(pEscort):setMinimumGuardPatrol(100)
			ShipAiAgent(pEscort):setMaximumGuardPatrol(1000)
			ShipAiAgent(pEscort):setGuardPatrol()

			local escortID = SceneObject(pEscort):getObjectID()

			escortCount = escortCount + 1
			writeData(playerID .. ":" .. self.className .. ":escort:" .. escortCount, escortID)

			-- Disabled Kessel escorts self-destruct after ~90s instead of the generic
			-- 300s (override read by ShipAiAgent::scheduleDestroyDisabled).
			writeData(escortID .. ":destroyDisabledOverrideMs", KESSEL_ESCORT_SELFDESTRUCT_MS)
		end
	end

	writeData(playerID .. ":" .. self.className .. ":escortCount", escortCount)

	-- Authentic dwell: the corvette stays ~45 min then hyperspaces out (Zina FAQ).
	-- If the player has not destroyed it by then, this trip's corvette is lost; it can
	-- respawn on a later zone entry.
	createEvent(KESSEL_CORVETTE_DWELL_MS, self.className, "hyperspaceOutCorvette", pPlayer, "")

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")
	SpaceHelpers:sendQuestUpdate(pPlayer, "An enemy Corellian Corvette and its gunboat escorts have been detected. Destroy the corvette's sub-components to complete your mission.")

	return true
end

-- Authentic ~45-minute dwell expiry: despawn the corvette (it "hyperspaces out") if
-- the player has not destroyed it. Its gunboat escorts are LEFT BEHIND at the exit
-- point (scrapbook): the corvette cannot respawn while they remain, so they must be
-- disabled (they then self-destruct in ~90s) or destroyed first.
function KesselCorvetteEncounter:hyperspaceOutCorvette(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Already destroyed/cleared (quest completed or reset) -> nothing to hyperspace out.
	if (readData(playerID .. ":" .. self.className .. ":corvetteUp") ~= 1) then
		return
	end

	local corvetteID = readData(playerID .. ":" .. self.className .. ":corvetteID")

	if (corvetteID ~= nil and corvetteID ~= 0) then
		local pShip = getSceneObject(corvetteID)

		if (pShip ~= nil) then
			CreatureObject(pPlayer):removeSpaceMissionObject(corvetteID, true)
			SpaceHelpers:delayedDestroyShipAgent(pShip)
		end

		deleteData(corvetteID .. ":kesselMasterCorvette")
		deleteData(playerID .. ":" .. self.className .. ":corvetteID")
	end

	deleteData(playerID .. ":" .. self.className .. ":corvetteUp")
	writeData(playerID .. ":" .. self.className .. ":lastExitMs", getTimestampMilli())

	SpaceHelpers:sendQuestUpdate(pPlayer, "The enemy corvette has jumped to hyperspace before you could destroy it. Its escorts remain at the exit point; the corvette will not return while they hold it.")
end

-- Clear our spawn state whenever the quest is reset/failed/completed.
function KesselCorvetteEncounter:clearEncounterState(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	local corvetteID = readData(playerID .. ":" .. self.className .. ":corvetteID")

	if (corvetteID ~= nil and corvetteID ~= 0) then
		deleteData(corvetteID .. ":kesselMasterCorvette")
	end

	deleteData(playerID .. ":" .. self.className .. ":corvetteID")

	local escortCount = readData(playerID .. ":" .. self.className .. ":escortCount")

	for i = 1, escortCount, 1 do
		local key = playerID .. ":" .. self.className .. ":escort:" .. i
		local escortID = readData(key)

		-- Keep the self-destruct override while the escort still exists (so a later
		-- disable still triggers the ~90s destruct); drop it once the ship is gone.
		if (escortID ~= nil and escortID ~= 0 and getSceneObject(escortID) == nil) then
			deleteData(escortID .. ":destroyDisabledOverrideMs")
		end

		deleteData(key)
	end

	deleteData(playerID .. ":" .. self.className .. ":escortCount")
	deleteData(playerID .. ":" .. self.className .. ":corvetteUp")
	deleteData(playerID .. ":" .. self.className .. ":pendingSpawnCheck")
	deleteData(playerID .. ":" .. self.className .. ":lastSpawnMs")
	deleteData(playerID .. ":" .. self.className .. ":lastExitMs")
end

function KesselCorvetteEncounter:resetQuest(pPlayer)
	self:clearEncounterState(pPlayer)
	SpaceDestroyScreenplay.resetQuest(self, pPlayer)
end

-- Authentic Kessel Master reward (Biophilia Pre-CU Scrapbook v5.1, Zina FAQ v3.0b §VI):
-- the "ace pilot" wearable title. Grants the faction + gender-appropriate ace-pilot necklace.
-- (Ace badge + master skill are granted in grantPilotMastery; faction helmet remains
-- documented-only -- see fidelity doc.)
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

-- Squadron trainer -> ace badge. Badge ids come from TRE datatables/badge/badge_map.iff
-- (130-138); the UPPERCASE globals are auto-registered from the badge map at boot
-- (DirectorManager), so they always match the runtime badge table.
function KesselCorvetteEncounter:getAceBadge(squadronType)
	if (squadronType == VORTEX_SQUADRON) then
		return PILOT_REBEL_NAVY_NABOO
	elseif (squadronType == HAVOC_SQUADRON) then
		return PILOT_REBEL_NAVY_CORELLIA
	elseif (squadronType == CRIMSON_PHOENIX_SQUADRON) then
		return PILOT_REBEL_NAVY_TATOOINE
	elseif (squadronType == INQUISITION_SQUADRON) then
		return PILOT_IMPERIAL_NAVY_NABOO
	elseif (squadronType == BLACK_EPSILON_SQUADRON) then
		return PILOT_IMPERIAL_NAVY_CORELLIA
	elseif (squadronType == STORM_SQUADRON) then
		return PILOT_IMPERIAL_NAVY_TATOOINE
	elseif (squadronType == RSF_SQUADRON) then
		return PILOT_NEUTRAL_NABOO
	elseif (squadronType == CORSEC_SQUADRON) then
		return PILOT_NEUTRAL_CORELLIA
	elseif (squadronType == SMUGGLER_SQUADRON) then
		return PILOT_NEUTRAL_TATOOINE
	end

	return nil
end

-- Pilot mastery (scrapbook §2.3/§2.4): completing the corvette mission masters the
-- profession -- the master box costs missions only, no XP. Grants the faction master
-- skill box and the squadron's ace badge. Prestige-in-place-of-XP then follows
-- automatically: PlayerManager::disseminateSpaceExperience awards prestige_* instead
-- of pilot XP once the master skill is held.
function KesselCorvetteEncounter:grantPilotMastery(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local masterSkill = ""

	if (SpaceHelpers:isNeutralPilot(pPlayer)) then
		masterSkill = "pilot_neutral_master"
	elseif (SpaceHelpers:isRebelPilot(pPlayer)) then
		masterSkill = "pilot_rebel_navy_master"
	elseif (SpaceHelpers:isImperialPilot(pPlayer)) then
		masterSkill = "pilot_imperial_navy_master"
	end

	if (masterSkill ~= "") then
		SpaceHelpers:grantSpaceSkill(pPlayer, masterSkill, false)
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local badge = self:getAceBadge(PlayerObject(pGhost):getSquadronType())

	if (badge ~= nil) then
		PlayerObject(pGhost):awardBadge(badge)
	end
end

function KesselCorvetteEncounter:completeQuest(pPlayer, notifyClient)
	self:grantAcePilotReward(pPlayer)
	self:grantPilotMastery(pPlayer)
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

	questZone = "space_light1",

	creditReward = 10000,

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

function destroy_master_imperial_1:completeQuest(pPlayer, notifyClient)
	SpaceDestroyScreenplay.completeQuest(self, pPlayer, notifyClient)

	if (pPlayer ~= nil) then
		CreatureObject(pPlayer):sendSystemMessage("Return to Grand Admiral Nial Declann on Naboo for further orders.")
	end
end

registerScreenPlay("destroy_master_imperial_1", true)

-- Rebel / Freelancer-rebel pilots: weaken the Imperial battlegroup -- 30 TIEs/gunboats.
destroy_master_rebel_1 = SpaceDestroyScreenplay:new {
	className = "destroy_master_rebel_1",

	questName = "master_rebel_1",
	questType = "destroy",

	questZone = "space_light1",

	creditReward = 10000,

	sideQuest = true,
	sideQuestType = "destroy",
	sideQuestName = "master_rebel_2",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION,

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

	-- space_light1 = Kessel in this build; the master encounter runs there.
	questZone = "space_light1",

	creditReward = 25000,
	-- Imperial pilots earn the Imperial "ace pilot" wearable (Zina FAQ §VI).
	aceRewardFaction = "empire",

	-- Rebel corvette takes the even alternating-hour window.
	spawnWindowParity = 0,

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

	-- space_light1 = Kessel in this build; the master encounter runs there.
	questZone = "space_light1",

	creditReward = 25000,
	-- Rebel pilots earn the Rebel "ace pilot" wearable (Zina FAQ §VI).
	aceRewardFaction = "rebel",

	-- Imperial Star Ravager takes the odd window (the two vettes spawn ~1h apart).
	spawnWindowParity = 1,

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

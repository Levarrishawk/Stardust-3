--[[
Myyydril Grievous encounter  --  theme_park.dungeon.myyydril.grievous_*

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live attached grievous_encounter_lock to the caverns BUILDING. The lock
creates (and later finds) object/tangible/theme_park/myyydril/myyydril_grievous_encounter_manager.iff
in the encounter cells; the manager is the 31-minute spawn state machine.
This screenplay is both lock and manager, on snapshot copy #0 only
(node 14400001). Core3 has no per-building script attach; ENTEREDBUILDING
on that node is the cell-entry shape (trando_slave_camp.lua:333).

JAVA -> LUA

	grievous_encounter_lock.java     session, grace, hall56-58 containment,
	                                 beginEncounter, eject to hall59
	grievous_encounter_manager.java  Grievous + 2 NK-3, machine, power cells,
	                                 spawn-speed vs generator health, wipe
	grievous_ai.java                 absorb countdown; DAMAGERECEIVED interrupt
	grievous_death.java              loot roll (tab rows; java also hard-codes
	                                 items that are OPEN here)
	grievous_player.java             OnAttach signalLornRetrieveCompleted
	grievous_guard.java              OBJECTDESTRUCTION -> numMobs
	power_cell.java / machine.java   OPEN: neither IFF is in the tree
	myyydril_player.java             OPEN: uncontained-in-pob warp to dead
	                                 forest; no Lua binding for that attach
	cantina_setup.java               lightningroom34 special_room
	magic_stone.java                 OPEN: no caverns.tab object row, no IFF
	wirartu_attack.java              50% HAM -> chat + peace; arena champion

WHO MAY START  --  lock.java:388-402 plus the servant conversation

	beginEncounter checks isQuestEligible before a session is allocated:
	  non-god callers need myyydrilLornRetrieve6ScreenPlay stage == 2
	  (readScreenPlayData under that screenplay name; refused if the
	  global is absent). God callers skip the quest gate.
	ep3_myyydril_lorn_servant.java is the live quest gate:
	  lockout objvar instance_lockout.myyydril_grievous.lockout_end
	    -> writeScreenPlayData(pPlayer, "MyyydrilGrievous", "lockout_end")
	  isTaskActive(ep3_myyydril_lorn_retrieve_6, "lornRetrieveCompleted")
	    -> readScreenPlayData(pPlayer, "myyydrilLornRetrieve6ScreenPlay", "stage") == 2
	  isTaskActive(..., "taskRetrieveCrystal") is stage 1 (refuse start, wait)
	  hasBadge is hardcoded false in the java (line 29) -- never a gate
	  isGod skips lockout and may start via s_492
	The servant row is OPEN (no repo template). Conversation is the arc's
	job; this file exports MyyydrilGrievous.beginEncounter(pPlayer).

COORDINATE TRANSFORM  --  POB interior, KashyyykPobPopulation axis mapping

	repo x        <-  loc_x / java x
	repo z        <-  loc_y / java y     (height)
	repo y        <-  loc_z / java z
	spawnMobile heading is degrees. spawnSceneObject heading is a quat
	from yaw degrees (trando_slave_camp.lua:273-275).

CELL NAMES

	lock.java:17-24. Lookup is BuildingObject:getNamedCell, the same call
	KashyyykPobPopulation:resolveCell uses. The caverns POB has 79 cells
	(copy stride 80). Room names encode the cell index (hallN is cell N).
	Derived name->index:

		hall55  55  start_cell                 lock.java:17
		hall56  56  entry_cell                 lock.java:18
		hall57  57  encounter + machine/mobs   lock.java:22, manager.java:55
		hall58  58  encounter                  lock.java:23
		hall59  59  exit_cell                  lock.java:19

	printCellMap walks getCellName(i) at boot, records the live table, and
	prints those five. Spawn-tab rooms prove hall55 / hall57 / hall58.
	hall56 and hall59 are layout-only warp cells (no spawn row).
--]]

MyyydrilGrievous = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MyyydrilGrievous",

	zoneName = "kashyyyk_pob_dungeons",
	buildingID = 14400001,

	-- lock.java:17-24. Name->index derived from the POB cell list
	-- (room name encodes the index; 79 cells, copy stride 80).
	startCell = "hall55",
	entryCell = "hall56",
	exitCell = "hall59",
	encounterCells = { "hall56", "hall57", "hall58" },
	cellIndex = {
		hall55 = 55,
		hall56 = 56,
		hall57 = 57,
		hall58 = 58,
		hall59 = 59,
	},

	-- lock.java:36-37
	gracePeriod = 300,
	encounterLength = 1860,
	-- lock.java:164
	lockoutSeconds = 1800,

	-- manager.java:92-106. Java spawn name ep3_general_grievous is not a
	-- CreatureTemplates key; general_grievous is the same IFF
	-- object/mobile/ep3/general_grievous.iff. Guards: ep3_myyydril_nk3
	-- exists; it is a level-4 townsperson (pvpBitmask NONE) -- spawn it,
	-- do not substitute. No creature edits.
	grievousTemplate = "general_grievous",
	guardTemplate = "ep3_myyydril_nk3",

	-- manager.java:57-58, 88-98. Interior, so no world offset.
	machineLoc = { x = -227.2, z = -92.6, y = 156.2, cell = "hall57" },
	grievousLoc = { x = -216.9, z = -93.8, y = 137.3, cell = "hall57" },
	guard1Loc = { x = -215.3, z = -94.0, y = 138.4, cell = "hall57" },
	guard2Loc = { x = -217.2, z = -93.7, y = 134.9, cell = "hall57" },

	-- lock.java:150-154, 158-166
	entryLoc = { x = -280, z = -108, y = -18 },
	exitLoc = { x = -163, z = -88, y = 127 },

	-- power_cell_locations.tab file lines 3-6 (manager.java:68 table,
	-- :73 rand(0,3) on begin; :156 rand(0,5) on respawn -- clamp 0..3).
	powerCellLocs = {
		{ x = -219, z = -93, y = 151.6 },   -- tab file line 3; manager.java:73
		{ x = -230, z = -92.7, y = 129.1 }, -- tab file line 4
		{ x = -254.3, z = -98, y = 144.7 }, -- tab file line 5
		{ x = -257, z = -98.3, y = 166.3 }, -- tab file line 6
	},

	-- OURS: champion lookup retries (arena may start after this screenplay).
	wirartuMaxAttempts = 12,
	wirartuRetryMs = 5000,

	-- OPEN: object/tangible/theme_park/myyydril/myyydril_machine.iff
	-- OPEN: object/tangible/theme_park/myyydril/myyydril_power_cell.iff
	-- OPEN: object/tangible/theme_park/myyydril/myyydril_grievous_encounter_manager.iff
	machineTemplate = "object/tangible/theme_park/myyydril/myyydril_machine.iff",
	powerCellTemplate = "object/tangible/theme_park/myyydril/myyydril_power_cell.iff",

	-- loot_items/kashyyyk/myyydril_grievous.tab rows 3-14. No grievous_loot.tab
	-- in sys.server datatables. Every listed IFF is in this tree.
	lootItems = {
		"object/weapon/melee/special/ep3_loot_necrosis.iff",
		"object/weapon/melee/sword/ep3_loot_ripper.iff",
		"object/weapon/melee/2h_sword/ep3_loot_executer.iff",
		"object/weapon/melee/polearm/ep3_loot_poisonspike.iff",
		"object/weapon/ranged/rifle/ep3_loot_darksting.iff",
		"object/weapon/ranged/pistol/ep3_loot_deathrain.iff",
		"object/weapon/ranged/carbine/ep3_loot_grievance.iff",
		"object/weapon/ranged/rifle/ep3_loot_nullifier.iff",
		"object/weapon/ranged/rifle/rifle_proton.iff",
		"object/weapon/ranged/rifle/ep3_loot_retaliation.iff",
		"object/weapon/ranged/pistol/ep3_loot_calibrated.iff",
		"object/weapon/ranged/rifle/ep3_loot_dawnsorrow.iff",
	},

	-- grievous_death.java:48-50. starfighter deed OPEN (no template).
	-- color crystal / wheel-bike deed are static_item names, OPEN.
	alwaysLoot = {
		"object/tangible/wearables/cybernetic/s02/cybernetic_s02_arm_r.iff",
	},

	-- ep3_myyydril_caverns.tab file lines cited by the arc. Axis mapping
	-- as KashyyykPobPopulation: x=loc_x, z=loc_y, y=loc_z, yaw degrees.
	retrieveObjects = {
		{ line = 593, template = "object/tangible/quest/pod_egg_sacs.iff", cell = "hall74", x = -73.5749, z = -201.75, y = -159.047, yaw = -37.302, arc = "myyydrilKallaaracRetrieve1ScreenPlay" },
		{ line = 292, template = "object/tangible/quest/warl_cave_plant.iff", cell = "hall18", x = 147.374, z = -41.3962, y = -11.4858, yaw = 168, arc = "myyydrilKirirrGather1ScreenPlay" },
		{ line = 765, template = "object/tangible/quest/r_naktra_crystals.iff", cell = "borglestatue49", x = -365.355, z = -256.536, y = -119.002, yaw = -104.164, arc = "myyydrilLornRetrieve6ScreenPlay" },
		{ line = 834, template = "object/tangible/quest/nawika_jewel_box.iff", cell = "bigroom40", x = -10.6357, z = -213.658, y = -166.037, yaw = -43.6363, arc = "myyydrilNawikaEscort1ScreenPlay" },
		{ line = 454, template = "object/tangible/quest/luilris_mushrooms.iff", cell = "hall26", x = 161.75, z = -58.5727, y = -10.5915, yaw = 33.6729, arc = "myyydrilYrakaRetrieve2ScreenPlay" },
	},

	lornScreenPlay = "myyydrilLornRetrieve6ScreenPlay",
	stf = "@dungeon/myyydril:",
}

registerScreenPlay("MyyydrilGrievous", true)

function MyyydrilGrievous:start()
	if (not isZoneEnabled(self.zoneName)) then
		return
	end

	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("MyyydrilGrievous: building " .. self.buildingID .. " is missing; encounter is idle")
		return
	end

	self:printCellMap(pBuilding)
	self:resetEncounter()
	self:spawnRetrieveObjects(pBuilding)
	self:setupCantina(pBuilding)
	self:attachWirartuAttack()

	createObserver(ENTEREDBUILDING, "MyyydrilGrievous", "notifyEnteredBuilding", pBuilding)
end

function MyyydrilGrievous:printCellMap(pBuilding)
	local total = BuildingObject(pBuilding):getTotalCellNumber()
	self.cellIndex = {}

	for i = 1, total do
		local name = BuildingObject(pBuilding):getCellName(i)

		if (name == nil) then
			name = ""
		end

		if (name ~= "") then
			self.cellIndex[name] = i
		end

		print("MyyydrilGrievous: cell index " .. i .. " name '" .. name .. "' node " .. (self.buildingID + i))
	end

	local names = { "hall55", "hall56", "hall57", "hall58", "hall59" }

	for i = 1, #names do
		local idx = self.cellIndex[names[i]]

		if (idx == nil) then
			print("MyyydrilGrievous: name->index '" .. names[i] .. "' MISSING")
		else
			print("MyyydrilGrievous: name->index '" .. names[i] .. "' = " .. idx)
		end
	end
end

function MyyydrilGrievous:resolveCell(pBuilding, cellName)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function MyyydrilGrievous:headingToQuat(yaw)
	local half = math.rad(yaw) * 0.5
	return math.cos(half), 0, math.sin(half), 0
end

function MyyydrilGrievous:questStage(pPlayer, screenplayName)
	return tonumber(readScreenPlayData(pPlayer, screenplayName, "stage")) or 0
end

function MyyydrilGrievous:isGod(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):hasGodMode()
end

function MyyydrilGrievous:isLockoutClear(pPlayer)
	if (self:isGod(pPlayer)) then
		return true
	end

	local lockoutEnd = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "lockout_end")) or 0

	return getTimestamp() >= lockoutEnd
end

-- Conversation gate. Lock.java beginEncounter does not read quests; the
-- servant does. Stage 2 is Wait for Signal lornRetrieveCompleted.
-- Non-god callers are refused unless that stage is 2, read under the
-- screenplay name and guarded on the global, before a session is allocated.
function MyyydrilGrievous:isQuestEligible(pPlayer)
	if (self:isGod(pPlayer)) then
		return true
	end

	if (myyydrilLornRetrieve6ScreenPlay == nil) then
		print("myyydril_grievous.lua: myyydrilLornRetrieve6ScreenPlay absent; start refused")
		return false
	end

	return self:questStage(pPlayer, self.lornScreenPlay) == 2
end

function MyyydrilGrievous:dataKey(suffix)
	return "MyyydrilGrievous:" .. suffix
end

function MyyydrilGrievous:getSessionId()
	return readData(self:dataKey("session"))
end

function MyyydrilGrievous:isActive()
	return readData(self:dataKey("active")) == 1
end

function MyyydrilGrievous:playerSessionKey(pPlayer)
	return SceneObject(pPlayer):getObjectID() .. ":MyyydrilGrievous:session"
end

function MyyydrilGrievous:isEventPlayer(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (readData(SceneObject(pPlayer):getObjectID() .. ":MyyydrilGrievous:god") == 1) then
		return true
	end

	if (not self:isActive()) then
		return false
	end

	return readData(self:playerSessionKey(pPlayer)) == self:getSessionId()
end

function MyyydrilGrievous:raiseSignal(pPlayer, name)
	if (pPlayer == nil) then
		return
	end

	if MyyydrilSignals ~= nil then
		MyyydrilSignals:raise(pPlayer, name)
	else
		print("myyydril_grievous.lua: MyyydrilSignals absent; " .. name .. " not raised")
	end
end

-- Conversation / god start. lock.java:388 beginEncounter.
function MyyydrilGrievous.beginEncounter(pPlayer)
	MyyydrilGrievous:doBeginEncounter(pPlayer)
end

function MyyydrilGrievous:doBeginEncounter(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		return
	end

	if (not self:isQuestEligible(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "encounter_not_available")
		return
	end

	local overrideLock = self:isGod(pPlayer)

	if (not self:isSessionAvailable(pBuilding, overrideLock)) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "encounter_not_available")
		return
	end

	if (not self:isLockoutClear(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "encounter_not_available")
		return
	end

	local sessionId = self:setSessionIds()
	self:moveGroupIntoEncounter(pPlayer, pBuilding, sessionId)
	writeData(self:dataKey("active"), 1)
	self:raiseSignal(pPlayer, "signalCompleteGrievousPrequest")
	self:startEventTimer(sessionId)
	createEvent(5000, "MyyydrilGrievous", "handleBeginEncounter", pBuilding, "")
end

function MyyydrilGrievous:setSessionIds()
	-- writeData is uint64 (screenplay.lua:5 -> writeSharedMemory). Java stores
	-- current session as -1 when idle; 0 here is idle, sessions start at 1.
	local sessionId = readData(self:dataKey("sessionCount")) + 1
	writeData(self:dataKey("session"), sessionId)
	writeData(self:dataKey("sessionCount"), sessionId)
	return sessionId
end

function MyyydrilGrievous:isSessionAvailable(pBuilding, godOverride)
	if (godOverride) then
		self:resetEncounter()
		return true
	end

	if (self:isActive()) then
		return self:validateEncounterSession(pBuilding)
	end

	self:resetEncounter()
	return true
end

function MyyydrilGrievous:validateEncounterSession(pBuilding)
	local graceEnd = readData(self:dataKey("graceEnd"))

	if (graceEnd ~= 0 and getTimestamp() < graceEnd) then
		return false
	end

	self:ejectInvalidPlayers(pBuilding)

	local players = self:getPlayersInEncounterArea(pBuilding)

	if (#players == 0) then
		self:resetEncounter()
		return true
	end

	return false
end

function MyyydrilGrievous:moveGroupIntoEncounter(pPlayer, pBuilding, sessionId)
	local startID = self:resolveCell(pBuilding, self.startCell)

	if (startID == 0) then
		print("MyyydrilGrievous: no cell named '" .. self.startCell .. "'")
		return
	end

	if (not CreatureObject(pPlayer):isGrouped()) then
		if (SceneObject(pPlayer):getParentID() == startID) then
			self:moveSinglePlayerIntoEncounter(pPlayer, pBuilding, sessionId)
		end

		return
	end

	local groupSize = CreatureObject(pPlayer):getGroupSize()

	for i = 0, groupSize - 1 do
		local pMember = CreatureObject(pPlayer):getGroupMember(i)

		if (pMember ~= nil and SceneObject(pMember):isPlayerCreature() and SceneObject(pMember):getParentID() == startID) then
			self:moveSinglePlayerIntoEncounter(pMember, pBuilding, sessionId)
		end
	end
end

function MyyydrilGrievous:moveSinglePlayerIntoEncounter(pPlayer, pBuilding, sessionId)
	local entryID = self:resolveCell(pBuilding, self.entryCell)

	if (entryID == 0) then
		print("MyyydrilGrievous: no cell named '" .. self.entryCell .. "'")
		return
	end

	writeData(self:playerSessionKey(pPlayer), sessionId)
	writeData(SceneObject(pPlayer):getObjectID() .. ":MyyydrilGrievous:player", 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "lockout_end", tostring(getTimestamp() + self.lockoutSeconds))

	if (self:isGod(pPlayer)) then
		writeData(SceneObject(pPlayer):getObjectID() .. ":MyyydrilGrievous:god", 1)
	end

	-- grievous_player.java:16 OnAttach
	self:raiseSignal(pPlayer, "signalLornRetrieveCompleted")

	local loc = self.entryLoc
	SceneObject(pPlayer):teleport(loc.x, loc.z, loc.y, entryID)
	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "encounter_begin")
end

function MyyydrilGrievous:ejectPlayersFromEncounter(pPlayer, pBuilding)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
		CreatureObject(pPlayer):setPosture(UPRIGHT)
		CreatureObject(pPlayer):healDamage(100000, 0)
		CreatureObject(pPlayer):healDamage(100000, 1)
		CreatureObject(pPlayer):healDamage(100000, 2)
	end

	self:clearPlayerSession(pPlayer)

	local exitID = self:resolveCell(pBuilding, self.exitCell)

	if (exitID == 0) then
		print("MyyydrilGrievous: no cell named '" .. self.exitCell .. "'")
		return
	end

	local loc = self.exitLoc
	SceneObject(pPlayer):teleport(loc.x, loc.z, loc.y, exitID)
end

function MyyydrilGrievous:clearPlayerSession(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	deleteData(playerID .. ":MyyydrilGrievous:session")
	deleteData(playerID .. ":MyyydrilGrievous:player")
	deleteData(playerID .. ":MyyydrilGrievous:god")
end

function MyyydrilGrievous:getPlayersInEncounterArea(pBuilding)
	local players = {}

	for i = 1, #self.encounterCells do
		local cellID = self:resolveCell(pBuilding, self.encounterCells[i])

		if (cellID ~= 0) then
			local pCell = getSceneObject(cellID)

			if (pCell ~= nil) then
				for j = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
					local pObj = SceneObject(pCell):getContainerObject(j)

					if (pObj ~= nil and SceneObject(pObj):isPlayerCreature()) then
						table.insert(players, pObj)
					end
				end
			end
		end
	end

	return players
end

function MyyydrilGrievous:getEventPlayersInDungeon(pBuilding)
	local players = {}
	local total = BuildingObject(pBuilding):getTotalCellNumber()

	for i = 1, total do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
				local pObj = SceneObject(pCell):getContainerObject(j)

				if (pObj ~= nil and SceneObject(pObj):isPlayerCreature() and self:isEventPlayer(pObj)) then
					table.insert(players, pObj)
				end
			end
		end
	end

	return players
end

function MyyydrilGrievous:ejectInvalidPlayers(pBuilding)
	local players = self:getPlayersInEncounterArea(pBuilding)

	for i = 1, #players do
		if (not self:isEventPlayer(players[i])) then
			self:ejectPlayersFromEncounter(players[i], pBuilding)
		end
	end
end

function MyyydrilGrievous:notifyEnteredBuilding(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local parentID = SceneObject(pPlayer):getParentID()
	local inEncounter = false

	for i = 1, #self.encounterCells do
		local cellID = self:resolveCell(pBuilding, self.encounterCells[i])

		if (cellID ~= 0 and parentID == cellID) then
			inEncounter = true
			break
		end
	end

	if (not inEncounter) then
		return 0
	end

	createEvent(0, "MyyydrilGrievous", "validatePlayersInEvent", pBuilding, "")
	return 0
end

function MyyydrilGrievous:validatePlayersInEvent(pBuilding)
	if (pBuilding == nil) then
		return
	end

	self:ejectInvalidPlayers(pBuilding)

	local players = self:getPlayersInEncounterArea(pBuilding)

	if (#players == 0) then
		self:resetEncounter()
	end
end

function MyyydrilGrievous:startEventTimer(sessionId)
	local now = getTimestamp()
	writeData(self:dataKey("start"), now)
	writeData(self:dataKey("end"), now + self.encounterLength)
	writeData(self:dataKey("graceEnd"), now + self.gracePeriod)
	createEvent(0, "MyyydrilGrievous", "handleSessionTimerUpdate", getSceneObject(self.buildingID), tostring(sessionId))
end

function MyyydrilGrievous:handleSessionTimerUpdate(pBuilding, sessionStr)
	if (pBuilding == nil) then
		return
	end

	local passedSession = tonumber(sessionStr) or -1

	if (self:getSessionId() ~= passedSession) then
		return
	end

	local remaining = readData(self:dataKey("end")) - getTimestamp()

	if (remaining < 1) then
		self:resetEncounter()
		return
	end

	local msg = self.stf .. "encounter_end_soon"

	if (remaining > 1800) then
		msg = self.stf .. "thirty_minute_warning"
	elseif (remaining > 300) then
		msg = self.stf .. "five_minute_warning"
	elseif (remaining > 60) then
		msg = self.stf .. "one_minute_warning"
	end

	local players = self:getEventPlayersInDungeon(pBuilding)

	for i = 1, #players do
		CreatureObject(players[i]):sendSystemMessage(msg)
	end

	local nextDelay = self:calculateNextMessage(remaining)
	createEvent(nextDelay * 1000, "MyyydrilGrievous", "handleSessionTimerUpdate", pBuilding, tostring(passedSession))
end

function MyyydrilGrievous:calculateNextMessage(remaining)
	if (remaining > 1800) then
		return remaining - 1800
	end

	if (remaining > 300) then
		return remaining - 300
	end

	if (remaining > 60) then
		return remaining - 60
	end

	if (remaining > 10) then
		return remaining - 10
	end

	return remaining
end

function MyyydrilGrievous:handleBeginEncounter(pBuilding)
	if (pBuilding == nil or not self:isActive()) then
		return
	end

	writeData(self:dataKey("numMobs"), 3)
	writeData(self:dataKey("powerCellsActive"), 0)
	writeData(self:dataKey("powerSpawn"), 20)
	writeData(self:dataKey("cleaning"), 0)

	local hall57 = self:resolveCell(pBuilding, "hall57")

	if (hall57 == 0) then
		print("MyyydrilGrievous: no cell named 'hall57'; encounter mobs not spawned")
		return
	end

	self:spawnMachine(hall57)
	self:spawnInitialPowerCells(pBuilding, hall57)
	self:spawnGrievous(hall57)
	self:spawnGuard(self.guard1Loc, hall57, "guard1")
	self:spawnGuard(self.guard2Loc, hall57, "guard2")
end

function MyyydrilGrievous:spawnMachine(cellID)
	-- OPEN: myyydril_machine.iff is not in the tree. Never a look-alike.
	-- Generator-health spawn-speed stays at the java default 20s.
	print("MyyydrilGrievous: OPEN spawn " .. self.machineTemplate)
end

function MyyydrilGrievous:spawnInitialPowerCells(pBuilding, cellID)
	-- OPEN: myyydril_power_cell.iff is not in the tree. Never a look-alike.
	-- Absorb loop and respawn therefore have nothing to find.
	print("MyyydrilGrievous: OPEN spawn " .. self.powerCellTemplate .. " x2")
end

function MyyydrilGrievous:spawnGrievous(cellID)
	if (not creatureTemplateExists(self.grievousTemplate)) then
		print("MyyydrilGrievous: OPEN spawn ep3_general_grievous (no repo template)")
		return
	end

	local loc = self.grievousLoc
	local pMob = spawnMobile(self.zoneName, self.grievousTemplate, 0, loc.x, loc.z, loc.y, 0, cellID)

	if (pMob == nil) then
		print("MyyydrilGrievous: failed to spawn " .. self.grievousTemplate)
		return
	end

	writeData(self:dataKey("grievous"), SceneObject(pMob):getObjectID())
	writeData(SceneObject(pMob):getObjectID() .. ":MyyydrilGrievous:power", 0)
	writeData(SceneObject(pMob):getObjectID() .. ":MyyydrilGrievous:absorbing", 0)
	createObserver(OBJECTDESTRUCTION, "MyyydrilGrievous", "notifyGrievousKilled", pMob)
	createObserver(DAMAGERECEIVED, "MyyydrilGrievous", "notifyGrievousDamaged", pMob)
	createEvent(10000, "MyyydrilGrievous", "handleGrievousAiLoop", pMob, "")
end

function MyyydrilGrievous:spawnGuard(loc, cellID, key)
	if (not creatureTemplateExists(self.guardTemplate)) then
		print("MyyydrilGrievous: OPEN spawn ep3_myyydril_nk3 (no repo template)")
		return
	end

	local pMob = spawnMobile(self.zoneName, self.guardTemplate, 0, loc.x, loc.z, loc.y, 0, cellID)

	if (pMob == nil) then
		print("MyyydrilGrievous: failed to spawn " .. self.guardTemplate)
		return
	end

	writeData(self:dataKey(key), SceneObject(pMob):getObjectID())
	createObserver(OBJECTDESTRUCTION, "MyyydrilGrievous", "notifyGuardKilled", pMob)
end

function MyyydrilGrievous:notifyGrievousDamaged(pGrievous, pAttacker)
	if (pGrievous == nil) then
		return 0
	end

	-- grievous_ai.java:157-160 OnCreatureDamaged cancels the absorb.
	writeData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing", 0)
	return 0
end

function MyyydrilGrievous:handleGrievousAiLoop(pGrievous)
	if (pGrievous == nil or readData(self:dataKey("cleaning")) == 1) then
		return
	end

	if (readData(self:dataKey("grievous")) ~= SceneObject(pGrievous):getObjectID()) then
		return
	end

	local level = readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:power")

	if (level < 5) then
		local pCell = self:lookForPowerCells(pGrievous)

		if (pCell ~= nil and readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing") == 0) then
			writeData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:targetCell", SceneObject(pCell):getObjectID())
			createEvent(7000, "MyyydrilGrievous", "handleAbsorbPowerCell", pGrievous, "")
		end
	end

	createEvent(10000, "MyyydrilGrievous", "handleGrievousAiLoop", pGrievous, "")
end

function MyyydrilGrievous:lookForPowerCells(pGrievous)
	-- Power-cell IFF is OPEN. When that template lands, spawn IDs are stored
	-- under MyyydrilGrievous:powerCellN and this loop can follow them.
	local n = readData(self:dataKey("powerCellsActive"))

	for i = 1, n do
		local oid = readData(self:dataKey("powerCell" .. i))
		local pCell = getSceneObject(oid)

		if (pCell ~= nil) then
			AiAgent(pGrievous):setFollowObject(pCell)
			return pCell
		end
	end

	return nil
end

function MyyydrilGrievous:handleAbsorbPowerCell(pGrievous)
	if (pGrievous == nil) then
		return
	end

	local oid = readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:targetCell")
	local pCell = getSceneObject(oid)

	if (pCell == nil) then
		return
	end

	if (SceneObject(pGrievous):getDistanceTo(pCell) > 15) then
		return
	end

	if (readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing") == 1) then
		return
	end

	writeData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing", 1)
	self:absorbTick(pGrievous, 5)
end

function MyyydrilGrievous:absorbTick(pGrievous, remaining)
	if (pGrievous == nil) then
		return
	end

	if (readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing") ~= 1) then
		return
	end

	local keys = { [5] = "five", [4] = "four", [3] = "three", [2] = "two", [1] = "one" }

	if (remaining > 0) then
		SceneObject(pGrievous):showFlyText("dungeon/myyydril", keys[remaining], 255, 0, 0)
		createEvent(1000, "MyyydrilGrievous", "onAbsorbTick", pGrievous, tostring(remaining - 1))
		return
	end

	self:handleAbsorb0(pGrievous)
end

function MyyydrilGrievous:onAbsorbTick(pGrievous, remainingStr)
	self:absorbTick(pGrievous, tonumber(remainingStr) or 0)
end

function MyyydrilGrievous:handleAbsorb0(pGrievous)
	if (pGrievous == nil or readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing") ~= 1) then
		return
	end

	local oid = readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:targetCell")
	local pCell = getSceneObject(oid)

	if (pCell ~= nil) then
		SceneObject(pCell):destroyObjectFromWorld()
	end

	local level = readData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:power")

	if (level < 5) then
		writeData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:power", level + 1)
		-- OPEN: appearance/pt_grievious_powerup.prt has no Core3 clienteffect binding verified.

		local hp = CreatureObject(pGrievous):getMaxHAM(0)
		local newHp = hp + math.floor(0.10 * hp)
		CreatureObject(pGrievous):setMaxHAM(0, newHp)
		CreatureObject(pGrievous):setHAM(0, newHp)
	end

	writeData(SceneObject(pGrievous):getObjectID() .. ":MyyydrilGrievous:absorbing", 0)
end

function MyyydrilGrievous:notifyGrievousKilled(pVictim, pKiller)
	if (pVictim == nil) then
		return 1
	end

	if (readData(self:dataKey("cleaning")) ~= 1) then
		self:createDeathLoot(pVictim)
	end

	self:handleNpcDeath()
	return 1
end

function MyyydrilGrievous:notifyGuardKilled(pVictim, pKiller)
	if (pVictim == nil) then
		return 1
	end

	self:handleNpcDeath()
	return 1
end

function MyyydrilGrievous:createDeathLoot(pVictim)
	local pInventory = CreatureObject(pVictim):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local roll = getRandomNumber(1, #self.lootItems)
	giveItem(pInventory, self.lootItems[roll], -1)

	for i = 1, #self.alwaysLoot do
		giveItem(pInventory, self.alwaysLoot[i], -1)
	end
end

function MyyydrilGrievous:handleNpcDeath()
	if (readData(self:dataKey("cleaning")) == 1) then
		return
	end

	local num = readData(self:dataKey("numMobs")) - 1
	writeData(self:dataKey("numMobs"), num)

	if (num > 0) then
		return
	end

	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil) then
		return
	end

	local players = self:getEventPlayersInDungeon(pBuilding)

	for i = 1, #players do
		-- badge.grantBadge "bdg_kash_grievous" OPEN: no such badge in the fork.
		CreatureObject(players[i]):sendSystemMessage(self.stf .. "encounter_ending")
	end

	createEvent(60000, "MyyydrilGrievous", "handleEndEncounter", pBuilding, "")
end

function MyyydrilGrievous:handleEndEncounter(pBuilding)
	self:resetEncounter()
end

function MyyydrilGrievous:resetEncounter()
	writeData(self:dataKey("cleaning"), 1)
	writeData(self:dataKey("active"), 0)
	writeData(self:dataKey("session"), 0)
	writeData(self:dataKey("powerCellsActive"), 0)
	writeData(self:dataKey("graceEnd"), 0)

	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding ~= nil and SceneObject(pBuilding):isBuildingObject()) then
		local players = self:getEventPlayersInDungeon(pBuilding)

		for i = 1, #players do
			CreatureObject(players[i]):sendSystemMessage(self.stf .. "encounter_ended")
			self:ejectPlayersFromEncounter(players[i], pBuilding)
		end

		self:ejectInvalidPlayers(pBuilding)
	end

	self:destroyTracked("grievous")
	self:destroyTracked("guard1")
	self:destroyTracked("guard2")
	self:destroyTracked("machine")

	local n = 8

	for i = 1, n do
		self:destroyTracked("powerCell" .. i)
	end

	writeData(self:dataKey("cleaning"), 0)
end

function MyyydrilGrievous:destroyTracked(key)
	local oid = readData(self:dataKey(key))

	if (oid == 0) then
		return
	end

	local pObj = getSceneObject(oid)

	if (pObj ~= nil) then
		SceneObject(pObj):destroyObjectFromWorld()
	end

	deleteData(self:dataKey(key))
end

function MyyydrilGrievous:spawnRetrieveObjects(pBuilding)
	for i = 1, #self.retrieveObjects do
		local row = self.retrieveObjects[i]
		local cellID = self:resolveCell(pBuilding, row.cell)

		if (cellID == 0) then
			print("MyyydrilGrievous: no cell named '" .. row.cell .. "'; tab line " .. row.line .. " skipped")
		else
			local qw, qx, qy, qz = self:headingToQuat(row.yaw)
			local pObject = spawnSceneObject(self.zoneName, row.template, row.x, row.z, row.y, cellID, qw, qx, qy, qz)

			if (pObject == nil) then
				print("MyyydrilGrievous: failed to spawn " .. row.template .. " from tab line " .. row.line)
			else
				self:attachRetrieveObject(pObject, row.arc, row.line)
			end
		end
	end
end

function MyyydrilGrievous:attachRetrieveObject(pObject, arcName, line)
	local arc = _G[arcName]

	if (arc ~= nil and arc.attachObject ~= nil) then
		arc:attachObject(pObject)
	else
		print("myyydril_grievous.lua: " .. arcName .. " absent; attachObject not raised for tab line " .. line)
	end
end

-- cantina_setup.java on lightningroom34 (caverns.tab special_room_script).
-- Sets healing.canhealshock. Core3 has no Lua binding for that objvar: OPEN.
function MyyydrilGrievous:setupCantina(pBuilding)
	local cellID = self:resolveCell(pBuilding, "lightningroom34")

	if (cellID == 0) then
		print("MyyydrilGrievous: no cell named 'lightningroom34'; cantina_setup skipped")
		return
	end

	writeData(self:dataKey("cantina"), cellID)
	print("MyyydrilGrievous: OPEN healing.canhealshock on lightningroom34 (no Lua binding)")
end

-- wirartu_attack.java is the creatures.tab script on ep3_forest_wirartu.
-- KashyyykArena already spawned dressed_arena_champion; attach here so the
-- arena file is not edited. Retry until the champion exists.
-- OURS bound: wirartuMaxAttempts * wirartuRetryMs (12 x 5 s).
function MyyydrilGrievous:attachWirartuAttack()
	self:tryAttachWirartu(getSceneObject(self.buildingID), "1")
end

function MyyydrilGrievous:tryAttachWirartu(pBuilding, attemptStr)
	local attempt = tonumber(attemptStr) or 1
	local oid = readData("KashyyykArena:champion")

	if (oid ~= 0) then
		local pChampion = getSceneObject(oid)

		if (pChampion ~= nil) then
			createObserver(DAMAGERECEIVED, "MyyydrilGrievous", "notifyWirartuDamaged", pChampion)
			return
		end
	end

	if (attempt < self.wirartuMaxAttempts) then
		createEvent(self.wirartuRetryMs, "MyyydrilGrievous", "tryAttachWirartu", pBuilding, tostring(attempt + 1))
		return
	end

	print("MyyydrilGrievous: OPEN wirartu_attack; arena champion not spawned after " .. self.wirartuMaxAttempts .. " tries")
end

function MyyydrilGrievous:notifyWirartuDamaged(pWirartu, pAttacker)
	if (pWirartu == nil) then
		return 0
	end

	if (readData(self:dataKey("wirartuYielded")) == 1) then
		return 0
	end

	local max = CreatureObject(pWirartu):getMaxHAM(0)
	local current = CreatureObject(pWirartu):getHAM(0)

	if (max <= 0 or (current / max) >= 0.50) then
		return 0
	end

	writeData(self:dataKey("wirartuYielded"), 1)

	-- wirartu_attack.java:24 setInvulnerable(self, true). No setInvulnerable
	-- Lua binding; the fork substitute is INVULNERABLE
	-- (DirectorManager.cpp:737, LuaTangibleObject.cpp:49 / :348).
	TangibleObject(pWirartu):setOptionBit(INVULNERABLE)

	-- wirartu_attack.java:25-26 clearCombatData + clearHateList.
	-- clearCombatState: LuaAiAgent.cpp:103 / :743.
	-- forcePeace also clears the threat map (DirectorManager.cpp:2367 / :2380).
	-- removeDefenders: LuaAiAgent.cpp:66 / :478. No clearHateList binding.
	forcePeace(pWirartu)

	if (CreatureObject(pWirartu):isAiAgent()) then
		AiAgent(pWirartu):clearCombatState(true)
		AiAgent(pWirartu):removeDefenders()
		-- wirartu_attack.java:27 BEHAVIOR_SENTINEL. setAITemplate exists
		-- (LuaAiAgent.cpp:32 / :174) but ignores its string argument.
		AiAgent(pWirartu):setAITemplate()
		-- wirartu_attack.java:28 attachScript conversation.ep3_forest_wirartu_attack.
		-- setConvoTemplate: LuaAiAgent.cpp:124 / :939. The conversation is not
		-- in this tree: OPEN (call still made so the bind is not dropped).
		AiAgent(pWirartu):setConvoTemplate("ep3_forest_wirartu_attack")
		TangibleObject(pWirartu):setOptionBit(CONVERSABLE)
	else
		CreatureObject(pWirartu):clearCombatState(true)
	end

	CreatureObject(pWirartu):setPvpStatusBitmask(NONE)
	spatialChat(pWirartu, "@quest/pirates:dont_hurt_me")
	return 1
end

-- magic_stone.java: inventory radial teleports to kashyyyk_main (-568, 0, -100)
-- when the top container is the caverns building. No caverns.tab object row
-- and no IFF in the tree. Menu component is exported for when the item lands.
MyyydrilMagicStoneMenuComponent = {}

function MyyydrilMagicStoneMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not SceneObject(pSceneObject):isASubChildOf(pPlayer)) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(120, 3, "@dungeon/myyydril:teleport")
end

function MyyydrilMagicStoneMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 120) then
		return 0
	end

	if (not SceneObject(pSceneObject):isASubChildOf(pPlayer)) then
		return 0
	end

	local pTop = SceneObject(pPlayer):getParent()

	if (pTop ~= nil) then
		pTop = SceneObject(pTop):getParent()
	end

	local inCaverns = false

	if (pTop ~= nil and SceneObject(pTop):isBuildingObject() and SceneObject(pTop):getObjectID() == MyyydrilGrievous.buildingID) then
		inCaverns = true
	end

	if (not inCaverns) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/myyydril:cantusestone")
		return 0
	end

	-- magic_stone.java:44 kashyyyk_main (-568, 0, -100). Merged kashyyyk_main
	-- snapshot offset is dx 0 / dz 0 (kashyyyk_regions.lua).
	if (not isZoneEnabled("kashyyyk")) then
		return 0
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	SceneObject(pPlayer):switchZone("kashyyyk", -568, 0, -100, 0)
	return 0
end

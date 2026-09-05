--[[
Trando Slave Camp  --  theme_park.dungeon.trando_slave_camp.*

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live ran the Blackscale camp as a space dungeon (theme_park.dungeon.space_dungeon_controller,
dungeon_name trando_slave_camp) on kashyyyk_north_dungeons. Core3 has no space-dungeon
controller. Copy #0 is shared outdoor surface plus one snapshot bunker. Reach it from
the Kachirho zone gate on the merged main zone (ticket point kashyyyk_main).

JAVA -> LUA

	bunker_controller.java     populate the 31 camp_command_bunker.tab rows; lock
	                           barracks + powerroom; door_signal on entry
	kachirho_slave_gate.java   radial on a spawned terminal beside the snapshot door
	player.java                arrival signalSlaverCampEntered
	exit_terminal.java         SUI confirm + travelBack to the Kachirho gate
	comp_room_trigger.java     unlock barracks + DISABLED
	power_terminal.java        signalSlaverDisableLocks, unlock powerroom + UNLOCKED
	door_signal.java           ENTEREDBUILDING grant while Tosk lives
	warden_tosk.java           OBJECTDESTRUCTION -> toskKilled
	broken_shock_lance.java    OPEN: loot-item reverse-engineer; not a bunker row
	combat_mine_spawner.java   21 slaver.tab rows; one mine object each
	combat_mine.java           ENTEREDAREA damage (nightsister trap precedent)

QUEST STATE  --  sibling-arc screenplay names, never quest names

	slaverGursanEntryQuestScreenPlay stage / runs (completed = runs > 0)
	slaveCampControlRoomAccessScreenPlay:grantQuest / :signalSlaverDisableLocks
	slaverGursanEntryQuestScreenPlay:signalSlaverEnterGate / :signalSlaverCampEntered
	Calls are guarded; an absent global prints and does not write a quest-name key.
	ep3_kymayrr_send_cyssc_signal has no quest screenplay on the trando tree: OPEN.

OPEN

	Outdoor isolation / the space-dungeon session model. Copy #0 is a shared
	surface. beginSpawn / resetBunker on a new session does not run: mobiles
	are respawn 0 like live spawnMobs, one boot cycle. A re-arm when toskKilled
	resets is OURS -- this file does not respawn the 31 rows or clear the flag.
	broken_shock_lance: the result template object/weapon/melee/polearm/lance_shock.iff
	is in the tree; the broken item is not in camp_command_bunker.tab and
	createLimitedUseSchematic is not a Lua binding. Mine scatter (live
	mineCount-in-radius, ~383 objects), 600 s
	respawn, commando defuse, smuggler reverse, prone 1-in-20, blast-radius
	AOE, and pet targeting stay OPEN. One mine object per spawner row.
	One-click gate (live two-click task progression) is OURS.
	OURS: live warden_tosk.java is OnIncapacitated. Core3 has no INCAPACITATED
	observer (DirectorManager.cpp:565-603). This file keeps OBJECTDESTRUCTION.
	11 barracks rows ep3_slaver_blackscale_wookiee_berserker are OPEN (listed,
	not spawned): creatures.tab maps that name to ep3_blackscale_berserker,
	which is not in the tree; no north-dungeons lair header IFF-maps it.

COORDINATE TRANSFORM

	kashyyyk_north_dungeons_regions.lua {#kash-offset}, copy #0:
		world_x = buildout_x - 3840
		world_y = buildout_z + 2816    -- Core3 y is SOE pz
		world_z = buildout_y           -- height
	kashyyyk_regions.lua kashyyyk_main {#kash-offset}:
		world_x = buildout_x - 4096
		world_y = buildout_z - 4096

	spawnMobile wants x, z(height), y, heading-degrees.

CELL NAMES

	bunker_controller.java:17-27 CELL_NAMES. Snapshot node 13680785, cells
	13680786..13680795 = index 1..10. slaver.tab cell_index 1 carries
	door_signal; live attaches that script to getCellId(bunker, "entry") --
	index 1 is entry. Named lookup is BuildingObject:getNamedCell, the same
	call KashyyykPobPopulation:resolveCell uses.

ARRIVAL

	space_dungeon.tab trando_slave_camp start_loc is an offset from the
	controller (space_dungeon.java:831). Bunker slaver.tab row + (290, -15, -759).
--]]

TrandoSlaveCamp = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TrandoSlaveCamp",

	zoneDungeon = "kashyyyk_north_dungeons",
	zoneMain = "kashyyyk",

	bunkerID = 13680785,

	-- slaver.tab bunker row (px 272.32, py 35.4327, pz 796.077)
	-- + space_dungeon.tab start_loc (290, -15, -759)
	arrival = { x = (272.32 + 290) - 3840, z = 35.4327 + (-15), y = (796.077 + (-759)) + 2816 },

	-- kashyyyk_main.tab thm_kash_zonegate_door_simple.iff
	-- kachirho_slave_gate; buildout (4511.09, 20.2691, 5072.36)
	kachirhoGate = {
		x = 4511.09 - 4096,
		z = 20.2691,
		y = 5072.36 - 4096,
		qw = -0.0157958,
		qx = 0,
		qy = 0.999875,
		qz = 0,
	},

	-- slaver.tab exit_terminal door. Offset from that row is (0, 0, 0), same as
	-- HraccaMonsterIsland:spawnExitTerminal at its door row.
	exitRow = { 561.82, 22.7207, 12.6987, 1, 0, 0, 0 },
	exitTemplate = "object/tangible/dungeon/terminal_free_s1.iff",
	gateTemplate = "object/tangible/dungeon/terminal_free_s1.iff",

	exitTitle = "@dungeon/space_dungeon:trando_camp_exit",
	exitConfirm = "@dungeon/space_dungeon:trando_camp_exit_confirm",
	gateLabelFile = "travel/zone_transition",
	gateLabelKey = "kachirho_trando_slave_camp",
	noAccess = "@travel/zone_transition:default_no_access",
	unlocked = "@terminal_ui:power_security_off",
	disabled = "@terminal_ui:security_disabled",
	mineHit = "@npc_landmines:hit_by_mine_detonation",

	entryScreenPlay = "slaverGursanEntryQuestScreenPlay",
	controlScreenPlay = "slaveCampControlRoomAccessScreenPlay",

	gateRange = 6,
	arrivalSignalMs = 10 * 1000,

	-- kashyyyk_kash_blackscale_assault.lua / _trooper.lua / _enforcer.lua headers.
	assault = {
		"ep3_blackscale_assault_m_01",
		"ep3_blackscale_assault_m_02",
		"ep3_blackscale_assault_m_03",
	},
	trooper = {
		"ep3_blackscale_trooper_m_01",
		"ep3_blackscale_trooper_m_02",
		"ep3_blackscale_trooper_m_03",
	},
	enforcer = {
		"ep3_blackscale_enforcer_m_01",
		"ep3_blackscale_enforcer_m_02",
		"ep3_blackscale_enforcer_m_03",
		"ep3_blackscale_enforcer_m_04",
	},
	toskTemplate = "ep3_blackscale_warden_tosk",

	mineTypes = {
		ApMine = {
			template = "object/weapon/mine/wp_mine_xg.iff",
			radius = 3,
			minDamage = 500,
			maxDamage = 1000,
			effect = "clienteffect/exp_sonic_landmine.cef",
		},
		IncindiaryMine = {
			template = "object/weapon/mine/wp_mine_xg.iff",
			radius = 4,
			minDamage = 500,
			maxDamage = 1150,
			effect = "clienteffect/combat_grenade_proton.cef",
		},
		HeMine = {
			template = "object/weapon/mine/wp_mine_anti_vehicle.iff",
			radius = 3,
			minDamage = 900,
			maxDamage = 1600,
			effect = "clienteffect/combat_grenade_thermal_detonator.cef",
		},
		concussionMine = {
			template = "object/weapon/mine/wp_mine_drx55.iff",
			radius = 4,
			minDamage = 800,
			maxDamage = 1100,
			effect = "clienteffect/combat_trap_sonic_pulse.cef",
		},
		shockMine = {
			template = "object/weapon/mine/wp_mine_xg.iff",
			radius = 5,
			minDamage = 1000,
			maxDamage = 1300,
			effect = "clienteffect/trap_electric_01.cef",
		},
		shrapnelMine = {
			template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_light.iff",
			radius = 3,
			minDamage = 1200,
			maxDamage = 1500,
			effect = "clienteffect/exp_ap_landmine.cef",
		},
	},

	-- slaver.tab combat_mine_spawner rows 1-21. {px, py, pz, mineType}
	mines = {
		{ 311.283, 24.1176, 488.844, "shrapnelMine" },
		{ 473.746, 23.2941, 286.811, "shrapnelMine" },
		{ 569.953, 24.3876, 653.264, "concussionMine" },
		{ 618.312, 25.0151, 756.671, "shockMine" },
		{ 575.667, 24.1837, 888.654, "ApMine" },
		{ 387.721, 26.4446, 845.023, "HeMine" },
		{ 465.53, 24.4326, 755.315, "shockMine" },
		{ 230.033, 32.7715, 812.863, "ApMine" },
		{ 624.823, 22.439, 102.153, "ApMine" },
		{ 718.982, 24.8666, 182.62, "IncindiaryMine" },
		{ 652.003, 23.2686, 239.876, "concussionMine" },
		{ 558.7, 23.2941, 271.777, "shrapnelMine" },
		{ 505.266, 27.6028, 348.338, "shockMine" },
		{ 429.224, 23.2941, 331.45, "HeMine" },
		{ 382.632, 24.6596, 373.49, "concussionMine" },
		{ 415.505, 24.8393, 554.167, "HeMine" },
		{ 501.001, 23.7485, 688.397, "concussionMine" },
		{ 690.981, 28.2353, 724.664, "IncindiaryMine" },
		{ 723.839, 24.1306, 876.098, "ApMine" },
		{ 681.161, 28.408, 819.929, "HeMine" },
		{ 293.202, 27.4118, 907.902, "IncindiaryMine" },
	},

	-- camp_command_bunker.tab 31 rows. {kind, template, cell, x, z, y, yaw, role}
	-- kind "mobile" or "object". role is tosk / comp / power or nil.
	-- x,z,y are cell-local (table locx, locy=height, locz).
	bunkerRows = {
		{ "mobile", "ep3_blackscale_assault_m_01", "anteroom", 8, -12, 35, -151, nil },
		{ "mobile", "ep3_blackscale_trooper_m_01", "anteroom", 0, -12, 35, 157, nil },
		{ "mobile", "ep3_blackscale_trooper_m_02", "anteroom", 0, -12, 27, 41, nil },
		{ "mobile", "ep3_blackscale_assault_m_02", "anteroom", 7, -12, 26, -38, nil },
		{ "mobile", "ep3_blackscale_trooper_m_03", "anteroom", 3, -12, 30, 170, nil },
		{ "mobile", "ep3_blackscale_trooper_m_01", "computerroom", 9, -16, 63, -86, nil },
		{ "mobile", "ep3_blackscale_enforcer_m_01", "computerroom", -2, -16, 63, 91, nil },
		{ "mobile", "ep3_blackscale_trooper_m_02", "computerroom", 4, -16, 69, 177, nil },
		{ "mobile", "ep3_blackscale_assault_m_03", "computerroom", -8, -16, 82, -174, nil },
		{ "mobile", "ep3_blackscale_trooper_m_03", "computerroom", -8, -16, 73, 1, nil },
		{ "mobile", "ep3_blackscale_assault_m_01", "computerroom", 18, -16, 74, 2, nil },
		{ "mobile", "ep3_blackscale_trooper_m_01", "computerroom", 19, -16, 84, 178, nil },
		{ "object", "object/tangible/dungeon/terminal_free_s1.iff", "computerroom", 25, -16, 81, -90, "comp" },
		{ "mobile", "ep3_blackscale_trooper_m_02", "office", -32, -14, 83, -136, nil },
		{ "mobile", "ep3_blackscale_trooper_m_03", "office", -32, -14, 73, -51, nil },
		{ "mobile", "ep3_blackscale_trooper_m_01", "office", -42, -14, 73, 58, nil },
		{ "mobile", "ep3_blackscale_trooper_m_02", "office", -41, -14, 84, 127, nil },
		{ "mobile", "ep3_blackscale_warden_tosk", "office", -38, -14, 79, 90, "tosk" },
		-- OPEN: ep3_slaver_blackscale_wookiee_berserker -> ep3_blackscale_berserker (absent; no lair IFF map)
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 42, -16, 69, -12, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 48, -16, 81, -88, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 55, -16, 64, -37, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 65, -16, 80, -103, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 69, -16, 60, -47, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 80, -16, 81, -115, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 77, -16, 74, -85, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 64, -16, 73, -92, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 40, -16, 82, 177, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 41, -16, 60, 6, nil },
		{ "open", "ep3_slaver_blackscale_wookiee_berserker", "barracks", 73, -16, 66, -48, nil },
		{ "object", "object/tangible/dungeon/terminal_free_s1.iff", "barracks", 72, -16, 64, 90, "power" },
		{ "object", "object/tangible/quest/computer_console.iff", "powerroom", 29, -12, 30, 90, nil },
	},
}

registerScreenPlay("TrandoSlaveCamp", true)

function TrandoSlaveCamp:start()
	if (isZoneEnabled(self.zoneDungeon)) then
		self:populateBunker()
		self:spawnExitTerminal()
		self:spawnMines()
	end

	if (isZoneEnabled(self.zoneMain)) then
		self:spawnKachirhoGate()
	end
end

function TrandoSlaveCamp:worldFromBuildout(px, py, pz)
	return px - 3840, py, pz + 2816
end

function TrandoSlaveCamp:headingToQuat(yaw)
	local half = math.rad(yaw) * 0.5
	return math.cos(half), 0, math.sin(half), 0
end

function TrandoSlaveCamp:questStage(pPlayer, screenplayName)
	return tonumber(readScreenPlayData(pPlayer, screenplayName, "stage")) or 0
end

-- slaverGursanEntryQuestScreenPlay records completed as runs > 0, not a "completed" key.
function TrandoSlaveCamp:questCompleted(pPlayer, screenplayName)
	return (tonumber(readScreenPlayData(pPlayer, screenplayName, "runs")) or 0) > 0
end

-- OPEN: no ep3_kymayrr_send_cyssc_signal screenplay on the trando tree.
function TrandoSlaveCamp:kymayrrCompleted(pPlayer)
	if kymayrrSendCysscSignalScreenPlay ~= nil then
		return (tonumber(readScreenPlayData(pPlayer, "kymayrrSendCysscSignalScreenPlay", "runs")) or 0) > 0
	end

	return false
end

function TrandoSlaveCamp:populateBunker()
	local pBunker = getSceneObject(self.bunkerID)

	if (pBunker == nil or not SceneObject(pBunker):isBuildingObject()) then
		print("TrandoSlaveCamp: snapshot bunker " .. self.bunkerID .. " is missing; the 31 rows are not placed")
		return
	end

	writeData("TrandoSlaveCamp:toskKilled", 0)
	self:printCellMap(pBunker)

	local cells = {}
	local placed = 0
	local openRows = 0

	for i = 1, #self.bunkerRows do
		local row = self.bunkerRows[i]
		local cellName = row[3]

		if (cells[cellName] == nil) then
			cells[cellName] = self:resolveCell(pBunker, cellName)

			if (cells[cellName] == 0) then
				print("TrandoSlaveCamp: bunker has no cell named '" .. cellName .. "'; its camp_command_bunker.tab rows are skipped")
			end
		end

		if (row[1] == "open") then
			openRows = openRows + 1
		elseif (cells[cellName] ~= 0) then
			if (self:spawnBunkerRow(row, cells[cellName])) then
				placed = placed + 1
			end
		end
	end

	self:lockEventRooms(pBunker, cells)
	createObserver(ENTEREDBUILDING, "TrandoSlaveCamp", "notifyEnteredBunker", pBunker)
	print("TrandoSlaveCamp: " .. placed .. " of 31 camp_command_bunker.tab rows placed in snapshot bunker " .. self.bunkerID .. " (" .. openRows .. " berserker rows OPEN)")
end

function TrandoSlaveCamp:printCellMap(pBunker)
	local total = BuildingObject(pBunker):getTotalCellNumber()

	for i = 1, total do
		local name = BuildingObject(pBunker):getCellName(i)

		if (name == nil) then
			name = ""
		end

		print("TrandoSlaveCamp: cell index " .. i .. " name '" .. name .. "' node " .. (self.bunkerID + i))
	end
end

function TrandoSlaveCamp:resolveCell(pBunker, cellName)
	local pCell = BuildingObject(pBunker):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function TrandoSlaveCamp:spawnBunkerRow(row, cellID)
	local kind = row[1]
	local template = row[2]
	local x = row[4]
	local z = row[5]
	local y = row[6]
	local yaw = row[7]
	local role = row[8]

	if (kind == "mobile") then
		local pMobile = spawnMobile(self.zoneDungeon, template, 0, x, z, y, yaw, cellID)

		if (pMobile == nil) then
			print("TrandoSlaveCamp: failed to spawn " .. template .. " in " .. row[3])
			return false
		end

		if (role == "tosk") then
			createObserver(OBJECTDESTRUCTION, "TrandoSlaveCamp", "notifyToskKilled", pMobile)
		end

		return true
	end

	local qw, qx, qy, qz = self:headingToQuat(yaw)
	local pObject = spawnSceneObject(self.zoneDungeon, template, x, z, y, cellID, qw, qx, qy, qz)

	if (pObject == nil) then
		print("TrandoSlaveCamp: failed to spawn " .. template .. " in " .. row[3])
		return false
	end

	if (role == "comp") then
		createObserver(OBJECTRADIALUSED, "TrandoSlaveCamp", "notifyCompRoomUsed", pObject)
	elseif (role == "power") then
		createObserver(OBJECTRADIALUSED, "TrandoSlaveCamp", "notifyPowerTerminalUsed", pObject)
	end

	return true
end

function TrandoSlaveCamp:lockEventRooms(pBunker, cells)
	-- bunker_controller.java:77-82. live names are swapped vs the cell names:
	-- powerRoom objvar is barracks; sequencer objvar is powerroom.
	self:lockRoom(pBunker, cells["barracks"])
	self:lockRoom(pBunker, cells["powerroom"])
end

function TrandoSlaveCamp:lockRoom(pBunker, cellID)
	if (cellID == nil or cellID == 0) then
		return
	end

	local pCell = getSceneObject(cellID)

	if (pCell == nil) then
		return
	end

	-- warren.lua:1148-1151
	SceneObject(pCell):setContainerInheritPermissionsFromParent(false)
	SceneObject(pCell):clearContainerDefaultAllowPermission(WALKIN)
	BuildingObject(pBunker):broadcastSpecificCellPermissions(cellID)
end

function TrandoSlaveCamp:unlockRoom(cellID)
	if (cellID == nil or cellID == 0) then
		return
	end

	local pBunker = getSceneObject(self.bunkerID)
	local pCell = getSceneObject(cellID)

	if (pBunker == nil or pCell == nil) then
		return
	end

	-- warren.lua:1164-1167
	SceneObject(pCell):setContainerInheritPermissionsFromParent(true)
	SceneObject(pCell):setContainerDefaultAllowPermission(WALKIN)
	BuildingObject(pBunker):broadcastSpecificCellPermissions(cellID)
end

function TrandoSlaveCamp:notifyEnteredBunker(pBunker, pPlayer)
	if (pBunker == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	-- door_signal.java:11 OnReceivedItem is on the entry cell, not the whole bunker.
	-- Shape: ENTEREDBUILDING on the building (heroOfTatooine.lua:54, deathWatchBunker.lua:161,
	-- warren.lua:41, geoLab.lua:111) plus a parent-cell check for the named entry cell.
	local pEntry = BuildingObject(pBunker):getNamedCell("entry")

	if (pEntry == nil or SceneObject(pPlayer):getParentID() ~= SceneObject(pEntry):getObjectID()) then
		return 0
	end

	if (readData("TrandoSlaveCamp:toskKilled") == 1) then
		return 0
	end

	if (self:questStage(pPlayer, self.controlScreenPlay) > 0) then
		return 0
	end

	if slaveCampControlRoomAccessScreenPlay ~= nil then
		slaveCampControlRoomAccessScreenPlay:grantQuest(pPlayer)
	else
		print("trando_slave_camp.lua: slaveCampControlRoomAccess screenplay absent; grantQuest not raised")
	end

	return 0
end

function TrandoSlaveCamp:notifyToskKilled(pVictim, pKiller)
	if (pVictim == nil) then
		return 1
	end

	writeData("TrandoSlaveCamp:toskKilled", 1)

	return 1
end

function TrandoSlaveCamp:notifyCompRoomUsed(pTerminal, pPlayer)
	if (pTerminal == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:questStage(pPlayer, self.controlScreenPlay) <= 0) then
		return 0
	end

	local pBunker = getSceneObject(self.bunkerID)

	if (pBunker ~= nil and SceneObject(pBunker):isBuildingObject()) then
		local pCell = BuildingObject(pBunker):getNamedCell("barracks")

		if (pCell ~= nil) then
			self:unlockRoom(SceneObject(pCell):getObjectID())
		end
	end

	CreatureObject(pPlayer):sendSystemMessage(self.disabled)

	return 0
end

function TrandoSlaveCamp:notifyPowerTerminalUsed(pTerminal, pPlayer)
	if (pTerminal == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:questStage(pPlayer, self.controlScreenPlay) <= 0) then
		return 0
	end

	if slaveCampControlRoomAccessScreenPlay ~= nil then
		slaveCampControlRoomAccessScreenPlay:signalSlaverDisableLocks(pPlayer)
	else
		print("trando_slave_camp.lua: slaveCampControlRoomAccess screenplay absent; signalSlaverDisableLocks not raised")
	end

	local pBunker = getSceneObject(self.bunkerID)

	if (pBunker ~= nil and SceneObject(pBunker):isBuildingObject()) then
		local pCell = BuildingObject(pBunker):getNamedCell("powerroom")

		if (pCell ~= nil) then
			self:unlockRoom(SceneObject(pCell):getObjectID())
		end
	end

	CreatureObject(pPlayer):sendSystemMessage(self.unlocked)

	return 0
end

function TrandoSlaveCamp:spawnExitTerminal()
	local row = self.exitRow
	local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])
	local pTerminal = spawnSceneObject(self.zoneDungeon, self.exitTemplate, x, z, y, 0, row[4], row[5], row[6], row[7])

	if (pTerminal == nil) then
		print("TrandoSlaveCamp: failed to spawn the exit terminal at slaver.tab exit_terminal door")
		return
	end

	createObserver(OBJECTRADIALUSED, "TrandoSlaveCamp", "notifyExitUsed", pTerminal)
	writeData("TrandoSlaveCamp:exitTerminal", SceneObject(pTerminal):getObjectID())
end

function TrandoSlaveCamp:notifyExitUsed(pTerminal, pPlayer)
	if (pTerminal == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local sui = SuiMessageBox.new("TrandoSlaveCamp", "exitConfirmCallback")
	sui.setTitle(self.exitTitle)
	sui.setPrompt(self.exitConfirm)
	sui.sendTo(pPlayer)

	return 0
end

function TrandoSlaveCamp:exitConfirmCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	if (eventIndex ~= 0) then
		return
	end

	self:travelBack(pPlayer)
end

function TrandoSlaveCamp:spawnKachirhoGate()
	local g = self.kachirhoGate
	-- Offset from the snapshot door is (0, 0, 0), same as Hracca at its door row.
	local pTerminal = spawnSceneObject(self.zoneMain, self.gateTemplate, g.x, g.z, g.y, 0, g.qw, g.qx, g.qy, g.qz)

	if (pTerminal == nil) then
		print("TrandoSlaveCamp: failed to spawn the Kachirho gate terminal")
		return
	end

	SceneObject(pTerminal):setObjectName(self.gateLabelFile, self.gateLabelKey, true)
	createObserver(OBJECTRADIALUSED, "TrandoSlaveCamp", "notifyGateUsed", pTerminal)
	writeData("TrandoSlaveCamp:gateTerminal", SceneObject(pTerminal):getObjectID())
end

function TrandoSlaveCamp:notifyGateUsed(pTerminal, pPlayer)
	if (pTerminal == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pPlayer):getDistanceTo(pTerminal) > self.gateRange) then
		return 0
	end

	local active = self:questStage(pPlayer, self.entryScreenPlay) > 0
	local completed = self:questCompleted(pPlayer, self.entryScreenPlay)
	local kymayrrDone = self:kymayrrCompleted(pPlayer)

	if (completed and not kymayrrDone) then
		self:travelTo(pPlayer)
		return 0
	end

	if (not active) then
		CreatureObject(pPlayer):sendSystemMessage(self.noAccess)
		return 0
	end

	if slaverGursanEntryQuestScreenPlay ~= nil then
		slaverGursanEntryQuestScreenPlay:signalSlaverEnterGate(pPlayer)
	else
		print("trando_slave_camp.lua: slaverGursanEntryQuest screenplay absent; signalSlaverEnterGate not raised")
	end
	self:travelTo(pPlayer)

	return 0
end

function TrandoSlaveCamp:travelTo(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled(self.zoneDungeon)) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local dest = self.arrival
	SceneObject(pPlayer):switchZone(self.zoneDungeon, dest.x, dest.z, dest.y, 0)
	createEvent(self.arrivalSignalMs, "TrandoSlaveCamp", "onCampEntered", pPlayer, "")
end

function TrandoSlaveCamp:onCampEntered(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pPlayer):getZoneName() ~= self.zoneDungeon) then
		return
	end

	if slaverGursanEntryQuestScreenPlay ~= nil then
		slaverGursanEntryQuestScreenPlay:signalSlaverCampEntered(pPlayer)
	else
		print("trando_slave_camp.lua: slaverGursanEntryQuest screenplay absent; signalSlaverCampEntered not raised")
	end
end

function TrandoSlaveCamp:travelBack(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled(self.zoneMain)) then
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local g = self.kachirhoGate
	SceneObject(pPlayer):switchZone(self.zoneMain, g.x, g.z, g.y, 0)
end

function TrandoSlaveCamp:spawnMines()
	local spawned = 0

	for i = 1, #self.mines do
		local row = self.mines[i]
		local spec = self.mineTypes[row[4]]

		if (spec == nil) then
			print("TrandoSlaveCamp: unknown mineType " .. tostring(row[4]) .. " at slaver.tab mine " .. i)
		else
			local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])
			local pMine = spawnSceneObject(self.zoneDungeon, spec.template, x, z, y, 0, 1, 0, 0, 0)

			if (pMine == nil) then
				print("TrandoSlaveCamp: failed to spawn " .. spec.template .. " at slaver.tab mine " .. i)
			else
				local pArea = spawnActiveArea(self.zoneDungeon, "object/active_area.iff", x, z, y, spec.radius, 0)

				if (pArea ~= nil) then
					local mineID = SceneObject(pMine):getObjectID()
					local areaID = SceneObject(pArea):getObjectID()
					writeData("TrandoSlaveCamp:mine:" .. areaID, mineID)
					writeStringData("TrandoSlaveCamp:mineType:" .. areaID, row[4])
					createObserver(ENTEREDAREA, "TrandoSlaveCamp", "notifyEnteredMine", pArea)
					spawned = spawned + 1
				end
			end
		end
	end

	print("TrandoSlaveCamp: " .. spawned .. " mine objects placed on copy #0 (one per combat_mine_spawner row)")
end

function TrandoSlaveCamp:notifyEnteredMine(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local areaID = SceneObject(pArea):getObjectID()
	local mineID = readData("TrandoSlaveCamp:mine:" .. areaID)

	if (mineID == 0) then
		return 1
	end

	local mineType = readStringData("TrandoSlaveCamp:mineType:" .. areaID)
	local spec = self.mineTypes[mineType]

	if (spec == nil) then
		return 1
	end

	local damage = getRandomNumber(spec.minDamage, spec.maxDamage)
	local x = SceneObject(pArea):getWorldPositionX()
	local z = SceneObject(pArea):getWorldPositionZ()
	local y = SceneObject(pArea):getWorldPositionY()

	playClientEffectLoc(pPlayer, spec.effect, self.zoneDungeon, x, z, y, 0)
	CreatureObject(pPlayer):inflictDamage(pPlayer, 0, damage, 1)
	CreatureObject(pPlayer):sendSystemMessageWithDI(self.mineHit, damage)

	local pMine = getSceneObject(mineID)

	if (pMine ~= nil) then
		SceneObject(pMine):destroyObjectFromWorld()
	end

	deleteData("TrandoSlaveCamp:mine:" .. areaID)
	deleteStringData("TrandoSlaveCamp:mineType:" .. areaID)
	SceneObject(pArea):destroyObjectFromWorld()

	return 1
end

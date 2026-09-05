--[[
Avatar Platform  --  theme_park.dungeon.avatar_platform.*

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Copy #0 of dungeon_avatar_platform, snapshot node 14400801, zone
kashyyyk_pob_dungeons. Creature rows are KashyyykPobPopulation. This file
spawns the object rows (terminals, lockboxes, cell doors, retrieve items)
and the scripted-creature behaviour (prisoners, jawa, trando01/02) that
those rows carry. The Avatar quest arc lives on a sibling branch and is
called through _G, guarded; that branch merges later.

COORDINATE TRANSFORM  --  POB interior

	repo x        <-  loc_x / java x
	repo z        <-  loc_y / java y     (height)
	repo y        <-  loc_z / java z
	spawnSceneObject heading is a quat from yaw degrees.

CELL NAMES

	Named lookup is BuildingObject:getNamedCell, the same call
	KashyyykPobPopulation:resolveCell uses. Indices are printed at boot
	from getCellName(i).

DOOR LOCKS

	Core3 has no openDoor / closeDoor Lua binding. Cell lock/unlock is
	WALKIN container permissions + broadcastSpecificCellPermissions.
	Energy-cell doors are destroyObjectFromWorld on release.

36 THEME_PARK ROWS  --  ep3_avatar_platform.tab + special_room

	objectRows has 33 object spawns. Three of the 36 theme_park rows
	are not objects (cell / building scripts, already wired as
	ENTEREDBUILDING observers):

	1  special_room avatar_boss_fight_spawn on commandhall08
	   (ep3_avatar_platform.tab spawn row 1, room techhall08,
	   special_room=commandhall08). Not an object.
	2  special_room avatar_boss_fight_room on commanddeck
	   (spawn row 2, room navigationroom, special_room=commanddeck).
	   Not an object.
	3  special_room avatar_entrance_explosion on entrance
	   (spawn row 5, room controlroom, special_room=entrance).
	   Not an object.

	Creature script rows (prisoners 01, 02, 03, 04, 06, jawa,
	trando01, trando02) are adopted, not objectRows. The jails switch
	at -166.7, 0.4, -157.88 yaw -90 has no script and is not one of
	the 36. Launch is the buildout avatar_platform.tab terminal,
	already in objectRows.

ARC  --  sibling globals, never quest-name keys

	Calls are guarded (_G[name] ~= nil). An absent global prints and
	does not write a quest-name key.

	Avatar arc  quest/avatar/
		avatarSecurity01ScreenPlay     avatar_security_01.lua:29
		  grantQuest :78  signalTechhallsUnlocked :160  hasPasscard :155
		  getStage :44  getRuns :52
		avatarTechhall08ScreenPlay     avatar_techhall08.lua:28
		  grantQuest :77  signalTechhall08Unlocked :159  hasPasscard :154
		avatarSelfDestructScreenPlay   avatar_self_destruct.lua:39
		  grantQuest :94  signalMagneticShieldOff :109
		  signalCoreOverloaded :154  signalDestructSequenceStarted :231
		KashAvatarSelfDestructMenuComponent  avatar_self_destruct.lua:244
		avatarBossTauntScreenPlay      avatar_boss_taunt.lua:26  grantQuest :49
		avatarWkePrisoner01ScreenPlay  avatar_wke_prisoner_01.lua:26
		  grantQuest :69  signalLockBox01 :85
		avatarWkePrisoner02ScreenPlay  avatar_wke_prisoner_02.lua:26
		  grantQuest :69  signalLockBox02 :85
		avatarWkePrisoner03ScreenPlay  avatar_wke_prisoner_03.lua:26
		  grantQuest :69  signalLockBox03 :85
		avatarWkePrisoner04ScreenPlay  avatar_wke_prisoner_04.lua:26
		  grantQuest :69  signalLockBox04 :85
		avatarWkePrisoner05ScreenPlay  avatar_wke_prisoner_05.lua:26
		  grantQuest :69  signalLockBox05 :85
		KashAvatarReturnMenuComponent  avatar_return.lua:181

	TRANDO arc  quest/trando/  (not the Avatar arc)
		trandoHssisskZssik10ScreenPlay  trando_hssissk_zssik_10.lua:25
		registerScreenPlay :31
		getStage :36  getRuns :44
		signalAvatarDestructSequence :97
		  consumes avatarDestructSequence (task 2 of that quest)

OPEN

	Terminal / lockbox / launch IFFs object/tangible/dungeon/avatar_platform/*
	are not registered in this tree (technical_readout is registered as
	object/dungeon/avatar_platform/..., a different path -- not used).
	Spawned as the spawn-table path; nil spawn is OPEN, never a look-alike.
	ep3_avatar_harwakokok_mighty: no repo template.
	Badge bdg_kash_avatar_zssik: no such badge.
	playClientEffectObj: no Lua binding; alarm/explosion use playClientEffectLoc.
	aiPathTo: teleport + delayed destroyObjectFromWorld.
	techhall01_unlocked: no raise site in the 45 java files.
	space_dungeon session / avatar_player.java: OPEN. Cleanup is
	avatar_clean_up.java msgSpaceDungeonCleanup, wired here to the
	destruct terminal event and to launch/eject once the building is empty
	(5 s delay, matching the controller's messageTo). Session launch/eject
	confirm (Really launch? / Really eject?) stays OPEN; no-session warp
	is kashyyyk_main (-670, 18, -137).
	Prisoner / jawa / trando rows are adopted by cell + populator template
	name (AiAgent:getCreatureTemplateName). Guards / jailer / watch
	commander SOE names have no registered template: trando01/02 still
	match the populator's mapped ep3_blackscale_guard_m_01 / _m_02 for
	those two hangar rows. A row with no populator template is OPEN
	(no adoption).
--]]

AvatarPlatform = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "AvatarPlatform",

	zoneName = "kashyyyk_pob_dungeons",
	buildingID = 14400801,
	stf = "@dungeon/avatar_platform:",

	-- terminal_launch.java:45, :58 no-session warp. Merged surface is kashyyyk.
	-- Session confirm (avatar_player.java) stays OPEN.
	launchDest = { x = -670, z = 18, y = -137 },

	lockedCells = { "techhall06", "techhall04", "techhall01", "room", "commanddeck" },

	-- ep3_avatar_platform.tab object rows. role drives behaviour.
	objectRows = {
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_security.iff", "mainhangar", 36.3, 0, 21.5, 90, "security" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "techhall08", -134.3, 1.1, -135.8, 48, "techhall08" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_master_console.iff", "navigationroom", -168.4, -0.3, 38.9, 90, "main" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_safety_override.iff", "sensorsystems", -197.5, 0, -116, 90, "safety" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_core_override.iff", "powercore", -89.9, 10, -20.8, 180, "core" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_technical_readout.iff", "controlroom", -100.5, 1.89, 12.95, -22, "readout" },
		{ "object/tangible/quest/avatar_safety_01.iff", "powercore", -97, 0, -50, -90, "safety1" },
		{ "object/tangible/quest/avatar_safety_02.iff", "powercore", -89.99, -13.7, -44.3, 0, "safety2" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "jails", -166.65, 0.4, -135.89, -90, "cell1" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "jails", -176.32, 0.4, -135.89, 90, "cell2" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "jails", -166.65, 0.4, -146.9, -90, "cell3" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "jails", -176.3, 0.4, -146.9, 90, "cell4" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "jails", -176.3, 0.4, -157.88, 90, "cell6" },
		{ "object/tangible/quest/avatar_medical_records.iff", "barracks01", -76.5, 0, -190.5, 0, "medical" },
		{ "object/tangible/dungeon/avatar_platform/avatar_terminal_switch.iff", "commanddeck", -190.7, 0.5, -22.6, -90, "boss" },
		{ "object/tangible/dungeon/avatar_platform/avatar_lockbox.iff", "anteroom", 64.7, 0, -68.5, -128, "lock5" },
		{ "object/tangible/dungeon/avatar_platform/avatar_lockbox.iff", "barracks02", -68.2, 0, -135.1, 48, "lock2" },
		{ "object/tangible/dungeon/avatar_platform/avatar_lockbox.iff", "securityoffice", -162.9, 0, -112.6, 0, "lock1" },
		{ "object/tangible/dungeon/avatar_platform/avatar_lockbox.iff", "securestorage", 6.9, 0, 24.6, -90, "lock3" },
		{ "object/tangible/dungeon/avatar_platform/avatar_lockbox.iff", "checkpoint01", 17.1, 0, 51.5, 0, "lock4" },
		{ "object/tangible/quest/avatar_cold_storage.iff", "barracks01", -70.6, 0, -168.1, -180, "ret4" },
		{ "object/tangible/quest/avatar_foot_locker.iff", "securityoffice", -150.7, 0, -107.4, -90, "ret3" },
		{ "object/tangible/quest/avatar_locker_sr71.iff", "generalstorage", -19.6, 0, 12.4, 90, "ret5" },
		{ "object/tangible/quest/avatar_storage_case.iff", "securestorage", 18.6, 0, 17.9, -90, "ret1" },
		{ "object/tangible/quest/avatar_warm_storage.iff", "barracks01", -70.6, 0, -185, 0, "ret2" },
		{ "object/building/kashyyyk/mun_kash_avatar_planet_hologram.iff", "navigationroom", -173.2, 7.9, 39.1, 0, "holo" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -166, -0.3, -133.5, 90, "door1" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -177, -0.3, -133.5, -90, "door2" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -166, -0.3, -144.5, 90, "door3" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -177, -0.3, -144.5, -90, "door4" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -166, -0.3, -155.5, 90, "door5" },
		{ "object/building/kashyyyk/thm_spc_asteroid_bunker_energy_door.iff", "jails", -177, -0.3, -155.5, -90, "door6" },
		-- buildout avatar_platform.tab terminal_launch. Live is cell 0 outdoors;
		-- placed in mainhangar so the shuttle is reachable inside copy #0.
		{ "object/tangible/dungeon/avatar_platform/terminal_launch.iff", "mainhangar", 57.5, 0, 22.5, 90, "launch" },
	},

	-- spawn_objvar string:passcode= on the lockbox / console rows.
	lockboxes = {
		lock1 = { passcode = "14321", credits = 1500, item = "object/weapon/ranged/pistol/ep3/pistol_wookiee.iff", quest = "avatarWkePrisoner01ScreenPlay", signal = "signalLockBox01" },
		lock2 = { passcode = "37986", credits = 1000, item = "object/weapon/ranged/carbine/ep3/carbine_wookiee_bowcaster.iff", quest = "avatarWkePrisoner02ScreenPlay", signal = "signalLockBox02" },
		lock3 = { passcode = "79631", credits = 7500, item = "object/weapon/ranged/pistol/ep3/pistol_wookiee_bowcaster.iff", quest = "avatarWkePrisoner03ScreenPlay", signal = "signalLockBox03" },
		lock4 = { passcode = "54376", credits = 2000, item = "object/weapon/ranged/pistol/ep3/pistol_ion_stunner.iff", quest = "avatarWkePrisoner04ScreenPlay", signal = "signalLockBox04" },
		lock5 = { passcode = "87424", credits = 25000, item = "object/tangible/loot/loot_schematic/trandoshan_hunter_rifle_schematic.iff", quest = "avatarWkePrisoner05ScreenPlay", signal = "signalLockBox05" },
	},

	prisoners = {
		{ key = "p1", template = "ep3_wke_civilian_01", cell = "jails", x = -160.4, z = -0.5, y = -133.5, yaw = -90, thanks = "wke_thanks_01", quest = "avatarWkePrisoner01ScreenPlay", death = "fire", effect = "clienteffect/avatar_wke_fire_01.cef", anim = nil, deathDelay = 0, door = "door1" },
		{ key = "p2", template = "ep3_wke_civilian_02", cell = "jails", x = -183.7, z = -0.5, y = -133.8, yaw = 90, thanks = "wke_thanks_02", quest = "avatarWkePrisoner02ScreenPlay", death = "gas", effect = "clienteffect/avatar_wke_gas_01.cef", anim = "heavy_cough_vomit", deathDelay = 5, door = "door2" },
		{ key = "p3", template = "ep3_wke_civilian_04", cell = "jails", x = -160.4, z = -0.5, y = -145, yaw = -90, thanks = "wke_thanks_03", quest = "avatarWkePrisoner03ScreenPlay", death = "electric", effect = "clienteffect/avatar_wke_electric_01.cef", anim = "shiver", deathDelay = 4, door = "door3" },
		{ key = "p4", template = "ep3_wke_civilian_05", cell = "jails", x = -182.5, z = -0.5, y = -144.5, yaw = 90, thanks = "wke_thanks_04", quest = "avatarWkePrisoner04ScreenPlay", death = "sonic", effect = "clienteffect/avatar_wke_sonic.cef", anim = "cover_ears_mocking", deathDelay = 4, door = "door4" },
		{ key = "p6", template = "ep3_wke_civilian_03", cell = "jails", x = -181.6, z = -0.5, y = -154.8, yaw = 90, thanks = "wke_thanks_06", quest = "avatarWkePrisoner05ScreenPlay", death = "jawa", effect = nil, anim = nil, deathDelay = 0, door = "door6" },
	},

	jawaHome = { template = "ep3_avatar_jawa", cell = "securityoffice", x = -160.8, z = 0, y = -124.7, yaw = 0 },
	jawaChatter = { x = -171.7, z = 0, y = -155.5 },
	jawaAttack = { x = -181.0, z = 0, y = -155.5 },
	fleePoint = { cell = "techhall09", x = -168.9, z = 0, y = -122.5 },

	-- populator mapped ep3_avatar_blackscale_guard -> ep3_blackscale_guard_m_01 / _m_02
	trando1 = { template = "ep3_blackscale_guard_m_01", cell = "mainhangar", x = 36.3, z = 0, y = 18.4, yaw = -90 },
	trando2 = { template = "ep3_blackscale_guard_m_02", cell = "mainhangar", x = 36.3, z = 0, y = 24.7, yaw = -90 },

	-- ep3_avatar_platform_boss_trando.tab. Harwakokok OPEN.
	bossMinions = {
		{ template = "ep3_wke_commando_01", cell = "commanddeck", x = -205.8, z = 0, y = -7.7, yaw = 140 },
		{ template = "ep3_wke_commando_02", cell = "commanddeck", x = -205.8, z = 0, y = -45, yaw = 37 },
		{ template = "ep3_wke_commando_03", cell = "commanddeck", x = -208.7, z = 0, y = -34.8, yaw = 66 },
		{ template = "ep3_wke_commando_01", cell = "commanddeck", x = -208.7, z = 0, y = -14.8, yaw = 123 },
	},
	bossTemplate = nil, -- OPEN ep3_avatar_harwakokok_mighty
	bossLoc = { cell = "commanddeck", x = -209, z = 0, y = -25.3, yaw = 90 },

	hangarExplosions = {
		{ 33.9, 0, 6.7 }, { 48.5, 0, 8.8 }, { 62.5, 0, 8.5 }, { 77.5, 0, 7.2 },
		{ 76.7, 0, 37.1 }, { 61.6, 0, 35.6 }, { 35.9, 0, 37.1 }, { 27.4, 0, 21.6 }, { 57.5, 0, 22.5 },
	},
	hallExplosions = {
		{ 91.1, 0, 24.4 }, { 91.1, 0, 18.4 }, { 97.2, 0, 18.4 }, { 97.2, 0, 24.4 },
		{ 101.8, 0, 18.4 }, { 101.8, 0, 24.4 }, { 108.9, 0, 18.4 }, { 108.9, 0, 24.4 },
	},

	returnKeys = { ret1 = "d1", ret2 = "d2", ret3 = "d3", ret4 = "d4", ret5 = "d5" },
	radialRoles = { security = true, techhall08 = true, main = true, safety = true, core = true, readout = true, cell1 = true, cell2 = true, cell3 = true, cell4 = true, cell6 = true, boss = true, lock1 = true, lock2 = true, lock3 = true, lock4 = true, lock5 = true },
}

registerScreenPlay("AvatarPlatform", true)

function AvatarPlatform:start()
	if (not isZoneEnabled(self.zoneName)) then
		return
	end

	self:setupBuilding()
end

function AvatarPlatform:setupBuilding()
	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("AvatarPlatform: snapshot building " .. self.buildingID .. " is missing; object rows are not placed")
		return
	end

	self:printCellMap(pBuilding)
	self:resetState()
	self:lockAvatarDoors(pBuilding)
	self:spawnObjectRows(pBuilding)
	-- KashyyykPobPopulation exposes no done flag and its population can
	-- finish after this screenplay's start(). OURS bound retry: every 10 s,
	-- 12 tries (120 s). Stop when all eight mobiles are adopted.
	createEvent(10000, "AvatarPlatform", "tryAdoptScriptedMobiles", pBuilding, "1")
	createObserver(ENTEREDBUILDING, "AvatarPlatform", "notifyEnteredBuilding", pBuilding)
end

function AvatarPlatform:printCellMap(pBuilding)
	local total = BuildingObject(pBuilding):getTotalCellNumber()

	for i = 1, total do
		local name = BuildingObject(pBuilding):getCellName(i)

		if (name == nil) then
			name = ""
		end

		print("AvatarPlatform: cell index " .. i .. " name '" .. name .. "' node " .. (self.buildingID + i))
	end
end

function AvatarPlatform:resolveCell(pBuilding, cellName)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function AvatarPlatform:headingToQuat(yaw)
	local half = math.rad(yaw) * 0.5
	return math.cos(half), 0, math.sin(half), 0
end

function AvatarPlatform:dataKey(suffix)
	return "AvatarPlatform:" .. tostring(self.buildingID) .. ":" .. suffix
end

function AvatarPlatform:resetState()
	local keys = { "destruct", "bossFight", "bossDoorLocked", "trandoChat", "explosionHangar", "explosionHall", "coreOverload", "recycleArmed", "recycleTries", "minionCount" }
	local i

	for i = 1, #keys do
		writeData(self:dataKey(keys[i]), 0)
	end

	for i = 1, 6 do
		writeData(self:dataKey("wkeDone" .. i), 0)
	end
end

function AvatarPlatform:lockRoom(pBuilding, cellName)
	local cellID = self:resolveCell(pBuilding, cellName)

	if (cellID == 0) then
		return
	end

	local pCell = getSceneObject(cellID)

	if (pCell == nil) then
		return
	end

	SceneObject(pCell):setContainerInheritPermissionsFromParent(false)
	SceneObject(pCell):clearContainerDefaultAllowPermission(WALKIN)
	BuildingObject(pBuilding):broadcastSpecificCellPermissions(cellID)
end

function AvatarPlatform:unlockRoom(pBuilding, cellName)
	local cellID = self:resolveCell(pBuilding, cellName)

	if (cellID == 0) then
		return
	end

	local pCell = getSceneObject(cellID)

	if (pCell == nil) then
		return
	end

	SceneObject(pCell):setContainerInheritPermissionsFromParent(true)
	SceneObject(pCell):setContainerDefaultAllowPermission(WALKIN)
	BuildingObject(pBuilding):broadcastSpecificCellPermissions(cellID)
end

function AvatarPlatform:lockAvatarDoors(pBuilding)
	local i

	for i = 1, #self.lockedCells do
		self:lockRoom(pBuilding, self.lockedCells[i])
	end
end

function AvatarPlatform:spawnObjectRows(pBuilding)
	local cells = {}
	local placed = 0
	local i

	for i = 1, #self.objectRows do
		local row = self.objectRows[i]
		local cellName = row[2]

		if (cells[cellName] == nil) then
			cells[cellName] = self:resolveCell(pBuilding, cellName)

			if (cells[cellName] == 0) then
				print("AvatarPlatform: building has no cell named '" .. cellName .. "'; its object rows are skipped")
			end
		end

		if (cells[cellName] ~= 0 and self:spawnObjectRow(row, cells[cellName])) then
			placed = placed + 1
		end
	end

	print("AvatarPlatform: " .. placed .. " of " .. #self.objectRows .. " object rows placed in snapshot " .. self.buildingID)
end

function AvatarPlatform:spawnObjectRow(row, cellID)
	local template = row[1]
	local yaw = row[6]
	local role = row[7]
	local qw, qx, qy, qz = self:headingToQuat(yaw)
	local pObject = spawnSceneObject(self.zoneName, template, row[3], row[4], row[5], cellID, qw, qx, qy, qz)

	if (pObject == nil) then
		print("AvatarPlatform: OPEN template " .. template .. " (" .. role .. ") did not spawn")
		return false
	end

	local oid = SceneObject(pObject):getObjectID()
	writeStringData(self:dataKey("role:" .. oid), role)
	writeData(self:dataKey(role), oid)

	if (self.radialRoles[role] == true) then
		createObserver(OBJECTRADIALUSED, "AvatarPlatform", "notifyObjectUsed", pObject)
	end

	if (role == "launch") then
		SceneObject(pObject):setObjectMenuComponent("AvatarLaunchMenuComponent")
	elseif (role == "safety1" or role == "safety2") then
		writeStringData(oid .. ":kashAvatarDestruct", (role == "safety1") and "s1" or "s2")

		if (KashAvatarSelfDestructMenuComponent ~= nil) then
			SceneObject(pObject):setObjectMenuComponent("KashAvatarSelfDestructMenuComponent")
		end
	elseif (self.returnKeys[role] ~= nil) then
		writeStringData(oid .. ":kashAvatarReturn", self.returnKeys[role])

		if (KashAvatarReturnMenuComponent ~= nil) then
			SceneObject(pObject):setObjectMenuComponent("KashAvatarReturnMenuComponent")
		end
	end

	return true
end

function AvatarPlatform:tryAdoptScriptedMobiles(pBuilding, tryArg)
	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		pBuilding = self:getBuilding()
	end

	if (pBuilding == nil) then
		return
	end

	local try = tonumber(tryArg) or 1
	local maxTries = 12
	local quiet = (try < maxTries)
	local missing = self:adoptScriptedMobiles(pBuilding, quiet)

	if (missing > 0 and try < maxTries) then
		createEvent(10000, "AvatarPlatform", "tryAdoptScriptedMobiles", pBuilding, tostring(try + 1))
	end
end

function AvatarPlatform:adoptScriptedMobiles(pBuilding, quiet)
	local missing = 0
	local i

	for i = 1, #self.prisoners do
		if (self:adoptOne(pBuilding, self.prisoners[i], nil, quiet) == nil) then
			missing = missing + 1
		end
	end

	if (self:adoptOne(pBuilding, self.jawaHome, "jawa", quiet) == nil) then
		missing = missing + 1
	end

	if (self:adoptOne(pBuilding, self.trando1, "trando1", quiet) == nil) then
		missing = missing + 1
	end

	if (self:adoptOne(pBuilding, self.trando2, "trando2", quiet) == nil) then
		missing = missing + 1
	end

	local pJawa = self:oidObject("jawa")

	if (pJawa ~= nil) then
		TangibleObject(pJawa):setPvpStatusBitmask(0)
	end

	return missing
end

function AvatarPlatform:adoptOne(pBuilding, spec, keyOverride, quiet)
	local key = keyOverride or spec.key
	local template = spec.template

	if (template == nil or template == "") then
		print("AvatarPlatform: " .. tostring(key) .. " has no populator template; adoption is OPEN")
		return nil
	end

	local pExisting = self:oidObject(key)

	if (pExisting ~= nil) then
		return pExisting
	end

	local pMob = self:findMobileByTemplate(pBuilding, spec.cell, template, spec.x, spec.y)

	if (pMob ~= nil) then
		writeData(self:dataKey(key), SceneObject(pMob):getObjectID())
		print("AvatarPlatform: " .. tostring(key) .. " template " .. template .. " adopted in " .. spec.cell)
		return pMob
	end

	if (not quiet) then
		print("AvatarPlatform: " .. tostring(key) .. " template " .. template .. " was not standing in " .. spec.cell)
	end

	return nil
end

function AvatarPlatform:respawnScriptedMobile(pBuilding, spec, keyOverride)
	local key = keyOverride or spec.key
	local pMob = self:adoptOne(pBuilding, spec, key)

	if (pMob ~= nil) then
		return pMob
	end

	local template = spec.template

	if (template == nil or template == "") then
		return nil
	end

	local cellID = self:resolveCell(pBuilding, spec.cell)

	if (cellID == 0) then
		return nil
	end

	local yaw = spec.yaw or 0
	pMob = spawnMobile(self.zoneName, template, 0, spec.x, spec.z, spec.y, yaw, cellID)

	if (pMob ~= nil) then
		writeData(self:dataKey(key), SceneObject(pMob):getObjectID())
	else
		print("AvatarPlatform: failed to spawn " .. template .. " (" .. tostring(key) .. ")")
	end

	return pMob
end

function AvatarPlatform:findMobileByTemplate(pBuilding, cellName, template, x, y)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return nil
	end

	local match = nil
	local matchD = nil
	local i

	for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
		local pObj = SceneObject(pCell):getContainerObject(i)

		if (pObj ~= nil and SceneObject(pObj):isCreatureObject() and not SceneObject(pObj):isPlayerCreature() and SceneObject(pObj):isAiAgent()) then
			local name = AiAgent(pObj):getCreatureTemplateName()

			if (name == template) then
				local dx = SceneObject(pObj):getPositionX() - x
				local dy = SceneObject(pObj):getPositionY() - y
				local d = math.sqrt(dx * dx + dy * dy)

				-- same cell + same template; the distance pick is only among
				-- that template (hangar has two guard_m_01 rows).
				if (d < 4 and (match == nil or d < matchD)) then
					match = pObj
					matchD = d
				end
			end
		end
	end

	return match
end

function AvatarPlatform:getBuilding()
	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		return nil
	end

	return pBuilding
end

function AvatarPlatform:oidObject(key)
	local oid = readData(self:dataKey(key))

	if (oid == nil or oid == 0) then
		return nil
	end

	return getSceneObject(oid)
end

function AvatarPlatform:arcCall(globalName, method, pPlayer)
	local g = _G[globalName]

	if (g ~= nil and g[method] ~= nil) then
		g[method](g, pPlayer)
		return true
	end

	print("avatar_platform.lua: " .. globalName .. " absent; " .. method .. " not raised")
	return false
end

function AvatarPlatform:arcStage(globalName, pPlayer)
	local g = _G[globalName]

	if (g == nil or g.getStage == nil) then
		return 0
	end

	return g:getStage(pPlayer)
end

function AvatarPlatform:arcRuns(globalName, pPlayer)
	local g = _G[globalName]

	if (g == nil or g.getRuns == nil) then
		return 0
	end

	return g:getRuns(pPlayer)
end

function AvatarPlatform:playersInBuilding()
	local pBuilding = self:getBuilding()
	local list = {}

	if (pBuilding == nil) then
		return list
	end

	local total = BuildingObject(pBuilding):getTotalCellNumber()
	local i

	for i = 1, total do
		local name = BuildingObject(pBuilding):getCellName(i)

		if (name ~= nil and name ~= "") then
			local pCell = BuildingObject(pBuilding):getNamedCell(name)

			if (pCell ~= nil) then
				local j

				for j = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
					local pObj = SceneObject(pCell):getContainerObject(j)

					if (pObj ~= nil and SceneObject(pObj):isPlayerCreature()) then
						table.insert(list, pObj)
					end
				end
			end
		end
	end

	return list
end

function AvatarPlatform:notifyEnteredBuilding(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local parentID = SceneObject(pPlayer):getParentID()
	local hall08 = self:resolveCell(pBuilding, "commandhall08")
	local deck = self:resolveCell(pBuilding, "commanddeck")
	local hangar = self:resolveCell(pBuilding, "mainhangar")
	local entrance = self:resolveCell(pBuilding, "entrance")

	if (parentID == hall08) then
		self:onEnteredCommandHall(pPlayer)
	elseif (parentID == deck) then
		self:onEnteredCommandDeck(pPlayer)
	elseif (parentID == hangar) then
		self:onEnteredHangar(pPlayer)
	elseif (parentID == entrance) then
		self:onEnteredEntrance(pPlayer)
	end

	return 0
end

function AvatarPlatform:notifyObjectUsed(pObject, pPlayer)
	if (pObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pObject, 8)) then
		return 0
	end

	local role = readStringData(self:dataKey("role:" .. SceneObject(pObject):getObjectID()))

	if (role == "security") then
		self:useSecurityTerminal(pPlayer)
	elseif (role == "techhall08") then
		self:useTechhall08Terminal(pPlayer)
	elseif (role == "main") then
		self:useMainConsole(pPlayer)
	elseif (role == "safety") then
		self:useSafetyOverride(pPlayer)
	elseif (role == "core") then
		self:useCoreOverload(pPlayer)
	elseif (role == "readout") then
		self:useTechnicalReadout(pPlayer)
	elseif (role == "boss") then
		self:useBossTerminal(pPlayer)
	elseif (string.sub(role, 1, 4) == "cell") then
		self:useCellTerminal(pPlayer, role)
	elseif (string.sub(role, 1, 4) == "lock") then
		self:useLockbox(pPlayer, role)
	end

	return 0
end

function AvatarPlatform:useSecurityTerminal(pPlayer)
	local hasCard = false
	local g = _G["avatarSecurity01ScreenPlay"]

	if (g ~= nil and g.hasPasscard ~= nil) then
		hasCard = g:hasPasscard(pPlayer)
	end

	if (hasCard or self:arcRuns("avatarSecurity01ScreenPlay", pPlayer) > 0) then
		local pBuilding = self:getBuilding()

		if (pBuilding ~= nil) then
			self:unlockRoom(pBuilding, "techhall06")
			self:unlockRoom(pBuilding, "techhall04")
			self:unlockRoom(pBuilding, "techhall01")
		end

		self:arcCall("avatarSecurity01ScreenPlay", "signalTechhallsUnlocked", pPlayer)
		CreatureObject(pPlayer):sendSystemMessage("@terminal_ui:door_locks_disabled")
	else
		if (self:arcStage("avatarSecurity01ScreenPlay", pPlayer) == 0) then
			self:arcCall("avatarSecurity01ScreenPlay", "grantQuest", pPlayer)
		end

		CreatureObject(pPlayer):sendSystemMessage("@terminal_ui:no_passcard")
	end
end

function AvatarPlatform:useTechhall08Terminal(pPlayer)
	local hasCard = false
	local g = _G["avatarTechhall08ScreenPlay"]

	if (g ~= nil and g.hasPasscard ~= nil) then
		hasCard = g:hasPasscard(pPlayer)
	end

	if (hasCard or self:arcRuns("avatarTechhall08ScreenPlay", pPlayer) > 0) then
		local pBuilding = self:getBuilding()

		if (pBuilding ~= nil) then
			self:unlockRoom(pBuilding, "room")
		end

		self:arcCall("avatarTechhall08ScreenPlay", "signalTechhall08Unlocked", pPlayer)
		CreatureObject(pPlayer):sendSystemMessage("@terminal_ui:door_locks_disabled")
	else
		if (self:arcStage("avatarTechhall08ScreenPlay", pPlayer) == 0) then
			self:arcCall("avatarTechhall08ScreenPlay", "grantQuest", pPlayer)
		end

		CreatureObject(pPlayer):sendSystemMessage("@terminal_ui:no_passcard")
	end
end

function AvatarPlatform:useSafetyOverride(pPlayer)
	if (self:arcStage("avatarSelfDestructScreenPlay", pPlayer) == 1) then
		self:arcCall("avatarSelfDestructScreenPlay", "signalMagneticShieldOff", pPlayer)
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "shield_off")
	else
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "not_needed")
	end
end

function AvatarPlatform:useCoreOverload(pPlayer)
	local stage = self:arcStage("avatarSelfDestructScreenPlay", pPlayer)

	if (stage == 4) then
		self:startCoreOverload(pPlayer)
		self:arcCall("avatarSelfDestructScreenPlay", "signalCoreOverloaded", pPlayer)
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "warning_overload")
	elseif (stage > 4 or self:arcRuns("avatarSelfDestructScreenPlay", pPlayer) > 0) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "core_overloaded")
	else
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "safety_measures")
	end
end

function AvatarPlatform:startCoreOverload(pPlayer)
	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	local cellID = self:resolveCell(pBuilding, "powercore")
	playClientEffectLoc(pPlayer, "clienteffect/ep3_avatar_core_overload.cef", self.zoneName, -90.0, 7.98, -50.0, cellID)
	writeData(self:dataKey("coreOverload"), 1)
	createEvent(60000, "AvatarPlatform", "replayCoreOverload", pPlayer, "")
end

function AvatarPlatform:replayCoreOverload(pPlayer)
	if (readData(self:dataKey("coreOverload")) ~= 1) then
		return
	end

	local players = self:playersInBuilding()

	if (#players > 0) then
		self:startCoreOverload(players[1])
	end
end

function AvatarPlatform:useTechnicalReadout(pPlayer)
	-- live: isTaskActive(ep3_trando_hssissk_zssik_10, technicalReadout).
	-- Lua zssik_10 has no technicalReadout task; quest-active is the proxy.
	if (self:arcStage("trandoHssisskZssik10ScreenPlay", pPlayer) > 0) then
		if (self:arcStage("avatarSelfDestructScreenPlay", pPlayer) == 0) then
			self:arcCall("avatarSelfDestructScreenPlay", "grantQuest", pPlayer)
			CreatureObject(pPlayer):sendSystemMessage(self.stf .. "readout_granted")
		else
			CreatureObject(pPlayer):sendSystemMessage(self.stf .. "already_read")
		end
	else
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "not_useful")
	end
end

function AvatarPlatform:useBossTerminal(pPlayer)
	local zssik = self:arcStage("trandoHssisskZssik10ScreenPlay", pPlayer)
	local runs = self:arcRuns("trandoHssisskZssik10ScreenPlay", pPlayer)

	if (zssik == 1) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "cannot_unlock")
		return
	end

	if (zssik >= 2 or runs > 0) then
		local pBuilding = self:getBuilding()

		if (pBuilding ~= nil) then
			self:unlockRoom(pBuilding, "commandhall08")
		end

		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "open_door")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "door_unlocked")
end

function AvatarPlatform:useMainConsole(pPlayer)
	local stage = self:arcStage("avatarSelfDestructScreenPlay", pPlayer)

	if (stage == 6) then
		self:openKeypad(pPlayer, "main", "12345", self.stf .. "enter_code")
		return
	end

	if (self:arcRuns("avatarSelfDestructScreenPlay", pPlayer) > 0 or readData(self:dataKey("destruct")) == 1) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "warning_already")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "no_effect")
end

function AvatarPlatform:useLaunchTerminal(pPlayer)
	-- terminal_launch.java:56-59: no dungeon-player script, warp immediately.
	self:warpOut(pPlayer)
end

function AvatarPlatform:useEjectTerminal(pPlayer)
	-- terminal_launch.java:43-46: no dungeon-player script, warp immediately.
	self:warpOut(pPlayer)
end

function AvatarPlatform:warpOut(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled("kashyyyk")) then
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local dest = self.launchDest
	SceneObject(pPlayer):switchZone("kashyyyk", dest.x, dest.z, dest.y, 0)
	self:scheduleRecycle()
end

function AvatarPlatform:useLockbox(pPlayer, role)
	local box = self.lockboxes[role]

	if (box == nil) then
		return
	end

	local stage = self:arcStage(box.quest, pPlayer)
	local runs = self:arcRuns(box.quest, pPlayer)

	if (stage > 0) then
		self:openKeypad(pPlayer, role, box.passcode, self.stf .. "lockbox_code")
	elseif (runs > 0) then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "not_needed")
	else
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "lockbox_unknown")
	end
end

function AvatarPlatform:openKeypad(pPlayer, role, passcode, prompt)
	writeStringData(SceneObject(pPlayer):getObjectID() .. ":AvatarPlatform:keyRole", role)
	writeStringData(SceneObject(pPlayer):getObjectID() .. ":AvatarPlatform:keyPass", passcode)

	local sui = SuiInputBox.new("AvatarPlatform", "keypadCallback")
	sui.setTitle(prompt)
	sui.setPrompt(prompt)
	sui.sendTo(pPlayer)
end

function AvatarPlatform:keypadCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	local pid = SceneObject(pPlayer):getObjectID()
	local role = readStringData(pid .. ":AvatarPlatform:keyRole")
	local pass = readStringData(pid .. ":AvatarPlatform:keyPass")
	deleteStringData(pid .. ":AvatarPlatform:keyRole")
	deleteStringData(pid .. ":AvatarPlatform:keyPass")

	if (args == nil) then
		args = ""
	end

	if (args ~= pass) then
		if (role == "main") then
			CreatureObject(pPlayer):sendSystemMessage(self.stf .. "incorrect_code")
		else
			CreatureObject(pPlayer):sendSystemMessage(self.stf .. "lockbox_incorrect")
		end

		return
	end

	if (role == "main") then
		self:beginDestruct(pPlayer)
	else
		self:grantLockbox(pPlayer, role)
	end
end

function AvatarPlatform:grantLockbox(pPlayer, role)
	local box = self.lockboxes[role]

	if (box == nil) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "lockbox_unlocked")
	CreatureObject(pPlayer):addBankCredits(box.credits, true)
	self:arcCall(box.quest, box.signal, pPlayer)

	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		local pItem = giveItem(pInventory, box.item, -1)

		if (pItem == nil) then
			print("AvatarPlatform: OPEN loot " .. box.item .. " did not grant")
		end
	end
end

function AvatarPlatform:beginDestruct(pPlayer)
	writeData(self:dataKey("destruct"), 1)

	local players = self:playersInBuilding()
	local i

	for i = 1, #players do
		local pOne = players[i]

		if (self:arcStage("avatarSelfDestructScreenPlay", pOne) == 6) then
			self:arcCall("avatarSelfDestructScreenPlay", "signalDestructSequenceStarted", pOne)
			self:arcCall("trandoHssisskZssik10ScreenPlay", "signalAvatarDestructSequence", pOne)
		end

		CreatureObject(pOne):sendSystemMessage(self.stf .. "warning_destruct")
		createEvent(20000, "AvatarPlatform", "playerExplosionTick", pOne, "")
		createEvent(300000, "AvatarPlatform", "playerDestructKill", pOne, "")
	end
end

function AvatarPlatform:playerExplosionTick(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pPlayer):getZoneName() ~= self.zoneName) then
		return
	end

	if (readData(self:dataKey("destruct")) ~= 1) then
		return
	end

	playClientEffectLoc(pPlayer, "clienteffect/avatar_explosion_01.cef", self.zoneName, SceneObject(pPlayer):getPositionX(), SceneObject(pPlayer):getPositionZ(), SceneObject(pPlayer):getPositionY(), SceneObject(pPlayer):getParentID())
	createEvent(15000, "AvatarPlatform", "playerExplosionTick", pPlayer, "")
end

function AvatarPlatform:playerDestructKill(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pPlayer):getZoneName() ~= self.zoneName) then
		return
	end

	if (readData(self:dataKey("destruct")) ~= 1) then
		return
	end

	playClientEffectLoc(pPlayer, "clienteffect/avatar_explosion_02.cef", self.zoneName, SceneObject(pPlayer):getPositionX(), SceneObject(pPlayer):getPositionZ(), SceneObject(pPlayer):getPositionY(), SceneObject(pPlayer):getParentID())
	CreatureObject(pPlayer):setPosture(14)
	createEvent(3000, "AvatarPlatform", "warpOut", pPlayer, "")
	self:scheduleRecycle()
end

function AvatarPlatform:useCellTerminal(pPlayer, role)
	local n = string.sub(role, 5)
	writeStringData(SceneObject(pPlayer):getObjectID() .. ":AvatarPlatform:cell", n)

	local sui = SuiMessageBox.new("AvatarPlatform", "cellCallback")
	sui.setTitle(self.stf .. "unlock_cell")
	sui.setPrompt(self.stf .. "destroy_wke")
	sui.setOkButtonText(self.stf .. "unlock_cell")
	sui.setOtherButtonText(self.stf .. "destroy_wke")
	sui.setCancelButtonText("@cancel")
	sui.setProperty("btnRevert", "OnPress", "RevertWasPressed=1\r\nparent.btnOk.press=t")
	sui.subscribeToPropertyForEvent(SuiEventType.SET_onClosedOk, "btnRevert", "RevertWasPressed")
	sui.sendTo(pPlayer)
end

function AvatarPlatform:cellCallback(pPlayer, pSui, eventIndex, ...)
	if (pPlayer == nil) then
		return
	end

	local n = readStringData(SceneObject(pPlayer):getObjectID() .. ":AvatarPlatform:cell")
	deleteStringData(SceneObject(pPlayer):getObjectID() .. ":AvatarPlatform:cell")

	if (eventIndex == 1) then
		return
	end

	local args = { ... }
	local execute = args[1]

	if (execute ~= nil) then
		self:executePrisoner(pPlayer, n)
	else
		self:freePrisoner(pPlayer, n)
	end
end

function AvatarPlatform:prisonerSpec(n)
	local key = "p" .. tostring(n)
	local i

	for i = 1, #self.prisoners do
		if (self.prisoners[i].key == key) then
			return self.prisoners[i]
		end
	end

	return nil
end

function AvatarPlatform:despawn(pObj)
	if (pObj == nil) then
		return
	end

	SceneObject(pObj):destroyObjectFromWorld()
end

function AvatarPlatform:freePrisoner(pPlayer, n)
	local spec = self:prisonerSpec(n)

	if (spec == nil) then
		return
	end

	if (readData(self:dataKey("wkeDone" .. n)) == 1) then
		return
	end

	writeData(self:dataKey("wkeDone" .. n), 1)

	local pMob = self:oidObject(spec.key)
	local pBuilding = self:getBuilding()
	local pDoor = self:oidObject(spec.door)

	if (pDoor ~= nil) then
		self:despawn(pDoor)
		writeData(self:dataKey(spec.door), 0)
	end

	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "cell_unlocked")

	if (pMob == nil) then
		return
	end

	local stage = self:arcStage(spec.quest, pPlayer)
	local runs = self:arcRuns(spec.quest, pPlayer)

	if (stage > 0 or runs > 0) then
		spatialChat(pMob, self.stf .. "wke_no_quest_01")
	else
		spatialChat(pMob, self.stf .. spec.thanks)
		self:arcCall(spec.quest, "grantQuest", pPlayer)
	end

	if (pBuilding ~= nil) then
		local fleeID = self:resolveCell(pBuilding, self.fleePoint.cell)
		SceneObject(pMob):teleport(self.fleePoint.x, self.fleePoint.z, self.fleePoint.y, fleeID)
	end

	createEvent(10000, "AvatarPlatform", "destroyAdopted", pMob, "")
end

function AvatarPlatform:executePrisoner(pPlayer, n)
	local spec = self:prisonerSpec(n)

	if (spec == nil) then
		return
	end

	if (readData(self:dataKey("wkeDone" .. n)) == 1) then
		return
	end

	if (spec.death == "jawa") then
		CreatureObject(pPlayer):sendSystemMessage(self.stf .. "error")
		createEvent(3000, "AvatarPlatform", "summonJawa", pPlayer, "")
		return
	end

	writeData(self:dataKey("wkeDone" .. n), 1)
	CreatureObject(pPlayer):sendSystemMessage(self.stf .. "execute")

	local pMob = self:oidObject(spec.key)

	if (pMob == nil) then
		return
	end

	if (spec.effect ~= nil) then
		playClientEffectLoc(pPlayer, spec.effect, self.zoneName, SceneObject(pMob):getPositionX(), SceneObject(pMob):getPositionZ(), SceneObject(pMob):getPositionY(), SceneObject(pMob):getParentID())
	end

	if (spec.anim ~= nil) then
		CreatureObject(pMob):doAnimation(spec.anim)
	end

	if (spec.deathDelay > 0) then
		createEvent(spec.deathDelay * 1000, "AvatarPlatform", "incapAdopted", pMob, "")
	else
		CreatureObject(pMob):setPosture(14)
	end

	createEvent(10000, "AvatarPlatform", "destroyAdopted", pMob, "")
end

function AvatarPlatform:incapAdopted(pMob)
	if (pMob ~= nil and SceneObject(pMob):isCreatureObject()) then
		CreatureObject(pMob):setPosture(14)
	end
end

function AvatarPlatform:destroyAdopted(pMob)
	self:despawn(pMob)
end

function AvatarPlatform:summonJawa(pPlayer)
	if (readData(self:dataKey("wkeDone6")) == 1) then
		return
	end

	writeData(self:dataKey("wkeDone6"), 1)

	local pJawa = self:oidObject("jawa")
	local pBuilding = self:getBuilding()

	if (pJawa == nil or pBuilding == nil or pPlayer == nil) then
		return
	end

	writeData(self:dataKey("jawaSummoner"), SceneObject(pPlayer):getObjectID())

	local jails = self:resolveCell(pBuilding, "jails")
	SceneObject(pJawa):teleport(self.jawaChatter.x, self.jawaChatter.z, self.jawaChatter.y, jails)
	playClientEffectLoc(pPlayer, "clienteffect/jawa_chatter_01.cef", self.zoneName, self.jawaChatter.x, self.jawaChatter.z, self.jawaChatter.y, jails)

	local pDoor = self:oidObject("door6")

	if (pDoor ~= nil) then
		self:despawn(pDoor)
		writeData(self:dataKey("door6"), 0)
	end

	createEvent(5000, "AvatarPlatform", "jawaAttack", pJawa, "")
end

function AvatarPlatform:jawaAttack(pJawa)
	local pBuilding = self:getBuilding()

	if (pJawa == nil or pBuilding == nil) then
		return
	end

	TangibleObject(pJawa):setPvpStatusBitmask(ATTACKABLE)

	local jails = self:resolveCell(pBuilding, "jails")
	SceneObject(pJawa):teleport(self.jawaAttack.x, self.jawaAttack.z, self.jawaAttack.y, jails)

	local pTarget = self:oidObject("p6")

	if (pTarget ~= nil) then
		CreatureObject(pJawa):engageCombat(pTarget)
		createEvent(5000, "AvatarPlatform", "incapAdopted", pTarget, "")
		createEvent(10000, "AvatarPlatform", "destroyAdopted", pTarget, "")
	end

	createEvent(10000, "AvatarPlatform", "jawaGoHome", pJawa, "")
end

function AvatarPlatform:jawaGoHome(pJawa)
	local pBuilding = self:getBuilding()

	if (pJawa == nil or pBuilding == nil) then
		return
	end

	TangibleObject(pJawa):setPvpStatusBitmask(0)

	local home = self:resolveCell(pBuilding, self.jawaHome.cell)
	SceneObject(pJawa):teleport(self.jawaHome.x, self.jawaHome.z, self.jawaHome.y, home)
end

function AvatarPlatform:onEnteredCommandHall(pPlayer)
	if (self:arcStage("trandoHssisskZssik10ScreenPlay", pPlayer) ~= 1) then
		return
	end

	if (readData(self:dataKey("bossFight")) == 1) then
		return
	end

	writeData(self:dataKey("bossFight"), 1)
	self:spawnBossFight(pPlayer)

	local players = self:playersInBuilding()
	local i

	for i = 1, #players do
		self:arcCall("avatarBossTauntScreenPlay", "grantQuest", players[i])
	end

	createEvent(10000, "AvatarPlatform", "openCommandDeck", pPlayer, "")
end

function AvatarPlatform:spawnBossFight(pPlayer)
	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	print("AvatarPlatform: OPEN ep3_avatar_harwakokok_mighty -- no repo template, not spawned")

	writeData(self:dataKey("minionCount"), 0)

	local i

	for i = 1, #self.bossMinions do
		local row = self.bossMinions[i]
		local cellID = self:resolveCell(pBuilding, row.cell)
		local pMob = spawnMobile(self.zoneName, row.template, 0, row.x, row.z, row.y, row.yaw, cellID)

		if (pMob ~= nil) then
			local n = readData(self:dataKey("minionCount")) + 1
			writeData(self:dataKey("minionCount"), n)
			writeData(self:dataKey("minion" .. n), SceneObject(pMob):getObjectID())
			createEvent(60000, "AvatarPlatform", "minionResetCheck", pMob, "")
		end
	end
end

function AvatarPlatform:openCommandDeck()
	local pBuilding = self:getBuilding()

	if (pBuilding ~= nil) then
		self:unlockRoom(pBuilding, "commanddeck")
	end
end

function AvatarPlatform:onEnteredCommandDeck(pPlayer)
	createEvent(10000, "AvatarPlatform", "lockBossHall", pPlayer, "")
end

function AvatarPlatform:lockBossHall()
	if (readData(self:dataKey("bossDoorLocked")) == 1) then
		return
	end

	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	self:lockRoom(pBuilding, "commandhall08")
	writeData(self:dataKey("bossDoorLocked"), 1)
end

function AvatarPlatform:minionResetCheck(pMob)
	if (pMob == nil) then
		return
	end

	if (CreatureObject(pMob):isInCombat()) then
		createEvent(60000, "AvatarPlatform", "minionResetCheck", pMob, "")
		return
	end

	local parentID = SceneObject(pMob):getParentID()
	local pCell = getSceneObject(parentID)

	if (pCell ~= nil) then
		local i

		for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
			local pObj = SceneObject(pCell):getContainerObject(i)

			if (pObj ~= nil and SceneObject(pObj):isPlayerCreature()) then
				createEvent(60000, "AvatarPlatform", "minionResetCheck", pMob, "")
				return
			end
		end
	end

	self:despawn(pMob)
end

function AvatarPlatform:onEnteredHangar(pPlayer)
	if (self:arcStage("trandoHssisskZssik10ScreenPlay", pPlayer) <= 0) then
		return
	end

	if (readData(self:dataKey("destruct")) == 1 and readData(self:dataKey("explosionHangar")) ~= 1) then
		writeData(self:dataKey("explosionHangar"), 1)
		self:hangarExplosion(pPlayer, 1)
	end

	if (readData(self:dataKey("trandoChat")) == 1) then
		return
	end

	writeData(self:dataKey("trandoChat"), 1)
	createEvent(3000, "AvatarPlatform", "trandoChat1", pPlayer, "")
end

function AvatarPlatform:trandoChat1()
	local pT1 = self:oidObject("trando1")

	if (pT1 ~= nil) then
		spatialChat(pT1, self.stf .. "trando_chat_01")
	end

	createEvent(5000, "AvatarPlatform", "trandoChat2", pT1, "")
end

function AvatarPlatform:trandoChat2()
	local pT2 = self:oidObject("trando2")

	if (pT2 ~= nil) then
		spatialChat(pT2, self.stf .. "trando_chat_02")
	end
end

function AvatarPlatform:hangarExplosion(pPlayer, idx)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		writeData(self:dataKey("explosionHangar"), 0)
		return
	end

	if (readData(self:dataKey("destruct")) ~= 1) then
		writeData(self:dataKey("explosionHangar"), 0)
		return
	end

	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	local hangar = self:resolveCell(pBuilding, "mainhangar")
	local loc = self.hangarExplosions[getRandomNumber(1, #self.hangarExplosions)]
	playClientEffectLoc(pPlayer, "clienteffect/avatar_room_explosion.cef", self.zoneName, loc[1], loc[2], loc[3], hangar)
	createEvent(3000, "AvatarPlatform", "hangarExplosionAgain", pPlayer, "")
end

function AvatarPlatform:hangarExplosionAgain(pPlayer)
	local pBuilding = self:getBuilding()

	if (pBuilding == nil or pPlayer == nil) then
		writeData(self:dataKey("explosionHangar"), 0)
		return
	end

	local hangar = self:resolveCell(pBuilding, "mainhangar")

	if (SceneObject(pPlayer):getParentID() ~= hangar) then
		writeData(self:dataKey("explosionHangar"), 0)
		return
	end

	self:hangarExplosion(pPlayer, 1)
end

function AvatarPlatform:onEnteredEntrance(pPlayer)
	if (self:arcStage("trandoHssisskZssik10ScreenPlay", pPlayer) <= 0) then
		return
	end

	if (readData(self:dataKey("destruct")) == 1 and readData(self:dataKey("explosionHall")) ~= 1) then
		writeData(self:dataKey("explosionHall"), 1)
		self:hallExplosion(pPlayer, 1)
	end
end

function AvatarPlatform:hallExplosion(pPlayer, step)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		writeData(self:dataKey("explosionHall"), 0)
		return
	end

	if (readData(self:dataKey("destruct")) ~= 1) then
		writeData(self:dataKey("explosionHall"), 0)
		return
	end

	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	step = tonumber(step) or 1
	local loc = self.hallExplosions[step]

	if (loc == nil) then
		self:hallExplosionCheck(pPlayer)
		return
	end

	local entrance = self:resolveCell(pBuilding, "entrance")
	playClientEffectLoc(pPlayer, "clienteffect/avatar_hallway_explosion.cef", self.zoneName, loc[1], loc[2], loc[3], entrance)
	createEvent(2000, "AvatarPlatform", "hallExplosionNext", pPlayer, tostring(step + 1))
end

function AvatarPlatform:hallExplosionNext(pPlayer, step)
	self:hallExplosion(pPlayer, tonumber(step))
end

function AvatarPlatform:hallExplosionCheck(pPlayer)
	local pBuilding = self:getBuilding()

	if (pBuilding == nil or pPlayer == nil) then
		writeData(self:dataKey("explosionHall"), 0)
		return
	end

	local entrance = self:resolveCell(pBuilding, "entrance")

	if (SceneObject(pPlayer):getParentID() == entrance) then
		self:hallExplosion(pPlayer, 1)
	else
		writeData(self:dataKey("explosionHall"), 0)
	end
end

function AvatarPlatform:reset()
	self:resetForNextRun()
end

function AvatarPlatform:scheduleRecycle()
	if (readData(self:dataKey("recycleArmed")) == 1) then
		return
	end

	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	writeData(self:dataKey("recycleArmed"), 1)
	writeData(self:dataKey("recycleTries"), 0)
	-- avatar_clean_up.java msgSpaceDungeonCleanup; avatar_controller.java:25
	-- messageTo(..., 5.0f). Copy #0 is shared, so wait until the building is empty.
	createEvent(5000, "AvatarPlatform", "recycleIfEmpty", pBuilding, "")
end

function AvatarPlatform:recycleIfEmpty(pBuilding)
	if (pBuilding == nil) then
		writeData(self:dataKey("recycleArmed"), 0)
		return
	end

	if (#self:playersInBuilding() > 0) then
		local tries = readData(self:dataKey("recycleTries")) + 1
		writeData(self:dataKey("recycleTries"), tries)

		if (tries < 20) then
			createEvent(30000, "AvatarPlatform", "recycleIfEmpty", pBuilding, "")
			return
		end

		writeData(self:dataKey("recycleArmed"), 0)
		return
	end

	writeData(self:dataKey("recycleArmed"), 0)
	self:resetForNextRun()
end

function AvatarPlatform:destroyMinions()
	local n = readData(self:dataKey("minionCount"))
	local i

	for i = 1, n do
		local oid = readData(self:dataKey("minion" .. i))
		local pMob = nil

		if (oid ~= nil and oid ~= 0) then
			pMob = getSceneObject(oid)
		end

		self:despawn(pMob)
		writeData(self:dataKey("minion" .. i), 0)
	end

	writeData(self:dataKey("minionCount"), 0)
end

function AvatarPlatform:restoreDoors(pBuilding)
	local i

	for i = 1, #self.objectRows do
		local row = self.objectRows[i]
		local role = row[7]

		if (string.sub(role, 1, 4) == "door") then
			local pDoor = self:oidObject(role)

			if (pDoor == nil) then
				local cellID = self:resolveCell(pBuilding, row[2])

				if (cellID ~= 0) then
					self:spawnObjectRow(row, cellID)
				end
			end
		end
	end
end

function AvatarPlatform:resetForNextRun()
	local pBuilding = self:getBuilding()

	if (pBuilding == nil) then
		return
	end

	self:destroyMinions()
	self:restoreDoors(pBuilding)
	self:resetState()
	self:lockAvatarDoors(pBuilding)
	self:unlockRoom(pBuilding, "commandhall08")
	self:respawnScriptedMobiles(pBuilding)
end

function AvatarPlatform:respawnScriptedMobiles(pBuilding)
	local i

	for i = 1, #self.prisoners do
		self:respawnScriptedMobile(pBuilding, self.prisoners[i])
	end

	self:respawnScriptedMobile(pBuilding, self.jawaHome, "jawa")
	self:respawnScriptedMobile(pBuilding, self.trando1, "trando1")
	self:respawnScriptedMobile(pBuilding, self.trando2, "trando2")

	local pJawa = self:oidObject("jawa")

	if (pJawa ~= nil) then
		TangibleObject(pJawa):setPvpStatusBitmask(0)
	end
end

-- terminal_launch.java:18-19 ITEM_USE = Launch (20), SERVER_MENU1 = Eject (68).
AvatarLaunchMenuComponent = {}

function AvatarLaunchMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@ep3/sidequests:avatar_launch")
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(68, 3, "@ep3/sidequests:avatar_eject")
end

function AvatarLaunchMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	if (selectedID == 20) then
		AvatarPlatform:useLaunchTerminal(pPlayer)
	elseif (selectedID == 68) then
		AvatarPlatform:useEjectTerminal(pPlayer)
	end

	return 0
end

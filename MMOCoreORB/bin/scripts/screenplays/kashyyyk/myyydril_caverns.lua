MyyydrilCaverns = ScreenPlay:new {
	screenplayName = "MyyydrilCaverns",
	zone = "kashyyyk_pob_dungeons",
	buildingTemplate = "object/building/kashyyyk/thm_kash_myyydril_caverns.iff",
	doorTemplate = "object/tangible/door/thm_kash_cave_myyydril_door.iff",
	entranceID = 14913592,
	nativeEntranceID = -27501 ~ (1 << 48), -- Dead Forest buildout area 0.
	entranceZone = "kashyyyk_dead_forest",
	collectors = {
		["object/tangible/quest/warl_cave_plant.iff"] = "myyydrilKirirrGather1ScreenPlay",
		["object/tangible/quest/r_naktra_crystals.iff"] = "myyydrilLornRetrieve6ScreenPlay",
		["object/tangible/quest/nawika_jewel_box.iff"] = "myyydrilNawikaEscort1ScreenPlay",
	},
	forestQuestProps = {
		["object/tangible/quest/pod_egg_sacs.iff"] = {"r0", "MyyydrilKallaaracRetrieve1MenuComponent"},
		["object/tangible/quest/naktra_crystals.iff"] = {"r1"},
		["object/tangible/quest/luilris_mushrooms.iff"] = {"r2", "MyyydrilYrakaRetrieve2MenuComponent"},
	},
}

registerScreenPlay("MyyydrilCaverns", true)

function MyyydrilCaverns:key(buildingID, suffix)
	return self.screenplayName .. ":" .. buildingID .. ":" .. suffix
end

function MyyydrilCaverns:isBuilding(pBuilding)
	return pBuilding ~= nil and SceneObject(pBuilding):isBuildingObject()
		and SceneObject(pBuilding):getZoneName() == self.zone
		and SceneObject(pBuilding):getTemplateObjectPath() == self.buildingTemplate
end

function MyyydrilCaverns:getBuilding(pObject)
	if (pObject == nil) then
		return nil
	end
	local pBuilding = pObject
	if (not SceneObject(pObject):isBuildingObject()) then
		pBuilding = SceneObject(pObject):getRootParent()
	end
	if (self:isBuilding(pBuilding)) then
		return pBuilding
	end
end

function MyyydrilCaverns:start()
	if (not isZoneEnabled(self.zone)) then
		return
	end
	local foundEntrance = false
	for _, id in ipairs({self.entranceID, self.nativeEntranceID}) do
		local pDoor = getSceneObject(id)
		if (self:isEntrance(pDoor)) then
			SceneObject(pDoor):setObjectMenuComponent("MyyydrilCavernsDoorMenuComponent")
			foundEntrance = true
		end
	end
	if (not foundEntrance) then
		print("MyyydrilCaverns: missing Dead Forest stone door")
	end
	for index, buildingID in ipairs(MyyydrilData.copies) do
		local pBuilding = getSceneObject(buildingID)
		if (self:isBuilding(pBuilding)) then
			local key = self:key(buildingID, "queued")
			if (readData(key) == 0 and not self:isReady(pBuilding)) then
				writeData(key, 1)
				createEvent(index * 1000, self.screenplayName, "populate", pBuilding, "1")
			end
		else
			print("MyyydrilCaverns: missing native copy " .. index .. " (" .. buildingID .. ")")
		end
	end
end

function MyyydrilCaverns:populate(pBuilding, attempt)
	if (not self:isBuilding(pBuilding) or self:isReady(pBuilding)) then
		return
	end
	local id = SceneObject(pBuilding):getObjectID()
	attempt = tonumber(attempt) or 1
	local ready = true
	local cells = {}
	for _, row in ipairs(MyyydrilData.rows) do
		local line, room = row[1], row[3]
		if (cells[room] == nil) then
			local pCell = BuildingObject(pBuilding):getNamedCell(room)
			cells[room] = pCell and SceneObject(pCell):getObjectID() or 0
			if (cells[room] == 0) then
				print("MyyydrilCaverns: missing cell " .. room .. " in " .. id)
			end
		end
		local key = self:key(id, line)
		if (cells[room] == 0 or (readData(key) == 0 and not self:spawnRow(id, row, cells[room]))) then
			ready = false
		end
	end
	if (ready) then
		MyyydrilGrievous:setupCopy(pBuilding)
		writeData(self:key(id, "ready"), 1)
		print("MyyydrilCaverns: placed all " .. #MyyydrilData.rows .. " DSRC rows in " .. id)
	elseif (attempt < 3) then
		createEvent(30000, self.screenplayName, "populate", pBuilding, tostring(attempt + 1))
		return
	end
	deleteData(self:key(id, "queued"))
end

function MyyydrilCaverns:spawnRow(buildingID, row, cellID)
	local line, template, _, x, height, y, yaw, respawn = table.unpack(row)
	local pObject
	if (respawn < 0) then
		local angle = math.rad(yaw) * 0.5
		pObject = spawnSceneObject(self.zone, template, x, height, y, cellID, math.cos(angle), 0, math.sin(angle), 0)
	else
		-- DSRC leaves the creature's randomized heading in place when the row specifies zero.
		local heading = yaw ~= 0 and yaw or getRandomNumber(0, 359999) / 1000
		pObject = spawnMobile(self.zone, template, 0, x, height, y, heading, cellID)
	end
	if (pObject ~= nil and SceneObject(pObject):getParentID() ~= cellID) then
		SceneObject(pObject):destroyObjectFromWorld()
		pObject = nil
	end
	if (pObject == nil) then
		print("MyyydrilCaverns: could not place DSRC row " .. line .. " (" .. template .. ") in " .. buildingID)
		return false
	end

	local oid = SceneObject(pObject):getObjectID()
	writeData(self:key(buildingID, line), oid)
	if (respawn > 0) then
		writeData(self:key(oid, "spawnLine"), line)
		writeData(self:key(oid, "spawnBuilding"), buildingID)
		createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifySpawnDeath", pObject)
	elseif (template == self.doorTemplate) then
		SceneObject(pObject):setObjectMenuComponent("MyyydrilCavernsDoorMenuComponent")
		writeData(self:key(buildingID, "exit"), oid)
	elseif (self.forestQuestProps[template] ~= nil) then
		SceneObject(pObject):setObjectMenuComponent("MyyydrilCavernsGatherMenuComponent")
	elseif (self.collectors[template] ~= nil) then
		_G[self.collectors[template]]:attachObject(pObject)
	elseif (respawn == 0 and SceneObject(pObject):isAiAgent()) then
		AiAgent(pObject):addObjectFlag(AI_STATIONARY)
	end
	return true
end

function MyyydrilCaverns:notifySpawnDeath(pMobile)
	if (pMobile == nil) then
		return 1
	end
	local oid = SceneObject(pMobile):getObjectID()
	local lineKey, buildingKey = self:key(oid, "spawnLine"), self:key(oid, "spawnBuilding")
	local line, buildingID = readData(lineKey), readData(buildingKey)
	if (line == 0 or buildingID == 0) then
		return 1
	end
	deleteData(lineKey)
	deleteData(buildingKey)
	-- The DSRC table has two header lines, followed by contiguous spawn rows.
	local row = MyyydrilData.rows[line - 2]
	local pBuilding = getSceneObject(buildingID)
	if (row ~= nil and row[8] > 0 and self:isBuilding(pBuilding) and readData(self:key(buildingID, line)) == oid) then
		createEvent(row[8] * 1000, self.screenplayName, "respawnRow", pBuilding, line .. ":" .. oid .. ":1")
	end
	return 1
end

function MyyydrilCaverns:respawnRow(pBuilding, args)
	if (not self:isBuilding(pBuilding)) then
		return
	end
	local line, previous, attempt = string.match(args or "", "^(%d+):(-?%d+):(%d+)$")
	line, previous, attempt = tonumber(line), tonumber(previous), tonumber(attempt)
	local row = line and MyyydrilData.rows[line - 2]
	local buildingID = SceneObject(pBuilding):getObjectID()
	if (row == nil or row[8] <= 0 or readData(self:key(buildingID, line)) ~= previous) then
		return
	end
	local pCell = BuildingObject(pBuilding):getNamedCell(row[3])
	if (pCell ~= nil and self:spawnRow(buildingID, row, SceneObject(pCell):getObjectID())) then
		return
	end
	if (attempt < 3) then
		createEvent(5000, self.screenplayName, "respawnRow", pBuilding, line .. ":" .. previous .. ":" .. (attempt + 1))
	end
end

MyyydrilCavernsGatherMenuComponent = {}

function MyyydrilCavernsGatherMenuComponent:fillObjectMenuResponse(pProp, pMenu, pPlayer)
	if (pProp == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local prop = MyyydrilCaverns.forestQuestProps[SceneObject(pProp):getTemplateObjectPath()]
	if (prop == nil) then
		return
	end
	local menu = _G[prop[2]]
	if (menu ~= nil) then
		menu:fillObjectMenuResponse(pProp, pMenu, pPlayer)
	end
	local text = forestKerritambaEpic1ScreenPlay:getRadialText(pPlayer, prop[1])
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenu):addRadialMenuItem(21, 3, text)
	end
end

function MyyydrilCavernsGatherMenuComponent:handleObjectMenuSelect(pProp, pPlayer, option)
	if (pProp == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end
	local prop = MyyydrilCaverns.forestQuestProps[SceneObject(pProp):getTemplateObjectPath()]
	if (prop == nil) then
		return 0
	end
	local menu = _G[prop[2]]
	if (option == 21 and CreatureObject(pPlayer):isInRangeWithObject(pProp, 8)) then
		forestKerritambaEpic1ScreenPlay:collectProp(pPlayer, prop[1])
	elseif (menu ~= nil) then
		return menu:handleObjectMenuSelect(pProp, pPlayer, option)
	end
	return 0
end

function MyyydrilCaverns:isReady(pBuilding)
	return self:isBuilding(pBuilding) and readData(self:key(SceneObject(pBuilding):getObjectID(), "ready")) == 1
end

function MyyydrilCaverns:isEntrance(pDoor)
	if (pDoor == nil) then
		return false
	end
	local door = SceneObject(pDoor)
	local id = door:getObjectID()
	return (id == self.entranceID or id == self.nativeEntranceID)
		and door:getZoneName() == self.entranceZone and door:getParentID() == 0
		and door:getTemplateObjectPath() == self.doorTemplate
end

function MyyydrilCaverns:getDirection(pDoor)
	if (self:isEntrance(pDoor)) then
		return "deadforest_myyydril"
	end
	local pBuilding = self:getBuilding(pDoor)
	if (self:isReady(pBuilding) and readData(self:key(SceneObject(pBuilding):getObjectID(), "exit")) == SceneObject(pDoor):getObjectID()) then
		return "myyydril_deadforest"
	end
end

function MyyydrilCaverns:canUse(pDoor, pPlayer)
	return pDoor ~= nil and pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()
		and SceneObject(pDoor):getZoneName() == SceneObject(pPlayer):getZoneName()
		and SceneObject(pDoor):getParentID() == SceneObject(pPlayer):getParentID()
		and SceneObject(pPlayer):getDistanceTo(pDoor) <= 6
end

function MyyydrilCaverns:getPlayersInCopy(pBuilding)
	local players = {}
	for _, pPlayer in ipairs(SceneObject(pBuilding):getPlayersInRange(512) or {}) do
		if (SceneObject(pPlayer):getRootParent() == pBuilding) then
			players[#players + 1] = pPlayer
		end
	end
	return players
end

function MyyydrilCaverns:populationLabel(pBuilding)
	local population = #self:getPlayersInCopy(pBuilding)
	if (population < 20) then return "Light" end
	if (population < 40) then return "Medium" end
	if (population < 60) then return "Heavy" end
	return "Full"
end

function MyyydrilCaverns:selectCopy(pDoor, pPlayer)
	local rows = {}
	for index, id in ipairs(MyyydrilData.copies) do
		local pBuilding = getSceneObject(id)
		if (self:isReady(pBuilding)) then
			rows[#rows + 1] = {"Myyydril Caverns " .. index .. " - " .. self:populationLabel(pBuilding), id}
		end
	end
	if (#rows == 1) then
		self:enter(pPlayer, rows[1][2])
	elseif (#rows > 1) then
		local sui = SuiListBox.new(self.screenplayName, "onCopySelected")
		sui.setTitle("Select Zone Instance")
		sui.setPrompt("Choose a Myyydril Caverns instance.")
		-- Keep the server door ID in page data. The client may know it by a different ID.
		sui.setStoredData("door", tostring(SceneObject(pDoor):getObjectID()))
		for _, row in ipairs(rows) do
			sui.add(row[1], tostring(row[2]))
		end
		sui.sendTo(pPlayer)
	else
		CreatureObject(pPlayer):sendSystemMessage("@travel/zone_transition:zone_unavailable")
	end
end

function MyyydrilCaverns:onCopySelected(pPlayer, pSui, eventIndex, selected)
	local row = math.tointeger(tonumber(selected))
	if (pPlayer == nil or pSui == nil or tonumber(eventIndex) ~= 0 or row == nil or row < 0) then
		return
	end
	local pPage = LuaSuiBoxPage(pSui):getSuiPageData()
	if (pPage == nil) then
		return
	end
	local page = LuaSuiPageData(pPage)
	local id = tonumber(page:getStoredData(tostring(row)))
	local doorID = tonumber(page:getStoredData("door"))
	if (id == nil or doorID == nil) then
		return
	end
	local pDoor = getSceneObject(doorID)
	if (self:isEntrance(pDoor) and self:canUse(pDoor, pPlayer)) then
		self:enter(pPlayer, id)
	end
end

function MyyydrilCaverns:enter(pPlayer, id)
	local pBuilding = getSceneObject(id)
	if (not self:isReady(pBuilding)) then
		return
	end
	local pCell = BuildingObject(pBuilding):getNamedCell("hall1")
	if (pCell ~= nil) then
		self:travel(pPlayer, self.zone, -4, -4, -12, SceneObject(pCell):getObjectID())
		createEvent(2000, self.screenplayName, "validateLocation", pPlayer, "")
	end
end

function MyyydrilCaverns:travel(pPlayer, zone, x, height, y, cell)
	if (zone == self.zone) then
		writeScreenPlayData(pPlayer, self.screenplayName, "entered", "1")
	end
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end
	SceneObject(pPlayer):switchZone(zone, x, height, y, cell)
	if (zone ~= self.zone and SceneObject(pPlayer):getZoneName() ~= self.zone) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "entered")
	end
end

function MyyydrilCaverns:playerLoggedIn(pPlayer)
	if (readScreenPlayData(pPlayer, self.screenplayName, "entered") == "1") then
		createEvent(2000, self.screenplayName, "validateLocation", pPlayer, "")
	end
end

function MyyydrilCaverns:validateLocation(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()
		or readScreenPlayData(pPlayer, self.screenplayName, "entered") ~= "1") then
		return
	end
	local player = SceneObject(pPlayer)
	if (player:getZoneName() ~= self.zone) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "entered")
	elseif (player:getParentID() == 0 and isZoneEnabled(self.entranceZone)) then
		self:travel(pPlayer, self.entranceZone, -205, 38, 301, 0)
	end
end

MyyydrilCavernsDoorMenuComponent = {}

function MyyydrilCavernsDoorMenuComponent:fillObjectMenuResponse(pDoor, pMenu, pPlayer)
	local direction = MyyydrilCaverns:getDirection(pDoor)
	if (direction and MyyydrilCaverns:canUse(pDoor, pPlayer)) then
		LuaObjectMenuResponse(pMenu):addRadialMenuItem(20, 3, "@travel/zone_transition:" .. direction)
	end
end

function MyyydrilCavernsDoorMenuComponent:handleObjectMenuSelect(pDoor, pPlayer, option)
	if (option == 20 and MyyydrilCaverns:canUse(pDoor, pPlayer)) then
		local direction = MyyydrilCaverns:getDirection(pDoor)
		if (direction == "deadforest_myyydril") then
			MyyydrilCaverns:selectCopy(pDoor, pPlayer)
		elseif (direction == "myyydril_deadforest" and isZoneEnabled(MyyydrilCaverns.entranceZone)) then
			MyyydrilCaverns:travel(pPlayer, MyyydrilCaverns.entranceZone, -242, 38, 302, 0)
		end
	end
	return 0
end

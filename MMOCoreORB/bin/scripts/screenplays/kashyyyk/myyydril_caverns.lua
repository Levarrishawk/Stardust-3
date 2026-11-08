MyyydrilCaverns = ScreenPlay:new {
	screenplayName = "MyyydrilCaverns",
	zone = "kashyyyk_pob_dungeons",
	buildingTemplate = "object/building/kashyyyk/thm_kash_myyydril_caverns.iff",
	doorTemplate = "object/tangible/door/thm_kash_cave_myyydril_door.iff",
	entranceID = 14913592,
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
	local pDoor = getSceneObject(self.entranceID)
	if (self:isEntrance(pDoor)) then
		SceneObject(pDoor):setObjectMenuComponent("MyyydrilCavernsDoorMenuComponent")
	else
		print("MyyydrilCaverns: missing Dead Forest stone door " .. self.entranceID)
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
		local line, template, room, x, height, y, yaw, respawn = table.unpack(row)
		if (cells[room] == nil) then
			local pCell = BuildingObject(pBuilding):getNamedCell(room)
			cells[room] = pCell and SceneObject(pCell):getObjectID() or 0
			if (cells[room] == 0) then
				print("MyyydrilCaverns: missing cell " .. room .. " in " .. id)
			end
		end
		local key = self:key(id, line)
		if (cells[room] == 0) then
			ready = false
		elseif (readData(key) == 0) then
			local pObject
			if (respawn < 0) then
				local angle = math.rad(yaw) * 0.5
				pObject = spawnSceneObject(self.zone, template, x, height, y, cells[room], math.cos(angle), 0, math.sin(angle), 0)
			else
				pObject = spawnMobile(self.zone, template, respawn, x, height, y, yaw, cells[room])
			end
			if (pObject ~= nil and SceneObject(pObject):getParentID() ~= cells[room]) then
				SceneObject(pObject):destroyObjectFromWorld()
				pObject = nil
			end
			if (pObject == nil) then
				print("MyyydrilCaverns: could not place DSRC row " .. line .. " (" .. template .. ") in " .. id)
				ready = false
			else
				writeData(key, SceneObject(pObject):getObjectID())
				if (template == self.doorTemplate) then
					SceneObject(pObject):setObjectMenuComponent("MyyydrilCavernsDoorMenuComponent")
					writeData(self:key(id, "exit"), SceneObject(pObject):getObjectID())
				elseif (self.forestQuestProps[template] ~= nil) then
					SceneObject(pObject):setObjectMenuComponent("MyyydrilCavernsGatherMenuComponent")
				elseif (self.collectors[template] ~= nil) then
					_G[self.collectors[template]]:attachObject(pObject)
				elseif (respawn == 0 and SceneObject(pObject):isAiAgent()) then
					AiAgent(pObject):addObjectFlag(AI_STATIONARY)
				end
			end
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
	return pDoor ~= nil and SceneObject(pDoor):getObjectID() == self.entranceID
		and SceneObject(pDoor):getZoneName() == self.entranceZone
		and SceneObject(pDoor):getTemplateObjectPath() == self.doorTemplate
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

function MyyydrilCaverns:populationLabel(pBuilding)
	local building = BuildingObject(pBuilding)
	local population = 0
	for index = 1, building:getTotalCellNumber() do
		local name = building:getCellName(index)
		local pCell = name and name ~= "" and building:getNamedCell(name)
		if (pCell) then
			local cell = SceneObject(pCell)
			for slot = 0, cell:getContainerObjectsSize() - 1 do
				local pObject = cell:getContainerObject(slot)
				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					population = population + 1
				end
			end
		end
	end
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
		LuaSuiManager():sendListBox(pDoor, pPlayer, "Select Zone Instance", "Choose a Myyydril Caverns instance.", 2,
			"@cancel", "", "@ok", self.screenplayName, "onCopySelected", 6, rows)
	else
		CreatureObject(pPlayer):sendSystemMessage("@travel/zone_transition:zone_unavailable")
	end
end

function MyyydrilCaverns:onCopySelected(pPlayer, pSui, eventIndex, _, selected)
	local row = tonumber(selected)
	if (pPlayer == nil or pSui == nil or tonumber(eventIndex) == 1 or row == nil or row < 0) then
		return
	end
	local list = LuaSuiListBox(pSui)
	local pDoor = list:getUsingObject()
	if (self:isEntrance(pDoor) and self:canUse(pDoor, pPlayer)) then
		self:enter(pPlayer, list:getMenuObjectID(row))
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

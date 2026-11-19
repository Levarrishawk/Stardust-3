SenatePlinthTerminal = {}

local terminalTemplate = "object/tangible/terminal/senate_plinth_terminal.iff"
local senateTemplate = "object/building/coruscant/imperial_senate.iff"
local halfTurn = math.sqrt(.5)

-- The stock panel's face is 1.14 m above its origin. Both panels lie flat
-- on existing desks. Coordinates are building-local and z is height in Core3.
local gallery = {
	name = "Presiding platform terminal", action = "Ascend to the Emperor's plinth",
	x = 2.7, z = 1.245, y = -89.38, rotation = {0, 0, halfTurn, halfTurn},
	arrival = {x = 2.7, z = 0, y = -90.1, heading = 0}
}
local plinth = {
	name = "Presiding desk return control", action = "Return to the main gallery",
	x = 0, z = 12.825, y = -1.36, rotation = {halfTurn, -halfTurn, 0, 0},
	arrival = {x = 0, z = 12.06, y = -.34, heading = math.pi}
}

local stations = {plinth, gallery}

local function isChamber(pCell)
	if pCell == nil or not SceneObject(pCell):isCellObject() then return false end
	local building = SceneObject(pCell):getParent()
	return building ~= nil and SceneObject(building):getTemplateObjectPath() == senateTemplate
		and BuildingObject(building):getCell(2) == pCell
end

local function stationAt(pPanel)
	if pPanel == nil then return end
	local panel = SceneObject(pPanel)
	if panel:getTemplateObjectPath() ~= terminalTemplate then return end
	for _, station in ipairs(stations) do
		if math.abs(panel:getPositionX() - station.x) < .02 and math.abs(panel:getPositionY() - station.y) < .02
			and math.abs(panel:getPositionZ() - station.z) < .02 then return station end
	end
end

local function installed(pCell)
	local cell = SceneObject1(pCell)
	local found = {}
	for i = 0, cell:getContainerObjectsSize() - 1 do
		local station = stationAt(cell:getContainerObject(i))
		if station then found[station] = true end
		if found[plinth] and found[gallery] then break end
	end
	return found
end

-- A cell-targeted event runs under the cell lock. This also installs the pair
-- in Senate buildings that were already placed before the terminals existed.
function SenatePlinthTerminal:install(pCell)
	if not isChamber(pCell) then return end
	local found = installed(pCell)
	local cell = SceneObject(pCell)
	local zone, id = cell:getZoneName(), cell:getObjectID()
	for _, station in ipairs(stations) do
		if not found[station] then
			local r = station.rotation
			local panel = spawnSceneObject(zone, terminalTemplate, station.x, station.z, station.y, id, r[1], r[2], r[3], r[4])
			if panel == nil then return end
			SceneObject(panel):setCustomObjectName(station.name)
		end
	end
end

function SenatePlinthTerminal:enteredCell(pPlayer, pCell)
	if isChamber(pCell) then
		createEvent(1, "SenatePlinthTerminal", "install", pCell, "")
	end
	return 0
end

function SenatePlinthTerminal:playerLoggedIn(pPlayer)
	if not hasObserver(PARENTCHANGED, "SenatePlinthTerminal", "enteredCell", pPlayer) then
		createObserver(PARENTCHANGED, "SenatePlinthTerminal", "enteredCell", pPlayer)
	end
	self:enteredCell(pPlayer, CreatureObject(pPlayer):getParent())
end

local function source(pPlayer, pPanel)
	if pPlayer == nil or pPanel == nil then return end
	local player = CreatureObject(pPlayer)
	local pCell = player:getParent()
	if SceneObject(pPanel):getParent() ~= pCell or not player:isInRangeWithObject3d(pPanel, 3)
		or not isChamber(pCell) then return end
	local ghost = player:getPlayerObject()
	if ghost ~= nil then return stationAt(pPanel), pCell, ghost end
end

function SenatePlinthTerminal:fillObjectMenuResponse(pPanel, pMenu, pPlayer)
	local station, _, ghost = source(pPlayer, pPanel)
	if station and (station == plinth or PlayerObject(ghost):isPrivileged()) then
		LuaObjectMenuResponse(pMenu):addRadialMenuItem(20, 3, station.action)
	end
end

function SenatePlinthTerminal:handleObjectMenuSelect(pPanel, pPlayer, selection)
	if selection ~= 20 then return 0 end
	local station, pCell, ghost = source(pPlayer, pPanel)
	if not station then return 0 end
	local destination = gallery
	if station == gallery then
		if not PlayerObject(ghost):isPrivileged() then
			CreatureObject(pPlayer):sendSystemMessage("Access to the Emperor's plinth is restricted.")
			return 0
		end
		if not installed(pCell)[plinth] then
			createEvent(1, "SenatePlinthTerminal", "install", pCell, "")
			CreatureObject(pPlayer):sendSystemMessage("The presiding desk is offline. Please try again in a moment.")
			return 0
		end
		destination = plinth
	end
	local id = SceneObject(pCell):getObjectID()
	local player = SceneObject(pPlayer)
	local landing = destination.arrival
	player:setDirectionalHeading(landing.heading)
	player:teleport(landing.x, landing.z, landing.y, id)
	return 0
end

-- Run from MMOCoreORB with LuaJIT: luajit bin/scripts/screenplays/tests/coruscant_space_test.lua
local root = "bin/scripts/"
local function load(path) dofile(root .. path) end
local function read(path)
	local file = assert(io.open(root .. path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end
local prototype = {}
function prototype:new(object)
	self.__index = self
	return setmetatable(object or {}, self)
end
ScreenPlay = prototype:new()
ShipAgent = prototype:new()
conv_handler = prototype:new()
SHIP_SPAWN_SINGLE, SHIP_SPAWN_SQUADRON = 1, 2
SHIP_AI_GUARD_PATROL, SHIP_AI_FIXED_PATROL, SHIP_AI_SINGLE_PATROL_ROTATION = 1, 2, 3
SHIP_SQUADRON_FORM_WALL, SHIP_SQUADRON_FORM_WEDGE, SHIP_SQUADRON_FORM_LINE = 1, 2, 3
NONE, AIENABLED, INVULNERABLE, ATTACKABLE, TURRETSHIP = 0, 1, 2, 4, 8
SHIPDESTROYED = 1
function registerScreenPlay() end
function includeFile() end
local agents, events, ships, data, points = {}, {}, {}, {}, {}
ShipAgentTemplates = {}
function ShipAgentTemplates:addShipAgentTemplate(agent, name) agents[name] = agent end
function createEvent(delay, screenplay, method, object, argument)
	table.insert(events, {delay = delay, method = method, argument = argument})
end
function getRandomNumber(low, high) return high and low or 1 end
function writeData(key, value) data[key] = value end
writeStringData = writeData
function readData(key) return data[key] or 0 end
function deleteData(key) data[key] = nil end
function createObserver() end
function dropObserver() end
local enabled = false
function isZoneEnabled() return enabled end
local shipMethods = prototype:new()
function shipMethods:getObjectID() return self.id end
function shipMethods:isShipAiAgent() return true end
function shipMethods:setDespawnOnNoPlayerInRange(value) self.despawn = value end
function shipMethods:setMinimumGuardPatrol(value) self.minPatrol = value end
function shipMethods:setMaximumGuardPatrol(value) self.maxPatrol = value end
function shipMethods:setGuardPatrol() self.patrol = "guard" end
function shipMethods:setFixedPatrol() self.patrol = "fixed" end
function shipMethods:addFixedPatrolPoint(name)
	assert(points[name], "Unregistered patrol point: " .. name)
	table.insert(self.points, name)
end
function shipMethods:createSquadron(formation) assert(formation) end
function shipMethods:assignToSquadron(leader) self.leader = leader end
function spawnShipAgent(name, zone, x, z, y)
	if (not agents[name]) then load("ship_mobile/ships/" .. name .. ".lua") end
	assert(agents[name] and zone == "space_coruscant", name)
	local ship = shipMethods:new {id = #ships + 1, name = name, x = x, z = z, y = y, points = {}}
	table.insert(ships, ship)
	return ship
end
function SceneObject(object) return object end
ShipAiAgent = SceneObject

load("screenplays/space/spawning/space_spawner.lua")
load("screenplays/space/spawning/space_coruscant_spawner.lua")
load("ship_mobile/ships/star_destroyer.lua")
load("ship_mobile/ships/imperial_venator.lua")
load("ship_mobile/ships/spacestation_imperial.lua")
load("ship_mobile/ships/spacestation_coruscant.lua")
assert(agents.spacestation_coruscant.pvpBitmask == NONE)
assert(agents.spacestation_coruscant.customShipAiMap == "spaceStations")
assert(agents.spacestation_coruscant.conversationMessage:sub(1, 1) == "@", "Comm message requires a client string reference")
ObjectTemplates = {}
function ObjectTemplates:addTemplate(object, path) self[path] = object end
object_ship_shared_spacestation_imperial = prototype:new {clientTemplateFileName = "object/ship/shared_spacestation_imperial.iff"}
load("object/ship/spacestation_imperial.lua")
load("object/custom_content/ship/spacestation_coruscant.lua")
local object = assert(ObjectTemplates["object/ship/spacestation_coruscant.iff"])
assert(object.clientTemplateFileName == object_ship_shared_spacestation_imperial.clientTemplateFileName)
load("managers/space/ship_chassis.lua")
local collisionRegistered = false
for _, row in ipairs(chassisData) do
	if (row[1] == "spacestation_coruscant") then
		assert(row[2] == "spacestation_imperial" and row[3] == "object/ship/spacestation_coruscant.iff")
		collisionRegistered = true
	end
end
assert(collisionRegistered)
load("managers/space/space_manager.lua")
assert(#space_coruscant.spaceStations == 1)
local station = space_coruscant.spaceStations[1]
assert(station.templateFile == "spacestation_coruscant" and station.x == 0 and station.z == 0 and station.y == 0)
load("ship_mobile/space_patrol_points.lua")
function addSpacePatrolPoints(zone, list)
	assert(zone == "space_coruscant" and #list == 84)
	for _, point in ipairs(list) do
		assert(not points[point.patrolPointName])
		points[point.patrolPointName] = point
		assert(math.max(math.abs(point.x), math.abs(point.z), math.abs(point.y)) < 8000)
	end
end
load("ship_mobile/patrol_points/space_coruscant.lua")

local spawner = SpaceCoruscantSpawner
spawner:start()
assert(#events == 0, "Disabled zone scheduled spawns")
enabled = true
spawner:start()
assert(#events == 2 and events[1].method == "populateSpawns" and events[2].method == "spawnPrimaryTargets")
events = {}
spawner:spawnPrimaryTargets()
assert(#ships == 10)
local counts, boxes = {}, {}
-- Measured appearance bounds, ordered x, vertical z, longitudinal y.
local bounds = {
	star_destroyer = {{-718.365, -124.451, -1881.098}, {718.365, 522.373, 705.756}},
	imperial_venator = {{-486, -160, -1005}, {486, 160, 1005}},
}
local function box(ship, limits)
	local origin, result = {ship.x, ship.z, ship.y}, {{}, {}}
	for axis = 1, 3 do
		result[1][axis] = origin[axis] + limits[1][axis]
		result[2][axis] = origin[axis] + limits[2][axis]
		assert(result[1][axis] > -8000 and result[2][axis] < 8000)
	end
	return result
end
boxes[1] = box(station, {{-147, -152, -90}, {147, 152, 90}})
for _, ship in ipairs(ships) do
	counts[ship.name] = (counts[ship.name] or 0) + 1
	assert(ship.despawn == false)
	table.insert(boxes, box(ship, bounds[ship.name]))
end
assert(counts.star_destroyer == 6 and counts.imperial_venator == 4)
for i = 1, 2 do
	local ship = ships[i]
	assert(math.sqrt(ship.x^2 + ship.z^2 + ship.y^2) <= 1500)
end
for i = 1, #boxes do
	for j = i + 1, #boxes do
		local overlap = true
		for axis = 1, 3 do
			if (boxes[i][2][axis] < boxes[j][1][axis] or boxes[j][2][axis] < boxes[i][1][axis]) then overlap = false end
		end
		assert(not overlap, "Station/capital hulls overlap: " .. i .. ", " .. j)
	end
end
spawner:primaryTargetDestroyed(ships[1], nil)
assert(#events == 1 and events[1].method == "spawnPrimaryTarget" and events[1].argument == "1" and events[1].delay == 1800000)
events = {}
spawner:populateSpawns()
assert(#events == 176, "Wrong initial single/squadron event count")
local names, civilians = {}, 0
for _, event in ipairs(events) do
	spawner[event.method](spawner, nil, event.argument)
end
assert(#ships == 226, "Expected 10 capitals + 216 ambient ships")
local registry = read("ship_mobile/ships/serverobjects.lua")
for _, ship in ipairs(ships) do
	assert(registry:find('includeFile("' .. ship.name .. '.lua")', 1, true), "Agent not included: " .. ship.name)
	assert(ship.despawn == false)
	if (ship.patrol == "fixed") then
		civilians = civilians + 1
		assert(#ship.points == 7)
	end
end
assert(civilians == 60)
for _, spawn in ipairs(spawner.shipSpawns) do
	assert(not names[spawn.spawnName], "Duplicate spawn name")
	names[spawn.spawnName] = true
	local radius = spawn.maxSpawnDistance + (spawn.maxPatrol or 0)
	assert(math.max(math.abs(spawn.x), math.abs(spawn.z), math.abs(spawn.y)) + radius < 8000)
end

ConvoScreen = prototype:new()
function ConvoScreen:getScreenID() return self.id end
function ConvoScreen:cloneScreen() return self:new {id = self.id} end
function ConvoScreen:setCustomDialogText(text) self.text = text end
ConvoTemplate = prototype:new()
function ConvoTemplate:addScreen(screen) self.screens[screen.id] = screen end
function ConvoTemplate:getScreen(id) return assert(self.screens[id], id) end
function addConversationTemplate() end
LuaConversationScreen, LuaConversationTemplate = SceneObject, SceneObject
load("mobile/conversations/space/spacestation_coruscant.lua")
load("screenplays/space/spacestations/spacestation.lua")
local destination = SpaceStationScreenPlay.travelPoints.coruscant_spaceport
assert(destination[1] == "coruscant" and destination[2] == -96 and destination[3] == 40 and destination[4] == 3149)
local landed, repaired, credits = 0, 0, true
function SpaceStationScreenPlay:hasCreditsForRepair() return credits end
function SpaceStationScreenPlay:getRepairCost() return 1234 end
function SpaceStationScreenPlay:repairShip() repaired = repaired + 1 end
function SpaceStationScreenPlay:landShip(player, target) assert(target == "coruscant_spaceport"); landed = landed + 1 end
load("screenplays/space/spacestations/spacestation_coruscant_conv_handler.lua")
local handler, template = SpacestationCoruscantConvoHandler, spacestation_coruscant_convotemplate
local player, ship, npc = {}, {inRange = true, zone = "space_coruscant"}, {}
function player:getRootParent() return self.ship end
function ship:isShipObject() return true end
function ship:getZoneName() return self.zone end
function ship:checkInConversationRange() return self.inRange end
assert(handler:getInitialScreen(nil, npc, template) == nil)
assert(handler:getInitialScreen(player, npc, template) == nil)
player.ship = ship
for _, screen in pairs(template.screens) do
	for _, option in ipairs(screen.options) do assert(template.screens[option[2]]) end
end
local function select(id) return handler:runScreenHandlers(template, player, npc, 0, template:getScreen(id)) end
assert(handler:getInitialScreen(player, npc, template).id == "greeting")
assert(select("repair_quote").text:find("1234", 1, true))
credits = false
assert(select("repair").id == "unavailable" and repaired == 0)
credits = true
ship.inRange = false
assert(select("land").id == "out_of_range" and landed == 0)
ship.inRange, ship.zone = true, "space_naboo"
assert(select("repair").id == "out_of_range" and repaired == 0)
ship.zone = "space_coruscant"
select("land")
select("repair")
assert(landed == 1 and repaired == 1)
print("PASS: Coruscant station, 10 capital hulls, 216 ambient ships, 84 route points, spawn/respawn scheduling, and station service guards")

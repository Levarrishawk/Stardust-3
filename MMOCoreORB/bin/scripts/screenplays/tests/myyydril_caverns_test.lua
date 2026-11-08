-- Standalone Lua 5.3 test. Run from the repository root.
local root = "MMOCoreORB/bin/scripts/screenplays/kashyyyk/"
local zone = "kashyyyk_pob_dungeons"
local forest = "kashyyyk_dead_forest"
local objects, data, events, observations = {}, {}, {}, {}
local counts = {mobile = 0, static = 0, respawn = 0}
local nextID = 20000000

ScreenPlay = {new = function(self, value) return setmetatable(value, {__index = self}) end}
function registerScreenPlay() end
function isZoneEnabled(name) return name == zone or name == forest end
function getSceneObject(id) return objects[id] end
function readData(key) return data[key] or 0 end
function writeData(key, value) data[key] = value end
function deleteData(key) data[key] = nil end
function readScreenPlayData(p, name, key) return data[p.id .. name .. key] or "" end
function writeScreenPlayData(p, name, key, value) data[p.id .. name .. key] = value end
function deleteScreenPlayData(p, name, key) data[p.id .. name .. key] = nil end
function createEvent(delay, name, method, object, args) table.insert(events, {name, method, object, args, delay}) end
function createObserver(event, name, method, object)
	observations[object] = observations[object] or {}
	assert(not observations[object][event])
	observations[object][event] = method
end

function SceneObject(p) return p end
CreatureObject, BuildingObject, AiAgent, TangibleObject = SceneObject, SceneObject, SceneObject, SceneObject
ENTEREDBUILDING, AI_STATIONARY, OBJECTDESTRUCTION, DAMAGERECEIVED, ATTACKABLE = 1, 2, 3, 4, 5
function creatureTemplateExists() return true end
function getRandomNumber(first) return first end

local function object(id, template, scene, parent, kind)
	local p = {id = id, template = template, zone = scene, parent = parent, kind = kind, contents = {}}
	function p:getObjectID() return self.id end
	function p:getTemplateObjectPath() return self.template end
	function p:getZoneName() return self.zone end
	function p:getParentID() return self.parent end
	function p:getRootParent() return objects[objects[self.parent] and objects[self.parent].parent] end
	function p:isBuildingObject() return self.kind == "building" end
	function p:isPlayerCreature() return self.kind == "player" end
	function p:isAiAgent() return self.kind == "mobile" end
	function p:getDistanceTo() return 1 end
	function p:setObjectMenuComponent(component) self.menu = component end
	function p:getContainerObjectsSize() return #self.contents end
	function p:getContainerObject(index) return self.contents[index + 1] end
	function p:addObjectFlag(flag) self.flag = flag end
	function p:setPvpStatusBitmask(flag) self.pvp = flag end
	function p:getConditionDamage() return 0 end
	function p:destroyObjectFromWorld() objects[self.id] = nil end
	function p:isRidingMount() return false end
	function p:switchZone(dest, x, height, y, cell)
		self.zone, self.parent = dest, cell
		self.travel = {x, height, y}
	end
	objects[id] = p
	return p
end

local failOnce = true
local function spawn(kind, scene, template, parent)
	assert(scene == zone and objects[parent] and objects[parent].kind == "cell")
	if (failOnce) then
		failOnce = false
		return nil
	end
	nextID = nextID + 1
	counts[kind] = counts[kind] + 1
	local p = object(nextID, template, scene, parent, kind)
	table.insert(objects[parent].contents, p)
	return p
end

function spawnSceneObject(scene, template, x, h, y, parent, w, qx, qy, qz)
	assert(math.abs(w * w + qy * qy - 1) < 1e-12 and qx == 0 and qz == 0)
	return spawn("static", scene, template, parent)
end

function spawnMobile(scene, template, seconds, x, h, y, yaw, parent)
	local p = spawn("mobile", scene, template, parent)
	if (p ~= nil and seconds > 0) then counts.respawn = counts.respawn + 1 end
	return p
end

dofile(root .. "myyydril_data.lua")
dofile(root .. "myyydril_caverns.lua")
dofile(root .. "myyydril_grievous.lua")
local caves, grievous = MyyydrilCaverns, MyyydrilGrievous
local rooms, seen = {"hall1", "hall55", "hall56", "hall57", "hall58", "hall59"}, {}
for _, room in ipairs(rooms) do seen[room] = true end
for _, row in ipairs(MyyydrilData.rows) do
	if (not seen[row[3]]) then
		table.insert(rooms, row[3])
		seen[row[3]] = true
	end
end
for _, id in ipairs(MyyydrilData.copies) do
	local p = object(id, caves.buildingTemplate, zone, 0, "building")
	p.rooms = {}
	function p:getNamedCell(name) return self.rooms[name] end
	function p:getTotalCellNumber() return #rooms end
	function p:getCellName(index) return rooms[index] end
	for index, room in ipairs(rooms) do
		p.rooms[room] = object(id + index, "cell", zone, id, "cell")
	end
end
for _, quest in pairs(caves.collectors) do
	_G[quest] = {attachObject = function(self, p) assert(p.parent ~= 0); p.collector = self end}
end
local entrance = object(caves.entranceID, caves.doorTemplate, forest, 0, "static")
local player = object(19999999, "player", forest, 0, "player")
local first, second = objects[MyyydrilData.copies[1]], objects[MyyydrilData.copies[2]]
local function run(event) _G[event[1]][event[2]](_G[event[1]], event[3], event[4]) end

caves:start()
caves:start()
assert(entrance.menu == "MyyydrilCavernsDoorMenuComponent" and #events == 10)
for i = 1, 10 do run(events[i]) end
assert(not caves:isReady(first) and caves:isReady(second))
assert(#events == 11 and events[11][5] == 30000)
run(events[11])
caves:start()
assert(#events == 11 and counts.mobile == 3520 and counts.static == 5650 and counts.respawn == 2420)
for _, id in ipairs(MyyydrilData.copies) do
	assert(caves:isReady(objects[id]) and observations[objects[id]][ENTEREDBUILDING] == "notifyEnteredBuilding")
end

local selection
function LuaSuiManager()
	return {sendListBox = function(self, door, who, title, prompt, buttons, cancel, middle, ok, name, callback, distance, rows)
		assert(door == entrance and who == player and #rows == 10 and callback == "onCopySelected")
		assert(rows[1][2] == first.id and rows[2][2] == second.id)
		selection = rows
	end}
end
function LuaSuiListBox(p) return p end
local sui = {getUsingObject = function() return entrance end,
	getMenuObjectID = function(self, index) return selection[index + 1][2] end}
MyyydrilCavernsDoorMenuComponent:handleObjectMenuSelect(entrance, player, 20)
caves:onCopySelected(player, sui, 1, "", "1")
assert(player.zone == forest)
caves:onCopySelected(player, sui, 0, "", "1")
assert(player.parent == second.rooms.hall1.id and table.concat(player.travel, ",") == "-4,-4,-12")
local exit = objects[readData(caves:key(second.id, "exit"))]
player.parent = exit.parent
MyyydrilCavernsDoorMenuComponent:handleObjectMenuSelect(exit, player, 20)
assert(player.zone == forest and player.parent == 0 and table.concat(player.travel, ",") == "-242,38,302")
assert(readScreenPlayData(player, caves.screenplayName, "entered") == "")
caves:enter(player, first.id)
player.parent = 0
caves:playerLoggedIn(player)
run(events[#events])
assert(player.zone == forest and table.concat(player.travel, ",") == "-205,38,301")

local a, b = grievous:forBuilding(first), grievous:forBuilding(second)
writeData(a:dataKey("active"), 1)
writeData(b:dataKey("active"), 1)
assert(a:setSessionIds() == 1 and b:setSessionIds() == 1 and b:setSessionIds() == 2)
grievous:handleBeginEncounter(first, "1")
grievous:handleBeginEncounter(second, "1")
assert(readData(a:dataKey("manager")) ~= 0 and readData(b:dataKey("manager")) == 0)
grievous:handleBeginEncounter(second, "2")
assert(readData(b:dataKey("manager")) ~= 0)
local powerCell = objects[readData(a:dataKey("powerCell1"))]
local otherCell = readData(b:dataKey("powerCell1"))
grievous:notifyPowerCellDestroyed(powerCell)
local replacement = events[#events]
assert(replacement[2] == "replacePowerCell" and replacement[5] == 20000)
run(replacement)
assert(readData(a:dataKey("powerCell1")) ~= powerCell.id and readData(b:dataKey("powerCell1")) == otherCell)
print("myyydril_caverns_test passed")

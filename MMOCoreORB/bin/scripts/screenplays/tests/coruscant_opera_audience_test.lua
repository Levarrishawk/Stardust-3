-- Run from MMOCoreORB: lua bin/scripts/screenplays/tests/coruscant_opera_audience_test.lua
local scripts = "bin/scripts/"
-- Supply the native handles. Let the real object manager decide which calls share one.
local function newHandle()
	local handle = { _setObject = function(self, object) self.object = object end }
	return setmetatable(handle, { __index = function(self, method)
		return function(_, ...) return self.object[method](self.object, ...) end
	end })
end

local previous = getmetatable(_G)
setmetatable(_G, { __index = function(_, name)
	if name:match("^Lua%u") then return newHandle end
end })
dofile(scripts .. "managers/object/object_manager.lua")
setmetatable(_G, previous)
ScreenPlay = Object
function registerScreenPlay() end
dofile(scripts .. "screenplays/cities/coruscant_entertainment_district.lua")

local district = CoruscantEntertainmentScreenPlay
local cellID = district.operaPerformanceHallCellID
local contents, objects, data = {}, {}, {}
local chairCount, patronCount = 0, 0
local item = {}
function item:isCellObject() return self.id == cellID end
function item:isPlayerCreature() return false end
function item:getObjectID() return self.id end
function item:getTemplateObjectPath() return self.path end
function item:getPositionX() return self.x end
function item:getPositionZ() return self.height end
function item:getPositionY() return self.y end
function item:getContainerObjectsSize() return self.children and #self.children or 0 end
function item:getContainerObject(index)
	assert(index >= 0 and index < self:getContainerObjectsSize(), "container index out of bounds: " .. index)
	return self.children[index + 1]
end

local function add(path, x, height, y)
	local id = #contents + 1
	local object = setmetatable({id = id, path = path, x = x, height = height, y = y}, {__index = item})
	contents[id], objects[id] = object, object
	return object
end

objects[cellID] = setmetatable({id = cellID, children = contents}, {__index = item})
function getSceneObject(id) return objects[id] end
function readData(key) return data[key] or 0 end
function readStringData(key) return data[key] or "" end
function writeData(key, value) data[key] = value end
writeStringData = writeData

function spawnSceneObject(_, path, x, height, y, parent)
	assert(parent == cellID)
	chairCount = chairCount + 1
	return add(path, x, height, y)
end
function spawnMobile(zone, name, respawn, x, height, y, heading, parent)
	assert(zone == "coruscant" and parent == cellID and name == "opera_house_patron" and respawn == 0)
	patronCount = patronCount + 1
	return add(name, x, height, y)
end
function item:addObjectFlag() end
function item:setState() end

-- Existing children exercise chair discovery on the first pass. Repeating setup
-- exercises both scans with the full audience present and must reuse the seats.
add("existing decoration", 0, 0, 0)
add("existing fixture", 1, 0, 0)
for pass = 1, 2 do
	district:populateOperaAuditorium()
	assert(chairCount == 395 and patronCount == 257, "auditorium setup lost or duplicated seats or patrons")
end
print("Opera auditorium startup and repeat population passed.")

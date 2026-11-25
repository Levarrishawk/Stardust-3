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

function spawnSceneObject(_, path, x, height, y, parent, heading)
	assert(parent == cellID)
	chairCount = chairCount + 1
	local chair = add(path, x, height, y)
	chair.heading = heading
	return chair
end
function spawnMobile(zone, name, respawn, x, height, y, heading, parent)
	assert(zone == "coruscant" and parent == cellID and name == "opera_house_patron" and respawn == 0)
	patronCount = patronCount + 1
	local patron = add(name, x, height, y)
	patron.heading = math.rad(heading)
	return patron
end
function item:addObjectFlag() end
function item:getParentID() return cellID end
function item:isAiAgent() return self.path == "opera_house_patron" end
function item:getCreatureTemplateName() return self.path end
function item:getDistanceTo3d(other)
	return math.sqrt((self.x - other.x)^2 + (self.height - other.height)^2 + (self.y - other.y)^2)
end
function item:hasState(state) return self.state == state and 1 or 0 end
function item:setState(state) self.state = state end
function item:clearState(state) assert(self.state == state); self.state = nil end
function item:setHomeLocation(x, height, y, cell)
	assert(cell.id == cellID)
	self.home = {x, height, y}
end
function item:setDirectionalHeading(heading) self.heading = heading end
local moves = 0
function item:teleport(x, height, y, parent)
	assert(parent == cellID and self.state == nil)
	assert(self.home[1] == x and self.home[2] == height and self.home[3] == y)
	self.x, self.height, self.y = x, height, y
	moves = moves + 1
end

-- Existing children exercise chair discovery on the first pass. Repeating setup
-- exercises both scans with the full audience present and must reuse the seats.
add("existing decoration", 0, 0, 0)
add("existing fixture", 1, 0, 0)
for pass = 1, 3 do
	district:populateOperaAuditorium()
	assert(chairCount == 395 and patronCount == 86, "auditorium setup lost or duplicated seats or patrons")
	assert(moves == (pass == 1 and 0 or 86), "each displaced patron should move exactly once")
	local rows = district:spawnOperaSeating()
	local publicVacancies = 0
	for rowIndex, row in ipairs(rows) do
		local key = district.screenplayName .. ":operaAudience:" .. rowIndex
		local plan = assert(data[key])
		for gap in plan:gmatch("%.+") do
			assert(#gap >= 2 and #gap <= 4, "open seats must fit a party within one row")
			publicVacancies = publicVacancies + #gap
		end
		for i, seat in ipairs(row) do
			if plan:sub(i, i) == "P" then
				local patron = assert(objects[data[key .. ":" .. i]])
				local chair = seat.chair
				assert(patron:getDistanceTo3d(chair) < 0.00001, "patron is off the assigned chair")
				assert(math.abs(patron.heading - chair.heading) < 0.00001 and patron.state == 0x80000)
				if pass == 1 then
					patron.x = patron.x + 0.431483 * math.sin(chair.heading)
					patron.y = patron.y + 0.431483 * math.cos(chair.heading)
				end
			end
		end
	end
	assert(publicVacancies == 306) -- Three more seats are in the private box.
end
print("Opera auditorium startup and repeat population passed.")

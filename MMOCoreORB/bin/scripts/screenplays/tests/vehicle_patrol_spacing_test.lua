-- Standalone Lua 5.3+: run from the repository root.
local root = "MMOCoreORB/bin/scripts/screenplays/"
ScreenPlay = {}
function ScreenPlay:new(t)
	return setmetatable(t, {__index = self})
end
getRandomNumber = function(a, b) return math.random(a, b) end
dofile(root .. "cities/city.lua")

local scenarios = {
	{"cities/alderaan_aldera_city.lua", "AlderaCityScreenPlay"},
	{"cities/corellia_coronet.lua", "CorelliaCoronetScreenPlay"},
	{"cities/corellia_doaba_guerfel.lua", "CorelliaDoabaGuerfelScreenPlay"},
	{"cities/corellia_kor_vella.lua", "CorelliaKorVellaScreenPlay"},
	{"cities/corellia_tyrena.lua", "CorelliaTyrenaScreenPlay"},
	{"cities/coruscant_entertainment_district.lua", "CoruscantEntertainmentScreenPlay"},
	{"cities/naboo_theed.lua", "NabooTheedScreenPlay"},
	{"cities/tatooine_mos_eisley.lua", "TatooineMosEisleyScreenPlay"},
	{"cities/tatooine_mos_espa.lua", "TatooineMosEspaScreenPlay"},
	{"racetracks/mosespa_podracer_patrol.lua", "MosEspaPodracerPatrolScreenPlay"}
}

local vehicles, data, sequence = {}, {}, 0
local function object(x, z, y)
	sequence = sequence + 1
	local o = {x = x, z = z, y = y, id = sequence}
	function o:getObjectID() return self.id end
	function o:teleport(tx, tz, ty, cell)
		assert(cell == 0)
		self.x, self.z, self.y = tx, tz, ty
	end
	function o:getPaletteColorCount() return 256 end
	function o:setCustomizationVariable(variable, value)
		assert(value >= 0 and value < 256 and value == math.floor(value))
	end
	function o:setCustomObjectName() end
	function o:setPvpStatusBitmask() end
	function o:setOptionBit() end
	function o:clearOptionBit() end
	return o
end
SceneObject = function(o) return o end
CreatureObject = function(o) return o end
TangibleObject = function(o) return o end
spawnSceneObject = function(planet, template, x, z, y, cell)
	assert(cell == 0)
	local o = object(x, z, y)
	vehicles[#vehicles + 1] = o
	return o
end
spawnMobile = function(planet, template, respawn, x, z, y)
	return object(x, z, y)
end
mountNpc = function() return true end
getTerrainHeight = function() return 0 end
writeData = function(key, value) data[key] = value end
createEvent = function() end

local function pointOnRoute(route, vehicle)
	for i, a in ipairs(route) do
		local b = route[i % #route + 1]
		local ay, by = a[3] or a[2], b[3] or b[2]
		local dx, dy = b[1] - a[1], by - ay
		local lengthSq = dx * dx + dy * dy
		if (lengthSq > 0) then
			local t = ((vehicle.x - a[1]) * dx + (vehicle.y - ay) * dy) / lengthSq
			if (t >= -0.000001 and t <= 1.000001) then
				local ex, ey = vehicle.x - a[1] - t * dx, vehicle.y - ay - t * dy
				if (ex * ex + ey * ey < 0.000001) then return true end
			end
		end
	end
	return false
end

for _, scenario in ipairs(scenarios) do
	local file = assert(io.open(root .. scenario[1], "r"))
	local source = file:read("*a")
	file:close()
	assert(load(source, "@" .. scenario[1])) -- Check the entire file's syntax.
	-- Load the real definitions and vehicle methods without unrelated city content.
	local definitions = assert(source:match("^(.-)registerScreenPlay"))
	assert(load(definitions, "@" .. scenario[1]))()
	local sp = _G[scenario[2]]
	for signature, body in source:gmatch("function ([^\n]+)\n(.-)\nend") do
		if (signature:find("[Ss]pawnMounted") or signature:find("customizeMounted") or signature:find("getMountedSwoopRoutePoint")) then
			assert(load("function " .. signature .. "\n" .. body .. "\nend"))()
		end
	end
	local expected = sp.mountedSwoopRacerCount or sp.mountedSpeederCount + (sp.mountedSpeederSecondCount or 0)
	local previousLayout
	local varied = false
	for seed = 1, 200 do
		math.randomseed(seed)
		vehicles, data = {}, {}
		if sp.mountedSwoopRoute then sp:spawnMountedSwoopPatrol() else sp:spawnMountedSpeederPatrol() end
		assert(#vehicles == expected, scenario[2] .. ": lost configured vehicles at seed " .. seed)
		if (previousLayout) then
			varied = varied or vehicles[1].x ~= previousLayout.x or vehicles[1].y ~= previousLayout.y
		end
		previousLayout = vehicles[1]
		for i, vehicle in ipairs(vehicles) do
			local route = sp.mountedSwoopRoute or sp.mountedSpeederRoute
			if (sp.mountedSpeederSecondRoute and data[vehicle.id .. ":theedSpeederRouteIndex"] == 2) then route = sp.mountedSpeederSecondRoute end
			assert(pointOnRoute(route, vehicle), scenario[2] .. ": spawn left its designated route")
			for j = i + 1, #vehicles do
				local other = vehicles[j]
				assert((vehicle.x - other.x) ^ 2 + (vehicle.y - other.y) ^ 2 >= 35 * 35 - 0.000001,
					scenario[2] .. ": vehicles spawned closer than 35m at seed " .. seed)
			end
		end
	end
	assert(varied, scenario[2] .. ": patrol phase must vary")
	print(scenario[2] .. ": 200 spaced layouts passed")
end

assert(#CityScreenPlay:getVehiclePatrolSpawnDistances({}, 3) == 0)
assert(#CityScreenPlay:getVehiclePatrolSpawnDistances({{0, 0}, {0, 0}}, 3) == 0)
assert(#CityScreenPlay:getVehiclePatrolSpawnDistances({{0, 0}, {100, 0}}, 0) == 0)
print("Vehicle patrol spacing regression passed")

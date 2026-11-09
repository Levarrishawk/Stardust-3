-- Standalone regression test. Run from the repository root.
local root = "MMOCoreORB/bin/scripts/"
local kashyyyk = root .. "screenplays/kashyyyk/"
NONE, AIENABLED, ATTACKABLE, AGGRESSIVE, ENEMY, INVULNERABLE = 0, 1, 2, 4, 8, 16
CONVERSABLE, INTERESTING, NAME_TAG, STALKER, KILLER = 32, 64, 128, 256, 512
MOB_CARNIVORE, MOB_NPC, MOB_DROID = 2, 3, 4
local profiles = {}
addTemplate = function(name, profile) profiles[name] = profile end
addWeapon = function() end
includeFile = function() end
dofile(root .. "mobile/creatures.lua")
local profilePath = root .. "mobile/custom_content/kashyyyk_hunting_profiles.lua"
local file = assert(io.open(profilePath))
for base in file:read("*a"):gmatch('{([%w_]+), "hunting_') do _G[base] = Creature end
file:close()
dofile(profilePath)
local count, wildlife = 0, 0
for _, profile in pairs(profiles) do
	count = count + 1
	assert(profile.objectName ~= "" and profile.randomNameType == NAME_TAG)
	if profile.mobType == MOB_CARNIVORE then
		wildlife = wildlife + 1
		assert(profile.pvpBitmask % (ATTACKABLE * 2) >= ATTACKABLE and profile.optionsBitmask == AIENABLED)
	end
end
assert(count == 61 and wildlife == 30)
assert(profiles.hunting_ep3_etyyy_walluga.aggroRadius == 24)
assert(profiles.hunting_ep3_etyyy_bantha_kashyyyk_greyclimber.pvpBitmask == ATTACKABLE)
assert(profiles.hunting_ep3_etyyy_sordaan_xris.optionsBitmask == AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING)

ScreenPlay = {new = function(self, child) self.__index = self; return setmetatable(child, self) end}
registerScreenPlay = function() end
AI_STATIONARY, AI_PATROLLING, OBJECTDESTRUCTION, DESTINATIONREACHED = 1, 2, 3, 4
local data, events, objects = {}, {}, {}
local enabled, failed, placed, resolved, serial = false, false, 0, 0, 0
readData = function(key) return data[key] or 0 end
writeData = function(key, value) data[key] = value end
deleteData = function(key) data[key] = nil end
getSceneObject = function(oid) return objects[oid] end
isZoneEnabled = function(zone) assert(zone == "kashyyyk_hunting"); return enabled end
getRandomNumber = function(minimum) return minimum end
getSpawnPointInArea = function(zone, x, y, clearance)
	assert(zone == "kashyyyk_hunting" and clearance == 8)
	if not failed then failed = true; return nil end
	resolved = resolved + 1
	return {x, 22, y}
end
createEvent = function(delay, screenplay, method, mobile, args)
	assert(screenplay == "KashyyykHuntingPopulation")
	if method == "spawnSlot" then events[#events + 1] = {delay, args}
	else assert(method == "walkStep" and mobile) end
end
createObserver = function() end
SceneObject = function(p) return p end
CreatureObject, AiAgent = SceneObject, SceneObject
spawnMobile = function(zone, name, respawn, x, z, y, heading, cell)
	assert(zone == "kashyyyk_hunting" and respawn == 0 and cell == 0 and profiles[name])
	serial = serial + 1
	local mobile = {id = serial, name = name, x = x, z = z, y = y, heading = heading}
	function mobile:getObjectID() return self.id end
	function mobile:getZoneName() return zone end
	function mobile:isAiAgent() return true end
	function mobile:isDead() return self.dead end
	function mobile:isIncapacitated() return false end
	function mobile:setAITemplate() end
	function mobile:setMovementState(state) assert(state == AI_PATROLLING); self.patrol = true end
	function mobile:addObjectFlag(flag) assert(flag == AI_STATIONARY); self.stationary = true end
	objects[serial] = mobile
	placed = placed + 1
	return mobile
end
dofile(kashyyyk .. "kashyyyk_spawn_controller.lua")
dofile(kashyyyk .. "kashyyyk_hunting_data.lua")
dofile(kashyyyk .. "kashyyyk_hunting_population.lua")
local sp, source = KashyyykHuntingPopulation, KashyyykHuntingData
sp:start()
assert(placed == 0 and #events == 0)
enabled = true
sp:start()
sp:start()
assert(placed == 17 and #events == 618)
for index, actor in ipairs(source.actors) do
	local mobile = objects[index]
	assert(mobile.stationary and mobile.name == actor.mobile)
	assert(mobile.x == actor.x and mobile.z == actor.z and mobile.y == actor.y)
end
for _, event in ipairs(events) do sp:spawnSlot(nil, event[2]) end
assert(failed and resolved == 20 and placed == 635 and #events == 619)
for _, controller in ipairs(source.patrols) do
	local mobile = objects[readData(sp:slotKey(controller, 1))]
	local point = controller.points[1]
	assert(mobile.patrol and mobile.x == point[1] and mobile.z == point[2] and mobile.y == point[3])
end
local controller = source.controllers[1]
local original = objects[readData(sp:slotKey(controller, 1))]
original.dead = true
sp:notifyDestroyed(original, nil)
sp:notifyDestroyed(original, nil)
assert(#events == 620 and events[620][1] == controller.respawnMin * 1000 + 2000)
sp:spawnSlot(nil, events[620][2])
assert(placed == 636 and objects[readData(sp:slotKey(controller, 1))] ~= original)
sp:start()
assert(placed == 636 and #events == 620)
print("PASS: Etyyy profiles, named actors, 618 area and patrol slots, location retries, respawn and duplicate prevention")

local hunt = kashyyyk .. "quest/hunt/"
dofile(hunt .. "hunt_manfred_collect_enhancements.lua")
dofile(hunt .. "hunt_tripp_collect_mouf_pelts.lua")
dofile(hunt .. "hunt_tripp_collect_mouf_incisors.lua")
dofile(hunt .. "hunt_loot_named_kills.lua")
local player = {state = {}}
function player:isPlayerCreature() return true end
function player:sendSystemMessage() end
readScreenPlayData = function(p, name, key) return p.state[name .. key] or "" end
writeScreenPlayData = function(p, name, key, value) p.state[name .. key] = value end
deleteScreenPlayData = function(p, name, key) p.state[name .. key] = nil end
KILLEDCREATURE = 5
local collector = huntLootNamedKillsScreenPlay
local wrongTarget = {getCreatureTemplateName = function() return "hunting_ep3_etyyy_mouf" end,
	isAiAgent = function() return true end}
for name, collection in pairs(collector.collections) do
	local quest, task = collection[1], collection[2]
	assert(profiles[name] and quest:grantQuest(player))
	quest:setStage(player, quest.killStage)
	local target = {getCreatureTemplateName = function() return name end, isAiAgent = function() return true end}
	collector:notifyKilledCreature(player, wrongTarget)
	assert(readScreenPlayData(player, quest.screenplayName, "kills") == "")
	for _ = 1, quest.killCount - 1 do collector:notifyKilledCreature(player, target) end
	assert(quest:isTaskActive(player, task))
	collector:notifyKilledCreature(player, target)
	assert(quest:getStage(player) == quest.killStage + 1)
	quest:clearQuest(player)
	assert(readScreenPlayData(player, quest.screenplayName, "kills") == "")
end
assert(#collector.rows == 6)
for _, row in ipairs(collector.rows) do assert(profiles[row.templates[#row.templates]]) end
print("PASS: Etyyy collection progress and named trophy target bindings")

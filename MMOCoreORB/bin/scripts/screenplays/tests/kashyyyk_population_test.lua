-- Standalone population regression test. Run from the repository root with Lua 5.1+.
local root = "MMOCoreORB/bin/scripts/"
-- Use the real Creature inheritance and registration helpers for the new captain.
NONE, AIENABLED, ATTACKABLE, MOB_NPC, NAME_GENERIC_TAG, HERBIVORE = 0, 1, 2, 3, 4, 5
brawlermaster, marksmanmaster, commandomaster, bountyhuntermaster = {}, {}, {}, {}
includeFile = function() end
local registered = {}
addTemplate = function(name, template) registered[name] = template end
dofile(root .. "mobile/creatures.lua")
dofile(root .. "mobile/custom_content/ep3/ep3_wke_cerimonial_guard_01.lua")
dofile(root .. "mobile/custom_content/ep3/ep3_wke_cerimonial_captain.lua")
local guard, captain = registered.ep3_wke_cerimonial_guard_01, registered.ep3_wke_cerimonial_captain
assert(captain.customName == "Ceremonial Captain")
assert(captain.templates[1] == "object/mobile/ep3/ep3_wke_cerimonial_captain.iff")
for field, value in pairs(guard) do
	if (field ~= "__index" and field ~= "customName" and field ~= "templates") then
		assert(captain[field] == value and rawget(captain, field) == nil, "Captain overrides guard profile: " .. field)
	end
end
assert(captain.baseXp == guard.baseXp and captain.lootGroups == guard.lootGroups and #captain.lootGroups == 0)
dofile(root .. "mobile/custom_content/ep3/ep3_wke_commando_01.lua")
local commando = registered.ep3_wke_commando_01
for _, variant in ipairs({"01", "02"}) do
 local name = "ep3_wke_battleleader_" .. variant
 dofile(root .. "mobile/custom_content/ep3/" .. name .. ".lua")
 local leader = assert(registered[name])
 assert(leader.customName == "Wookiee Battle Leader")
 assert(#leader.templates == 1 and leader.templates[1] == "object/mobile/ep3/" .. name .. ".iff")
 for field, value in pairs(commando) do
  if field ~= "__index" and field ~= "customName" and field ~= "templates" then
   assert(leader[field] == value and rawget(leader, field) == nil, "Leader overrides commando profile: " .. field)
  end
 end
end


ScreenPlay = {new = function(self, t) return t end}
registerScreenPlay = function() end
local directorFile = assert(io.open('MMOCoreORB/src/server/zone/managers/director/DirectorManager.cpp', 'r'))
local directorSource = directorFile:read('*a'); directorFile:close()
local flagFile = assert(io.open('MMOCoreORB/src/templates/params/creature/ObjectFlag.h', 'r'))
local flagSource = flagFile:read('*a'); flagFile:close()
for _, name in ipairs({'AI_STATIC', 'AI_STATIONARY'}) do
 local field = assert(string.match(directorSource, 'setGlobalInt%("' .. name .. '",%s*ObjectFlag::([%w_]+)%)'))
 _G[name] = assert(tonumber(assert(string.match(flagSource, '%s' .. field .. '%s*=%s*(0x%x+)'))))
end
assert(STATIC == nil and STATIONARY == nil, 'AI-map constants must not leak into screenplay mocks')

OBJECTDESTRUCTION = 3
local data, objects, events = {}, {}, {}
local enabled, now, oid, born, failSpawn = true, 0, 100, 0, false
local floorCalls, randomSeed = 0, 13
local guardFloors, guardControllers = {}, {}
readData = function(k) return data[k] or 0 end
writeData = function(k, v) data[k] = v end
deleteData = function(k) data[k] = nil end
getSceneObject = function(id) return objects[id] end
isZoneEnabled = function(z) assert(z == 'kashyyyk_main'); return enabled end
getRandomNumber = function(a, b)
 assert(a <= b)
 randomSeed = (randomSeed * 16807) % 2147483647
 return a + (randomSeed % (b - a + 1))
end
getWorldFloor = function(x, y, zone)
 floorCalls = floorCalls + 1; assert(zone == 'kashyyyk_main')
 local height = guardFloors[x .. ':' .. y]
 if height == false then return nil end
 return height or 50
end
createEvent = function(delay, sp, method, p, args)
 assert(delay >= 0 and sp == 'KashyyykMainPopulation' and method == 'spawnSlot' and p == nil)
 events[#events + 1] = {due = now + delay, args = args}
end
-- Keep the wrapper APIs separate so an AiAgent-only call cannot pass on CreatureObject.
local function wrapper(methods)
 return function(p)
  return setmetatable({}, {__index = function(_, name)
   assert(methods[name], "Method unavailable on this Lua wrapper: " .. name)
   return function(_, ...) return p[name](p, ...) end
  end})
 end
end
SceneObject = wrapper({getObjectID = true, isAiAgent = true})
CreatureObject = wrapper({isDead = true, isIncapacitated = true})
AiAgent = wrapper({addObjectFlag = true})
spawnMobile = function(zone, template, respawn, x, z, y, heading, cell)
 assert(zone == 'kashyyyk_main' and respawn == 0 and cell == 0)
 if failSpawn then failSpawn = false; return nil end
 oid = oid + 1; born = born + 1
 local p = {id = oid, template = template, x = x, z = z, y = y, heading = heading}
 function p:getObjectID() return self.id end
 function p:isDead() return self.dead == true end
 function p:isIncapacitated() return self.incapacitated == true end
 function p:isAiAgent() return true end
 function p:addObjectFlag(f) assert(f == AI_STATIONARY or f == AI_STATIC, 'Invalid screenplay flag'); self.flag = f end
 objects[oid] = p
 return p
end
createObserver = function(event, sp, method, p)
 assert(event == OBJECTDESTRUCTION and sp == 'KashyyykMainPopulation' and method == 'notifyDestroyed')
 p.observer = true
end
dofile('MMOCoreORB/bin/scripts/screenplays/kashyyyk/kashyyyk_main_population_data.lua')
dofile('MMOCoreORB/bin/scripts/screenplays/kashyyyk/kashyyyk_main_population.lua')
local sp, source = KashyyykMainPopulation, KashyyykMainPopulationData
local commandos = source.types['kashyyyk/kash_kachirho_wke_commando']
assert(#commandos == 6)
for i, entry in ipairs(commandos) do
 local expected = i <= 2 and 'ep3_npc_wookiee_commando' or (i <= 5 and 'ep3_npc_wookiee_freedom_fighters' or 'ep3_npc_wookiee_battleleader')
 assert(entry.item == expected and entry.clearance == 1)
end
local leaders = commandos[6].mobiles
assert(#leaders == 2 and leaders[1] == 'ep3_wke_battleleader_01' and leaders[2] == 'ep3_wke_battleleader_02')

assert(#source.controllers == 240)
local total, unique, captainIndex = 0, {}, nil
for index, c in ipairs(source.controllers) do
 if c.type == 'kashyyyk/kash_kachirho_wke_ceremonial_guard' then
  assert(c.snapToFloor == true and c.radius == 0 and c.count == 1)
  guardControllers[#guardControllers + 1] = index
  guardFloors[c.x .. ':' .. c.y] = c.z - 3
 else
  assert(c.snapToFloor == nil, 'Other platform heights must remain unchanged')
 end
 if c.type == 'kashyyyk/kash_kachirho_wke_ceremonial_captain' then
  assert(captainIndex == nil, 'Duplicate captain controller'); captainIndex = index
  assert(c.id == -7029960 and c.count == 1 and c.radius == 0 and c.behavior == 1)
  assert(c.x == -54.4 and c.z == 22.4933 and c.y == 839.33)
  assert(c.respawnMin == 120 and c.respawnMax == 240)
 end
 assert(not unique[c.id]); unique[c.id] = true; total = total + c.count
end
assert(total == 579 and #guardControllers == 4)
enabled = false; sp:start(); assert(#events == 0)
assert(captainIndex ~= nil)
local entry = source.types['kashyyyk/kash_kachirho_wke_ceremonial_captain'][1]
assert(entry.item == 'ep3_npc_ceremonial_captain' and #entry.mobiles == 1 and entry.mobiles[1] == 'ep3_wke_cerimonial_captain')
local originalPrint, warnings = print, {}
print = function(message) warnings[#warnings + 1] = message end
enabled = true; sp:start()
print = originalPrint
assert(#warnings == 0, table.concat(warnings, '\n'))
assert(#events == 579, 'Every authored slot must be scheduled')
local firstCaptainEvent
for _, event in ipairs(events) do
 if event.args:match('^' .. captainIndex .. ':1:') then firstCaptainEvent = event end
end
assert(firstCaptainEvent and firstCaptainEvent.due == 20000, 'Captain uses normal startup delay')
local initialEvents = #events
sp:start(); assert(#events == initialEvents, 'Repeated start must not duplicate pending slots')
local function runNext()
 table.sort(events, function(a, b) return a.due < b.due end)
 local event = table.remove(events, 1)
 assert(event)
 now = event.due
 sp:spawnSlot(nil, event.args)
 return event
end
-- Simulate an engine spawn failure and prove bounded retry retains population capacity.
failSpawn = true; local failed = runNext(); assert(born == 0)
local _, _, failedToken = string.match(failed.args, '^(%d+):(%d+):(%d+)$')
local queued = #events; sp:spawnSlot(nil, failed.args); assert(#events == queued and born == 0, 'Stale callback cannot consume a newer retry')
local steps = 0
while #events > 0 do
 runNext(); steps = steps + 1; assert(steps < 10000, 'Retry loop must converge')
end
assert(born == 579)
for _, c in ipairs(source.controllers) do
 for slot = 1, c.count do
  local p = getSceneObject(readData(sp:slotKey(c, slot)))
  assert(p and p.observer and p.heading == c.heading)
  assert(math.abs(p.x - c.x) <= c.radius and math.abs(p.y - c.y) <= c.radius)
  local expectedHeight = c.z
  if c.snapToFloor then expectedHeight = guardFloors[c.x .. ':' .. c.y]
  elseif c.radius > 0 then expectedHeight = 50 end
  assert(p.z == expectedHeight, 'Guard floor or fixed platform height was not respected')
  assert(p.flag == (c.behavior == 1 and AI_STATIONARY or AI_STATIC))
  if c.type == 'kashyyyk/kash_kachirho_wke_ceremonial_captain' then
   assert(p.template == entry.mobiles[1] and p.flag == AI_STATIONARY)
  end
 end
end
assert(floorCalls > 0)
sp:start(); assert(#events == 0 and born == 579, 'Alive population must not be duplicated')
-- Repeated deaths and start calls cannot refill a still-reserved dead slot early.
local c = source.controllers[captainIndex]; local key = sp:slotKey(c, 1); local p = objects[readData(key)]
local delay = readData(p.id .. ':KashyyykMainPopulation:delay')
assert(delay >= 120000 and delay <= 240000)
p.dead = true; local diedAt = now
sp:notifyDestroyed(p, nil); assert(#events == 1 and events[1].due == diedAt + delay + 2000)
sp:notifyDestroyed(p, nil); sp:start(); assert(#events == 1)
local deathEvent = runNext(); assert(born == 580 and readData(key) ~= p.id)
sp:spawnSlot(nil, deathEvent.args); assert(born == 580 and #events == 0)
sp:notifyDestroyed(p, nil); assert(#events == 0, 'Old death event must not replace the new occupant')
-- Destroyed corpse lookup is not required for a pending replacement.
p = objects[readData(key)]; p.incapacitated = true; sp:notifyDestroyed(p, nil); objects[p.id] = nil
sp:start(); assert(#events == 1); runNext(); assert(born == 581)
-- Disabled zone safely drops callback; a subsequent startup schedules the missing slot.
p = objects[readData(key)]; p.dead = true; sp:notifyDestroyed(p, nil)
enabled = false; runNext(); assert(born == 581 and #events == 0)
enabled = true; sp:start(); assert(#events == 1); runNext(); assert(born == 582)
-- Guard replacements resolve the floor again; missing/invalid floor values retry safely.
local guardController = source.controllers[guardControllers[1]]
local guardKey = sp:slotKey(guardController, 1)
local floorKey = guardController.x .. ':' .. guardController.y
local guardMobile = objects[readData(guardKey)]
guardMobile.dead = true; sp:notifyDestroyed(guardMobile, nil)
for _, unavailable in ipairs({false, 0/0}) do
 guardFloors[floorKey] = unavailable
 runNext(); assert(born == 582 and #events == 1, 'Invalid floor must retry without spawning')
end
guardFloors[floorKey] = guardController.z - 4
runNext()
local replacement = objects[readData(guardKey)]
assert(born == 583 and #events == 0 and replacement.id ~= guardMobile.id)
assert(replacement.z == guardFloors[floorKey], 'Respawn must use the current guard floor')
-- Exercise the existing battle-leader row with each appearance on the real respawn path.
local commandoController
for _, controller in ipairs(source.controllers) do
 if controller.type == 'kashyyyk/kash_kachirho_wke_commando' then commandoController = controller; break end
end
local commandoKey = sp:slotKey(assert(commandoController), 1)
for variant = 1, 2 do
 local oldMobile = objects[readData(commandoKey)]
 local previousBorn = born
 oldMobile.dead = true; sp:notifyDestroyed(oldMobile, nil)
 local originalRandom, rolls = getRandomNumber, 0
 getRandomNumber = function(a, b)
  rolls = rolls + 1
  if rolls == 1 then assert(a == 1 and b == #commandos); return 6 end
  if rolls == 2 then assert(a == 1 and b == #leaders); return variant end
  return originalRandom(a, b)
 end
 runNext(); getRandomNumber = originalRandom
 local leader = objects[readData(commandoKey)]
 assert(born == previousBorn + 1 and #events == 0 and leader.id ~= oldMobile.id)
 assert(leader.template == leaders[variant] and leader.flag == AI_STATIC)
 assert(leader.z == 50 and math.abs(leader.x - commandoController.x) <= commandoController.radius)
 assert(math.abs(leader.y - commandoController.y) <= commandoController.radius)
 sp:notifyDestroyed(oldMobile, nil); assert(#events == 0, 'Old occupant must not duplicate a leader')
end
sp:spawnSlot(nil, nil); sp:spawnSlot(nil, 'bad'); sp:spawnSlot(nil, '9999:1:1'); sp:spawnSlot(nil, '1:0:1')
sp:notifyDestroyed(nil, nil)
print('PASS: all 240 controllers / 579 slots, captain/leader identity and inherited profiles, both leader respawns and source row weights, guard floor correction/retries, platform heights, startup/respawn timing, retries, stale events and duplicate prevention')

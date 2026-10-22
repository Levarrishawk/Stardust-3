-- Standalone Lua 5.3+: public Rryatt controller ownership and quest-spawn lifecycle.
local root = "MMOCoreORB/bin/scripts/"
ScreenPlay = {new = function(self, t) return t end}
registerScreenPlay = function() end
AI_STATIONARY, AI_STATIC, AI_PATROLLING = 1, 2, 4
OBJECTDESTRUCTION, DESTINATIONREACHED, ENTEREDAREA, EXITEDAREA = 1, 2, 3, 4
KILLEDCREATURE = 5
local data, objects, events, now, sequence = {}, {}, {}, 0, 100
local enabled, failSpawn, born = true, false, 0
readData = function(k) return data[k] or 0 end
writeData = function(k, v) data[k] = v end
deleteData = function(k) data[k] = nil end
getSceneObject = function(id) return objects[id] end
isZoneEnabled = function(zone) assert(zone == "kashyyyk_rryatt_trail"); return enabled end
local seed = 13
getRandomNumber = function(a, b)
	assert(a <= b and a == math.floor(a) and b == math.floor(b))
	seed = (seed * 16807) % 2147483647
	return a + (seed % (b - a + 1))
end
getWorldFloor = function() error("Rryatt's stacked platforms must retain authored heights") end
SceneObject = function(o) return o end
CreatureObject = function(o) return o end
AiAgent = function(o) return o end
PlayerObject = function(o) return o end
getHashCode = function(key) assert(key == "quest/ep3_kymayrr_rescue_rroot"); return 123 end
local function object(zone)
	sequence = sequence + 1
	local o = {id = sequence, zone = zone, observers = {}}
	function o:getObjectID() return self.id end
	function o:getZoneName() return self.zone end
	function o:isAiAgent() return not self.player end
	function o:isPlayerCreature() return self.player == true end
	function o:isDead() return self.dead == true end
	function o:isIncapacitated() return self.incapacitated == true end
	function o:isInCombat() return self.combat == true end
	function o:getCreatureTemplateName() return self.template end
	function o:sendSystemMessage() end
	function o:getPlayerObject() return self.player and self or nil end
	function o:isJournalQuestActive(crc) assert(crc == 123); return self.quest == true end
	function o:addObjectFlag(f) self.flag = f end
	function o:setAITemplate() self.ai = true end
	function o:setMovementState(state) self.movement = state end
	function o:stopWaiting() end
	function o:setWait(t) assert(t == 0) end
	function o:setNextPosition(x, z, y, parent) self.next = {x, z, y}; assert(parent == 0) end
	function o:executeBehavior() self.walked = (self.walked or 0) + 1 end
	function o:destroyObjectFromWorld() objects[self.id] = nil end
	objects[o.id] = o
	return o
end
spawnMobile = function(zone, template, respawn, x, z, y, heading, cell)
	assert(zone == "kashyyyk_rryatt_trail" and respawn == 0 and cell == 0)
	if failSpawn then failSpawn = false; return nil end
	local o = object(zone)
	o.template, o.x, o.z, o.y, o.heading = template, x, z, y, heading
	born = born + 1
	return o
end
spawnActiveArea = function(zone, template, x, z, y, radius, cell)
	assert(template == "object/active_area.iff" and radius == 100 and cell == 0)
	local o = object(zone); o.x, o.z, o.y = x, z, y
	return o
end
createObserver = function(event, screenplay, method, o)
	assert(o.observers[event] == nil, "Duplicate observer")
	o.observers[event] = {screenplay, method}
end
createEvent = function(delay, screenplay, method, o, args)
	assert(delay >= 0)
	events[#events + 1] = {due = now + delay, screenplay = screenplay, method = method, o = o, args = args}
end
local function advance(untilTime)
	while true do
		local idx
		for i, e in ipairs(events) do
			if e.due <= untilTime and (idx == nil or e.due < events[idx].due) then idx = i end
		end
		if idx == nil then break end
		local e = table.remove(events, idx)
		now = e.due
		_G[e.screenplay][e.method](_G[e.screenplay], e.o, e.args)
	end
	now = untilTime
end
dofile(root .. "screenplays/kashyyyk/kashyyyk_rryatt_population_data.lua")
dofile(root .. "screenplays/kashyyyk/kashyyyk_patrols.lua")
dofile(root .. "screenplays/kashyyyk/kashyyyk_rryatt_population.lua")
dofile(root .. "screenplays/kashyyyk/kashyyyk_rryatt_rroot.lua")
local sp, source = KashyyykRryattPopulation, KashyyykRryattPopulationData
assert(#source.controllers == 230 and #source.patrols == 2)
local counts, slots, types = {}, 0, 0
for _, entries in pairs(source.types) do
	types = types + 1
	for _, entry in ipairs(entries) do assert(source.profiles[entry.mobile] and entry.clearance >= 0) end
end
assert(types == 41)
for _, c in ipairs(source.controllers) do
	assert(counts[c.id] == nil); counts[c.id] = c.count; slots = slots + c.count
	assert(c.radius <= 9 and c.goodLocation == 0)
end
assert(slots == 564)
enabled = false; sp:start(); assert(#events == 0)
enabled = true; sp:start(); assert(#events == 566)
sp:start(); assert(#events == 566, "Startup duplicated pending slots")
advance(9999); assert(born == 0)
advance(10000); assert(born == 2, "Patrol startup must be ten seconds")
advance(19999); assert(born == 2)
advance(10000000); assert(born == 566)
sp:start(); assert(#events == 0 and born == 566)
for i = 1, 232 do
	local c = sp:controllerAt(i)
	for slot = 1, c.count do
		local o = assert(objects[data[sp:slotKey(c, slot)]])
		assert(o.z == c.z and o.heading == c.heading)
		assert(math.abs(o.x - c.x) <= c.radius and math.abs(o.y - c.y) <= c.radius)
		local allowed = false
		for _, e in ipairs(source.types[c.type]) do if e.mobile == o.template then allowed = true end end
		assert(allowed)
		if c.points then
			assert(o.movement == AI_PATROLLING and o.next[1] == c.points[2][1])
		else
			assert(o.flag == (c.behavior == 1 and AI_STATIONARY or AI_STATIC))
		end
	end
end
-- Death reserves just one slot; repeated observers/start cannot shorten its delay.
local c = source.controllers[1]
local key = sp:slotKey(c, 1)
local victim = objects[data[key]]
local delay = data[victim.id .. ":RryattPopulation:delay"]
victim.dead = true; sp:notifyDestroyed(victim); sp:notifyDestroyed(victim)
assert(#events == 1 and events[1].due == now + delay + 2000)
sp:start(); assert(#events == 1)
local staleArgs = events[1].args
sp:spawnSlot(nil, "1:1:999999"); assert(#events == 1)
local before = born
advance(now + delay + 1999); assert(born == before)
advance(now + 1); assert(born == before + 1)
sp:spawnSlot(nil, staleArgs); assert(born == before + 1)
-- A failure retries, and disabling the zone permits a later restart.
victim = objects[data[key]]; victim.dead = true; sp:notifyDestroyed(victim)
failSpawn = true; advance(events[1].due)
assert(born == before + 1 and #events == 1)
enabled = false; advance(events[1].due); assert(#events == 0)
enabled = true; sp:start(); assert(#events == 1)
advance(events[1].due); assert(born == before + 2)
-- Native patrol arrays include the controller, and both loop directions are traversable.
for i, route in ipairs(source.patrols) do
	assert(#route.points == (i == 1 and 5 or 7))
	assert(route.points[1][1] == route.x and route.points[1][3] == route.y)
	local o = objects[data[sp:slotKey(route, 1)]]
	local at = route.points[2]
	assert(o.next[1] == at[1] and o.next[3] == at[3])
	for step = 1, #route.points * 3 do sp:notifyDestinationReached(o) end
	local walked = o.walked; o.combat = true; sp:walkStep(o)
	assert(o.walked == walked); o.combat = false
	advance(now + 10000); assert(o.walked == walked + 1)
end
-- Quest-dependent, single-owner Rroot with stale-event and logout cleanup.
local rroot = KashyyykRryattRroot
rroot:start(); local area = objects[data[rroot.screenplayName .. ":area"]]
assert(area and area.x == -3656.525 and area.z == 130.294 and area.y == 2166.973)
rroot:start(); local count = sequence; assert(objects[area.id] == area)
local player, other = object(sp.zone), object(sp.zone)
player.player, other.player = true, true
rroot:notifyEntered(area, player); assert(data[rroot.screenplayName .. ":mobile"] == nil)
player.quest, other.quest = true, true
rroot:notifyEntered(area, player)
local id = data[rroot.screenplayName .. ":mobile"]
assert(objects[id].heading == 117 and objects[id].flag == AI_STATIONARY)
rroot:notifyEntered(area, other); assert(data[rroot.screenplayName .. ":mobile"] == id)
rroot:notifyExited(area, other); assert(objects[id])
rroot:notifyExited(area, player); assert(objects[id] == nil)
rroot:notifyEntered(area, other)
local nextId = data[rroot.screenplayName .. ":mobile"]
rroot:expire(nil, tostring(id)); assert(objects[nextId], "Stale timeout destroyed a new Rroot")
other.zone = ""; advance(now + 5000); assert(objects[nextId] == nil)
other.zone = sp.zone; rroot:notifyEntered(area, other)
nextId = data[rroot.screenplayName .. ":mobile"]
advance(now + 300000); assert(objects[nextId] == nil and data[rroot.screenplayName .. ":owner"] == nil)
-- Kill credit includes the new identities without widening the authored targets.
local checks = {
	{"rryatt_krepauk_cleanse_feral_wookiees", "rryattKrepaukCleanseFeralWookieesScreenPlay", "ep3_rryatt_feral_wookiee"},
	{"rryatt_krepauk_defeat_katarn", "rryattKrepaukDefeatKatarnScreenPlay", "ep3_rryatt_katarn"},
	{"rryatt_krepauk_kill_elite_minstyngar", "rryattKrepaukEliteMinstyngarScreenPlay", "ep3_rryatt_minstyngar_elite_bloodspiller"},
	{"rryatt_krepauk_defeat_exjedi", "rryattKrepaukDefeatExjediScreenPlay", "ep3_rryatt_crazed_jedi"},
	{"rryatt_krepauk_kill_walluga_smashers", "rryattKrepaukWallugaSmashersScreenPlay", "ep3_rryatt_walluga_smasher"},
	{"rryatt_tressk_kill_deep_woods_poachers", "rryattTresskDeepWoodsPoachersScreenPlay", "ep3_rryatt_deep_woods_poacher"},
	{"rryatt_tressk_kill_gotal_hunters", "rryattTresskGotalHuntersScreenPlay", "ep3_rryatt_gotal_hunter"},
	{"rryatt_tressk_kill_lost_rodian_hunters", "rryattTresskLostRodianHuntersScreenPlay", "ep3_rryatt_lost_rodian_hunter_deranged"},
}
for _, check in ipairs(checks) do
	dofile(root .. "screenplays/kashyyyk/quest/rryatt/" .. check[1] .. ".lua")
	local quest = assert(_G[check[2]], check[2])
	local found = false
	for _, name in ipairs(quest.killTemplates) do if name == "rryatt_native_" .. check[3] then found = true end end
	assert(found)
end
local questData = {}
readScreenPlayData = function(p, sp, key) return questData[p.id .. sp .. key] end
writeScreenPlayData = function(p, sp, key, value) questData[p.id .. sp .. key] = value end
deleteScreenPlayData = function(p, sp, key) questData[p.id .. sp .. key] = nil end
dropObserver = function(event, sp, method, p) p.observers[event] = nil end
local elite = rryattKrepaukEliteMinstyngarScreenPlay
assert(elite:grantQuest(player) and player.observers[KILLEDCREATURE])
elite:attachKillObserver(player) -- Repeated interaction cannot install a second observer.
local target = object(sp.zone)
target.template = "rryatt_native_ep3_rryatt_minstyngar_breeder"
elite:notifyKilledCreature(player, target); assert(elite:getKills(player) == 0)
target.template = "rryatt_native_ep3_rryatt_minstyngar_elite_bloodspiller"
for i = 1, 24 do elite:notifyKilledCreature(player, target) end
assert(elite:getStage(player) == 2 and elite:getKills(player) == 24 and player.observers[KILLEDCREATURE] == nil)
print("PASS: 230/564 area controllers/slots, 2 patrols, bounds/heights, AI, startup/death/retry ownership, native patrol loops, quest credit, Rroot eligibility/ownership/timeout/logout")

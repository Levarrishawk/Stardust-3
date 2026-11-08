-- Standalone Lua 5.3 test. Run from the repository root.
local root = "MMOCoreORB/bin/scripts/screenplays/kashyyyk/"
ScreenPlay = {new = function(self, t) return setmetatable(t, {__index = self}) end}
registerScreenPlay = function() end
AI_STATIONARY, AI_STATIC, AI_PATROLLING = 1, 2, 3
OBJECTDESTRUCTION, DESTINATIONREACHED = 1, 2
local native, merged = "kashyyyk_dead_forest", "kashyyyk"
local enabled, objects, memory, events, spawned, now = {}, {}, {}, {}, {}, 0
isZoneEnabled = function(zone)
	assert(type(zone) == "string", "isZoneEnabled requires a zone name")
	return enabled[zone]
end
readData = function(k) return memory[k] or 0 end
writeData = function(k, v) memory[k] = v end
deleteData = function(k) memory[k] = nil end
getSceneObject = function(id) return objects[id] end
getRandomNumber = function(a, b) assert(a <= b); return a end
SceneObject = function(o) return o end
CreatureObject = SceneObject
AiAgent = SceneObject
BuildingObject = SceneObject
LuaCellObject = SceneObject
createObserver = function(event, sp, method, object)
	assert(not object.observers[event]); object.observers[event] = method
end
createEvent = function(delay, sp, method, object, args)
	events[#events + 1] = {at = now + delay, sp = sp, method = method, object = object, args = args}
end
local function object(id, zone)
	local o = {id = id, zone = zone, observers = {}}
	function o:getObjectID() return self.id end
	function o:getZoneName() return self.zone end
	function o:isDead() return self.dead == true end
	function o:isIncapacitated() return false end
	function o:isInCombat() return false end
	function o:isAiAgent() return true end
	function o:addObjectFlag(flag) self.flag = flag end
	function o:setAITemplate() end
	function o:setMovementState(m) self.movement = m end
	function o:stopWaiting() end
	function o:setWait() end
	function o:setNextPosition(x, z, y) self.next = {x, z, y} end
	function o:executeBehavior() end
	function o:getCreatureTemplateName() return self.template end
	objects[id] = o
	return o
end
spawnMobile = function(zone, name, respawn, x, z, y, heading, cell)
	local o = object(30000000 + #spawned, zone)
	o.template, o.respawn, o.x, o.z, o.y, o.heading, o.cell = name, respawn, x, z, y, heading, cell
	spawned[#spawned + 1] = o
	return o
end
local function makeCave(id, zone)
	local o = object(id, zone)
	function o:isBuildingObject() return true end
	function o:getTemplateObjectPath() return "object/building/kashyyyk/ep3_forest_webweaver.iff" end
	function o:getTotalCellNumber() return 11 end
	function o:getCellName(i) return "r" .. i end
	function o:getCell(i) return objects[id + i] end
	for i = 1, 11 do
		local cell = object(id + i, zone)
		cell.index = i
		function cell:getCellNumber() return self.index end
	end
end
-- Core3 loads screenplays on worker threads without calling start() there.
local worker = setmetatable({}, {__index = _G})
for _, file in ipairs({"kashyyyk_patrols", "kashyyyk_spawn_controller", "kashyyyk_dead_forest_data", "kashyyyk_dead_forest_population"}) do
	assert(loadfile(root .. file .. ".lua", "t", worker))()
end
local function advance(to)
	while true do
		local index
		for i, event in ipairs(events) do
			if (event.at <= to and (index == nil or event.at < events[index].at)) then index = i end
		end
		if (index == nil) then break end
		local e = table.remove(events, index)
		now = e.at
		local screenplay = worker[e.sp]
		screenplay[e.method](screenplay, e.object, e.args)
	end
	now = to
end

dofile(root .. "kashyyyk_patrols.lua")
dofile(root .. "kashyyyk_spawn_controller.lua")
dofile(root .. "kashyyyk_dead_forest_data.lua")
dofile(root .. "kashyyyk_dead_forest_population.lua")
dofile(root .. "kashyyyk_webweaver_population.lua")
local forest, cave, source = KashyyykDeadForestPopulation, KashyyykWebweaverPopulation, KashyyykDeadForestData
forest:start(); cave:start()
assert(#spawned == 0 and #events == 0)
enabled[native], enabled[merged] = true, true
makeCave(14913083, native); makeCave(6292864, merged)
forest:start(); forest:start()
assert(#spawned == 11 and #events == 228)
cave:start(); cave:start()
assert(#spawned == 64)
local vesad
for _, o in ipairs(spawned) do
	assert(o.zone == native)
	if (o.template == "dead_forest_ep3_forest_mother_vesad") then
		assert(vesad == nil)
		vesad = o
	end
end
assert(vesad and vesad.cell == 14913087 and vesad.respawn == 420 and vesad.z == -76.1955)
advance(9999); assert(#spawned == 64)
advance(15000); assert(#spawned == 71)
for _, route in ipairs(source.patrols) do
	for slot = 1, route.count do
		local o = assert(getSceneObject(readData(forest:slotKey(route, slot))))
		assert(o.x == route.points[slot][1] and o.y == route.points[slot][3])
		assert(o.next[1] == route.points[slot + 1][1] and o.next[3] == route.points[slot + 1][3])
	end
end
advance(5000000); assert(#spawned == 292)
forest:start(); cave:start(); assert(#events == 0 and #spawned == 292)
for _, controller in ipairs(source.controllers) do
	local o = assert(getSceneObject(readData(forest:slotKey(controller, 1))))
	assert(o.flag == (controller.behavior == 1 and AI_STATIONARY or nil))
end
local c = source.controllers[1]
local victim = getSceneObject(readData(forest:slotKey(c, 1)))
assert(victim.template == "dead_forest_rebel_trooper")
victim.dead = true
worker.KashyyykDeadForestPopulation:notifyDestroyed(victim)
worker.KashyyykDeadForestPopulation:notifyDestroyed(victim)
assert(#events == 1 and events[1].at - now == c.respawnMin * 1000 + 2000)
advance(events[1].at)
assert(#spawned == 293 and getSceneObject(readData(forest:slotKey(c, 1))) ~= victim)

enabled[native] = false
objects, memory, events, spawned, now = {}, {}, {}, {}, 0
makeCave(6292864, merged)
forest:start(); cave:start(); assert(#spawned == 64)
assert(spawned[1].zone == merged and spawned[1].x == source.npcs[1].x - 1500)
assert(spawned[12].cell >= 6292865 and spawned[12].cell <= 6292875)
advance(20000)
local route = source.patrols[1]
local patrol = assert(getSceneObject(readData(forest:slotKey(route, 1))))
assert(patrol.zone == merged and patrol.x == route.points[1][1] - 1500 and patrol.y == route.points[1][3] + 1500)
assert(patrol.next[1] == route.points[2][1] - 1500 and patrol.next[3] == route.points[2][3] + 1500)
worker.KashyyykDeadForestPopulation:notifyDestinationReached(patrol)
assert(patrol.next[1] == route.points[3][1] - 1500 and patrol.next[3] == route.points[3][3] + 1500)
local ambient = assert(getSceneObject(readData(forest:slotKey(c, 1))))
assert(ambient.zone == merged and ambient.x == c.x - c.radius - 1500 and ambient.y == c.y - c.radius + 1500)

dofile(root .. "quest/forest/forest_rhiek_quest_1.lua")
dofile(root .. "quest/forest/forest_rhiek_quest_3.lua")
assert(forestRhiekQuest1ScreenPlay:isKillTemplate("dead_forest_ep3_forest_webweaver_gravespinner"))
assert(not forestRhiekQuest1ScreenPlay:isKillTemplate("dead_forest_ep3_forest_webweaver_tombsinger"))
assert(forestRhiekQuest3ScreenPlay:isKillTemplate("dead_forest_ep3_forest_mother_vesad"))
assert(not forestRhiekQuest3ScreenPlay:isKillTemplate("webweaver"))
print("PASS: Dead Forest 221 ambient slots, 7 patrol slots, 11 surface NPCs, 53 cave rows, layout and duplicate ownership, respawn and kill targets")

local player = object(42, native)
function player:isPlayerCreature() return true end
function player:sendSystemMessage() end
function player:getWorldPositionX() return 10 end
function player:getWorldPositionY() return 20 end
function player:getWorldPositionZ() return 30 end
local state = {}
readScreenPlayData = function(_, play, key) return state[play .. ":" .. key] end
writeScreenPlayData = function(_, play, key, value) state[play .. ":" .. key] = value end
deleteScreenPlayData = function(_, play, key) state[play .. ":" .. key] = nil end
KILLEDCREATURE = 3
dropObserver = function(event, _, _, o) o.observers[event] = nil end
cancelEvent = function(play, method, o)
	for i = #events, 1, -1 do
		if (events[i].sp == play and events[i].method == method and events[i].object == o) then
			table.remove(events, i)
		end
	end
end
local spawn = spawnMobile
spawnMobile = function(...)
	local o = spawn(...)
	function o:setDefender(defender) self.defender = defender end
	return o
end
events, spawned = {}, {}
now = 0
dofile(root .. "quest/forest/forest_dahlia_epic_4.lua")
local dahlia = forestDahliaEpic4ScreenPlay
assert(dahlia:grantQuest(player) and #events == 2)
dahlia:clearQuest(player)
assert(#events == 0 and dahlia:grantQuest(player))
advance(10000)
assert(#spawned == 5 and spawned[1].template == "dead_forest_ep3_forest_kerritamba_warrior")
advance(120000)
local leader = spawned[6]
assert(#spawned == 6 and leader.template == "dead_forest_ep3_forest_kerritamba_leader" and leader.defender == player)
dahlia:notifyKilledCreature(player, spawned[1])
assert(dahlia:getStage(player) == 1)
dahlia:notifyKilledCreature(player, leader)
assert(dahlia:getStage(player) == 2 and player.observers[KILLEDCREATURE] == nil)

package.preload["screenplays.kashyyyk.quest.kashyyyk_quest_journal"] = function()
	return {sync = function() end, begin = function() end}
end
dofile(root .. "quest/trando/arena_challenge.lua")
dofile(root .. "quest/forest/forest_kerritamba_epic_6.lua")
conv_handler = ScreenPlay
LuaConversationTemplate = SceneObject
LuaConversationScreen = SceneObject
local template = {getScreen = function(_, id) return id end}
local reply = {getScreenID = function() return "s_579" end, cloneScreen = function(o) return o end}
local entries = 0
KashyyykArena = {enter = function(p) assert(p == player); entries = entries + 1 end}
dofile(root .. "quest/trando/conversation/ep3_forest_arena_guard_conv_handler.lua")
local guard = ep3_forest_arena_guard_conv_handler
assert(guard:getInitialScreen(player, nil, template) == "s_581")
guard:runScreenHandlers(template, player, nil, 0, reply)
assert(entries == 0)
dofile(root .. "quest/forest/conversation/ep3_forest_kerritamba_conv_handler.lua")
local chiefReply = {getScreenID = function() return "s_663" end, cloneScreen = function(o) return o end}
ep3_forest_kerritamba_conv_handler:runScreenHandlers(template, player, nil, 0, chiefReply)
assert(forestKerritambaEpic6ScreenPlay:getStage(player) == 1 and arenaChallengeScreenPlay:getStage(player) == 1)
assert(guard:getInitialScreen(player, nil, template) == "s_575")
guard:runScreenHandlers(template, player, nil, 0, reply)
assert(entries == 1)
print("PASS: Dahlia's two ambushes and leader credit, arena guard eligibility and entry")

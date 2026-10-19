-- Standalone regression harness. Run from the repository root with Lua 5.3+.
local root = "MMOCoreORB/bin/scripts/"
package.path = root .. "?.lua;" .. package.path
local objects, shared, pages, spawned = {}, {}, {}, {}
local nextId, enabled = 1000, {}

local function object(o)
	nextId = nextId + 1
	o = o or {}
	o.id = nextId
	objects[o.id] = o
	function o:getObjectID() return self.id end
	function o:getZoneName() return self.zone end
	function o:getParentID() return self.parent or 0 end
	function o:getWorldPositionX() return self.x or 0 end
	function o:getWorldPositionY() return self.y or 0 end
	function o:getWorldPositionZ() return self.z or 0 end
	function o:getTemplateObjectPath() return self.template end
	function o:isPlayerCreature() return self.ghost ~= nil end
	function o:isAiAgent() return self.ghost == nil end
	function o:getPlayerObject() return self.ghost end
	function o:hasSkill(skill) return self.skills[skill] == true end
	function o:isInRangeWithObject(other, range) return self.near ~= false end
	function o:isDead() return self.dead == true end
	function o:isIncapacitated() return self.incapacitated == true end
	function o:isInCombat() return self.combat == true end
	function o:isRidingMount() return self.mounted == true end
	function o:dismount()
		if self.failDismount then return end
		self.mounted, self.parent = false, 0; self.dismounts = (self.dismounts or 0) + 1
	end
	function o:getDistanceTo3d(other)
		return math.sqrt(((self.x or 0) - (other.x or 0))^2 + ((self.z or 0) - (other.z or 0))^2 + ((self.y or 0) - (other.y or 0))^2)
	end
	function o:teleport(x, z, y, parent)
		if (self.failTeleport) then return end
		self.x, self.z, self.y, self.parent = x, z, y, parent
		self.teleports = (self.teleports or 0) + 1
	end
	function o:sendSystemMessage(message) self.message = message end
	function o:playMusicMessage() end
	function o:doAnimation() end
	function o:getSlottedObject() return self.inventory end
	function o:addBankCredits(amount) self.credits = (self.credits or 0) + amount end
	function o:getCreatureTemplateName() return self.template end
	function o:addObjectFlag(flag) self.flag = flag end
	function o:setObjectMenuComponent(component) self.component = component end
	function o:destroyObjectFromWorld() objects[self.id] = nil end
	return o
end

local function player()
	local p = object({zone = "kashyyyk_main", skills = {}, data = {}, inventory = {}})
	p.ghost = {quests = {}, removeSuiBox = function(self, id) pages[id].closed = true end}
	local g = p.ghost
	function g:isJournalQuestActive(key) return self.quests[key] ~= nil and not self.quests[key].done end
	function g:isJournalQuestComplete(key) return self.quests[key] ~= nil and self.quests[key].done == true end
	function g:activateJournalQuest(key)
		assert(self.quests[key] == nil, "Native journal refuses an existing owner")
		self.quests[key] = {active = {[0] = true}, completed = {}, counts = {}}
	end
	function g:clearJournalQuest(key) self.quests[key] = nil end
	function g:completeJournalQuest(key) assert(self:isJournalQuestActive(key)); self.quests[key].done = true end
	function g:isJournalQuestTaskActive(key, id) return self.quests[key] ~= nil and self.quests[key].active[id] == true end
	function g:isJournalQuestTaskComplete(key, id) return self.quests[key] ~= nil and self.quests[key].completed[id] == true end
	function g:activateJournalQuestTask(key, id)
		assert(id >= 0 and id <= 15 and id == math.floor(id), "Native task mask overflow")
		self.quests[key].active[id] = true
	end
	function g:completeJournalQuestTask(key, id)
		assert(self.quests[key].active[id], "Native completion requires an active task")
		self.quests[key].active[id] = nil
		self.quests[key].completed[id] = true
	end
	function g:clearJournalQuestTask(key, id) self.quests[key].active[id] = nil; self.quests[key].completed[id] = nil end
	function g:setQuestCounter() end
	function g:sendQuestTaskCounter(key, id, label, current, max)
		self.quests[key].counts[id] = {current, max}
	end
	return p
end

SceneObject = function(p) assert(p); return p end
-- Enforce native method visibility: CreatureObject and AiAgent are distinct Lua bindings.
local function nativeWrapper(className, sourcePath)
	local file = assert(io.open(sourcePath, "r"))
	local source = file:read("*a"); file:close()
	source = source:gsub("/%*.-%*/", ""):gsub("//[^\n]*", "")
	local register = assert(source:match("Register%[%]%s*=%s*{(.-)};"))
	local methods = {}
	for method in register:gmatch('{%s*"([^"]+)"%s*,') do methods[method] = true end
	assert(next(methods), "Empty native binding " .. className)
	return function(p)
		assert(p)
		return setmetatable({}, {__index = function(self, method)
			if (not methods[method]) then return nil end
			assert(type(p[method]) == "function", "Missing mock for " .. className .. ":" .. method)
			return function(self, ...) return p[method](p, ...) end
		end})
	end
end
CreatureObject = nativeWrapper("CreatureObject", "MMOCoreORB/src/server/zone/objects/creature/LuaCreatureObject.cpp")
AiAgent = nativeWrapper("AiAgent", "MMOCoreORB/src/server/zone/objects/creature/ai/LuaAiAgent.cpp")
PlayerObject = SceneObject
ScreenPlay = {new = function(self, o) return o end}
conv_handler = ScreenPlay
registerScreenPlay, createObserver, dropObserver = function() end, function() end, function() end
printLuaError = function(message) error(message) end
readData = function(key) return shared[key] or 0 end
writeData = function(key, value) shared[key] = value end
deleteData = function(key) shared[key] = nil end
readScreenPlayData = function(p, name, key) return p.data[name .. ":" .. key] or "" end
writeScreenPlayData = function(p, name, key, value) p.data[name .. ":" .. key] = value end
deleteScreenPlayData = function(p, name, key) p.data[name .. ":" .. key] = nil end
writeStringData = writeData
isZoneEnabled = function(zone) return enabled[zone] == true end
getWorldFloor = function() return nil end
getRandomNumber = function(a, b) return b or a end
getSceneObject = function(id) return objects[id] end
giveItem = function() return object() end
KashyyykQuestXp = {award = function(self, p, quest) p.xpAwards = (p.xpAwards or 0) + 1 end}
AI_STATIONARY, KILLEDCREATURE, OBJECTDESTRUCTION, ENTEREDAREA = 1, 2, 3, 4
getHashCode = function(key) return key end
getTimestamp = function() return 1000 end
getContainerObjectByTemplate = function(inventory, template)
	return inventory[template]
end
PROTOTYPECREATED = 5
readStringData = readData
local events = {}
createEvent = function(ms, name, callback, p, arg) table.insert(events, {ms, name, callback, p, arg}) end

spawnMobile = function(zone, template, respawn, x, z, y, heading, parent)
	local p = object({zone = zone, template = template, x = x, z = z, y = y, parent = parent})
	table.insert(spawned, p)
	return p
end
spawnSceneObject = function(zone, template, x, z, y, parent)
	return spawnMobile(zone, template, 0, x, z, y, 0, parent)
end
spawnActiveArea = function(zone, template, x, z, y, radius, parent)
	return object({zone = zone, template = template, x = x, z = z, y = y, parent = parent})
end

LuaConversationTemplate = SceneObject
LuaConversationScreen = SceneObject
ConvoTemplate = {new = function(self, o)
	function o:addScreen(screen) self.screens[screen.id] = screen end
	function o:getScreen(id) return assert(self.screens[id], "Missing screen " .. id) end
	return o
end}
ConvoScreen = {new = function(self, o)
	function o:getScreenID() return self.id end
	function o:cloneScreen() return self end
	function o:removeAllOptions() self.options = {} end
	function o:addOption(label, target) table.insert(self.options, {label, target}) end
	return o
end}
addConversationTemplate = function() end

LuaSuiBoxPage = function(page) return {getSuiPageData = function() return page end} end
LuaSuiPageData = SceneObject
SuiKeypad = {new = function()
	local page, sui = {}, {}
	function page:getPageId() return self.id end
	function page:getTargetNetworkId() return self.target end
	sui.hideSliceButton, sui.hideKeycardButton = function() end, function() end
	sui.setTargetNetworkId = function(id) page.target = id end
	sui.setForceCloseDistance = function() end
	sui.sendTo = function()
		nextId = nextId + 1
		page.id = nextId
		pages[nextId] = page
		return nextId
	end
	return sui
end}

local function load(path) dofile(root .. path) end
local function screenplay(path) load("screenplays/kashyyyk/" .. path .. ".lua") end
local function conversation(name)
	load("mobile/conversations/kashyyyk/trando/" .. name .. "_convo.lua")
	screenplay("quest/trando/conversation/" .. name .. "_conv_handler")
	return _G[name .. "_conv_handler"], _G[name .. "_convo"]
end
local function follow(handler, convo, p, screen, option)
	assert(screen.stopConversation == "false", "Conversation ends at " .. screen.id)
	local nextScreen = convo:getScreen(assert(screen.options[option or 1])[2])
	handler:runScreenHandlers(convo, p, nil, option or 1, nextScreen)
	return nextScreen
end
local function finishDialogue(handler, convo, p, screen)
	for i = 1, 20 do
		if (screen.stopConversation == "true") then return screen end
		screen = follow(handler, convo, p, screen)
	end
	error("Conversation did not finish")
end

screenplay("quest/trando/trando_boshaz_zssik_02")
screenplay("quest/trando/trando_orooroo_zssik_08")
screenplay("quest/trando/trando_harwakokok_zssik_09")
screenplay("quest/trando/trando_mosolium_transfer")
screenplay("quest/trando/trando_orooroo_transfer")
screenplay("quest/trando/trando_mosolium_zssik_05")
local chawroo, chawrooConvo = conversation("ep3_trandoshan_chawroo_zssik_01a")
local harwa, harwaConvo = conversation("ep3_harwakokok_mighty")
local orooroo, oroorooConvo = conversation("ep3_orooroo_betrayer")

local p = player()
assert(chawroo:getInitialScreen(p, nil, chawrooConvo).id == "s_70")
assert(harwa:getInitialScreen(p, nil, harwaConvo).id == "s_122")
assert(orooroo:getInitialScreen(p, nil, oroorooConvo).id == "s_97")
p.skills.combat_smuggler_underworld_01 = true
trandoBoshazZssik02ScreenPlay:setStage(p, 2)
assert(chawroo:getInitialScreen(p, nil, chawrooConvo).id == "s_791")
trandoBoshazZssik02ScreenPlay:setStage(p, 3)
finishDialogue(chawroo, chawrooConvo, p, chawroo:getInitialScreen(p, nil, chawrooConvo))
assert(trandoBoshazZssik02ScreenPlay:getStage(p) == 4)
assert(chawroo:getInitialScreen(p, nil, chawrooConvo).id == "s_747")

-- Enter from the actual transfer conversation; visit Harwakokok and return to Orooroo.
assert(trandoMosoliumTransferScreenPlay:grantQuest(p))
finishDialogue(orooroo, oroorooConvo, p, orooroo:getInitialScreen(p, nil, oroorooConvo))
assert(trandoOroorooZssik08ScreenPlay:getStage(p) == 1)
trandoOroorooZssik08ScreenPlay:setStage(p, 2) -- arrival at the authored Kachirho area
for run = 1, 2 do
	local greeting = harwa:getInitialScreen(p, nil, harwaConvo)
	assert(greeting.id == "s_896")
	finishDialogue(harwa, harwaConvo, p, greeting)
	assert(trandoHarwakokokZssik09ScreenPlay:getStage(p) == 1)
	harwa:runScreenHandlers(harwaConvo, p, nil, 1, harwaConvo:getScreen("s_892"))
	assert(trandoOroorooZssik08ScreenPlay:getStage(p) == 2)
	trandoHarwakokokZssik09ScreenPlay:notifyKilledCreature(p, object({template = "minstyngar"}))
	assert(trandoHarwakokokZssik09ScreenPlay:getStage(p) == 2)
	finishDialogue(harwa, harwaConvo, p, harwa:getInitialScreen(p, nil, harwaConvo))
	assert(trandoOroorooZssik08ScreenPlay:getStage(p) == 3)
	if (run == 1) then trandoOroorooZssik08ScreenPlay:setStage(p, 2) end
end
assert(trandoHarwakokokZssik09ScreenPlay:getRuns(p) == 2)
finishDialogue(orooroo, oroorooConvo, p, orooroo:getInitialScreen(p, nil, oroorooConvo))
assert(trandoOroorooZssik08ScreenPlay:getRuns(p) == 1)
assert(p.credits == 15000) -- existing award retained
local other = player()
other.skills.social_language_wookiee_comprehend = true
assert(chawroo:getInitialScreen(other, nil, chawrooConvo).id == "s_793")

screenplay("quest/missing_son")
assert(kachirhoMissingSonScreenPlay:grantQuest(other))
assert(kachirhoMissingSonScreenPlay:signalTakookTale(other))
kachirhoMissingSonScreenPlay:notifyKilledCreature(other, object({template = "ep3_kachirho_lobarorr"}))
assert(kachirhoMissingSonScreenPlay:getStage(other) == 3)

Creature = ScreenPlay
CreatureTemplates = {addCreatureTemplate = function() end}
NONE, ATTACKABLE, MOB_NPC, AIENABLED, CONVERSABLE, INTERESTING = 0, 1, 1, 1, 2, 4
brawlermaster, marksmanmaster = {}, {}
merge = function() return {} end
load("mobile/custom_content/ep3/ep3_kachirho_lobarorr.lua")
load("mobile/custom_content/ep3/ep3_chawroo.lua")
assert(ep3_kachirho_lobarorr.pvpBitmask == ATTACKABLE)
assert(ep3_chawroo.pvpBitmask == NONE and ep3_chawroo.optionsBitmask == AIENABLED + CONVERSABLE + INTERESTING)
assert(ep3_chawroo.conversationTemplate == "ep3_trandoshan_chawroo_zssik_01a_convo")

screenplay("quest/destroyed_camp")
screenplay("quest/conversation/ep3_kachirho_qst_radio_conv_handler")
local camp = kachirhoDestroyedCampScreenPlay
camp:spawnContainer()
local container = getSceneObject(readData(camp.screenplayName .. ":container"))
local count = #spawned
camp:spawnContainer()
assert(#spawned == count)
assert(container.x == 116.49 and container.z == 7.97043 and container.y == 799.86)
local radioScreen = ConvoScreen:new({id = "s_413"})
camp:setStage(other, 6)
ep3_kachirho_qst_radio_conv_handler:runScreenHandlers(nil, other, nil, 1, radioScreen)
assert(camp:getStage(other) == 7 and camp:getRuns(other) == 0)
local function open()
	camp:openContainer(other, container)
	return pages[readData(camp:containerPageKey(other))]
end
local first = assert(open())
local second = assert(open())
assert(first.closed)
camp:containerKeypadCallback(other, first, 0, "25854", "enter")
assert(camp:getStage(other) == 7)
camp:containerKeypadCallback(other, second, 0, "wrong", "enter")
assert(camp:getStage(other) == 7)
local cancel = assert(open())
camp:containerKeypadCallback(other, cancel, 1, "25854", "enter")
assert(camp:getStage(other) == 7)
local away = assert(open())
other.zone = "tatooine"
camp:containerKeypadCallback(other, away, 0, "25854", "enter")
assert(camp:getStage(other) == 7)
other.zone = "kashyyyk_main"
for _, case in ipairs({{key = "near", value = false}, {key = "dead", value = true},
	{key = "incapacitated", value = true}, {key = "parent", value = 123}}) do
	local page = assert(open())
	other[case.key] = case.value
	camp:containerKeypadCallback(other, page, 0, "25854", "enter")
	assert(camp:getStage(other) == 7)
	other[case.key] = nil
end
local cleared = assert(open())
camp:clearQuest(other)
assert(cleared.closed and readData(camp:containerPageKey(other)) == 0)
camp:containerKeypadCallback(other, cleared, 0, "25854", "enter")
assert(camp:getRuns(other) == 0)
camp:setStage(other, 7)
local success = assert(open())
camp:containerKeypadCallback(other, success, 0, "25854", "enter")
assert(camp:getStage(other) == 0 and camp:getRuns(other) == 1)
camp:containerKeypadCallback(other, success, 0, "25854", "enter")
assert(camp:getRuns(other) == 1 and other.credits == nil)
assert(not camp:canUseContainer(other, container))

screenplay("kashyyyk_static_npcs")
enabled = {kashyyyk_main = true, kashyyyk_hunting = true, kashyyyk_dead_forest = true}
spawned = {}
KashyyykStaticNpcsScreenPlay:start()
assert(#spawned == 73) -- 50 main, 17 hunting, 6 dead forest
local counts = {}
for _, npc in ipairs(spawned) do
	counts[npc.zone] = (counts[npc.zone] or 0) + 1
	assert(npc.flag == AI_STATIONARY)
	if (npc.zone ~= "kashyyyk_main") then assert(math.abs(npc.x) < 2048 and math.abs(npc.y) < 2048) end
end
assert(counts.kashyyyk_main == 50 and counts.kashyyyk_hunting == 17 and counts.kashyyyk_dead_forest == 6)
for _, name in ipairs({"forest_athnalu_quest_1", "forest_meust_quest_1", "forest_kerritamba_epic_1", "forest_perusta_quest_1"}) do
	screenplay("quest/forest/" .. name)
end
local before = #spawned
forestAthnaluQuest1ScreenPlay:start()
forestMeustQuest1ScreenPlay:start()
forestKerritambaEpic1ScreenPlay:start()
forestPerustaQuest1ScreenPlay:start()
assert(#spawned > before + 4) -- four givers and their existing nearby retrieval props
for i = before + 1, #spawned do
	assert(spawned[i].zone == "kashyyyk_dead_forest")
	assert(math.abs(spawned[i].x) < 2048 and math.abs(spawned[i].y) < 2048)
end
enabled = {kashyyyk = true}
spawned = {}
KashyyykStaticNpcsScreenPlay:start()
forestAthnaluQuest1ScreenPlay:start()
forestMeustQuest1ScreenPlay:start()
forestKerritambaEpic1ScreenPlay:start()
forestPerustaQuest1ScreenPlay:start()
assert(#spawned == 0)
print("PASS: Chawroo, Harwakokok/Orooroo dialogue paths, Lobarorr credit, container lifecycle, separated-zone placements")

-- Journal integration: drive real quest handlers against a strict native journal mock.
local Journal = require("managers.quest.journal")
local Mirror = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")
local function journal(p, name) return assert(p.ghost.quests["quest/" .. name]) end
for name in pairs(Mirror.quests) do
	if (_G[name] == nil) then
		-- Screenplay registration is global in the server, so load the same files here.
		local files = {
			rryattTrailMasteryScreenPlay = "rryatt/rryatt_trail_mastery",
			kachirhoKillWkeScreenPlay = "kill_wke", kachirhoVaractylHuntScreenPlay = "varactyl_hunt",
			kachirhoSurveyDataScreenPlay = "survey_data", kachirhoVaractylEggScreenPlay = "varactyl_egg",
			kachirhoTakookCommScreenPlay = "takook_comm", kachirhoTrandoRifleCraftingScreenPlay = "trando_rifle_crafting",
		}
		local path = files[name]
		if (path == nil) then
			path = "trando/" .. name:gsub("ScreenPlay$", ""):gsub("(%l)(%u)", "%1_%2"):gsub("(%a)(%d)", "%1_%2"):lower()
			path = path:gsub("zssik_(%d)", "zssik_%1")
		end
		screenplay("quest/" .. path)
	end
end

-- Every mapped stage can hydrate an existing character, using only supported client tasks.
local mapped = 0
for name, spec in pairs(Mirror.quests) do
	mapped = mapped + 1
	local sp = _G[name]
	for stage = 1, #spec.stages do
		local p = player()
		writeScreenPlayData(p, name, "stage", tostring(stage))
		Mirror.playerLoggedIn(p)
		local q = journal(p, spec.quest)
		assert(not q.done, name .. " completed before reward")
		for previous = 1, stage do
			for _, id in ipairs(spec.stages[previous]) do
				assert((previous < stage and q.completed[id]) or (previous == stage and q.active[id]), name .. " task " .. id)
			end
		end
		local credits, xp = p.credits, p.xpAwards
		Mirror.playerLoggedIn(p)
		assert(p.credits == credits and p.xpAwards == xp)
		Mirror.complete(sp, p)
		assert(q.done and next(q.active) == nil)
		Mirror.clear(sp, p)
		assert(q.done, "Clearing gameplay state discarded completed journal")
		Mirror.begin(sp, p)
		sp:setStage(p, 1)
		q = journal(p, spec.quest)
		assert(not q.done, "Repeat did not reset journal")
		Mirror.clear(sp, p)
		assert(p.ghost.quests["quest/" .. spec.quest] == nil)
	end
end
assert(mapped == 32)

local p = player()
assert(kachirhoKillWkeScreenPlay:grantQuest(p))
local fighter = object({template = "ep3_wke_freedom_fighter_01"})
for i = 1, 14 do kachirhoKillWkeScreenPlay:notifyKilledCreature(p, fighter) end
local q = journal(p, "ep3_kachirho_kill_wke")
assert(q.active[0] and q.counts[0][1] == 14 and q.counts[0][2] == 15 and not q.done)
kachirhoKillWkeScreenPlay:notifyKilledCreature(p, fighter)
assert(q.completed[0] and q.active[1] and not q.done)
assert(kachirhoKillWkeScreenPlay:signalTurnIn(p))
assert(q.done and q.completed[1] and q.completed[2] and p.credits == 15000)
assert(kachirhoKillWkeScreenPlay:grantQuest(p))
assert(journal(p, "ep3_kachirho_kill_wke").counts[0][1] == 0)

local p = player()
assert(kachirhoSurveyDataScreenPlay:grantQuest(p))
assert(kachirhoSurveyDataScreenPlay:collectDevice(p, "d3"))
q = journal(p, "ep3_kachirho_survey_data")
assert(q.completed[3] and q.active[0] and q.active[1] and q.active[2] and q.active[4])
assert(not kachirhoSurveyDataScreenPlay:collectDevice(p, "d3"))
for _, key in ipairs({"d4", "d1", "d0", "d2"}) do assert(kachirhoSurveyDataScreenPlay:collectDevice(p, key)) end
assert(q.active[5] and not q.done)
assert(kachirhoSurveyDataScreenPlay:signalTurnIn(p) and q.done and p.credits == 10000)

-- Only the five actual ambush guards count. Another actor may kill an owner's encounter.
local sp, p, helper = trandoBoshazZssik02ScreenPlay, player(), player()
assert(sp:grantQuest(p))
sp:completeGoto(p)
local guards = {}
for i = 1, 5 do guards[i] = getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "ambush" .. i))) end
local unrelated = object({template = guards[1].template})
sp:notifyKilledCreature(p, unrelated)
sp:notifyKilledCreature(helper, guards[1])
assert((tonumber(readScreenPlayData(p, sp.screenplayName, "kills")) or 0) == 0)
sp:notifyEncounterDestroyed(guards[1], helper)
sp:notifyKilledCreature(p, guards[1])
assert(tonumber(readScreenPlayData(p, sp.screenplayName, "kills")) == 1)
local before = #spawned
sp:spawnAmbush(p)
assert(#spawned == before, "Re-entry duplicated the encounter")
for i = 2, 5 do sp:notifyEncounterDestroyed(guards[i], helper) end
assert(sp:getStage(p) == 3 and journal(p, "ep3_trando_boshaz_zssik_02").active[3])
assert(sp:signalChawrooLifeDebt(p) and sp:signalRewardBoshaz(p) and p.credits == 2000)
assert(journal(p, "ep3_trando_boshaz_zssik_02").done)
assert(sp:grantQuest(p))
sp:completeGoto(p)
sp:notifyKilledCreature(p, guards[2])
assert((tonumber(readScreenPlayData(p, sp.screenplayName, "kills")) or 0) == 0, "Old run credited")
sp:clearQuest(p)

-- All three waves may overlap; their five deaths and journal tasks are independent.
local sp, p = trandoSsiksikScreenPlay, player()
assert(sp:grantQuest(p))
sp:completeGoto(p)
assert(sp:signalStartWookieeAttack(p))
local token = readScreenPlayData(p, sp.screenplayName, "encounterRun")
local oldToken = token
sp:timerWaveOne(p, token)
sp:timerWaveTwo(p, token)
sp:timerWaveThree(p, token)
q = journal(p, "ep3_trando_ssiksik")
assert(q.active[9] and q.active[10] and q.active[6] and not q.done)
local before = #spawned
sp:timerWaveOne(p, token)
assert(#spawned == before)
sp:notifyKilledCreature(p, object({template = "ep3_wke_freedom_fighter_01"}))
for _, wave in ipairs({2, 1, 3}) do
	for i = 1, 5 do
		local mob = getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "wave" .. wave .. "s" .. i)))
		sp:notifyEncounterDestroyed(mob, helper)
		sp:notifyKilledCreature(p, mob)
	end
	assert(tonumber(readScreenPlayData(p, sp.screenplayName, "wave" .. wave .. "kills")) == 5)
end
assert(sp:getStage(p) == 5 and q.active[12] and not q.done)
assert(q.completed[9] and q.completed[10] and q.completed[6])
sp:timerWaveOne(p, token)
assert(sp:getStage(p) == 5)
assert(sp:signalRewardSlaverLeader(p) and q.done and p.credits == 10000)
assert(sp:grantQuest(p))
sp:completeGoto(p)
assert(sp:signalStartWookieeAttack(p))
local before = #spawned
sp:timerWaveOne(p, oldToken)
assert(#spawned == before, "An old timer spawned in the next run")

local sp, p = slaverGursanEntryQuestScreenPlay, player()
assert(sp:grantQuest(p) and sp:signalSlaverEnterGate(p))
local beshk = getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "beshkOid")))
sp:notifyKilledCreature(p, object({template = beshk.template}))
assert(sp:getStage(p) == 2)
sp:notifyEncounterDestroyed(beshk, helper)
sp:notifyKilledCreature(p, beshk)
assert(sp:getStage(p) == 3 and journal(p, "ep3_slaver_gursan_entry_quest").active[10])
assert(sp:signalSlaverCampEntered(p) and journal(p, "ep3_slaver_gursan_entry_quest").done)
print("Kashyyyk journal (32 quests) and encounter credit regression checks passed")

-- Craft journal advances only for a real bowcaster prototype; inventory still gates rewards.
local sp, p = kachirhoTrandoRifleCraftingScreenPlay, player()
assert(sp:grantQuest(p) and sp:signalQuestionLolo(p))
local q = journal(p, "ep3_kachirho_trando_rifle_crafting")
assert(q.completed[4] and q.active[6] and not q.active[5])
sp:notifyBowcasterCrafted(p, object({template = sp.bowcasterTemplate}), 1)
sp:notifyBowcasterCrafted(p, object({template = "another_weapon"}), 0)
assert(q.active[6] and not q.active[5])
sp:notifyBowcasterCrafted(p, object({template = sp.bowcasterTemplate}), 0)
assert(q.completed[6] and q.active[5] and not q.done)
assert(not sp:signalTurnIn(p))
local item = object({template = sp.bowcasterTemplate})
function item:destroyObjectFromDatabase() end
p.inventory[sp.bowcasterTemplate] = item
assert(sp:signalTurnIn(p) and q.done)

-- Restore old active ambushes and missing transient spawns without erasing credited kills.
local sp, p = trandoBoshazZssik02ScreenPlay, player()
sp:setStage(p, 2)
writeScreenPlayData(p, sp.screenplayName, "kills", "2")
local before = #spawned
sp:playerLoggedIn(p)
assert(#spawned == before + 3)
for i = 3, 5 do
	local mob = getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "ambush" .. i)))
	sp:notifyEncounterDestroyed(mob, helper)
end
assert(sp:getStage(p) == 3)

local sp, p = trandoSsiksikScreenPlay, player()
assert(sp:grantQuest(p)); sp:completeGoto(p); assert(sp:signalStartWookieeAttack(p))
local token = readScreenPlayData(p, sp.screenplayName, "encounterRun")
sp:timerWaveOne(p, token)
-- Credit the LAST slot to verify restart restoration does not consume an extra early slot.
local mob = getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "wave1s5")))
sp:notifyEncounterDestroyed(mob, helper)
for i = 1, 4 do
	objects[tonumber(readScreenPlayData(p, sp.screenplayName, "wave1s" .. i))] = nil
end
local before = #spawned
sp:playerLoggedIn(p)
assert(#spawned == before + 4)
assert(tonumber(readScreenPlayData(p, sp.screenplayName, "wave1kills")) == 1)
assert(readScreenPlayData(p, sp.screenplayName, "wave1s5") == "-1")
for i = 1, 4 do
	sp:notifyEncounterDestroyed(getSceneObject(tonumber(readScreenPlayData(p, sp.screenplayName, "wave1s" .. i))), helper)
end
assert(readScreenPlayData(p, sp.screenplayName, "wave1") == "1")
local before = #spawned
sp:timerWaveTwo(p, token)
assert(#spawned == before, "Pre-login timer was still accepted")
print("PASS: crafting journal, legacy ambush recovery, wave restart recovery")

-- Simultaneous players cannot credit one another's encounter by using the same template.
local sp, a, b = trandoBoshazZssik02ScreenPlay, player(), player()
assert(sp:grantQuest(a) and sp:grantQuest(b))
sp:completeGoto(a); sp:completeGoto(b)
local mob = getSceneObject(tonumber(readScreenPlayData(a, sp.screenplayName, "ambush1")))
sp:notifyKilledCreature(b, mob)
assert((tonumber(readScreenPlayData(b, sp.screenplayName, "kills")) or 0) == 0)
sp:notifyKilledCreature(a, mob)
sp:notifyEncounterDestroyed(mob, b)
assert(tonumber(readScreenPlayData(a, sp.screenplayName, "kills")) == 1)
sp:clearQuest(a)
sp:notifyEncounterDestroyed(getSceneObject(tonumber(readScreenPlayData(b, sp.screenplayName, "ambush1"))), a)
assert(tonumber(readScreenPlayData(b, sp.screenplayName, "kills")) == 1)

-- Exercise the real login hook, including missing journals on pre-existing characters.
ServerEventAutomation, BestineElection, MissionJournal, ElysiumGuardian = {}, {}, {}, {}
for _, system in ipairs({ServerEventAutomation, BestineElection, ElysiumGuardian}) do system.playerLoggedIn = function() end end
MissionJournal.onPlayerLoggedIn = function() end
load("screenplays/playerTriggers.lua")
local p = player()
writeScreenPlayData(p, "kachirhoMissingSonScreenPlay", "stage", "3")
PlayerTriggers:playerLoggedIn(p)
local q = journal(p, "ep3_kachirho_missing_son")
assert(q.completed[0] and q.completed[2] and q.active[3] and not q.done)
PlayerTriggers:playerLoggedIn(p)
assert(q == journal(p, "ep3_kachirho_missing_son") and not q.done)
assert(kachirhoMissingSonScreenPlay:signalTurnIn(p) and q.done and p.credits == 2500)
print("PASS: concurrent encounter owners, duplicate callback ordering, real player login hook")

-- Rryatt: use real NPC placements, both conversation trees, mastery flags and the login hook.
screenplay("kashyyyk_rryatt_npcs")
screenplay("quest/rryatt/conversation/rryatt_trail_guide_conv_handler")
screenplay("quest/rryatt/conversation/ep3_achonnko_conv_handler")
load("mobile/conversations/kashyyyk/rryatt/rryatt_trail_guide_convo.lua")
load("mobile/conversations/kashyyyk/rryatt/rryatt_trail_guide_up_convo.lua")
load("mobile/conversations/kashyyyk/rryatt/ep3_achonnko_convo.lua")
load("mobile/custom_content/ep3/ep3_achonnko.lua")
assert(ep3_achonnko.customName == "Achonnko the Trail Master" and ep3_achonnko.conversationTemplate == "ep3_achonnko_convo")
for _, spelling in ipairs({"guide_f", "guild_f", "guide_m"}) do
	for level = 1, 4 do
		local name = "ep3_rryatt_trail_" .. spelling .. "_0" .. level
		load("mobile/custom_content/ep3/" .. name .. ".lua")
		local expected = spelling == "guide_m" and "rryatt_trail_guide_up_convo" or "rryatt_trail_guide_convo"
		assert(_G[name].conversationTemplate == expected and _G[name].optionsBitmask == AIENABLED + CONVERSABLE + INTERESTING)
	end
end
local rryatt, mastery = KashyyykRryattNpcs, rryattTrailMasteryScreenPlay
local bindingProbe = object()
assert(not pcall(function() CreatureObject(bindingProbe):addObjectFlag(AI_STATIONARY) end),
	"CreatureObject mock incorrectly exposes AiAgent-only methods")
AiAgent(bindingProbe):addObjectFlag(AI_STATIONARY)
assert(bindingProbe.flag == AI_STATIONARY)
local function rryattNpc(template)
	for i, entry in ipairs(rryatt.npcs) do
		if (entry[1] == template) then return assert(getSceneObject(readData(rryatt.screenplayName .. ":npc:" .. i))), entry end
	end
	error("Unspawned Rryatt actor " .. template)
end
local function beside(p, npc)
	p.zone, p.x, p.z, p.y, p.parent = npc.zone, npc.x, npc.z, npc.y, 0
end
local function close(a, b) assert(math.abs(a - b) < 0.01, tostring(a) .. " differs from " .. tostring(b)) end
local before = #spawned
rryatt:start()
assert(#spawned == before, "Disabled zone spawned NPCs")
enabled.kashyyyk_rryatt_trail = true
rryatt:start()
assert(#spawned == before + 15)
rryatt:start()
assert(#spawned == before + 15, "Restart duplicated static NPCs")
local actors = {}
for i, entry in ipairs(rryatt.npcs) do
	local npc = rryattNpc(entry[1])
	actors[entry[1]] = npc
	assert(npc.flag == AI_STATIONARY)
	if (entry.zoneLine) then
		assert(readStringData(npc.id .. ":zoneLine") == entry.zoneLine)
		assert(readStringData(npc.id .. ":startingLocation") == entry.startingLocation)
	end
end
-- Both female-template spellings keep the same owned NPC and conversation role.
for _, entry in ipairs(rryatt.npcs) do
	local legacy = entry[1]:gsub("_guide_f_", "_guild_f_")
	if (legacy ~= entry[1]) then
		local npc = actors[entry[1]]
		npc.template = legacy
		deleteData(rryatt.screenplayName .. ":index:" .. npc.id)
		assert(rryatt:getNpc(npc) == entry, "Registered legacy guide lost its dialogue role")
		local listener = player(); beside(listener, npc)
		assert(rryatt_trail_guide_conv_handler:getInitialScreen(listener, npc, rryatt_trail_guide_convo).id == "s_61")
		npc.template = entry[1]
	end
end
local unowned = object({zone = rryatt.zoneName, template = "ep3_rryatt_trail_guide_f_01"})
writeData(rryatt.screenplayName .. ":index:" .. unowned.id, 7)
assert(rryatt:getNpc(unowned) == nil, "Unregistered guide gained a travel role")
local achonnko, p = rryattNpc("ep3_achonnko"), player()
beside(p, achonnko)
local handler, convo = ep3_achonnko_conv_handler, ep3_achonnko_convo
assert(handler:getInitialScreen(p, achonnko, convo).id == "s_169")
handler:runScreenHandlers(convo, p, achonnko, 0, convo:getScreen("s_169"))
assert(p.message == "@ep3/sidequests:wke_convo_failure")
assert(mastery:getStage(p) == 0 and p.ghost.quests["quest/ep3_rryatt_trail_mastery"] == nil)
-- Understanding Shyriiwook unlocks the same offer as the existing smuggler exception.
p.skills.social_language_wookiee_comprehend = true
assert(handler:getInitialScreen(p, achonnko, convo).id == "s_171")
p.skills.social_language_wookiee_comprehend = nil
handler:runScreenHandlers(convo, p, achonnko, 1, convo:getScreen("s_183"))
assert(mastery:getStage(p) == 0, "Forged accept bypassed language")
p.skills.combat_smuggler_underworld_01 = true
assert(handler:getInitialScreen(p, achonnko, convo).id == "s_171")
local screen = handler:getInitialScreen(p, achonnko, convo)
while screen.stopConversation ~= "true" do
	screen = convo:getScreen(screen.options[1][2])
	handler:runScreenHandlers(convo, p, achonnko, 1, screen)
end
assert(mastery:getStage(p) == 1)
local q = journal(p, "ep3_rryatt_trail_mastery")
assert(q.completed[0] and q.active[1] and q.active[2] and q.active[3] and q.active[4] and q.active[5])
assert(not rryatt:travel(p, achonnko, true, 1), "Locked mastery warp accepted")
assert(not rryatt:travel(p, achonnko, true, 0))
assert(not rryatt:travel(p, achonnko, true, 1.5))
assert(not mastery:signalLevel(p, 0) and not mastery:signalLevel(p, 1.5) and not mastery:hasLevel(p, 5))

-- Expected landing coordinates are independently calculated from DSRC offsets and verified snapshot origins.
local down = {
	{"ep3_rryatt_trail_guide_f_01", -2949.251, 69.405, 4256.97},
	{"ep3_rryatt_trail_guide_f_02", -1839.67, 182.3, 3004.16},
	{"ep3_rryatt_trail_guide_f_03", -3590.499, 142.038, 2911.8},
	{"ep3_rryatt_trail_guide_f_04", -1876.03, -23.653, 2360.039},
}
local up = {
	{"ep3_rryatt_trail_guide_m_01", -3155.343185, 115.620025, 4021.710658},
	{"ep3_rryatt_trail_guide_m_02", -2719.16, 121.824, 4210.84},
	{"ep3_rryatt_trail_guide_m_03", -1295.582, 186, 4061.839},
	{"ep3_rryatt_trail_guide_m_04", -2597.01, 142.5994, 2906.039},
}
local guide = rryatt_trail_guide_conv_handler
local indices = {2, 3, 4, 5}
for level, destination in ipairs(down) do
	local npc = actors[destination[1]]
	beside(p, npc)
	assert(guide:getInitialScreen(p, npc, rryatt_trail_guide_convo).id == "s_61")
	if (level == 1) then
		-- Report a server/client height mismatch without bypassing travel eligibility.
		local messages, oldPrint = {}, print
		print = function(message) messages[#messages + 1] = message end
		p.z = npc.z - 30
		local rejected = guide:getInitialScreen(p, npc, rryatt_trail_guide_convo)
		print = oldPrint
		assert(rejected == nil and not rryatt:travel(p, npc, false))
		assert(messages[1]:find("player=(x=", 1, true) and messages[1]:find(" guide=(x=", 1, true))
		assert(messages[1]:find("expectedGuide=(x=", 1, true))
		assert(messages[2]:find("tree100000109=missing", 1, true) and messages[2]:find("hut100000111=missing", 1, true))
		beside(p, npc)
		-- Same-screen retries, stale callbacks, nil/unregistered actors and invalid player states give no credit.
		for _, case in ipairs({{"dead", true}, {"incapacitated", true}, {"combat", true}, {"parent", 9}, {"zone", "tatooine"}, {"failTeleport", true}}) do
			local old = p[case[1]]; p[case[1]] = case[2]
			assert(not rryatt:travel(p, npc, false))
			assert(mastery:levelCount(p) == 0)
			p[case[1]] = old
		end
		p.x = p.x + 7
		assert(not rryatt:travel(p, npc, false))
		beside(p, npc)
		assert(not rryatt:travel(p, object({zone = npc.zone, template = npc.template}), false))
		assert(not rryatt:travel(nil, npc, false) and not rryatt:travel(p, nil, false))
		p.mounted, p.parent, p.failDismount = true, 1234, true
		assert(not rryatt:travel(p, npc, false), "Failed dismount still teleported")
		assert(mastery:levelCount(p) == 0)
		p.failDismount = nil
	end
	guide:runScreenHandlers(rryatt_trail_guide_convo, p, npc, 1, rryatt_trail_guide_convo:getScreen("s_65"))
	close(p.x, destination[2]); close(p.z, destination[3]); close(p.y, destination[4])
	assert(q.completed[indices[level]])
	assert(not rryatt:travel(p, npc, false), "Stale screen teleported again")
	if (level < 4) then
		assert(mastery:levelCount(p) == level and not q.done and p.xpAwards == nil)
		local stranger = player()
		assert(not mastery:hasLevel(stranger, level))
	end
	local ascending = actors[up[level][1]]
	beside(p, ascending)
	assert(guide:getInitialScreen(p, ascending, rryatt_trail_guide_up_convo).id == "s_86")
	local count, runs, xp = mastery:levelCount(p), mastery:getRuns(p), p.xpAwards
	guide:runScreenHandlers(rryatt_trail_guide_up_convo, p, ascending, 1, rryatt_trail_guide_up_convo:getScreen("s_90"))
	close(p.x, up[level][2]); close(p.z, up[level][3]); close(p.y, up[level][4])
	assert(mastery:levelCount(p) == count and mastery:getRuns(p) == runs and p.xpAwards == xp)
end
assert(p.dismounts == 1 and not p.mounted)
assert(mastery:isComplete(p) and mastery:getRuns(p) == 1 and p.xpAwards == 1 and p.credits == nil and q.done)
assert(q.completed[1] and next(q.active) == nil)

local warps = {{-2955.1,69.417,4257.29},{-1840.1,182.317,3004.09},{-3592.4,140.117,2911.29},{-1876.1,-23.583,2358.29}}
local screens = {"s_189", "s_193", "s_197", "s_201"}
for level = 1, 4 do
	beside(p, achonnko)
	local menu = handler:runScreenHandlers(convo, p, achonnko, 1, convo:getScreen("s_185"))
	assert(#menu.options == 5)
	handler:runScreenHandlers(convo, p, achonnko, 1, convo:getScreen(screens[level]))
	close(p.x, warps[level][1]); close(p.z, warps[level][2]); close(p.y, warps[level][3])
	assert(p.xpAwards == 1 and mastery:getRuns(p) == 1)
end

-- Every guide's return option lands near the original public entry controller and gives no mastery credit.
for _, route in ipairs({down, up}) do
	for _, destination in ipairs(route) do
		local npc = actors[destination[1]]
		local p = player(); beside(p, npc)
		assert(mastery:grantQuest(p))
		local convo = route == up and rryatt_trail_guide_up_convo or rryatt_trail_guide_convo
		local screen = route == up and "s_94" or "s_69"
		guide:runScreenHandlers(convo, p, npc, 2, convo:getScreen(screen))
		assert(p.x > -3785 and p.x < -3770 and p.y > 3600 and p.y < 3620 and p.z > 167 and p.z < 172)
		assert(mastery:levelCount(p) == 0 and mastery:getRuns(p) == 0)
	end
end

-- Existing flags hydrate on relog; completion and unlocked travel survive Lua/server restart.
local p = player()
writeScreenPlayData(p, mastery.screenplayName, "stage", "1")
writeScreenPlayData(p, mastery.screenplayName, "l2", "1")
writeScreenPlayData(p, mastery.screenplayName, "l4", "1")
-- Seed the old XML-ID journal masks and verify migration preserves persistent travel flags.
p.ghost:activateJournalQuest("quest/ep3_rryatt_trail_mastery")
q = journal(p, "ep3_rryatt_trail_mastery")
q.active[14], q.active[12], q.completed[13], q.completed[11] = true, true, true, true
PlayerTriggers:playerLoggedIn(p)
q = journal(p, "ep3_rryatt_trail_mastery")
assert(q.completed[3] and q.completed[5] and q.active[2] and q.active[4])
for id = 11, 14 do assert(q.active[id] == nil and q.completed[id] == nil) end
assert(mastery:getRuns(p) == 0 and mastery:levelCount(p) == 2 and p.xpAwards == nil)
PlayerTriggers:playerLoggedIn(p)
assert(mastery:levelCount(p) == 2 and p.xpAwards == nil)
screenplay("quest/rryatt/rryatt_trail_mastery")
assert(rryattTrailMasteryScreenPlay:hasLevel(p, 2) and not rryattTrailMasteryScreenPlay:hasLevel(p, 1))
assert(rryattTrailMasteryScreenPlay:signalLevel(p, 1))
assert(rryattTrailMasteryScreenPlay:signalLevel(p, 3))
assert(p.xpAwards == 1 and q.done)
assert(not rryattTrailMasteryScreenPlay:signalLevel(p, 3))
-- Completed legacy entries migrate once without replaying the completion award.
q.completed[2], q.completed[3], q.completed[4], q.completed[5] = nil, nil, nil, nil
for id = 11, 14 do q.completed[id] = true end
PlayerTriggers:playerLoggedIn(p)
q = journal(p, "ep3_rryatt_trail_mastery")
assert(q.done and q.completed[2] and q.completed[3] and q.completed[4] and q.completed[5])
for id = 11, 14 do assert(q.active[id] == nil and q.completed[id] == nil) end
assert(rryattTrailMasteryScreenPlay:getStage(p) == 0 and rryattTrailMasteryScreenPlay:getRuns(p) == 1 and p.xpAwards == 1)
PlayerTriggers:playerLoggedIn(p)
assert(q == journal(p, "ep3_rryatt_trail_mastery") and q.done and p.xpAwards == 1)
assert(rryattTrailMasteryScreenPlay:grantQuest(p))
assert(rryattTrailMasteryScreenPlay:hasLevel(p, 1), "A repeat erased permanent travel access")
rryattTrailMasteryScreenPlay:clearQuest(p)
assert(p.xpAwards == 1)
print("PASS: all 15 Rryatt NPCs, eight guide routes/returns, four mastery warps, compiled journal task IDs, legacy migration and persistence")

-- Retry a single failed static spawn without duplicating the other fourteen actors.
local missing = actors.ep3_carl_mosik
objects[missing.id] = nil
local realSpawnMobile = spawnMobile
spawnMobile = function(zone, template, ...)
	if template == "ep3_carl_mosik" then return nil end
	return realSpawnMobile(zone, template, ...)
end
local before = #spawned
assert(not rryatt:spawnNpcs() and #spawned == before)
spawnMobile = realSpawnMobile
assert(rryatt:spawnNpcs() and #spawned == before + 1)
assert(rryatt:getNpc(missing) == nil)
print("PASS: failed-spawn retry and stale NPC rejection")

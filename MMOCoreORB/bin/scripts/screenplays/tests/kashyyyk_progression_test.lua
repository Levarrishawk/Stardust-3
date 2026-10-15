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
CreatureObject, PlayerObject, AiAgent = SceneObject, SceneObject, SceneObject
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
NONE, ATTACKABLE, MOB_NPC, AIENABLED, CONVERSABLE = 0, 1, 1, 1, 2
brawlermaster, marksmanmaster = {}, {}
merge = function() return {} end
load("mobile/custom_content/ep3/ep3_kachirho_lobarorr.lua")
load("mobile/custom_content/ep3/ep3_chawroo.lua")
assert(ep3_kachirho_lobarorr.pvpBitmask == ATTACKABLE)
assert(ep3_chawroo.pvpBitmask == NONE and ep3_chawroo.optionsBitmask == AIENABLED + CONVERSABLE)
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
assert(mapped == 31)

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
print("Kashyyyk journal (31 quests) and encounter credit regression checks passed")

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

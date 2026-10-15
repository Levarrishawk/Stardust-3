-- Standalone regression harness. Run from the repository root with Lua 5.3+.
local root = "MMOCoreORB/bin/scripts/"
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
	p.ghost = {removeSuiBox = function(self, id) pages[id].closed = true end}
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
AI_STATIONARY, KILLEDCREATURE = 1, 2

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

-- Standalone regression harness. Run from the repository root with Lua 5.3+.
local root = "MMOCoreORB/bin/scripts/"
package.path = root .. "?.lua;" .. package.path
local objects, transient, nextID, pages = {}, {}, 1000, {}
local awards, failItem = {}, false

local function object(fields)
	nextID = nextID + 1
	local o = fields or {}
	o.id = nextID
	objects[o.id] = o
	function o:getObjectID() return self.id end
	function o:getZoneName() return self.zone end
	function o:getParentID() return self.parent and self.parent.id or self.parentID or 0 end
	function o:getTemplateObjectPath() return self.path end
	function o:getSlottedObject(slot) return self[slot] end
	function o:getPlayerObject() return self.ghost end
	function o:isImperial() return self.imperial or false end
	function o:isDead() return self.dead or false end
	function o:isInCombat() return self.combat or false end
	function o:isInRangeWithObject(target, range) return self.inRange ~= false end
	function o:isContainerFullRecursive() return self.full or false end
	function o:isASubChildOf(parent) return self.parent == parent end
	function o:setCustomObjectName(name) self.name = name end
	function o:sendSystemMessage(message) self.message = message end
	function o:destroyObjectFromWorld() self.parent = nil end
	function o:destroyObjectFromDatabase() objects[self.id] = nil end
	return o
end

local function player()
	local p = object({zone = "lok", data = {}})
	p.inventory = object()
	p.ghost = {journal = {}, waypoints = {}}
	local g = p.ghost
	function g:isJournalQuestActive(crc) return self.journal[crc] ~= nil and not self.journal[crc].done end
	function g:isJournalQuestComplete(crc) return self.journal[crc] ~= nil and self.journal[crc].done end
	function g:isJournalQuestTaskActive(crc, n) return self.journal[crc].active[n] or false end
	function g:isJournalQuestTaskComplete(crc, n) return self.journal[crc].complete[n] or false end
	function g:activateJournalQuest(crc) self.journal[crc] = {active = {[0] = true}, complete = {}} end
	function g:activateJournalQuestTask(crc, n) self.journal[crc].active[n] = true end
	function g:completeJournalQuestTask(crc, n)
		assert(self.journal[crc].active[n])
		self.journal[crc].active[n] = nil
		self.journal[crc].complete[n] = true
	end
	function g:completeJournalQuest(crc) self.journal[crc].done = true end
	function g:removeWaypointBySpecialType(crc) self.waypoints[crc] = nil end
	function g:addWaypoint(planet, name, desc, x, z, y, color, active, notify, crc)
		self.waypoints[crc] = planet
		return 1
	end
	function g:removeSuiBox(id) pages[id].closed = true end
	return p
end

SceneObject = function(p) assert(p); return p end
CreatureObject = SceneObject
PlayerObject = SceneObject
ScreenPlay = {new = function(self, o) return o end}
conv_handler = ScreenPlay
registerScreenPlay = function() end
includeFile = function(path) dofile(root .. "screenplays/" .. path) end
getSceneObject = function(id) return objects[id] end
readData = function(key) return transient[key] or 0 end
writeData = function(key, value) transient[key] = value end
deleteData = function(key) transient[key] = nil end
readScreenPlayData = function(p, name, key) return p.data[name .. key] or "" end
writeScreenPlayData = function(p, name, key, value) p.data[name .. key] = value end
getHashCode = function(key) assert(key == "quest/incom_xwing_plans"); return 3646283336 end
WAYPOINT_YELLOW = 1
giveItem = function(inventory, path)
	if failItem then return nil end
	local item = object({path = path, parent = inventory})
	awards[path] = (awards[path] or 0) + 1
	return item
end
SuiMessageBox = {new = function()
	local page = {}
	function page:getPageId() return self.id end
	function page:getTargetNetworkId() return self.target end
	local sui = {}
	for _, name in ipairs({"setTitle", "setPrompt", "setOkButtonText", "setCancelButtonText", "setForceCloseDistance"}) do
		sui[name] = function() end
	end
	sui.setTargetNetworkId = function(id) page.target = id end
	sui.sendTo = function()
		nextID = nextID + 1
		page.id = nextID
		pages[page.id] = page
		return page.id
	end
	return sui
end}
LuaSuiPageData = SceneObject
LuaSuiBoxPage = function(page) return {getSuiPageData = function() return page end} end

dofile(root .. "screenplays/quests/incom_xwing_plans.lua")
local q = IncomXwingPlans
local npc = object({zone = "lok"})
writeData("IncomXwingPlans:npc", npc.id)
local terminal = object({zone = "corellia", parentID = q.terminalCell})
writeData("IncomXwingPlans:terminal", terminal.id)
local p, other = player(), player()
assert(q:accept(p, npc))
assert(not q:accept(p, npc))
assert(q:getStage(other) == 0)
other.imperial = true
assert(not q:accept(other, npc))
other.imperial = false
assert(q:accept(other, npc))

local function open(who)
	who.zone, who.parentID = "corellia", q.terminalCell
	q:openTerminal(who, terminal)
	return pages[readData(who.id .. ":IncomXwingPlans:sui")]
end
local function download(who)
	q:downloadCallback(who, open(who), 0)
end

local first = open(p)
local second = open(p)
assert(first.closed)
q:downloadCallback(p, first, 0)
assert(q:getPlans(p) == nil)
q:downloadCallback(p, second, 1)
assert(q:getPlans(p) == nil)

for _, change in ipairs({"zone", "parentID", "inRange", "combat", "dead", "imperial"}) do
	local page = open(p)
	local old = p[change]
	p[change] = ({zone = "lok", parentID = 0, inRange = false, combat = true, dead = true, imperial = true})[change]
	q:downloadCallback(p, page, 0)
	assert(q:getPlans(p) == nil, change)
	p[change] = old
end

p.inventory.full = true
download(p)
assert(q:getStage(p) == 1 and q:getPlans(p) == nil)
p.inventory.full = false
failItem = true
download(p)
assert(q:getStage(p) == 1)
failItem = false
download(p)
local disk = q:getPlans(p)
assert(disk.name == "X-Wing Technical plans" and q:getStage(p) == 2)
download(p)
assert(awards[q.planTemplate] == 1)
disk.parent = object() -- bank: an existing disk must not be duplicated
download(p)
assert(awards[q.planTemplate] == 1)
p.zone = "lok"
assert(q:complete(p, npc) == "missing_plans")
disk:destroyObjectFromDatabase()
download(p)
assert(awards[q.planTemplate] == 2)
disk = q:getPlans(p)

download(other)
assert(q:getPlans(other) ~= disk)
other.zone = "lok"
local otherDisk = q:getPlans(other)
otherDisk.parent = p.inventory
assert(q:complete(other, npc) == "missing_plans")
otherDisk.parent = other.inventory

-- Script reload preserves per-player progress and exact disk identity.
dofile(root .. "screenplays/quests/incom_xwing_plans.lua")
q = IncomXwingPlans
assert(q:getStage(p) == 2 and q:getPlans(p) == disk)
p.zone = "lok"
p.inventory.full = true
assert(q:complete(p, npc) == "inventory_full" and objects[disk.id] == disk)
p.inventory.full = false
failItem = true
assert(q:complete(p, npc) == "reward_failed" and q:getStage(p) == 2 and objects[disk.id] == disk)
failItem = false
assert(q:complete(p, npc) == "rewarded")
assert(q:getStage(p) == 3 and objects[disk.id] == nil and awards[q.rewardTemplate] == 1)
assert(q:complete(p, npc) == "not_ready" and awards[q.rewardTemplate] == 1)
assert(q:complete(other, npc) == "rewarded" and awards[q.rewardTemplate] == 2)
assert(not q:accept(p, npc))
assert(not q:canUseTerminal(p, terminal))
local j = p.ghost.journal[getHashCode(q.questKey)]
assert(j.done and j.complete[0] and j.complete[1])
assert(next(p.ghost.waypoints) == nil)

-- Every conversation option resolves; declining has no mission side effect.
ConvoTemplate = {new = function(self, o)
	function o:addScreen(s) self.screens[s.id] = s end
	function o:getScreen(id) assert(self.screens[id], id); return self.screens[id] end
	return o
end}
ConvoScreen = {new = function(self, o)
	function o:getScreenID() return self.id end
	return o
end}
addConversationTemplate = function() end
LuaConversationTemplate = SceneObject
LuaConversationScreen = SceneObject
dofile(root .. "mobile/conversations/quests/incom_xwing_plans_convo.lua")
local template = incomXwingPlansConvoTemplate
for _, screen in pairs(template.screens) do
	for _, option in ipairs(screen.options) do assert(template.screens[option[2]]) end
end
local fresh = player()
incomXwingPlansConvoHandler:runScreenHandlers(template, fresh, npc, 0, template:getScreen("decline"))
assert(q:getStage(fresh) == 0)
assert(incomXwingPlansConvoHandler:getInitialScreen(p, npc, template).id == "already_complete")
print("PASS: journal progression, player isolation, reload, stale/cancelled SUI, range/cell/zone/combat/faction checks, full inventory, item failures, lost-disk recovery, one-time rewards, conversation links.")

-- The standard X-wing cannot be redeemed, even from an old confirmation box.
package.loaded["utils.logger"] = {}
package.loaded["utils.helpers"] = {}
dofile(root .. "screenplays/space/chassis_dealer.lua")
dofile(root .. "screenplays/space/conversations/chassisDealerConvoHandler.lua")
local xwing = object({path = "object/tangible/ship/components/chassis/xwing_chassis_token.iff", parent = p.inventory})
local otherShip = object({path = "object/tangible/ship/components/chassis/z95_chassis_token.iff", parent = p.inventory})
for _, token in ipairs({xwing, otherShip}) do
	function token:getGameObjectType() return 1073741836 end
	function token:getDisplayedName() return self.path end
end
function p.inventory:getContainerObjectsSize() return 2 end
function p.inventory:getContainerObject(n) return ({xwing, otherShip})[n + 1] end
local blueprints = ChassisDealer:getValidBlueprints(p)
assert(#blueprints == 1 and blueprints[1][2] == otherShip.id)
local confirmation = {getUsingObject = function() return npc end}
LuaSuiBox = SceneObject
LuaSuiListBox = SceneObject
LuaSuiManager = function() return {} end
function npc:isCreatureObject() return true end
generateShipDeed = function() error("X-wing dealer redemption must be blocked") end
writeData(p.id .. ":ChassisDealer:BlueprintID:", xwing.id)
chassisDealerConvoHandler:purchaseChassis(p, confirmation, 0)
local oldList = {
	getMenuSize = function() return 1 end,
	getMenuObjectID = function() return xwing.id end,
}
chassisDealerConvoHandler:purchaseChassisConfirmation(p, oldList, 0, "0")
chassisDealerConvoHandler:purchaseChassisConfirmation(p, oldList, 0, "999")
assert(readData(p.id .. ":ChassisDealer:BlueprintID:") == 0)
print("PASS: standard X-wing dealer exclusion, other chassis retained, stale confirmation rejected, invalid selection rejected.")

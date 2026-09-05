-- Collection world objects (ruling 2026-09-05: "all the collections, the gui,
-- the items across the galaxy, everything").
-- SOURCED spawnSceneObject + spawnIfMissing (collector_spawns.lua). Slot binding
-- is per-object writeStringData <oid>:collection.slot (collector_spawns.lua:159
-- writeStringData for <oid>:collection.columnName; slot is a string so this is
-- writeStringData, not writeData). Quaternion is identity (OURS): the transcribed
-- rows carry px/py/pz only.
-- Click: CollectionObjectMenuComponent ITEM_USE @collection:consume_item
-- (consume_click.java:52; collector_npc.lua:371 radial 20; tutorial.lua:259
-- setObjectMenuComponent after spawn). Countdown is createEvent 5 s (OURS:
-- sui.smartCountdownTimerSUI has no Lua twin) plus a 500 ms watcher that
-- cancels on incap/dead, HAM drop, combat, or >0.1 m move. finishClick is
-- the expiry recheck.

includeFile("collections/objects/corellia.lua")
includeFile("collections/objects/dantooine.lua")
includeFile("collections/objects/dathomir.lua")
includeFile("collections/objects/dungeon1.lua")
includeFile("collections/objects/endor.lua")
includeFile("collections/objects/kashyyyk.lua")
includeFile("collections/objects/kashyyyk_rryatt_trail.lua")
includeFile("collections/objects/lok.lua")
includeFile("collections/objects/mustafar.lua")
includeFile("collections/objects/naboo.lua")
includeFile("collections/objects/rori.lua")
includeFile("collections/objects/talus.lua")
includeFile("collections/objects/tatooine.lua")
includeFile("collections/objects/yavin4.lua")

CollectionObjects = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionObjects",
	MAX_RANGE = 3,
	COLLECT_TIMER_MS = 5000,
	WATCH_MS = 500,
	WATCH_TICKS = 10,
	MOVE_LIMIT = 0.1,
	zones = {
		"corellia",
		"dantooine",
		"dathomir",
		"dungeon1",
		"endor",
		"kashyyyk",
		"kashyyyk_rryatt_trail",
		"lok",
		"mustafar",
		"naboo",
		"rori",
		"talus",
		"tatooine",
		"yavin4",
	},
}

registerScreenPlay("CollectionObjects", true)

function CollectionObjects:start()
	self:spawnAll()
end

function CollectionObjects:spawnAll()
	local zones = self.zones

	for i = 1, #zones, 1 do
		local zone = zones[i]
		local rows = CollectionObjectSpawns[zone]
		local placed = 0

		if (rows ~= nil) then
			for j = 1, #rows, 1 do
				if (self:spawnIfMissing(rows[j])) then
					placed = placed + 1
				end
			end
		end

		print("CollectionObjects: placed " .. placed .. " on " .. zone)
	end
end

function CollectionObjects:storedKey(entry)
	return self.screenplayName .. ":" .. entry.zone .. ":" .. entry.row
end

function CollectionObjects:spawnIfMissing(entry)
	if (entry.open) then
		print("CollectionObjects: " .. entry.row .. " on " .. entry.zone .. " is OPEN (" .. entry.openNote .. "); not spawned")
		return false
	end

	if (not isZoneEnabled(entry.zone)) then
		return false
	end

	local key = self:storedKey(entry)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			self:bindObject(pExisting, entry.slot)
			return true
		end
	end

	local pObject = spawnSceneObject(entry.zone, entry.template, entry.x, entry.z, entry.y, 0, 1, 0, 0, 0)

	if (pObject == nil) then
		return false
	end

	writeData(key, SceneObject(pObject):getObjectID())
	self:bindObject(pObject, entry.slot)
	return true
end

function CollectionObjects:bindObject(pObject, slot)
	if (pObject == nil or slot == nil or slot == "") then
		return
	end

	local oid = SceneObject(pObject):getObjectID()
	writeStringData(oid .. ":collection.slot", slot)
	SceneObject(pObject):setObjectMenuComponent("CollectionObjectMenuComponent")
end

function CollectionObjects:splitSlot(full)
	if (full == nil or full == "") then
		return nil, nil
	end

	local colon = string.find(full, ":", 1, true)

	if (colon == nil) then
		return nil, full
	end

	return string.sub(full, 1, colon - 1), string.sub(full, colon + 1)
end

function CollectionObjects:slotOf(pObject)
	if (pObject == nil) then
		return nil
	end

	local stored = readStringData(SceneObject(pObject):getObjectID() .. ":collection.slot")

	if (stored == nil or stored == "") then
		return nil
	end

	return stored
end

function CollectionObjects:checkState(pPlayer)
	if (CreatureObject(pPlayer):isInCombat()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_combat")
		return false
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_mounted")
		return false
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_dead_incap")
		return false
	end

	return true
end

function CollectionObjects:inRange(pPlayer, pObject)
	return CreatureObject(pPlayer):isInRangeWithObject(pObject, self.MAX_RANGE)
end

function CollectionObjects:checksBeforeTimer(pPlayer, pObject, collectionName, slotName)
	if (not CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
		return false
	end

	if (collectionName ~= nil and CollectionManager.hasCompletedCollection(pPlayer, collectionName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
		return false
	end

	if (slotName == nil or slotName == "" or CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
		return false
	end

	if (not self:checkState(pPlayer)) then
		return false
	end

	if (not self:inRange(pPlayer, pObject)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:not_close_enough")
		return false
	end

	return true
end

function CollectionObjects:beginClick(pPlayer, pObject)
	if (pPlayer == nil or pObject == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local full = self:slotOf(pObject)

	if (full == nil) then
		return
	end

	local collectionName, slotName = self:splitSlot(full)

	if (not self:checksBeforeTimer(pPlayer, pObject, collectionName, slotName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local serial = (readData(playerID .. ":CollectionObjects:serial") or 0) + 1
	writeData(playerID .. ":CollectionObjects:serial", serial)
	writeData(playerID .. ":CollectionObjects:oid", SceneObject(pObject):getObjectID())
	writeData(playerID .. ":CollectionObjects:ham0", CreatureObject(pPlayer):getHAM(0))
	writeData(playerID .. ":CollectionObjects:ham3", CreatureObject(pPlayer):getHAM(3))
	writeData(playerID .. ":CollectionObjects:ham6", CreatureObject(pPlayer):getHAM(6))
	writeVector3Data(playerID .. ":CollectionObjects:pos", SceneObject(pPlayer):getWorldPositionX(), SceneObject(pPlayer):getWorldPositionZ(), SceneObject(pPlayer):getWorldPositionY())

	local sui = SuiMessageBox.new("CollectionObjects", "countdownCallback")
	sui.setTitle("@collection:consume_item_title")
	sui.setPrompt("@collection:click_countdown_timer")
	sui.setForceCloseDistance(self.MAX_RANGE)
	sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
	sui.setWindowType(self:suiWindowType())
	sui.sendTo(pPlayer)

	createEvent(self.WATCH_MS, "CollectionObjects", "watchClick", pPlayer, tostring(serial) .. ":1")
	createEvent(self.COLLECT_TIMER_MS, "CollectionObjects", "finishClick", pPlayer, tostring(serial))
end

function CollectionObjects:suiWindowType()
	if (SuiWindowType.MESSAGE_BOX ~= nil) then
		return SuiWindowType.MESSAGE_BOX
	end

	return 0
end

function CollectionObjects:cancelClick(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local serial = (readData(playerID .. ":CollectionObjects:serial") or 0) + 1
	writeData(playerID .. ":CollectionObjects:serial", serial)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):closeSuiWindowType(self:suiWindowType())
	end
end

function CollectionObjects:shouldCancelClick(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	if (CreatureObject(pPlayer):isIncapacitated() or CreatureObject(pPlayer):isDead()) then
		return true
	end

	if (CreatureObject(pPlayer):getHAM(0) < readData(playerID .. ":CollectionObjects:ham0")) then
		return true
	end

	if (CreatureObject(pPlayer):getHAM(3) < readData(playerID .. ":CollectionObjects:ham3")) then
		return true
	end

	if (CreatureObject(pPlayer):getHAM(6) < readData(playerID .. ":CollectionObjects:ham6")) then
		return true
	end

	if (CreatureObject(pPlayer):isInCombat()) then
		return true
	end

	local start = readVector3Data(playerID .. ":CollectionObjects:pos")
	local dx = SceneObject(pPlayer):getWorldPositionX() - start[1]
	local dz = SceneObject(pPlayer):getWorldPositionZ() - start[2]
	local dy = SceneObject(pPlayer):getWorldPositionY() - start[3]

	if ((dx * dx + dy * dy + dz * dz) > (self.MOVE_LIMIT * self.MOVE_LIMIT)) then
		return true
	end

	return false
end

function CollectionObjects:watchClick(pPlayer, arg)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or arg == nil) then
		return
	end

	local colon = string.find(arg, ":", 1, true)

	if (colon == nil) then
		return
	end

	local serial = tonumber(string.sub(arg, 1, colon - 1))
	local tick = tonumber(string.sub(arg, colon + 1))
	local playerID = SceneObject(pPlayer):getObjectID()

	if (serial == nil or tick == nil or serial ~= readData(playerID .. ":CollectionObjects:serial")) then
		return
	end

	if (self:shouldCancelClick(pPlayer)) then
		self:cancelClick(pPlayer)
		return
	end

	if (tick < self.WATCH_TICKS) then
		createEvent(self.WATCH_MS, "CollectionObjects", "watchClick", pPlayer, tostring(serial) .. ":" .. tostring(tick + 1))
	end
end

function CollectionObjects:countdownCallback(pPlayer, pSui, eventIndex)
	if (pPlayer == nil or eventIndex ~= 1) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local serial = (readData(playerID .. ":CollectionObjects:serial") or 0) + 1
	writeData(playerID .. ":CollectionObjects:serial", serial)
end

function CollectionObjects:finishClick(pPlayer, serialText)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local serial = tonumber(serialText)

	if (serial == nil or serial ~= readData(playerID .. ":CollectionObjects:serial")) then
		return
	end

	-- The last watcher tick and the expiry share the 5 s boundary: run the
	-- same cancel test here so a late hit or step cannot slip through.
	if (self:shouldCancelClick(pPlayer)) then
		self:cancelClick(pPlayer)
		return
	end

	local oid = readData(playerID .. ":CollectionObjects:oid")
	local pObject = getSceneObject(oid)

	if (pObject == nil) then
		return
	end

	local full = self:slotOf(pObject)

	if (full == nil) then
		return
	end

	local collectionName, slotName = self:splitSlot(full)

	if (not self:checksBeforeTimer(pPlayer, pObject, collectionName, slotName)) then
		return
	end

	if (not CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:report_consume_item_fail")
	end
end

CollectionObjectMenuComponent = { }

function CollectionObjectMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@collection:consume_item")
end

function CollectionObjectMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	CollectionObjects:beginClick(pPlayer, pSceneObject)
	return 0
end

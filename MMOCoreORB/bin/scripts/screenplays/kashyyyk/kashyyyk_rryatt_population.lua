KashyyykRryattPopulation = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykRryattPopulation",
	zone = "kashyyyk_rryatt_trail"
}

registerScreenPlay("KashyyykRryattPopulation", true)

function KashyyykRryattPopulation:controllerAt(index)
	local data = KashyyykRryattPopulationData
	if (index <= #data.controllers) then
		return data.controllers[index]
	end
	return data.patrols[index - #data.controllers]
end

function KashyyykRryattPopulation:slotKey(controller, slot)
	return self.screenplayName .. ":" .. controller.id .. ":" .. slot
end

function KashyyykRryattPopulation:isAlive(pMobile)
	return pMobile ~= nil and SceneObject(pMobile):getZoneName() == self.zone
		and not CreatureObject(pMobile):isDead() and not CreatureObject(pMobile):isIncapacitated()
end

function KashyyykRryattPopulation:respawnDelay(controller)
	return getRandomNumber(math.floor(controller.respawnMin * 1000), math.floor(controller.respawnMax * 1000))
end

function KashyyykRryattPopulation:start()
	if (not isZoneEnabled(self.zone)) then
		return
	end

	local data = KashyyykRryattPopulationData
	for index = 1, #data.controllers + #data.patrols do
		local c = self:controllerAt(index)
		local delay = c.points ~= nil and 10000 or 20000
		for slot = 1, c.count do
			local key = self:slotKey(c, slot)
			if (not self:isAlive(getSceneObject(readData(key)))) then
				self:scheduleSpawn(index, slot, delay)
			end
			if (c.points == nil) then
				delay = delay + self:respawnDelay(c)
			end
		end
	end
end

function KashyyykRryattPopulation:scheduleSpawn(index, slot, delay)
	local key = self:slotKey(self:controllerAt(index), slot)
	if (readData(key .. ":pending") ~= 0) then
		return
	end
	local token = readData(key .. ":generation") + 1
	writeData(key .. ":generation", token)
	writeData(key .. ":pending", token)
	createEvent(delay, self.screenplayName, "spawnSlot", nil, index .. ":" .. slot .. ":" .. token)
end

function KashyyykRryattPopulation:spawnSlot(pUnused, args)
	local index, slot, token = string.match(args or "", "^(%d+):(%d+):(%d+)$")
	index, slot, token = tonumber(index), tonumber(slot), tonumber(token)
	local c = index ~= nil and self:controllerAt(index) or nil
	if (c == nil or slot == nil or slot < 1 or slot > c.count) then
		return
	end
	local key = self:slotKey(c, slot)
	if (readData(key .. ":pending") ~= token) then
		return
	end
	deleteData(key .. ":pending")
	if (not isZoneEnabled(self.zone) or self:isAlive(getSceneObject(readData(key)))) then
		return
	end

	local entries = KashyyykRryattPopulationData.types[c.type]
	local entry = entries[getRandomNumber(1, #entries)]
	local x, z, y = c.x, c.z, c.y
	if (c.radius > 0) then
		local radius = math.floor(c.radius * 1000)
		x = x + getRandomNumber(-radius, radius) / 1000
		y = y + getRandomNumber(-radius, radius) / 1000
	end
	-- DSRC's helper changes only the horizontal axes. A highest-floor lookup
	-- can select another trail level above this controller's authored platform.
	local pMobile = spawnMobile(self.zone, entry.mobile, 0, x, z, y, c.heading, 0)
	if (pMobile == nil) then
		print(self.screenplayName .. ": spawn failed for " .. c.id .. " (" .. entry.mobile .. ")")
		self:scheduleSpawn(index, slot, self:respawnDelay(c))
		return
	end

	local oid = SceneObject(pMobile):getObjectID()
	writeData(key, oid)
	writeData(oid .. ":RryattPopulation:controller", index)
	writeData(oid .. ":RryattPopulation:slot", slot)
	writeData(oid .. ":RryattPopulation:delay", self:respawnDelay(c))
	createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyDestroyed", pMobile)
	if (SceneObject(pMobile):isAiAgent()) then
		if (c.points ~= nil) then
			AiAgent(pMobile):setAITemplate()
			AiAgent(pMobile):setMovementState(AI_PATROLLING)
			writeData(oid .. ":RryattPopulation:point", 2)
			writeData(oid .. ":RryattPopulation:direction", 1)
			createObserver(DESTINATIONREACHED, self.screenplayName, "notifyDestinationReached", pMobile)
			createEvent(5000, self.screenplayName, "walkStep", pMobile, "")
		elseif (c.behavior == 1) then
			AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
		else
			AiAgent(pMobile):addObjectFlag(AI_STATIC)
		end
	end
end

function KashyyykRryattPopulation:notifyDestroyed(pMobile, pAttacker)
	if (pMobile == nil) then
		return 1
	end
	local oid = SceneObject(pMobile):getObjectID()
	local index = readData(oid .. ":RryattPopulation:controller")
	local slot = readData(oid .. ":RryattPopulation:slot")
	local delay = readData(oid .. ":RryattPopulation:delay")
	local c = self:controllerAt(index)
	for _, field in ipairs({"controller", "slot", "delay", "point", "direction"}) do
		deleteData(oid .. ":RryattPopulation:" .. field)
	end
	if (c ~= nil and slot >= 1 and slot <= c.count and readData(self:slotKey(c, slot)) == oid) then
		deleteData(self:slotKey(c, slot))
		-- spawned_tracker reserves the count for the delay, then requests a two-second refill.
		self:scheduleSpawn(index, slot, delay + 2000)
	end
	return 1
end

function KashyyykRryattPopulation:walkStep(pMobile)
	if (not self:isAlive(pMobile)) then
		return
	end
	local oid = SceneObject(pMobile):getObjectID()
	local c = self:controllerAt(readData(oid .. ":RryattPopulation:controller"))
	if (c == nil or c.points == nil) then
		return
	end
	if (CreatureObject(pMobile):isInCombat()) then
		createEvent(10000, self.screenplayName, "walkStep", pMobile, "")
		return
	end
	local point = c.points[readData(oid .. ":RryattPopulation:point")]
	if (point ~= nil) then
		AiAgent(pMobile):setMovementState(AI_PATROLLING)
		AiAgent(pMobile):stopWaiting()
		AiAgent(pMobile):setWait(0)
		AiAgent(pMobile):setNextPosition(point[1], point[2], point[3], 0)
		AiAgent(pMobile):executeBehavior()
	end
end

function KashyyykRryattPopulation:notifyDestinationReached(pMobile)
	if (not self:isAlive(pMobile)) then
		return 0
	end
	local oid = SceneObject(pMobile):getObjectID()
	local c = self:controllerAt(readData(oid .. ":RryattPopulation:controller"))
	if (c ~= nil and c.points ~= nil) then
		local point, direction = KashyyykPatrolsScreenPlay:advanceIndex(c,
			readData(oid .. ":RryattPopulation:point"), readData(oid .. ":RryattPopulation:direction"))
		writeData(oid .. ":RryattPopulation:point", point)
		writeData(oid .. ":RryattPopulation:direction", direction)
		self:walkStep(pMobile)
	end
	return 0
end

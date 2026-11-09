KashyyykSpawnController = ScreenPlay:new {}

-- A callback may run in a Lua state that never ran start().
function KashyyykSpawnController:getLayout()
	if (self.zone ~= nil and isZoneEnabled(self.zone)) then
		return self.zone, 0, 0
	end
end

function KashyyykSpawnController:controllerAt(index)
	local data = self.data
	if (index <= #data.controllers) then
		return data.controllers[index]
	end
	return data.patrols[index - #data.controllers]
end

function KashyyykSpawnController:slotKey(controller, slot)
	return self.screenplayName .. ":" .. controller.id .. ":" .. slot
end

function KashyyykSpawnController:isAlive(pMobile, zone)
	return pMobile ~= nil and SceneObject(pMobile):getZoneName() == zone
		and not CreatureObject(pMobile):isDead() and not CreatureObject(pMobile):isIncapacitated()
end

function KashyyykSpawnController:respawnDelay(controller)
	return getRandomNumber(math.floor(controller.respawnMin * 1000), math.floor(controller.respawnMax * 1000))
end

function KashyyykSpawnController:start()
	local zone = self:getLayout()
	if (zone == nil) then
		return
	end

	local data = self.data
	for index = 1, #data.controllers + #data.patrols do
		local c = self:controllerAt(index)
		local delay = c.points ~= nil and 10000 or 20000
		for slot = 1, c.count do
			local key = self:slotKey(c, slot)
			if (not self:isAlive(getSceneObject(readData(key)), zone)) then
				self:scheduleSpawn(index, slot, delay)
			end
			if (c.points == nil) then
				delay = delay + self:respawnDelay(c)
			end
		end
	end
end

function KashyyykSpawnController:scheduleSpawn(index, slot, delay)
	local key = self:slotKey(self:controllerAt(index), slot)
	if (readData(key .. ":pending") ~= 0) then
		return
	end
	local token = readData(key .. ":generation") + 1
	writeData(key .. ":generation", token)
	writeData(key .. ":pending", token)
	createEvent(delay, self.screenplayName, "spawnSlot", nil, index .. ":" .. slot .. ":" .. token)
end

function KashyyykSpawnController:spawnSlot(pUnused, args)
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
	local zone, offsetX, offsetY = self:getLayout()
	if (zone == nil or self:isAlive(getSceneObject(readData(key)), zone)) then
		return
	end

	local entries = self.data.types[c.type]
	local entry = entries[getRandomNumber(1, #entries)]
	local firstPatrol = c.points ~= nil and self.nativePatrols and readData(key .. ":spawned") == 0
	local x, z, y = c.x, c.z, c.y
	if (firstPatrol) then
		local point = c.points[slot]
		x, z, y = point[1], point[2], point[3]
	elseif (c.radius > 0) then
		local radius = math.floor(c.radius * 1000)
		x = x + getRandomNumber(-radius, radius) / 1000
		y = y + getRandomNumber(-radius, radius) / 1000
	end
	x, y = x + offsetX, y + offsetY
	if (c.findSpawnPoint) then
		local point = getSpawnPointInArea(zone, x, y, entry.searchRadius)
		if (point == nil) then
			self:scheduleSpawn(index, slot, self:respawnDelay(c))
			return
		end
		x, z, y = point[1], point[2], point[3]
	end
	-- DSRC's helper changes only the horizontal axes. A highest-floor lookup
	-- can select a different floor above the controller's authored platform.
	local pMobile = spawnMobile(zone, entry.mobile, 0, x, z, y, c.heading, 0)
	if (pMobile == nil) then
		print(self.screenplayName .. ": spawn failed for " .. c.id .. " (" .. entry.mobile .. ")")
		self:scheduleSpawn(index, slot, self:respawnDelay(c))
		return
	end

	local oid = SceneObject(pMobile):getObjectID()
	writeData(key, oid)
	writeData(oid .. ":" .. self.dataKey .. ":controller", index)
	writeData(oid .. ":" .. self.dataKey .. ":slot", slot)
	writeData(oid .. ":" .. self.dataKey .. ":delay", self:respawnDelay(c))
	createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyDestroyed", pMobile)
	if (SceneObject(pMobile):isAiAgent()) then
		if (c.points ~= nil) then
			AiAgent(pMobile):setAITemplate()
			AiAgent(pMobile):setMovementState(AI_PATROLLING)
			writeData(oid .. ":" .. self.dataKey .. ":point", firstPatrol and slot + 1 or 2)
			if (firstPatrol) then
				writeData(key .. ":spawned", 1)
			end
			writeData(oid .. ":" .. self.dataKey .. ":direction", 1)
			createObserver(DESTINATIONREACHED, self.screenplayName, "notifyDestinationReached", pMobile)
			createEvent(5000, self.screenplayName, "walkStep", pMobile, "")
		elseif (c.behavior == 1) then
			AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
		elseif (self.keepLoiterAtHome) then
			AiAgent(pMobile):addObjectFlag(AI_STATIC)
		end
	end
end

function KashyyykSpawnController:notifyDestroyed(pMobile, pAttacker)
	if (pMobile == nil) then
		return 1
	end
	local oid = SceneObject(pMobile):getObjectID()
	local index = readData(oid .. ":" .. self.dataKey .. ":controller")
	local slot = readData(oid .. ":" .. self.dataKey .. ":slot")
	local delay = readData(oid .. ":" .. self.dataKey .. ":delay")
	local c = self:controllerAt(index)
	for _, field in ipairs({"controller", "slot", "delay", "point", "direction"}) do
		deleteData(oid .. ":" .. self.dataKey .. ":" .. field)
	end
	if (c ~= nil and slot >= 1 and slot <= c.count and readData(self:slotKey(c, slot)) == oid) then
		deleteData(self:slotKey(c, slot))
		-- spawned_tracker reserves the count for the delay, then requests a two-second refill.
		self:scheduleSpawn(index, slot, delay + 2000)
	end
	return 1
end

function KashyyykSpawnController:walkStep(pMobile)
	local zone, offsetX, offsetY = self:getLayout()
	if (zone == nil or not self:isAlive(pMobile, zone)) then
		return
	end
	local oid = SceneObject(pMobile):getObjectID()
	local c = self:controllerAt(readData(oid .. ":" .. self.dataKey .. ":controller"))
	if (c == nil or c.points == nil) then
		return
	end
	if (CreatureObject(pMobile):isInCombat()) then
		createEvent(10000, self.screenplayName, "walkStep", pMobile, "")
		return
	end
	local point = c.points[readData(oid .. ":" .. self.dataKey .. ":point")]
	if (point ~= nil) then
		AiAgent(pMobile):setMovementState(AI_PATROLLING)
		AiAgent(pMobile):stopWaiting()
		AiAgent(pMobile):setWait(0)
		AiAgent(pMobile):setNextPosition(point[1] + offsetX, point[2], point[3] + offsetY, 0)
		AiAgent(pMobile):executeBehavior()
	end
end

function KashyyykSpawnController:notifyDestinationReached(pMobile)
	local zone = self:getLayout()
	if (zone == nil or not self:isAlive(pMobile, zone)) then
		return 0
	end
	local oid = SceneObject(pMobile):getObjectID()
	local c = self:controllerAt(readData(oid .. ":" .. self.dataKey .. ":controller"))
	if (c ~= nil and c.points ~= nil) then
		local point, direction = KashyyykPatrolsScreenPlay:advanceIndex(c,
			readData(oid .. ":" .. self.dataKey .. ":point"), readData(oid .. ":" .. self.dataKey .. ":direction"))
		writeData(oid .. ":" .. self.dataKey .. ":point", point)
		writeData(oid .. ":" .. self.dataKey .. ":direction", direction)
		self:walkStep(pMobile)
	end
	return 0
end

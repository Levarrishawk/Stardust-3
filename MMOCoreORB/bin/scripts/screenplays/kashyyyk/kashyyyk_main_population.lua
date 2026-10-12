KashyyykMainPopulation = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykMainPopulation",
	zone = "kashyyyk_main"
}

registerScreenPlay("KashyyykMainPopulation", true)

function KashyyykMainPopulation:slotKey(controller, slot)
	return "KashyyykMainPopulation:" .. controller.id .. ":" .. slot
end

function KashyyykMainPopulation:respawnDelay(controller)
	return getRandomNumber(math.floor(controller.respawnMin * 1000), math.floor(controller.respawnMax * 1000))
end

function KashyyykMainPopulation:isAlive(pMobile)
	return pMobile ~= nil and not CreatureObject(pMobile):isDead()
		and not CreatureObject(pMobile):isIncapacitated()
end

function KashyyykMainPopulation:start()
	if (not isZoneEnabled(self.zone)) then
		return
	end

	for name, entries in pairs(KashyyykMainPopulationData.types) do
		for i = 1, #entries do
			if (#entries[i].mobiles == 0) then
				print("KashyyykMainPopulation: unresolved creature " .. entries[i].item .. " in " .. name)
			end
		end
	end

	for index = 1, #KashyyykMainPopulationData.controllers do
		local controller = KashyyykMainPopulationData.controllers[index]
		local entries = KashyyykMainPopulationData.types[controller.type]
		local supported = false
		for i = 1, #entries do
			if (#entries[i].mobiles > 0) then
				supported = true
			end
		end
		if (supported) then
			-- Retail starts after 20 seconds and fills one creature per spawn interval.
			local delay = 20000
			for slot = 1, controller.count do
				local key = self:slotKey(controller, slot)
				if (not self:isAlive(getSceneObject(readData(key))) and readData(key .. ":pending") == 0) then
					self:scheduleSpawn(index, slot, delay)
				end
				delay = delay + self:respawnDelay(controller)
			end
		end
	end
end

function KashyyykMainPopulation:scheduleSpawn(index, slot, delay)
	local controller = KashyyykMainPopulationData.controllers[index]
	local key = self:slotKey(controller, slot)
	if (readData(key .. ":pending") ~= 0) then
		return
	end
	local token = readData(key .. ":generation") + 1
	writeData(key .. ":generation", token)
	writeData(key .. ":pending", token)
	createEvent(delay, self.screenplayName, "spawnSlot", nil, index .. ":" .. slot .. ":" .. token)
end

function KashyyykMainPopulation:spawnSlot(pUnused, args)
	if (args == nil) then
		return
	end
	local index, slot, token = string.match(args, "^(%d+):(%d+):(%d+)$")
	index, slot, token = tonumber(index), tonumber(slot), tonumber(token)
	local controller = index ~= nil and KashyyykMainPopulationData.controllers[index] or nil
	if (controller == nil or slot == nil or slot < 1 or slot > controller.count) then
		return
	end
	local key = self:slotKey(controller, slot)
	if (readData(key .. ":pending") ~= token) then
		return
	end
	deleteData(key .. ":pending")
	if (not isZoneEnabled(self.zone) or self:isAlive(getSceneObject(readData(key)))) then
		return
	end

	local entries = KashyyykMainPopulationData.types[controller.type]
	local entry = entries[getRandomNumber(1, #entries)]
	if (#entry.mobiles == 0) then
		self:scheduleSpawn(index, slot, self:respawnDelay(controller))
		return
	end
	local mobile = entry.mobiles[getRandomNumber(1, #entry.mobiles)]
	local x, z, y = controller.x, controller.z, controller.y
	if (controller.radius > 0) then
		-- The retail helper offsets X and Y independently, within this controller's radius.
		local radius = math.floor(controller.radius * 1000)
		x = x + getRandomNumber(-radius, radius) / 1000
		y = y + getRandomNumber(-radius, radius) / 1000
		z = getWorldFloor(x, y, self.zone)
	end
	local pMobile = nil
	if (z ~= nil and z == z) then
		pMobile = spawnMobile(self.zone, mobile, 0, x, z, y, controller.heading, 0)
	end
	if (pMobile == nil) then
		print("KashyyykMainPopulation: spawn failed for controller " .. controller.id .. " (" .. mobile .. ")")
		self:scheduleSpawn(index, slot, self:respawnDelay(controller))
		return
	end

	local oid = SceneObject(pMobile):getObjectID()
	writeData(key, oid)
	writeData(oid .. ":KashyyykMainPopulation:controller", index)
	writeData(oid .. ":KashyyykMainPopulation:slot", slot)
	writeData(oid .. ":KashyyykMainPopulation:delay", self:respawnDelay(controller))
	if (SceneObject(pMobile):isAiAgent()) then
		-- Only the idle behaviour changes; normal combat and template stats remain intact.
		if (controller.behavior == 1) then
			AiAgent(pMobile):addObjectFlag(STATIONARY)
		else
			AiAgent(pMobile):addObjectFlag(STATIC)
		end
	end
	createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyDestroyed", pMobile)
end

function KashyyykMainPopulation:notifyDestroyed(pMobile, pAttacker)
	if (pMobile == nil) then
		return 1
	end
	local oid = SceneObject(pMobile):getObjectID()
	local index = readData(oid .. ":KashyyykMainPopulation:controller")
	local slot = readData(oid .. ":KashyyykMainPopulation:slot")
	local delay = readData(oid .. ":KashyyykMainPopulation:delay")
	deleteData(oid .. ":KashyyykMainPopulation:controller")
	deleteData(oid .. ":KashyyykMainPopulation:slot")
	deleteData(oid .. ":KashyyykMainPopulation:delay")
	local controller = KashyyykMainPopulationData.controllers[index]
	if (controller ~= nil and slot >= 1 and slot <= controller.count
		and readData(self:slotKey(controller, slot)) == oid) then
		-- Retail spawned_tracker reserves the slot through the delay, then refills after two seconds.
		self:scheduleSpawn(index, slot, delay + 2000)
	end
	return 1
end

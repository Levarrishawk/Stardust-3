-- Kashyyyk patrol walker (ruling 2026-09-04: "ensure kashyyyk is done in full").
-- Reads KashyyykPatrolPaths. The engine pops a reached patrol point and does not loop
-- by itself; this screenplay drives the next waypoint. city.lua is not reused: that
-- helper refuses combat-capable NPCs, and these routes are combat mobiles.

KashyyykPatrolsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykPatrolsScreenPlay"
}

registerScreenPlay("KashyyykPatrolsScreenPlay", true)

function KashyyykPatrolsScreenPlay:start()
	self:spawnPatrols()
end

function KashyyykPatrolsScreenPlay:spawnPatrols()
	if (KashyyykPatrolPaths == nil) then
		return
	end

	for routeIndex = 1, #KashyyykPatrolPaths, 1 do
		local route = KashyyykPatrolPaths[routeIndex]

		if (route ~= nil and route.spawnZone ~= nil and isZoneEnabled(route.spawnZone) and route.mobiles ~= nil and route.points ~= nil and route.count ~= nil and route.count > 0 and #route.mobiles > 0 and #route.points > 0) then
			local count = route.count
			local pointCount = #route.points
			local mobileCount = #route.mobiles
			-- Spread the route's mobiles along its points; when a route has fewer points than mobiles (SOE has
			-- count-4 routes with three points) the start index wraps instead of stacking everyone on point 1.
			local stride = math.max(1, math.floor(pointCount / count))

			for i = 1, count, 1 do
				local template = route.mobiles[((i - 1) % mobileCount) + 1]
				local startIdx = (((i - 1) * stride) % pointCount) + 1

				if (startIdx < 1) then
					startIdx = 1
				elseif (startIdx > pointCount) then
					startIdx = pointCount
				end

				self:spawnOne(routeIndex, template, startIdx)
			end
		end
	end
end

function KashyyykPatrolsScreenPlay:spawnOne(routeIndex, template, startIdx)
	local route = KashyyykPatrolPaths[routeIndex]

	if (route == nil or template == nil or startIdx == nil or route.spawnZone == nil or not isZoneEnabled(route.spawnZone)) then
		return
	end

	local points = route.points
	local startPoint = points[startIdx]

	if (startPoint == nil) then
		return
	end

	local dir = 1
	local targetIdx = startIdx
	local heading = 0

	if (#points >= 2) then
		targetIdx, dir = self:advanceIndex(route, startIdx, 1)
		heading = self:headingBetween(startPoint, points[targetIdx])
	end

	local pMobile = spawnMobile(route.spawnZone, template, 0, startPoint[1], startPoint[2], startPoint[3], heading, 0)

	if (pMobile == nil) then
		return
	end

	self:armMobile(pMobile, routeIndex, template, targetIdx, dir)
end

function KashyyykPatrolsScreenPlay:armMobile(pMobile, routeIndex, template, targetIdx, dir)
	if (pMobile == nil or not SceneObject(pMobile):isAiAgent()) then
		return
	end

	local oid = SceneObject(pMobile):getObjectID()

	writeData(oid .. ":KashyyykPatrols:route", routeIndex)
	writeData(oid .. ":KashyyykPatrols:loc", targetIdx)
	writeData(oid .. ":KashyyykPatrols:dir", dir)
	writeStringData(oid .. ":KashyyykPatrols:mobile", template)

	-- Chandrila hanna patrol1.lua:41-42 calls setAiTemplate("manualescortwalk") and
	-- setFollowState(4). This fork binds setAITemplate() with no template string
	-- (LuaAiAgent.cpp) and setMovementState; PATROLLING is 4 (AiAgent.idl).
	AiAgent(pMobile):setAITemplate()
	AiAgent(pMobile):setMovementState(AI_PATROLLING)

	createObserver(DESTINATIONREACHED, "KashyyykPatrolsScreenPlay", "notifyDestinationReached", pMobile)
	createObserver(OBJECTDESTRUCTION, "KashyyykPatrolsScreenPlay", "notifyDestroyed", pMobile)

	if (#KashyyykPatrolPaths[routeIndex].points >= 2) then
		createEvent(getRandomNumber(2, 6) * 1000, "KashyyykPatrolsScreenPlay", "walkStep", pMobile, "")
	end
end

function KashyyykPatrolsScreenPlay:headingBetween(fromPoint, toPoint)
	if (fromPoint == nil or toPoint == nil) then
		return 0
	end

	local dx = toPoint[1] - fromPoint[1]
	local dy = toPoint[3] - fromPoint[3]

	if (dx == 0 and dy == 0) then
		return 0
	end

	-- math.atan(y, x) is the Lua 5.3 two-argument form (math.atan2 is compat-only).
	return math.deg(math.atan(dx, dy))
end

function KashyyykPatrolsScreenPlay:advanceIndex(route, idx, dir)
	local n = #route.points

	if (n < 2) then
		return idx, dir
	end

	if (route.pathType == "oscillate") then
		local nextIdx = idx + dir

		if (nextIdx > n) then
			dir = -1
			nextIdx = n - 1
		elseif (nextIdx < 1) then
			dir = 1
			nextIdx = 2
		end

		return nextIdx, dir
	end

	local nextIdx = idx + 1

	if (nextIdx > n) then
		nextIdx = 1
	end

	return nextIdx, 1
end

function KashyyykPatrolsScreenPlay:mobileInWorld(pMobile)
	if (pMobile == nil) then
		return false
	end

	if (not SceneObject(pMobile):isAiAgent()) then
		return false
	end

	if (SceneObject(pMobile):getZoneName() == "") then
		return false
	end

	if (CreatureObject(pMobile):isDead()) then
		return false
	end

	return true
end

function KashyyykPatrolsScreenPlay:walkStep(pMobile, args)
	if (not self:mobileInWorld(pMobile)) then
		return
	end

	-- In combat: do not move; try again in 10 s. Every step is an event, never a busy-loop.
	if (CreatureObject(pMobile):isInCombat()) then
		createEvent(10 * 1000, "KashyyykPatrolsScreenPlay", "walkStep", pMobile, "")
		return
	end

	local oid = SceneObject(pMobile):getObjectID()
	local routeIndex = readData(oid .. ":KashyyykPatrols:route")
	local loc = readData(oid .. ":KashyyykPatrols:loc")
	local route = KashyyykPatrolPaths[routeIndex]

	if (route == nil or route.points == nil) then
		return
	end

	local point = route.points[loc]

	if (point == nil) then
		return
	end

	AiAgent(pMobile):setMovementState(AI_PATROLLING)
	AiAgent(pMobile):stopWaiting()
	AiAgent(pMobile):setWait(0)
	AiAgent(pMobile):setNextPosition(point[1], point[2], point[3], 0)
	AiAgent(pMobile):executeBehavior()
end

function KashyyykPatrolsScreenPlay:notifyDestinationReached(pMobile)
	if (not self:mobileInWorld(pMobile)) then
		return 0
	end

	local oid = SceneObject(pMobile):getObjectID()
	local routeIndex = readData(oid .. ":KashyyykPatrols:route")
	local loc = readData(oid .. ":KashyyykPatrols:loc")
	local dir = readData(oid .. ":KashyyykPatrols:dir")
	local route = KashyyykPatrolPaths[routeIndex]

	if (route == nil or route.points == nil) then
		return 0
	end

	if (dir == 0) then
		dir = 1
	end

	loc, dir = self:advanceIndex(route, loc, dir)
	writeData(oid .. ":KashyyykPatrols:loc", loc)
	writeData(oid .. ":KashyyykPatrols:dir", dir)

	-- 3-8 s between points. A route point is a walking waypoint, not a post;
	-- Chandrila waits 25-45 s at a post (hanna patrol1.lua:84).
	createEvent(getRandomNumber(3, 8) * 1000, "KashyyykPatrolsScreenPlay", "walkStep", pMobile, "")

	return 0
end

function KashyyykPatrolsScreenPlay:notifyDestroyed(pVictim, pAttacker)
	if (pVictim == nil) then
		return 1
	end

	local oid = SceneObject(pVictim):getObjectID()
	local routeIndex = readData(oid .. ":KashyyykPatrols:route")
	local template = readStringData(oid .. ":KashyyykPatrols:mobile")

	deleteData(oid .. ":KashyyykPatrols:route")
	deleteData(oid .. ":KashyyykPatrols:loc")
	deleteData(oid .. ":KashyyykPatrols:dir")
	deleteStringData(oid .. ":KashyyykPatrols:mobile")

	local route = KashyyykPatrolPaths[routeIndex]

	if (route == nil or template == nil or template == "") then
		return 1
	end

	local delay = getRandomNumber(route.respawnMin, route.respawnMax)

	createEvent(delay * 1000, "KashyyykPatrolsScreenPlay", "respawnMobile", nil, tostring(routeIndex) .. ":" .. template)

	return 1
end

function KashyyykPatrolsScreenPlay:respawnMobile(pMobile, args)
	if (args == nil or args == "") then
		return
	end

	local sep = string.find(args, ":", 1, true)

	if (sep == nil) then
		return
	end

	local routeIndex = tonumber(string.sub(args, 1, sep - 1))
	local template = string.sub(args, sep + 1)

	if (routeIndex == nil or template == nil or template == "") then
		return
	end

	-- SOE timers: respawn at the route's first point, then start walking again.
	self:spawnOne(routeIndex, template, 1)
end

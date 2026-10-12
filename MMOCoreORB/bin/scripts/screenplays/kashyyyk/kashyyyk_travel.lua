-- Repair missing travel children on existing shuttleposts and adopt children
-- created from the building template on fresh databases. Cached OIDs are
-- process-local; persistent template children are rediscovered after restart.
-- Requires the bounds-checked SceneObject:getChildObject binding.

KashyyykTravelScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykTravelScreenPlay",
	planet = "kashyyyk_main",

	-- Kachirho starport in snapshot/kashyyyk_main.ws.
	POST_ID = 14602401,

	-- Offsets, cells and headings from mun_kachirho_starport.lua childObjects.
	travelChildren = {
		{templateFile = "object/tangible/terminal/terminal_travel.iff", x = -3.12, z = 0.14659503, y = -17.57, ox = 0, oy = 0.707107, oz = 0, ow = -0.707107, cell = 1},
		{templateFile = "object/tangible/travel/ticket_collector/ticket_collector.iff", x = 1, z = 0, y = -10, ox = 0, oy = 0, oz = 0, ow = 1},
		{templateFile = "object/mobile/player_transport.iff", x = 0, z = 7, y = 0, ox = 0, oy = 0.707107, oz = 0, ow = 0.707107}
	}
}

registerScreenPlay("KashyyykTravelScreenPlay", true)

function KashyyykTravelScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self.present = 0
		self.spawned = 0
		self:ensureTravelChildren()
		print("[kashyyyk_main] travel children: present=" .. self.present .. " spawned=" .. self.spawned)
	end
end

-- Match SceneObjectImplementation::createChildObjects outdoor placement:
-- yaw-rotate the template offset by the building heading, then add the
-- building position. Child quaternion is rotated the same way
-- (Quaternion::rotate around +Y by getDirectionAngle degrees).
function KashyyykTravelScreenPlay:worldPose(pBuilding, entry)
	local bx = SceneObject(pBuilding):getPositionX()
	local bz = SceneObject(pBuilding):getPositionZ()
	local by = SceneObject(pBuilding):getPositionY()
	local degrees = SceneObject(pBuilding):getDirectionAngle()
	local angle = math.rad(degrees)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)
	local wx = (cosA * entry.x) + (entry.y * sinA) + bx
	local wy = (cosA * entry.y) - (entry.x * sinA) + by
	local wz = bz + entry.z
	local half = angle * 0.5
	local c = math.cos(half)
	local s = math.sin(half)
	-- q_yaw(c, 0, s, 0) * q_child
	local ow = (c * entry.ow) - (s * entry.oy)
	local ox = (c * entry.ox) + (s * entry.oz)
	local oy = (c * entry.oy) + (s * entry.ow)
	local oz = (c * entry.oz) - (s * entry.ox)

	return wx, wz, wy, ow, ox, oy, oz
end

function KashyyykTravelScreenPlay:childPresent(pBuilding, entry, index)
	local oid = readData("KashyyykTravel:" .. self.planet .. ":oid:" .. index)
	local pObj = getSceneObject(oid)

	if (self:matchesChild(pBuilding, pObj, entry)) then
		return true
	end

	local childIndex = 0
	local pChild = SceneObject(pBuilding):getChildObject(childIndex)
	while (pChild ~= nil) do
		if (self:matchesChild(pBuilding, pChild, entry)) then
			writeData("KashyyykTravel:" .. self.planet .. ":oid:" .. index, SceneObject(pChild):getObjectID())
			return true
		end
		childIndex = childIndex + 1
		pChild = SceneObject(pBuilding):getChildObject(childIndex)
	end

	return false
end

function KashyyykTravelScreenPlay:matchesChild(pBuilding, pObj, entry)
	if (pObj == nil or SceneObject(pObj):getZoneName() ~= self.planet) then
		return false
	end

	if (entry.cell ~= nil) then
		local pCell = BuildingObject(pBuilding):getCell(entry.cell)
		return pCell ~= nil and SceneObject(pObj):getParentID() == SceneObject(pCell):getObjectID()
			and SceneObject(pObj):getTemplateObjectPath() == entry.templateFile
	end

	return SceneObject(pObj):getTemplateObjectPath() == entry.templateFile
		and SceneObject(pBuilding):getDistanceTo(pObj) <= 20
end

function KashyyykTravelScreenPlay:spawnIfMissing(pBuilding, entry, index)
	if (self:childPresent(pBuilding, entry, index)) then
		self.present = self.present + 1
		return
	end

	local wx, wz, wy, ow, ox, oy, oz = self:worldPose(pBuilding, entry)
	local parentID = 0
	if (entry.cell ~= nil) then
		local pCell = BuildingObject(pBuilding):getCell(entry.cell)
		if (pCell == nil) then
			print("[kashyyyk_main] travel: missing starport cell " .. entry.cell)
			return
		end
		parentID = SceneObject(pCell):getObjectID()
		wx, wz, wy = entry.x, entry.z, entry.y
		ow, ox, oy, oz = entry.ow, entry.ox, entry.oy, entry.oz
	end
	-- parent 0: outdoor. spawnSceneObject zone-transfers, which is what
	-- ShuttleZoneComponent::notifyInsertToZone needs to ScheduleShuttleTask
	-- and PlanetTravelPoint::setShuttle.
	local pObj = spawnSceneObject(self.planet, entry.templateFile, wx, wz, wy, parentID, ow, ox, oy, oz)

	if (pObj == nil) then
		print("[kashyyyk_main] travel spawn failed: " .. entry.templateFile)
		return
	end

	writeData("KashyyykTravel:" .. self.planet .. ":oid:" .. index, SceneObject(pObj):getObjectID())
	self.spawned = self.spawned + 1
end

function KashyyykTravelScreenPlay:ensureTravelChildren()
	local pBuilding = getSceneObject(self.POST_ID)

	if (pBuilding == nil or SceneObject(pBuilding):getZoneName() ~= self.planet) then
		print("[kashyyyk_main] travel: starport " .. self.POST_ID .. " not in zone")
		return
	end

	for i = 1, #self.travelChildren, 1 do
		self:spawnIfMissing(pBuilding, self.travelChildren[i], i)
	end
end

-- Kashyyyk Hunting Grounds Outpost travel children (ruling 2026-09-04:
-- "ensure kashyyyk is fully done, including any space work").
-- The shuttleport at snapshot node 6295268 already exists in a warm
-- clientobjects DB, so BuildingObject::createChildObjects is never walked
-- again (same ZoneServerImplementation early-return the Meatlump hideout
-- hit). Those children are outdoor (cellid -1), so a cell container walk
-- does not apply. Lua has no getObjectsInRange / getCloseObjects /
-- PlanetTravelPoint::getShuttle binding; SceneObject:getChildObject throws
-- ArrayIndexOutOfBoundsException on an empty childObjects vector (the warm
-- DB case). Detection is therefore getSceneObject on OIDs stored with
-- writeData (DirectorSharedMemory, process lifetime) plus a 20 m
-- getDistanceTo check against the post.

KashyyykTravelScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykTravelScreenPlay",
	planet = "kashyyyk",

	-- snapshot node for mun_kash_shuttlepost_s01 at the Hunting Grounds
	-- Outpost travel point
	POST_ID = 6295268,

	-- offsets / headings copied from mun_kash_shuttlepost_s01.lua childObjects
	travelChildren = {
		{templateFile = "object/tangible/terminal/terminal_travel.iff", x = -8, z = 0, y = -6, ox = 0, oy = -0.707107, oz = 0, ow = 0.707107},
		{templateFile = "object/tangible/travel/ticket_collector/ticket_collector.iff", x = -8, z = 0, y = 6, ox = 0, oy = -0.707107, oz = 0, ow = 0.707107},
		{templateFile = "object/creature/npc/theme_park/player_shuttle.iff", x = 0, z = 0, y = 0, ox = 0, oy = 1, oz = 0, ow = 0}
	}
}

registerScreenPlay("KashyyykTravelScreenPlay", true)

function KashyyykTravelScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self.present = 0
		self.spawned = 0
		self:ensureTravelChildren()
		print("[kashyyyk] travel children: present=" .. self.present .. " spawned=" .. self.spawned)
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
	local oid = readData("KashyyykTravel:oid:" .. index)
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		return false
	end

	if (SceneObject(pObj):getTemplateObjectPath() ~= entry.templateFile) then
		return false
	end

	if (SceneObject(pBuilding):getDistanceTo(pObj) > 20) then
		return false
	end

	return true
end

function KashyyykTravelScreenPlay:spawnIfMissing(pBuilding, entry, index)
	if (self:childPresent(pBuilding, entry, index)) then
		self.present = self.present + 1
		return
	end

	local wx, wz, wy, ow, ox, oy, oz = self:worldPose(pBuilding, entry)
	-- parent 0: outdoor. spawnSceneObject zone-transfers, which is what
	-- ShuttleZoneComponent::notifyInsertToZone needs to ScheduleShuttleTask
	-- and PlanetTravelPoint::setShuttle.
	local pObj = spawnSceneObject(self.planet, entry.templateFile, wx, wz, wy, 0, ow, ox, oy, oz)

	if (pObj == nil) then
		print("[kashyyyk] travel spawn failed: " .. entry.templateFile)
		return
	end

	writeData("KashyyykTravel:oid:" .. index, SceneObject(pObj):getObjectID())
	self.spawned = self.spawned + 1
end

function KashyyykTravelScreenPlay:ensureTravelChildren()
	local pBuilding = getSceneObject(self.POST_ID)

	if (pBuilding == nil) then
		print("[kashyyyk] travel: shuttlepost " .. self.POST_ID .. " not in zone")
		return
	end

	for i = 1, #self.travelChildren, 1 do
		self:spawnIfMissing(pBuilding, self.travelChildren[i], i)
	end
end

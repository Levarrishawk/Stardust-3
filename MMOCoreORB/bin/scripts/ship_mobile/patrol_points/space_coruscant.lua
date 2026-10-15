space_coruscant = SpacePatrolPointTable:new {}

-- Two crossing traffic decks below the military formation. Alternate lanes
-- start at opposite ends; every route stays inside the +/-8 km space boundary.
for lane = 1, 6 do
	local direction = lane % 2 == 1 and 1 or -1
	local offset = -6000 + (lane - 1) * 2400
	for point = 0, 6 do
		local along = direction * (-6200 + point * (12400 / 6))
		table.insert(space_coruscant, {
			patrolPointName = "coruscant_eastwest_" .. lane .. "_" .. string.format("%02d", point),
			x = along, z = -1600, y = offset,
		})
		table.insert(space_coruscant, {
			patrolPointName = "coruscant_northsouth_" .. lane .. "_" .. string.format("%02d", point),
			x = offset, z = -2800, y = along,
		})
	end
end

SpacePatrolPoints:addSpacePatrolPoints(space_coruscant, "space_coruscant")

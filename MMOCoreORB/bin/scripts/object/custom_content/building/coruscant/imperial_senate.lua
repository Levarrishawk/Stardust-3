local panelTemplate = "object/tangible/terminal/senate_delegation_lift.iff"

-- Child coordinates are building-local. In this table z is height.
local function liftPanel(cell, x, height, y, heading)
	return {
		templateFile = panelTemplate, cellid = cell, containmentType = -1,
		x = x, z = height + 0.24, y = y,
		ow = math.cos(heading / 2), ox = 0, oy = math.sin(heading / 2), oz = 0
	}
end

local panels = { liftPanel(1, 12.89, 0, -116.859, -math.pi / 2) }
local angle = math.pi / 16
for row = 0, 13 do
	local backWall = (67 + row * 7) * math.cos(math.pi / 64) + 6.365
	table.insert(panels, liftPanel(2, backWall * math.sin(angle), -40 + row * 8,
		-backWall * math.cos(angle), -angle))
end

object_building_coruscant_imperial_senate = object_building_coruscant_shared_imperial_senate:new {
	totalCellNumber = 2,
	childObjects = panels
}
ObjectTemplates:addTemplate(object_building_coruscant_imperial_senate, "object/building/coruscant/imperial_senate.iff")

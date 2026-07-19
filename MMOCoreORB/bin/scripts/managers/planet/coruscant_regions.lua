-- Planet Region Definitions
--
-- {"regionName", x, y, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- For circle and ring, x and y are the center point
-- For rectangles, x and y are the bottom left corner. x2 and y2 (see below) are the upper right corner
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {CIRCLE, radius}
--   - Rectangle: {RECTANGLE, x2, y2}
--   - Ring: {RING, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.

require("scripts.managers.planet.regions")

coruscant_regions = {
	-- No Build Zones


	-- Cities
	{"@coruscant_region_names:spaceport_district", -114, 3227, {CIRCLE, 300}, CITY + NOSPAWNAREA},
	{"@coruscant_region_names:entertainment_district", 2248, -4462, {CIRCLE, 300}, CITY + NOSPAWNAREA},
	{"@coruscant_region_names:monument_square", 1566, 662, {CIRCLE, 300}, CITY + NOSPAWNAREA},
	{"@coruscant_region_names:coco_district", -1918, -134, {CIRCLE, 300}, CITY + NOSPAWNAREA},
	{"@coruscant_region_names:palace_district", -472, 6679, {CIRCLE, 300}, CITY + NOSPAWNAREA},
	{"@coruscant_region_names:lower_city_1312", -5766, -4889, {CIRCLE, 300}, CITY + NOSPAWNAREA},

	

	--{"@corellia_region_names:world_spawner", 0, 0, {RECTANGLE, 0, 0}, WORLDSPAWNAREA + SPAWNAREA, {"corellia_world"}, 2048}
}
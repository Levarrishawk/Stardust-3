-- Planet Region Definitions
-- This file has been generated with the SWGEmu World Spawner Tool.
--
-- {"regionName", xCenter, yCenter, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {1, radius}
--   - Rectangle: {2, width, height}
--   - Ring: {3, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.

require("scripts.managers.planet.regions")

chandrila_regions = {
       
  {"@chandrila_region_names:hanna", 294, -2938, {CIRCLE, 800}, CITY + NOSPAWNAREA},
  {"hanna_nobuild_1", 1151, -1383, {CIRCLE, 1000}, CAMPINGAREA + NOBUILDZONEAREA},               
  {"@corellia_region_names:world_spawner", 0, 0, {RECTANGLE, 0, 0}, WORLDSPAWNAREA + SPAWNAREA, {"corellia_world"}, 2048}

}

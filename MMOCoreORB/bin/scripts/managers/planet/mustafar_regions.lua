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

--[[ 

Mustafar Creature Spawn Groups
- mustafar_lava_fleas
- mustafar_blistmoks
- mustafar_tulrus
- mustafar_tanrays
- mustafar_xandanks
- mustafar_jundaks
- mustafar_kubaza_beetles

--]]

mustafar_regions = {  
  -- Mensix Region
  {"mensix_southwest_1", -3396, 1305, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"mensix_southwest_2", -3439, 902, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"mensix_southwest_3", -3367, 510, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"mensix_southwest_4", -3266, 122, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"mensix_southwest_5", -3642, -30, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"mensix_southwest_6", -4063, 92, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_southwest_7", -4171, 479, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_southwest_8", -4042, 866, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_southwest_9", -3952, 1264, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_southwest_10", -3672, 1570, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_southwest_10", -3672, 1570, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_southwest_11", -3448, 1905, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},  
  {"mensix_southwest_11", -3448, 1905, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_1", -3600, 2274, {1, 400}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_1", -3600, 2274, {1, 400}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"mensix_west_2", -3600, 2274, {1, 300}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_west_3", -2776, 2414, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_3", -2776, 2414, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_west_4", -3562, 2393, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_4", -3562, 2393, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"mensix_west_5", -3946, 2484, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_5", -3946, 2484, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_west_6", -4357, 2519, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_6", -4357, 2519, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_west_7", -4719, 2340, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256}, 
  {"mensix_west_7", -4719, 2340, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256}, 
  {"mensix_west_8", -5104, 2159, {1, 250}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_west_9", -5591, 2173, {1, 250}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_west_10", -5591, 2173, {1, 500}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_west_11", -5960, 871, {1, 300}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_west_12", -5933, 459, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  {"mensix_west_13", -5933, 459, {1, 750}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  -- Old Mining Facility Region
  {"old_mining_facility_1", -2774, 279, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_2", -2746, 681, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_3", -2417, 911, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_4", -2053, 731, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_5", -1752, 455, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_6", -1487, 135, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_7", -1109, -8, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_8", -710, 53, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_9", -303, 62, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  {"old_mining_facility_10", 88, -132, {1, 200}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_lava_fleas"}, 256},
  -- Tulrus Isle
  {"tulrus_isle_1", -1491, 2239, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256}, 
  {"tulrus_isle_2", -1720, 2573, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256}, 
  {"tulrus_isle_2", -1720, 2573, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256},
  {"tulrus_isle_3", -1748, 3016, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256}, 
  {"tulrus_isle_3", -1748, 3016, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256}, 
  {"tulrus_isle_4", -1751, 3424, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256},
  {"tulrus_isle_4", -1751, 3424, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"tulrus_isle_5", -1781, 3814, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"tulrus_isle_5", -1781, 3814, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256}, 
  {"tulrus_isle_6", -1999, 4194, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256},
  {"tulrus_isle_6", -1999, 4194, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"tulrus_isle_7", -1056, 2463, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"tulrus_isle_8", -1113, 2879, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"tulrus_isle_8", -1113, 2879, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_jundaks"}, 256},
  -- Berkens Flow
  {"berkens_1", -494, 3619, {1, 250}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_1", -494, 3619, {1, 250}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_1a", -494, 3619, {1, 250}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tanrays"}, 256},
  {"berkens_2", -453, 4064, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_2", -453, 4064, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_3", -616, 4433, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_3", -616, 4433, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_3a", -616, 4433, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_4", -616, 4433, {1, 300}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_4", -616, 4433, {1, 300}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_4a", -616, 4433, {1, 300}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_tanrays"}, 256},
  {"berkens_4a", -616, 4433, {1, 300}, NOBUILDZONEAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_5", -474, 5120, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_5", -474, 5120, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_6", -106, 5143, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tulrus"}, 256},
  {"berkens_6", -106, 5143, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_7", -106, 5143, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_7", -106, 5143, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_8", -494, 3619, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_8", -494, 3619, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_8a", -494, 3619, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tanrays"}, 256},
  {"berkens_9", 495, 5732, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256}, 
  {"berkens_9", 495, 5732, {1, 200}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"berkens_10", 51, 5753, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_tanrays"}, 256},
  {"berkens_10", 51, 5753, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_xandanks"}, 256},
  {"berkens_10", 51, 5753, {1, 450}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  -- Burning Plains
  -- Not produced by the World Spawner Tool: the block bounded by the NGE mining
  -- field markers (x -2100..-4500, y 4590..5920) had no spawn region at all, so
  -- the documented "kill 5 Kubaza Beetles in the Burning Plain" objective had no
  -- creatures anywhere near any of the three waypoints the NGE guide quotes for
  -- it. These are plain SPAWNAREA -- they layer kubaza beetles onto the plain
  -- without suppressing the planet-wide world_spawner or changing build rules.
  -- Centres are the NGE marker positions plus the guide's own alternates.
  {"burning_plains_1", -2805, 5131, {1, 400}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"burning_plains_2", -2789, 5921, {1, 400}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"burning_plains_3", -2155, 5511, {1, 300}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"burning_plains_4", -4490, 5905, {1, 400}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"burning_plains_5", -2776, 4593, {1, 300}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"burning_plains_6", -3955, 5328, {1, 400}, SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  -- Smoking Forest
  {"smoking_forest_1", -5464, 4110, {1, 1000}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_kubaza_beetles"}, 256},
  {"smoking_forest_2", -5464, 4110, {1, 1000}, NOWORLDSPAWNAREA + SPAWNAREA, {"mustafar_blistmoks"}, 256},
  -- Storm Lord Ruins
  -- SPAWNAREA added: the row names a spawn group, but PlanetManagerImplementation.cpp:1069
  -- only reads argument 6 when that flag is set, so this was built as a plain region_area
  -- and mustafar_storm_lord_minions never spawned. setRegionFlags runs first at :1067, so
  -- NOWORLDSPAWNAREA still applied -- the 500 m circle suppressed the planet-wide spawner
  -- and supplied nothing in its place. Flag order matches smoking_forest_1/_2 above.
  {"storm_lord_ruins", 193, 4163, {1, 500}, NOWORLDSPAWNAREA + SPAWNAREA + NOBUILDZONEAREA, {"mustafar_storm_lord_minions"}, 256},
  -- Areas Cleared of World Spawns
  -- Re-centred from (-6170, 10). The camp it is meant to clear is the 13 mobiles at
  -- screenplays/mustafar/regions/mensix_facility_region.lua:68-93, which span
  -- x -6059..-5998.9 and y -73.0..73.7. Against the old centre every one of the 13 sat
  -- 111.4-181.1 m out, i.e. entirely outside the 100 m circle, so the camp was exposed to
  -- the mensix_west_13 blistmoks and the planet-wide lava fleas. -6029, 0 is the bounding
  -- box centre of those 13; it brings the farthest in to 75.7 m, so the shipped radius is
  -- left at 100 rather than widened.
  {"sw_bandit_camp", -6029, 0, {1, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
  {"mensix_mining_facility", -2601, 1635, {1, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
  {"striking_miner_camp", -5335, 4429, {1, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
  {"blackguard_jedi_ruins", -4373, 3255, {1, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
  {"nw_jedi_ruins", -5424, 6028, {1, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
  -- World Spawns
  {"world_spawner", 0, 0, {1, -1}, SPAWNAREA + WORLDSPAWNAREA, {"mustafar_lava_fleas"}, 2048}
}

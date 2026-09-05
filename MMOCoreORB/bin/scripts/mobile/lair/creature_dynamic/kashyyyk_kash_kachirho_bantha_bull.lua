-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_bantha_bull.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_kachirho_bantha -> kashyyyk_bull_bantha  size=4  (creatures.tab line 1392; lua kashyyyk_bull_bantha.lua) [picked 1 of 2 the creature table lua matches]
--   ep3_kachirho_bantha -> kashyyyk_bull_bantha  size=4  (creatures.tab line 1392; lua kashyyyk_bull_bantha.lua) [picked 1 of 2 the creature table lua matches]
--   ep3_kachirho_bantha_matriarch -> kashyyyk_matriarch_bantha  size=4  (creatures.tab line 1394; lua kashyyyk_matriarch_bantha.lua) [picked 1 of 2 the creature table lua matches]
--   ep3_kachirho_bantha_matriarch -> kashyyyk_matriarch_bantha  size=4  (creatures.tab line 1394; lua kashyyyk_matriarch_bantha.lua) [picked 1 of 2 the creature table lua matches]
--   ep3_kachirho_bantha_bull -> kashyyyk_bull_bantha  size=4  (creatures.tab line 1393; lua kashyyyk_bull_bantha.lua) [picked 1 of 2 the creature table lua matches]
--   ep3_kachirho_bantha_bull -> kashyyyk_bull_bantha  size=4  (creatures.tab line 1393; lua kashyyyk_bull_bantha.lua) [picked 1 of 2 the creature table lua matches]
kashyyyk_kash_kachirho_bantha_bull = Lair:new {
	mobiles = {{"kashyyyk_bull_bantha",4},{"kashyyyk_bull_bantha",4},{"kashyyyk_matriarch_bantha",4},{"kashyyyk_matriarch_bantha",4},{"kashyyyk_bull_bantha",4},{"kashyyyk_bull_bantha",4}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_bantha_bull", kashyyyk_kash_kachirho_bantha_bull)

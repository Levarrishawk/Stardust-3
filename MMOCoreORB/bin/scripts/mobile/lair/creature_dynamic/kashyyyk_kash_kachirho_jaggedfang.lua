-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_jaggedfang.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_kachirho_varactyl_jaggedfang -> varactyl_jagged_fang  size=4  (creatures.tab line 1410; lua varactyl_jagged_fang.lua) [picked 1 of 4 the creature table lua matches]
kashyyyk_kash_kachirho_jaggedfang = Lair:new {
	mobiles = {{"varactyl_jagged_fang",4}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_jaggedfang", kashyyyk_kash_kachirho_jaggedfang)

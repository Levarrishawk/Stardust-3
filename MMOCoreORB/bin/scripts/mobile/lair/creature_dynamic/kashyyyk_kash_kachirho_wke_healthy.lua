-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_healthy.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_kachirho_wke_healthy -> ep3_wke_civilian_05  size=1  (creatures.tab line 1416; lua ep3_wke_civilian_05.lua)
kashyyyk_kash_kachirho_wke_healthy = Lair:new {
	mobiles = {{"ep3_wke_civilian_05",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_wke_healthy", kashyyyk_kash_kachirho_wke_healthy)

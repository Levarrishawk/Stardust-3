-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_canopy_boss.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_kachirho_canopy_reaper -> ep3_canopy_reaper_01  size=1  (creatures.tab line 1401; lua ep3_canopy_reaper_01.lua)
--   ep3_kachirho_canopy_reaper -> ep3_canopy_reaper_01  size=1  (creatures.tab line 1401; lua ep3_canopy_reaper_01.lua)
--   ep3_kachirho_canopy_reaper -> ep3_canopy_reaper_01  size=1  (creatures.tab line 1401; lua ep3_canopy_reaper_01.lua)
--   ep3_kachirho_canopy_boss -> ep3_canopy_boss  size=1  (creatures.tab line 1399; lua ep3_canopy_boss.lua)
kashyyyk_kash_kachirho_canopy_boss = Lair:new {
	mobiles = {{"ep3_canopy_reaper_01",1},{"ep3_canopy_reaper_01",1},{"ep3_canopy_reaper_01",1},{"ep3_canopy_boss",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_canopy_boss", kashyyyk_kash_kachirho_canopy_boss)

-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/ep3_qst_wke_wrhisch.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; C6 line):
--   ep3_qst_wrhisch -> ep3_wrhisch  size=1  (C6 creatures.tab line 1497; lua ep3_wrhisch.lua)
kashyyyk_ep3_qst_wke_wrhisch = Lair:new {
	mobiles = {{"ep3_wrhisch",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_ep3_qst_wke_wrhisch", kashyyyk_ep3_qst_wke_wrhisch)

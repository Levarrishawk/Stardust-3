-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/ep3_qst_anguished_wookiee.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_qst_anguished_wookiee -> ep3_anguished_wookiee_01  size=1  (creatures.tab line 1485; lua ep3_anguished_wookiee_01.lua) [picked 1 of 5 the creature table lua matches]
kashyyyk_ep3_qst_anguished_wookiee = Lair:new {
	mobiles = {{"ep3_anguished_wookiee_01",1}},
	spawnLimit = 2,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_ep3_qst_anguished_wookiee", kashyyyk_ep3_qst_anguished_wookiee)

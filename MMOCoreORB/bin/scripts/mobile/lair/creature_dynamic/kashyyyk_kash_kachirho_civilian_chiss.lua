-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_civilian_chiss.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; C6 line):
--   ep3_kachirho_chiss_villager -> ep3_etyyy_chiss_poacher_01  size=1  (C6 creatures.tab line 1404; lua ep3_etyyy_chiss_poacher_01.lua) [picked 1 of 25 C6 lua matches]
kashyyyk_kash_kachirho_civilian_chiss = Lair:new {
	mobiles = {{"ep3_etyyy_chiss_poacher_01",1}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_civilian_chiss", kashyyyk_kash_kachirho_civilian_chiss)

-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kkowir_tagged_wookiee.tab
-- ruling 2026-09-04: dead-forest surface spawns (K-5). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_qst_wookiee_tagged -> ep3_wke_civilian_01  size=1  set-matched (SOE template column = ep3_wookiee_civilians; repo numbered members; C6 creatures.tab line 1496)
kashyyyk_kash_kkowir_tagged_wookiee = Lair:new {
	mobiles = {{"ep3_wke_civilian_01",1}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kkowir_tagged_wookiee", kashyyyk_kash_kkowir_tagged_wookiee)

-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_stalkers.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3.1). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_wookiee_forest_stalker -> ep3_wke_forest_stalker_01  size=1  set-matched (SOE template column = ep3_wke_stalkers; repo numbered members ep3_wke_forest_stalker_01.._03)
kashyyyk_kash_kachirho_wke_stalkers = Lair:new {
	mobiles = {{"ep3_wke_forest_stalker_01",1}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_wke_stalkers", kashyyyk_kash_kachirho_wke_stalkers)

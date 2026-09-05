-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/forest_blackscale_guard.tab
-- ruling 2026-09-04: dead-forest surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_forest_blackscale_guard -> ep3_blackscale_guard_m_01  size=1  set-rotate (creatures.tab line 1341; rotate numbered variants (4 the creature table lua matches))
kashyyyk_forest_blackscale_guard = Lair:new {
	mobiles = {{"ep3_blackscale_guard_m_01",1}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_forest_blackscale_guard", kashyyyk_forest_blackscale_guard)

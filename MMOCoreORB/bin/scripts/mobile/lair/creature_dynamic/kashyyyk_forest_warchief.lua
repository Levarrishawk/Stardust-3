-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/forest_warchief.tab
-- ruling 2026-09-04: dead-forest surface spawns (K-5). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_forest_warchief -> dressed_ep3_forest_warchief  size=1  iff-matched (repo templates iff equals SOE template column dressed_ep3_forest_warchief.iff; C6 creatures.tab line 1371; C6 scout skipped custom_content/mobile/; level-4 placeholder today, C6 revisits levels))
kashyyyk_forest_warchief = Lair:new {
	mobiles = {{"dressed_ep3_forest_warchief",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_forest_warchief", kashyyyk_forest_warchief)

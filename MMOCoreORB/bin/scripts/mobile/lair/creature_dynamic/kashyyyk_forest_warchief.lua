-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/forest_warchief.tab
-- ruling 2026-09-04: dead-forest surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_forest_warchief -> dressed_ep3_forest_warchief  size=1  iff-matched (repo templates iff equals SOE template column dressed_ep3_forest_warchief.iff; creatures.tab line 1371; level-4 placeholder today, the level curve is an open ruling))
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

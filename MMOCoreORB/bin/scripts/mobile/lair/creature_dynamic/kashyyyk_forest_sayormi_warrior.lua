-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/forest_sayormi_warrior.tab
-- ruling 2026-09-04: dead-forest surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_forest_sayormi_warrior -> dressed_sayormi_warrior_01  size=1  set-matched (SOE template column = ep3_forest_sayormi_warrior; repo numbered members; creatures.tab line 1363)
kashyyyk_forest_sayormi_warrior = Lair:new {
	mobiles = {{"dressed_sayormi_warrior_01",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_forest_sayormi_warrior", kashyyyk_forest_sayormi_warrior)

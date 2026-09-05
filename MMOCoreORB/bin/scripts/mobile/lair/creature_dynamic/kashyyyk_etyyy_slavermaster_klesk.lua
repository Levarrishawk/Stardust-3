-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_slavermaster_klesk.tab
-- ruling 2026-09-04: hunting-grounds surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_qst_slavemaster_klesk -> ep3_slavemaster_klesk  size=2  iff-match (creatures.tab line 1491; lua ep3_slavemaster_klesk.lua)
kashyyyk_etyyy_slavermaster_klesk = Lair:new {
	mobiles = {{"ep3_slavemaster_klesk",2}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_slavermaster_klesk", kashyyyk_etyyy_slavermaster_klesk)

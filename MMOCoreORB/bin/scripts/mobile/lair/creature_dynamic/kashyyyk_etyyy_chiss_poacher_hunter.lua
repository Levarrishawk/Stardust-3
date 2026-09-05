-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_chiss_poacher_hunter.tab
-- ruling 2026-09-04: hunting-grounds surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hunter_01  size=2  set-rotate (creatures.tab line 1291; rotate numbered variants (4 the creature table lua matches))
--   ep3_etyyy_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hunter_02  size=2  set-rotate (creatures.tab line 1291; rotate numbered variants (4 the creature table lua matches))
--   ep3_etyyy_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hunter_03  size=2  set-rotate (creatures.tab line 1291; rotate numbered variants (4 the creature table lua matches))
--   ep3_etyyy_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hunter_04  size=2  set-rotate (creatures.tab line 1291; rotate numbered variants (4 the creature table lua matches))
--   ep3_etyyy_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hunter_01  size=2  set-rotate (creatures.tab line 1291; rotate numbered variants (4 the creature table lua matches))
--   ep3_etyyy_chiss_poacher_defender -> ep3_etyyy_chiss_poacher_defender_01  size=2  set-rotate (creatures.tab line 1290; rotate numbered variants (4 the creature table lua matches))
kashyyyk_etyyy_chiss_poacher_hunter = Lair:new {
	mobiles = {{"ep3_etyyy_chiss_poacher_hunter_01",2},{"ep3_etyyy_chiss_poacher_hunter_02",2},{"ep3_etyyy_chiss_poacher_hunter_03",2},{"ep3_etyyy_chiss_poacher_hunter_04",2},{"ep3_etyyy_chiss_poacher_hunter_01",2},{"ep3_etyyy_chiss_poacher_defender_01",2}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_chiss_poacher_hunter", kashyyyk_etyyy_chiss_poacher_hunter)

-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_chiss_poacher.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_chiss_poacher -> ep3_etyyy_chiss_poacher_01  size=2  set-rotate (creatures.tab line 1289; rotate numbered variants ep3_etyyy_chiss_poacher_01.._05 (not defender/hracca/hunter/smuggler))
--   ep3_etyyy_chiss_poacher -> ep3_etyyy_chiss_poacher_02  size=2  set-rotate (creatures.tab line 1289; rotate numbered variants ep3_etyyy_chiss_poacher_01.._05 (not defender/hracca/hunter/smuggler))
--   ep3_etyyy_chiss_poacher -> ep3_etyyy_chiss_poacher_03  size=2  set-rotate (creatures.tab line 1289; rotate numbered variants ep3_etyyy_chiss_poacher_01.._05 (not defender/hracca/hunter/smuggler))
kashyyyk_etyyy_chiss_poacher = Lair:new {
	mobiles = {{"ep3_etyyy_chiss_poacher_01",2},{"ep3_etyyy_chiss_poacher_02",2},{"ep3_etyyy_chiss_poacher_03",2}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_chiss_poacher", kashyyyk_etyyy_chiss_poacher)

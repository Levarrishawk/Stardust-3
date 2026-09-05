-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_chiss_poacher_defender.tab
-- ruling 2026-09-04: hunting-grounds surface spawns (K-4). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_chiss_poacher_defender -> ep3_etyyy_chiss_poacher_defender_01  size=2  c6-rotate (C6 creatures.tab line 1290; rotate numbered variants (4 C6 lua matches))
--   ep3_etyyy_chiss_poacher_defender -> ep3_etyyy_chiss_poacher_defender_02  size=2  c6-rotate (C6 creatures.tab line 1290; rotate numbered variants (4 C6 lua matches))
--   ep3_etyyy_chiss_poacher_defender -> ep3_etyyy_chiss_poacher_defender_03  size=2  c6-rotate (C6 creatures.tab line 1290; rotate numbered variants (4 C6 lua matches))
kashyyyk_etyyy_chiss_poacher_defender = Lair:new {
	mobiles = {{"ep3_etyyy_chiss_poacher_defender_01",2},{"ep3_etyyy_chiss_poacher_defender_02",2},{"ep3_etyyy_chiss_poacher_defender_03",2}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_chiss_poacher_defender", kashyyyk_etyyy_chiss_poacher_defender)

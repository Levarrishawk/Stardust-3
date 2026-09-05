-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_clan_tripp.tab
-- ruling 2026-09-04: hunting-grounds surface spawns (K-4). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_rodian_trippclan -> ep3_etyyy_hunter_trippclan_01  size=2  set-matched (SOE template column = etyyy_rodian_trippclan; repo numbered members; C6 creatures.tab line 1471)
kashyyyk_etyyy_clan_tripp = Lair:new {
	mobiles = {{"ep3_etyyy_hunter_trippclan_01",2}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_clan_tripp", kashyyyk_etyyy_clan_tripp)

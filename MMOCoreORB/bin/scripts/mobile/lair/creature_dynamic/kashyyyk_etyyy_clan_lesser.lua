-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_clan_lesser.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_rodian_lesser_hunter -> ep3_etyyy_hunter_lesser_rodian_01  size=2  set-matched (SOE template column = etyyy_rodian_lesser_hunter; repo numbered members ep3_etyyy_hunter_lesser_rodian_01.._04)
kashyyyk_etyyy_clan_lesser = Lair:new {
	mobiles = {{"ep3_etyyy_hunter_lesser_rodian_01",2}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_clan_lesser", kashyyyk_etyyy_clan_lesser)

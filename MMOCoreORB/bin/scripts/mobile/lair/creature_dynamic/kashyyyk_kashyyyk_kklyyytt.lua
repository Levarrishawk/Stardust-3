-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kashyyyk_kklyyytt.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3.1). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_kklyyytt -> ep3_kklyyytt  size=4  iff-matched (repo templates iff equals SOE template column; level-4 placeholder today, C6 revisits levels)
kashyyyk_kashyyyk_kklyyytt = Lair:new {
	mobiles = {{"ep3_kklyyytt",4}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kashyyyk_kklyyytt", kashyyyk_kashyyyk_kklyyytt)

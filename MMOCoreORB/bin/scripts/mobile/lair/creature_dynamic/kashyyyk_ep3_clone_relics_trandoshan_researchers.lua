-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/ep3_clone_relics_trandoshan_researchers.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   clone_relics_trandoshan_researcher -> ep3_clone_relics_trandoshan_researcher  size=10  (creatures.tab line 549; lua ep3_clone_relics_trandoshan_researcher.lua) [picked 1 of 9 the creature table lua matches]
kashyyyk_ep3_clone_relics_trandoshan_researchers = Lair:new {
	mobiles = {{"ep3_clone_relics_trandoshan_researcher",10}},
	spawnLimit = 8,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_ep3_clone_relics_trandoshan_researchers", kashyyyk_ep3_clone_relics_trandoshan_researchers)

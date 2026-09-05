-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_scout_troopers.tab
-- ruling 2026-09-04: dead-forest surface spawns (K-5). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   scout_trooper -> scout_trooper  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/imperial/scout_trooper.lua; C6 creatures.tab line n/a))
--   scout_trooper -> scout_trooper  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/imperial/scout_trooper.lua; C6 creatures.tab line n/a))
--   scout_trooper -> scout_trooper  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/imperial/scout_trooper.lua; C6 creatures.tab line n/a))
kashyyyk_rryatt_scout_troopers = Lair:new {
	mobiles = {{"scout_trooper",4},{"scout_trooper",4},{"scout_trooper",4}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_scout_troopers", kashyyyk_rryatt_scout_troopers)

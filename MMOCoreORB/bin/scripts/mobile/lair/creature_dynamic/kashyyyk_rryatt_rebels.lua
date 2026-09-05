-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_rebels.tab
-- ruling 2026-09-04: rryatt trail levels 1 and 2 (K-11a). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5/K-11b/K-11a: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   rebel_commando -> rebel_commando  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/rebel/rebel_commando.lua; C6 creatures.tab line n/a))
--   rebel_commando -> rebel_commando  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/rebel/rebel_commando.lua; C6 creatures.tab line n/a))
--   rebel_commando -> rebel_commando  size=4  exact-name (exact registered name (SOE creatureName equals repo addCreatureTemplate name; lua faction/rebel/rebel_commando.lua; C6 creatures.tab line n/a))
kashyyyk_rryatt_rebels = Lair:new {
	mobiles = {{"rebel_commando",4},{"rebel_commando",4},{"rebel_commando",4}},
	spawnLimit = 5,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_rebels", kashyyyk_rryatt_rebels)

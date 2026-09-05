-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/forest_shadevale.tab
-- ruling 2026-09-04: dead-forest surface spawns (K-5.1). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template):
--   ep3_forest_shadevale_stalker -> crystal_snake  size=2  iff-matched (SOE template column crystal_snake.iff = mobile/yavin4/crystal_snake.lua templates; C6 creatures.tab line 1365)
--   ep3_forest_shadevale_venomsting -> fanned_rawl  size=2  iff-matched (SOE template column fanned_rawl.iff = mobile/naboo/fanned_rawl.lua templates (hue variant); C6 creatures.tab line 1366)
-- Both are base-game templates SOE reused for the dead forest; their levels are the repo's (OURS, as they stand).
kashyyyk_forest_shadevale = Lair:new {
	mobiles = {{"crystal_snake",2},{"fanned_rawl",2}},
	spawnLimit = 6,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_forest_shadevale", kashyyyk_forest_shadevale)

-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_abandoned_droideka.tab
-- ruling 2026-09-04: rryatt trail levels 4 and 5 (K-11b). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5/K-11b: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_abandoned_droideka -> ep3_rryatt_abandoned_droideka_01  size=6  set-matched (C6 creatures.tab line 1507; C6 unmatched_rows (set name rryatt_droideka; numbered members ep3_rryatt_abandoned_droideka_01.._02))
--   ep3_rryatt_abandoned_droideka -> ep3_rryatt_abandoned_droideka_02  size=6  set-matched (C6 creatures.tab line 1507; C6 unmatched_rows (set name rryatt_droideka; numbered members ep3_rryatt_abandoned_droideka_01.._02))
--   ep3_rryatt_abandoned_droideka -> ep3_rryatt_abandoned_droideka_01  size=6  set-matched (C6 creatures.tab line 1507; C6 unmatched_rows (set name rryatt_droideka; numbered members ep3_rryatt_abandoned_droideka_01.._02))
--   ep3_rryatt_abandoned_battle_droid -> ep3_rryatt_abandoned_battle_droid_01  size=6  set-matched (C6 creatures.tab line 1506; C6 unmatched_rows (set name rryatt_battle_droid; numbered members ep3_rryatt_abandoned_battle_droid_01.._03))
--   ep3_rryatt_abandoned_droideka -> ep3_rryatt_abandoned_droideka_02  size=6  set-matched (C6 creatures.tab line 1507; C6 unmatched_rows (set name rryatt_droideka; numbered members ep3_rryatt_abandoned_droideka_01.._02))
--   ep3_rryatt_abandoned_droideka -> ep3_rryatt_abandoned_droideka_01  size=6  set-matched (C6 creatures.tab line 1507; C6 unmatched_rows (set name rryatt_droideka; numbered members ep3_rryatt_abandoned_droideka_01.._02))
kashyyyk_rryatt_abandoned_droideka = Lair:new {
	mobiles = {{"ep3_rryatt_abandoned_droideka_01",6},{"ep3_rryatt_abandoned_droideka_02",6},{"ep3_rryatt_abandoned_droideka_01",6},{"ep3_rryatt_abandoned_battle_droid_01",6},{"ep3_rryatt_abandoned_droideka_02",6},{"ep3_rryatt_abandoned_droideka_01",6}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_abandoned_droideka", kashyyyk_rryatt_abandoned_droideka)

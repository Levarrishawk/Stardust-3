-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_feral_wookiee.tab
-- ruling 2026-09-04: rryatt trail levels 4 and 5 (K-11b). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5/K-11b: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_feral_wookiee -> ep3_rryatt_feral_wookiee_01  size=4  c6-rotate (C6 creatures.tab line 1515; rotate numbered variants ep3_rryatt_feral_wookiee_01.._04)
--   ep3_rryatt_feral_wookiee -> ep3_rryatt_feral_wookiee_02  size=4  c6-rotate (C6 creatures.tab line 1515; rotate numbered variants ep3_rryatt_feral_wookiee_01.._04)
kashyyyk_rryatt_feral_wookiee = Lair:new {
	mobiles = {{"ep3_rryatt_feral_wookiee_01",4},{"ep3_rryatt_feral_wookiee_02",4}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_feral_wookiee", kashyyyk_rryatt_feral_wookiee)

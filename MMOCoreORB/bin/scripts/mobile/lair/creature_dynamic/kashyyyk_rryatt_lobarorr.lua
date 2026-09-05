-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_lobarorr.tab
-- ruling 2026-09-04: rryatt trail levels 4 and 5. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_lobarorr -> ep3_kachirho_lobarorr  size=6  iff-match (creatures.tab line 1420; lua ep3_kachirho_lobarorr.lua)
kashyyyk_rryatt_lobarorr = Lair:new {
	mobiles = {{"ep3_kachirho_lobarorr",6}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_lobarorr", kashyyyk_rryatt_lobarorr)

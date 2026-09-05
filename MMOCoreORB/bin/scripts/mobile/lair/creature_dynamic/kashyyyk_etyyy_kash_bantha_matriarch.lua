-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_kash_bantha_matriarch.tab
-- ruling 2026-09-04: hunting-grounds surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  iff-match (creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  iff-match (creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 the creature table lua matches])
kashyyyk_etyyy_kash_bantha_matriarch = Lair:new {
	mobiles = {{"kashyyyk_bull_bantha",5},{"kashyyyk_matriarch_bantha",5},{"kashyyyk_matriarch_bantha",5},{"kashyyyk_matriarch_bantha",5},{"kashyyyk_matriarch_bantha",5},{"kashyyyk_matriarch_bantha",5},{"kashyyyk_matriarch_bantha",5}},
	spawnLimit = 5,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_kash_bantha_matriarch", kashyyyk_etyyy_kash_bantha_matriarch)

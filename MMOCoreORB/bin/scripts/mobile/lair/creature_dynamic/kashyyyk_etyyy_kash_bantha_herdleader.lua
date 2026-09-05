-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_kash_bantha_herdleader.tab
-- ruling 2026-09-04: hunting-grounds surface spawns (K-4). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  c6-match (C6 creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 C6 lua matches])
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  c6-match (C6 creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 C6 lua matches])
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  c6-match (C6 creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 C6 lua matches])
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  c6-match (C6 creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 C6 lua matches])
--   ep3_etyyy_bantha_kashyyyk_herdleader -> kashyyyk_bull_bantha  size=5  c6-match (C6 creatures.tab line 1285; lua kashyyyk_bull_bantha.lua [picked 1 of 2 C6 lua matches])
--   ep3_etyyy_bantha_kashyyyk_matriarch -> kashyyyk_matriarch_bantha  size=5  c6-match (C6 creatures.tab line 1286; lua kashyyyk_matriarch_bantha.lua [picked 1 of 2 C6 lua matches])
kashyyyk_etyyy_kash_bantha_herdleader = Lair:new {
	mobiles = {{"kashyyyk_bull_bantha",5},{"kashyyyk_bull_bantha",5},{"kashyyyk_bull_bantha",5},{"kashyyyk_bull_bantha",5},{"kashyyyk_bull_bantha",5},{"kashyyyk_matriarch_bantha",5}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_kash_bantha_herdleader", kashyyyk_etyyy_kash_bantha_herdleader)

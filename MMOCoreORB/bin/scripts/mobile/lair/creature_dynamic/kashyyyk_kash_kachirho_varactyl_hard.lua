-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_varactyl_hard.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; C6 line):
--   ep3_kachirho_varactyl_preystalker -> varactyl_preystalker  size=4  (C6 creatures.tab line 1411; lua varactyl_preystalker.lua) [picked 1 of 4 C6 lua matches]
--   ep3_kachirho_varactyl_preystalker -> varactyl_preystalker  size=4  (C6 creatures.tab line 1411; lua varactyl_preystalker.lua) [picked 1 of 4 C6 lua matches]
--   ep3_kachirho_varactyl_preystalker -> varactyl_preystalker  size=4  (C6 creatures.tab line 1411; lua varactyl_preystalker.lua) [picked 1 of 4 C6 lua matches]
--   ep3_kachirho_varactyl_deathspine -> varactyl_deathspine  size=4  (C6 creatures.tab line 1409; lua varactyl_deathspine.lua) [picked 1 of 4 C6 lua matches]
kashyyyk_kash_kachirho_varactyl_hard = Lair:new {
	mobiles = {{"varactyl_preystalker",4},{"varactyl_preystalker",4},{"varactyl_preystalker",4},{"varactyl_deathspine",4}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_varactyl_hard", kashyyyk_kash_kachirho_varactyl_hard)

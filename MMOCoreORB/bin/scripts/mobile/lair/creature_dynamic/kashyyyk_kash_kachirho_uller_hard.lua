-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_uller_hard.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; the creature table line):
--   ep3_kachirho_uller_stoneclaw -> uller_stoneclaw  size=4  (creatures.tab line 1407; lua uller_stoneclaw.lua)
--   ep3_kachirho_uller_stoneclaw -> uller_stoneclaw  size=4  (creatures.tab line 1407; lua uller_stoneclaw.lua)
--   ep3_kachirho_uller_stoneclaw -> uller_stoneclaw  size=4  (creatures.tab line 1407; lua uller_stoneclaw.lua)
--   ep3_kachirho_uller_stoneclaw -> uller_stoneclaw  size=4  (creatures.tab line 1407; lua uller_stoneclaw.lua)
kashyyyk_kash_kachirho_uller_hard = Lair:new {
	mobiles = {{"uller_stoneclaw",4},{"uller_stoneclaw",4},{"uller_stoneclaw",4},{"uller_stoneclaw",4}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_uller_hard", kashyyyk_kash_kachirho_uller_hard)

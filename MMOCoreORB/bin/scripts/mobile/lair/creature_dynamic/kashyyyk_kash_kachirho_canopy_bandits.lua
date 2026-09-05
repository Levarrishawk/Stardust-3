-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_canopy_bandits.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template; C6 line):
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_bandit  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_cutthroat  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_cutthroat  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_cutthroat  size=1  OPEN (no C6 matches entry; not guessed)
--   ep3_kachirho_canopy_reaper -> ep3_canopy_reaper_01  size=1  (C6 creatures.tab line 1401; lua ep3_canopy_reaper_01.lua)
kashyyyk_kash_kachirho_canopy_bandits = Lair:new {
	mobiles = {{"ep3_canopy_reaper_01",1}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_canopy_bandits", kashyyyk_kash_kachirho_canopy_bandits)

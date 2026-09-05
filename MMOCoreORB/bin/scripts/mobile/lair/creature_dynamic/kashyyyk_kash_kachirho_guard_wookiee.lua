-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_guard_wookiee.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Mapping is OURS, name-matched (ruling 2026-09-04 ).
-- Creature rows (SOE creatureName -> repo template):
--   ep3_qst_wookiee_guard -> ep3_village_guard_01  size=1  name-matched (OURS, name-matched (repo Kachirho village guard files ep3_village_guard_01.._05; no iff in SOE's row to compare))
kashyyyk_kash_kachirho_guard_wookiee = Lair:new {
	mobiles = {{"ep3_village_guard_01",1}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_guard_wookiee", kashyyyk_kash_kachirho_guard_wookiee)

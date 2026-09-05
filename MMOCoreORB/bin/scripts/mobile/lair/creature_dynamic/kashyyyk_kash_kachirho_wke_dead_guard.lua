-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_dead_guard.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_dead_guard -> ep3_wke_dead_guard_01  size=1  set-matched (SOE template column = ep3_dead_guard; repo numbered members ep3_wke_dead_guard_01.._03)
kashyyyk_kash_kachirho_wke_dead_guard = Lair:new {
	mobiles = {{"ep3_wke_dead_guard_01",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_wke_dead_guard", kashyyyk_kash_kachirho_wke_dead_guard)

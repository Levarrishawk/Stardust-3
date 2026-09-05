-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_guard_trando.tab
-- ruling 2026-09-04: Kachirho surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_trandoshan_slavers -> ep3_trando_slaver  size=1  set-matched (SOE template column = ep3_trandoshan_slavers; the one repo file ep3_trando_slaver.lua already carries all five slaver iffs)
--   ep3_trandoshan_slavermaster  size=1  OPEN (no repo template (ruling 2026-09-04 still OPEN))
--   ep3_npc_trandoshan_slavers -> ep3_trando_slaver  size=1  set-matched (SOE template column = ep3_trandoshan_slavers; the one repo file ep3_trando_slaver.lua already carries all five slaver iffs)
--   ep3_npc_trandoshan_slavers -> ep3_trando_slaver  size=1  set-matched (SOE template column = ep3_trandoshan_slavers; the one repo file ep3_trando_slaver.lua already carries all five slaver iffs)
--   ep3_npc_trandoshan_slavers -> ep3_trando_slaver  size=1  set-matched (SOE template column = ep3_trandoshan_slavers; the one repo file ep3_trando_slaver.lua already carries all five slaver iffs)
kashyyyk_kash_kachirho_guard_trando = Lair:new {
	mobiles = {{"ep3_trando_slaver",1},{"ep3_trando_slaver",1},{"ep3_trando_slaver",1},{"ep3_trando_slaver",1}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_guard_trando", kashyyyk_kash_kachirho_guard_trando)

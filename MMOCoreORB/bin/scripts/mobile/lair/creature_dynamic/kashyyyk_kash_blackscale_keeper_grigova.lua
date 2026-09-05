-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_blackscale_keeper_grigova.tab
-- ruling 2026-09-04: north-dungeons surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_slaver_keeper_grigova -> ep3_keeper_grigova  size=1  iff-matched (repo templates iff equals SOE template column ep3/ep3_keeper_grigova.iff; creatures.tab line 1571; lua ep3_keeper_grigova.lua)
kashyyyk_kash_blackscale_keeper_grigova = Lair:new {
	mobiles = {{"ep3_keeper_grigova",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_blackscale_keeper_grigova", kashyyyk_kash_blackscale_keeper_grigova)

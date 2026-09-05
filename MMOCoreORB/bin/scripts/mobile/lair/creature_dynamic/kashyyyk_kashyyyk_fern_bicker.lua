-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kashyyyk_fern_bicker.tab
-- ruling 2026-09-04: hunting-grounds surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_fern_bicker -> ep3_fern_bicker  size=4  iff-matched (repo templates iff equals SOE template column ep3_fern_bicker.iff; creatures.tab line 1336; level-4 placeholder today, the level curve is an open ruling)
kashyyyk_kashyyyk_fern_bicker = Lair:new {
	mobiles = {{"ep3_fern_bicker",4}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kashyyyk_fern_bicker", kashyyyk_kashyyyk_fern_bicker)

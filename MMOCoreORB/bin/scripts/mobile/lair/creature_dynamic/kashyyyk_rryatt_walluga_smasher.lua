-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_walluga_smasher.tab
-- ruling 2026-09-04: rryatt trail levels 1 and 2. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_walluga_smasher -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1548; lua walluga.lua)
--   ep3_rryatt_walluga_smasher -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1548; lua walluga.lua)
kashyyyk_rryatt_walluga_smasher = Lair:new {
	mobiles = {{"walluga",6},{"walluga",6}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_walluga_smasher", kashyyyk_rryatt_walluga_smasher)

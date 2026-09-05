-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_walluga_smasher_boss.tab
-- ruling 2026-09-04: rryatt trail levels 1 and 2 (K-11a). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5/K-11b/K-11a: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_walluga_smasher_boss -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-4 placeholder today, C6 revisits levels; C6 creatures.tab line 1549; lua walluga.lua)
kashyyyk_rryatt_walluga_smasher_boss = Lair:new {
	mobiles = {{"walluga",6}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_walluga_smasher_boss", kashyyyk_rryatt_walluga_smasher_boss)

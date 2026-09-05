-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_walluga.tab
-- ruling 2026-09-04: hunting-grounds surface spawns (K-4). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_walluga -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; C6 creatures.tab line 1324; C6 scout skipped custom_content/mobile/; level-4 placeholder today, C6 revisits levels)
--   ep3_etyyy_walluga -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; C6 creatures.tab line 1324; C6 scout skipped custom_content/mobile/; level-4 placeholder today, C6 revisits levels)
--   ep3_etyyy_walluga -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; C6 creatures.tab line 1324; C6 scout skipped custom_content/mobile/; level-4 placeholder today, C6 revisits levels)
--   ep3_etyyy_walluga -> walluga  size=6  iff-matched (repo templates iff equals SOE template column walluga.iff; C6 creatures.tab line 1324; C6 scout skipped custom_content/mobile/; level-4 placeholder today, C6 revisits levels)
kashyyyk_etyyy_walluga = Lair:new {
	mobiles = {{"walluga",6},{"walluga",6},{"walluga",6},{"walluga",6}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_walluga", kashyyyk_etyyy_walluga)

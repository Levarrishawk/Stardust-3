-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_minstyngar_elite_bonecrusher.tab
-- ruling 2026-09-04: rryatt trail levels 4 and 5 (K-11b). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1/K-4/K-5/K-11b: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_minstyngar_elite_bonecrusher -> minstyngar  size=6  iff-matched (repo templates iff equals SOE template column minstyngar.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-400 as the template stands, C6 revisits levels; C6 creatures.tab line 1527; lua minstyngar.lua)
--   ep3_rryatt_minstyngar_elite_bonecrusher -> minstyngar  size=6  iff-matched (repo templates iff equals SOE template column minstyngar.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-400 as the template stands, C6 revisits levels; C6 creatures.tab line 1527; lua minstyngar.lua)
--   ep3_rryatt_minstyngar_elite_bonecrusher -> minstyngar  size=6  iff-matched (repo templates iff equals SOE template column minstyngar.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-400 as the template stands, C6 revisits levels; C6 creatures.tab line 1527; lua minstyngar.lua)
--   ep3_rryatt_minstyngar_elite_bonecrusher -> minstyngar  size=6  iff-matched (repo templates iff equals SOE template column minstyngar.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-400 as the template stands, C6 revisits levels; C6 creatures.tab line 1527; lua minstyngar.lua)
--   ep3_rryatt_minstyngar_elite_deathcaller -> minstyngar  size=6  iff-matched (repo templates iff equals SOE template column minstyngar.iff; C6 unmatched_rows (C6 scout skipped custom_content/mobile/); level-400 as the template stands, C6 revisits levels; C6 creatures.tab line 1528; lua minstyngar.lua)
kashyyyk_rryatt_minstyngar_elite_bonecrusher = Lair:new {
	mobiles = {{"minstyngar",6},{"minstyngar",6},{"minstyngar",6},{"minstyngar",6},{"minstyngar",6}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_minstyngar_elite_bonecrusher", kashyyyk_rryatt_minstyngar_elite_bonecrusher)

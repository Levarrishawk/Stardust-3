-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/rryatt_bolotaur_special.tab
-- ruling 2026-09-04: rryatt trail levels 1 and 2. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_rryatt_bolotaur_bonegouged -> bolotaur  size=10  iff-matched (repo templates iff equals SOE template column bolotaur.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1510; lua bolotaur.lua)
--   ep3_rryatt_bolotaur_darkgnasher -> bolotaur  size=10  iff-matched (repo templates iff equals SOE template column bolotaur.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1511; lua bolotaur.lua)
--   ep3_rryatt_bolotaur_darkgnasher -> bolotaur  size=10  iff-matched (repo templates iff equals SOE template column bolotaur.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1511; lua bolotaur.lua)
--   ep3_rryatt_bolotaur_darkgnasher -> bolotaur  size=10  iff-matched (repo templates iff equals SOE template column bolotaur.iff; the creature table unmatched_rows (); level-4 placeholder today, the level curve is an open ruling; creatures.tab line 1511; lua bolotaur.lua)
kashyyyk_rryatt_bolotaur_special = Lair:new {
	mobiles = {{"bolotaur",10},{"bolotaur",10},{"bolotaur",10},{"bolotaur",10}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_rryatt_bolotaur_special", kashyyyk_rryatt_bolotaur_special)

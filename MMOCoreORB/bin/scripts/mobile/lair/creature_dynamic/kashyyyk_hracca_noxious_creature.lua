-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/hracca_noxious_creature.tab
-- ruling 2026-09-04: south-dungeons surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_hracca_noxious_walluga -> walluga  size=10  iff-matched (repo templates iff equals SOE template column walluga.iff; creatures.tab line 1389; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_walluga -> walluga  size=10  iff-matched (repo templates iff equals SOE template column walluga.iff; creatures.tab line 1389; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_kklyyytt -> ep3_kklyyytt  size=6  iff-matched (repo templates iff equals SOE template column ep3_kklyyytt.iff; creatures.tab line 1384; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_pug_jumper -> ep3_pug_jumper  size=6  iff-matched (repo templates iff equals SOE template column ep3_pug_jumper.iff; creatures.tab line 1386; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_pug_jumper -> ep3_pug_jumper  size=6  iff-matched (repo templates iff equals SOE template column ep3_pug_jumper.iff; creatures.tab line 1386; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_roroo -> ep3_roroo  size=6  iff-matched (repo templates iff equals SOE template column ep3_roroo.iff; creatures.tab line 1387; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_roroo -> ep3_roroo  size=6  iff-matched (repo templates iff equals SOE template column ep3_roroo.iff; creatures.tab line 1387; level-4 placeholder today, the level curve is an open ruling)
--   ep3_hracca_noxious_uller -> uller_stoneclaw  size=8  iff-match (creatures.tab line 1388; lua uller_stoneclaw.lua)
--   ep3_hracca_noxious_uller -> uller_stoneclaw  size=8  iff-match (creatures.tab line 1388; lua uller_stoneclaw.lua)
--   ep3_hracca_noxious_bantha_kashyyyk -> kashyyyk_bull_bantha  size=10  iff-match (creatures.tab line 1383; lua kashyyyk_bull_bantha.lua [picked 1 of 2 the creature table lua matches])
--   ep3_hracca_noxious_mouf  size=8  OPEN (no repo mouf template; surface rounds established this)
--   ep3_hracca_noxious_mouf  size=8  OPEN (no repo mouf template; surface rounds established this)
kashyyyk_hracca_noxious_creature = Lair:new {
	mobiles = {{"walluga",10},{"walluga",10},{"ep3_kklyyytt",6},{"ep3_pug_jumper",6},{"ep3_pug_jumper",6},{"ep3_roroo",6},{"ep3_roroo",6},{"uller_stoneclaw",8},{"uller_stoneclaw",8},{"kashyyyk_bull_bantha",10}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_hracca_noxious_creature", kashyyyk_hracca_noxious_creature)

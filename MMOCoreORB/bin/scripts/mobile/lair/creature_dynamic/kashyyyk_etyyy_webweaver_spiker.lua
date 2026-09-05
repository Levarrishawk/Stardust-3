-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/etyyy_webweaver_spiker.tab
-- ruling 2026-09-04: hunting-grounds surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_etyyy_webweaver_spiker -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1331; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_spiker -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1331; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_spiker -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1331; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_spiker -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1331; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_spiker -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1331; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_warrior -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1332; level-4 placeholder today, the level curve is an open ruling)
--   ep3_etyyy_webweaver_warrior -> webweaver  size=5  iff-matched (repo templates iff equals SOE template column webweaver.iff; creatures.tab line 1332; level-4 placeholder today, the level curve is an open ruling)
kashyyyk_etyyy_webweaver_spiker = Lair:new {
	mobiles = {{"webweaver",5},{"webweaver",5},{"webweaver",5},{"webweaver",5},{"webweaver",5},{"webweaver",5},{"webweaver",5}},
	spawnLimit = 3,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_etyyy_webweaver_spiker", kashyyyk_etyyy_webweaver_spiker)

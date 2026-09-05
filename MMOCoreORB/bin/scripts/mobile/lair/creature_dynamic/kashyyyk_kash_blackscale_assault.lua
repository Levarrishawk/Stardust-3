-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_blackscale_assault.tab
-- ruling 2026-09-04: north-dungeons surface spawns. NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- an earlier pass only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_slaver_blackscale_assault -> ep3_blackscale_assault_m_01  size=1  set-rotate (creatures.tab line 1558; rotate numbered variants ep3_blackscale_assault_m_01.._03)
--   ep3_slaver_blackscale_assault -> ep3_blackscale_assault_m_02  size=1  set-rotate (creatures.tab line 1558; rotate numbered variants ep3_blackscale_assault_m_01.._03)
--   ep3_slaver_blackscale_assault -> ep3_blackscale_assault_m_03  size=1  set-rotate (creatures.tab line 1558; rotate numbered variants ep3_blackscale_assault_m_01.._03)
kashyyyk_kash_blackscale_assault = Lair:new {
	mobiles = {{"ep3_blackscale_assault_m_01",1},{"ep3_blackscale_assault_m_02",1},{"ep3_blackscale_assault_m_03",1}},
	spawnLimit = 6,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_blackscale_assault", kashyyyk_kash_blackscale_assault)

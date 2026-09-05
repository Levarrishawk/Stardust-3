-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_commando.tab
-- ruling 2026-09-04: Kachirho surface spawns (K-3.1). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- K-3.1: C6 scout only scanned mobile/custom_content/ep3/; creatures also live
-- in mobile/custom_content/mobile/ and as numbered set-members. Mapping as given.
-- When the same SOE creature name repeats, rotate numbered variants row by row.
-- K-3.1: rotate numbered variants row by row. OPEN commando/battleleader unchanged.
-- Creature rows (SOE creatureName -> repo template):
--   ep3_npc_wookiee_commando  size=1  OPEN (no K-3.1 mapping and no C6 numbered-variant rotation; not guessed)
--   ep3_npc_wookiee_commando  size=1  OPEN (no K-3.1 mapping and no C6 numbered-variant rotation; not guessed)
--   ep3_npc_wookiee_freedom_fighters -> ep3_wke_freedom_fighter_01  size=1  c6-rotate (C6 creatures.tab line 1477; rotate numbered variants ep3_wke_freedom_fighter_01.._05)
--   ep3_npc_wookiee_freedom_fighters -> ep3_wke_freedom_fighter_02  size=1  c6-rotate (C6 creatures.tab line 1477; rotate numbered variants ep3_wke_freedom_fighter_01.._05)
--   ep3_npc_wookiee_freedom_fighters -> ep3_wke_freedom_fighter_03  size=1  c6-rotate (C6 creatures.tab line 1477; rotate numbered variants ep3_wke_freedom_fighter_01.._05)
--   ep3_npc_wookiee_battleleader  size=1  OPEN (no K-3.1 mapping and no C6 numbered-variant rotation; not guessed)
kashyyyk_kash_kachirho_wke_commando = Lair:new {
	mobiles = {{"ep3_wke_freedom_fighter_01",1},{"ep3_wke_freedom_fighter_02",1},{"ep3_wke_freedom_fighter_03",1}},
	spawnLimit = 4,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_kachirho_wke_commando", kashyyyk_kash_kachirho_wke_commando)

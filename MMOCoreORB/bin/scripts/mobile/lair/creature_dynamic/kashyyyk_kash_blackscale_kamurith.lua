-- SOURCED -- datatables/spawning/ground_spawning/types/kashyyyk/kash_blackscale_kamurith.tab
-- ruling 2026-09-04: Trandoshan slave camp spawns (K-8b.1). NGE area-spawner
-- type table mapped onto a Core3 dynamic lair (buildingType = none).
-- Each row is one SOE strItem with fltSize as the weight (integer).
-- spawnLimit = SOE's largest intSpawnCount among the spawners that use this table (fltSize is a weight, not a count).
-- Creature rows (SOE creatureName -> repo template):
--   ep3_slaver_blackscale_kamurith (x4 rows) -> kamurith_snapper / kamurith_defiler / nocuous_kamurith, rotated
--     iff-matched: SOE template column voritor_lizard_hue.iff = the iff these base-game kamurith templates declare
--     (mobile/dathomir/kamurith_snapper.lua, kamurith_defiler.lua, nocuous_kamurith.lua); C6 creatures.tab line for
--     ep3_slaver_blackscale_kamurith (where=slave_camp, ELITE 81). Levels are the repo's (44-50): OURS, unchanged.
--   The named boss ep3_slaver_blackscale_kamurith_ysskir (BOSS, its own table kash_blackscale_kamurith_ysskir) stays OPEN.
kashyyyk_kash_blackscale_kamurith = Lair:new {
	mobiles = {{"kamurith_snapper",4},{"kamurith_defiler",4},{"nocuous_kamurith",4},{"kamurith_snapper",4}},
	spawnLimit = 6,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_kash_blackscale_kamurith", kashyyyk_kash_blackscale_kamurith)

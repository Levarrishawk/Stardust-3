-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/rryatt_walluga_smasher_boss.tab
-- Lair kashyyyk_rryatt_walluga_smasher_boss (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_rryatt_walluga_smasher_boss = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_rryatt_walluga_smasher_boss",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_rryatt_walluga_smasher_boss", kashyyyk_rryatt_walluga_smasher_boss);

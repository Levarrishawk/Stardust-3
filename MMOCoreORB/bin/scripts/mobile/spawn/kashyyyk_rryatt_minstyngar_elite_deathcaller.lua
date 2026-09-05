-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/rryatt_minstyngar_elite_deathcaller.tab
-- Lair kashyyyk_rryatt_minstyngar_elite_deathcaller (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_rryatt_minstyngar_elite_deathcaller = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_rryatt_minstyngar_elite_deathcaller",
      spawnLimit = -1,
      minDifficulty = 400,
      maxDifficulty = 400,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_rryatt_minstyngar_elite_deathcaller", kashyyyk_rryatt_minstyngar_elite_deathcaller);

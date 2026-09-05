-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/rryatt_crazed_jedi.tab
-- Lair kashyyyk_rryatt_crazed_jedi (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_rryatt_crazed_jedi = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_rryatt_crazed_jedi",
      spawnLimit = -1,
      minDifficulty = 120,
      maxDifficulty = 120,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_rryatt_crazed_jedi", kashyyyk_rryatt_crazed_jedi);

-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/rryatt_lobarorr.tab
-- Lair kashyyyk_rryatt_lobarorr (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_rryatt_lobarorr = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_rryatt_lobarorr",
      spawnLimit = -1,
      minDifficulty = 30,
      maxDifficulty = 30,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_rryatt_lobarorr", kashyyyk_rryatt_lobarorr);

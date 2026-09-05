-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/rryatt_minstyngar_scratch.tab
-- Lair kashyyyk_rryatt_minstyngar_scratch (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_rryatt_minstyngar_scratch = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_rryatt_minstyngar_scratch",
      spawnLimit = -1,
      minDifficulty = 400,
      maxDifficulty = 400,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_rryatt_minstyngar_scratch", kashyyyk_rryatt_minstyngar_scratch);

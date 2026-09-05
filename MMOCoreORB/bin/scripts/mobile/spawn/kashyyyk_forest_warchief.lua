-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/forest_warchief.tab
-- Lair kashyyyk_forest_warchief (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_forest_warchief = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_forest_warchief",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_forest_warchief", kashyyyk_forest_warchief);

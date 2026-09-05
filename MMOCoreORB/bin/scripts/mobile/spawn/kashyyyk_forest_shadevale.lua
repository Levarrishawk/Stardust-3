-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/forest_shadevale.tab
-- Lair kashyyyk_forest_shadevale (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand: fanned_rawl 10, crystal_snake 25).
kashyyyk_forest_shadevale = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_forest_shadevale",
      spawnLimit = -1,
      minDifficulty = 10,
      maxDifficulty = 25,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },
	}
}

addSpawnGroup("kashyyyk_forest_shadevale", kashyyyk_forest_shadevale);

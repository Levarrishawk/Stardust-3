-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kashyyyk_roroo.tab
-- Lair kashyyyk_kashyyyk_roroo (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kashyyyk_roroo = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kashyyyk_roroo",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kashyyyk_roroo", kashyyyk_kashyyyk_roroo);

-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kashyyyk_kklyyytt.tab
-- Lair kashyyyk_kashyyyk_kklyyytt (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kashyyyk_kklyyytt = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kashyyyk_kklyyytt",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kashyyyk_kklyyytt", kashyyyk_kashyyyk_kklyyytt);

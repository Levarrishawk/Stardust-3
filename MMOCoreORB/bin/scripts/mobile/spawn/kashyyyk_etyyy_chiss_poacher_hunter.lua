-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_chiss_poacher_hunter.tab
-- Lair kashyyyk_etyyy_chiss_poacher_hunter (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_etyyy_chiss_poacher_hunter = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_chiss_poacher_hunter",
      spawnLimit = -1,
      minDifficulty = 45,
      maxDifficulty = 45,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_chiss_poacher_hunter", kashyyyk_etyyy_chiss_poacher_hunter);

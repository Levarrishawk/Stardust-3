-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_laen_pieweto.tab
-- Lair kashyyyk_etyyy_laen_pieweto (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_etyyy_laen_pieweto = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_laen_pieweto",
      spawnLimit = -1,
      minDifficulty = 47,
      maxDifficulty = 47,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_laen_pieweto", kashyyyk_etyyy_laen_pieweto);

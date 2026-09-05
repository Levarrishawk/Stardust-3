-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_webweaver_spiker.tab
-- Lair kashyyyk_etyyy_webweaver_spiker (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_etyyy_webweaver_spiker = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_webweaver_spiker",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_webweaver_spiker", kashyyyk_etyyy_webweaver_spiker);

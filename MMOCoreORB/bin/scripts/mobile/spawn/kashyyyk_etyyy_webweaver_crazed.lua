-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_webweaver_crazed.tab
-- Lair kashyyyk_etyyy_webweaver_crazed (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_etyyy_webweaver_crazed = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_webweaver_crazed",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_webweaver_crazed", kashyyyk_etyyy_webweaver_crazed);

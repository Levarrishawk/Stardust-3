-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_uller_diseased.tab
-- Lair kashyyyk_etyyy_uller_diseased (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_etyyy_uller_diseased = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_uller_diseased",
      spawnLimit = -1,
      minDifficulty = 60,
      maxDifficulty = 60,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_uller_diseased", kashyyyk_etyyy_uller_diseased);

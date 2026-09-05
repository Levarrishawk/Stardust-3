-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_blackscale_selindrolich.tab
-- Lair kashyyyk_kash_blackscale_selindrolich (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kash_blackscale_selindrolich = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_blackscale_selindrolich",
      spawnLimit = -1,
      minDifficulty = 400,
      maxDifficulty = 400,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_blackscale_selindrolich", kashyyyk_kash_blackscale_selindrolich);

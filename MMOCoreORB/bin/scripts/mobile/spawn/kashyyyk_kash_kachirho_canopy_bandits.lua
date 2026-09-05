-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_canopy_bandits.tab
-- Lair kashyyyk_kash_kachirho_canopy_bandits (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kash_kachirho_canopy_bandits = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_canopy_bandits",
      spawnLimit = -1,
      minDifficulty = 130,
      maxDifficulty = 130,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_canopy_bandits", kashyyyk_kash_kachirho_canopy_bandits);

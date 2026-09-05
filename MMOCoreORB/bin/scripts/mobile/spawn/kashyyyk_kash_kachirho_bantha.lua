-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_bantha.tab
-- Lair kashyyyk_kash_kachirho_bantha (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kash_kachirho_bantha = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_bantha",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 45,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_bantha", kashyyyk_kash_kachirho_bantha);

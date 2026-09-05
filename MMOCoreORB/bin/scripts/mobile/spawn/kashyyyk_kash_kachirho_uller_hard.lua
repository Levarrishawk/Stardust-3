-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_uller_hard.tab
-- Lair kashyyyk_kash_kachirho_uller_hard (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kash_kachirho_uller_hard = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_uller_hard",
      spawnLimit = -1,
      minDifficulty = 60,
      maxDifficulty = 60,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_uller_hard", kashyyyk_kash_kachirho_uller_hard);

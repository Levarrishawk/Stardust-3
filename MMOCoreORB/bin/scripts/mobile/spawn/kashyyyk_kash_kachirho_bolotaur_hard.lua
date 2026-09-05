-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_bolotaur_hard.tab
-- Lair kashyyyk_kash_kachirho_bolotaur_hard (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_kash_kachirho_bolotaur_hard = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_bolotaur_hard",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_bolotaur_hard", kashyyyk_kash_kachirho_bolotaur_hard);

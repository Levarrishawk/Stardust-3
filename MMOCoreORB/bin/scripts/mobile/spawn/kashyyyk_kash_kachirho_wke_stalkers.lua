-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_stalkers.tab
-- Lair kashyyyk_kash_kachirho_wke_stalkers (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kash_kachirho_wke_stalkers = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_wke_stalkers",
      spawnLimit = -1,
      minDifficulty = 105,
      maxDifficulty = 105,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_wke_stalkers", kashyyyk_kash_kachirho_wke_stalkers);

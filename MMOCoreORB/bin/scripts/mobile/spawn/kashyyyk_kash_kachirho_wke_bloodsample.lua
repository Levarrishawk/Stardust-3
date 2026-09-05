-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_bloodsample.tab
-- Lair kashyyyk_kash_kachirho_wke_bloodsample (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kash_kachirho_wke_bloodsample = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_wke_bloodsample",
      spawnLimit = -1,
      minDifficulty = 30,
      maxDifficulty = 30,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_wke_bloodsample", kashyyyk_kash_kachirho_wke_bloodsample);

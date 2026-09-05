-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_wke_commando.tab
-- Lair kashyyyk_kash_kachirho_wke_commando (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kash_kachirho_wke_commando = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_wke_commando",
      spawnLimit = -1,
      minDifficulty = 45,
      maxDifficulty = 45,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_wke_commando", kashyyyk_kash_kachirho_wke_commando);

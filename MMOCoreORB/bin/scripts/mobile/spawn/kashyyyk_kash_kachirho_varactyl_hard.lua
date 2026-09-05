-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_kachirho_varactyl_hard.tab
-- Lair kashyyyk_kash_kachirho_varactyl_hard (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kash_kachirho_varactyl_hard = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_kachirho_varactyl_hard",
      spawnLimit = -1,
      minDifficulty = 40,
      maxDifficulty = 50,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kash_kachirho_varactyl_hard", kashyyyk_kash_kachirho_varactyl_hard);

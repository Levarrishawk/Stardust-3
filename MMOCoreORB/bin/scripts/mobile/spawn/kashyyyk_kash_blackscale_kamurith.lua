-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kash_blackscale_kamurith.tab
-- Lair kashyyyk_kash_blackscale_kamurith (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand: kamurith_snapper 44 .. kamurith_defiler 50).
kashyyyk_kash_blackscale_kamurith = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kash_blackscale_kamurith",
      spawnLimit = -1,
      minDifficulty = 44,
      maxDifficulty = 50,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },
	}
}

addSpawnGroup("kashyyyk_kash_blackscale_kamurith", kashyyyk_kash_blackscale_kamurith);

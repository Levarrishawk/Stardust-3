-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/kashyyyk_fern_bicker.tab
-- Lair kashyyyk_kashyyyk_fern_bicker (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_kashyyyk_fern_bicker = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_kashyyyk_fern_bicker",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_kashyyyk_fern_bicker", kashyyyk_kashyyyk_fern_bicker);

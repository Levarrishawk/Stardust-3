-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/hracca_noxious_creature.tab
-- Lair kashyyyk_hracca_noxious_creature (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_hracca_noxious_creature = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_hracca_noxious_creature",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 60,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_hracca_noxious_creature", kashyyyk_hracca_noxious_creature);

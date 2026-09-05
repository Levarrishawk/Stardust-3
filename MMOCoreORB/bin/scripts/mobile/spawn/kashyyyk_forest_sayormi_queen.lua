-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/forest_sayormi_queen.tab
-- Lair kashyyyk_forest_sayormi_queen (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; C6 will revisit levels).
kashyyyk_forest_sayormi_queen = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_forest_sayormi_queen",
      spawnLimit = -1,
      minDifficulty = 4,
      maxDifficulty = 4,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_forest_sayormi_queen", kashyyyk_forest_sayormi_queen);

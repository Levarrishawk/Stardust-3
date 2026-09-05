-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/ep3_qst_mad_wookiee.tab
-- Lair kashyyyk_ep3_qst_mad_wookiee (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_ep3_qst_mad_wookiee = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_ep3_qst_mad_wookiee",
      spawnLimit = -1,
      minDifficulty = 105,
      maxDifficulty = 105,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_ep3_qst_mad_wookiee", kashyyyk_ep3_qst_mad_wookiee);

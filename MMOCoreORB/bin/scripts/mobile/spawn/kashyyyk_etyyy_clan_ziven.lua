-- SOURCED -- spawn group for type table datatables/spawning/ground_spawning/types/kashyyyk/etyyy_clan_ziven.tab
-- Lair kashyyyk_etyyy_clan_ziven (same stem). Mustafar precedent for the numeric fields:
--   spawnLimit = -1, numberToSpawn = 0, weighting = 15, size = 25
--   (bin/scripts/mobile/spawn/mustafar_blistmoks.lua).
-- minDifficulty/maxDifficulty = min/max `level` of the repo templates
-- in this lair (OURS, as the templates stand; the level curve is an open ruling).
kashyyyk_etyyy_clan_ziven = {

	lairSpawns = {
    {
      lairTemplateName = "kashyyyk_etyyy_clan_ziven",
      spawnLimit = -1,
      minDifficulty = 30,
      maxDifficulty = 30,
      numberToSpawn = 0,
      weighting = 15,
      size = 25
    },    				
	}
}

addSpawnGroup("kashyyyk_etyyy_clan_ziven", kashyyyk_etyyy_clan_ziven);

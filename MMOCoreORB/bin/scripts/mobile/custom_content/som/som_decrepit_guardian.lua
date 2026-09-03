--[[ som_decrepit_guardian -- Factory Guardian, Decrepit Droid Factory trial
     boss. Live record: creatures.tab BaseLevel 85 / difficultyClass BOSS /
     HP 185250 (runtime from trial.java, header only -- Core3 has no matching
     HAM column; the tier ladder's baseHAM governs) / where mustafar /
     socialGroup droid_army / pvpFaction droid_army /
     template death_watch_s_battle_droid.iff / intLootRolls 1 /
     intRollPercent 100 / lootTable mustafar/mustafar_trial_factory_guardian /
     niche android / primary_weapon
     object/weapon/ranged/droid/droid_union_sentry_02.iff /
     primary_weapon_specials droid_special_6 / aggressive 6 / assist 9 /
     death_blow instant.

     TIER: BOSS 120. Live level 85 / difficultyClass BOSS maps to the BOSS 120
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same row
     som_working_doom_bringer already uses. Stat row taken whole from that
     ladder. Live's own armour columns are NOT used -- the ladder is applied
     whole.

     SOURCED:
       customName "Factory Guardian" -- live English name.
       socialGroup "droid_army" -- live.
       templates {"object/mobile/death_watch_s_battle_droid.iff"} -- live.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       loot group factory_guardian_loot, lootChance 10000000 -- live
         intLootRolls 1 / intRollPercent 100.

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_union_sentry_02.iff, which is not
       registered anywhere in this repo -- som_working_doom_bringer.lua:4
       already records that same class of absence and takes the same fallback
       to droid_droideka_ranged.iff. Following that precedent rather than
       minting a second answer.

     No specials authored. Live's droid_special_6 profile row contains no
     actions at all (same note as som_working_doom_bringer). ]]
som_decrepit_guardian = Creature:new {
	customName = "Factory Guardian",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/death_watch_s_battle_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "factory_guardian_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_decrepit_guardian, "som_decrepit_guardian")

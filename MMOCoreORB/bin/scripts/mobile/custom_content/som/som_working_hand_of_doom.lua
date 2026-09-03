--[[ som_working_hand_of_doom -- Hand of Doom, Working Droid Factory elite
     guard ringing the Doom Bringer. Live record: creatures.tab BaseLevel 82 /
     difficultyClass ELITE / HP 125000 (runtime from trial.java, header only --
     Core3 has no matching HAM column; the tier ladder's baseHAM governs) /
     where mustafar / socialGroup droid_army / pvpFaction droid_army /
     template som/union_sentry_droid.iff / minScale 0.9 / maxScale 0.9 / hue 0 /
     intLootRolls 1 / intRollPercent 80 / lootTable BLANK / niche android /
     primary_weapon object/weapon/ranged/droid/droid_union_sentry_01.iff /
     primary_weapon_specials droid_special_6 / aggressive 6 / assist 9 /
     death_blow instant.

     TIER: ELITE 85. Live level 82 / difficultyClass ELITE maps to the ELITE 85
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same reading every
     prior Mustafar round took. Stat row taken whole from that ladder. Resists
     are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     SOURCED:
       customName "Hand of Doom" -- live English name.
       socialGroup "droid_army" -- live.
       templates {"object/mobile/som/union_sentry_droid.iff"}, scale 0.9 --
         live. No hues key: live hue is 0.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       lootGroups {} -- live intLootRolls 1 / intRollPercent 80 with a blank
         lootTable. Empty here is live's data, not an omission.

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_union_sentry_01.iff, which is not
       registered anywhere in this repo -- som_working_doom_bringer.lua:4
       already records that same class of absence and takes the same fallback
       to droid_droideka_ranged.iff. Following that precedent rather than
       minting a second answer.

     No specials authored. Live's droid_special_6 profile row contains no
     actions at all (same note as som_working_doom_bringer). ]]
som_working_hand_of_doom = Creature:new {
	customName = "Hand of Doom",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
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

	templates = {"object/mobile/som/union_sentry_droid.iff"},
	scale = 0.9,
	lootGroups = {},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_working_hand_of_doom, "som_working_hand_of_doom")

--[[ som_working_hk_58_aurek -- HK-58 Aurek, Working Droid Factory trial boss.
     Live record: creatures.tab BaseLevel 83 / difficultyClass BOSS / HP 448220
     (runtime from trial.java, header only -- Core3 has no matching HAM column;
     the tier ladder's baseHAM governs) / where mustafar / socialGroup
     droid_army / pvpFaction droid_army / template som/hk77.iff / minScale 1.2 /
     maxScale 1.2 / hue 0 / intLootRolls 1 / intRollPercent 80 / lootTable BLANK /
     niche android / primary_weapon
     object/weapon/ranged/droid/droid_hk77_boss.iff / primary_weapon_specials
     droid_special_6 / aggressive 6 / assist 9 / death_blow instant.

     Byte-identical to som_working_hk_58_besh in creatures.tab apart from the
     name. Neither header was copied from the other carelessly; live ships them
     as twins.

     TIER: BOSS 120. Live level 83 / difficultyClass BOSS maps to the BOSS 120
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same row
     som_working_doom_bringer already uses. Stat row taken whole from that
     ladder. Live's own armour columns are NOT used -- the ladder is applied
     whole.

     SOURCED:
       customName "HK-58 Aurek" -- live English name.
       socialGroup "droid_army" -- live.
       templates {"object/mobile/som/hk77.iff"}, scale 1.2 -- live.
         No hues key: live hue is 0.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       lootGroups {} -- live intLootRolls 1 / intRollPercent 80 with a blank
         lootTable. Empty here is live's data, not an omission.

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_hk77_boss.iff, which is not registered
       anywhere in this repo -- som_working_doom_bringer.lua:4 already records
       that same class of absence and takes the same fallback to
       droid_droideka_ranged.iff. Following that precedent rather than minting a
       second answer.

     No specials authored. Live's droid_special_6 profile row contains no
     actions at all (same note as som_working_doom_bringer). ]]
som_working_hk_58_aurek = Creature:new {
	customName = "HK-58 Aurek",
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

	templates = {"object/mobile/som/hk77.iff"},
	scale = 1.2,
	lootGroups = {},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_working_hk_58_aurek, "som_working_hk_58_aurek")

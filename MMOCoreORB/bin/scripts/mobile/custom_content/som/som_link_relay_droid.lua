--[[ som_link_relay_droid -- Relay Droid, the escort droid the player protects
     in the Establish the Link trial. Live record: creatures.tab BaseLevel 55 /
     difficultyClass NORMAL / where mustafar / socialGroup link_player /
     template som/must_mining_droid_mark_03.iff / intLootRolls 1 /
     intRollPercent 80 / lootTable BLANK / niche android / primary_weapon
     object/weapon/ranged/droid/droid_union_sentry_01.iff /
     primary_weapon_specials droid_special_6 / aggressive BLANK / assist 2 /
     death_blow instant.

     TIER: STD 70. Live level 55 / difficultyClass NORMAL maps to the STD 70
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same reading every
     prior Mustafar NORMAL row took. Stat row taken whole from that ladder.
     Resists are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     SOURCED:
       customName "Relay Droid" -- live English name.
       socialGroup "link_player" -- live.
       templates {"object/mobile/som/must_mining_droid_mark_03.iff"} -- live.
         No scale, no hues.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask ATTACKABLE only -- live aggressive is BLANK and assist 2.
         Getting this bitmask wrong turns a friendly escort into an attacker;
         it is the one field in this round where the obvious AGGRESSIVE copy
         is wrong.
       lootGroups {} -- live lootTable blank. Empty here is live's data, not
         an omission.

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_union_sentry_01.iff, which is not
       registered anywhere in this repo -- som_working_doom_bringer.lua:4
       already records that same class of absence and takes the same fallback
       to droid_droideka_ranged.iff. Following that precedent rather than
       minting a second answer.

     No specials authored. Live's droid_special_6 profile row contains no
     actions at all (same note as som_working_doom_bringer). ]]
som_link_relay_droid = Creature:new {
	customName = "Relay Droid",
	socialGroup = "link_player",
	faction = "",
	mobType = MOB_DROID,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/must_mining_droid_mark_03.iff"},
	lootGroups = {},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_link_relay_droid, "som_link_relay_droid")

--[[ som_working_devistator -- the Devistator, Working Droid Factory trial boss.
     Live spells it "Devistator" -- that is live's own spelling, not a typo
     introduced here. Live record: creatures.tab BaseLevel 88 /
     difficultyClass BOSS / HP 635425 (runtime from trial.java, header only --
     Core3 has no matching HAM column; the tier ladder's baseHAM governs) /
     where mustafar / socialGroup droid_army / pvpFaction droid_army /
     template som/cww8a_battle_droid.iff / hue 1 / intLootRolls 1 /
     intRollPercent 100 / lootTable mustafar/mustafar_trial_devistator /
     niche android / primary_weapon object/weapon/ranged/droid/droid_cww8.iff /
     primary_weapon_specials som_working_devistator / aggressive 6 / assist 9 /
     death_blow instant.

     TIER: BOSS 120. Live level 88 / difficultyClass BOSS maps to the BOSS 120
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same row
     som_working_doom_bringer already uses. Stat row taken whole from that
     ladder. Live's own armour columns are NOT used -- the ladder is applied
     whole.

     SOURCED:
       customName "the Devistator" -- live English name (live spelling kept).
       socialGroup "droid_army" -- live.
       templates {"object/mobile/som/cww8a_battle_droid.iff"}, hues { 1 } --
         live. No scale key: live leaves scale at default.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       loot group devistator_loot, lootChance 10000000 -- live intLootRolls 1 /
         intRollPercent 100 / lootTable mustafar/mustafar_trial_devistator.

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_cww8.iff, which is not registered
       anywhere in this repo -- som_working_doom_bringer.lua:4 already records
       that same class of absence and takes the same fallback to
       droid_droideka_ranged.iff. Following that precedent rather than minting a
       second answer.

     No specials authored. Live's som_working_devistator specials profile is
     not ported this round; say so here rather than invent actions. ]]
som_working_devistator = Creature:new {
	customName = "the Devistator",
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

	templates = {"object/mobile/som/cww8a_battle_droid.iff"},
	hues = { 1 },
	lootGroups = {
		{
			groups = {
				{group = "devistator_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_working_devistator, "som_working_devistator")

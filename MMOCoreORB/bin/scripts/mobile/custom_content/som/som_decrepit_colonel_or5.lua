--[[ som_decrepit_colonel_or5 -- Colonel OR-5, Decrepit Droid Factory trial
     boss. Live record: creatures.tab BaseLevel 86 / difficultyClass BOSS /
     HP 145000 (runtime from trial.java, header only -- Core3 has no matching
     HAM column; the tier ladder's baseHAM governs) / where mustafar /
     socialGroup droid_army / pvpFaction droid_army /
     template death_watch_battle_droid.iff / intLootRolls 2 /
     intRollPercent 100 / lootTable mustafar/mustafar_trial_col_or5 /
     niche android / primary_weapon battledroid / primary_weapon_specials
     droid_special_6 / aggressive 6 / assist 9 / death_blow instant.

     TIER: BOSS 120. Live level 86 / difficultyClass BOSS maps to the BOSS 120
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same row
     som_working_doom_bringer already uses. Stat row taken whole from that
     ladder. Live's own armour columns are NOT used -- the ladder is applied
     whole.

     SOURCED:
       customName "Colonel OR-5" -- live English name.
       socialGroup "droid_army" -- live.
       templates {"object/mobile/death_watch_battle_droid.iff"} -- live.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       loot group colonel_or5_loot x2, lootChance 10000000 each -- live
         intLootRolls 2 / intRollPercent 100; same two-block shape
         sher_kar.lua:39-52 uses.
       primaryWeapon = "battle_droid_weapons" -- live primary_weapon
         battledroid resolves to the registered battle_droid_weapons group
         (mobile/weapon/serverobjects.lua). Field is primaryWeapon /
         primaryAttacks because CreatureTemplate.cpp:191-233 reads only
         those; the earlier weapons / attacks form was dead and left this
         boss spawning unarmed.

     No specials authored beyond the weapon-group merge above. Live's
     droid_special_6 profile row contains no actions at all. ]]
som_decrepit_colonel_or5 = Creature:new {
	customName = "Colonel OR-5",
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

	templates = {"object/mobile/death_watch_battle_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "colonel_or5_loot", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "colonel_or5_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "battle_droid_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(pistoleermaster,carbineermaster,marksmanmaster),
	secondaryAttacks = marksmanmaster
}

CreatureTemplates:addCreatureTemplate(som_decrepit_colonel_or5, "som_decrepit_colonel_or5")

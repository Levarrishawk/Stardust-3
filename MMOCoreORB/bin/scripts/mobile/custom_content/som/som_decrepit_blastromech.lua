--[[ som_decrepit_blastromech -- Decrepit Droid Factory blastromech.
     Retail creatures.tab: BaseLevel 81, difficultyClass ELITE,
     socialGroup droid_army, template blastromech.iff, lootTable (blank).
     Placed on ELITE 85: retail difficultyClass ELITE maps to the ELITE 85 row.
     Retail BaseLevel 81 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; mobType MOB_DROID; diet = NONE. ]]
som_decrepit_blastromech = Creature:new {
	customName = "a decrepit blastromech",
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/blastromech.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
	primaryWeapon = "ranged_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,pistoleermaster),
	secondaryAttacks = pistoleermaster
}

CreatureTemplates:addCreatureTemplate(som_decrepit_blastromech, "som_decrepit_blastromech")
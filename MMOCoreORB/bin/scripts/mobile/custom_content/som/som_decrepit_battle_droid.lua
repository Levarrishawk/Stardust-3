--[[ som_decrepit_battle_droid -- Decrepit Droid Factory battle droid.
     Retail creatures.tab: BaseLevel 83, difficultyClass ELITE,
     socialGroup droid_army, template death_watch_battle_droid,
     lootTable (blank).
     Placed on ELITE 85: retail difficultyClass ELITE maps to the ELITE 85 row.
     Retail BaseLevel 83 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; diet = NONE; pvpBitmask ATTACKABLE. ]]
som_decrepit_battle_droid = Creature:new {
	customName = "a decrepit battle droid",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
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

	templates = {"object/mobile/death_watch_battle_droid.iff"},
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

CreatureTemplates:addCreatureTemplate(som_decrepit_battle_droid, "som_decrepit_battle_droid")
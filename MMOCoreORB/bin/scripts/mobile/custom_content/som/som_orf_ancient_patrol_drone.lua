--[[ som_orf_ancient_patrol_drone -- Old Republic Facility patrol drone.
     Retail creatures.tab: BaseLevel 84, difficultyClass NORMAL,
     socialGroup orf_security, template som/cww8_battle_droid.iff,
     lootTable mustafar/mustafar_droid.
     Placed on STD 70: retail difficultyClass NORMAL maps to the STD 70 row.
     Retail BaseLevel 84 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; diet = NONE; scale 0.8 from retail. ]]
som_orf_ancient_patrol_drone = Creature:new {
	customName = "an Old Republic patrol drone",
	socialGroup = "orf_security",
	faction = "",
	mobType = MOB_ANDROID,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
	scale = 0.8,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/cww8_battle_droid.iff"},
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

CreatureTemplates:addCreatureTemplate(som_orf_ancient_patrol_drone, "som_orf_ancient_patrol_drone")
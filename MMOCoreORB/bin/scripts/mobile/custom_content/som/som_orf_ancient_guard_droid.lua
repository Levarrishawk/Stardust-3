--[[ som_orf_ancient_guard_droid -- Old Republic Facility guard droid.
     Retail creatures.tab: BaseLevel 87, difficultyClass ELITE,
     socialGroup orf_security, template som/cww8a_battle_droid.iff,
     lootTable mustafar/mustafar_droid.
     Placed on ELITE 85: retail difficultyClass ELITE maps to the ELITE 85 row.
     Retail BaseLevel 87 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; appearance cww8a_battle_droid.iff;
     diet = NONE; scale 0.8 from retail; armor 1. ]]
som_orf_ancient_guard_droid = Creature:new {
	customName = "an Old Republic guard droid",
	socialGroup = "orf_security",
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

	templates = {"object/mobile/som/cww8a_battle_droid.iff"},
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

CreatureTemplates:addCreatureTemplate(som_orf_ancient_guard_droid, "som_orf_ancient_guard_droid")
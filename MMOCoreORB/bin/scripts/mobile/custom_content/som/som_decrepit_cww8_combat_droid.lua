--[[ som_decrepit_cww8_combat_droid -- Decrepit Droid Factory CWW8 combat droid.
     Retail creatures.tab: BaseLevel 83, difficultyClass BOSS,
     socialGroup droid_army, template som/cww8a_battle_droid.iff,
     lootTable (blank).
     Placed on BOSS 120: retail difficultyClass BOSS maps to the BOSS 120 row.
     Retail BaseLevel 83 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; diet = NONE; armor 2 from the BOSS rung. ]]
som_decrepit_cww8_combat_droid = Creature:new {
	customName = "a decrepit CWW8 combat droid",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
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

CreatureTemplates:addCreatureTemplate(som_decrepit_cww8_combat_droid, "som_decrepit_cww8_combat_droid")
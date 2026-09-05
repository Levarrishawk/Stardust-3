mand_bunker_foreman = Creature:new {
	objectName = "",
	customName = "Japer Witter (a mine Foreman)",
	socialGroup = "death_watch",
	mobType = MOB_NPC,
	faction = "",
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9336,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_mand_bunker_foreman.iff"},
	lootGroups = {
		{
			groups = {
				{group = "housing_improvement_01", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "housing_improvement_02", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "housing_improvement_03", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "housing_improvement_04", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "housing_improvement_05", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "col_story_count_dooku_set_3", chance = 10000000}
			},
			lootChance = 100000
		},
		{
			groups = {
				{group = "col_contraband_set_04", chance = 10000000}
			},
			lootChance = 100000
		},
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "deathWatchForemanConvoTemplate",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(mand_bunker_foreman, "mand_bunker_foreman")

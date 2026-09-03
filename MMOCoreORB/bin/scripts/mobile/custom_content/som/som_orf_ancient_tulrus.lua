--[[ som_orf_ancient_tulrus -- Old Republic Facility ancient tulrus boss.
     Retail creatures.tab: BaseLevel 85, difficultyClass BOSS,
     socialGroup orf_tulrus, template som/orf_tulrus.iff,
     lootTable mustafar/mustafar_orf_tulrus.
     Placed on BOSS 120: retail difficultyClass BOSS maps to the BOSS 120 row.
     Retail BaseLevel 85 is recorded here and NOT copied into level.
     Copied from orf_tulrus.lua. armor overridden to 2 (BOSS rung).
     Keeps MOB_HERBIVORE + diet = HERBIVORE to match family anchor
     orf_tulrus.lua, even though retail niche says carnivore -- the family
     convention wins; one divergent template would read as a mistake. ]]
som_orf_ancient_tulrus = Creature:new {
	customName = "an Ancient Tulrus",
	socialGroup = "orf_tulrus",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_herbivore",
	meatAmount = 300,
	hideType = "hide_leathery",
	hideAmount = 200,
	boneType = "bone_mammal",
	boneAmount = 150,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/orf_tulrus.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_orf_ancient_tulrus, "som_orf_ancient_tulrus")
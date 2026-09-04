--[[ som_orf_ancient_xandank -- Old Republic Facility ancient xandank boss.
     Retail creatures.tab: BaseLevel 87, difficultyClass BOSS,
     socialGroup orf_xandank, template som/orf_xandank.iff,
     lootTable mustafar/mustafar_orf_xandank.
     Placed on BOSS 120: retail difficultyClass BOSS maps to the BOSS 120 row.
     Retail BaseLevel 87 is recorded here and NOT copied into level.
     Copied from orf_xandank.lua. armor overridden to 2 (BOSS rung).
     mobType MOB_CARNIVORE and diet = CARNIVORE (retail niche=carnivore);
     meat/hide/bone amounts kept from the anchor. ]]
som_orf_ancient_xandank = Creature:new {
	customName = "an Ancient Xandank",
	socialGroup = "orf_xandank",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 250,
	hideType = "hide_leathery",
	hideAmount = 180,
	boneType = "bone_mammal",
	boneAmount = 120,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/orf_xandank.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_orf_ancient_xandank, "som_orf_ancient_xandank")
cinderclaw = Creature:new {
	customName = "Cinderclaw",
	socialGroup = "blistmok",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {130,130,-1,160,160,160,-1,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 500,
	hideType = "hide_leathery",
	hideAmount = 400,
	boneType = "bone_mammal",
	boneAmount = 375,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/cinderclaw.iff"},
	lootGroups = {
		{
			groups = {
				{group = "resource_creature", chance = 5000000},
				{group = "armor_attachments", chance = 2500000},
				{group = "clothing_attachments", chance = 2500000}
			},
			lootChance = 7000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"creatureareaattack",""}, {"creatureareaknockdown",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(cinderclaw, "cinderclaw")

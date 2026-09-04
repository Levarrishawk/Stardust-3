deathsting = Creature:new {
	customName = "Deathsting",
	socialGroup = "deathsting",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_insect",
	meatAmount = 200,
	hideType = "hide_scaley",
	hideAmount = 150,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/deathsting.iff"},
	lootGroups = {
		{
			groups = {
				{group = "resource_creature", chance = 6000000},
				{group = "junk", chance = 2000000},
				{group = "armor_attachments", chance = 2000000}
			},
			lootChance = 4000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(deathsting, "deathsting")

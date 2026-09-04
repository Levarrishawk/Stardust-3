tulrus_magma_drenched = Creature:new {
	customName = "a Magma-Drenched Tulrus",
	socialGroup = "tulrus",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {130,130,-1,160,160,160,-1,-1,-1},
	meatType = "meat_herbivore",
	meatAmount = 600,
	hideType = "hide_bristley",
	hideAmount = 450,
	boneType = "bone_mammal",
	boneAmount = 400,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/tulrus_magma_drenched.iff"},
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
	primaryAttacks = { {"knockdownattack",""}, {"dizzyattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(tulrus_magma_drenched, "tulrus_magma_drenched")

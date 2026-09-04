xandank_onyx_plated = Creature:new {
	customName = "an Onyx-Plated Xandank",
	socialGroup = "xandank",
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

	templates = {"object/mobile/som/xandank_onyx_plated.iff"},
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

CreatureTemplates:addCreatureTemplate(xandank_onyx_plated, "xandank_onyx_plated")

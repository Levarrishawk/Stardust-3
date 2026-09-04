tremor_foot = Creature:new {
	customName = "Tremor Foot",
	socialGroup = "orf_fauna",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
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

	templates = {"object/mobile/som/tremor_foot.iff"},
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

CreatureTemplates:addCreatureTemplate(tremor_foot, "tremor_foot")

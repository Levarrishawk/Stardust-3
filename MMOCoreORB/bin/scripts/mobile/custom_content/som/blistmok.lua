blistmok = Creature:new {
	customName = "Blistmok",
	socialGroup = "blistmok",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 250,
	hideType = "hide_leathery",
	hideAmount = 180,
	boneType = "bone_mammal",
	boneAmount = 120,
	milk = 0,
	tamingChance = 0.25,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/blistmok.iff"},
	controlDeviceTemplate = "object/intangible/pet/som/blistmok.iff",
	-- Live rolls once at 100% and then picks one of two pools evenly, so this
	-- creature drops something on every kill. The trophy is one of four in its
	-- own pool, so it is still 12.5% per kill -- the same rate the previous
	-- encoding produced. The old lootChance = 1250000 was that 12.5% collapsed
	-- onto the roll itself, which delivered the trophy at the right rate but
	-- dropped nothing the other 87.5% of the time.
	lootGroups = {
		{
			groups = {
				{group = "som_blistmok_trophy", chance = 5000000},
				{group = "som_mustafar_creature", chance = 5000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(blistmok, "blistmok")

master_kah = Creature:new {
	customName = "Master Kah",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
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
	diet = HERBIVORE,

	templates = {"object/mobile/som/master_kah.iff"},
	lootGroups = {
		{
			groups = {
				{group = "townsperson_tier_1", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},
	primaryWeapon = "light_jedi_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(master_kah, "master_kah")

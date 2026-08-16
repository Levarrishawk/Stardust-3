separatist_droideka = Creature:new {
	objectName = "@mob/creature_names:geonosian_droideka_crazed",
	socialGroup = "rebel",
	faction = "separatist",
	mobType = MOB_DROID,
	level = 86,
	chanceHit = 0.81,
	damageMin = 595,
	damageMax = 900,
	baseXp = 8223,
	baseHAM = 14000,
	baseHAMmax = 17000,
	armor = 1,
	resists = {140,155,110,125,125,-1,40,40,-1},
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
  creatureBitmask = PACK,
  optionsBitmask = AIENABLED,
  diet = HERBIVORE,
  scale = 1.05,

	templates = {"object/mobile/droideka.iff"},
	lootGroups = {
         {
			groups = {
				{group = "geonosian_cubes", chance = 10000000}
			},
			lootChance = 1800000
	    }	
	},
	defaultAttack = "attack",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
}

CreatureTemplates:addCreatureTemplate(separatist_droideka, "separatist_droideka")

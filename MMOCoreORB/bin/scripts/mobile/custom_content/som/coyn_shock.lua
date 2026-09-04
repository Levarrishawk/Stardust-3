coyn_shock = Creature:new {
	customName = "a Razor Runner shock trooper",
	socialGroup = "pirate",
	faction = "",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
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

	templates = {"object/mobile/som/coyn_shock.iff"},
	lootGroups = {
		{
			groups = {
				{group = "pirate_tier_1", chance = 10000000}
			}
		}
	},
	primaryWeapon = "pirate_weapons_heavy",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,carbineermaster),
	secondaryAttacks = carbineermaster
}

CreatureTemplates:addCreatureTemplate(coyn_shock, "coyn_shock")

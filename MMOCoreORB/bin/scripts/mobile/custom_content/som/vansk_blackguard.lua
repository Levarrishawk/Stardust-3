-- Vansk of the Blackguard.
-- Loot: live table mustafar/blackguard_vansk_drop (loot group blackguard_vansk_drop).
-- creatures.tab intLootRolls = 2, so two identical lootGroups blocks.
-- master_loot.tab chance 10000/10000 so lootChance = 10000000 on each.
-- Previous wilder_tier_1 / armor_attachments / clothing_attachments were filler,
-- not a tuned choice.
vansk_blackguard = Creature:new {
	customName = "Vansk of the Blackguard",
	socialGroup = "wilder",
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

	templates = {"object/mobile/som/vansk_blackguard.iff"},
	lootGroups = {
		{
			groups = {
				{group = "blackguard_vansk_drop", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "blackguard_vansk_drop", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "pirate_weapons_heavy",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,carbineermaster),
	secondaryAttacks = carbineermaster
}

CreatureTemplates:addCreatureTemplate(vansk_blackguard, "vansk_blackguard")

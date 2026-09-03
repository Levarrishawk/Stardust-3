-- Storm Lord open-world boss.
-- Loot: live table mustafar/storm_lord_drop (loot group storm_lord_drop).
-- creatures.tab intLootRolls = 3, so three identical lootGroups blocks.
-- master_loot.tab chance 10000/10000 so lootChance = 10000000 on each.
-- Previous dark_jedi_tier_5 / force_tier_4 / holocron / crystal / attachment
-- groups were filler, not a tuned choice.
storm_lord = Creature:new {
	customName = "Storm Lord",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
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

	templates = {"object/mobile/som/storm_lord.iff"},
	lootGroups = {
		{
			groups = {
				{group = "storm_lord_drop", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "storm_lord_drop", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "storm_lord_drop", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "melee_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(brawlermaster,swordsmanmaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(storm_lord, "storm_lord")

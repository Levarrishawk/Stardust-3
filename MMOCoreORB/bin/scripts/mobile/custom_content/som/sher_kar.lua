-- Sher Kar open-world / lair boss.
-- Loot: live table mustafar/sher_kar_loot (loot group sher_kar_loot). creatures.tab
-- intLootRolls = 2, so two identical lootGroups blocks. master_loot.tab chance
-- 10000/10000 so lootChance = 10000000 on each. Previous dark_jedi_tier_5 /
-- force_tier_4 / crystal / attachment groups were filler, not a tuned choice.
sher_kar = Creature:new {
	customName = "Sher Kar",
	socialGroup = "sher_kar",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 200,
	chanceHit = 16,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19008,
	baseHAM = 160000,
	baseHAMmax = 195000,
	armor = 3,
	resists = {165,145,35,35,35,35,35,35,-1},
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
	creatureBitmask = PACK + STALKER + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/sher_kar.iff"},
	lootGroups = {
		{
			groups = {
				{group = "sher_kar_loot", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "sher_kar_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"creatureareaattack",""}, {"creatureareaknockdown",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(sher_kar, "sher_kar")

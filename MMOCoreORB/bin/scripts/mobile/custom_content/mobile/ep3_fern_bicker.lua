-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1336 (ep3_fern_bicker, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_fern_bicker = Creature:new {
	customName = "ep3_fern_bicker",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "fern_bicker",
	faction = "",
	level = 4,
	chanceHit = 0.24,
	damageMin = 40,
	damageMax = 45,
	baseXp = 62,
	baseHAM = 113,
	baseHAMmax = 118,
	armor = 0,
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
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3_fern_bicker.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_fern_bicker lootList kashyyyk_fern_bicker intLootRolls=1 creatures.tab line 1336 (ep3_fern_bicker).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_fern_bicker", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(ep3_fern_bicker, "ep3_fern_bicker")

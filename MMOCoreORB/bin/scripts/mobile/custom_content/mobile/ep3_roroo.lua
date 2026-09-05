-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1387 (ep3_hracca_noxious_roroo, where=hracca, NORMAL); 1503 (ep3_roroo, where=kachirho, NORMAL; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_roroo = Creature:new {
	customName = "a ro-roo",
	socialGroup = "roroo",
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

	templates = {"object/mobile/ep3_roroo.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_roroo lootList kashyyyk_roroo intLootRolls=1 creatures.tab line 1503 (ep3_roroo).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_roroo", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(ep3_roroo, "ep3_roroo")

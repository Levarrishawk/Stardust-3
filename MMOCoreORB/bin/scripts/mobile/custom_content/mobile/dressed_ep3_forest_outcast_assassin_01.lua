-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1345 (ep3_forest_exemplar_zheus, where=dead_forest, ELITE); 1354 (ep3_forest_outcast_assassin, where=dead_forest, ELITE; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
dressed_ep3_forest_outcast_assassin_01 = Creature:new {
	customName = "human_base_male",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "forest_webweaver",
	faction = "forest_outcast",
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

	templates = {"object/mobile/dressed_ep3_forest_outcast_assassin_01.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/forest_outcast lootList forest_outcast intLootRolls=1 creatures.tab line 1354 (ep3_forest_outcast_assassin).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "forest_outcast", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(dressed_ep3_forest_outcast_assassin_01, "dressed_ep3_forest_outcast_assassin_01")

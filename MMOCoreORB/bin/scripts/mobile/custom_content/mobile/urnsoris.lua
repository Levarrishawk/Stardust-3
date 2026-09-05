-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1581 (ep3_urnsoris_eviscerater, where=myyydril, ELITE; primary); 1583 (ep3_urnsoris_nefarious, where=myyydril, ELITE); 1587 (ep3_urnsoris_soldier, where=myyydril, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
urnsoris = Creature:new {
	customName = "urnsoris",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "myyydril_urn",
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

	templates = {"object/mobile/urnsoris.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/myyydril_eviserator lootList myyydril_eviserator intLootRolls=1 creatures.tab line 1581 (ep3_urnsoris_eviscerater).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "myyydril_eviserator", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(urnsoris, "urnsoris")

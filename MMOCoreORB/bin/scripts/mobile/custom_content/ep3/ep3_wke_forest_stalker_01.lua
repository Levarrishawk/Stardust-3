-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1476 (ep3_npc_wookiee_forest_stalker, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_wke_forest_stalker_01 = Creature:new {
	customName = "Forest Stalker",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "kashyyyk_resistance",
	faction = "kashyyyk_resistance",
	mobType = MOB_NPC,
	level = 105,
	chanceHit = 1.05,
	damageMin = 1150,
	damageMax = 1470,
	baseXp = 7500,
	baseHAM = 80000,
	baseHAMmax = 90000,
	armor = 1,
	resists = {60,60,60,60,60,60,60,60,-1},
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_wke_forest_stalker_01.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/wke_resistance lootList wke_resistance intLootRolls=1 creatures.tab line 1476 (ep3_npc_wookiee_forest_stalker).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "wke_resistance", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {"chewbacca_weapons"},
	conversationTemplate = "",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_wke_forest_stalker_01, "ep3_wke_forest_stalker_01")

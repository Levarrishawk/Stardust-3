-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1252 (ep3_avatar_wke_fighter, where=avatar, ELITE); 1477 (ep3_npc_wookiee_freedom_fighters, where=kachirho, NORMAL; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_wke_freedom_fighter_04 = Creature:new {
	customName = "Freedom Fighter",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "kashyyyk_resistance",
	faction = "kashyyyk_resistance",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.45,
	damageMin = 750,
	damageMax = 900,
	baseXp = 4500,
	baseHAM = 20000,
	baseHAMmax = 30000,
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

	templates = {"object/mobile/ep3/ep3_wke_freedom_fighter_04.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/wke_resistance lootList wke_resistance intLootRolls=1 creatures.tab line 1477 (ep3_npc_wookiee_freedom_fighters).
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

CreatureTemplates:addCreatureTemplate(ep3_wke_freedom_fighter_04, "ep3_wke_freedom_fighter_04")

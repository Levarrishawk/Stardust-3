-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1251 (ep3_avatar_wke_commando, where=avatar, ELITE); 1475 (ep3_npc_wookiee_commando, where=kachirho, NORMAL; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_wke_commando_02 = Creature:new {
	customName = "Wookiee Commando",
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

	templates = {"object/mobile/ep3/ep3_wke_commando_02.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/wke_resistance_commando lootList wke_resistance_commando intLootRolls=1 creatures.tab line 1475 (ep3_npc_wookiee_commando).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "wke_resistance_commando", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(brawlermaster,marksmanmaster,commandomaster,bountyhuntermaster)
}

CreatureTemplates:addCreatureTemplate(ep3_wke_commando_02, "ep3_wke_commando_02")

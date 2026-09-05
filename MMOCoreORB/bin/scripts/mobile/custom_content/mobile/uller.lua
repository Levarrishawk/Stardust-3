-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1239 (ep3_arena_uller_hellstalker, where=arena, ELITE); 1274 (ep3_cr_uller, where=kashyyyk, NORMAL; primary); 1319 (ep3_etyyy_uller, where=etyyy, NORMAL); 1320 (ep3_etyyy_uller_diseased, where=etyyy, NORMAL); 1321 (ep3_etyyy_uller_elder, where=etyyy, NORMAL); 1322 (ep3_etyyy_uller_spiketop, where=etyyy, ELITE); 1323 (ep3_etyyy_uller_warhoof, where=etyyy, ELITE); 1388 (ep3_hracca_noxious_uller, where=hracca, NORMAL); 1405 (ep3_kachirho_uller, where=kachirho, NORMAL); 1406 (ep3_kachirho_uller_packleader, where=kachirho, NORMAL); 1407 (ep3_kachirho_uller_stoneclaw, where=kachirho, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
uller = Creature:new {
	customName = "uller",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "uller",
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

	templates = {"object/mobile/uller.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_uller lootList kashyyyk_uller intLootRolls=1 creatures.tab line 1274 (ep3_cr_uller).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_uller", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(uller, "uller")

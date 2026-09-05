-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1241 (ep3_arena_webweaver_bonerender, where=arena, ELITE); 1277 (ep3_cr_webweaver, where=kashyyyk, NORMAL; primary); 1328 (ep3_etyyy_webweaver, where=etyyy, NORMAL); 1329 (ep3_etyyy_webweaver_crazed, where=etyyy, NORMAL); 1330 (ep3_etyyy_webweaver_silkthrower, where=etyyy, ELITE); 1331 (ep3_etyyy_webweaver_spiker, where=etyyy, ELITE); 1332 (ep3_etyyy_webweaver_warrior, where=etyyy, NORMAL); 1351 (ep3_forest_mother_vesad, where=dead_forest, ELITE); 1372 (ep3_forest_webweaver_bloodseeker, where=dead_forest, NORMAL); 1373 (ep3_forest_webweaver_gravespinner, where=dead_forest, NORMAL); 1374 (ep3_forest_webweaver_tombsinger, where=dead_forest, NORMAL); 1551 (ep3_rryatt_webweaver_darkstalker, where=rryatt_trail, NORMAL); 1552 (ep3_rryatt_webweaver_shadowravager, where=rryatt_trail, NORMAL); 1553 (ep3_rryatt_webweaver_trailphantom, where=rryatt_trail, NORMAL); 1570 (ep3_slaver_controlled_webweaver, where=slave_camp, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
webweaver = Creature:new {
	customName = "Webweaver",
	socialGroup = "webweaver",
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

	templates = {"object/mobile/webweaver.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_webweaver lootList kashyyyk_webweaver intLootRolls=1 creatures.tab line 1277 (ep3_cr_webweaver).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_webweaver", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(webweaver, "webweaver")

-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1276 (ep3_cr_walluga, where=kashyyyk, NORMAL); 1324 (ep3_etyyy_walluga, where=etyyy, NORMAL); 1325 (ep3_etyyy_walluga_elder, where=etyyy, NORMAL); 1326 (ep3_etyyy_walluga_frenzied, where=etyyy, ELITE); 1327 (ep3_etyyy_walluga_stoneleg, where=etyyy, ELITE); 1389 (ep3_hracca_noxious_walluga, where=hracca, NORMAL); 1412 (ep3_kachirho_walluga, where=kachirho, NORMAL); 1413 (ep3_kachirho_walluga_bonecrusher, where=kachirho, NORMAL); 1414 (ep3_kachirho_walluga_stoneskin, where=kachirho, NORMAL); 1548 (ep3_rryatt_walluga_smasher, where=rryatt_trail, NORMAL); 1549 (ep3_rryatt_walluga_smasher_boss, where=rryatt_trail, BOSS); 1550 (ep3_rryatt_walluga_smasher_elite, where=rryatt_trail, ELITE); 5636 (walluga, where=kashyyyk, NORMAL; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
walluga = Creature:new {
	customName = "Walluga",
	socialGroup = "walluga",
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

	templates = {"object/mobile/walluga.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_walluga lootList kashyyyk_walluga intLootRolls=1 creatures.tab line 1276 (ep3_cr_walluga).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_walluga", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(walluga, "walluga")

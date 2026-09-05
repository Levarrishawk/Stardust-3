-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1240 (ep3_arena_varactyl_venomblade, where=arena, ELITE); 1275 (ep3_cr_varactyl, where=kashyyyk, NORMAL); 1408 (ep3_kachirho_varactyl, where=kachirho, NORMAL); 1409 (ep3_kachirho_varactyl_deathspine, where=kachirho, NORMAL; primary); 1410 (ep3_kachirho_varactyl_jaggedfang, where=kachirho, BOSS); 1411 (ep3_kachirho_varactyl_preystalker, where=kachirho, NORMAL); 1427 (ep3_mount_varactyl, where=global, NORMAL); 1490 (ep3_qst_reward_varactyl, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
varactyl_deathspine = Creature:new {
	customName = "a Deathspine Varactyl",
	socialGroup = "kachirho_varactyl",
	faction = "",
	level = 50,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/varactyl.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_varactyl lootList kashyyyk_varactyl intLootRolls=1 creatures.tab line 1409 (ep3_kachirho_varactyl_deathspine).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_varactyl", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	scale = 1.35,
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(varactyl_deathspine, "varactyl_deathspine")

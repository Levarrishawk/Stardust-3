-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1240 (ep3_arena_varactyl_venomblade, where=arena, ELITE); 1275 (ep3_cr_varactyl, where=kashyyyk, NORMAL); 1408 (ep3_kachirho_varactyl, where=kachirho, NORMAL); 1409 (ep3_kachirho_varactyl_deathspine, where=kachirho, NORMAL); 1410 (ep3_kachirho_varactyl_jaggedfang, where=kachirho, BOSS; primary); 1411 (ep3_kachirho_varactyl_preystalker, where=kachirho, NORMAL); 1427 (ep3_mount_varactyl, where=global, NORMAL); 1490 (ep3_qst_reward_varactyl, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
varactyl_jagged_fang = Creature:new {
	customName = "Jagged Fang",
	socialGroup = "kachirho_varactyl",
	faction = "",
	level = 221,
	chanceHit = 19,
	damageMin = 1245,
	damageMax = 2200,
	baseXp = 20948,
	baseHAM = 350000,
	baseHAMmax = 350000,
	armor = 1,
	resists = {80,80,90,80,45,45,100,70,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE +ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/varactyl.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_varactyl lootList kashyyyk_varactyl intLootRolls=1 creatures.tab line 1275 (ep3_cr_varactyl).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_varactyl", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	scale = 1.5,
	weapons = {},
	conversationTemplate = "",
	attacks = {
		{"creatureareadisease",""},
		{"dizzyattack",""}
	}
}

CreatureTemplates:addCreatureTemplate(varactyl_jagged_fang, "varactyl_jagged_fang")

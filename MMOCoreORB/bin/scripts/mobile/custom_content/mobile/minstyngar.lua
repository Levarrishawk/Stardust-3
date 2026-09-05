-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1272 (ep3_cr_minstyngar, where=kashyyyk, NORMAL; primary); 1525 (ep3_rryatt_minstyngar_breeder, where=rryatt_trail, NORMAL); 1526 (ep3_rryatt_minstyngar_elite_bloodspiller, where=rryatt_trail, ELITE); 1527 (ep3_rryatt_minstyngar_elite_bonecrusher, where=rryatt_trail, ELITE); 1528 (ep3_rryatt_minstyngar_elite_deathcaller, where=rryatt_trail, ELITE); 1529 (ep3_rryatt_minstyngar_lvl3_boss, where=rryatt_trail, BOSS); 1530 (ep3_rryatt_minstyngar_preyfinder, where=rryatt_trail, NORMAL); 1531 (ep3_rryatt_minstyngar_thrasher, where=rryatt_trail, NORMAL); 1537 (ep3_rryatt_qst_minstyngar, where=rryatt_trail, NORMAL); 1572 (ep3_slaver_selindrolich, where=slave_camp, BOSS).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
minstyngar = Creature:new {
	customName = "Minstyngar",
	socialGroup = "minstyngar",
	faction = "",
	level = 400,
	chanceHit = 500,
	damageMin = 1800,
	damageMax = 3600,
	baseXp = 79336,
	baseHAM = 2050000,
	baseHAMmax = 2200000,
	armor = 1,
	resists = {45,30,45,50,40,30,35,45,35},
	meatType = "meat_carnivore",
	meatAmount = 1000,
	hideType = "hide_leathery",
	hideAmount = 870,
	boneType = "bone_mammal",
	boneAmount = 805,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = 128,
	diet = CARNIVORE,
	scale = 1,
	templates = {"object/mobile/minstyngar.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_minstyngar lootList kashyyyk_minstyngar intLootRolls=1 creatures.tab line 1272 (ep3_cr_minstyngar).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_minstyngar", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	    {"creatureareaknockdown","knockdownChance=90"},
		{"creatureareadisease","stateAccuracyBonus=100"},
		{"dizzyattack","stateAccuracyBonus=100"},
		{"strongpoison","stateAccuracyBonus=100"},
		{"creatureareapoison","stateAccuracyBonus=100"}
	}
}

CreatureTemplates:addCreatureTemplate(minstyngar, "minstyngar")

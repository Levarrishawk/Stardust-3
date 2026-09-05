-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1268 (ep3_cr_bantha_kashyyyk, where=kashyyyk, NORMAL); 1283 (ep3_etyyy_bantha_kashyyyk, where=etyyy, NORMAL); 1284 (ep3_etyyy_bantha_kashyyyk_greyclimber, where=etyyy, ELITE); 1285 (ep3_etyyy_bantha_kashyyyk_herdleader, where=etyyy, NORMAL); 1286 (ep3_etyyy_bantha_kashyyyk_matriarch, where=etyyy, NORMAL); 1383 (ep3_hracca_noxious_bantha_kashyyyk, where=hracca, NORMAL); 1392 (ep3_kachirho_bantha, where=kachirho, NORMAL); 1393 (ep3_kachirho_bantha_bull, where=kachirho, NORMAL; primary); 1394 (ep3_kachirho_bantha_matriarch, where=kachirho, NORMAL); 1426 (ep3_mount_kashyyyk_bantha, where=global, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
kashyyyk_bull_bantha = Creature:new {
	customName = "a Bull Kashyyyk Bantha",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "bantha_kashyyyk",
	faction = "",
	mobType = MOB_HERBIVORE,
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

	templates = {"object/mobile/kashyyyk_bantha.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_bantha lootList kashyyyk_bantha intLootRolls=1 creatures.tab line 1393 (ep3_kachirho_bantha_bull).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_bantha", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(kashyyyk_bull_bantha, "kashyyyk_bull_bantha")

-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1269 (ep3_cr_bolotaur, where=kashyyyk, NORMAL; primary); 1395 (ep3_kachirho_bolotaur, where=kachirho, NORMAL); 1396 (ep3_kachirho_bolotaur_fleshripper, where=kachirho, NORMAL); 1397 (ep3_kachirho_bolotaur_sunbaked, where=kachirho, NORMAL); 1425 (ep3_mount_bolotaur, where=global, NORMAL); 1510 (ep3_rryatt_bolotaur_bonegouged, where=rryatt_trail, NORMAL); 1511 (ep3_rryatt_bolotaur_darkgnasher, where=rryatt_trail, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
bolotaur = Creature:new {
	customName = "Bolotaur",
	--randomNameType = NAME_GENERIC,
	--randomNameTag = true,
	socialGroup = "bolotaur",
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
	templates = {"object/mobile/bolotaur.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_bolotaur lootList kashyyyk_bolotaur intLootRolls=1 creatures.tab line 1269 (ep3_cr_bolotaur).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this file.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_bolotaur", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}
CreatureTemplates:addCreatureTemplate(bolotaur, "bolotaur")

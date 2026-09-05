-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1384 (ep3_hracca_noxious_kklyyytt, where=hracca, NORMAL); 1417 (ep3_kklyyytt, where=kachirho, NORMAL; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_kklyyytt = Creature:new {
	customName = "ep3_kklyyytt",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "kklyyytt",
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

	templates = {"object/mobile/ep3_kklyyytt.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/kashyyyk_kkryytch lootList kashyyyk_kkryytch intLootRolls=1 creatures.tab line 1417 (ep3_kklyyytt).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "kashyyyk_kkryytch", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(ep3_kklyyytt, "ep3_kklyyytt")

-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1378 (ep3_general_grievous, where=myyydril, BOSS).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
general_grievous = Creature:new {
	--objectName = "@mob/creature_names:ep3_general_grievous",
	customName = "General Grievous",
	socialGroup = "myyydril_grievous",
	pvpFaction = "",
	faction = "",
	mobType = MOB_ANDROID,
	level = 300,
	chanceHit = 100,
	damageMin = 2000,
	damageMax = 4000,
	baseXp = 16884,
	baseHAM = 585000,
	baseHAMmax = 1085000,
	armor = 0,
	resists = {90,90,90,90,90,90,90,90,90},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED + INTERESTING,
	diet = HERBIVORE,
	scale = 1.5,

	templates = {"object/mobile/ep3/general_grievous.iff"},
	-- SOURCED (ruling 2026-09-04): lootTable kashyyyk/myyydril_grievous lootList myyydril_grievous intLootRolls=1 creatures.tab line 1378 (ep3_general_grievous).
	-- OURS: chance=10000000 lootChance=10000000 (Mustafar roll numbers; single group occupies the full 10M). collectionLoot/chronicle not this round.
	lootGroups = {
		{
			groups = {
				{group = "myyydril_grievous", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	weapons = {"dark_jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(general_grievous, "general_grievous")

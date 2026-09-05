-- OURS: exact SOE name for the placement rows; the guild_f file is this fork's earlier spelling
-- ruling 2026-09-04: "ensure kashyyyk is fully done"

ep3_rryatt_trail_guide_f_02 = Creature:new {
	customName = "Rryatt Trail Guide",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 30,
	chanceHit = 0.33,
	damageMin = 180,
	damageMax = 190,
	baseXp = 1609,
	baseHAM = 4500,
	baseHAMmax = 5500,
	armor = 0,
	resists = {10,10,10,10,10,10,10,-1,-1},
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
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_rryatt_trail_guild_f_02.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "rryatt_trail_guide_convo",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_rryatt_trail_guide_f_02, "ep3_rryatt_trail_guide_f_02")

mtp_hideout_col_eavesdrop_npc_01 = Creature:new {
	customName = "human_base_male",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "meatlump", -- SOURCED creatures.tab:6108 where=meatlumps_hideout
	faction = "townsperson",
	mobType = MOB_NPC,
	level = 4, -- OURS placeholder (creatures.tab BaseLevel 100; Kashyyyk stub shape)
	chanceHit = 0.24, -- OURS
	damageMin = 40, -- OURS
	damageMax = 45, -- OURS
	baseXp = 62, -- OURS
	baseHAM = 113, -- OURS
	baseHAMmax = 118, -- OURS
	armor = 0, -- OURS
	resists = {0,0,0,0,0,0,0,-1,-1}, -- OURS
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
	creatureBitmask = NONE, -- OURS
	optionsBitmask = AIENABLED + CONVERSABLE + INVULNERABLE, -- creatures.tab:6108 invulnerable=1
	diet = HERBIVORE, -- OURS

	templates = {"object/mobile/dressed_meatlump_hideout_male_04.iff"}, -- SOURCED creatures.tab:6108 template=meatlump_thug (species group, not an iff)
	lootGroups = {},
	weapons = {}, -- OURS
	conversationTemplate = "mtp_hideout_col_eavesdrop_convo",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(mtp_hideout_col_eavesdrop_npc_01, "mtp_hideout_col_eavesdrop_npc_01")

mtp_quest_crate_breaker = Creature:new {
	customName = "Crate Breaker",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "crate_breaker", -- SOURCED creatures.tab:6009
	faction = "",
	mobType = MOB_NPC,
	level = 45, -- OURS placeholder (creatures.tab BaseLevel 63; Kashyyyk stub shape)
	chanceHit = 0.45, -- OURS
	damageMin = 750, -- OURS
	damageMax = 900, -- OURS
	baseXp = 4500, -- OURS
	baseHAM = 20000, -- OURS
	baseHAMmax = 30000, -- OURS
	armor = 1, -- OURS
	resists = {60,60,60,60,60,60,60,60,-1}, -- OURS
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
	creatureBitmask = PACK, -- OURS
	optionsBitmask = AIENABLED + CONVERSABLE + INVULNERABLE,
	diet = HERBIVORE, -- OURS

	templates = {"object/mobile/dressed_assassin_mission_giver_imp_hum_m_02.iff"}, -- SOURCED creatures.tab:6009
	lootGroups = {},
	weapons = {"pirate_weapons_light"}, -- OURS
	conversationTemplate = "mtp_hideout_access_crate_breaker_convo",
	attacks = merge(brawlermaster,marksmanmaster) -- OURS
}

CreatureTemplates:addCreatureTemplate(mtp_quest_crate_breaker, "mtp_quest_crate_breaker")

theme_park_imperial_inquisitor_contact = Creature:new {
	objectName = "@mob/creature_names:imperial_inquisitor",
	socialGroup = "imperial",
	faction = "imperial",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = {
		"object/mobile/tatooine_npc/hedon_istee.iff",
		"object/mobile/tatooine_npc/brea_tonnika.iff"
	},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	outfit = "inquisitor_outfit",
	conversationTemplate = "theme_park_imperial_mission_target_convotemplate",
	primaryAttacks = {},
	secondaryAttacks = {}
}

CreatureTemplates:addCreatureTemplate(theme_park_imperial_inquisitor_contact, "theme_park_imperial_inquisitor_contact")

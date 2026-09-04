-- Chief Ulon Glost -- giver and turn-in for the "Man Eater" tulrus hunt.
-- Stands in entrance_room_01 of the Mensix Mining Facility.
--
-- Name is live-sourced: SOE's conversation/maneater_ulon script sets the mob's
-- name to "Chief Ulon Glost" on attach.  The live facility spawn table places
-- som_chief_glost in entrance_room_01 at -9.5 / 10.8 / 52.6, heading 90, and
-- names conversation.maneater_ulon in its script column.  Both are reproduced
-- in mensix_mining_facility_main.lua, which owns the spawn.
--
-- APPEARANCE IS A REPO CHOICE, not a live value.  No chief_glost.iff ships in
-- any .tre, and the live spawn table carries no appearance column.
-- mustafarian_m_01.iff is the generic Mustafarian miner model this repo
-- already uses for the facility's other foremen and chiefs.  Stat block copied
-- from chief_armstrong.lua -- he is a conversation NPC, not a combat
-- encounter, and live marks him invulnerable.

chief_glost = Creature:new {
	customName = "Chief Ulon Glost",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_01.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "maneater_ulon",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(chief_glost, "chief_glost")

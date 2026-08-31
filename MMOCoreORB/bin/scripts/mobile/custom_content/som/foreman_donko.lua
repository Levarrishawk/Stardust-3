-- Donko Jen -- giver and turn-in for som_lava_beetle_nest_destroy and its
-- repeat variant som_lava_beetle_nest_destroy_2.  Stands in
-- entrance_room_01 of the Mensix Mining Facility.
--
-- Name is live-sourced: som_lava_beetle_nest_destroy.stf names him "Donko
-- Jen" in task02 and task04.  SOE's own conversation script is
-- conversation/lava_beetle_nest_destroy_donko, hence the tree file's name.
-- He mistakes the player for a new crew hire, so he is a crew foreman.
--
-- APPEARANCE IS A REPO CHOICE, not a live value.  No foreman_donko.iff
-- ships in any .tre and the live spawn table carries no appearance column.
-- mustafarian_m_02.iff is the foreman-tier generic this repo already uses
-- for miner_foreman_on_strike.lua.  Stat block copied from
-- foreman_nurfa.lua -- conversation NPC, not a combat encounter.

foreman_donko = Creature:new {
	customName = "Donko Jen",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
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

	templates = {"object/mobile/som/mustafarian_m_02.iff"},
	lootGroups = {},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "lava_beetle_nest_destroy_donko",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(foreman_donko, "foreman_donko")

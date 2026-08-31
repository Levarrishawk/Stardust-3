-- Surveyor Keslev -- giver for "The Mining Field Markers".
-- Stands in small_room_05 of the Mensix Mining Facility.
--
-- Name is live-sourced.  All seven shipped quest journals --
-- som_exploration_{berken,burning,crystal,mining,smoking,tulrus,volcano}.stf -- say
-- "Surveyor Keslev has asked you to...".  There is no middle name; the "Jo" this
-- replaces came from the wiki.  The live facility spawn table names the mobile
-- som_surveyor_keslev, places it in small_room_05 at -145.6 / 18.6 / -58.1 heading
-- -80, and names conversation.som_exploration_marker in its script column.  The spawn
-- itself lives in mining_field_markers.lua, which owns this quest.
--
-- APPEARANCE IS A REPO CHOICE, not a live value.  The live spawn table carries no
-- appearance column and no keslev .iff ships in any .tre.  miner_hens.iff is the model
-- the earlier surveyor_jo template used and it is kept so nothing about how he looks
-- changes with the rename.  Stat block is the same conversation-NPC block chief_glost.lua
-- uses -- he is a quest giver, not an encounter.

som_surveyor_keslev = Creature:new {
	customName = "Surveyor Keslev",
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
	scale = 1.2,
	pvpBitmask = NONE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/miner_hens.iff"},
	lootGroups = {},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "som_exploration_marker",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_surveyor_keslev, "som_surveyor_keslev")

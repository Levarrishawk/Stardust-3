-- som_kenobi_main_quest_1 support NPC -- the technician who guards the search
-- terminal in the Mensix mining facility. som_kenobi_main_quest_1 task 0 is a
-- Wait-for-Signal on 'talkedToTechnician' and he is what fires it.
--
-- No proper name appears in any som STF; named descriptively, matching repo
-- convention for unnamed roles. (The earlier header on this file called him a
-- moral_choice NPC. That was wrong -- no moral_choice task or string mentions
-- him -- and it is corrected here rather than left standing.)
som_mustafarian_computer_technician = Creature:new {
	customName = "a Computer Technician",
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_mustafarian_computer_technician.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "som_kenobi_computer_technician",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_mustafarian_computer_technician, "som_mustafarian_computer_technician")

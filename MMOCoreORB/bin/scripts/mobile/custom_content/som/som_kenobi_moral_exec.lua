-- moral_choice quest giver -- the mining corporation executive.
--
-- Reuse the Mustafarian appearance worn by Urup Fal'co in the same room.
-- The Neimoidian appearance references missing arm and body mesh generators,
-- which make the client render the default appearance cube.
--
-- ATTACKABLE, not invulnerable, and no faction: nothing in the .qst kills him,
-- but s_45 in his string table ("You have ruined me! I thought I could trust you,
-- you rotting mynock!") is what he says to a player who took the miners' side,
-- so he has to survive the betrayal and keep standing there.
som_kenobi_moral_exec = Creature:new {
	customName = "a Mining Corporation Executive",
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_02.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "som_kenobi_moral_exec",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_moral_exec, "som_kenobi_moral_exec")

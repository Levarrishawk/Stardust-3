-- som_obi_wan_signal_1 target -- the dying miner at the new mining facility.
--
-- DSRC's som_dying_miner creature row uses mustafarian_m_01.iff. The
-- quest.som.dying_miner script grants the next quest through an examine radial.
--
-- Scenery only: never fights, never dies. The 'Examine the dying miner' radial
-- is supplied at spawn time by the screenplay via SceneObject:setObjectMenuComponent().
som_kenobi_dying_miner = Creature:new {
	customName = "a Dying Miner",
	socialGroup = "",
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_01.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_dying_miner, "som_kenobi_dying_miner")

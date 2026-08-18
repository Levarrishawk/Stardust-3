-- Ben Kenobi for the Mustafar Kenobi arc -- som_obi_wan_signal_1/2 and
-- som_kenobi_main_quest_1 through _3.
--
-- WHY THIS IS NOT obi_wan_ghost. conversationTemplate binds to the creature
-- template, not to the spawned instance, so pointing the arc's dialogue at
-- obi_wan_ghost would replace obi_wan_elysium on every Ben Kenobi in the game.
-- obi_wan_elysium is World Beyond Worlds content and is left exactly as it is.
-- This is an additive template that reuses the same registered appearance,
-- object/mobile/som/obi_wan_ghost.iff -- the same thing som_kenobi_moral_exec
-- does with neimoidian.iff. No new object template is added.
--
-- INVULNERABLE, and no faction. The arc never fights him; he is spawned twice,
-- once on the northeastern shoreline (s_266, s_302) and once at the chamber
-- entrance stone (s_162), and the screenplay tags which is which. Nothing in
-- any of the six .qst files makes him a target, so he cannot be attacked and
-- cannot die between the shoreline and the finale.
--
-- scale 1.1 matches obi_wan_ghost, so the two stand the same height.
som_kenobi_obi_wan = Creature:new {
	customName = "Ben Kenobi (a Hermit)",
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
	scale = 1.1,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/obi_wan_ghost.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "som_kenobi_obi_wan",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_obi_wan, "som_kenobi_obi_wan")

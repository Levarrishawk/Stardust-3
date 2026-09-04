-- historian chain ambusher. She meditates until you hail her, then kills you for it,
-- so CONVERSABLE and not aggressive -- see the tree header in
-- conversations/mustafar/som_kenobi_historian_dark_jedi.lua. She was AGGRESSIVE with
-- no conversationTemplate, which inverted the encounter: an aggressive agent charges
-- on sight, so the player never got to hail her and her whole conversation was dead.
-- Her sibling som_kenobi_serpent_dark_jedi is the same creature to the stat and
-- taunts before her fight too; this now matches it.
som_kenobi_historian_dark_jedi = Creature:new {
	customName = "a Dark Jedi",
	socialGroup = "dark_jedi",
	faction = "",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
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
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_kenobi_historian_dark_jedi.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_4", chance = 6000000},
				{group = "color_crystals", chance = 2000000},
				{group = "power_crystals", chance = 1000000},
				{group = "holocron_dark", chance = 1000000}
			},
			lootChance = 5000000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen3",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "som_kenobi_historian_dark_jedi",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(som_kenobi_historian_dark_jedi, "som_kenobi_historian_dark_jedi")

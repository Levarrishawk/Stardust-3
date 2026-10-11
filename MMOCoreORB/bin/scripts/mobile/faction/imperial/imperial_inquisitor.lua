imperial_inquisitor = Creature:new {
	objectName = "@mob/creature_names:imperial_inquisitor",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "imperial",
	faction = "imperial",
	level = 200,
	chanceHit = 15,
	damageMin = 1200,
	damageMax = 2200,
	baseXp = 11296,
	baseHAM = 175000,
	baseHAMmax = 210000,
	armor = 2,
	resists = {75,75,75,75,75,75,75,75,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.000000,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/tatooine_npc/hedon_istee.iff",
		"object/mobile/tatooine_npc/brea_tonnika.iff"
	},
	outfit = "inquisitor_outfit",
	lootGroups = {
		{
			groups = {
				{group = "imperial_marshall_tier_4", chance = 10000000}
			}
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen4",
	secondaryWeapon = "none",
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	personalityStf = "@hireling/hireling_military",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster,forcewielder),
	secondaryAttacks = {}
}

CreatureTemplates:addCreatureTemplate(imperial_inquisitor, "imperial_inquisitor")

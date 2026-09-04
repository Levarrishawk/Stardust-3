-- reunite_shard chain ambusher.
-- faction deliberately left empty: making him faction "imperial" would put
-- Imperial-aligned players in a TEF bind on a quest they must be able to finish.
som_kenobi_reunite_dark_trooper = Creature:new {
	customName = "a Dark Trooper",
	socialGroup = "imperial",
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_kenobi_reunite_dark_trooper.iff"},
	lootGroups = {
		{
			groups = {
				{group = "imperial_tier_3", chance = 8000000},
				{group = "armor_attachments", chance = 1000000},
				{group = "clothing_attachments", chance = 1000000}
			},
			lootChance = 5000000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "imperial_weapons_heavy",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(marksmanmaster,commandomaster),
	secondaryAttacks = commandomaster
}

CreatureTemplates:addCreatureTemplate(som_kenobi_reunite_dark_trooper, "som_kenobi_reunite_dark_trooper")

-- moral_choice task 15 -- som_mustafarian_corrupt_security_guard, substituted.
--
-- The .qst names the creature and it does not exist. Nothing on the planet does
-- either: a sweep of every customName in mobile/custom_content/som/ turns up only
-- Vansk of the Blackguard, a blackguard elite minion, a blackguard minion, a
-- blackguard wilder, a storm lord guard, a treasure hunter guard, an Ancient
-- Guardian and an Old Republic security droid. None of them is corporate
-- security, and all of them are already somebody else's population.
--
-- So this is a new template on the one guard appearance the planet has that is
-- neither a droid nor a named faction -- object/mobile/som/treasure_hunter_guard.iff
-- -- carrying the name the .qst asks for. The stats are treasure_hunter_guard's,
-- unchanged, so these are exactly as dangerous as the guards the .qst's own level
-- band implies.
--
-- AGGRESSIVE + ATTACKABLE + ENEMY in the template, unlike the guard it is copied
-- from. Task 15 is an Encounter that drops three of them 25-50 m from the player
-- after the upload, and the strike leader's own line (s_206 / s_288) says what
-- they are for: "Be careful of guards on the executive's payroll. They will try
-- to stop you if they figure out what you are up to." They start the fight
-- themselves, the same way som_pwwoz_thug_1 and _2 do.
som_kenobi_moral_corrupt_guard = Creature:new {
	customName = "a corrupt security guard",
	socialGroup = "thug",
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/treasure_hunter_guard.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(marksmanmid,brawlermid),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_moral_corrupt_guard, "som_kenobi_moral_corrupt_guard")

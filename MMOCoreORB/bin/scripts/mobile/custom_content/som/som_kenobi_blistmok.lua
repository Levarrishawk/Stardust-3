-- Quest-spawn variant of the Mustafar blistmok; name matches the sibling
-- template mobile/custom_content/som/blistmok.lua and the client's
-- @monster_name:blistmok.
--
-- mobType was MOB_HERBIVORE, which looked like it was read off the former
-- diet = HERBIVORE (now diet = CARNIVORE to match MOB_CARNIVORE). That field
-- is not a mobType signal in this set -- blackguard.lua:26 is diet = HERBIVORE
-- on a humanoid -- and every sibling blistmok (blistmok, blistmok_shrieker,
-- blistmok_trampler, trained_blistmok) is MOB_CARNIVORE.
-- The mismatch was not cosmetic: AiAgentImplementation.cpp:4272 makes a carnivore
-- treat any herbivore as attackable, so the wild packs would have hunted this
-- quest spawn on sight. The profile here is a predator's anyway -- AGGRESSIVE +
-- ENEMY, PACK + STALKER, posturedownattack/stunattack.
som_kenobi_blistmok = Creature:new {
	customName = "Blistmok",
	socialGroup = "blistmok",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 250,
	hideType = "hide_leathery",
	hideAmount = 180,
	boneType = "bone_mammal",
	boneAmount = 120,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/som_kenobi_blistmok.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_blistmok, "som_kenobi_blistmok")

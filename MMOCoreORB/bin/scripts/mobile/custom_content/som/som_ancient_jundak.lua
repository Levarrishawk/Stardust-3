-- creatures.tab row som_ancient_jundak: CL 84 ELITE, object/mobile/som/jundak.iff at scale 1.5/1.5.
--
-- level = 84 is retail's own number, not the ladder's.  The ladder's ELITE rung is 85.
-- Everything else in this template is the ELITE rung (jundak_devourer), unchanged.  This is
-- the second deliberate exception to "level is copied from the anchor exactly" -- it is taken
-- because retail states a per-creature number for this named unique and a displayed CL is
-- worth getting exactly right.  Do not "fix" the 84 back to 85; it is intentional.
--
-- retail lists meat_insect / hide_scaley for every jundak row, but this tree's whole jundak
-- family (jundak.lua, jundak_devourer.lua) uses meat_carnivore / hide_leathery / bone_mammal,
-- so the family convention wins here.  retail's values are recorded in this comment rather
-- than applied -- one divergent template would read as a mistake.
--
-- retail row lootTable mustafar/mustafar_jundak is not transcribed here; the lootGroups block
-- is the ELITE sibling's (jundak_devourer), carried over unchanged.

som_ancient_jundak = Creature:new {
	customName = "Ancient Jundak",
	socialGroup = "jundak",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 84,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 400,
	hideType = "hide_leathery",
	hideAmount = 300,
	boneType = "bone_mammal",
	boneAmount = 250,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/jundak.iff"},
	lootGroups = {
		{
			groups = {
				{group = "resource_creature", chance = 6000000},
				{group = "junk", chance = 2000000},
				{group = "armor_attachments", chance = 2000000}
			},
			lootChance = 4000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"knockdownattack",""}, {"dizzyattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_ancient_jundak, "som_ancient_jundak")

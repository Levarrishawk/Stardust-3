-- The pilot who flies the player into the volcano crater in
-- som_story_arc_chapter_three_03, "Talk to a Pilot".
--
-- THE NAME IS LIVE.  customName was the descriptive "Miner Pilot"; his own
-- conversation script, conversation/story_arc_chapter_three_pilot, calls
-- setName(self, "Master Pilot Menddle") in both OnInitialize and OnAttach, and
-- his opening line introduces him: "Menddle is my name and flying is my game."
-- He is a Mon Cal -- s_42 says so.
--
-- The same script sets invulnerable, which the bitmask below now carries.
miner_pilot = Creature:new {
	customName = "Master Pilot Menddle",
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
	pvpBitmask = NONE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/miner_pilot.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "story_arc_chapter_three_pilot",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(miner_pilot, "miner_pilot")

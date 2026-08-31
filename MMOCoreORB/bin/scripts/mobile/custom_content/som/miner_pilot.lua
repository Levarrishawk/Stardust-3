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
	pvpBitmask = NONE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/miner_pilot.iff"},
	lootGroups = {},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "story_arc_chapter_three_pilot",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(miner_pilot, "miner_pilot")

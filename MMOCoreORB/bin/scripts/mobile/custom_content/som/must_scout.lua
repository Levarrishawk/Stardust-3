-- The scout who releases the droid army in som_story_arc_chapter_three_01,
-- "Defeat the Droid Army".
--
-- THE NAME IS LIVE.  customName used to be the raw template string "must_scout"
-- -- a placeholder, and story_arc_chapters.lua recorded it as unresolved because
-- no som_ STF and no spawn table row names him.  Neither does: his name is set
-- by his own conversation script, conversation/story_arc_chapter_three_scout,
-- which calls setName(self, "Scout Olon Lono") in both OnInitialize and OnAttach.
-- Root cause of the gap: the search looked in string tables and spawn tables,
-- and the answer was in the conversation script all along.
--
-- The same script sets invulnerable plus CONDITION_CONVERSABLE and
-- CONDITION_INTERESTING, which is what the bitmasks below now carry.  He was
-- previously ATTACKABLE with no CONVERSABLE flag at all, so he could be shot and
-- could not be talked to -- both backwards.
must_scout = Creature:new {
	customName = "Scout Olon Lono",
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

	templates = {"object/mobile/som/must_scout.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "story_arc_chapter_three_scout",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_scout, "must_scout")

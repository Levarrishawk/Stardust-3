-- Engineer Cobar -- the engineer who hands out the terminal override tool for
-- som_story_arc_chapter_three_02, "Get a Terminal Override".
--
-- THE NAME IS LIVE, not a repo invention.  SOE's conversation script
-- conversation/story_arc_chapter_three_cobar renames the mob "Engineer Cobar"
-- on attach and sets invulnerable plus CONDITION_CONVERSABLE and
-- CONDITION_INTERESTING.  optionsBitmask below is those three flags.
--
-- The .qst task says "Talk to one of the engineers located at the Mensix Mining
-- Facility", and Cobar's own default line -- "This computer terminal isn't
-- going to fix itself" -- puts him at a terminal inside it.
--
-- POSITION IS INFERRED.  Cobar is the one story-arc NPC with no row in
-- som_mining_facility.tab or in any other dungeon spawn table; his script is
-- referenced by nothing but itself.  small_room_05 is the facility's technician
-- room in the live table -- it holds the technician patrol markers, Chief Drono
-- and the exploration marker -- so he is placed in the free corner of it.  The
-- ROOM is reasoned from live; the coordinate is not.  storyArcChaptersScreenPlay
-- owns the spawn.
--
-- APPEARANCE IS A REPO CHOICE.  No cobar.iff ships in any .tre.  The generic
-- Mustafarian technician model is used because that is what he is, and the stat
-- block is copied from som_mustafarian_computer_technician.lua for the same
-- reason chief_glost.lua copied chief_armstrong: he is a conversation NPC, not
-- an encounter, and live marks him invulnerable.

engineer_cobar = Creature:new {
	customName = "Engineer Cobar",
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_mustafarian_computer_technician.iff"},
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "story_arc_chapter_three_cobar",

	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(engineer_cobar, "engineer_cobar")

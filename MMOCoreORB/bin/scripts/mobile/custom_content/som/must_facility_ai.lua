-- The Old Republic AI, after it transfers out of the crashed cruiser and into the
-- facility.  Carrier only.  Sibling of must_cruiser_ai.lua and the same DEVIATION
-- for the same reason.
--
-- WHY THIS FILE EXISTS AT ALL.  Live does not put this conversation on a creature.
-- It puts it on a TANGIBLE: one row of the Old Republic Facility dungeon spawn
-- table places object/tangible/furniture/terminal/terminal_bank_floor_on_02.iff,
-- named "Terminal Delta Five", in room core_tower8 and hangs the single script
-- conversation.story_arc_chapter_two_computer on it.
--
-- Core3 cannot do that.  sendConversationStartTo exists only on AiAgent
-- (AiAgentImplementation.cpp:4087), on DroidObject and on ShipAiAgent; there is no
-- TangibleObject counterpart and it is not lua-bound, so nothing can start a
-- conversation from a terminal.
--
-- DEVIATION: storyArcChaptersScreenPlay puts the furniture terminal exactly where
-- the live row puts it and stands this invisible AiAgent on the same spot to hold
-- the conversation.  Unlike the cruiser, the terminal here keeps NO radial -- live
-- hangs only the one script on it, so the conversation is the whole object.
--
-- OPEN, and not claimed as working: whether an invis_man-appearance agent is
-- reliably clickable for a player standing at the terminal.  That cannot be
-- checked without a client, so it is stated rather than asserted.  If it turns out
-- not to be, the fix is one string: swap templates below for a visible mobile.
-- Nothing else in the wiring depends on the appearance.
--
-- object/mobile/invis_man.iff is a real registered repo template
-- (object/custom_content/mobile/invis_man.lua, included from
-- object/custom_content/mobile/serverobjects.lua:450).
--
-- customName is SHIPPED, not inferred.  The spawn row carries the display name in
-- its own "name" column: "Terminal Delta Five".  That is the string a player sees
-- over the object on live, so the carrier wears it.
--
-- The bitmasks match must_cruiser_ai's, and for the same reason: the live script
-- only ever makes this object conversable, and INVULNERABLE is the repo's way of
-- saying what a tangible gets for free -- a terminal cannot be shot.
must_facility_ai = Creature:new {
	customName = "Terminal Delta Five",
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/invis_man.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "story_arc_chapter_two_computer",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_facility_ai, "must_facility_ai")

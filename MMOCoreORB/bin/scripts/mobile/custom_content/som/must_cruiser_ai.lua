-- The crashed Old Republic cruiser's AI, on the bridge.  Carrier only.
--
-- WHY THIS FILE EXISTS AT ALL.  Live does not put this conversation on a
-- creature.  It puts it on a TANGIBLE: one row of the crash-site dungeon spawn
-- table places object/tangible/quest/must_orc_computer.iff in room "bridge" and
-- hangs two scripts on it, quest.task.ground.retrieve_item_on_item and
-- conversation.story_arc_chapter_one_computer.
--
-- Core3 cannot do that.  sendConversationStartTo exists only on AiAgent
-- (AiAgentImplementation.cpp:4087), on DroidObject and on ShipAiAgent; there is
-- no TangibleObject counterpart and it is not lua-bound, so nothing can start a
-- conversation from a terminal.
--
-- DEVIATION, and it is the smallest one available: storyArcChaptersScreenPlay
-- keeps must_orc_computer exactly where the live row puts it, and stands this
-- invisible AiAgent on the same spot to hold the conversation.  The terminal
-- keeps its radial -- "Install Circuit Boards" is the OTHER live script and has
-- to stay -- and this carrier keeps the talk.
--
-- OPEN, and not claimed as working: whether an invis_man-appearance agent is
-- reliably clickable for a player standing at the terminal.  That cannot be
-- checked without a client, so it is stated rather than asserted.  If it turns
-- out not to be, the fix is one string: swap templates below for a visible
-- mobile.  Nothing else in the wiring depends on the appearance.
--
-- object/mobile/invis_man.iff is a real registered repo template
-- (object/custom_content/mobile/invis_man.lua, included from
-- object/custom_content/mobile/serverobjects.lua:450), and the creature template
-- invis_man already ships and spawns; this is that same appearance with a
-- conversation on it.
--
-- customName is INFERRED.  The shipped display name lives in the STRING_ID chunk
-- of object/tangible/quest/shared_must_orc_computer.iff, which is client-side and
-- is in no .stf, so there is no string to quote.  "Ship's Computer" is a plain
-- reading of what the object is, labelled here so it does not read as sourced.
--
-- The bitmasks are live's.  story_arc_chapter_one_computer.java calls
-- setCondition(self, CONDITION_CONVERSABLE) at three points and never sets
-- anything else.  INVULNERABLE is not from that script -- it is the repo's way of
-- saying what a tangible gets for free: a terminal cannot be shot.
must_cruiser_ai = Creature:new {
	customName = "Ship's Computer",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 80,
	chanceHit = 0.0,
	damageMin = 0,
	damageMax = 0,
	baseXp = 0,
	baseHAM = 20000,
	baseHAMmax = 20000,
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
	conversationTemplate = "story_arc_chapter_one_computer",
	primaryAttacks = {
	},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_cruiser_ai, "must_cruiser_ai")

-- Milo Mensix -- the anchor of the Secrets of Mustafar story arc, chapters one
-- through three.  storyArcChaptersScreenPlay spawns him in the Mensix facility's
-- conference room.
--
-- conversationTemplate WAS EMPTY, and that emptiness got misread as evidence
-- that live had no conversation for him.  It ships:
-- conversation/story_arc_chapter_one_milo, fifteen greeting conditions and
-- forty-three screens.  See mobile/conversations/mustafar/
-- story_arc_chapter_one_milo.lua for the root cause of the wrong call.
--
-- THE FLAGS BELOW ARE LIVE'S, not a repo choice.  SOE's script sets, on attach:
-- CONDITION_CONVERSABLE, setInvulnerable(true), CONDITION_INTERESTING, and
-- setName "Milo Mensix" -- which is already this template's customName.  The old
-- block had AIENABLED alone and pvpBitmask ATTACKABLE, so he could be killed
-- mid-arc and take the whole story with him.  optionsBitmask and pvpBitmask now
-- say what the live script says.
--
-- creatureBitmask keeps PACK and drops STALKER: he is a seated executive in a
-- boardroom, and STALKER is hunting behaviour.
must_milo_mensix = Creature:new {
	customName = "Milo Mensix",
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/must_milo_mensix.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "story_arc_chapter_one_milo",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_milo_mensix, "must_milo_mensix")

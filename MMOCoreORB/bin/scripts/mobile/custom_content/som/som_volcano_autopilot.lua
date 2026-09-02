-- Volcano Battlefield evacuation-ship autopilot on the bridge after the HK-47 finale.
-- Live row som_volcano_autopilot, level 100 NORMAL; level here is CIV tier 45, not live's 100 -- see
-- the note below.
-- Non-combat: pvpBitmask NONE, creatureBitmask NONE, CONVERSABLE, empty loot, and the
-- unarmed / empty-attack-set shape every other non-combat NPC in this folder uses
-- (chief_armstrong.lua and the rest). Appearance object/mobile/3po_protocol_droid_red.iff
-- is registered at object/mobile/3po_protocol_droid_red.lua:48.
--
-- Live's level 100 on this row is not a difficulty rating -- it is a protocol droid with no
-- combat stats at all in creatures.tab, and live only ever uses it as scenery you talk to.
-- So it takes the CIV rung, the ladder's non-combatant tier, and does NOT take part in the
-- volcano's one-rung shift that the nineteen combat rows do.
som_volcano_autopilot = Creature:new {
	customName = "an autopilot droid",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_DROID,
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
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = NONE,

	templates = {"object/mobile/3po_protocol_droid_red.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_volcano_autopilot, "som_volcano_autopilot")

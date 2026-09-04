-- Chief Armstrong -- giver and turn-in for som_poison_miners, "Miner Madness".
-- Stands in small_room_05 of the Mensix Mining Facility.
--
-- Name is live-sourced: som_poison_miners.stf task06 names him "Chief
-- Armstrong".  SOE's own conversation script is conversation/
-- miner_madness_chief_drono, which is why the tree file keeps that name.
--
-- APPEARANCE IS A REPO CHOICE, not a live value.  No chief_armstrong.iff
-- ships in any .tre, and the live spawn table carries no appearance column.
-- mustafarian_m_01.iff is the generic Mustafarian miner model this repo
-- already uses for his crew (mustafarian_miner_01.lua, miner_on_strike.lua).
-- Same convention foreman_nurfa.lua follows.  Stat block copied from
-- foreman_nurfa.lua -- he is a conversation NPC, not a combat encounter.

chief_armstrong = Creature:new {
	customName = "Chief Armstrong",
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
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_01.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "miner_madness_chief_drono",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(chief_armstrong, "chief_armstrong")

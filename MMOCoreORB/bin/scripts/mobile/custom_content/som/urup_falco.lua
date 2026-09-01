-- Urup Fal'co -- giver and turn-in for som_striking_miners, the Mensix
-- Mining Company's side of the labour dispute.  Stands in the conference
-- room of the Mensix Mining Facility.
--
-- Name is live-sourced: som_striking_miners.stf names him "Urup Fal'co" in
-- the journal entry and in task04.  In his own greeting he calls the place
-- "mining facility AG3-T of the Mensix Mining Company" and says "We
-- Mustafarians", so he is Mustafarian by his own line.
--
-- APPEARANCE IS A REPO CHOICE, not a live value.  No urup_falco.iff ships
-- in any .tre and the live spawn table carries no appearance column.
-- mustafarian_02.iff is the speaking-Mustafarian model this repo already
-- uses for the other half of this same quest (foreman_nurfa.lua).  Stat
-- block copied from foreman_nurfa.lua -- conversation NPC, not a fight.

urup_falco = Creature:new {
	customName = "Urup Fal'co",
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

	templates = {"object/mobile/som/mustafarian_02.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "striking_miners_urst",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(urup_falco, "urup_falco")

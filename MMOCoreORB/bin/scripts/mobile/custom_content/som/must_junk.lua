-- The Mensix junk dealer. He is spawned and reachable (mensix_mining_facility_main.lua:58,
-- registered serverobjects.lua:54), but shipped with conversationTemplate = "" and no
-- CONVERSABLE bit while being a level-70 ATTACKABLE STALKER -- so a merchant read to players
-- as a hostile mob that could not be talked to.
--
-- The posture below is copied field for field from the shipped mobile/misc/junk_dealer.lua,
-- and the conversation is the shipped generic flow (mobile/conversations/junk_dealer/
-- junk_dealer_generic_conv.lua, handler screenplays/junk_dealer/junk_dealer_conv_handler.lua).
-- No bespoke tree was authored on purpose: that handler hardcodes @conversation/
-- junk_dealer_generic:* option text, so a custom tree would give dialogue with no selling.
-- The consequence, stated rather than hidden: the five SOM-specific strings in
-- string/en/conversation/som_mustafar_junk_dealer.stf stay unused.
must_junk = Creature:new {
	customName = "Junk Dealer",
	planetMapCategory = "junkshop",
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
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/som/must_junk.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "junkDealerGenericConvoTemplate",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_junk, "must_junk")

-- Valley Battlefield (mustafar_droid_army) allied miner. Live row
-- som_battlefield_miner, level 80 NORMAL; level here is STD tier 70 from
-- cww8_battle_droid.lua -- one tier under ELITE 85, same relationship live
-- kept between miners at 80 and the army at 80-84. The miners are meant to
-- lose. socialGroup is live mustafar_miner; weapon from mustafarian_miner_01.lua.
-- customName is authored -- no .stf in the extract.
--
-- pvpBitmask is ATTACKABLE and deliberately NOT the NONE that the ambient
-- mustafarian_miner_01 carries. Live does not make these miners invulnerable --
-- it keeps them killable and merely stops them ever choosing a player as a
-- target (setHate -5000, factions.setIgnorePlayer). NONE here would mean the
-- droid army could not kill them either, which would delete the whole point of
-- them and break the battlefield's lose condition, which counts dead defenders.
som_battlefield_miner = Creature:new {
	customName = "a Mustafarian Miner",
	socialGroup = "mustafar_miner",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_01.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_battlefield_miner, "som_battlefield_miner")

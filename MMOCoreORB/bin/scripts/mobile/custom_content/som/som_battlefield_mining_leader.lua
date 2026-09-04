-- Valley Battlefield (mustafar_droid_army) mining squad leader. Live row
-- som_battlefield_mining_leader, level 80 NORMAL; level here is STD tier 70
-- from cww8_battle_droid.lua -- one tier under ELITE 85, same relationship
-- live kept between miners at 80 and the army at 80-84. The miners are meant
-- to lose. socialGroup is live mustafar_miner; weapon from
-- mustafarian_miner_01.lua. customName is authored -- no .stf in the extract.
--
-- pvpBitmask is ATTACKABLE and deliberately NOT the NONE that the ambient
-- mustafarian_miner_01 carries, for the reason written out in
-- som_battlefield_miner.lua: live keeps these miners killable and only stops
-- them targeting players. NONE would make the droid army unable to kill them.
som_battlefield_mining_leader = Creature:new {
	customName = "a Mining Squad Leader",
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

CreatureTemplates:addCreatureTemplate(som_battlefield_mining_leader, "som_battlefield_mining_leader")

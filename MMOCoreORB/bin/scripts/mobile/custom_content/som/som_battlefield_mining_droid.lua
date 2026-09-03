-- Valley Battlefield (mustafar_droid_army) allied mining droid. Live row
-- som_battlefield_mining_droid, level 80 NORMAL; level here is STD tier 70
-- from cww8_battle_droid.lua -- one tier under ELITE 85, same relationship
-- live kept between allies at 80 and the army at 80-84. The miners are meant
-- to lose. socialGroup is live mustafar_miner; weapon and bitmasks from
-- must_mining_droid_mark_01.lua. customName is authored -- no .stf in extract.
som_battlefield_mining_droid = Creature:new {
	customName = "a Mining Droid",
	socialGroup = "mustafar_miner",
	faction = "",
	mobType = MOB_DROID,
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
	diet = NONE,

	templates = {"object/mobile/probot.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_battlefield_mining_droid, "som_battlefield_mining_droid")

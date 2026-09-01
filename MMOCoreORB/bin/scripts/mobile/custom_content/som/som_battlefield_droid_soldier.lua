-- Valley Battlefield (mustafar_droid_army) soldier. Live row
-- som_battlefield_droid_soldier, level 80 ELITE; level here is ELITE tier 85
-- from asn_121.lua, not live's 80. resists and socialGroup are live; aggression
-- blank on live so ATTACKABLE + ENEMY only. weapon/attacks from hk77.lua --
-- live's droid_hk77_assault_droid is unregistered. customName is authored
-- because no .stf ships in the extract.
som_battlefield_droid_soldier = Creature:new {
	customName = "a Droid Army Soldier",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {75,75,100,60,100,25,40,85,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/hk77.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
	primaryWeapon = "ranged_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,bountyhuntermaster),
	secondaryAttacks = bountyhuntermaster
}

CreatureTemplates:addCreatureTemplate(som_battlefield_droid_soldier, "som_battlefield_droid_soldier")

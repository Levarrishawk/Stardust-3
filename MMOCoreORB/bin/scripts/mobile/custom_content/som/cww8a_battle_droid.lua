-- MOB_ANDROID for the same reason as cww8_battle_droid.lua: 6 of 6 plain battle droids
-- in the shipped tree use it. (The eradicator alongside stays MOB_DROID -- it is
-- droideka-class, and there the shipped split runs the other way, 5 of 6.)
cww8a_battle_droid = Creature:new {
	customName = "CWW8A Battle Droid",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_ANDROID,
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

	templates = {"object/mobile/som/cww8a_battle_droid.iff"},
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
	primaryAttacks = merge(marksmanmaster,pistoleermaster),
	secondaryAttacks = pistoleermaster
}

CreatureTemplates:addCreatureTemplate(cww8a_battle_droid, "cww8a_battle_droid")

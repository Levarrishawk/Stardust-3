-- Valley Battlefield (mustafar_droid_army) AK-3 assault killer. Live row
-- som_battlefield_ak_3, level 82 BOSS; level here is NAMED tier 100 from
-- volcano_cyborg_lt.lua, not live's 82. resists and socialGroup are live;
-- aggression blank on live so ATTACKABLE + ENEMY only. weapon/attacks from
-- cww8a_battle_droid.lua -- live's droid_cww8_02 is unregistered. customName
-- is authored because no .stf ships in the extract.
som_battlefield_ak_3 = Creature:new {
	customName = "an AK-3 Assault Killer Bot",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
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

CreatureTemplates:addCreatureTemplate(som_battlefield_ak_3, "som_battlefield_ak_3")

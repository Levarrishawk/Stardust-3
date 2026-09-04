--[[ som_decrepit_super_battle_droid -- Decrepit Droid Factory super battle droid.
     Retail creatures.tab: BaseLevel 85, difficultyClass BOSS,
     socialGroup droid_army, template death_watch_s_battle_droid,
     lootTable (blank).
     Placed on BOSS 120: retail difficultyClass BOSS maps to the BOSS 120 row.
     Retail BaseLevel 85 is recorded here and NOT copied into level.
     Copied from cww8_battle_droid.lua; weapons from cww8a_eradicator.lua
     (imperial_weapons_heavy / marksmanmaster+commandomaster); diet = NONE;
     armor 2 from the BOSS rung. ]]
som_decrepit_super_battle_droid = Creature:new {
	customName = "a decrepit super battle droid",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
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

	templates = {"object/mobile/death_watch_s_battle_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
	primaryWeapon = "imperial_weapons_heavy",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,commandomaster),
	secondaryAttacks = commandomaster
}

CreatureTemplates:addCreatureTemplate(som_decrepit_super_battle_droid, "som_decrepit_super_battle_droid")
-- heroic_tusken_mos_espa_citizen -- protection objective, killable, not a threat.
--
-- SOURCED (SOE, creatures.tab:2187): creatureName heroic_tusken_mos_espa_citizen,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup espa, template commoner (pool).
-- All eight armor columns = 0.
--
-- D5: SOE sub-tables also name heroic_tusken_citizen (10 rows, absent from creatures.tab).
-- Those rows spawn this template. Flagged at the spawn sites in tuskenArmy.lua.
--
-- Stardust rung CIV 45, OURS, NOT SOURCED. Anchor is must_mining_droid_mark_01.lua /
-- heroic_ig88_mouse_droid.lua (45/9300). Chassis
-- object/mobile/dressed_commoner_tatooine_bith_male_01.iff -- OURS, NOT SOURCED
-- (SOE commoner pool; PART 8.6 item 10).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_mos_espa_citizen = Creature:new {
	customName = "a Mos Espa citizen",
	socialGroup = "townsperson",
	faction = "townsperson",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_commoner_tatooine_bith_male_01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_mos_espa_citizen, "heroic_tusken_mos_espa_citizen")

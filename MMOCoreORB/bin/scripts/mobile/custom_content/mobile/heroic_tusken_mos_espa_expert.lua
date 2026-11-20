-- heroic_tusken_mos_espa_expert -- escort objective.
--
-- SOURCED (SOE, creatures.tab:2208): creatureName heroic_tusken_mos_espa_expert,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup espa, template scientist (pool).
-- All eight armor columns = 0.
--
-- D5: SOE sub-tables also name heroic_tusken_mos_eisley_expect (5 rows, absent from
-- creatures.tab). Those rows spawn this template. Flagged at the spawn sites in
-- tuskenArmy.lua.
--
-- Stardust rung CIV 45, OURS, NOT SOURCED. Chassis
-- object/mobile/dressed_doctor_trainer_human_female_01.iff -- OURS, NOT SOURCED
-- (SOE scientist pool; PART 8.6 item 10).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_mos_espa_expert = Creature:new {
	customName = "a Mos Espa expert",
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

	templates = {"object/mobile/dressed_doctor_trainer_human_female_01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_mos_espa_expert, "heroic_tusken_mos_espa_expert")

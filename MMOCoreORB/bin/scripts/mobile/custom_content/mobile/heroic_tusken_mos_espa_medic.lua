-- heroic_tusken_mos_espa_medic -- hospital reward, outdoor healer.
--
-- SOURCED (SOE, creatures.tab:2188): creatureName heroic_tusken_mos_espa_medic,
-- BaseLevel 90, difficultyClass ELITE, socialGroup espa_guard, template scientist (pool).
-- All eight armor columns = 0.
--
-- Stardust rung ELITE 85 (friendly), OURS, NOT SOURCED. Chassis
-- object/mobile/dressed_doctor_trainer_human_female_01.iff -- OURS, NOT SOURCED
-- (SOE scientist pool; PART 8.6 item 10). Heal loop (25 m, 5000 cap, outdoor only) is
-- scripted in tuskenArmy.lua from medic.java:82-148, not from this template.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_mos_espa_medic = Creature:new {
	customName = "a Mos Espa medic",
	socialGroup = "townsperson",
	faction = "townsperson",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
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
	creatureBitmask = PACK + HEALER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_doctor_trainer_human_female_01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "rebel_pistol",
	secondaryWeapon = "unarmed",
	primaryAttacks = merge(marksmanmaster, pistoleermid),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_mos_espa_medic, "heroic_tusken_mos_espa_medic")

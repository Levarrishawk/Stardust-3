-- heroic_echo_snowspeeder_ai -- Echo Base heroic Rebel snowspeeder (AI commander).
--
-- SOURCED (SOE, creatures.tab:6179): creatureName heroic_echo_snowspeeder_ai,
-- BaseLevel 90, difficultyClass BOSS, socialGroup hoth_snowspeeder, faction Rebel,
-- template snowspeeder_ai.iff, niche vehicle, rootImmune 100, snareImmune 100,
-- stunImmune 100, mezImmune 100, canNotPunish 1, tauntImmune 1, death_blow instant,
-- skillmods absorption_fire=80,dissipation_fire=50,
-- objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- Stardust rung APEX 140, OURS, NOT SOURCED (Stardust rung APEX 140, Mustafar ladder).
-- Anchored on corsec_special_ops_master_sergeant.lua (level 140, chanceHit 7,
-- damageMin 845, damageMax 1400, baseXp 13273, baseHAM 68000, baseHAMmax 83000, armor 2,
-- resists {90,90,90,90,90,90,90,90,-1}).
--
-- Appearance: object/mobile/snowspeeder_ai.iff (registered in
-- object/custom_content/mobile/snowspeeder_ai.lua:5).
--
-- Weapon: primaryWeapon "unarmed", secondaryWeapon "none", primaryAttacks {}, secondaryAttacks = {}
-- (vehicles use unarmed / built-in weapons).
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_snowspeeder_ai = Creature:new {
	customName = "a snowspeeder",
	socialGroup = "hoth_snowspeeder",
	faction = "rebel",
	mobType = MOB_VEHICLE,
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/snowspeeder_ai.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_snowspeeder_ai, "heroic_echo_snowspeeder_ai")

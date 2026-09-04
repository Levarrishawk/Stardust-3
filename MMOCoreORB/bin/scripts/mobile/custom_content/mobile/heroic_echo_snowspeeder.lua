-- heroic_echo_snowspeeder -- Echo Base heroic Rebel snowspeeder.
--
-- SOURCED (SOE, creatures.tab:6178): creatureName heroic_echo_snowspeeder,
-- BaseLevel 90, difficultyClass ELITE, socialGroup hoth_snowspeeder, faction Rebel,
-- template snowspeeder.iff, niche vehicle, rootImmune 100, snareImmune 100,
-- stunImmune 100, mezImmune 100, canNotPunish 1, death_blow instant,
-- objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED (Stardust rung ELITE 85, Mustafar ladder).
-- Anchored on mobile/dathomir/spiderclan_crawler.lua (level 85, chanceHit 0.75,
-- damageMin 555, damageMax 820, baseXp 8130, baseHAM 12000, baseHAMmax 15000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/snowspeeder.iff (registered in
-- object/custom_content/mobile/snowspeeder.lua:5).
--
-- Weapon: primaryWeapon "unarmed", secondaryWeapon "none", primaryAttacks {}, secondaryAttacks = {}
-- (vehicles use unarmed / built-in weapons).
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_snowspeeder = Creature:new {
	customName = "a snowspeeder",
	socialGroup = "hoth_snowspeeder",
	faction = "rebel",
	mobType = MOB_VEHICLE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	-- EB-d fix-1 (2026-09-04): SOE's appearance object/mobile/snowspeeder.iff carries client gameObjectType 0x10002 (a vehicle type);
	-- Core3's ObjectManager refuses to create a creature from it ("unknown gameObjectType 65538", final boot probe).
	-- The registered creature-typed snowspeeder model is the TCG familiar; scaled up. OURS, NOT SOURCED (appearance substitution).
	templates = {"object/mobile/tcg_familiar_snow_speeder.iff"},
	scale = 4.0,
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_snowspeeder, "heroic_echo_snowspeeder")

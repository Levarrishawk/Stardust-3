-- heroic_echo_rebel_turret_phase3 -- Echo Base heroic Rebel turret (phase 3).
--
-- SOURCED (SOE, creatures.tab:6170): creatureName heroic_echo_rebel_turret_s1_phase3,
-- BaseLevel 90, difficultyClass ELITE, socialGroup rebel, faction Rebel,
-- template hoth_turret_s1.iff, minScale 1.5, maxScale 1.5, niche vehicle,
-- death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- SOE turret HP (rebel_turret.java 100k-150k / 80k-100k) is recorded here and is NOT used;
-- the ELITE-85 rung governs.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED (Stardust rung ELITE 85, Mustafar ladder).
-- Anchored on mobile/dathomir/spiderclan_crawler.lua (level 85, chanceHit 0.75,
-- damageMin 555, damageMax 820, baseXp 8130, baseHAM 12000, baseHAMmax 15000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/hoth_turret_s1.iff (registered in
-- object/custom_content/mobile/hoth_turret_s1.lua:5).
--
-- Turret weapon & attacks: primaryWeapon "unarmed", primaryAttacks {}, secondaryAttacks = {}.
-- Turret bitmasks: creatureBitmask NONE, optionsBitmask AIENABLED,
-- pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY.
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_rebel_turret_phase3 = Creature:new {
	customName = "a Rebel heavy turret",
	socialGroup = "rebel",
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = NONE,
	scale = 1.5,

	templates = {"object/mobile/hoth_turret_s1.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_rebel_turret_phase3, "heroic_echo_rebel_turret_phase3")

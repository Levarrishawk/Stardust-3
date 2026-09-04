-- heroic_echo_rebel_turret_phase3_boss -- Echo Base heroic Rebel turret (phase 3 boss).
--
-- SOURCED (SOE, creatures.tab:6171): creatureName heroic_echo_rebel_turret_s1_phase3_boss,
-- BaseLevel 90, difficultyClass BOSS, socialGroup rebel, faction Rebel,
-- template hoth_turret_s1.iff, minScale 1.5, maxScale 1.5, niche vehicle,
-- death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- SOE turret HP (rebel_turret.java 100k-150k / 80k-100k) is recorded here and is NOT used;
-- the BOSS-120 rung governs.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED (Stardust rung BOSS 120, Mustafar ladder).
-- Anchored on corsec_security_specialist.lua (level 120, chanceHit 4.0,
-- damageMin 745, damageMax 1200, baseXp 11390, baseHAM 44000, baseHAMmax 54000, armor 2,
-- resists {90,90,90,90,90,90,90,90,-1}).
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
heroic_echo_rebel_turret_phase3_boss = Creature:new {
	customName = "a Rebel command turret",
	socialGroup = "rebel",
	faction = "rebel",
	mobType = MOB_VEHICLE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
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

CreatureTemplates:addCreatureTemplate(heroic_echo_rebel_turret_phase3_boss, "heroic_echo_rebel_turret_phase3_boss")

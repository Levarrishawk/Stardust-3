-- heroic_echo_wampa_boss_bodyguard -- Uncle Joe's summoned adds.
--
-- SOURCED (SOE, creatures.tab:6208): creatureName heroic_echo_wampa_boss_bodyguard,
-- BaseLevel 91, difficultyClass BOSS, socialGroup hoth_wampa_boss, template
-- wampa.iff, minScale/maxScale 0.7, hue 0, niche carnivore, aggressive 9,
-- assist 9, death_blow instant, lootTable blank, primary_weapon blank,
-- primary_weapon_specials gorilla_4. armorCold 90, other armour 0, armorStun -1.
-- Runtime HP rand(HP_JOES_ADDS +/-) = 345,325-375,325 (trial.java:249,
-- wampa_boss_add.java:13). Three rows at echo_base.tab:4736-4738, trigger
-- summon_wampas.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED. D-EBe1: SOE 345k-375k maps to
-- BOSS. Ladder row from ROUND-HSD-SPEC.md BOSS / heroic_ig88_droideka.lua
-- (chanceHit 4.0, 745-1200, xp 11390, HAM 44000/54000, armor 2).
-- Resists keep the SOE armour columns (cold 90), the way heroic_ig88_* kept
-- the droid resist row rather than the ladder's all-90 BOSS override.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:292 gorilla_4
-- = bm_dampen_pain_4 (2s once), bm_stomp_4 (9s), bm_shaken_2 (6s once + 18s).
-- Nearest Core3: intimidationattack, creatureareaknockdown, stunattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_boss_bodyguard = Creature:new {
	customName = "a wampa bodyguard",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "hoth_wampa_boss",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {0,0,0,0,90,0,0,-1,-1},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 0.7,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_boss_bodyguard, "heroic_echo_wampa_boss_bodyguard")

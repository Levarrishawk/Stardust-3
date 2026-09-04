-- heroic_echo_wampa_hostile -- Echo Base wampa-cave trash, smallest of four.
--
-- SOURCED (SOE, creatures.tab:6146): creatureName heroic_echo_wampa_hostile,
-- BaseLevel 90, difficultyClass ELITE, socialGroup wampa, template wampa.iff,
-- minScale/maxScale 0.3, hue 0, niche carnivore, aggressive 9, assist 9,
-- herd 1, death_blow instant, intLootRolls 1, intRollPercent 20,
-- lootTable heroic/heroic:echo_base_wampa_generic, primary_weapon blank,
-- primary_weapon_specials gorilla_1. armorCold 40, other armour 0, armorStun -1.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1: trash hostile/brute/
-- fierce/savage share ELITE 85 with a damage spread. Ladder row from
-- ROUND-HSD-SPEC.md ELITE / heroic_ig88_bomb_droid.lua (chanceHit 0.75,
-- xp 8130, HAM 12000/15000, armor 1). This file is the bottom of the spread
-- (555-820, the unmodified ELITE row). Resists keep SOE armour columns.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:289 gorilla_1
-- = bm_dampen_pain_1 (2s once), bm_stomp_1 (9s). Nearest Core3:
-- intimidationattack, creatureareaknockdown.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_hostile = Creature:new {
	customName = "a hostile wampa",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "wampa",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,40,0,0,-1,-1},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 0.3,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_generic", chance = 10000000}
			},
			lootChance = 2000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_hostile, "heroic_echo_wampa_hostile")

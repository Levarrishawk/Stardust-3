-- heroic_echo_wampa_brute -- Echo Base wampa-cave trash, second of four.
--
-- SOURCED (SOE, creatures.tab:6147): creatureName heroic_echo_wampa_brute,
-- BaseLevel 92, difficultyClass ELITE, socialGroup wampa, template wampa.iff,
-- minScale/maxScale 0.35, hue 0, niche carnivore, aggressive 9, assist 9,
-- herd 1, death_blow instant, intLootRolls 1, intRollPercent 60,
-- lootTable heroic/heroic:echo_base_wampa_generic, primary_weapon blank,
-- primary_weapon_specials gorilla_2. armorCold 50, other armour 0, armorStun -1.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 damage spread: +25/+25
-- off the unmodified ELITE row (555-820). Ladder HAM/xp/armor from
-- ROUND-HSD-SPEC.md ELITE / heroic_ig88_bomb_droid.lua.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:290 gorilla_2
-- = bm_dampen_pain_2 (2s once), bm_stomp_2 (9s). Nearest Core3:
-- intimidationattack, creatureareaknockdown.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_brute = Creature:new {
	customName = "a brute wampa",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "wampa",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 580,
	damageMax = 845,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,50,0,0,-1,-1},
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
	scale = 0.35,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_generic", chance = 10000000}
			},
			lootChance = 6000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_brute, "heroic_echo_wampa_brute")

-- heroic_echo_wampa_savage -- Echo Base wampa-cave trash, largest of four.
--
-- SOURCED (SOE, creatures.tab:6149): creatureName heroic_echo_wampa_savage,
-- BaseLevel 96, difficultyClass ELITE, socialGroup wampa, template wampa.iff,
-- minScale/maxScale 0.45, hue 0, niche carnivore, aggressive 9, assist 9,
-- herd 1, death_blow instant, intLootRolls 1, intRollPercent 50,
-- lootTable heroic/heroic:echo_base_wampa_generic, primary_weapon blank,
-- primary_weapon_specials gorilla_4. armorCold 75, other armour 0, armorStun -1.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 damage spread: +75/+75
-- off the unmodified ELITE row (555-820). Ladder HAM/xp/armor from
-- ROUND-HSD-SPEC.md ELITE / heroic_ig88_bomb_droid.lua.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:292 gorilla_4
-- = bm_dampen_pain_4 (2s once), bm_stomp_4 (9s), bm_shaken_2 (6s once + 18s).
-- Nearest Core3: intimidationattack, creatureareaknockdown, stunattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_savage = Creature:new {
	customName = "a savage wampa",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "wampa",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 630,
	damageMax = 895,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,75,0,0,-1,-1},
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
	scale = 0.45,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_generic", chance = 10000000}
			},
			lootChance = 5000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_savage, "heroic_echo_wampa_savage")

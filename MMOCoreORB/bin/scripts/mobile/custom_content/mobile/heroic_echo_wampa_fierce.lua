-- heroic_echo_wampa_fierce -- Echo Base wampa-cave trash, third of four.
--
-- SOURCED (SOE, creatures.tab:6148): creatureName heroic_echo_wampa_fierce,
-- BaseLevel 94, difficultyClass ELITE, socialGroup wampa, template wampa.iff,
-- minScale/maxScale 0.4, hue 0, niche carnivore, aggressive 9, assist 9,
-- herd 1, death_blow instant, intLootRolls 1, intRollPercent 40,
-- lootTable heroic/heroic:echo_base_wampa_generic, primary_weapon blank,
-- primary_weapon_specials gorilla_3. armorCold 60, other armour 0, armorStun -1.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 damage spread: +50/+50
-- off the unmodified ELITE row (555-820). Ladder HAM/xp/armor from
-- ROUND-HSD-SPEC.md ELITE / heroic_ig88_bomb_droid.lua.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:291 gorilla_3
-- = bm_dampen_pain_3 (2s once), bm_stomp_3 (9s), bm_shaken_1 (6s once + 18s).
-- Nearest Core3: intimidationattack, creatureareaknockdown, stunattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_fierce = Creature:new {
	customName = "a fierce wampa",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "wampa",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 605,
	damageMax = 870,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,60,0,0,-1,-1},
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
	scale = 0.4,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_generic", chance = 10000000}
			},
			lootChance = 4000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_fierce, "heroic_echo_wampa_fierce")

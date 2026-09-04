-- heroic_echo_wampa_berzerker -- Echo Base wampa_rm gate (SOE spelling).
--
-- SOURCED (SOE, creatures.tab:6150): creatureName heroic_echo_wampa_berzerker,
-- BaseLevel 93, difficultyClass BOSS, socialGroup wampa, template wampa.iff,
-- minScale/maxScale 0.5, hue 0, niche carnivore, aggressive 9, assist 9,
-- death_blow instant, intLootRolls 1, intRollPercent 100,
-- lootTable heroic/heroic:echo_base_wampa_berserker, primary_weapon blank,
-- primary_weapon_specials gorilla_4. armorCold 90, other armour 0, armorStun -1.
-- echo_base.tab:4720, cell wampa_rm, spawn_id wampa_funland_gate.
--
-- Stardust rung NAMED 100, OURS, NOT SOURCED. D-EBe1: its own loot column.
-- Ladder row from ROUND-HSD-SPEC.md NAMED / som_battlefield_gk_5.lua
-- (chanceHit 1, 645-1000, xp 9429, HAM 24000/30000, armor 1).
-- Resists keep SOE armour columns.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:292 gorilla_4
-- = bm_dampen_pain_4 (2s once), bm_stomp_4 (9s), bm_shaken_2 (6s once + 18s).
-- Nearest Core3: intimidationattack, creatureareaknockdown, stunattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_berzerker = Creature:new {
	customName = "a berserk wampa",	-- OURS, NOT SOURCED (English of creatureName; SOE spelling is berzerker)
	socialGroup = "wampa",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
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
	scale = 0.5,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_berserker", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_berzerker, "heroic_echo_wampa_berzerker")

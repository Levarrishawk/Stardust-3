-- heroic_echo_tauntaun_domesticated -- Echo Base grotto fauna.
--
-- SOURCED (SOE, creatures.tab:6141): creatureName heroic_echo_tauntaun_domesticated,
-- BaseLevel 70, difficultyClass NORMAL, socialGroup tauntaun, template
-- tauntaun_hue.iff, minScale/maxScale 1.25, hue 7, niche herbivore,
-- aggressive 0, assist 10, herd 1, death_blow blank, intLootRolls 1,
-- intRollPercent 5, lootTable heroic/heroic:echo_base_tauntaun_generic,
-- primary_weapon object/weapon/ranged/creature/creature_spit_hoth_tauntaun.iff,
-- primary_weapon_specials raptor_1. armorCold 40, other armour 0, armorStun -1.
-- echo_base.tab:1102,1107, cell tauntaun_grounds.
--
-- Stardust rung FAUNA_L 50, OURS, NOT SOURCED. D-EBe1 / research-echo-base.md
-- §4.3: non-aggressive fauna. Ladder row from ROUND-HSD-SPEC.md FAUNA_L /
-- ancient_graul.lua (chanceHit 0.47, 370-450, xp 4825, HAM 9700/11900, armor 0).
-- Resists keep SOE armour columns.
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: creature_spit_hoth_tauntaun.iff is
-- registered as an object template but has no mobile/weapon/ group (self-check
-- requires a shipped group or unarmed). primaryWeapon = "unarmed".
--
-- LOOT: echo_base_tauntaun_generic is out of this round's fence (EB-e is
-- wampa loot only). lootGroups empty.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:314 raptor_1
-- = bm_bite_1 (6s), bm_hamstring_1 (4s once + 12s). Nearest Core3:
-- creatureareaattack, intimidationattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_tauntaun_domesticated = Creature:new {
	customName = "a domesticated tauntaun",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "tauntaun",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 50,
	chanceHit = 0.47,
	damageMin = 370,
	damageMax = 450,
	baseXp = 4825,
	baseHAM = 9700,
	baseHAMmax = 11900,
	armor = 0,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.25,

	templates = {"object/mobile/tauntaun_hue.iff"},
	hues = { 7 },
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_tauntaun_domesticated, "heroic_echo_tauntaun_domesticated")

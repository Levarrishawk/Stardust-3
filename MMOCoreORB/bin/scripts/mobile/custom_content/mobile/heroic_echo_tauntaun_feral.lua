-- heroic_echo_tauntaun_feral -- Echo Base grotto death-blow fauna.
--
-- SOURCED (SOE, creatures.tab:6144): creatureName heroic_echo_tauntaun_feral,
-- BaseLevel 90, difficultyClass ELITE, socialGroup tauntaun, template
-- tauntaun_hue.iff, minScale 1, maxScale 1.2, hue 43, niche herbivore,
-- aggressive 0, assist 8, herd 1, death_blow yes, intLootRolls 1,
-- intRollPercent 30, lootTable heroic/heroic:echo_base_tauntaun_generic,
-- primary_weapon object/weapon/ranged/creature/creature_spit_hoth_tauntaun.iff,
-- primary_weapon_specials raptor_1. armorCold 75, other armour 0, armorStun -1.
-- echo_base.tab:1105, cell tauntaun_grounds.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 / §4.3. Damage spread
-- +25/+25 off the unmodified ELITE row. hue 43 not applied.
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: spit iff has no weapon group → unarmed.
-- LOOT: echo_base_tauntaun_generic is out of this round's fence.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): raptor_1 (ai_combat_profiles.tab:314).
-- Nearest Core3: creatureareaattack, intimidationattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_tauntaun_feral = Creature:new {
	customName = "a feral tauntaun",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "tauntaun",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 580,
	damageMax = 845,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.1,

	templates = {"object/mobile/tauntaun_hue.iff"},
	-- SOURCED (creatures.tab:6144 lootTable); EB-f
	lootGroups = {
		{
			groups = {
				{group = "echo_base_tauntaun_generic", chance = 10000000}
			},
			lootChance = 3000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_tauntaun_feral, "heroic_echo_tauntaun_feral")

-- heroic_echo_tauntaun_bull -- Echo Base grotto death-blow fauna.
--
-- SOURCED (SOE, creatures.tab:6143): creatureName heroic_echo_tauntaun_bull,
-- BaseLevel 85, difficultyClass ELITE, socialGroup tauntaun, template
-- tauntaun_hue.iff, minScale 0.9, maxScale 1.1, hue 41, niche herbivore,
-- aggressive 0, assist 8, herd 1, death_blow yes, intLootRolls 1,
-- intRollPercent 20, lootTable heroic/heroic:echo_base_tauntaun_generic,
-- primary_weapon object/weapon/ranged/creature/creature_spit_hoth_tauntaun.iff,
-- primary_weapon_specials raptor_2. armorCold 60, other armour 0, armorStun -1.
-- echo_base.tab:1104,1108, cell tauntaun_grounds.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 / §4.3: bull/feral/agitator
-- map STD 70 → ELITE 85; this SOE 85/ELITE row takes ELITE, bottom of the
-- damage spread. Ladder from ROUND-HSD-SPEC.md ELITE / heroic_ig88_bomb_droid.lua.
-- hue 41 not applied (Core3 palettes 0-7).
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: spit iff has no weapon group → unarmed.
-- LOOT: echo_base_tauntaun_generic is out of this round's fence.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): raptor_2 (ai_combat_profiles.tab:315)
-- = bm_bite_2, bm_hamstring_2. Nearest Core3: creatureareaattack, intimidationattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_tauntaun_bull = Creature:new {
	customName = "a tauntaun bull",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "tauntaun",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.0,

	templates = {"object/mobile/tauntaun_hue.iff"},
	-- SOURCED (creatures.tab:6143 lootTable); EB-f
	lootGroups = {
		{
			groups = {
				{group = "echo_base_tauntaun_generic", chance = 10000000}
			},
			lootChance = 2000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_tauntaun_bull, "heroic_echo_tauntaun_bull")

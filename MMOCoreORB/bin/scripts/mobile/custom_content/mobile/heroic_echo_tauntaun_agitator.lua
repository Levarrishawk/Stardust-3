-- heroic_echo_tauntaun_agitator -- Echo Base grotto death-blow fauna.
--
-- SOURCED (SOE, creatures.tab:6145): creatureName heroic_echo_tauntaun_agitator,
-- BaseLevel 95, difficultyClass ELITE, socialGroup tauntaun, template
-- tauntaun_hue.iff, minScale 1.1, maxScale 1.3, hue 45, niche herbivore,
-- aggressive 0, assist 4, herd 1, death_blow instant, intLootRolls 1,
-- intRollPercent 50, lootTable heroic/heroic:echo_base_tauntaun_generic,
-- primary_weapon object/weapon/ranged/creature/creature_spit_hoth_tauntaun.iff,
-- primary_weapon_specials raptor_3. armorCold 90, other armour 0, armorStun -1.
-- echo_base.tab:1106,1109, cell tauntaun_grounds.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. D-EBe1 / §4.3. Damage spread
-- +50/+50 off the unmodified ELITE row. hue 45 not applied.
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: spit iff has no weapon group → unarmed.
-- LOOT: echo_base_tauntaun_generic is out of this round's fence.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): raptor_3 (ai_combat_profiles.tab:316)
-- = bm_bite_3, bm_hamstring_3. Nearest Core3: creatureareaattack, intimidationattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_tauntaun_agitator = Creature:new {
	customName = "an agitator tauntaun",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "tauntaun",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 605,
	damageMax = 870,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.2,

	templates = {"object/mobile/tauntaun_hue.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_tauntaun_agitator, "heroic_echo_tauntaun_agitator")

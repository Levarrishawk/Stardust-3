-- heroic_echo_tauntaun_diseased -- Echo Base grotto fauna.
--
-- SOURCED (SOE, creatures.tab:6142): creatureName heroic_echo_tauntaun_diseased,
-- BaseLevel 75, difficultyClass NORMAL, socialGroup tauntaun, template
-- tauntaun_hue.iff, minScale 0.8, maxScale 1, hue 15, niche herbivore,
-- aggressive 0, assist 10, herd 1, death_blow blank, intLootRolls 1,
-- intRollPercent 10, lootTable heroic/heroic:echo_base_tauntaun_generic,
-- primary_weapon object/weapon/ranged/creature/creature_spit_hoth_tauntaun.iff,
-- primary_weapon_specials raptor_1. armorCold 50, other armour 0, armorStun -1.
-- echo_base.tab:1103, cell tauntaun_grounds.
--
-- Stardust rung STD 70, OURS, NOT SOURCED. D-EBe1 / §4.3: the 70/75 pair maps
-- FAUNA_L 50 → STD 70; diseased takes STD. Ladder row from ROUND-HSD-SPEC.md
-- STD / som_link_lava_beetle_worker.lua (chanceHit 0.65, 430-570, xp 6747,
-- HAM 12000/15000, armor 0). hue 15 not applied (Core3 palettes 0-7).
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: spit iff has no weapon group → unarmed.
-- LOOT: echo_base_tauntaun_generic is out of this round's fence.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): raptor_1 (ai_combat_profiles.tab:314).
-- Nearest Core3: creatureareaattack, intimidationattack.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_tauntaun_diseased = Creature:new {
	customName = "a diseased tauntaun",	-- OURS, NOT SOURCED (English of creatureName)
	socialGroup = "tauntaun",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 0.9,

	templates = {"object/mobile/tauntaun_hue.iff"},
	-- SOURCED (creatures.tab:6142 lootTable); EB-f
	lootGroups = {
		{
			groups = {
				{group = "echo_base_tauntaun_generic", chance = 10000000}
			},
			lootChance = 1000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_tauntaun_diseased, "heroic_echo_tauntaun_diseased")

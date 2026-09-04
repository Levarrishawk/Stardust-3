-- heroic_ig88_droideka -- phase-4 wave. Four at once; all must die to advance.
--
-- SOURCED (SOE, creatures.tab:2168): creatureName heroic_ig88_droideka,
-- BaseLevel 90, difficultyClass BOSS, socialGroup ig88, template droideka.iff,
-- lootTable npc/elite_npc:elite_npc_81_90, primary_weapon droid_droideka_ranged.iff,
-- specials ig88_droideka, attackSpeed 2. niche droid -> MOB_DROID.
-- Resists share the five-combat-droid row: K85 E95 Blast100 Heat60 Cold100
-- Electric25 Acid40 Stun85.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED. SOE's 90/BOSS maps to BOSS because
-- this is the phase-4 wave. Anchor is som_working_devistator.lua (level 120,
-- chanceHit 4.0, 745-1200, baseXp 11390, baseHAM 44000/54000, armor 2), the
-- Mustafar BOSS-120 droid row.
--
-- Chassis anchor is mobile/lok/droideka.lua: defaultWeapon plus defaultAttack.
-- droid_droideka_ranged.iff is the one droid weapon on SD3 that actually
-- resolves (PART 3.7). A generic group would be a downgrade -- same reason
-- som_ancient_guardian_droideka.lua:25-27 keeps the specific weapon.
--
-- LOST: ig88_droideka_shield (every 120 s) and ig88_droideka_electrify (every
-- 15 s). SOURCED (SOE, datatables/ai/ai_combat_profiles.tab row ig88_droideka): action1
-- ig88_droideka_shield every 120 s at 100 %, action2 ig88_droideka_electrify every 15 s at
-- 100 %. Neither command exists on SD3 (0 files tree-wide). The shield has no Core3
-- analogue at all; it is not faked.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_droideka = Creature:new {
	customName = "a droideka",
	socialGroup = "ig88",
	faction = "",
	mobType = MOB_DROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {85,95,100,60,100,25,40,85,-1},
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/droideka.iff"},
	lootGroups = {},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(heroic_ig88_droideka, "heroic_ig88_droideka")

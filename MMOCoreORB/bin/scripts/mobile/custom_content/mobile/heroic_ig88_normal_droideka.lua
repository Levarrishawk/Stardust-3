-- heroic_ig88_normal_droideka -- summoned repeatedly during the boss fight.
--
-- SOURCED (SOE, creatures.tab:2169): creatureName heroic_ig88_normal_droideka,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup ig88, template droideka.iff,
-- lootTable npc/elite_npc:elite_npc_81_90, primary_weapon droid_droideka_ranged.iff,
-- specials ig88_droideka, attackSpeed 2. niche droid -> MOB_DROID.
-- Resists share the five-combat-droid row: K85 E95 Blast100 Heat60 Cold100
-- Electric25 Acid40 Stun85.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. SOE's 90/NORMAL maps to ELITE so
-- the summoned adds must not out-damage the RAID 200 boss. Anchor is
-- mobile/custom_content/som/som_ancient_guardian_droideka.lua (the ELITE-85
-- retune of the stock droideka chassis): level 85, chanceHit 0.75, 555-820,
-- baseXp 8130, baseHAM 12000/15000, armor 1.
--
-- defaultWeapon / defaultAttack kept for the same reason that file gives at
-- :25-27: droid_droideka_ranged.iff is the right weapon and a generic group
-- would be a downgrade. It is the one droid weapon on SD3 that resolves
-- (PART 3.7).
--
-- LOST: ig88_droideka_shield (every 120 s) and ig88_droideka_electrify (every
-- 15 s). SOURCED (SOE, datatables/ai/ai_combat_profiles.tab row ig88_droideka): action1
-- ig88_droideka_shield every 120 s at 100 %, action2 ig88_droideka_electrify every 15 s at
-- 100 %. Neither command exists on SD3 (0 files tree-wide). The shield has no Core3
-- analogue at all; it is not faked.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_normal_droideka = Creature:new {
	customName = "a droideka",
	socialGroup = "ig88",
	faction = "",
	mobType = MOB_DROID,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
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

CreatureTemplates:addCreatureTemplate(heroic_ig88_normal_droideka, "heroic_ig88_normal_droideka")

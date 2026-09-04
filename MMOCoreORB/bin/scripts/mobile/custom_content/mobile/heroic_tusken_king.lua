-- heroic_tusken_king -- Mos Espa heroic final boss.
--
-- SOURCED (SOE, creatures.tab:2182): creatureName heroic_tusken_king, BaseLevel 95,
-- difficultyClass BOSS, socialGroup heroic_tusken, template tusken_king.iff,
-- lootTable heroic/heroic:tusken, primary_weapon object/weapon/melee/baton/baton_gaderiffi_elite.iff,
-- specials heroic_tusken_king, attackSpeed 2, minCash 80000 / maxCash 160000, scale 1.3,
-- aggressive 36. All eight armor columns = 0.
--
-- Stardust rung RAID 200, OURS, NOT SOURCED. SOE's 95/BOSS maps to RAID because this is
-- the heroic's final boss; the rung exar_kun.lua and H(ig)'s heroic_ig88_ig88_rocket sit on.
-- Stat row taken from mobile/tatooine/tusken_witch_doctor.lua (202/160000) -- an in-tree
-- RAID-rung tusken. Armor/resists kept at SOE's all-zero, not the witch doctor's.
--
-- SHARED HEALTH, NOT PORTED. SOURCED (SOE, tusken_king.java:26-57): OnEnteredCombat /
-- setupSquad -> getNPCsInRange(150) faction heroic_tusken same cell ->
-- ai_lib.establishSharedHealth(allies) plus establishAgroLink and buff tusken_unity.
-- Core3 has no establishSharedHealth analogue (D4, same recording as the IG-88 droideka
-- shield). The King carries the RAID 200 rung; the honor guard and warlords fight
-- normally. Not faked.
--
-- LOST specials, SOURCED (SOE, ai_combat_profiles.tab:138): king_head_crack (8 s, 100%),
-- king_rend (13 s, 100%), king_sandstorm (15 s, 100%). None of the three commands exist
-- on SD3 (0 files tree-wide). Not faked. Attacks follow stock tusken_king.lua with the
-- elite gaffi as primary (melee) so primaryAttacks are brawler/fencer, ranged on secondary.
--
-- D6: loot deferred to H(ta-b). lootGroups empty; the token is the reward.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_king = Creature:new {
	customName = "a Tusken king",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_NPC,
	level = 200,
	chanceHit = 16,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19201,
	baseHAM = 160000,
	baseHAMmax = 195000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
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
	diet = HERBIVORE,
	scale = 1.3,

	templates = {"object/mobile/tusken_king.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "object/weapon/melee/baton/baton_gaderiffi_elite.iff",
	secondaryWeapon = "tusken_ranged",
	primaryAttacks = merge(brawlermaster, fencermaster),
	secondaryAttacks = merge(marksmanmaster, riflemanmaster)
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_king, "heroic_tusken_king")

-- heroic_tusken_pack_master -- patrol/garrison elite.
--
-- SOURCED (SOE, creatures.tab:2193): creatureName heroic_tusken_pack_master, BaseLevel 90,
-- difficultyClass ELITE, socialGroup heroic_tusken, template tusken_raider.iff,
-- lootTable npc/tusken:tusken_elite, tusken_ranged/tusken_melee, specials bounty_hunter_3/melee_3,
-- cash 8000-16000, aggressive 12. All eight armor columns = 0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. Patrol/garrison elite, 9 spawned.
-- Anchor is tusken_brute.lua (role) with H(ig) ELITE-85 HAM from heroic_ig88_normal_droideka.lua
-- (12000/15000, chanceHit 0.75, 555-820).
--
-- No shipped creature name for pack_master (PART 5.3). customName hand-written.
-- OURS, NOT SOURCED.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_pack_master = Creature:new {
	customName = "a Tusken pack master",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
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

	templates = {"object/mobile/tusken_raider.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "tusken_ranged",
	secondaryWeapon = "tusken_melee",
	primaryAttacks = merge(marksmanmaster, riflemanmid),
	secondaryAttacks = merge(brawlermaster, fencermid)
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_pack_master, "heroic_tusken_pack_master")

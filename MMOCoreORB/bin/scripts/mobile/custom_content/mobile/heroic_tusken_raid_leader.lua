-- heroic_tusken_raid_leader -- Mos Espa heroic.
--
-- SOURCED (SOE, creatures.tab:2194): creatureName heroic_tusken_raid_leader, BaseLevel 90,
-- difficultyClass BOSS, socialGroup heroic_tusken, attackSpeed 2,
-- all eight armor columns = 0.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED. SOE's 90/BOSS maps to BOSS because these are garrison leaders, one per hall. Anchor is tusken_raid_leader.lua (role) with H(ig) BOSS-120 HAM from heroic_ig88_droideka.lua (44000/54000).
-- Weapons tusken_ranged / tusken_melee, merge(marksmanmaster, riflemanmaster).
-- customName uses the shipped generic @mob/creature_names:tusken_raid_leader English. Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_raid_leader = Creature:new {
	customName = "a Tusken raid leader",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_NPC,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
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
	primaryAttacks = merge(marksmanmaster, riflemanmaster),
	secondaryAttacks = merge(brawlermaster, fencermaster)
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_raid_leader, "heroic_tusken_raid_leader")

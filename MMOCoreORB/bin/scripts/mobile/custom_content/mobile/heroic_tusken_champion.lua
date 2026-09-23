-- heroic_tusken_champion -- Mos Espa heroic.
--
-- SOURCED (SOE, creatures.tab:2176): creatureName heroic_tusken_champion, BaseLevel 90,
-- difficultyClass ELITE, socialGroup heroic_tusken, attackSpeed 2,
-- all eight armor columns = 0.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED. SOE's 90/ELITE maps to BOSS because it leads the cantina assassin waves (1+4 x4). Anchor is tusken_raid_champion.lua (role) with H(ig) BOSS-120 HAM.
-- Weapons tusken_ranged / tusken_melee, merge(marksmanmaster, riflemanmaster).
-- customName uses the shipped generic @mob/creature_names:tusken_fort_tusken_champion English 'a Tusken carnage champion' (PART 5.3). Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_champion = Creature:new {
	customName = "a Tusken carnage champion",
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

CreatureTemplates:addCreatureTemplate(heroic_tusken_champion, "heroic_tusken_champion")

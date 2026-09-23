-- heroic_tusken_berserker -- Mos Espa heroic trash.
--
-- SOURCED (SOE, creatures.tab:2173): creatureName heroic_tusken_berserker, BaseLevel 90,
-- difficultyClass NORMAL, socialGroup heroic_tusken, template tusken_raider.iff,
-- tusken_ranged/tusken_melee, attackSpeed 2, all eight armor columns = 0.
-- 
-- Stardust rung STD 70, OURS, NOT SOURCED. Anchor is treasure_hunter_merc.lua /
-- storm_lord_minion.lua (level 70, chanceHit 0.65, 430-570, baseXp 6747);
-- HAM 10000/12000 so the ELITE-85 row (12000/15000) sits above.
-- customName uses the shipped generic English (PART 5.3).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_berserker = Creature:new {
	customName = "a Tusken berserker",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 10000,
	baseHAMmax = 12000,
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
	primaryAttacks = marksmanmid,
	secondaryAttacks = brawlermid
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_berserker, "heroic_tusken_berserker")

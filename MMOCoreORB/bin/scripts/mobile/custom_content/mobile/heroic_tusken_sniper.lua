-- heroic_tusken_sniper -- Mos Espa heroic.
--
-- SOURCED (SOE, creatures.tab:2197): creatureName heroic_tusken_sniper, BaseLevel 90,
-- difficultyClass ELITE, socialGroup heroic_tusken, attackSpeed 2,
-- all eight armor columns = 0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. SOE's 90/ELITE maps to ELITE; garrison ranged. Anchor is tusken_sniper.lua (role) with H(ig) ELITE-85 HAM.
-- Weapons tusken_ranged / tusken_melee, merge(marksmanmaster, riflemanmid).
-- customName uses the shipped generic @mob/creature_names:tusken_sniper English. Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_sniper = Creature:new {
	customName = "a Tusken sniper",
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

CreatureTemplates:addCreatureTemplate(heroic_tusken_sniper, "heroic_tusken_sniper")

-- heroic_tusken_warlord -- Mos Espa heroic.
--
-- SOURCED (SOE, creatures.tab:2199): creatureName heroic_tusken_warlord, BaseLevel 90,
-- difficultyClass BOSS, socialGroup heroic_tusken, attackSpeed 2,
-- all eight armor columns = 0.
--
-- Stardust rung APEX 140, OURS, NOT SOURCED. SOE's 90/BOSS maps to APEX because 9 are spawned, 5 of them the King's guard; must not out-tank the RAID 200 King. Anchor is tusken_carnage_champion.lua (116/43000) scaled 140/116 -> HAM 52000/64000 (below the King's 160000).
-- Weapons tusken_ranged / tusken_melee, primaryAttacks merge(marksmanmaster, riflemanmaster) -- OURS, nearest to bounty_hunter_3 / melee_3 (melee_3 row is empty).
-- customName uses the shipped generic @mob/creature_names:tusken_warlord English 'a Tusken warlord' (PART 5.3). Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_warlord = Creature:new {
	customName = "a Tusken warlord",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_NPC,
	level = 140,
	chanceHit = 4.5,
	damageMin = 900,
	damageMax = 1460,
	baseXp = 11015,
	baseHAM = 52000,
	baseHAMmax = 64000,
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

CreatureTemplates:addCreatureTemplate(heroic_tusken_warlord, "heroic_tusken_warlord")

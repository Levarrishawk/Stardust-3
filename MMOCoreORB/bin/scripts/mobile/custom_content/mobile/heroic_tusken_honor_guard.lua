-- heroic_tusken_honor_guard -- four that march with the King.
--
-- SOURCED (SOE, creatures.tab:2180): creatureName heroic_tusken_honor_guard, BaseLevel 90,
-- difficultyClass BOSS, socialGroup heroic_tusken, template tusken_raider.iff,
-- lootTable npc/tusken:tusken_normal, tusken_ranged/tusken_melee, no specials, aggressive 36.
-- All eight armor columns = 0, attackSpeed 2.
--
-- Stardust rung APEX 140, OURS, NOT SOURCED. The four that would share health with the King
-- (tusken_king.java:26-57); D4 does not port shared health, so they fight as APEX adds
-- that must not out-tank the King. Same HAM row as heroic_tusken_warlord.
--
-- No shipped creature name for honor_guard (PART 5.3). customName hand-written.
-- OURS, NOT SOURCED.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_honor_guard = Creature:new {
	customName = "a Tusken honor guard",
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

CreatureTemplates:addCreatureTemplate(heroic_tusken_honor_guard, "heroic_tusken_honor_guard")

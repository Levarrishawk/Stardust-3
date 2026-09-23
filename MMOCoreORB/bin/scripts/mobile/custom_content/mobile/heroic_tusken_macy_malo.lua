-- heroic_tusken_macy_malo -- starport reward, off-screen Y-Wing bomber, non-combat.
--
-- SOURCED (SOE, creatures.tab:2183): creatureName heroic_tusken_macy_malo, BaseLevel 90,
-- difficultyClass NORMAL, template macy_malo.iff, no weapons, no specials, no aggressive.
-- All eight armor columns = 0.
--
-- Stardust rung CIV 45, non-combat, OURS, NOT SOURCED. pvpBitmask NONE -- macy_malo.java:16-24
-- detaches ai.creature_combat / ai.ai / credit_for_kills and setCreatureCoverVisibility false.
-- Appearance object/mobile/macy_malo.iff (present).
--
-- queueCommand CRC -116167121 (the one-shot) has no SD3 binding (PART 8.6 item 6). The
-- effect (kill one outdoor Tusken every 35-60 s) is scripted in tuskenArmy.lua.
--
-- customName "Macy Malo" -- OURS, NOT SOURCED (PART 5.3: no shipped name key; the name
-- exists only inside dialogue body text).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_macy_malo = Creature:new {
	customName = "Macy Malo",
	socialGroup = "townsperson",
	faction = "townsperson",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
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
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/macy_malo.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_macy_malo, "heroic_tusken_macy_malo")

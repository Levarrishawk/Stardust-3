-- heroic_ig88_mouse_droid -- protection objective, not a threat.
--
-- SOURCED (SOE, creatures.tab:2171): creatureName heroic_ig88_mouse_droid,
-- BaseLevel 1, difficultyClass NORMAL, socialGroup mousedroid, template
-- mouse_droid.iff, lootTable droid/droid_1_10, no primary_weapon, no specials,
-- armorStun -1, canNotPunish 1, tauntImmune 1, aggressive 0. niche droid ->
-- MOB_DROID. SOE's level 1 is deliberate.
--
-- Stardust rung CIV 45, OURS, NOT SOURCED. Non-combat; it is a protection
-- objective the super battle droids hunt (ig88_mouse_droid.java:25-61 patrol,
-- ig88_super_battle_droid.java:85-110 hate). Anchor is
-- mobile/custom_content/som/must_mining_droid_mark_01.lua (level 45, chanceHit
-- 0.44, 345-400, baseXp 4461, baseHAM 9300/11300, armor 0).
--
-- pvpBitmask MUST be NONE -- it is protected, not fought (PART 3.4).
-- primaryWeapon = "unarmed", primaryAttacks = {} per PART 3.5.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_mouse_droid = Creature:new {
	customName = "a mouse droid",
	socialGroup = "mousedroid",
	faction = "",
	mobType = MOB_DROID,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
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
	diet = NONE,

	templates = {"object/mobile/mouse_droid.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_ig88_mouse_droid, "heroic_ig88_mouse_droid")

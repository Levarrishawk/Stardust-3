-- heroic_tusken_massiff -- the hound.
--
-- SOURCED (SOE, creatures.tab:2185): creatureName heroic_tusken_massiff, BaseLevel 90,
-- difficultyClass NORMAL, template tusken_massif.iff (SOE spelling massif), no weapons,
-- specials wolf_5/wolf_5, aggressive 12. All eight armor columns = 0.
--
-- Stardust rung STD 70, OURS, NOT SOURCED. Appearance object/mobile/tusken_massif.iff
-- (SD3 spelling massif). HAM from the STD-70 row.
--
-- LOST: wolf_5 kit. SOURCED (SOE, ai_combat_profiles.tab:343): bm_bite_5 (6 s),
-- bm_hamstring_5 (4 s once), bm_hamstring_5 (16 s), bm_puncture_3 (9 s). No SD3 analogue.
-- primaryAttacks stunattack+intimidationattack are OURS, NOT SOURCED, a beast stand-in,
-- not a fake of wolf_5.
--
-- No shipped creature name for massiff (PART 5.3). customName hand-written.
-- OURS, NOT SOURCED.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_massiff = Creature:new {
	customName = "a Tusken massiff",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 10000,
	baseHAMmax = 12000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
	meatType = "meat_carnivore",
	meatAmount = 0,
	hideType = "hide_leathery",
	hideAmount = 0,
	boneType = "bone_mammal",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/tusken_massif.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_massiff, "heroic_tusken_massiff")

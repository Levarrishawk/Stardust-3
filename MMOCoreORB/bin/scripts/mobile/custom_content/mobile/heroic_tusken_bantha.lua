-- heroic_tusken_bantha -- saddle bantha, a tank not a threat.
--
-- SOURCED (SOE, creatures.tab:2172): creatureName heroic_tusken_bantha, BaseLevel 90,
-- difficultyClass ELITE, template bantha_saddle_hue.iff, lootTable npc/tusken:tusken_elite,
-- no weapons, no specials, aggressive 12. All eight armor columns = 0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. 7 spawned; a tank, not a threat.
-- Chassis copied from mobile/tatooine/tusken_bantha.lua (unarmed, posturedownattack);
-- HAM from the ELITE-85 row.
--
-- customName uses the shipped generic @mob/creature_names:tusken_bantha English.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_bantha = Creature:new {
	customName = "a Tusken bantha",
	socialGroup = "tusken_raider",
	faction = "tusken_raider",
	mobType = MOB_HERBIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
	meatType = "meat_domesticated",
	meatAmount = 475,
	hideType = "hide_wooly",
	hideAmount = 350,
	boneType = "bone_mammal",
	boneAmount = 375,
	milkType = "milk_domesticated",
	milk = 235,
	tamingChance = 0,
	ferocity = 2,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.25,

	templates = {"object/mobile/bantha_saddle_hue.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"posturedownattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_bantha, "heroic_tusken_bantha")

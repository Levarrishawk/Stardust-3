-- heroic_tusken_mos_espa_militia -- combat-hall reward squads, friendly.
--
-- SOURCED (SOE, creatures.tab:2190): creatureName heroic_tusken_mos_espa_militia,
-- BaseLevel 90, difficultyClass ELITE, socialGroup espa_guard, template eisley_officer
-- (npc_customization pool, not an object template). All eight armor columns = 0.
--
-- Stardust rung ELITE 85 (friendly), OURS, NOT SOURCED. Chassis
-- object/mobile/dressed_eisley_officer_human_male_01.iff -- OURS, NOT SOURCED
-- (SOE's eisley_officer pool is randomized; SD3 must pick one dressed_* per role, PART 8.6 item 10).
-- rebel_pistol resolves (mobile/weapon/groups/rebel_pistol.lua).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_mos_espa_militia = Creature:new {
	customName = "a Mos Espa militiaman",
	socialGroup = "townsperson",
	faction = "townsperson",
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_eisley_officer_human_male_01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "rebel_pistol",
	secondaryWeapon = "unarmed",
	primaryAttacks = merge(marksmanmaster, pistoleermaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_mos_espa_militia, "heroic_tusken_mos_espa_militia")

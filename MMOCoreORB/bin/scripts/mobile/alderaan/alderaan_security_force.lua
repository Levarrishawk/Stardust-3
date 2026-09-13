alderaan_security_force = Creature:new {
	--objectName = "@mob/creature_names:rebel_trooper",
	customName = "an Alderaan Security Force Officer",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "imperial",
	faction = "imperial",
	level = 20,
	chanceHit = 0.34,
	damageMin = 200,
	damageMax = 210,
	baseXp = 1600,
	baseHAM = 4800,
	baseHAMmax = 6000,
	armor = 0,
	resists = {10,10,20,10,10,10,10,-1,-1},
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

	-- The local force retained Alderaanian field uniforms while serving the Empire.
	templates = {"object/mobile/dressed_rebel_crewman_human_female_01.iff",
    "object/mobile/dressed_rebel_crewman_human_female_02.iff",
    "object/mobile/dressed_rebel_crewman_human_male_01.iff",
    "object/mobile/dressed_rebel_crewman_human_male_02.iff",
    "object/mobile/dressed_rebel_crewman_human_male_03.iff",
    "object/mobile/dressed_rebel_crewman_human_male_04.iff"
  },
	lootGroups = {
		{
			groups = {
				{group = "imperial_stormtrooper_tier_1", chance = 10000000}
			}
		}
	},

	primaryWeapon = "rebel_carbine",
	secondaryWeapon = "rebel_pistol",
	thrownWeapon = "thrown_weapons",

	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	personalityStf = "@hireling/hireling_military",

	primaryAttacks = marksmanmid,
	secondaryAttacks = marksmanmid
}

CreatureTemplates:addCreatureTemplate(alderaan_security_force, "alderaan_security_force")

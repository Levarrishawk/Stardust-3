theme_park_rebel_private_collector = theme_park_rebel_civilian_contact:new {
	socialGroup = "townsperson",
	faction = "",
	level = 10,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + CONVERSABLE,
	templates = {
		"object/mobile/dressed_noble_human_male_01.iff",
		"object/mobile/dressed_noble_human_male_02.iff",
		"object/mobile/dressed_noble_human_male_03.iff"
	},
	conversationTemplate = "theme_park_rebel_mission_target_convotemplate"
}

CreatureTemplates:addCreatureTemplate(theme_park_rebel_private_collector, "theme_park_rebel_private_collector")

spacestation_coruscant = spacestation_imperial:new {
	template = "spacestation_coruscant",
	lootChance = 0,
	lootRolls = 0,
	pvpBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,
	customShipAiMap = "spaceStations",
	alliedFactions = {"imperial", "merchant", "civilian", "rsf"},
	conversationTemplate = "spacestation_coruscant_convotemplate",
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_coruscant, "spacestation_coruscant")

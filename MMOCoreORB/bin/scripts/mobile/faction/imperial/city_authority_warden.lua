city_authority_warden = imperial_colonel:new {
	objectName = "Imperial Prison Warden",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE,
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "cityAuthorityWardenConvoTemplate",
	primaryAttacks = {},
	secondaryAttacks = {},
}

CreatureTemplates:addCreatureTemplate(city_authority_warden, "city_authority_warden")

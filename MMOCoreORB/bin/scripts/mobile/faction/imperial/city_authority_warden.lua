city_authority_warden = imperial_colonel:new {
	objectName = "",
	customName = "Coruscant Prison Warden",
	randomNameType = NAME_TAG,
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

city_authority_sentence_officer = imperial_officer:new {
	--objectName = "Imperial Corrections Officer",
	customName = "an Imperial Corrections Officer",
	--randomNameType = NAME_GENERIC,
	--randomNameTag = true,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE,
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "cityAuthoritySentenceOfficerConvoTemplate",
	primaryAttacks = {},
	secondaryAttacks = {},
}

CreatureTemplates:addCreatureTemplate(city_authority_sentence_officer, "city_authority_sentence_officer")

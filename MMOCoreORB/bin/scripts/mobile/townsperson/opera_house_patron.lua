local patron = commoner:new {
	objectName = "",
	customName = "Opera Patron",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE,
	templates = {"noble"},
}

CreatureTemplates:addCreatureTemplate(patron, "opera_house_patron")

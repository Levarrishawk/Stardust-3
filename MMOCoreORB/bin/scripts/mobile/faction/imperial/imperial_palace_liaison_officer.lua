local officer = imperial_officer:new {
	customName = "an Imperial Palace Liason Officer",
	randomNameType = NAME_TAG,
	randomNameTag = false,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE + INTERESTING + CONVERSABLE,
	templates = {"object/mobile/dressed_imperial_officer_m.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = {},
	conversationTemplate = "imperialPalaceLiaisonConvoTemplate",
}

CreatureTemplates:addCreatureTemplate(officer, "imperial_palace_liaison_officer")

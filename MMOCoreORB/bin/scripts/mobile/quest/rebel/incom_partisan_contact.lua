incom_partisan_contact = theme_park_rebel_field_contact:new {
	customName = "Kessa Venn (Partisan Intelligence)",
	randomNameType = NAME_TAG,
	randomNameTag = false,
	optionsBitmask = INVULNERABLE + CONVERSABLE + JTLINTERESTING,
	templates = {"object/mobile/dressed_rebel_commando_human_female_01.iff"},
	conversationTemplate = "incomXwingPlansConvoTemplate",
}

CreatureTemplates:addCreatureTemplate(incom_partisan_contact, "incom_partisan_contact")

local dexter = commoner:new {
    objectName = "@dexter_jettster:name",
    customName = "Dexter Jettster",
    randomNameType = NAME_TAG,
    randomNameTag = false,
    socialGroup = "",
    faction = "",
    creatureBitmask = NONE,
    pvpBitmask = NONE,
    optionsBitmask = INVULNERABLE + CONVERSABLE + INTERESTING,
    conversationTemplate = "dexterJettsterDiner",
    indoorConversationHeight = 1.5,
    templates = {"object/mobile/dexter_jettster.iff"}
}
CreatureTemplates:addCreatureTemplate(dexter, "dexter_jettster")

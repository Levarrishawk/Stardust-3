local employee = commoner:new {
    socialGroup = "", faction = "", pvpBitmask = NONE, creatureBitmask = NONE,
    customAiMap = "cityPatrol", conversationTemplate = "monumentGrillService",
    templates = {
        "object/mobile/dressed_noble_human_female_04.iff", "object/mobile/dressed_noble_human_male_04.iff",
        "object/mobile/dressed_noble_naboo_twilek_female_02.iff", "object/mobile/dressed_noble_naboo_twilek_male_01.iff",
    },
}
CreatureTemplates:addCreatureTemplate(employee:new {
    optionsBitmask = INVULNERABLE + AIENABLED,
}, "monument_grill_waiter")
CreatureTemplates:addCreatureTemplate(employee:new {
    customName = "Monument Grill Bartender", randomNameType = NAME_TAG, randomNameTag = false,
    optionsBitmask = INVULNERABLE + CONVERSABLE,
}, "monument_grill_bartender")

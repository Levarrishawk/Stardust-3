local employee = commoner:new {
    socialGroup = "", faction = "", pvpBitmask = NONE, creatureBitmask = NONE,
    customAiMap = "cityPatrol", conversationTemplate = "monumentGrillService",
    templates = {
        "object/mobile/dressed_noble_human_female_04.iff", "object/mobile/dressed_noble_human_male_04.iff",
        "object/mobile/dressed_noble_naboo_twilek_female_02.iff", "object/mobile/dressed_noble_naboo_twilek_male_01.iff",
    },
}
local waiter = employee:new { optionsBitmask = INVULNERABLE + AIENABLED + INTERESTING }
CreatureTemplates:addCreatureTemplate(waiter, "monument_grill_waiter")
CreatureTemplates:addCreatureTemplate(waiter:new {
    templates = {"object/mobile/dressed_noble_naboo_twilek_female_02.iff"},
}, "monument_grill_robed_waiter")
CreatureTemplates:addCreatureTemplate(employee:new {
    customName = "Monument Grill Bartender", randomNameType = NAME_TAG, randomNameTag = false,
    optionsBitmask = INVULNERABLE + CONVERSABLE + INTERESTING,
    indoorConversationHeight = 1.5,
}, "monument_grill_bartender")

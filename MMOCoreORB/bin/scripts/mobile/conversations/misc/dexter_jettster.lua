local diner = ConvoTemplate:new {
    initialScreen = "welcome", templateType = "Normal", luaClassHandler = "", screens = {}
}
diner:addScreen(ConvoScreen:new {
    id = "welcome", leftDialog = "@dexter_jettster:greeting", stopConversation = "false",
    options = {
        {"@dexter_jettster:special_q", "special"},
        {"@dexter_jettster:news_q", "news"},
        {"@dexter_jettster:arms_q", "arms"},
        {"@dexter_jettster:bye_q", "bye"}
    }
})
for _, id in ipairs({"special", "news", "arms", "bye"}) do
    diner:addScreen(ConvoScreen:new {
        id = id, leftDialog = "@dexter_jettster:" .. id .. "_a", stopConversation = "true", options = {}
    })
end
addConversationTemplate("dexterJettsterDiner", diner)

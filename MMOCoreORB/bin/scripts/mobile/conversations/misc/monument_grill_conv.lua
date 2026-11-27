local service = ConvoTemplate:new {
    initialScreen = "hello", templateType = "Lua", luaClassHandler = "MonumentGrillMenuHandler", screens = {},
}
local function screen(id, text, options)
    service:addScreen(ConvoScreen:new {
        id = id, customDialogText = text, options = options or {},
        stopConversation = options and "false" or "true",
    })
end
screen("hello", "Good evening.", {{"May I see the menu?", "menu"}, {"Another time, thank you.", "bye"}})
screen("menu", "This evening's menu.", {})
for i = 1, 4 do screen("order" .. i, "One moment, please.") end
screen("closed", "Please speak to me again when you're ready to order at your table or the bar.")
screen("bye", "Enjoy your evening.")
addConversationTemplate("monumentGrillService", service)

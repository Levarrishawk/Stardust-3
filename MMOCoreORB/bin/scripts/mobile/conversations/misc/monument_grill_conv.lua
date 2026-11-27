local service = ConvoTemplate:new {
    initialScreen = "hello", templateType = "Lua", luaClassHandler = "MonumentGrillMenuHandler", screens = {},
}
local function screen(template, id, text, options)
    template:addScreen(ConvoScreen:new {
        id = id, customDialogText = text, options = options or {},
        stopConversation = options and "false" or "true",
    })
end
screen(service, "hello", "Good evening.", {{"May I see the menu?", "menu"}, {"Another time, thank you.", "bye"}})
screen(service, "menu", "This evening's menu.", {})
for i = 1, 4 do screen(service, "order" .. i, "One moment, please.") end
screen(service, "closed", "Please speak to me again when you're ready to order at your table or the bar.")
screen(service, "bye", "Enjoy your evening.")
addConversationTemplate("monumentGrillService", service)

local host = ConvoTemplate:new {
    initialScreen = "welcome", templateType = "Lua", luaClassHandler = "MonumentGrillHostHandler", screens = {},
}
local partySize = {
    {"One or two of us.", "small_party"},
    {"Three or four.", "four_party"},
    {"Five or more.", "large_party"},
    {"We're still waiting for someone.", "wait"},
}

screen(host, "welcome", "Good evening. Welcome to the Monument Grill. Do you have a reservation?", {
    {"Yes, we have a reservation.", "reservation"},
    {"We're walking in. Do you have room?", "walk_in"},
    {"I'm meeting someone here.", "meeting"},
    {"I'd just like a drink.", "bar"},
})
screen(host, "reservation", "Lovely. May I have the name on the reservation?", {
    {"It's under my name.", "reserved_size"},
    {"My companion booked it. I'll wait for them here.", "wait"},
})
screen(host, "reserved_size", "Thank you. How many will be dining with us?", partySize)
screen(host, "walk_in", "Of course. How many places shall we find for you?", partySize)
screen(host, "small_party", "Would you like a view of the square, or a table in the main dining room?", {
    {"A window table, please.", "window_two"},
    {"We'd like to sit near the bar.", "dining_room"},
})
screen(host, "four_party", "We have tables for four along the windows and in the main room. Which would you prefer?", {
    {"The windows would be lovely.", "window_four"},
    {"The main room, please.", "dining_room"},
})
screen(host, "large_party", "For a party that size, I'd suggest two tables in the same section. Is everyone here?", {
    {"Yes, we're ready to sit down.", "group_tables"},
    {"A few more are on their way.", "wait"},
})
screen(host, "meeting", "Has your party already been seated?", {
    {"Yes, they gave me a table number.", "find_table"},
    {"They haven't arrived yet.", "wait"},
})
screen(host, "window_two", "Through the dining room, along the windows. Look for 11 or 17. Both have two chairs and a view of the square. Take whichever is free, and your server will be by.")
screen(host, "window_four", "Follow the windows in the side room. Tables 10, 19 and 23 each seat four. Choose an open one. Table 10 has a lovely view of the square.")
screen(host, "dining_room", "Straight through the foyer and down the steps. Tables 04, 05 and 06 are in the main room near the bar. Make yourselves comfortable at an open table. Your server will take your order there.")
screen(host, "group_tables", "Through the foyer and into the window room. Tables 09 and 10 each seat four, and Taro looks after both. If your party needs more room, come back to me here at the stand.")
screen(host, "wait", "Please make yourself comfortable in the foyer. When everyone is here, come back to my stand and we'll seat you together.")
screen(host, "find_table", "You'll find the number on a small card on the table. The dining room is down the steps, and the window tables run along the side room. If you miss your party, meet them here at my stand.")
screen(host, "bar", "Straight through the foyer and down the steps. You'll see the bottle shelves in the middle of the room. The bartenders will be happy to show you the drinks menu.")
addConversationTemplate("monumentGrillHost", host)

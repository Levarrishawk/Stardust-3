local function register(name, handler, screens)
	local conversation = ConvoTemplate:new {
		initialScreen = "hello", templateType = "Lua", luaClassHandler = handler, screens = {},
	}
	for _, entry in ipairs(screens) do
		conversation:addScreen(ConvoScreen:new {
			id = entry[1], customDialogText = entry[2], options = entry[3] or {},
			stopConversation = entry[3] and "false" or "true",
		})
	end
	addConversationTemplate(name, conversation)
end

register("monumentWelcome", "conv_handler", {
	{"hello", "Welcome to Monument Square. Just off the shuttle? You've picked a good place to get your bearings.", {
		{"What should I see first?", "summit"}, {"Where can I get something to eat?", "food"},
		{"Where are the projections and souvenirs?", "gallery"}, {"Where's the shuttleport?", "transit"},
	}},
	{"summit", "Follow this path south to the circular rail. That's Umate, the highest peak on Coruscant. Ranger Vale can show you where the stone drops away beneath the lip.", {{"What else is here?", "hello"}}},
	{"food", "Nemi pours caf just down this path. For something hot, try Boro by the southeast pavilion. Follow the southern walk past there for the cantina.", {{"And where's the summit?", "summit"}}},
	{"gallery", "The big pink projection is southwest of the peak. If you want something to take home, Sela sells little holoprojectors by the southern rotunda gallery.", {{"Thanks, Ranger.", "bye"}}},
	{"transit", "Just north of here. Follow the straight walk back from the summit and you'll come out in front of the shuttleport."},
	{"bye", "Enjoy the square. Leave yourself time to see the lights come on."},
})

register("monumentSummit", "conv_handler", {
	{"hello", "First visit? Come up to the rail. See where the stone disappears below the rim? The mountain keeps going. This is just the part the city hasn't covered.", {
		{"That's the top of a mountain?", "umate"}, {"How far down does it go?", "depth"},
		{"Do locals still come here?", "locals"}, {"Where can I get a model of the peak?", "model"},
	}},
	{"umate", "Umate. Highest peak on Coruscant. You could spend your whole life walking this world and never see its natural surface. This is the only place where it's still exposed.", {{"What's below the rim?", "depth"}, {"Do locals still visit?", "locals"}}},
	{"depth", "Look down beside the curb. That's the same rock face you see up here. The plaza was built around the summit, and the rest of the mountain is buried under city levels.", {{"What's its name again?", "umate"}, {"I'll take a look.", "bye"}}},
	{"locals", "Every day. Visitors usually watch the summit. The regulars watch their friends see it for the first time.", {{"I might bring someone back.", "bye"}}},
	{"model", "Sela keeps a little one running at the southern gallery. You can carry the projector in your palm."},
	{"bye", "Take your time. From the other side of the rim you'll see a different ridge."},
})

-- The merchant handler fills in this player's menu and purchase result.
register("monumentShop", "MonumentSquareVendorHandler", {
	{"hello", "What can I get you?", {}},
	{"buy1", "One moment."}, {"buy2", "One moment."}, {"bye", "Enjoy your visit."},
})

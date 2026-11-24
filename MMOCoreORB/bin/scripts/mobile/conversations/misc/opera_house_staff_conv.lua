local function register(name, greeting, replies)
	local conversation = ConvoTemplate:new {
		initialScreen = "hello",
		templateType = "Lua",
		luaClassHandler = "conv_handler",
		screens = {},
	}
	local options = {}
	for _, reply in ipairs(replies) do
		table.insert(options, {reply[1], reply[2]})
		conversation:addScreen(ConvoScreen:new {
			id = reply[2], customDialogText = reply[3], stopConversation = "true", options = {},
		})
	end
	conversation:addScreen(ConvoScreen:new {
		id = "hello", customDialogText = greeting, stopConversation = "false", options = options,
	})
	addConversationTemplate(name, conversation)
end

register("operaHouseProtocol", "Welcome to the Galaxies Opera House. I have tonight's program quite by heart. May I help?", {
	{"What's playing?", "program", "Squid Lake. Listen for the horn under the opening strings. If you hear it a second time, watch the little sphere on the outside."},
	{"Which way to the private box?", "box", "Up the foyer stairs and through the auditorium doors. Follow either upper aisle around to the far side. Lieutenant Arlen keeps the guest list there."},
	{"How do I get back down to the district?", "taxi", "Through the foyer and out to the red carpet. Ressa Pell has the cab on the terrace. Tell her whether you want the West Bank or the South Cantina."},
})

register("operaHouseMusician", "Have you got the time? I've got thirty-two bars to get back to my stand. Thirty-one.", {
	{"You must be Nemm's sister.", "nemm", "Did he tell you? My brother says he plays horn too. Ask him how many notes his cab knows."},
	{"What does the third horn play?", "horn", "Two low notes when the shoal turns. The first horn gets the tune. I get to make the water look heavy."},
	{"I'd better let you make your cue.", "cue", "Thank you. If the conductor asks, I was here on the downbeat."},
})

register("operaHouseTechnician", "Mind the reader. I've finally got it to show me the surface current without reflecting my face.", {
	{"What should I watch for?", "turn", "When the smallest sphere passes behind the big one, keep your eye on the squid. Its fins start the turn a beat before the water follows."},
	{"Are you steering them from here?", "current", "Only the water. I can trim the current a little. Getting a squid to take direction is the conductor's problem."},
})

register("operaHouseBoxAide", "Good evening. A little closer, please. Voices carry very well from this box.", {
	{"Expecting someone important?", "guest", "Yes, the senator requested privacy. He also requested that everyone see him arrive."},
	{"Who's on the list tonight?", "list", "I could give you the names, or I could keep my posting. Do enjoy the performance."},
})

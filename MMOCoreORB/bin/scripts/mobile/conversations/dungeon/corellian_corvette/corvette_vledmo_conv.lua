corvetteVledmoConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "corvetteVledmoConvoHandler",
	screens = {}
}

intro = ConvoScreen:new {
	id = "intro",
	customDialogText = "Jabba sent somebody? I had this under control until CorSec sold my transfer to Imperial Security. If you've got a way out, I suppose I could use it.",
	stopConversation = "false",
	options = {
		{"Yondalla sent us. We have an extraction point.", "regular_channels"},
		{"I can put you back in the cell if you prefer.", "space_hero"},
	}
}
corvetteVledmoConvoTemplate:addScreen(intro);

already_rescued = ConvoScreen:new {
	id = "already_rescued",
	customDialogText = "Talk later. I've got a pickup to make.",
	stopConversation = "true",
	options = { }
}
corvetteVledmoConvoTemplate:addScreen(already_rescued);

regular_channels = ConvoScreen:new {
	id = "regular_channels",
	customDialogText = "I'll head to the forward elevator. Tell Jabba I got clear on my own and we'll call it even.",
	stopConversation = "true",
	options = {}
}
corvetteVledmoConvoTemplate:addScreen(regular_channels);

space_hero = ConvoScreen:new {
	id = "space_hero",
	customDialogText = "Fine, point me toward the forward elevator. When we get out, this was my idea.",
	stopConversation = "true",
	options = {}
}
corvetteVledmoConvoTemplate:addScreen(space_hero);

addConversationTemplate("corvetteVledmoConvoTemplate", corvetteVledmoConvoTemplate);

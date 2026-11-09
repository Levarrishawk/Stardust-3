local mensixJunkDealer = ConvoTemplate:new {
	initialScreen = "ask_for_loot",
	templateType = "Lua",
	luaClassHandler = "JunkDealerMustafarConvoHandler",
	screens = {}
}

mensixJunkDealer:addScreen(ConvoScreen:new {
	id = "ask_for_loot",
	leftDialog = "@conversation/som_mustafar_junk_dealer:s_4",
	animation = "bow2",
	stopConversation = "false",
	options = {}
})

mensixJunkDealer:addScreen(ConvoScreen:new {
	id = "start_sale",
	leftDialog = "@conversation/som_mustafar_junk_dealer:s_8",
	animation = "beckon",
	stopConversation = "true",
	options = {}
})

mensixJunkDealer:addScreen(ConvoScreen:new {
	id = "no_loot",
	leftDialog = "@conversation/som_mustafar_junk_dealer:s_12",
	animation = "bow3",
	playerAnimation = "shrug_hands",
	stopConversation = "true",
	options = {}
})

addConversationTemplate("som_mustafar_junk_dealer", mensixJunkDealer)

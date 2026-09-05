-- mtp_vendor
-- ruling 2026-09-04

mtp_vendor_convo = ConvoTemplate:new {
	initialScreen = "vendor_credits",
	templateType = "Lua",
	luaClassHandler = "mtp_vendor_conv_handler",
	screens = {}
}

mtp_vendor_convo_vendor_credits = ConvoScreen:new {
	id = "vendor_credits",
	leftDialog = "@set_bonus:vendor_credits", -- opens the stock list (shipped set_bonus vendor key)
	stopConversation = true,
	options = {}
}
mtp_vendor_convo:addScreen(mtp_vendor_convo_vendor_credits)

addConversationTemplate("mtp_vendor_convo", mtp_vendor_convo)

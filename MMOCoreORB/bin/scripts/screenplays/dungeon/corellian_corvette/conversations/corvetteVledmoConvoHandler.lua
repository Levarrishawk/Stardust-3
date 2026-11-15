corvetteVledmoConvoHandler = conv_handler:new {}

function corvetteVledmoConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (readData(SceneObject(pNpc):getObjectID() .. ":alreadyRescued") == 1) then
		return convoTemplate:getScreen("already_rescued")
	else
		return convoTemplate:getScreen("intro")
	end
end

function corvetteVledmoConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pConvScreen = screen:cloneScreen()
	if (screenID == "regular_channels" or screenID == "space_hero") then
		CorellianCorvette:releaseRescueTarget(pNpc)
	end

	return pConvScreen
end

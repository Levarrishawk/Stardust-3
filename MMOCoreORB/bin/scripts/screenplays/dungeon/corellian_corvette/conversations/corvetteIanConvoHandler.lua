corvetteIanConvoHandler = conv_handler:new {}

function corvetteIanConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (readData(SceneObject(pNpc):getObjectID() .. ":alreadyRescued") == 1) then
		return convoTemplate:getScreen("already_rescued")
	else
		return convoTemplate:getScreen("intro")
	end
end

function corvetteIanConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pConvScreen = screen:cloneScreen()
	if (screenID == "safe_haven" or screenID == "excellent_work") then
		CorellianCorvette:releaseRescueTarget(pNpc)
	end

	return pConvScreen
end

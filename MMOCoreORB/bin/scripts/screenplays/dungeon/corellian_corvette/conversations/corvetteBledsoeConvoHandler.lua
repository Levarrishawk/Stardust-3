corvetteBledsoeConvoHandler = conv_handler:new {}

function corvetteBledsoeConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (readData(SceneObject(pNpc):getObjectID() .. ":alreadyRescued") == 1) then
		return convoTemplate:getScreen("already_rescued")
	else
		return convoTemplate:getScreen("intro")
	end
end

function corvetteBledsoeConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pConvScreen = screen:cloneScreen()
	if (screenID == "good_work" or screenID == "great_work" or screenID == "breed_and_spread") then
		CorellianCorvette:releaseRescueTarget(pNpc)
	end

	return pConvScreen
end

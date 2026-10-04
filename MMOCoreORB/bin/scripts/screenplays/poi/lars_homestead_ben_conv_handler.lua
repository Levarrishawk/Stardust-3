larsHomesteadBenConvoHandler = conv_handler:new {}

function larsHomesteadBenConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	return LuaConversationTemplate(pConvTemplate):getScreen("hello")
end

function larsHomesteadBenConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pConvScreen == nil or pPlayer == nil or pNpc == nil) then
		return pConvScreen
	end

	if (SceneObject(pPlayer):getZoneName() ~= "tatooine" or SceneObject(pNpc):getZoneName() ~= "tatooine") then
		return pConvScreen
	end

	if (LuaConversationScreen(pConvScreen):getScreenID() == "run_along") then
		local key = "larsHomesteadBen:teleport:" .. SceneObject(pPlayer):getObjectID()

		if (readData(key) == 0) then
			writeData(key, 1)
			createEvent(4000, "TatooineLarsHomesteadScreenPlay", "sendToAnchorhead", pPlayer, key)
		end
	end

	return pConvScreen
end

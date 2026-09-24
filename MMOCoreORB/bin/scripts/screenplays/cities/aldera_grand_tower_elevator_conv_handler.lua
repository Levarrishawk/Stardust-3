alderaGrandTowerElevatorConvoHandler = conv_handler:new {}

function alderaGrandTowerElevatorConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pNpc ~= nil and SceneObject(pNpc):getParentID() == 610000834) then
		return convoTemplate:getScreen("operator")
	end

	return convoTemplate:getScreen("doorman")
end

function alderaGrandTowerElevatorConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or SceneObject(pPlayer):getZoneName() ~= "alderaan") then
		return pConvScreen
	end

	local screenID = LuaConversationScreen(pConvScreen):getScreenID()
	local npcCell = SceneObject(pNpc):getParentID()
	local playerCell = SceneObject(pPlayer):getParentID()

	if (screenID == "go_up" and npcCell == 0 and playerCell == 0) then
		SceneObject(pPlayer):teleport(-1.2, 88.9, -14.0, 610000834)
	elseif (screenID == "go_down" and npcCell == 610000834 and playerCell == 610000834) then
		SceneObject(pPlayer):teleport(1011, 28, -1352, 0)
	end

	return pConvScreen
end

elysiumForceSpiritConvoHandler = conv_handler:new {}

function elysiumForceSpiritConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pPlayer == nil or pNpc == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return convoTemplate:getScreen("silent")
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.NPC_SEARCH_ACTIVE) then
		return convoTemplate:getScreen("waiting")
	elseif (stage >= ElysiumJediProgression.NPC_FOUND) then
		return convoTemplate:getScreen("found")
	end

	return convoTemplate:getScreen("silent")
end

function elysiumForceSpiritConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil) then
		return pConvScreen
	end

	local screen = LuaConversationScreen(pConvScreen)

	if (screen:getScreenID() == "search_complete") then
		ElysiumJediProgression:completeNpcSearch(pPlayer)
	end

	return pConvScreen
end

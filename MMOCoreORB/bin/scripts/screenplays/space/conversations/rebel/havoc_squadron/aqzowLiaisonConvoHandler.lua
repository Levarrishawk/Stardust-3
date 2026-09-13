local SpaceHelpers = require("utils.space_helpers")

aqzowLiaisonConvoHandler = conv_handler:new {}

function aqzowLiaisonConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	return LuaConversationTemplate(pConvTemplate):getScreen("greeting")
end

function aqzowLiaisonConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return nil
	end

	if (LuaConversationScreen(pConvScreen):getScreenID() == "give_waypoint") then
		SpaceHelpers:addAqzowWaypoint(pPlayer)
	end

	return pConvScreen
end

local SpaceHelpers = require("utils.space_helpers")

ekerLiaisonConvoHandler = conv_handler:new {}

function ekerLiaisonConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	return LuaConversationTemplate(pConvTemplate):getScreen("greeting")
end

function ekerLiaisonConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return nil
	end

	if (LuaConversationScreen(pConvScreen):getScreenID() == "give_waypoint") then
		SpaceHelpers:addCrimsonPhoenixNextWaypoint(pPlayer)
	end

	return pConvScreen
end

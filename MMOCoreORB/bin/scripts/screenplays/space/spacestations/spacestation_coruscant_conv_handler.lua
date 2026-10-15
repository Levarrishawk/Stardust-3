SpacestationCoruscantConvoHandler = conv_handler:new {}

function SpacestationCoruscantConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()
	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (SceneObject(pShip):getZoneName() ~= "space_coruscant" or not SceneObject(pShip):checkInConversationRange(pNpc)) then
		return convoTemplate:getScreen("out_of_range")
	end

	return convoTemplate:getScreen("greeting")
end

function SpacestationCoruscantConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil or pConvScreen == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()
	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (SceneObject(pShip):getZoneName() ~= "space_coruscant" or not SceneObject(pShip):checkInConversationRange(pNpc)) then
		return convoTemplate:getScreen("out_of_range")
	end

	local screenID = LuaConversationScreen(pConvScreen):getScreenID()
	if (screenID == "repair_quote" or screenID == "repair") then
		if (not SpaceStationScreenPlay:hasCreditsForRepair(pPlayer, pShip, 1.0)) then
			return convoTemplate:getScreen("unavailable")
		end
	end

	local pScreenClone = LuaConversationScreen(pConvScreen):cloneScreen()
	if (screenID == "repair_quote") then
		LuaConversationScreen(pScreenClone):setCustomDialogText("Full repairs cost " .. SpaceStationScreenPlay:getRepairCost(pShip, 1.0) .. " cash credits. Standard component decay applies. Authorize payment?")
	elseif (screenID == "repair") then
		SpaceStationScreenPlay:repairShip(pPlayer, pShip, 1.0, pNpc, true)
	elseif (screenID == "land") then
		SpaceStationScreenPlay:landShip(pPlayer, "coruscant_spaceport")
	end

	return pScreenClone
end

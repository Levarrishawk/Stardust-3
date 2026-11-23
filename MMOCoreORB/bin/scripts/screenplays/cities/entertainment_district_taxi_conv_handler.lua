entertainmentDistrictTaxiConvoHandler = conv_handler:new {}

function entertainmentDistrictTaxiConvoHandler:getStop(pPlayer, pNpc)
	if pPlayer == nil or pNpc == nil then return nil end
	local player, npc = SceneObject(pPlayer), SceneObject(pNpc)
	if player:getZoneName() ~= "coruscant" or npc:getZoneName() ~= "coruscant" or
			player:getParentID() ~= 0 or npc:getParentID() ~= 0 or player:getDistanceTo3d(pNpc) > 10 then
		return nil
	end

	local district = CoruscantEntertainmentScreenPlay
	for name, stop in pairs(district.taxiStops) do
		if npc:getObjectID() == readData(district.screenplayName .. ":" .. stop.mobile) then
			return name, stop
		end
	end
end

function entertainmentDistrictTaxiConvoHandler:getInitialScreen(pPlayer, pNpc, pTemplate)
	local name = self:getStop(pPlayer, pNpc)
	return LuaConversationTemplate(pTemplate):getScreen(name or "unavailable")
end

function entertainmentDistrictTaxiConvoHandler:runScreenHandlers(pTemplate, pPlayer, pNpc, selectedOption, pScreen)
	if pScreen == nil or LuaConversationScreen(pScreen):getScreenID() ~= "board" then return pScreen end
	local _, origin = self:getStop(pPlayer, pNpc)
	local district = CoruscantEntertainmentScreenPlay
	if origin == nil or (origin.destination == "opera" and not district:isOperaTaxiPadAvailable()) then
		return LuaConversationTemplate(pTemplate):getScreen("unavailable")
	end

	local arrival = district.taxiStops[origin.destination].arrival
	SceneObject(pPlayer):teleport(arrival.x, arrival.height, arrival.y, 0)
	return pScreen
end

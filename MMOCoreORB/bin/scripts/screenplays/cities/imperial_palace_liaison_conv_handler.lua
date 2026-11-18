imperialPalaceLiaisonConvoHandler = conv_handler:new {
	greatHallCellID = 37002512,
}

local boardingOffers = {
	imperial_board = "trusted",
	rebel_board = "papers",
	privileged_board = "privileged",
	return_board = "departure",
}

function imperialPalaceLiaisonConvoHandler:getOffer(pPlayer, pNpc)
	if pPlayer == nil or pNpc == nil then return "unavailable" end
	local npc = SceneObject(pNpc)
	local player = SceneObject(pPlayer)
	local cellID = npc:getParentID()
	if npc:getZoneName() ~= "coruscant" or player:getZoneName() ~= "coruscant" or player:getParentID() ~= cellID then
		return "unavailable"
	end
	if cellID == self.greatHallCellID then return "departure" end
	if cellID ~= 0 then return "unavailable" end

	local creature = CreatureObject(pPlayer)
	local pGhost = creature:getPlayerObject()
	if pGhost == nil then return "unavailable" end
	local ghost = PlayerObject(pGhost)
	if ghost:isPrivileged() then
		return "privileged"
	elseif creature:isRebel() then
		if not creature:isOnLeave() then
			return "insurgent"
		elseif ghost:hasBadge(THEME_PARK_REBEL_BADGE) then
			return "papers"
		end
	elseif creature:isImperial() and ghost:hasBadge(THEME_PARK_IMPERIAL_BADGE) then
		return "trusted"
	end
	return "visitor"
end

function imperialPalaceLiaisonConvoHandler:getInitialScreen(pPlayer, pNpc, pTemplate)
	return LuaConversationTemplate(pTemplate):getScreen(self:getOffer(pPlayer, pNpc))
end

function imperialPalaceLiaisonConvoHandler:runScreenHandlers(pTemplate, pPlayer, pNpc, selectedOption, pScreen)
	if pScreen == nil then return end
	local template = LuaConversationTemplate(pTemplate)
	local offer = self:getOffer(pPlayer, pNpc)
	local requiredOffer = boardingOffers[LuaConversationScreen(pScreen):getScreenID()]
	if offer == "insurgent" or offer == "unavailable" or (requiredOffer ~= nil and requiredOffer ~= offer) then
		return template:getScreen(offer)
	end
	if requiredOffer == "departure" then
		SceneObject(pPlayer):teleport(-126, 40, 3227, 0)
	elseif requiredOffer ~= nil then
		local pCell = getSceneObject(self.greatHallCellID)
		if pCell == nil or not SceneObject(pCell):isCellObject() or SceneObject(pCell):getZoneName() ~= "coruscant" then
			return template:getScreen("unavailable")
		end
		local player = SceneObject(pPlayer)
		player:setDirectionalHeading(0)
		player:teleport(0, 1.2, -181, self.greatHallCellID)
	end
	return pScreen
end

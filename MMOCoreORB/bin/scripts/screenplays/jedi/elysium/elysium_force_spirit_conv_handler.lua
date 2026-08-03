elysiumForceSpiritConvoHandler = conv_handler:new {}

function elysiumForceSpiritConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pPlayer == nil or pNpc == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return convoTemplate:getScreen("silent")
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.NPC_SEARCH_ACTIVE) then
		return convoTemplate:getScreen("waiting")
	elseif (stage >= ElysiumJediProgression.NPC_FOUND and stage < ElysiumJediProgression.UNLOCK_COMPLETE) then
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
	elseif (screen:getScreenID() == "teleport") then
		self:teleportToElysiumTwo(pPlayer)
	end

	return pConvScreen
end

function elysiumForceSpiritConvoHandler:teleportToElysiumTwo(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.NPC_FOUND) then
		if (not ElysiumJediProgression:startForceTrials(pPlayer)) then
			return
		end
	elseif (stage ~= ElysiumJediProgression.FORCE_TRIALS_ACTIVE) then
		return
	end

	if (not isZoneEnabled("elysium2")) then
		CreatureObject(pPlayer):sendSystemMessage("The spirit cannot open the way at this time. Return and try again later.")
		return
	end

	local x = 2606
	local y = 2491
	local z = getWorldFloor(x, y, "elysium2")

	SceneObject(pPlayer):switchZone("elysium2", x, z, y, 0)
end

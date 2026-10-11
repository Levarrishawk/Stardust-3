incomXwingPlansConvoHandler = conv_handler:new {}

function incomXwingPlansConvoHandler:getInitialScreen(pPlayer, pNpc, pTemplate)
	if (not IncomXwingPlans:canSpeak(pPlayer, pNpc)) then
		return
	end
	local template = LuaConversationTemplate(pTemplate)
	if (CreatureObject(pPlayer):isImperial()) then
		return template:getScreen("imperial")
	end
	if (not CreatureObject(pPlayer):isRebel()) then
		return template:getScreen("not_rebel")
	end
	local stage = IncomXwingPlans:getStage(pPlayer)
	if (stage == 3) then
		return template:getScreen("already_complete")
	elseif (stage == 2) then
		return template:getScreen("return_plans")
	elseif (stage == 1) then
		return template:getScreen("in_progress")
	end
	return template:getScreen("intro")
end

function incomXwingPlansConvoHandler:runScreenHandlers(pTemplate, pPlayer, pNpc, selectedOption, pScreen)
	if (pScreen == nil or not IncomXwingPlans:canSpeak(pPlayer, pNpc)) then
		return
	end
	local template = LuaConversationTemplate(pTemplate)
	if (CreatureObject(pPlayer):isImperial()) then
		return template:getScreen("imperial")
	end
	if (not CreatureObject(pPlayer):isRebel()) then
		return template:getScreen("not_rebel")
	end
	local screenID = LuaConversationScreen(pScreen):getScreenID()
	if (screenID == "accept") then
		if (not IncomXwingPlans:accept(pPlayer, pNpc)) then
			return self:getInitialScreen(pPlayer, pNpc, pTemplate)
		end
	elseif (screenID == "deliver") then
		return template:getScreen(IncomXwingPlans:complete(pPlayer, pNpc))
	elseif (screenID == "waypoint") then
		IncomXwingPlans:giveWaypoint(pPlayer)
	end
	return pScreen
end

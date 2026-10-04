elysiumGuardianConvoHandler = conv_handler:new {
	waitSeconds = 30 * 24 * 60 * 60,
}

function elysiumGuardianConvoHandler:getEligibilityScreen(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return "waiting"
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	if (pGhost == nil) then
		return "waiting"
	end

	if (PlayerObject(pGhost):getJediState() >= 2) then
		return "rejected"
	end

	local entryTime = tonumber(readScreenPlayData(pPlayer, "ElysiumGuardian", "entryTime"))

	local jediState = PlayerObject(pGhost):getJediState()
	if ((jediState == 0 or jediState == 1) and entryTime ~= nil and entryTime > 0 and getTimestamp() - entryTime >= self.waitSeconds) then
		return "offer"
	end

	return "waiting"
end

function elysiumGuardianConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	return LuaConversationTemplate(pConvTemplate):getScreen(self:getEligibilityScreen(pPlayer))
end

function elysiumGuardianConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or pConvScreen == nil) then
		return pConvScreen
	end

	if (LuaConversationScreen(pConvScreen):getScreenID() ~= "resurrect") then
		return pConvScreen
	end

	local eligibility = self:getEligibilityScreen(pPlayer)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (eligibility ~= "offer") then
		return convoTemplate:getScreen(eligibility)
	end

	local shrines = {}
	for i = 1, #JediTrials.shrinePlanets do
		local planet = JediTrials.shrinePlanets[i]
		if (isZoneEnabled(planet)) then
			local shrineIds = JediTrials.forceShrineIds[planet]
			for j = 1, #shrineIds do
				local pShrine = getSceneObject(shrineIds[j])
				if (pShrine ~= nil and SceneObject(pShrine):getZoneName() == planet and SceneObject(pShrine):getParentID() == 0) then
					table.insert(shrines, { planet, pShrine })
				end
			end
		end
	end

	if (#shrines == 0) then
		return convoTemplate:getScreen("unavailable")
	end

	local shrine = shrines[getRandomNumber(1, #shrines)]
	local x = SceneObject(shrine[2]):getWorldPositionX()
	local y = SceneObject(shrine[2]):getWorldPositionY() + 5
	local z = getWorldFloor(x, y, shrine[1])
	SceneObject(pPlayer):switchZone(shrine[1], x, z, y, 0)

	return pConvScreen
end

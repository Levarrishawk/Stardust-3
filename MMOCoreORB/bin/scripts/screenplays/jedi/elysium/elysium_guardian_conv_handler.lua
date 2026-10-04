elysiumGuardianConvoHandler = conv_handler:new {
	waitSeconds = 30 * 24 * 60 * 60,
}

function elysiumGuardianConvoHandler:isPrivileged(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	return pGhost ~= nil and PlayerObject(pGhost):isPrivileged()
end

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
	if (self:isPrivileged(pPlayer)) then
		return LuaConversationTemplate(pConvTemplate):getScreen("privileged")
	end

	return LuaConversationTemplate(pConvTemplate):getScreen(self:getEligibilityScreen(pPlayer))
end

function elysiumGuardianConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or pConvScreen == nil) then
		return pConvScreen
	end

	local screenID = LuaConversationScreen(pConvScreen):getScreenID()
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (screenID == "privileged") then
		if (not self:isPrivileged(pPlayer)) then
			return convoTemplate:getScreen(self:getEligibilityScreen(pPlayer))
		end

		local entryTime = tonumber(readScreenPlayData(pPlayer, "ElysiumGuardian", "entryTime"))
		local text = "Resurrection timer: no Elysium entry time recorded."
		if (entryTime ~= nil and entryTime > 0) then
			local remaining = math.max(0, self.waitSeconds - (getTimestamp() - entryTime))
			local days = math.floor(remaining / 86400)
			local hours = math.floor((remaining % 86400) / 3600)
			local minutes = math.floor((remaining % 3600) / 60)
			local seconds = math.floor(remaining % 60)
			text = string.format("Time until resurrection timer eligibility: %d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
		end

		local pGhost = CreatureObject(pPlayer):getPlayerObject()
		if (PlayerObject(pGhost):getJediState() >= 2) then
			text = text .. " Jedi state prevents normal resurrection."
		elseif (self:getEligibilityScreen(pPlayer) == "offer") then
			text = text .. " You are eligible for resurrection."
		end

		local pClonedScreen = LuaConversationScreen(pConvScreen):cloneScreen()
		LuaConversationScreen(pClonedScreen):setCustomDialogText(text .. " Which path would you like to test?")
		return pClonedScreen
	end

	if (screenID == "test_regular") then
		return convoTemplate:getScreen(self:getEligibilityScreen(pPlayer))
	end

	if (screenID ~= "resurrect" and screenID ~= "test_exit") then
		return pConvScreen
	end

	if (screenID == "test_exit") then
		if (not self:isPrivileged(pPlayer)) then
			return convoTemplate:getScreen(self:getEligibilityScreen(pPlayer))
		end
	else
		local eligibility = self:getEligibilityScreen(pPlayer)
		if (eligibility ~= "offer") then
			return convoTemplate:getScreen(eligibility)
		end
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

	return convoTemplate:getScreen("resurrect")
end

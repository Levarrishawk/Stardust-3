ElysiumForceShrineMenuComponent = {}

function ElysiumForceShrineMenuComponent:fillObjectMenuResponse(pShrine, pMenuResponse, pPlayer)
	if (pShrine == nil or pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.SHRINE_SEARCH_ACTIVE) then
		local menuResponse = LuaObjectMenuResponse(pMenuResponse)
		menuResponse:addRadialMenuItem(122, 3, "Examine the structure")
	elseif (stage == ElysiumJediProgression.SHRINE_FOUND) then
		local menuResponse = LuaObjectMenuResponse(pMenuResponse)
		menuResponse:addRadialMenuItem(123, 3, "Listen to the structure")
	end
end

function ElysiumForceShrineMenuComponent:handleObjectMenuSelect(pShrine, pPlayer, selectedID)
	if (pShrine == nil or pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return 0
	end

	if (selectedID == 122) then
		if (not ElysiumJediProgression:completeShrineSearch(pPlayer)) then
			return 0
		end

		self:sendNpcQuestOffer(pShrine, pPlayer)
	elseif (selectedID == 123 and ElysiumJediProgression:getStage(pPlayer) == ElysiumJediProgression.SHRINE_FOUND) then
		self:sendNpcQuestOffer(pShrine, pPlayer)
	end

	return 0
end

function ElysiumForceShrineMenuComponent:sendNpcQuestOffer(pShrine, pPlayer)
	local sui = SuiMessageBox.new("ElysiumJediProgression", "npcSearchQuestCallback")
	sui.setTitle("An Ancient Structure")
	sui.setPrompt("As you approach, the structure responds to your presence. A distant figure appears in your mind, hidden somewhere in Elysium. Find this individual and discover why the Force has drawn you together.")
	sui.setOkButtonText("I will find them.")
	sui.setCancelButtonText("Not yet.")
	sui.setForceCloseDistance(10)
	sui.sendTo(pPlayer)
end

function ElysiumJediProgression:npcSearchQuestCallback(pPlayer, pSui, eventIndex, ...)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	if (self:startNpcSearch(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("The structure's vision remains in your mind. The individual is somewhere in Elysium.")
	end
end

function ElysiumJediProgression:noCallback(pPlayer, pSui, eventIndex, ...)
end

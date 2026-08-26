local SpaceHelpers = require("utils.space_helpers")

nialDeclannConvoHandler = conv_handler:new {}

function nialDeclannConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not isJtlEnabled()) then
		return convoTemplate:getScreen("not_eligible")
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return convoTemplate:getScreen("not_eligible")
	end

	local ghost = LuaPlayerObject(pGhost)
	local stageOneActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_1")
	local stageTwoActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_2")
	local stageOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")
	local stageTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")

	if (stageOneActive or stageTwoActive) then
		return convoTemplate:getScreen("on_mission")
	elseif (SpaceHelpers:hasMasterSkill(pPlayer, "imperial_navy")) then
		return convoTemplate:getScreen("completed")
	elseif (stageTwoComplete) then
		return convoTemplate:getScreen("final_report")
	elseif (stageOneComplete) then
		return convoTemplate:getScreen("second_assignment_intro")
	elseif (SpaceHelpers:isImperialPilot(pPlayer) and ghost:getPilotTier() >= 5) then
		return convoTemplate:getScreen("briefing")
	end

	return convoTemplate:getScreen("not_eligible")
end

function nialDeclannConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or pConvScreen == nil) then
		return pConvScreen
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pClonedScreen)

	clonedScreen:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "accept_master_mission"
			and SpaceHelpers:isImperialPilot(pPlayer)
			and LuaPlayerObject(pGhost):getPilotTier() >= 5
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_1")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")) then
		destroy_master_imperial_2:resetQuest(pPlayer)
		destroy_master_imperial_1:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_1", false)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_2", false)
		destroy_master_imperial_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_second_master_mission"
			and SpaceHelpers:isImperialPilot(pPlayer)
			and LuaPlayerObject(pGhost):getPilotTier() >= 5
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_2")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")) then
		destroy_master_imperial_2:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_2", false)
		destroy_master_imperial_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "claim_master_rewards"
			and SpaceHelpers:isImperialPilot(pPlayer)
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")
			and not SpaceHelpers:hasMasterSkill(pPlayer, "imperial_navy")) then
		destroy_master_imperial_2:rewardPlayer(pPlayer)
		destroy_master_imperial_2:grantAcePilotReward(pPlayer)
		destroy_master_imperial_2:grantPilotMastery(pPlayer)
	end

	return pClonedScreen
end

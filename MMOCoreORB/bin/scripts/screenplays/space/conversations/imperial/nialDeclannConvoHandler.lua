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
	local isRsfPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isRSFSquadron(pPlayer)
	local playerID = CreatureObject(pPlayer):getObjectID()
	local isCorsecPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isCorsecSquadron(pPlayer) and
		getQuestStatus(playerID .. "CorsecSquadronScreenplay:reportToDeclann") == "1"
	local eligiblePilot = SpaceHelpers:isImperialPilot(pPlayer) or isRsfPilot or isCorsecPilot
	local masterFaction = (isRsfPilot or isCorsecPilot) and "neutral" or "imperial_navy"
	local stageOneActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_1")
	local stageTwoActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_2")
	local stageOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")
	local stageTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")

	if (stageOneActive or stageTwoActive) then
		return convoTemplate:getScreen("on_mission")
	elseif (SpaceHelpers:hasMasterSkill(pPlayer, masterFaction)) then
		return convoTemplate:getScreen("completed")
	elseif (stageTwoComplete) then
		return convoTemplate:getScreen("final_report")
	elseif (stageOneComplete) then
		return convoTemplate:getScreen("second_assignment_intro")
	elseif (eligiblePilot and ghost:getPilotTier() >= 5) then
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

	local isRsfPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isRSFSquadron(pPlayer)
	local playerID = CreatureObject(pPlayer):getObjectID()
	local isCorsecPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isCorsecSquadron(pPlayer) and
		getQuestStatus(playerID .. "CorsecSquadronScreenplay:reportToDeclann") == "1"
	local eligiblePilot = SpaceHelpers:isImperialPilot(pPlayer) or isRsfPilot or isCorsecPilot
	local masterFaction = (isRsfPilot or isCorsecPilot) and "neutral" or "imperial_navy"

	if (not eligiblePilot) then
		return pConvScreen
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pClonedScreen)

	clonedScreen:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "accept_master_mission"
			and eligiblePilot
			and LuaPlayerObject(pGhost):getPilotTier() >= 5
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_1")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")) then
		destroy_master_imperial_2:resetQuest(pPlayer)
		destroy_master_imperial_1:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_1", false)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_2", false)
		destroy_master_imperial_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_second_master_mission"
			and eligiblePilot
			and LuaPlayerObject(pGhost):getPilotTier() >= 5
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_1")
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_imperial_2")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")) then
		destroy_master_imperial_2:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_imperial_2", false)
		destroy_master_imperial_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "claim_master_rewards"
			and eligiblePilot
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_imperial_2")
			and not SpaceHelpers:hasMasterSkill(pPlayer, masterFaction)) then
		destroy_master_imperial_2:rewardPlayer(pPlayer)
		destroy_master_imperial_2:grantAcePilotReward(pPlayer)
		destroy_master_imperial_2:grantPilotMastery(pPlayer)
	end

	return pClonedScreen
end

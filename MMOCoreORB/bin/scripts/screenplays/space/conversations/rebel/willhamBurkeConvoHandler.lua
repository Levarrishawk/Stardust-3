local SpaceHelpers = require("utils.space_helpers")

willhamBurkeConvoHandler = conv_handler:new {}

function willhamBurkeConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local isSmugglerPilot = pGhost ~= nil and SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isSmugglerSquadron(pPlayer)
	local playerID = CreatureObject(pPlayer):getObjectID()
	local isCorsecPilot = pGhost ~= nil and SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isCorsecSquadron(pPlayer) and
		getQuestStatus(playerID .. "CorsecSquadronScreenplay:reportToBurke") == "1"

	if (not isJtlEnabled() or pGhost == nil or (not SpaceHelpers:isRebelPilot(pPlayer) and not isSmugglerPilot and not isCorsecPilot)) then
		return convoTemplate:getScreen("not_eligible")
	end

	local ghost = LuaPlayerObject(pGhost)
	local stageOneActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_rebel_1")
	local stageTwoActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_rebel_2")
	local stageOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_1")
	local stageTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_2")

	if (stageOneActive or stageTwoActive) then
		return convoTemplate:getScreen("on_mission")
	elseif (SpaceHelpers:hasMasterSkill(pPlayer, (isSmugglerPilot or isCorsecPilot) and "neutral" or "rebel_navy")) then
		return convoTemplate:getScreen("completed")
	elseif (stageTwoComplete) then
		return convoTemplate:getScreen("final_report")
	elseif (stageOneComplete) then
		return convoTemplate:getScreen("second_assignment_intro")
	elseif (ghost:getPilotTier() >= 5) then
		return convoTemplate:getScreen("briefing")
	end

	return convoTemplate:getScreen("not_eligible")
end

function willhamBurkeConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil or pConvScreen == nil) then
		return pConvScreen
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pConvScreen
	end

	local isSmugglerPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isSmugglerSquadron(pPlayer)
	local playerID = CreatureObject(pPlayer):getObjectID()
	local isCorsecPilot = SpaceHelpers:isNeutralPilot(pPlayer) and SpaceHelpers:isCorsecSquadron(pPlayer) and
		getQuestStatus(playerID .. "CorsecSquadronScreenplay:reportToBurke") == "1"

	if (not SpaceHelpers:isRebelPilot(pPlayer) and not isSmugglerPilot and not isCorsecPilot) then
		return pConvScreen
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local masterFaction = (isSmugglerPilot or isCorsecPilot) and "neutral" or "rebel_navy"
	LuaConversationScreen(pClonedScreen):setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "accept_master_mission" and LuaPlayerObject(pGhost):getPilotTier() >= 5
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_rebel_1")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_1")) then
		destroy_master_rebel_2:resetQuest(pPlayer)
		destroy_master_rebel_1:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_rebel_1", false)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_rebel_2", false)
		destroy_master_rebel_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_second_master_mission"
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_1")
			and not SpaceHelpers:isSpaceQuestActive(pPlayer, "destroy", "master_rebel_2")
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_2")) then
		destroy_master_rebel_2:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "master_rebel_2", false)
		destroy_master_rebel_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "claim_master_rewards"
			and SpaceHelpers:isSpaceQuestComplete(pPlayer, "destroy", "master_rebel_2")
			and not SpaceHelpers:hasMasterSkill(pPlayer, masterFaction)) then
		destroy_master_rebel_2:rewardPlayer(pPlayer)
		destroy_master_rebel_2:grantAcePilotReward(pPlayer)
		destroy_master_rebel_2:grantPilotMastery(pPlayer)
	end

	return pClonedScreen
end

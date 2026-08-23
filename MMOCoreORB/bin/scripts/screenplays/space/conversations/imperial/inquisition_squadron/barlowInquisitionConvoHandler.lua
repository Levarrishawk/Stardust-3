local SpaceHelpers = require("utils.space_helpers")

barlowInquisitionConvoHandler = conv_handler:new {}

function barlowInquisitionConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (not isJtlEnabled() or pGhost == nil or not SpaceHelpers:isInquisitionSquadron(pPlayer)) then
		return convoTemplate:getScreen("unavailable")
	end

	local ghost = LuaPlayerObject(pGhost)

	if (ghost:getPilotTier() ~= 3) then
		return convoTemplate:getScreen("unavailable")
	end

	local missionOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.name)
	local missionTwoActive = SpaceHelpers:isSpaceQuestActive(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.name) or
		SpaceHelpers:isSpaceQuestActive(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE1.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE1.name) or
		SpaceHelpers:isSpaceQuestActive(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.name) or
		SpaceHelpers:isSpaceQuestActive(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)
	local missionTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)

	if (missionTwoComplete) then
		return convoTemplate:getScreen("return_to_vyrke")
	elseif (missionTwoActive) then
		return convoTemplate:getScreen("tier3_on_mission")
	elseif (missionOneComplete) then
		local playerID = CreatureObject(pPlayer):getObjectID()

		if (getQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted") == "1") then
			return convoTemplate:getScreen("failed_tier3_second_mission")
		end

		return convoTemplate:getScreen("tier3_second_mission")
	end

	return convoTemplate:getScreen("unavailable")
end

function barlowInquisitionConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return nil
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "accept_tier3_second_mission" or screenID == "failed_tier3_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. InquisitionSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted", 1)
		inspect_naboo_imperial_tier3_2:startQuest(pPlayer, pNpc)
	end

	return pClonedScreen
end

local SpaceHelpers = require("utils.space_helpers")

vrakConvoHandler = conv_handler:new {}

function vrakConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local playerID = CreatureObject(pPlayer):getObjectID()

	-- Get the viopaSmuggler flag value
	local viopaSmuggler = getQuestStatus(playerID .. "HavocSquadron:viopaSmuggler")

	if (viopaSmuggler == nil) then
		viopaSmuggler = 0
	else
		viopaSmuggler = tonumber(viopaSmuggler) or 0
	end

	local missionTwoActive = SpaceHelpers:isSpaceQuestActive(pPlayer, HavocSquadronScreenplay.TIER2_QUEST_STRING_2.type, HavocSquadronScreenplay.TIER2_QUEST_STRING_2.name)
	local missionTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, HavocSquadronScreenplay.TIER2_QUEST_STRING_2.type, HavocSquadronScreenplay.TIER2_QUEST_STRING_2.name)

	-- First meeting: Player has been sent by Viopa to meet Vrak (viopaSmuggler == 1)
	-- State 2 recovery lets characters who spoke to Vrak before mission assignment was added repeat the conversation.
	if (viopaSmuggler == 1 or (viopaSmuggler == 2 and not missionTwoActive and not missionTwoComplete)) then
		return convoTemplate:getScreen("are_you_the_pilot")

	-- Confrontation: Player returns to confront Vrak about betrayal (viopaSmuggler == 3)
	elseif (viopaSmuggler == 3) then
		return convoTemplate:getScreen("what_are_you_doing_here")
	end

	-- Default: Not the right player or wrong state
	return convoTemplate:getScreen("not_right_player")
end

function vrakConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	local playerID = CreatureObject(pPlayer):getObjectID()

	-- First meeting complete: Vrak sends the player to meet the hacker in Dantooine.
	if (screenID == "thank_you_vrak" or screenID == "calm_down_goodbye") then
		setQuestStatus(playerID .. "HavocSquadron:viopaSmuggler", 2)
		setQuestStatus(playerID .. HavocSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted", 1)

		HavocSquadronScreenplay:prepareMissionChainAttempt(pPlayer, {escort_viopa_rebel_2}, {{type="escort", name="viopa_rebel_2"}})
		escort_viopa_rebel_2:startQuest(pPlayer, pNpc)

	-- Confrontation complete: only the final responses unlock Viopa's fourth mission.
	elseif (screenID == "nym_will_take_care" or screenID == "nym_ensures_change") then
		setQuestStatus(playerID .. "HavocSquadron:viopaSmuggler", 4)
	end

	return pClonedScreen
end

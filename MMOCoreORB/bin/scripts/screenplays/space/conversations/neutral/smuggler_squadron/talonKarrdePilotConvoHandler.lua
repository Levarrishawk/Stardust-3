local SpaceHelpers = require("utils.space_helpers")

talonKarrdePilotConvoHandler = conv_handler:new {}

function talonKarrdePilotConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local playerID = CreatureObject(pPlayer):getObjectID()

	if (not SpaceHelpers:isSmugglerSquadron(pPlayer) or
		getQuestStatus(playerID .. "SmugglerSquadronScreenplay:dravis_finished") ~= "1") then
		return convoTemplate:getScreen("not_ready")
	end

	-- Recover characters that completed Shamdon's final assignment before the
	-- explicit Talon-to-Beissa handoff state was introduced.
	local completedShamdon = getQuestStatus(playerID .. "SmugglerSquadronScreenplay:shamdon_finished") == "1" or
		(SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name) and
		getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward") == "1")

	if (completedShamdon) then
		if (getQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_tier3_handoff") == "1") then
			return convoTemplate:getScreen("tier2_handoff_complete")
		end

		return convoTemplate:getScreen("tier2_handoff_intro")
	end

	if (getQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_finished") == "1") then
		return convoTemplate:getScreen("already_complete")
	end

	local patrolActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "patrol", "tat_priv_quest_trans")
	local patrolComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "patrol", "tat_priv_quest_trans")
	local assassinateActive = SpaceHelpers:isSpaceQuestActive(pPlayer, "assassinate", "tat_priv_quest_trans")
	local assassinateComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, "assassinate", "tat_priv_quest_trans")

	if (assassinateComplete) then
		return convoTemplate:getScreen("mission_complete")
	elseif ((patrolActive and not patrolComplete) or assassinateActive) then
		return convoTemplate:getScreen("on_mission")
	end

	return convoTemplate:getScreen("initial")
end

function talonKarrdePilotConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	clonedConversation:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "assign_mission") then
		assassinate_tat_priv_quest_trans:resetQuest(pPlayer)
		patrol_tat_priv_quest_trans:resetQuest(pPlayer)
		patrol_tat_priv_quest_trans:startQuest(pPlayer, pNpc)
	elseif (screenID == "mission_complete") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_finished", 1)
		assassinate_tat_priv_quest_trans:rewardPlayer(pPlayer)
		SpaceHelpers:addShamdonKreeWaypoint(pPlayer)
	elseif (screenID == "tier2_handoff_final") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "SmugglerSquadronScreenplay:shamdon_finished", 1)
		setQuestStatus(playerID .. "SmugglerSquadronScreenplay:talon_tier3_handoff", 1)
		SpaceHelpers:addBeissaWaypoint(pPlayer)
	end

	return pClonedScreen
end

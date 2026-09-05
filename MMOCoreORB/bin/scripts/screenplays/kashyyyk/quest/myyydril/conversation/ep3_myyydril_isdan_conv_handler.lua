-- ep3_myyydril_isdan
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_isdan_conv_handler = conv_handler:new {}

function ep3_myyydril_isdan_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilIsdanRetrieve5ScreenPlay:getRuns(pPlayer) > 0 and myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_3850")
	elseif (((myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilIsdanRetrieve5ScreenPlay:getRuns(pPlayer) > 0 and myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_3856")
	elseif ((myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) > 0) or (myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_3862")
	end

	return convoTemplate:getScreen("s_3864")
end

function ep3_myyydril_isdan_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_3888") then
		myyydrilIsdanRetrieve5ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3856") then
		MyyydrilSignals:send(pPlayer, "giveNeat")
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/myyydril:reward_isdan_quest_1")
	end

	return pClonedScreen
end


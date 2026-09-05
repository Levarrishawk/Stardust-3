-- ep3_myyydril_patrol_leader
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_patrol_leader_conv_handler = conv_handler:new {}

function ep3_myyydril_patrol_leader_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_523")
	elseif ((myyydrilKivvaaaTalkto1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_525")
	elseif ((myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_527")
	end

	return convoTemplate:getScreen("s_529")
end

function ep3_myyydril_patrol_leader_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_577") then
		myyydrilKivvaaaTalkto1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_557") then
		myyydrilKivvaaaTalkto1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_573") then
		myyydrilKivvaaaTalkto1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end


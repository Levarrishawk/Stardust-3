-- ep3_myyydril_patrol_1
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_patrol_1_conv_handler = conv_handler:new {}

function ep3_myyydril_patrol_1_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilTalaoreeDestroy1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) == 0) and (myyydrilTalaoreeTalkto3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTalaoreeTalkto3ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_479")
	elseif ((myyydrilTalaoreeTalkto3ScreenPlay:getStage(pPlayer) > 0) or (myyydrilTalaoreeTalkto3ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_481")
	elseif ((myyydrilTalaoreeDestroy1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_483")
	elseif (((myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilTalaoreeDestroy1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_493")
	elseif ((myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_503")
	end

	return convoTemplate:getScreen("s_519")
end

function ep3_myyydril_patrol_1_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_487") then
		myyydrilTalaoreeTalkto3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_497") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_513") then
		myyydrilTalaoreeDestroy1ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "talktotalaoree")
	end

	return pClonedScreen
end


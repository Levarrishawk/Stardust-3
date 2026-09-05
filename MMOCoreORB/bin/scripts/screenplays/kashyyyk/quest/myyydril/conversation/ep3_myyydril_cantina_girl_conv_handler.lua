-- ep3_myyydril_cantina_girl
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_cantina_girl_conv_handler = conv_handler:new {}

function ep3_myyydril_cantina_girl_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilKirrirTalkto4ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKirrirTalkto4ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_350")
	elseif ((myyydrilKirrirTalkto4ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKirrirTalkto4ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_326")
	elseif ((myyydrilKirirrGather1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_333")
	elseif (((myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKirirrGather1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_346")
	elseif ((myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_349")
	elseif ((myyydrilTalaoreeTalkto3ScreenPlay:getStage(pPlayer) > 0) or (myyydrilTalaoreeTalkto3ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_341")
	end

	return convoTemplate:getScreen("s_300")
end

function ep3_myyydril_cantina_girl_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_335") then
		myyydrilKirrirTalkto4ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_366") then
		myyydrilKirirrGather1ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "talktokirrir")
	elseif (screenID == "s_346") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	end

	return pClonedScreen
end


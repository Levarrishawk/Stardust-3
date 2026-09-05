-- ep3_myyydril_chief
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_chief_conv_handler = conv_handler:new {}

function ep3_myyydril_chief_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_1076")
	elseif ((myyydrilKallaaracDestroy3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracDestroy3ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_3742")
	elseif (((myyydrilKallaaracDestroy3ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKallaaracDestroy3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracDestroy3ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_3748")
	elseif ((myyydrilKallaaracDestroy3ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKallaaracDestroy3ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_3758")
	elseif ((myyydrilKallaaracRetrieve1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_3760")
	elseif (((myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKallaaracRetrieve1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_3774")
	elseif ((myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_3784")
	elseif ((myyydrilKallaaracDestroy2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracDestroy2ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_3786")
	elseif (((myyydrilKallaaracDestroy2ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKallaaracDestroy2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKallaaracDestroy2ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_3796")
	elseif ((myyydrilKallaaracDestroy2ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKallaaracDestroy2ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_3806")
	elseif ((myyydrilNawikaTalkto5ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_1113")
	elseif ((myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer) > 0) or (myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_3812")
	elseif (((myyydrilKivvaaaTalkto1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) == 0) and not (myyydrilNawikaEscort1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_3826")
	elseif ((myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_3832")
	end

	return convoTemplate:getScreen("s_3846")
end

function ep3_myyydril_chief_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_3752") then
		MyyydrilSignals:send(pPlayer, "talktochief")
	elseif (screenID == "s_3768") then
		myyydrilKallaaracDestroy3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3778") then
		MyyydrilSignals:send(pPlayer, "talktokallaarac")
	elseif (screenID == "s_3790") then
		myyydrilKallaaracRetrieve1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3800") then
		MyyydrilSignals:send(pPlayer, "giveStuff")
	elseif (screenID == "s_1117") then
		myyydrilKallaaracDestroy2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3816") then
		MyyydrilSignals:send(pPlayer, "talktochief")
	elseif (screenID == "s_3840") then
		myyydrilKallaaracTalkto2ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "talktokallaarac")
	end

	return pClonedScreen
end


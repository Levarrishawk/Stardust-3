-- ep3_myyydril_kinesworthy
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_kinesworthy_conv_handler = conv_handler:new {}

function ep3_myyydril_kinesworthy_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilKinesworthyEpic3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_4016")
	elseif (((myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKinesworthyEpic3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_4018")
	elseif ((myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_4032")
	elseif ((myyydrilKinesworthyEpic2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_4038")
	elseif (((myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKinesworthyEpic2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_4048")
	elseif ((myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_4062")
	elseif ((myyydrilKinesworthyEpic1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_4068")
	elseif (((myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilKinesworthyEpic1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_4102")
	elseif ((myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2) or (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_4112")
	elseif (((myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer) >= 1))) then
		return convoTemplate:getScreen("s_4118")
	end

	return convoTemplate:getScreen("s_4172")
end

function ep3_myyydril_kinesworthy_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_4026") then
		MyyydrilSignals:send(pPlayer, "phatLewts")
	elseif (screenID == "s_4046") then
		myyydrilKinesworthyEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_4056") then
		MyyydrilSignals:send(pPlayer, "phatLewts")
	elseif (screenID == "s_4096") then
		myyydrilKinesworthyEpic2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_4106") then
		MyyydrilSignals:send(pPlayer, "phatLewts")
	elseif (screenID == "s_4122") then
		MyyydrilSignals:send(pPlayer, "talktokines")
	elseif (screenID == "s_4166") then
		myyydrilKinesworthyEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_4102") then
		MyyydrilSignals:send(pPlayer, "phatLewts")
	end

	return pClonedScreen
end


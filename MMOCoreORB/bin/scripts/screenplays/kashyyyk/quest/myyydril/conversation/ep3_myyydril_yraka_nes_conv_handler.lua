-- ep3_myyydril_yraka_nes
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_yraka_nes_conv_handler = conv_handler:new {}

function ep3_myyydril_yraka_nes_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilYrakaEpic1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaEpic1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_894")
	elseif (((myyydrilYrakaEpic1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilYrakaEpic1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaEpic1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_906")
	elseif ((myyydrilYrakaEpic1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaEpic1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_920")
	elseif ((myyydrilYrakaTalkto6ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_926")
	elseif ((myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_952")
	elseif ((myyydrilYrakaRetrieve3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_955")
	elseif (((myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilYrakaRetrieve3ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_969")
	elseif ((myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_979")
	elseif ((myyydrilYrakaRetrieve2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaRetrieve2ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_981")
	elseif (((myyydrilYrakaRetrieve2ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilYrakaRetrieve2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaRetrieve2ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_999")
	elseif ((myyydrilYrakaRetrieve2ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaRetrieve2ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_1009")
	elseif ((myyydrilYrakaDestroyloot1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_1015")
	elseif (((myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilYrakaDestroyloot1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_1033")
	elseif ((myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_1039")
	elseif ((myyydrilNawikaEscort1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_1041")
	end

	return convoTemplate:getScreen("s_1133")
end

function ep3_myyydril_yraka_nes_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_914") then
		MyyydrilSignals:send(pPlayer, "partsrule")
	elseif (screenID == "s_942") then
		myyydrilYrakaEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_963") then
		myyydrilYrakaTalkto6ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_973") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_989") then
		myyydrilYrakaRetrieve3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1003") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_1023") then
		myyydrilYrakaRetrieve2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1037") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_1073") then
		myyydrilYrakaDestroyloot1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1090") then
		myyydrilYrakaDestroyloot1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1106") then
		myyydrilYrakaDestroyloot1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1127") then
		myyydrilYrakaDestroyloot1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1033") then
		MyyydrilSignals:send(pPlayer, "giveReward")
	end

	return pClonedScreen
end


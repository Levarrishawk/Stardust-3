-- ep3_myyydril_patron_1
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_patron_1_conv_handler = conv_handler:new {}

function ep3_myyydril_patron_1_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_670")
	elseif ((myyydrilNawikaTalkto5ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_586")
	elseif ((myyydrilNawikaEscort1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_592")
	elseif (((myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilNawikaEscort1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_598")
	elseif ((myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) == 1)) then
		return convoTemplate:getScreen("s_608")
	elseif (((myyydrilKirrirTalkto4ScreenPlay:getStage(pPlayer) > 0) or (myyydrilKirrirTalkto4ScreenPlay:getRuns(pPlayer) > 0 and myyydrilKirrirTalkto4ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_620")
	end

	return convoTemplate:getScreen("s_29")
end

function ep3_myyydril_patron_1_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_596") then
		myyydrilNawikaTalkto5ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_606") then
		myyydrilNawikaTalkto5ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "giveReward")
	elseif (screenID == "s_656") then
		myyydrilNawikaEscort1ScreenPlay:grantQuest(pPlayer)
		MyyydrilSignals:send(pPlayer, "talktonawika")
	elseif (screenID == "s_592") then
		myyydrilNawikaTalkto5ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end


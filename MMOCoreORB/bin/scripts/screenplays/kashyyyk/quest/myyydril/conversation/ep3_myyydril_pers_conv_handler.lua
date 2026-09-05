-- ep3_myyydril_pers
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_pers_conv_handler = conv_handler:new {}

function ep3_myyydril_pers_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilPersRetrieve4ScreenPlay:getRuns(pPlayer) > 0 and myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_632")
	elseif (((myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilPersRetrieve4ScreenPlay:getRuns(pPlayer) > 0 and myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_635")
	elseif ((myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) > 0) or (myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_648")
	elseif (CreatureObject(pPlayer):hasSkill("class_smuggler_phase1_novice")) then
		return convoTemplate:getScreen("s_691")
	end

	return convoTemplate:getScreen("s_719")
end

function ep3_myyydril_pers_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_640") then
		MyyydrilSignals:send(pPlayer, "giveLewtSmug")
	elseif (screenID == "s_711") then
		myyydrilPersRetrieve4ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end


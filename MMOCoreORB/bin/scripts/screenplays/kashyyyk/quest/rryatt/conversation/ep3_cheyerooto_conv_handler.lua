-- Cheyerooto -- ep3_cheyerooto_5_rrwii_root
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.
-- OPEN: wrhisch_liver is not this arc; those screens never become the initial screen.

ep3_cheyerooto_conv_handler = conv_handler:new {}

ep3_cheyerooto_conv_handler.screenAnimations = {
}

function ep3_cheyerooto_conv_handler:stage(pPlayer)
	return rryattCheyerootoRrwiiRootScreenPlay:getStage(pPlayer)
end

function ep3_cheyerooto_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_207")
	elseif (rryattCheyerootoRrwiiRootScreenPlay:isComplete(pPlayer)) then
		return convoTemplate:getScreen("s_322")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_512")
	end

	return convoTemplate:getScreen("s_540")
end

function ep3_cheyerooto_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "s_512" and self:stage(pPlayer) ~= 2) then
		clonedConversation:removeAllOptions()
		clonedConversation:addOption("@conversation/ep3_cheyerooto:s_518", "s_520")
	end

	if (screenID == "s_516") then
		rryattCheyerootoRrwiiRootScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_530") then
		rryattCheyerootoRrwiiRootScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

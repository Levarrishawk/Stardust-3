-- Krepauk -- ep3_rryatt_krepauk_* trials
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_rryatt_krepauk_conv_handler = conv_handler:new {}

ep3_rryatt_krepauk_conv_handler.screenAnimations = {
}

local function doneOrReady(sp, pPlayer)
	return sp:getStage(pPlayer) == 2 or sp:isComplete(pPlayer)
end

function ep3_rryatt_krepauk_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local walluga = rryattKrepaukWallugaSmashersScreenPlay
	local exjedi = rryattKrepaukDefeatExjediScreenPlay
	local feral = rryattKrepaukCleanseFeralWookieesScreenPlay
	local minsty = rryattKrepaukEliteMinstyngarScreenPlay
	local katarn = rryattKrepaukDefeatKatarnScreenPlay

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_307")
	elseif (doneOrReady(katarn, pPlayer)) then
		return convoTemplate:getScreen("s_309")
	elseif (katarn:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_311")
	elseif (doneOrReady(minsty, pPlayer)) then
		return convoTemplate:getScreen("s_313")
	elseif (minsty:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_323")
	elseif (doneOrReady(feral, pPlayer)) then
		return convoTemplate:getScreen("s_325")
	elseif (feral:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_335")
	elseif (doneOrReady(exjedi, pPlayer)) then
		return convoTemplate:getScreen("s_337")
	elseif (exjedi:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_347")
	elseif (doneOrReady(walluga, pPlayer)) then
		return convoTemplate:getScreen("s_349")
	elseif (walluga:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_359")
	end

	return convoTemplate:getScreen("s_361")
end

function ep3_rryatt_krepauk_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "s_309") then
		rryattKrepaukDefeatKatarnScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_313") then
		rryattKrepaukEliteMinstyngarScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_317") then
		rryattKrepaukDefeatKatarnScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_325") then
		rryattKrepaukCleanseFeralWookieesScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_329") then
		rryattKrepaukEliteMinstyngarScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_337") then
		rryattKrepaukDefeatExjediScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_341") then
		rryattKrepaukCleanseFeralWookieesScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_349") then
		rryattKrepaukWallugaSmashersScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_353") then
		rryattKrepaukDefeatExjediScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_370") then
		rryattKrepaukWallugaSmashersScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

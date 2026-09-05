-- ep3_etyyy_harroom -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_harroom_conv_handler = conv_handler:new {}

ep3_etyyy_harroom_conv_handler.screenAnimations = {
}

function ep3_etyyy_harroom_conv_handler:needsUllerReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer) and huntSordaanSeekHarroomScreenPlay:hasCompletedTask(pPlayer, "sordaan_ullerBetReward") and not huntHarroomUllerRewardScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_harroom_conv_handler:needsWallugaReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer) and huntSordaanSeekHarroomScreenPlay:hasCompletedTask(pPlayer, "sordaan_wallugaBetReward") and not huntHarroomWallugaRewardScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_harroom_conv_handler:needsMoufReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer) and huntSordaanSeekHarroomScreenPlay:hasCompletedTask(pPlayer, "sordaan_moufBetReward") and not huntHarroomMoufRewardScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_harroom_conv_handler:needsWebweaverReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer) and huntSordaanSeekHarroomScreenPlay:hasCompletedTask(pPlayer, "sordaan_webweaverBetReward") and not huntHarroomWebweaverRewardScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_harroom_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_harroom_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_294")
	end
	if (self:needsUllerReward(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_183")
	elseif (self:needsWallugaReward(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_185")
	elseif (self:needsMoufReward(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_187")
	elseif (self:needsWebweaverReward(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_189")
	end
	return convoTemplate:getScreen("s_294")
end

function ep3_etyyy_harroom_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_183") then
		huntHarroomUllerRewardScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToHarroom")
	elseif (screenID == "s_185") then
		huntHarroomWallugaRewardScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToHarroom")
	elseif (screenID == "s_187") then
		huntHarroomMoufRewardScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToHarroom")
	elseif (screenID == "s_189") then
		huntHarroomWebweaverRewardScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToHarroom")
	end
	return pClonedScreen
end

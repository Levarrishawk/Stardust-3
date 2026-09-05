-- ep3_etyyy_manfred_carter -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_manfred_carter_conv_handler = conv_handler:new {}

ep3_etyyy_manfred_carter_conv_handler.screenAnimations = {
	s_590 = "greet",
}

function ep3_etyyy_manfred_carter_conv_handler:hasCompletedManfredQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredKillChissLeaderScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_manfred_carter_conv_handler:finishedKillChissLeader(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredKillChissLeaderScreenPlay:isTaskActive(pPlayer, "manfred_killedChissLeader")
end

function ep3_etyyy_manfred_carter_conv_handler:isKillingChissLeader(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredKillChissLeaderScreenPlay:isTaskActive(pPlayer, "manfred_killingChissLeader")
end

function ep3_etyyy_manfred_carter_conv_handler:finishedCollectChissChemicals(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredCollectEnhancementsScreenPlay:isTaskActive(pPlayer, "manfred_chissChemicals") or huntManfredCollectEnhancementsScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_manfred_carter_conv_handler:isCollectingChissChemicals(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredCollectEnhancementsScreenPlay:isTaskActive(pPlayer, "manfred_collectChemicals")
end

function ep3_etyyy_manfred_carter_conv_handler:finishedStealChissGoods(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredStealChissGoodsScreenPlay:isTaskActive(pPlayer, "manfred_backToManfred") or huntManfredStealChissGoodsScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_manfred_carter_conv_handler:isDeliveringToKerssoc(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredStealChissGoodsScreenPlay:isTaskActive(pPlayer, "manfred_deliverToKerssoc")
end

function ep3_etyyy_manfred_carter_conv_handler:isStealingChissGoods(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredStealChissGoodsScreenPlay:isTaskActive(pPlayer, "manfred_stealChissGoods")
end

function ep3_etyyy_manfred_carter_conv_handler:hasToTalkToManfred(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntManfredStealChissGoodsScreenPlay:isTaskActive(pPlayer, "manfred_talkToManfred")
end

function ep3_etyyy_manfred_carter_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_manfred_carter_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_600")
	end
	if (self:hasCompletedManfredQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_566")
	elseif (self:finishedKillChissLeader(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_657")
	elseif (self:isKillingChissLeader(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_658")
	elseif (self:finishedCollectChissChemicals(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_659")
	elseif (self:isCollectingChissChemicals(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_660")
	elseif (self:finishedStealChissGoods(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_568")
	elseif (self:isDeliveringToKerssoc(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_574")
	elseif (self:isStealingChissGoods(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_584")
	elseif (self:hasToTalkToManfred(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_590")
	end
	return convoTemplate:getScreen("s_600")
end

function ep3_etyyy_manfred_carter_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_670") then
		EtyyyHuntState:raise(pPlayer, "manfred_killedChissLeader")
		huntTrippCollectMoufPeltsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_665") then
		huntManfredKillChissLeaderScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_572") then
		huntManfredCollectEnhancementsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_594") then
		EtyyyHuntState:raise(pPlayer, "manfred_talkToManfred")
	end
	return pClonedScreen
end

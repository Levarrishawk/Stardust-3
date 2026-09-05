-- ep3_etyyy_iluna_mystuk -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_iluna_mystuk_conv_handler = conv_handler:new {}

ep3_etyyy_iluna_mystuk_conv_handler.screenAnimations = {
}

function ep3_etyyy_iluna_mystuk_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

-- OPEN: ep3_etyyy_iluna_mystuk_condition_doesNotHaveBrodyQuest java was not a straight boolean; see report.
function ep3_etyyy_iluna_mystuk_conv_handler:doesNotHaveBrodyQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return ((huntChriloocSeekJohnsonScreenPlay:isQuestActive(pPlayer) or huntChriloocSeekJohnsonScreenPlay:hasCompletedQuest(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)))
end

function ep3_etyyy_iluna_mystuk_conv_handler:killedGreyclimber(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootGreyclimberKilledScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_iluna_mystuk_conv_handler:killedGreyclimberPlusAll(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootPaleclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSilkthrowerKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootStonelegKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSpiketopKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootBrightclawKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_iluna_mystuk_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	return convoTemplate:getScreen("s_1773")
end

function ep3_etyyy_iluna_mystuk_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_1773") then
		clonedConversation:removeAllOptions()
		if (self:doesNotHaveBrodyQuest(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_iluna_mystuk:s_1775", "s_1777")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_iluna_mystuk:s_1779", "s_1781")
		if (self:killedGreyclimber(pPlayer, pNpc)) then
			if (self:killedGreyclimberPlusAll(pPlayer, pNpc)) then
				clonedConversation:addOption("@conversation/ep3_etyyy_iluna_mystuk:s_1783", "s_1785")
			else
				clonedConversation:addOption("@conversation/ep3_etyyy_iluna_mystuk:s_1783", "s_1791")
			end
		end
	elseif (screenID == "s_1777") then
		huntIlunaGotoArconaCompoundScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1785") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedGreyclimber")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1791") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedGreyclimber")
	end
	return pClonedScreen
end

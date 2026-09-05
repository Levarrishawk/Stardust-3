-- ep3_etyyy_ehartt_brihnt -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_ehartt_brihnt_conv_handler = conv_handler:new {}

ep3_etyyy_ehartt_brihnt_conv_handler.screenAnimations = {
	s_1815 = "greet",
}

function ep3_etyyy_ehartt_brihnt_conv_handler:hasCompletedAllQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntEharttCollectWallugaClawsScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_ehartt_brihnt_conv_handler:finishedCollectingClaws(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntEharttCollectWallugaClawsScreenPlay:isTaskActive(pPlayer, "ehartt_wallugaClaws")
end

function ep3_etyyy_ehartt_brihnt_conv_handler:isCollectingWallugaClaws(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntEharttCollectWallugaClawsScreenPlay:isTaskActive(pPlayer, "ehartt_collectingWallugaClaws")
end

function ep3_etyyy_ehartt_brihnt_conv_handler:speakToEhartt(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntEharttCollectWallugaClawsScreenPlay:isTaskActive(pPlayer, "ehartt_talkToEhartt")
end

function ep3_etyyy_ehartt_brihnt_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_ehartt_brihnt_conv_handler:killedStoneleg(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootStonelegKilledScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_ehartt_brihnt_conv_handler:killedStonelegPlusAll(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootBrightclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSilkthrowerKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootPaleclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSpiketopKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootGreyclimberKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_ehartt_brihnt_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_1835")
	end
	if (self:hasCompletedAllQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1795")
	elseif (self:killedStonelegPlusAll(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1839")
	elseif (self:killedStoneleg(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1845")
	elseif (self:finishedCollectingClaws(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1799")
	elseif (self:isCollectingWallugaClaws(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1811")
	elseif (self:speakToEhartt(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1815")
	end
	return convoTemplate:getScreen("s_1835")
end

function ep3_etyyy_ehartt_brihnt_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_1839") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedStoneleg")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1845") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedStoneleg")
	elseif (screenID == "s_1803") then
		EtyyyHuntState:raise(pPlayer, "ehartt_wallugaClaws")
		EtyyyHuntState:raise(pPlayer, "sordaan_eharttSendsYou")
		huntSordaanSeekSordaanScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1823") then
		EtyyyHuntState:raise(pPlayer, "ehartt_speakWithEhartt")
	end
	return pClonedScreen
end

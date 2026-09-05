-- ep3_etyyy_tuwezz_vol -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_tuwezz_vol_conv_handler = conv_handler:new {}

ep3_etyyy_tuwezz_vol_conv_handler.screenAnimations = {
	s_1665 = "greet",
}

function ep3_etyyy_tuwezz_vol_conv_handler:hasCompletedTuwezzQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzCollectUllerHornsScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_tuwezz_vol_conv_handler:finishedCollectingUllerHorns(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzCollectUllerHornsScreenPlay:isTaskActive(pPlayer, "tuwezz_elderUllerHorns")
end

function ep3_etyyy_tuwezz_vol_conv_handler:isCollectingUllerHorns(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzCollectUllerHornsScreenPlay:isTaskActive(pPlayer, "tuwezz_collectUllerHorns")
end

function ep3_etyyy_tuwezz_vol_conv_handler:finishedHuntingDiseasedUller(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzKillDiseasedUllersScreenPlay:isTaskActive(pPlayer, "tuwezz_diseasedUllersDone") or huntTuwezzKillDiseasedUllersScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_tuwezz_vol_conv_handler:isHuntingDiseasedUller(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzKillDiseasedUllersScreenPlay:isTaskActive(pPlayer, "tuwezz_huntingDiseasedUllers")
end

function ep3_etyyy_tuwezz_vol_conv_handler:hasToSpeakToTuwezz(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzKillDiseasedUllersScreenPlay:isTaskActive(pPlayer, "tuwezz_talkToTuwezz")
end

function ep3_etyyy_tuwezz_vol_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_tuwezz_vol_conv_handler:killedSpiketop(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootSpiketopKilledScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_tuwezz_vol_conv_handler:killedSpiketopPlusAll(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootBrightclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSilkthrowerKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootStonelegKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootPaleclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootGreyclimberKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_tuwezz_vol_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_1685")
	end
	if (self:hasCompletedTuwezzQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1621")
	elseif (self:finishedCollectingUllerHorns(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1625")
	elseif (self:isCollectingUllerHorns(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1637")
	elseif (self:finishedHuntingDiseasedUller(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1645")
	elseif (self:isHuntingDiseasedUller(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1657")
	elseif (self:hasToSpeakToTuwezz(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1665")
	end
	return convoTemplate:getScreen("s_1685")
end

function ep3_etyyy_tuwezz_vol_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_1689") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedSpiketop")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1695") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedSpiketop")
		if (self:killedSpiketopPlusAll(pPlayer, pNpc)) then
			huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
		end
	elseif (screenID == "s_1629") then
		EtyyyHuntState:raise(pPlayer, "tuwezz_elderUllerHorns")
		EtyyyHuntState:raise(pPlayer, "sordaan_tuwezzSendsYou")
		huntSordaanSeekSordaanScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1649") then
		EtyyyHuntState:raise(pPlayer, "tuwezz_diseasedUllersDone")
		huntTuwezzCollectUllerHornsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1673") then
		EtyyyHuntState:raise(pPlayer, "tuwezz_talkToTuwezz")
	end
	return pClonedScreen
end

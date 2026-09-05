-- ep3_etyyy_sordaan_xris -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_sordaan_xris_conv_handler = conv_handler:new {}

ep3_etyyy_sordaan_xris_conv_handler.screenAnimations = {
	s_1154 = "nod_head_multiple",
}

function ep3_etyyy_sordaan_xris_conv_handler:speakWithSordaan(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekSordaanScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:betWonByPlayer(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntSordaanUllerBetWonScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWallugaBetWonScreenPlay:isQuestActive(pPlayer)) or (huntSordaanMoufBetWonScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWebweaverBetWonScreenPlay:isQuestActive(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:betLostByPlayer(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntSordaanUllerBetLostScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWallugaBetLostScreenPlay:isQuestActive(pPlayer)) or (huntSordaanMoufBetLostScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWebweaverBetLostScreenPlay:isQuestActive(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:eligibleForABet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntTuwezzCollectUllerHornsScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:sentToZivenFirst(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntKerssocEnterEtyyyScreenPlay:isTaskActive(pPlayer, "etyyy_talkToZiven")
end

function ep3_etyyy_sordaan_xris_conv_handler:sentByKerssoc(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntKerssocEnterEtyyyScreenPlay:isTaskActive(pPlayer, "etyyy_talkToSordaan")
end

function ep3_etyyy_sordaan_xris_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_sordaan_xris_conv_handler:finishedTuwezz(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekSordaanScreenPlay:hasCompletedTask(pPlayer, "sordaan_tuwezzSendsYou")
end

function ep3_etyyy_sordaan_xris_conv_handler:finishedEhartt(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekSordaanScreenPlay:hasCompletedTask(pPlayer, "sordaan_eharttSendsYou")
end

function ep3_etyyy_sordaan_xris_conv_handler:finishedTripp(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekSordaanScreenPlay:hasCompletedTask(pPlayer, "sordaan_trippSendsYou")
end

function ep3_etyyy_sordaan_xris_conv_handler:finishedZiven(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekSordaanScreenPlay:hasCompletedTask(pPlayer, "sordaan_zivenSendsYou")
end

function ep3_etyyy_sordaan_xris_conv_handler:killedEtyyyNamedCreatures(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntLootCompletedAllScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:wonUllerBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanUllerBetWonScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:wonWallugaBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanWallugaBetWonScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:wonMoufBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanMoufBetWonScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:wonWebweaverBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanWebweaverBetWonScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:lostUllerBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanUllerBetLostScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:lostWallugaBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanWallugaBetLostScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:lostMoufBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanMoufBetLostScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:lostWebweaverBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanWebweaverBetLostScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:betAlreadyActive(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntSordaanUllerBetScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWallugaBetScreenPlay:isQuestActive(pPlayer)) or (huntSordaanMoufBetScreenPlay:isQuestActive(pPlayer)) or (huntSordaanWebweaverBetScreenPlay:isQuestActive(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:eligibleForWallugaBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntEharttCollectWallugaClawsScreenPlay:hasCompletedQuest(pPlayer)) and (EtyyyHuntState:betLevel(pPlayer) >= 1)
end

function ep3_etyyy_sordaan_xris_conv_handler:eligibleForMoufBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntTrippCollectMoufIncisorsScreenPlay:hasCompletedQuest(pPlayer)) and (EtyyyHuntState:betLevel(pPlayer) >= 2)
end

function ep3_etyyy_sordaan_xris_conv_handler:eligibleForWebweaverBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntZivenCollectWebweaverEyesScreenPlay:hasCompletedQuest(pPlayer)) and (EtyyyHuntState:betLevel(pPlayer) >= 3)
end

function ep3_etyyy_sordaan_xris_conv_handler:eligibleForAnyBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (EtyyyHuntState:betLevel(pPlayer) >= 4)
end

function ep3_etyyy_sordaan_xris_conv_handler:canAffordWebweaverBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return EtyyyHuntState:hasFunds(pPlayer, 25000)
end

function ep3_etyyy_sordaan_xris_conv_handler:canAffordMoufBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return EtyyyHuntState:hasFunds(pPlayer, 10000)
end

function ep3_etyyy_sordaan_xris_conv_handler:canAffordWallugaBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return EtyyyHuntState:hasFunds(pPlayer, 5000)
end

function ep3_etyyy_sordaan_xris_conv_handler:canAffordUllerBet(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return EtyyyHuntState:hasFunds(pPlayer, 2000)
end

function ep3_etyyy_sordaan_xris_conv_handler:hasNotSeenHarroom(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_sordaan_xris_conv_handler:notGottenUllerReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (not huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)) and (not huntHarroomUllerRewardScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:notGottenWallugaReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (not huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)) and (not huntHarroomWallugaRewardScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:notGottenMoufReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (not huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)) and (not huntHarroomMoufRewardScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:notGottenWebweaverReward(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (not huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)) and (not huntHarroomWebweaverRewardScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_sordaan_xris_conv_handler:destroyedBocctyyyTicket(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return false
end

function ep3_etyyy_sordaan_xris_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_1432")
	end
	if (self:speakWithSordaan(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1134")
	elseif (self:betWonByPlayer(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1190")
	elseif (self:betLostByPlayer(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1268")
	elseif (self:eligibleForABet(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1290")
	elseif (self:sentToZivenFirst(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1428")
	elseif (self:sentByKerssoc(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1430")
	end
	return convoTemplate:getScreen("s_1432")
end

function ep3_etyyy_sordaan_xris_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_1134") then
		clonedConversation:removeAllOptions()
		if (self:finishedTuwezz(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1136", "s_1138")
		end
		if (self:finishedEhartt(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1156", "s_1158")
		end
		if (self:finishedTripp(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1166", "s_1168")
		end
		if (self:finishedZiven(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1176", "s_1178")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1186", "s_1188")
		if (self:killedEtyyyNamedCreatures(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_sordaan_xris:s_1453", "s_1434")
		end
	elseif (screenID == "s_1138") then
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToSordaan")
		huntEharttCollectWallugaClawsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1158") then
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToSordaan")
		huntManfredStealChissGoodsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1168") then
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToSordaan")
		huntZivenCollectWebweaverFangsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1178") then
		EtyyyHuntState:raise(pPlayer, "sordaan_talkToSordaan")
	elseif (screenID == "s_1434") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedAll")
		-- OPEN: badge bdg_kash_hunting_excellence is not in this repo
	elseif (screenID == "s_1418") then
		huntSordaanUllerBetScreenPlay:grantQuest(pPlayer)
		-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree
		EtyyyHuntState:takeFunds(pPlayer, 2000)
	elseif (screenID == "s_1194") then
		EtyyyHuntState:raise(pPlayer, "sordaan_ullerBetWon")
		CreatureObject(pPlayer):addBankCredits(4000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 1)
		EtyyyHuntState:raise(pPlayer, "sordaan_ullerBetReward")
		huntSordaanSeekHarroomScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1200") then
		EtyyyHuntState:raise(pPlayer, "sordaan_ullerBetWon")
		CreatureObject(pPlayer):addBankCredits(4000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 1)
	elseif (screenID == "s_1212") then
		EtyyyHuntState:raise(pPlayer, "sordaan_wallugaBetWon")
		CreatureObject(pPlayer):addBankCredits(10000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 2)
		EtyyyHuntState:raise(pPlayer, "sordaan_wallugaBetReward")
		huntSordaanSeekHarroomScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1218") then
		EtyyyHuntState:raise(pPlayer, "sordaan_wallugaBetWon")
		CreatureObject(pPlayer):addBankCredits(10000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 2)
	elseif (screenID == "s_1230") then
		EtyyyHuntState:raise(pPlayer, "sordaan_moufBetWon")
		CreatureObject(pPlayer):addBankCredits(20000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 3)
		EtyyyHuntState:raise(pPlayer, "sordaan_moufBetReward")
		huntSordaanSeekHarroomScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1236") then
		EtyyyHuntState:raise(pPlayer, "sordaan_moufBetWon")
		CreatureObject(pPlayer):addBankCredits(20000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 3)
	elseif (screenID == "s_1248") then
		EtyyyHuntState:raise(pPlayer, "sordaan_webweaverBetWon")
		CreatureObject(pPlayer):addBankCredits(50000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 4)
		EtyyyHuntState:raise(pPlayer, "sordaan_webweaverBetReward")
		huntSordaanSeekHarroomScreenPlay:grantQuest(pPlayer)
		-- OPEN: necklace_rodian_safari.iff has no repo template
	elseif (screenID == "s_1254") then
		EtyyyHuntState:raise(pPlayer, "sordaan_webweaverBetWon")
		CreatureObject(pPlayer):addBankCredits(50000, true)
		EtyyyHuntState:raiseBetLevel(pPlayer, 4)
	elseif (screenID == "s_1272") then
		EtyyyHuntState:raise(pPlayer, "sordaan_ullerBetLost")
		EtyyyHuntState:setCanDoBanol(pPlayer, true)
	elseif (screenID == "s_1276") then
		EtyyyHuntState:raise(pPlayer, "sordaan_wallugaBetLost")
		EtyyyHuntState:setCanDoBanol(pPlayer, true)
	elseif (screenID == "s_1280") then
		EtyyyHuntState:raise(pPlayer, "sordaan_moufBetLost")
		EtyyyHuntState:setCanDoBanol(pPlayer, true)
	elseif (screenID == "s_1284") then
		EtyyyHuntState:raise(pPlayer, "sordaan_webweaverBetLost")
		EtyyyHuntState:setCanDoBanol(pPlayer, true)
	elseif (screenID == "s_214") then
		-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree
	elseif (screenID == "s_1338") then
		huntSordaanWebweaverBetScreenPlay:grantQuest(pPlayer)
		-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree
		EtyyyHuntState:takeFunds(pPlayer, 25000)
	elseif (screenID == "s_1370") then
		huntSordaanMoufBetScreenPlay:grantQuest(pPlayer)
		-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree
		EtyyyHuntState:takeFunds(pPlayer, 10000)
	elseif (screenID == "s_1398") then
		huntSordaanWallugaBetScreenPlay:grantQuest(pPlayer)
		-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree
		EtyyyHuntState:takeFunds(pPlayer, 5000)
	end
	return pClonedScreen
end

-- ep3_etyyy_pilot_to_bocctyyy -- Etyyy to Bocctyyy shuttle
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires travel on the accept screens.
-- No journal engine: this branch has no managers/quest/journal.lua.
-- OPEN: KashyyykIslands / BocctyyyTheBet are loaded by the dungeons branch; this branch does not include them.
-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree.
-- OPEN: god-mode ticket create is not implemented.

ep3_etyyy_pilot_to_bocctyyy_conv_handler = conv_handler:new {}

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:canGoToBocctyyy(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	return huntSordaanUllerBetScreenPlay:isQuestActive(pPlayer)
		or huntSordaanWallugaBetScreenPlay:isQuestActive(pPlayer)
		or huntSordaanMoufBetScreenPlay:isQuestActive(pPlayer)
		or huntSordaanWebweaverBetScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:tooManyInGroup(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	return CreatureObject(pPlayer):isGrouped() and CreatureObject(pPlayer):getGroupSize() > 6
end

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:isFemaleCharacter(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	return CreatureObject(pPlayer):getGender() == 1
end

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:sendToBocctyyy(pPlayer)
	if (pPlayer == nil) then
		return
	end
	if (KashyyykIslands ~= nil) then
		KashyyykIslands.travelTo(pPlayer, "bocctyyy")
		BocctyyyTheBet:enter(pPlayer)
	end
end

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_706")
	end
	if (self:canGoToBocctyyy(pPlayer)) then
		return convoTemplate:getScreen("s_688")
	elseif (self:isFemaleCharacter(pPlayer)) then
		return convoTemplate:getScreen("s_700")
	end
	return convoTemplate:getScreen("s_706")
end

function ep3_etyyy_pilot_to_bocctyyy_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_690") then
		if (self:tooManyInGroup(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_692")
		end
		self:sendToBocctyyy(pPlayer)
		if (self:isFemaleCharacter(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_116")
		end
		return LuaConversationTemplate(pConvTemplate):getScreen("s_694")
	end
	return pClonedScreen
end

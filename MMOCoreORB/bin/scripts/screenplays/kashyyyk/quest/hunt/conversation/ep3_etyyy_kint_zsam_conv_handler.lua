-- ep3_etyyy_kint_zsam -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_kint_zsam_conv_handler = conv_handler:new {}

ep3_etyyy_kint_zsam_conv_handler.screenAnimations = {
	s_270 = "belly_laugh",
}

function ep3_etyyy_kint_zsam_conv_handler:knowsKint(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonSeekKintScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_kint_zsam_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

-- OPEN: ep3_etyyy_kint_zsam_condition_canEnterHracca java was not a straight boolean; see report.
function ep3_etyyy_kint_zsam_conv_handler:canEnterHracca(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntHraccaKkorrwrotHuntScreenPlay:isTaskActive(pPlayer, "hracca_huntKkorrwrot") and (KashyyykIslands ~= nil))
end

-- OPEN: ep3_etyyy_kint_zsam_condition_killedKkorrwrotNoBadge java was not a straight boolean; see report.
function ep3_etyyy_kint_zsam_conv_handler:killedKkorrwrotNoBadge(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntHraccaKkorrwrotHuntScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_kint_zsam_conv_handler:hasKilledKkorrwrot(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntHraccaKkorrwrotHuntScreenPlay:isTaskActive(pPlayer, "hracca_kkorrwrotKilled")
end

-- OPEN: ep3_etyyy_kint_zsam_condition_needsATicket java was not a straight boolean; see report.
function ep3_etyyy_kint_zsam_conv_handler:needsATicket(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntHraccaKkorrwrotHuntScreenPlay:isTaskActive(pPlayer, "hracca_huntKkorrwrot") and (KashyyykIslands == nil))
end

function ep3_etyyy_kint_zsam_conv_handler:sentBySmith(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonSeekKintScreenPlay:isQuestActive(pPlayer)
end

-- OPEN: ep3_etyyy_kint_zsam_condition_hasHraccaTicket java was not a straight boolean; see report.
function ep3_etyyy_kint_zsam_conv_handler:hasHraccaTicket(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (KashyyykIslands ~= nil)
end

function ep3_etyyy_kint_zsam_conv_handler:canRepeatHunt(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntHraccaKkorrwrotHuntScreenPlay:hasCompletedQuest(pPlayer)
end

-- OPEN: ep3_etyyy_kint_zsam_condition_tooManyInGroup java was not a straight boolean; see report.
function ep3_etyyy_kint_zsam_conv_handler:tooManyInGroup(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (CreatureObject(pPlayer):isGrouped() and CreatureObject(pPlayer):getGroupSize() > 8)
end

-- OPEN: java isInGodMode / giveHraccaGatePass. Core3 has no matching god-ticket grant.
function ep3_etyyy_kint_zsam_conv_handler:isInGodMode(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return false
end

function ep3_etyyy_kint_zsam_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_203")
	end
	if (self:knowsKint(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_183")
	end
	return convoTemplate:getScreen("s_203")
end

function ep3_etyyy_kint_zsam_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_183") then
		clonedConversation:setDialogTextTO(CreatureObject(pPlayer):getFirstName())
		clonedConversation:removeAllOptions()
		if (self:canEnterHracca(pPlayer, pNpc) or self:needsATicket(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_185", "s_189")
		end
		if (self:killedKkorrwrotNoBadge(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_379", "s_380")
		end
		if (self:hasKilledKkorrwrot(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_191", "s_193")
		end
		if (self:canRepeatHunt(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_195", "s_197")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_199", "s_201")
	elseif (screenID == "s_189") then
		if (self:tooManyInGroup(pPlayer, pNpc)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_187")
		end
	elseif (screenID == "s_203") then
		clonedConversation:removeAllOptions()
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_205", "s_208")
		if (self:sentBySmith(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_210", "s_212")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_282", "s_284")
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_287", "s_290")
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_301", "s_303")
	elseif (screenID == "s_246") then
		clonedConversation:removeAllOptions()
		if (self:hasHraccaTicket(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_250", "s_254")
		else
			clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_250", "s_258")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_kint_zsam:s_262", "s_266")
	elseif (screenID == "s_380") then
		-- OPEN: badge bdg_kash_hunting_excellence is not in this repo
	elseif (screenID == "s_193") then
		EtyyyHuntState:raise(pPlayer, "hracca_kkorrwrotKilled")
	elseif (screenID == "s_197") then
		-- OPEN: hracca_glade_ticket / space_dungeon.KASH_MONSTER_ISLAND is not in this tree
	elseif (screenID == "s_259") then
		if (KashyyykIslands ~= nil) then
			KashyyykIslands.travelTo(pPlayer, "hracca")
		end
	elseif (screenID == "s_254") then
		EtyyyHuntState:raise(pPlayer, "johnson_talkToKint")
		huntHraccaKkorrwrotHuntScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_258") then
		-- OPEN: hracca_glade_ticket / space_dungeon.KASH_MONSTER_ISLAND is not in this tree
		EtyyyHuntState:raise(pPlayer, "johnson_talkToKint")
		huntHraccaKkorrwrotHuntScreenPlay:grantQuest(pPlayer)
	end
	return pClonedScreen
end

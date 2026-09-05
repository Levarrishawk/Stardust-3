-- Kressik -- ep3_kachirho_trando_rifle_crafting
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_trando_kressik_conv_handler = conv_handler:new {}

ep3_trando_kressik_conv_handler.screenAnimations = {
}

function ep3_trando_kressik_conv_handler:stage(pPlayer)
	return kachirhoTrandoRifleCraftingScreenPlay:getStage(pPlayer)
end

function ep3_trando_kressik_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:stage(pPlayer) == 0 and kachirhoTrandoRifleCraftingScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_4")
	elseif (kachirhoTrandoRifleCraftingScreenPlay:canTurnInBowcaster(pPlayer)) then
		return convoTemplate:getScreen("s_6")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_16")
	elseif (CreatureObject(pPlayer):hasSkill("crafting_weaponsmith_master")) then
		return convoTemplate:getScreen("s_20")
	end

	return convoTemplate:getScreen("s_60")
end

function ep3_trando_kressik_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_32") then
		kachirhoTrandoRifleCraftingScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_50") then
		kachirhoTrandoRifleCraftingScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

-- Lolo -- ground tree for ep3_kachirho_trando_rifle_crafting. Mobile already carries ep3_wke_lolo_convotemplate (space inspect); this file is not attached.
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_wke_lolo_conv_handler = conv_handler:new {}

ep3_wke_lolo_conv_handler.screenAnimations = {
}

function ep3_wke_lolo_conv_handler:stage(pPlayer)
	return kachirhoTrandoRifleCraftingScreenPlay:getStage(pPlayer)
end

function ep3_wke_lolo_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_87")
	elseif (kachirhoTrandoRifleCraftingScreenPlay:hasCompletedLolo(pPlayer)) then
		return convoTemplate:getScreen("s_254")
	elseif (kachirhoTrandoRifleCraftingScreenPlay:hasBowcasterPieces(pPlayer)) then
		return convoTemplate:getScreen("s_88")
	elseif (kachirhoTrandoRifleCraftingScreenPlay:hasFailedSpace(pPlayer)) then
		return convoTemplate:getScreen("s_89")
	elseif (self:stage(pPlayer) > 0 and self:stage(pPlayer) ~= 1) then
		return convoTemplate:getScreen("s_90")
	elseif (self:stage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_91")
	end

	return convoTemplate:getScreen("s_100")
end

function ep3_wke_lolo_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_258") then
		kachirhoTrandoRifleCraftingScreenPlay:grantSpaceMission(pPlayer)
	elseif (screenID == "s_108") then
		kachirhoTrandoRifleCraftingScreenPlay:grantSpaceMission(pPlayer)
	elseif (screenID == "s_104") then
		kachirhoTrandoRifleCraftingScreenPlay:grantBarrelSchematic(pPlayer)
		kachirhoTrandoRifleCraftingScreenPlay:grantSpaceMission(pPlayer)
		kachirhoTrandoRifleCraftingScreenPlay:signalQuestionLolo(pPlayer)
	end

	return pClonedScreen
end

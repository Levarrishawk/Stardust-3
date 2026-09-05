-- Achonnko -- grant site for ep3_rryatt_trail_mastery
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant.
-- OPEN: no Creature:new; this handler is included but cannot be attached.
-- OPEN: camo-kit and zone warps are not this arc. Warp screens are idle.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_achonnko_conv_handler = conv_handler:new {}

ep3_achonnko_conv_handler.screenAnimations = {
}

function ep3_achonnko_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local sp = rryattTrailMasteryScreenPlay

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_169")
	elseif (sp:getStage(pPlayer) == 0 and sp:getRuns(pPlayer) == 0) then
		return convoTemplate:getScreen("s_171")
	end

	return convoTemplate:getScreen("s_185")
end

function ep3_achonnko_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	local sp = rryattTrailMasteryScreenPlay

	if (screenID == "s_185") then
		clonedConversation:removeAllOptions()

		if (sp:hasLevel(pPlayer, 1)) then
			clonedConversation:addOption("@conversation/ep3_achonnko:s_187", "s_189")
		end

		if (sp:hasLevel(pPlayer, 2)) then
			clonedConversation:addOption("@conversation/ep3_achonnko:s_191", "s_193")
		end

		if (sp:hasLevel(pPlayer, 3)) then
			clonedConversation:addOption("@conversation/ep3_achonnko:s_195", "s_197")
		end

		if (sp:hasLevel(pPlayer, 4)) then
			clonedConversation:addOption("@conversation/ep3_achonnko:s_199", "s_201")
		end

		clonedConversation:addOption("@conversation/ep3_achonnko:s_203", "s_205")
	elseif (screenID == "s_183") then
		sp:grantQuest(pPlayer)
	end

	return pClonedScreen
end

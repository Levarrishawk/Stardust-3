-- Achonnko grants trail mastery and offers travel only to levels the player has unlocked.
ep3_achonnko_conv_handler = conv_handler:new {}

ep3_achonnko_conv_handler.screenAnimations = {
}

function ep3_achonnko_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local sp = rryattTrailMasteryScreenPlay

	if (not KashyyykRryattNpcs:canUseNpc(pPlayer, pNpc)) then
		return nil
	elseif (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")
		and not CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01")) then
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
		local npc = KashyyykRryattNpcs:getNpc(pNpc)
		if (npc ~= nil and npc.mastery and KashyyykRryattNpcs:canUseNpc(pPlayer, pNpc)
			and (CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")
			or CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01"))) then
			sp:grantQuest(pPlayer)
		end
	elseif (screenID == "s_189") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, true, 1)
	elseif (screenID == "s_193") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, true, 2)
	elseif (screenID == "s_197") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, true, 3)
	elseif (screenID == "s_201") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, true, 4)
	end

	return pClonedScreen
end

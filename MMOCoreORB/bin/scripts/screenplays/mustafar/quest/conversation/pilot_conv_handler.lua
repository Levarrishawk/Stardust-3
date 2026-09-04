--[[
	Master Pilot Menddle -- conversation handler for som_story_arc_chapter_three_03
	task 0, "Talk to a Pilot" (storyArcChaptersScreenPlay).

	The tree is in mobile/conversations/mustafar/story_arc_chapter_three_pilot.lua
	and carries the DEVIATION note for the instanced crater.  This file only routes
	and fires the side effects.

	SOE's two dispatch conditions, read out of OnStartNpcConversation and kept in
	SOE's order, first match wins:

	  travelToVolcanoTwo  volcano_arena_one COMPLETE, or the whole quest is  -> ready
	  travelToVolcano     volcano_arena_one ACTIVE                           -> greeting
	  default                                                               -> busy

	Both conditions also call instance.flagPlayerForInstance as a side effect of
	being TESTED.  The repo has no instance to flag into, so only the test carries
	over -- see the tree's DEVIATION block.

	volcano_arena_one is STAGE_FIND_PILOT, so "active" is stage == STAGE_FIND_PILOT
	and "completed" is any stage past it.

	SOE fires two actions on each of the two go-ahead edges, in this order:
	sendFirstSignal, then sendGroupToVolcano.  sendGroupToVolcano is nothing but
	the instance move and has no repo counterpart.  sendFirstSignal is the one that
	carries the quest, and it is group-aware; sendPartyToVolcano reproduces it.
--]]

pilot_conv_handler = conv_handler:new {}
pilot_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function pilot_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	if (stage > storyArcChaptersScreenPlay.STAGE_FIND_PILOT) then
		return convoTemplate:getScreen("ready")
	elseif (stage == storyArcChaptersScreenPlay.STAGE_FIND_PILOT) then
		return convoTemplate:getScreen("greeting")
	end

	return convoTemplate:getScreen("busy")
end

function pilot_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "fly" or screenID == "ready_go") then
		storyArcChaptersScreenPlay:sendPartyToVolcano(pPlayer)
	end

	return pClonedScreen
end

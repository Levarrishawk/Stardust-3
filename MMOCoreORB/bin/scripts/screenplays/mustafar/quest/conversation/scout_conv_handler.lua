--[[
	Scout Olon Lono -- conversation handler for som_story_arc_chapter_three_01
	task 6, "Defeat the Droid Army" (storyArcChaptersScreenPlay).

	The tree is in mobile/conversations/mustafar/story_arc_chapter_three_scout.lua
	and carries the DEVIATION note for the instanced battlefield.  This file only
	routes and fires the one side effect.

	SOE's three dispatch conditions map onto storyArcChaptersScreenPlay:

	  readyToEnterAgain  flagged, or the battle task/quest complete  -> return
	  readyToEnterOne    the battle task is active                   -> briefing
	  default                                                        -> busy

	SOE's order is kept even though the repo's first two tests are mutually
	exclusive.  "Flagged for the instance" is the repo's armyReleased flag: on
	live, a player who had already been sent in got the "want to head back in?"
	screen forever after, and that is what armyReleased reproduces.

	sendGroupToBattlefield is the screenplay's sendToBattlefield, which spawns the
	army once and reports the remaining count on any later visit -- the repo has
	no instance to move the player into.  See the tree's DEVIATION block.
--]]

scout_conv_handler = conv_handler:new {}
scout_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function scout_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	if (storyArcChaptersScreenPlay:hasFlag(pPlayer, "armyReleased") or stage > storyArcChaptersScreenPlay.STAGE_DROID_ARMY) then
		return convoTemplate:getScreen("return")
	elseif (stage == storyArcChaptersScreenPlay.STAGE_DROID_ARMY) then
		return convoTemplate:getScreen("briefing")
	end

	return convoTemplate:getScreen("busy")
end

function scout_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "accept" or screenID == "return_yes") then
		storyArcChaptersScreenPlay:sendToBattlefield(pPlayer)
	end

	return pClonedScreen
end

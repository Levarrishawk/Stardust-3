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
	exclusive.  "Flagged for the instance" is the repo's armyReleased flag.  The
	live conditions were read line by line (story_arc_chapter_three_scout.java
	:18-43) and the flag is set by the CONDITION, not by the action: on the first
	visit readyToEnterAgain is false, readyToEnterOne sees the task active, calls
	instance.flagPlayerForInstance, and returns true -- so visit one is the
	briefing and every visit after it is "want to head back in?", forever.  That
	is why the flag is set here in getInitialScreen and not in sendToBattlefield;
	setting it on entry instead would give the briefing twice to anyone who
	talked to the scout and walked away.

	sendGroupToBattlefield is instance.requestInstanceMovement(player,
	"mustafar_droid_army").  Round F1(c) gave that a real destination: the
	screenplay's sendToBattlefield now hands off to ValleyBattlefield:enter.  It
	used to spawn a six-droid stand-in army in the open world; it does not any
	more.  See the tree's DEVIATION block.
--]]

scout_conv_handler = conv_handler:new {}
scout_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function scout_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	if (storyArcChaptersScreenPlay:hasFlag(pPlayer, "armyReleased") or stage > storyArcChaptersScreenPlay.STAGE_DROID_ARMY) then
		return convoTemplate:getScreen("return")
	elseif (stage == storyArcChaptersScreenPlay.STAGE_DROID_ARMY) then
		-- live's readyToEnterOne flags the player the moment it sees the task
		-- active, before the screen is handed back.  Same here.
		storyArcChaptersScreenPlay:setFlag(pPlayer, "armyReleased")
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

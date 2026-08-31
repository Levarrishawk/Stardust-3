--[[
	Engineer Cobar -- conversation handler for som_story_arc_chapter_three_02,
	"Get a Terminal Override" (storyArcChaptersScreenPlay).

	The tree is in mobile/conversations/mustafar/story_arc_chapter_three_cobar.lua.
	This file only routes and fires the one side effect.

	SOE's two dispatch conditions map onto storyArcChaptersScreenPlay like this:

	  isTaskActive("som_story_arc_chapter_three_02",
	               "mustafar_droid_factory_slicing")   -> sliceQuest and not
	                                                      overrideTool  -> greeting
	  default                                          ->                 busy

	The side quest has exactly one task, so "the quest is active" and "that task
	is active" are the same test.  It opens when the factory terminal first
	refuses the player (the screenplay sets sliceQuest there) and closes when the
	tool is handed over (overrideTool).  Both halves are needed: without the
	second, Cobar would keep offering a tool the player already has.

	grantTool is the screenplay's grantOverrideTool, which sets overrideTool and
	tells the player -- that is this repo's stand-in for SOE's sendSignal
	"mustafar_droid_factory_tool_recieved", since there is no groundquests
	journal here for the signal to land in.
--]]

cobar_conv_handler = conv_handler:new {}
cobar_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function cobar_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (storyArcChaptersScreenPlay:isSlicingTaskActive(pPlayer)) then
		return convoTemplate:getScreen("greeting")
	end

	return convoTemplate:getScreen("busy")
end

function cobar_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "grant_tool") then
		storyArcChaptersScreenPlay:grantOverrideTool(pPlayer)
	end

	return pClonedScreen
end

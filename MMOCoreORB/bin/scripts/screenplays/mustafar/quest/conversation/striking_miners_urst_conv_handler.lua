--[[
	Urup Fal'co -- conversation handler for the Mensix Mining Company's side of
	the strike (som_striking_miners / somStrikingMinersScreenPlay).

	The tree is in mobile/conversations/mustafar/striking_miners_urst.lua.
	This file only routes.

	SOE's dispatch, and what each condition is here:

	  hasCompletedQuest("som_striking_miners")            -> done
	  isTaskActive(...,"mustafar_striking_miners_five")   -> report
	  isQuestActive("som_striking_miners")                -> checkin
	  default                                             -> greeting

	mustafar_striking_miners_five is the .qst's turn-in wait, which is
	STAGE_REPORT_URUP.  isQuestActive is any live stage below that.

	hasCompletedQuest has no stage to sit on: allowRepeats is true, so closeOut()
	resets the player to STAGE_NONE at payout and bumps a run counter instead.
	getRuns() > 0 is the exact analogue and it is what routes the done bubble --
	the same reasoning, written out in full, as in
	miner_madness_chief_drono_conv_handler.lua.
--]]

striking_miners_urst_conv_handler = conv_handler:new {}

function striking_miners_urst_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somStrikingMinersScreenPlay:getStage(pPlayer)

	if (stage == somStrikingMinersScreenPlay.STAGE_REPORT_URUP) then
		return convoTemplate:getScreen("report")
	elseif (stage ~= somStrikingMinersScreenPlay.STAGE_NONE) then
		return convoTemplate:getScreen("checkin")
	elseif (somStrikingMinersScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("done")
	end

	return convoTemplate:getScreen("greeting")
end

function striking_miners_urst_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- s_32 -> s_34.  groundquests.grantQuest(player, "som_striking_miners").
	if (screenID == "accept") then
		somStrikingMinersScreenPlay:grantQuest(pPlayer)

	-- s_19 -> s_20.  The reward is handed over on this screen.
	elseif (screenID == "hand_in") then
		somStrikingMinersScreenPlay:turnIn(pPlayer)
	end

	return pClonedScreen
end

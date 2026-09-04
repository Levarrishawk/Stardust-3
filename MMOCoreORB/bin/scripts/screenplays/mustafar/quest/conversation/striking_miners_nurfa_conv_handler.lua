--[[
	Foreman Nurfa Laz'op -- conversation handler for the strikers' side of
	som_striking_miners (somStrikingMinersScreenPlay).

	The tree is in mobile/conversations/mustafar/striking_miners_nurfa.lua.
	This file only routes.  He neither grants nor completes the quest; he is
	the two middle legs of it.

	SOE's dispatch is FIVE conditions, and the order matters because three of
	the task names are checked individually rather than with isQuestActive:

	  hasCompletedQuest("som_striking_miners")            -> done       (bubble)
	  isTaskActive(...,"mustafar_striking_miners_three")  -> eggs_ready
	  isTaskActive(...,"mustafar_striking_miners_two")    -> checkin
	  isTaskActive(...,"mustafar_striking_miners_one")    -> greeting
	  default                                             -> brush_off  (bubble)

	Mapped onto this screenplay's stages:

	  _one   = STAGE_MEET_NURFA    Urup has sent the player; Nurfa will talk.
	  _two   = STAGE_STEAL_EGGS    out at Tulrus Isle.
	  _three = STAGE_RETURN_NURFA  ten eggs in hand.

	Note what the default does.  A player who has NOT been sent by Urup gets
	s_40 and nothing else -- Nurfa cannot be used to skip the company half of
	the quest.  STAGE_REPORT_URUP falls into that default too, and so does a
	finished-and-reset player, which is why the done bubble is routed off
	getRuns() rather than off a stage.  Same reasoning as
	miner_madness_chief_drono_conv_handler.lua.
--]]

striking_miners_nurfa_conv_handler = conv_handler:new {}

function striking_miners_nurfa_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somStrikingMinersScreenPlay:getStage(pPlayer)

	if (stage == somStrikingMinersScreenPlay.STAGE_RETURN_NURFA) then
		return convoTemplate:getScreen("eggs_ready")
	elseif (stage == somStrikingMinersScreenPlay.STAGE_STEAL_EGGS) then
		return convoTemplate:getScreen("checkin")
	elseif (stage == somStrikingMinersScreenPlay.STAGE_MEET_NURFA) then
		return convoTemplate:getScreen("greeting")
	elseif (stage == somStrikingMinersScreenPlay.STAGE_NONE and somStrikingMinersScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("done")
	end

	return convoTemplate:getScreen("brush_off")
end

function striking_miners_nurfa_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- s_44 -> s_46.  sendSignal(player, "mustafar_striking_miners_nurfa"),
	-- which clears task 1 and opens the egg hunt.
	if (screenID == "its_a_deal") then
		somStrikingMinersScreenPlay:signalNurfa(pPlayer)

	-- s_20 -> s_21.  sendSignal(player, "mustafar_striking_miners_win"),
	-- which clears task 3 and sends the player back to Urup.
	elseif (screenID == "a_deal_is_a_deal") then
		somStrikingMinersScreenPlay:signalNurfaWin(pPlayer)
	end

	return pClonedScreen
end

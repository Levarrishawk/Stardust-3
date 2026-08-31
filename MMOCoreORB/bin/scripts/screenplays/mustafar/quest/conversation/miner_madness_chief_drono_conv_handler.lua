--[[
	Chief Armstrong -- conversation handler for "Miner Madness"
	(som_poison_miners / somPoisonMinersScreenPlay).

	The tree is in mobile/conversations/mustafar/miner_madness_chief_drono.lua.
	This file only routes.

	SOE's dispatch, and what each condition is here:

	  hasCompletedQuest("som_poison_miners")            -> done
	  isTaskActive(...,"mustafar_poison_miners_five")   -> report
	  isQuestActive("som_poison_miners")                -> checkin
	  default                                           -> greeting

	mustafar_poison_miners_five is the .qst's turn-in wait, which is
	STAGE_REPORT.  isQuestActive is any stage between un-started and that.

	hasCompletedQuest has no stage to sit on: the .qst carries allowRepeats
	true, so closeOut() resets the player to STAGE_NONE at payout and bumps a
	run counter instead.  getRuns() > 0 is therefore the exact analogue and it
	is what routes the done bubble.  That means Armstrong will not re-offer the
	job to someone who has already finished it -- which is what SOE's dispatch
	does, since s_4 is a bubble with no options.  allowRepeats still holds: the
	quest system will take a re-grant, Armstrong just is not the one who gives
	it.
--]]

miner_madness_chief_drono_conv_handler = conv_handler:new {}

function miner_madness_chief_drono_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somPoisonMinersScreenPlay:getStage(pPlayer)

	if (stage == somPoisonMinersScreenPlay.STAGE_REPORT) then
		return convoTemplate:getScreen("report")
	elseif (stage ~= somPoisonMinersScreenPlay.STAGE_NONE) then
		return convoTemplate:getScreen("checkin")
	elseif (somPoisonMinersScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("done")
	end

	return convoTemplate:getScreen("greeting")
end

function miner_madness_chief_drono_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- s_48 -> s_50 and s_44 -> s_46.  Two ways of saying yes; SOE gave both
	-- the same grantQuest call and the same reply text.
	if (screenID == "accept_blunt" or screenID == "accept") then
		somPoisonMinersScreenPlay:grantQuest(pPlayer)

	-- s_54 -> s_55.  clearQuest then grantQuest, back to back.
	elseif (screenID == "retry") then
		somPoisonMinersScreenPlay:regrantQuest(pPlayer)

	-- s_25 -> s_26.  The reward is handed over on this screen.
	elseif (screenID == "hand_in") then
		somPoisonMinersScreenPlay:turnIn(pPlayer)
	end

	return pClonedScreen
end

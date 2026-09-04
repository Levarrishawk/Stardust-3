--[[
	Jural -- conversation handler for the Corellian Times reporter
	("The Storm Lord" / somStormLordScreenPlay).

	The tree is in mobile/conversations/mustafar/som_storm_lord_jural.lua.
	This file only routes.

	SOE's greeting dispatch, top-down, first match wins, and what each
	condition is here. Its conditions read the quest's task names; this
	screenplay carries the same ladder as a stage number, so the mapping is
	one-to-one:

	  hasCompletedQuest("som_storm_lord")  -> done               runs > 0
	  isTaskActive "storm_lord_eight"      -> storm_lord_return  stage 8
	  isTaskActive "storm_lord_seven"      -> storm_lord_checkin stage 7
	  isTaskActive "storm_lord_six"        -> prophet_return     stage 6
	  isTaskActive "storm_lord_five"       -> prophet_checkin    stage 5
	  isTaskActive "storm_lord_four"       -> zealots_return     stage 4
	  isTaskActive "storm_lord_three"      -> zealots_checkin    stage 3
	  isTaskActive "storm_lord_two"        -> minions_return     stage 2
	  isTaskActive "storm_lord_one"        -> minions_checkin    stage 1
	  default                              -> greeting           stage 0

	The completed test sits ABOVE every task test, so a player who has run
	the ladder gets the s_62 bubble and is never re-offered the quest. The
	[list]'s allowRepeats true is not contradicted by that: it only means the
	quest system would accept a re-grant, and SOE's giver never asks for one.
	awardQuest resets stage to 0 but increments "runs", which is what makes
	the finished player distinguishable from a new one.

	SIDE EFFECTS. SOE hangs each signal on the ACCEPT of the NEXT job, not on
	the report screen before it. This file used to fire them one screen early
	and used to advance the ladder on a decline; both are corrected:

	  accept_minions     grantQuest                -- s_120, startMission
	  accept_zealots     signalMinionsDefeated     -- s_44,  sendFirstSignal
	  accept_prophet     signalZealotsDefeated     -- s_51,  sendSecondSignal
	  accept_storm_lord  signalProphetDefeated     -- s_58,  sendThirdSignal
	  payment            signalStormLordDefeated   -- s_63,  sendFourthSignal

	The declines (s_52, s_68, s_59) fire nothing at all, which is deliberate
	on SOE's part: the player stays parked on the finished wait task and can
	come back to the same report greeting and accept later. Nothing is
	advanced behind their back.

	The signals are called unconditionally, exactly as SOE calls sendSignal.
	raiseSignal already refuses any signal whose leg is not the one waiting
	(storm_lord.lua raiseSignal), so an out-of-order call does nothing.

	reportProgress on the four kill-stage check-ins is the one thing here
	that is not in SOE's script. Those screens are bubbles with no action.
	It stands in for the journal page this quest cannot have -- som_storm_lord
	has no row in the shipped quests table, so all of its journal text goes
	out as system messages, the same compensation bounty_hunts.lua and
	map_exploration.lua already make. It reads state and changes none.
--]]

storm_lord_jural_conv_handler = conv_handler:new {}

function storm_lord_jural_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somStormLordScreenPlay:getStage(pPlayer)

	-- SOE's first condition. Stage 9 is transient -- awardQuest sets it and
	-- then immediately resets to 0 -- so the finished player is the one at
	-- stage 0 with a run behind them.
	if (stage == somStormLordScreenPlay.finishedStage or (stage == 0 and somStormLordScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("done")
	elseif (stage == 8) then
		return convoTemplate:getScreen("storm_lord_return")
	elseif (stage == 7) then
		return convoTemplate:getScreen("storm_lord_checkin")
	elseif (stage == 6) then
		return convoTemplate:getScreen("prophet_return")
	elseif (stage == 5) then
		return convoTemplate:getScreen("prophet_checkin")
	elseif (stage == 4) then
		return convoTemplate:getScreen("zealots_return")
	elseif (stage == 3) then
		return convoTemplate:getScreen("zealots_checkin")
	elseif (stage == 2) then
		return convoTemplate:getScreen("minions_return")
	elseif (stage == 1) then
		return convoTemplate:getScreen("minions_checkin")
	end

	return convoTemplate:getScreen("greeting")
end

function storm_lord_jural_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- Not SOE's; the journal substitute. Read-only. See the header.
	if (screenID == "minions_checkin" or screenID == "zealots_checkin" or screenID == "prophet_checkin" or screenID == "storm_lord_checkin") then
		somStormLordScreenPlay:reportProgress(pPlayer)

	-- s_120 -> s_122. grantQuest("som_storm_lord"). grantQuest calls
	-- canGrantQuest itself and returns false rather than granting twice.
	elseif (screenID == "accept_minions") then
		somStormLordScreenPlay:grantQuest(pPlayer)

	-- s_44 -> s_66. sendSignal(player, "storm_lord_minions_defeated").
	elseif (screenID == "accept_zealots") then
		somStormLordScreenPlay:signalMinionsDefeated(pPlayer)

	-- s_51 -> s_54. sendSignal(player, "storm_lord_zealots_defeated").
	elseif (screenID == "accept_prophet") then
		somStormLordScreenPlay:signalZealotsDefeated(pPlayer)

	-- s_58 -> s_60. sendSignal(player, "storm_lord_prophet_defeated").
	elseif (screenID == "accept_storm_lord") then
		somStormLordScreenPlay:signalProphetDefeated(pPlayer)

	-- s_63 -> s_64. sendSignal(player, "storm_lord_defeated"), which is the
	-- last task and therefore what fires the Reward.
	elseif (screenID == "payment") then
		somStormLordScreenPlay:signalStormLordDefeated(pPlayer)
	end

	return pClonedScreen
end

--[[
	Q4P3 -- conversation handler for som_kenobi_collectors_business_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_q4p3.lua, which carries the note on
	how the branches were reconstructed from the shipped string table. This file only routes and
	fires the three state changes the .qst asks for: quest start, abandon, and the reward.

	All state lives in collectorsBusinessScreenPlay's persistent screenplay data on the player's
	ghost; nothing is kept here. readScreenPlayData returns "" for a key never written, which is
	why getStage does "tonumber(...) or 0".

	THE LEVEL GATE

	som_kenobi_collectors_business_1.qst's [list] block says Level 75, and the string table has a
	greeting written for exactly that case (s_122, "you seem to lack the experience to assist
	me"). So the gate is the .qst's number and the refusal is the shipped line -- neither is
	invented here.
--]]

q4p3_conv_handler = conv_handler:new {}

q4p3_conv_handler.screenPlayName = "collectorsBusinessScreenPlay"

function q4p3_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = collectorsBusinessScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < collectorsBusinessScreenPlay.requiredLevel) then
			return convoTemplate:getScreen("too_low")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == collectorsBusinessScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("turn_in")
	elseif (stage == collectorsBusinessScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("finished")
	end

	return convoTemplate:getScreen("in_progress")
end

function q4p3_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	-- Both briefings end at the same handover -- scanner, communicator, coordinates -- so both
	-- accepts start the quest.
	if (screenID == "accept_civil" or screenID == "accept_rude") then
		collectorsBusinessScreenPlay:startQuest(pPlayer)

	-- .qst has no abandon task; the strings do (s_158 / s_133). Giving up puts the player back
	-- to stage 0 so the briefing can be taken again -- the [list] block says allowRepeats true.
	elseif (screenID == "give_up" or screenID == "give_up_rude") then
		collectorsBusinessScreenPlay:abandonQuest(pPlayer)

	-- task 19 Reward, on the screen where Q4P3 actually says he is paying.
	elseif (screenID == "reward" or screenID == "reward_rude") then
		collectorsBusinessScreenPlay:awardQuest(pPlayer)
	end

	return pClonedScreen
end

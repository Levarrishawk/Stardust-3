--[[
	The mining corporation executive -- conversation handler for
	som_kenobi_moral_choice_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_moral_exec.lua, which
	carries the note on how it was reconstructed from the shipped string table.
	This file routes by quest stage, fires the grant and pays the corporation's
	reward. All state lives in moralChoiceScreenPlay's persistent screenplay data
	on the player's ghost; nothing is kept here.

	SIX OPENINGS, and every one of them shipped -- none of this routing is
	invented, the string table simply has a first line for each state:

	  s_110 greeting   never spoken to him
	  s_47  toolow     under the .qst's Level 75
	  s_139 progress   on the job and not finished
	  s_140 has_core   back with the power core
	  s_171 epilogue   paid, and done with him
	  s_45  betrayed   the player took the miners' side

	THE LEVEL GATE needs no invented text here. som_kenobi_moral_choice_1.qst's
	[list] block says Level = 75, and unlike Pwwoz Pwwa -- whose table shipped
	nothing of the kind, so his handler has to explain the refusal in a system
	message -- this executive has s_47: "I'm busy and you're too wet behind the
	ears. Come back when you've gained some experience and I may have a job for
	you." That is the whole gate.

	STAGE_UPLOAD FALLS THROUGH TO s_139 ON PURPOSE. A player who has taken the
	miners' disk but not yet uploaded it is, as far as the executive knows,
	still running his errand -- "What are you doing back here already? Get out
	there and finish the job!" is exactly right, and s_45 is held back until the
	upload actually happens.

	REFUSING is not a hook. refuse_a (s_69) and refuse_b (s_138) both end the
	conversation and change no state, so the player can hail him again. The .qst
	models no abandon and the executive has no line for taking the job back.
--]]

moral_exec_conv_handler = conv_handler:new {}

moral_exec_conv_handler.screenPlayName = "moralChoiceScreenPlay"

-- the two "let me mark it down in your datapad" screens, one per pitch chain
moral_exec_conv_handler.grantScreens = {
	grant_a = true,
	grant_b = true,
}

-- the two reward speeches, one per attitude the player took on the way back
moral_exec_conv_handler.rewardScreens = {
	reward_a = true,
	reward_b = true,
}

function moral_exec_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = moralChoiceScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < moralChoiceScreenPlay.requiredLevel) then
			return convoTemplate:getScreen("toolow")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == moralChoiceScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("has_core")
	elseif (stage == moralChoiceScreenPlay.STAGE_TELL or stage == moralChoiceScreenPlay.STAGE_DONE_MINERS) then
		return convoTemplate:getScreen("betrayed")
	elseif (stage == moralChoiceScreenPlay.STAGE_DONE_CORP) then
		return convoTemplate:getScreen("epilogue")
	end

	-- STAGE_CABLES, STAGE_CORE and STAGE_UPLOAD: s_139, "Get out there and
	-- finish the job!"
	return convoTemplate:getScreen("progress")
end

function moral_exec_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (self.grantScreens[screenID]) then
		moralChoiceScreenPlay:startQuest(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		moralChoiceScreenPlay:finishForCorporation(pPlayer)
	end

	return pClonedScreen
end

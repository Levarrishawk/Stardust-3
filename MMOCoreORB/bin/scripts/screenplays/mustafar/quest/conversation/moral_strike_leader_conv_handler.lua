--[[
	The leader of the striking miners -- conversation handler for
	som_kenobi_moral_choice_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_moral_strike_leader.lua,
	which carries the note on how it was reconstructed from the shipped string
	table. This file routes by quest stage, hands over the disk that switches the
	player's side, and pays the miners' reward. All state lives in
	moralChoiceScreenPlay's persistent screenplay data on the player's ghost;
	nothing is kept here.

	SEVEN OPENINGS across seven stages, out of five shipped opening lines:

	  s_110 ambient   no quest -- a warning to a stranger, and nothing more
	  s_140 greeting  on the executive's errand: STAGE_CABLES, STAGE_CORE and
	                  STAGE_RETURN all land here
	  s_207 progress  disk taken, not yet uploaded
	  s_208 done      uploaded, back to collect
	  s_139 moveon    the player took the corporation's reward
	  s_171 after     the miners' branch is finished

	THE TREE IS GATED BEHIND THE EXECUTIVE'S ERRAND. Every branch of it assumes
	the player was sent to sabotage -- the confession the whole conversation
	turns on is "I was sent here by that executive to sabotage" -- so a player
	with no quest gets s_110 and no options. That is not a level gate: the
	executive's own s_47 already refuses anyone under the .qst's Level 75, so
	nobody can reach this conversation's tree under-levelled.

	STAGE_RETURN STILL GETS THE FULL TREE, deliberately. In the .qst the
	talkedLeader signal (task 10) is a sibling of the sabotage chain under root
	task 1, not a child of it, so nothing orders them -- a player holding the
	stolen power core can still walk over and switch sides, and the leader has
	no way of knowing the core is already gone. moralChoiceScreenPlay:switchSides
	is what closes the corporation's half.

	WALKING AWAY changes no state at any of the five exits the table gives
	(s_181/s_183, s_188/s_190, s_300/s_302, s_196/s_197, s_296/s_298), so a
	player who backed out can hail him again and start over.
--]]

moral_strike_leader_conv_handler = conv_handler:new {}

moral_strike_leader_conv_handler.screenPlayName = "moralChoiceScreenPlay"

-- "Good, here's the disk." -- the .qst's talkedLeader signal, once per half.
moral_strike_leader_conv_handler.switchScreens = {
	p1_disk = true,
	p2_disk = true,
}

-- "we all chipped in" -- the .qst's talkedLeader2 signal and task 13's reward.
moral_strike_leader_conv_handler.rewardScreens = {
	reward = true,
}

function moral_strike_leader_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = moralChoiceScreenPlay:getStage(pPlayer)

	if (stage == moralChoiceScreenPlay.STAGE_UPLOAD) then
		return convoTemplate:getScreen("progress")
	elseif (stage == moralChoiceScreenPlay.STAGE_TELL) then
		return convoTemplate:getScreen("done")
	elseif (stage == moralChoiceScreenPlay.STAGE_DONE_CORP) then
		return convoTemplate:getScreen("moveon")
	elseif (stage == moralChoiceScreenPlay.STAGE_DONE_MINERS) then
		return convoTemplate:getScreen("after")
	elseif (stage == moralChoiceScreenPlay.STAGE_CABLES or stage == moralChoiceScreenPlay.STAGE_CORE
		or stage == moralChoiceScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("greeting")
	end

	-- no quest: s_110, "Be careful around here, friend."
	return convoTemplate:getScreen("ambient")
end

function moral_strike_leader_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (self.switchScreens[screenID]) then
		moralChoiceScreenPlay:switchSides(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		moralChoiceScreenPlay:finishForMiners(pPlayer)
	end

	return pClonedScreen
end

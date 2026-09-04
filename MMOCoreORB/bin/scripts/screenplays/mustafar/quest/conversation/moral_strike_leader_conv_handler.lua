--[[
	The leader of the striking miners -- conversation handler for
	som_kenobi_moral_choice_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_moral_strike_leader.lua,
	which carries the string-table provenance and the correction the live tree
	forced on the four standing lines. This file routes by quest stage, plays the
	animations, switches the player's side and pays the miners' reward. All state
	lives in moralChoiceScreenPlay's persistent screenplay data on the player's
	ghost; nothing is kept here.

	SIX OPENINGS, IN LIVE'S ORDER. One flag each, first match wins:

	  hasCompletedQuest           -> s_171 after     DONE_CORP and DONE_MINERS
	  isTaskActive talkLeader2    -> s_208 done      STAGE_TELL
	  isTaskActive switchedSides  -> s_207 progress  STAGE_UPLOAD
	  isTaskActive needDestroy    -> s_140 greeting  STAGE_CABLES
	  isQuestActive               -> s_139 moveon    STAGE_CORE, STAGE_RETURN
	  default                     -> s_110 ambient   no quest

	Live also defines a haveCore condition, isTaskActive gotCore, and never uses
	it in the start chain. The player carrying the stolen core is caught by
	isQuestActive along with everyone else, which is why STAGE_CORE and
	STAGE_RETURN share one line.

	THE TREE IS GATED BEHIND THE SABOTAGE TASK, NOT THE QUEST. This file used to
	send STAGE_CABLES, STAGE_CORE and STAGE_RETURN all to s_140 and call
	STAGE_RETURN's inclusion deliberate. Live offers the tree at STAGE_CABLES
	alone: needDestroy is the flag, and tearing out the cables clears it. From
	then on branch A is one-way as far as the leader is concerned, and
	moralChoiceScreenPlay:switchSides is only ever reached from STAGE_CABLES --
	see WHAT THE .QST PERMITS IS NOT WHAT THE LEADER OFFERS in moral_choice.lua
	for the root cause and why its other two arms stay.

	Every branch of the tree assumes the player was sent to sabotage -- the
	confession it all turns on is "I was sent here by that executive to
	sabotage" -- so a player with no quest gets s_110 and no options. That is not
	a level gate: the executive's own s_47 already refuses anyone under Level 61,
	the number his server-side conversation tests rather than the .qst's display
	value of 75, so nobody reaches this tree under-levelled.

	WHERE THE HOOKS SIT -- both switches moved one screen later

	switchSides fires on p1_careful (s_206) and p2_careful (s_288), not on the
	disk screens. s_204 and s_284 hand the disk over in the text and carry no
	action in live; the signal goes on "I look forward to it. Be careful of
	guards on the executive's payroll", which is where the exchange actually
	ends. Same mistake, same place, as Ikt's turn-in and Dr. Lu's payout: screen
	text describing a handover is not the handover.

	Live fires a second action on s_206 and not on s_288 -- failTask needDestroy,
	clearing the sabotage task outright. Recorded as observed, not reproduced: it
	is redundant here because switchSides moves the stage to STAGE_UPLOAD, which
	already leaves the cables behind, and both halves are only ever reached from
	the same STAGE_CABLES state. Whatever it is on live's side, it cannot be a
	difference between the halves the player can see.

	The reward hook was already right: live fires talkedLeader2 on reward
	(s_210), and so does this file.

	WALKING AWAY changes no state at any of the five exits the table gives
	(s_181/s_183, s_188/s_190, s_300/s_302, s_196/s_197, s_296/s_298), so a
	player who backed out can hail him again and start over. Checked against
	live, not assumed -- none of those five carries an action.

	THE ANIMATIONS -- these were missing entirely

	Live fires 40, across 21 of the 32 screens. Two screens have two inbound
	edges -- p1_confess (s_198) is reached from s_192 and s_195, p2_confess
	(s_272) from s_270 and s_294 -- and both inbound edges play the same gesture
	in each case, so keying by destination still cannot produce a disagreement.
	All six root screens except progress carry one; runScreenHandlers runs on the
	initial screen as well, so they sit in the same table as the rest rather than
	in getInitialScreen.

	Eleven screens get nothing, and they cluster: the entire opening of the
	second half (p2_notmuch, p2_strike, p2_why), both "why do you ask" answers
	(p1_curious, p2_curious), both offers (p1_offer, p2_offer), p1_why, and
	progress. That is live, not an omission.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no wiring, no actions, no
	gestures.
--]]

moral_strike_leader_conv_handler = conv_handler:new {}

moral_strike_leader_conv_handler.screenPlayName = "moralChoiceScreenPlay"

-- "Be careful of guards on the executive's payroll" -- the .qst's talkedLeader
-- signal, once per half. s_206 and s_288, not the disk screens above them.
-- See WHERE THE HOOKS SIT.
moral_strike_leader_conv_handler.switchScreens = {
	p1_careful = true,
	p2_careful = true,
}

-- "we all chipped in" -- the .qst's talkedLeader2 signal and task 13's reward.
moral_strike_leader_conv_handler.rewardScreens = {
	reward = true,
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays
-- them. See THE ANIMATIONS for why keying by destination is safe here.
moral_strike_leader_conv_handler.screenAnimations = {
	-- the six openings; progress carries none
	after      = { { "npc", "dismiss" } },
	done       = { { "npc", "greet" }, { "player", "greet" } },
	greeting   = { { "npc", "nod_head_once" }, { "player", "greet" } },
	moveon     = { { "npc", "point_accusingly" } },
	ambient    = { { "npc", "point_forward" }, { "player", "greet" } },

	-- the payoff
	reward     = { { "npc", "nod" } },
	farewell   = { { "player", "thank" }, { "npc", "thank" } },

	-- half one
	p1_strike   = { { "player", "shrug_hands" }, { "npc", "shake_head_no" } },
	p1_goodluck = { { "player", "nod" }, { "npc", "goodbye" } },
	p1_proof    = { { "npc", "rub_chin_thoughtful" } },
	p1_bye      = { { "player", "rub_chin_thoughtful" }, { "npc", "goodbye" } },
	p1_confess  = { { "npc", "stamp_feet" } },
	p1_takecare = { { "player", "nod" }, { "npc", "goodbye" }, { "player", "goodbye" } },
	p1_plan     = { { "player", "nod" } },
	p1_disk     = { { "npc", "nod" } },
	p1_careful  = { { "npc", "goodbye" }, { "player", "goodbye" } },

	-- half two
	p2_proof    = { { "npc", "rub_chin_thoughtful" } },
	p2_bye      = { { "player", "rub_chin_thoughtful" }, { "npc", "goodbye" } },
	p2_confess  = { { "npc", "stamp_feet" } },
	p2_takecare = { { "player", "nod" }, { "npc", "goodbye" }, { "player", "goodbye" } },
	p2_plan     = { { "player", "nod" } },
	p2_disk     = { { "npc", "nod" } },
	p2_careful  = { { "npc", "goodbye" }, { "player", "goodbye" } },

	-- progress (s_207), p1_why (s_185), p1_curious (s_194), p1_offer (s_200),
	-- p2_notmuch (s_214), p2_strike (s_261), p2_why (s_264), p2_curious (s_292)
	-- and p2_offer (s_276) carry none, in live too.
}

function moral_strike_leader_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = moralChoiceScreenPlay:getStage(pPlayer)

	-- Live's order. See SIX OPENINGS, IN LIVE'S ORDER -- completion is tested
	-- first, and both endings share s_171.
	if (stage == moralChoiceScreenPlay.STAGE_DONE_CORP or stage == moralChoiceScreenPlay.STAGE_DONE_MINERS) then
		return convoTemplate:getScreen("after")
	elseif (stage == moralChoiceScreenPlay.STAGE_TELL) then
		return convoTemplate:getScreen("done")
	elseif (stage == moralChoiceScreenPlay.STAGE_UPLOAD) then
		return convoTemplate:getScreen("progress")
	elseif (stage == moralChoiceScreenPlay.STAGE_CABLES) then
		-- the only stage that is offered the tree; see THE TREE IS GATED
		-- BEHIND THE SABOTAGE TASK, NOT THE QUEST.
		return convoTemplate:getScreen("greeting")
	elseif (stage ~= 0) then
		-- STAGE_CORE and STAGE_RETURN: s_139, "You should move along..."
		return convoTemplate:getScreen("moveon")
	end

	-- no quest: s_110, "Be careful around here, friend."
	return convoTemplate:getScreen("ambient")
end

function moral_strike_leader_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (self.switchScreens[screenID]) then
		moralChoiceScreenPlay:switchSides(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		moralChoiceScreenPlay:finishForMiners(pPlayer)
	end

	return pClonedScreen
end

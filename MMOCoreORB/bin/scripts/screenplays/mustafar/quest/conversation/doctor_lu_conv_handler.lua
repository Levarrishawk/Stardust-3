--[[
	Dr. Mi Fon Lu -- conversation handler for "An Archeologist's Problem".

	The tree is in mobile/conversations/mustafar/som_doctor_lu.lua, which carries the
	string-table provenance, the speaker-assignment argument, and the two corrections
	the live tree forced. This file picks the root, plays the animations and fires the
	four actions.

	State is not kept here. somBlackguardProblemScreenPlay owns it; getStage is read on
	every entry so a conversation left open across a stage change cannot fire a stale
	signal. Each signal is re-checked against the stage that accepts it, which makes the
	guard belt-and-braces -- the screenplay already returns false at the wrong stage.

	THE ROOT, IN LIVE'S ORDER

	  quest won   -> s_46  already_helped     hasWonMission
	  stage 6     -> s_43  singed             hasWonThirdTask
	  stage 5     -> s_10  sansii_checkin     isOnThirdTask
	  stage 4     -> s_14  waiting_news       hasWonSecondTask
	  stage 3     -> s_20  business_checkin   isOnSecondTask
	  stage 2     -> s_24  ruins_return       hasWonFirstTask
	  stage 1     -> s_60  ruins_checkin      isOnFirstTask
	  default     -> s_66  greeting           _defaultCondition

	Live's six task conditions are isTaskActive on blackguard_problem_one through
	_six, in that order, which is exactly this screenplay's stages 1 through 6. The
	order is written live's way so the two read against each other.

	The first line is new. It was missing because the tree declared s_46 unplaceable;
	see CORRECTING s_46 in the tree for the root cause. awardQuest sets finishedStage
	and then immediately resets to 0, so the finished player is the one sitting at
	stage 0 with a run behind them -- the same test storm_lord_jural_conv_handler
	makes for the same reason.

	Because live checks it FIRST, a player who has finished once never sees s_66
	again and can never be re-granted through Dr. Lu. He is the only giver, so the
	.qst's allowRepeats never fires. That is live, not a gap to paper over.

	WHERE THE HOOKS SIT -- the payout moved one screen later

	signalSansiiDefeated fires on thanks_again (s_50), not on reward (s_48). s_48
	carries no action in live at all. See CORRECTING THE PAYOUT in the tree.

	The other three are unchanged and were already right: grantQuest on wish_well
	(s_94), signalMinionsDefeated on wait_here (s_58), signalVanskDefeated on
	wait_for_sansii (s_42).

	THE PROGRESS LINE -- not SOE's

	reportProgress on the three kill-stage check-ins is the one thing here that is
	not in the live script; those screens carry no action. It stands in for the
	journal page this quest cannot have -- see NO JOURNAL in blackguard_problem.lua
	-- and is the same compensation storm_lord_jural_conv_handler already makes on
	its four check-ins. It reads state and changes none.

	Until now somBlackguardProblemScreenPlay:reportProgress had no caller anywhere
	in the tree; its own header described it as something "a giver can use", written
	when this quest was believed to have no giver.

	THE ANIMATIONS -- these were missing entirely

	Live fires 33, across 25 of the 28 screens. Every screen in this tree is reached
	exactly one way -- no screen has two inbound edges -- so keying by destination
	cannot produce a disagreement. All eight root screens carry one except
	waiting_news; runScreenHandlers runs on the initial screen as well, so they sit
	in the same table as the rest rather than in getInitialScreen.

	Three screens get nothing: waiting_news (s_14), still_waiting (s_38) and
	take_care (s_64). That is live, not an omission.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no wiring, no actions, no
	gestures.
--]]

doctor_lu_conv_handler = conv_handler:new {}

-- The three kill-stage check-ins. Read-only; see THE PROGRESS LINE.
doctor_lu_conv_handler.checkinScreens = {
	ruins_checkin = true,     -- s_60, stage 1
	business_checkin = true,  -- s_20, stage 3
	sansii_checkin = true,    -- s_10, stage 5
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why keying by destination is safe in this tree.
doctor_lu_conv_handler.screenAnimations = {
	-- the eight roots
	already_helped   = { { "npc", "bounce" } },
	singed           = { { "npc", "wave1" } },
	sansii_checkin   = { { "npc", "nervous" } },
	business_checkin = { { "npc", "twitch" } },
	ruins_return     = { { "npc", "bounce" } },
	ruins_checkin    = { { "npc", "greet" } },
	greeting         = { { "npc", "stop" } },

	-- first meeting, s_66 through s_98
	why_blackguard   = { { "npc", "shake_head_disgust" } },
	archaeologist    = { { "player", "point_forward" }, { "npc", "bow2" } },
	who_is_narl      = { { "npc", "rub_chin_thoughtful" } },
	why_narl         = { { "npc", "explain" } },
	blackguard_study = { { "npc", "gesticulate_wildly" } },
	perhaps_help     = { { "npc", "huh" } },
	wish_well        = { { "player", "pose_proudly" }, { "npc", "goodbye" } },
	decline          = { { "npc", "nod_head_multiple" } },

	-- stage 2, the minions report
	what_do_you_mean = { { "npc", "huh" } },
	efforts_wasted   = { { "player", "slit_throat" }, { "npc", "wtf" } },
	vansk_and_sansii = { { "npc", "explain" } },
	what_will_you_do = { { "npc", "nervous" } },
	wait_here        = { { "player", "wave_finger_warning" }, { "npc", "point_down" } },

	-- stage 4, the Vansk report
	ask_sansii       = { { "npc", "nervous" } },
	wait_for_sansii  = { { "npc", "nod_head_multiple" } },

	-- stage 5, the San'sii check-in
	ruins_wonders    = { { "player", "shake_head_no" }, { "npc", "rub_chin_thoughtful" } },

	-- stage 6, the turn-in
	reward           = { { "player", "nod" }, { "npc", "celebrate" } },
	thanks_again     = { { "npc", "offer_affection" }, { "player", "refuse_offer_affection" } },

	-- waiting_news (s_14), still_waiting (s_38) and take_care (s_64) carry none,
	-- in live too.
}

function doctor_lu_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somBlackguardProblemScreenPlay:getStage(pPlayer)

	-- Live's order. See THE ROOT, IN LIVE'S ORDER.
	if (stage == somBlackguardProblemScreenPlay.finishedStage or (stage == 0 and somBlackguardProblemScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("already_helped")
	elseif (stage == 6) then
		return convoTemplate:getScreen("singed")
	elseif (stage == 5) then
		return convoTemplate:getScreen("sansii_checkin")
	elseif (stage == 4) then
		return convoTemplate:getScreen("waiting_news")
	elseif (stage == 3) then
		return convoTemplate:getScreen("business_checkin")
	elseif (stage == 2) then
		return convoTemplate:getScreen("ruins_return")
	elseif (stage == 1) then
		return convoTemplate:getScreen("ruins_checkin")
	end

	return convoTemplate:getScreen("greeting")
end

function doctor_lu_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local stage = somBlackguardProblemScreenPlay:getStage(pPlayer)

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (screenID == "wish_well") then
		if (somBlackguardProblemScreenPlay:canGrantQuest(pPlayer)) then
			somBlackguardProblemScreenPlay:grantQuest(pPlayer)
		end
	elseif (screenID == "wait_here") then
		if (stage == 2) then
			somBlackguardProblemScreenPlay:signalMinionsDefeated(pPlayer)
		end
	elseif (screenID == "wait_for_sansii") then
		if (stage == 4) then
			somBlackguardProblemScreenPlay:signalVanskDefeated(pPlayer)
		end

	-- s_50, not s_48. See WHERE THE HOOKS SIT.
	elseif (screenID == "thanks_again") then
		if (stage == 6) then
			somBlackguardProblemScreenPlay:signalSansiiDefeated(pPlayer)
		end

	-- Not SOE's; the journal substitute. Read-only. See THE PROGRESS LINE.
	elseif (self.checkinScreens[screenID]) then
		somBlackguardProblemScreenPlay:reportProgress(pPlayer)
	end

	return pClonedScreen
end

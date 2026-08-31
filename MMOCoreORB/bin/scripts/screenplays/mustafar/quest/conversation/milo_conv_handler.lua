--[[
	scripts/screenplays/mustafar/quest/conversation/milo_conv_handler.lua

	Dispatch for story_arc_chapter_one_milo -- Milo Mensix, the anchor of the
	whole Mustafar story arc.  Runs on storyArcChaptersScreenPlay.

	SOE tests FIFTEEN conditions in OnStartNpcConversation, first match wins, and
	the order below is theirs, unchanged.  Order is the whole design here: several
	of these overlap, and the earlier one is meant to win.  Live's condition, then
	the repo stage that stands for it:

	   1 hasWonStoryArc            ch3_03 complete       == STAGE_DONE
	   2 messageWaiting            ch3_03/volcano_five   == STAGE_CHECK_MESSAGE
	   3 hasDefeatedHK             ch3_03/volcano_four   == STAGE_REPORT_SUCCESS
	   4 isFightingHK              ch3_03 active         FIND_PILOT..KILL_HK47
	   5 hasWonFactory             ch3_01/milo_report    == STAGE_REPORT_MILO
	   6 isFightingDroids          ch3_01 active         DROID_ARMY..SHUTDOWN_FACTORY
	   7 hk47IsAlive               ch2_01/factory_five   == STAGE_WARN_MILO
	   8 hasCompletedFourthMission ch2_01 complete       -- unreachable, see below
	   9 isOnSecondMission         ch2_01 active         FIND_FACTORY..RETURN_ORF
	  10 hasCompletedThirdMission  ch1_03 complete       -- unreachable, see below
	  11 hasCompletedSecondMission ch1_02 complete       STAGE_UPLINK..DELTA_FIVE
	  12 hasCompletedFirstMission  ch1_01 complete       SALVAGE_BOARDS..ACTIVATE
	  13 isOnFirstMission          ch1_01/02/03 active   TRAVEL_WRECK, FIND_TERMINAL
	  14 hasCompletedPrelude       prelude_03 complete   STAGE_NONE + prelude done
	  15 default                                         everything else

	WHY 8 AND 10 CANNOT FIRE, and why they are written anyway.  Both are SOE's own
	ordering, not a hole in the port:

	  #8 wants "finished chapter two 01".  But finishing chapter two 01 is what
	  puts the player into the factory tasks that #5, #6 and #7 read, so one of
	  those three always catches them first.

	  #10 wants "finished chapter one 03".  completeChapterOne grants chapter two
	  01 in the same breath as finishing chapter one 03, so #9 always catches them
	  first.

	They are kept in position with their real screens.  The strings ship, and a
	future stage change could open them.  Deleting them would quietly lose SOE's
	structure; the same treatment chapter two's hasCompleteChapterOne got.

	CHECKFORERROR IS A DOCUMENTED NO-OP.  It fires at six places: the greeting of
	#7, and the five options s_81, s_97, s_127, s_130 and s_133.  Live's body is
	"if chapter one 01 is still active, complete it" -- a repair for a journal
	left showing a mission that was already done.  The repo holds progress as ONE
	stage integer, so there is no second copy of the state that can drift out of
	step, and nothing for that repair to catch.  It is still called at all six of
	SOE's sites so the shape stays visible;
	storyArcChaptersScreenPlay:checkForError carries the reasoning.

	THE REPO HAS NO SIGNAL BUS.  grantFinalChapter, startVolcanoQuest and
	grantFinalReward each open with a sendSignal -- mustafar_factory_finish,
	mustafar_droidfactory_victory, hk_story_arc_completed.  Those are live's
	cross-script wake-ups.  Here the screenplay advances its own stage, which is
	what the signals were for.  Said plainly, not papered over.

	NO LEVEL GATE, AND THAT IS THE CORRECTION.  The retired offerArc refused the
	arc below storyArcChaptersScreenPlay.requiredLevel (80).  Live's Milo has no
	level test at all -- his fifteen conditions are pure quest state.  The 80 is
	the "Level" row of the seven .qst files, which is the level the journal
	DISPLAYS, not an entry requirement.  The gate was a repo invention from the
	period when Milo was a radial with an SUI box and something had to stand in
	for a giver.  It is gone; requiredLevel stays declared because the value is
	real evidence worth keeping.
--]]

milo_conv_handler = conv_handler:new {}
milo_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function milo_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	-- 1 hasWonStoryArc.
	if (stage >= storyArcChaptersScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("all_safe")
	end

	-- 2 messageWaiting. The encoded message is still sitting on the console.
	if (stage == storyArcChaptersScreenPlay.STAGE_CHECK_MESSAGE) then
		return convoTemplate:getScreen("message_waiting")
	end

	-- 3 hasDefeatedHK. ACTION grantFinalReward waits on the option.
	if (stage == storyArcChaptersScreenPlay.STAGE_REPORT_SUCCESS) then
		return convoTemplate:getScreen("signal_stopped")
	end

	-- 4 isFightingHK.
	if (stage >= storyArcChaptersScreenPlay.STAGE_FIND_PILOT) then
		return convoTemplate:getScreen("hk_still_active")
	end

	-- 5 hasWonFactory. ACTION startVolcanoQuest waits three options in.
	if (stage == storyArcChaptersScreenPlay.STAGE_REPORT_MILO) then
		return convoTemplate:getScreen("army_gone")
	end

	-- 6 isFightingDroids.
	if (stage >= storyArcChaptersScreenPlay.STAGE_DROID_ARMY) then
		return convoTemplate:getScreen("droids_active")
	end

	-- 7 hk47IsAlive. The confession branch, and the only greeting carrying an
	-- action. ACTION checkForError.
	if (stage == storyArcChaptersScreenPlay.STAGE_WARN_MILO) then
		storyArcChaptersScreenPlay:checkForError(pPlayer)
		return convoTemplate:getScreen("worried")
	end

	-- 8 hasCompletedFourthMission. Unreachable -- see the header.
	if (stage > storyArcChaptersScreenPlay.STAGE_RETURN_ORF) then
		return convoTemplate:getScreen("discovered_yet")
	end

	-- 9 isOnSecondMission.
	if (stage >= storyArcChaptersScreenPlay.STAGE_FIND_FACTORY) then
		return convoTemplate:getScreen("productivity")
	end

	-- 10 hasCompletedThirdMission. Unreachable -- see the header.
	if (stage > storyArcChaptersScreenPlay.STAGE_DELTA_FIVE) then
		return convoTemplate:getScreen("back_to_work")
	end

	-- 11 hasCompletedSecondMission.
	if (stage >= storyArcChaptersScreenPlay.STAGE_UPLINK) then
		return convoTemplate:getScreen("follow_leads")
	end

	-- 12 hasCompletedFirstMission.
	if (stage >= storyArcChaptersScreenPlay.STAGE_SALVAGE_BOARDS) then
		return convoTemplate:getScreen("no_more_help")
	end

	-- 13 isOnFirstMission.
	if (stage >= storyArcChaptersScreenPlay.STAGE_TRAVEL_WRECK) then
		return convoTemplate:getScreen("how_is_search")
	end

	-- 14 hasCompletedPrelude. The offer. ACTION grantFirstMission waits eleven
	-- options in, at s_92.
	if (storyArcChaptersScreenPlay:isPreludeComplete(pPlayer)) then
		return convoTemplate:getScreen("welcome")
	end

	-- 15 default. Go and see Foreman Chivos first.
	return convoTemplate:getScreen("see_chivos")
end

function milo_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	-- ACTION grantFirstMission. s_92 -> s_103. The arc starts here.
	if (screenID == "i_will_help") then
		storyArcChaptersScreenPlay:grantFirstMission(pPlayer)

	-- ACTION grantFinalChapter. s_87 -> s_90. Opens chapter three and sends the
	-- player to the scout.
	elseif (screenID == "clean_it_up") then
		storyArcChaptersScreenPlay:grantFinalChapter(pPlayer)

	-- ACTION startVolcanoQuest. s_112 -> s_113. Sends the player to find a pilot.
	elseif (screenID == "need_a_pilot") then
		storyArcChaptersScreenPlay:startVolcanoQuest(pPlayer)

	-- ACTION grantFinalReward. s_115 -> s_116. The last action in the arc.
	elseif (screenID == "factory_owner") then
		storyArcChaptersScreenPlay:grantFinalReward(pPlayer)

	-- ACTION checkForError. The five option sites; the sixth is the greeting of
	-- condition 7, fired in getInitialScreen above.
	elseif (screenID == "what_worse" or screenID == "crater_signal" or
		screenID == "will_do" or screenID == "if_you_say_so" or
		screenID == "working_on_it") then
		storyArcChaptersScreenPlay:checkForError(pPlayer)
	end

	return pClonedScreen
end

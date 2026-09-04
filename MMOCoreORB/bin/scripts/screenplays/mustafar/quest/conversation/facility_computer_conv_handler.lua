--[[
	The Old Republic Facility's Terminal Delta Five -- conversation handler for
	conversation/story_arc_chapter_two_computer (storyArcChaptersScreenPlay).

	Same AI as the crashed cruiser, one building later.  The tree is in
	mobile/conversations/mustafar/story_arc_chapter_two_computer.lua and carries
	the live spawn row, the AiAgent-carrier DEVIATION, the bark deviation and the
	full evidence.  This file only routes and fires.

	SOE's greeting dispatch, in order, first match wins, against repo stages:

	  isNotFinalStep         building "status" < 11   see below           s_79
	  completedTransfer      factory_three done, or
	                         chapter two 01 complete  >= WARN_MILO        s_19
	  factoryIsRepaired      factory_three active     == RETURN_ORF       s_16
	  isFixingFactory        factory_one or _two
	                         active                   == FIND_FACTORY or
	                                                     REPAIR_FACTORY   s_15
	  hasCompleteChapterOne  chapter one 03 complete  -- see below        s_51
	  isReadyForChapTwo      uplink_four active       == DELTA_FIVE       s_25
	  default                                         TRAVEL_ORF,
	                                                  ORF_POWER           s_72

	Verified against the java's OnStartNpcConversation, condition block and both
	handleBranch call sites; the order below is SOE's order, not a tidy-up.

	NO ACTION FIRES ON A GREETING HERE.  That is the opposite of the cruiser,
	where four of five did.  Both of this tree's live actions sit on the last
	option of a chain, so they run out of runScreenHandlers.

	isNotFinalStep IS NOT A QUEST TEST -- it reads "status" off the building, and
	that objvar belongs to the eight-object mustafar_trials puzzle this repo does
	not implement.  DEVIATION: the per-player stage stands in for it, split so
	that both of live's dead screens keep a distinct trigger.  Splitting it was
	deliberate: folding both into one test would have made s_72 -- the tree's own
	initialScreen -- unreachable, silently killing a shipped screen.  One repo
	axis standing in for two live axes, said plainly.

	hasCompleteChapterOne is written in SOE's position and is unreachable, and
	SOE's own ordering is why: completeChapterOne grants chapter two 01 in the
	same breath as finishing chapter one 03, so every stage it could catch is
	already swallowed by the three conditions tested ahead of it.  Left in with
	the faithful action because the strings ship and the screens exist -- the
	same honest treatment as the cruiser's abandonedFirstMission.

	THE REPO HAS NO SIGNAL BUS.  storyArcChaptersScreenPlay's SIGNAL_* constants
	record what each .qst task listens for; nothing consumes them.  Progress is
	one stage integer, so each grant becomes the advance that the step it opens
	was already driving:

	  grant som_story_arc_chapter_two_01  -> STAGE_FIND_FACTORY

	mustafar_uplink_finish gets no advance of its own; it closes chapter one 03,
	and in the repo that closure and the chapter two 01 grant are the same edge.
--]]

facility_computer_conv_handler = conv_handler:new {}
facility_computer_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function facility_computer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	-- isNotFinalStep. The facility is not the player's business yet. On live this
	-- terminal is not even conversable at this point -- the radial offers an SUI
	-- box instead -- and the line is a chat.chat bark, not a window.
	if (stage < storyArcChaptersScreenPlay.STAGE_TRAVEL_ORF) then
		return convoTemplate:getScreen("offline_bark")
	end

	-- completedTransfer. The AI has moved into the droid factory.
	if (stage >= storyArcChaptersScreenPlay.STAGE_WARN_MILO) then
		return convoTemplate:getScreen("transferred")
	end

	-- factoryIsRepaired. The factory runs and the AI is halfway out the door.
	if (stage == storyArcChaptersScreenPlay.STAGE_RETURN_ORF) then
		return convoTemplate:getScreen("well_done")
	end

	-- isFixingFactory. Sent to the factory and back here without doing it.
	if (stage == storyArcChaptersScreenPlay.STAGE_FIND_FACTORY or
		stage == storyArcChaptersScreenPlay.STAGE_REPAIR_FACTORY) then
		return convoTemplate:getScreen("you_lied")
	end

	-- hasCompleteChapterOne. Unreachable -- see the header. The condition is
	-- SOE's own, written literally, and its unreachability is structural: every
	-- stage at or past STAGE_FIND_FACTORY is caught by one of the three tests
	-- above. Kept in position rather than deleted or faked.
	if (stage >= storyArcChaptersScreenPlay.STAGE_FIND_FACTORY) then
		return convoTemplate:getScreen("troublesome")
	end

	-- isReadyForChapTwo. Power is on and the AI is awake. This is the arrival.
	if (stage == storyArcChaptersScreenPlay.STAGE_DELTA_FIVE) then
		return convoTemplate:getScreen("arrived")
	end

	-- default. Reached the facility, power not yet restored.
	return convoTemplate:getScreen("functional_offline")
end

function facility_computer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	-- ACTION completeChapterOne, java:511. Signal, grant and badge.
	if (screenID == "to_the_south") then
		storyArcChaptersScreenPlay:completeChapterOne(pPlayer)

	-- ACTION grantMission, java:192. The grant alone -- no signal, no badge.
	-- On the nag branch, so unreachable today; wired anyway.
	elseif (screenID == "turn_it_on") then
		storyArcChaptersScreenPlay:grantChapterTwo(pPlayer)
	end

	return pClonedScreen
end

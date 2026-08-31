--[[
	The crashed Old Republic cruiser's AI -- conversation handler for
	conversation/story_arc_chapter_one_computer (storyArcChaptersScreenPlay).

	The tree is in mobile/conversations/mustafar/story_arc_chapter_one_computer.lua
	and carries the evidence, the full dispatch table and the AiAgent-carrier
	DEVIATION.  This file only routes and fires.

	SOE's greeting dispatch, in order, first match wins, against repo stages:

	  hasCompletedMission     ch1_03 complete       stage > DELTA_FIVE   silent
	  hasCompletedFirstTask   uplink_one complete   == UPLINK_REPORT     transferred
	  isOnFirstTask           uplink_one active     == UPLINK            uplink_reminder
	  isOnStoryArc            ch1_02 done, or
	                          motor_four active     == ACTIVATE_COMPUTER,
	                                                or TRAVEL_ORF..DELTA_FIVE
	                                                                     awake
	  abandonedFirstMission   ch1_01 done, ch1_02
	                          not active            -- see below         no_boards
	  ChapOneFirstStep        orc_two active        == FIND_TERMINAL     dead_terminal
	  default                                       everything else     offline

	FOUR OF THE FIVE ACTIONS FIRE ON THE GREETING.  That is SOE's placement, not a
	convenience here -- the player has not picked anything yet when they run:

	  greeting transferred     sendTransferSignal   mustafar_uplink_make_transfer
	  greeting awake           startedComputerTalk  access_computer_fixed
	  greeting no_boards       regrantMission       grant chapter one 02
	  greeting dead_terminal   fixTerminal          mustafar_orc_complete
	                                                + grant chapter one 02
	  option   blasted         makeUpLink           grant chapter one 03

	The screen is picked before the action fires, so the player still reads the
	line that belongs to the stage he walked up in.

	THE REPO HAS NO SIGNAL BUS.  storyArcChaptersScreenPlay's SIGNAL_* constants
	are a written record of what each .qst task listens for; nothing consumes them.
	Progress is one stage integer, so each SOE signal-or-grant becomes the advance
	that the step it closes was already driving:

	  mustafar_uplink_make_transfer  -> STAGE_TRAVEL_ORF
	  grant chapter one 02           -> STAGE_SALVAGE_BOARDS
	  grant chapter one 03           -> STAGE_UPLINK

	access_computer_fixed gets NO advance of its own, and that is deliberate.  It
	closes chapter one 02 task 6, and in the repo that closure and the chapter one
	03 grant are the same edge -- STAGE_ACTIVATE_COMPUTER -> STAGE_UPLINK, which
	makeUpLink performs at the end of the briefing.  Advancing on the greeting as
	well would skip the fourteen screens the player is standing there to hear.
	Folded on purpose; this note is why.
--]]

cruiser_computer_conv_handler = conv_handler:new {}
cruiser_computer_conv_handler.screenPlayName = "storyArcChaptersScreenPlay"

function cruiser_computer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcChaptersScreenPlay:getStage(pPlayer)

	-- hasCompletedMission. The AI has already gone; nobody is home.
	if (stage > storyArcChaptersScreenPlay.STAGE_DELTA_FIVE) then
		return convoTemplate:getScreen("silent")
	end

	-- hasCompletedFirstTask. ACTION sendTransferSignal.
	if (stage == storyArcChaptersScreenPlay.STAGE_UPLINK_REPORT) then
		storyArcChaptersScreenPlay:advance(pPlayer, storyArcChaptersScreenPlay.STAGE_TRAVEL_ORF)
		return convoTemplate:getScreen("transferred")
	end

	-- isOnFirstTask. Still out at the cavern; the AI nags.
	if (stage == storyArcChaptersScreenPlay.STAGE_UPLINK) then
		return convoTemplate:getScreen("uplink_reminder")
	end

	-- isOnStoryArc. ACTION startedComputerTalk -- folded into makeUpLink, see the
	-- header. The TRAVEL_ORF..DELTA_FIVE half is not a slip: those stages pass
	-- "chapter one 02 complete" and no earlier condition catches them, so on live
	-- the player really could walk back and re-hear the briefing. makeUpLink is
	-- guarded so a re-hear cannot walk him backwards.
	if (stage == storyArcChaptersScreenPlay.STAGE_ACTIVATE_COMPUTER or
		(stage >= storyArcChaptersScreenPlay.STAGE_TRAVEL_ORF and stage <= storyArcChaptersScreenPlay.STAGE_DELTA_FIVE)) then
		return convoTemplate:getScreen("awake")
	end

	-- abandonedFirstMission. ACTION regrantMission. SOE's recovery for a player
	-- who dropped chapter one 02 out of the journal. The repo tracks progress with
	-- a stage integer that cannot be dropped, so NOTHING WRITES THIS FLAG and this
	-- branch is unreachable today. It is kept in SOE's position with the faithful
	-- effect because the strings ship and the screen exists: if a stage model ever
	-- gains an abandon, setting "abandonedChapterOne" is the entire wiring.
	if (storyArcChaptersScreenPlay:hasFlag(pPlayer, "abandonedChapterOne")) then
		storyArcChaptersScreenPlay:advance(pPlayer, storyArcChaptersScreenPlay.STAGE_SALVAGE_BOARDS)
		return convoTemplate:getScreen("no_boards")
	end

	-- ChapOneFirstStep. ACTION fixTerminal -- finding the bridge terminal IS the
	-- step, so walking up to it closes chapter one 01 and opens chapter one 02.
	if (stage == storyArcChaptersScreenPlay.STAGE_FIND_TERMINAL) then
		storyArcChaptersScreenPlay:advance(pPlayer, storyArcChaptersScreenPlay.STAGE_SALVAGE_BOARDS)
		return convoTemplate:getScreen("dead_terminal")
	end

	return convoTemplate:getScreen("offline")
end

function cruiser_computer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	-- The one option effect in the whole conversation.
	if (screenID == "blasted") then
		storyArcChaptersScreenPlay:makeUpLink(pPlayer)
	end

	return pClonedScreen
end

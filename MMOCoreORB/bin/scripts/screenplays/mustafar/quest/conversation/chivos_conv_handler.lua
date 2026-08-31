--[[ Foreman Chivos's handler -- story_arc_prelude_chivos.

THE DISPATCH TABLE

SOE's OnStartNpcConversation tests eight conditions in this order and returns on the
first that is true. The condition bodies are quest-state calls; the middle column is
what each one actually asks, and the right is the storyArcPreludeScreenPlay stage
that means the same thing here.

   #  condition            live test                                    stage
   1  hasWonAllMissions    hasCompletedQuest(prelude_03)                >= STAGE_DONE
   2  hasCollectedRods     isTaskActive(prelude_03, rod_four)           == STAGE_RODS_DONE
   3  isOnMissionTwo       isQuestActive(prelude_03)                    >= STAGE_TRAVEL
   4  hasWonVentMission    hasCompletedQuest(prelude_02)                >= STAGE_REACTOR_OFFER
   5  hasCleanedVents      isTaskActive(prelude_02, air_filter_five)    == STAGE_FILTERS_DONE
   6  isOnMissionOne       isQuestActive(prelude_01 or prelude_02)      >= STAGE_SUPPLIES
   7  hasCompletedSupply   hasCompletedQuest(prelude_01)                unreachable
   8  _defaultCondition    true                                         anything else

The cumulative tests (1, 4) are >= because on live they stay true forever once set;
the tests above them are what discriminate, exactly as they do on live. The
task-active tests (2, 5) are == because a task goes inactive again. 3 and 6 are
quest-active windows -- 3 covers STAGE_TRAVEL and STAGE_SALVAGE, 6 covers
STAGE_SUPPLIES and STAGE_FILTERS -- and the earlier returns close the top of each
window, again as on live.

CONDITION 7 IS STRUCTURALLY UNREACHABLE HERE, AND THAT IS FAITHFUL

hasCompletedSupply is prelude_01 finished. On live that can be true while prelude_02
is NOT active, because the two are separate quest grants -- a player could complete
the supply run and never pick the vent job up. That state is what greeting 7 and its
grantVentQuest action exist to repair.

This repo has no such state. story_arc_prelude.lua:sendCompanyComm sets
STAGE_FILTERS and calls startFilters in the same breath, so finishing the supply run
IS starting the vent job. Condition 6 therefore claims every stage from
STAGE_SUPPLIES up, and 7 can never fire. The screens are reconstructed anyway and
the test is written as the > that can never be true, so that if the stage machine is
ever split the branch comes back on its own. This is the same shape as Milo's
conditions 8 and 10; see milo_conv_handler.lua.

THE FIVE ACTIONS

Live's actions are one line each. All five already have a home in
storyArcPreludeScreenPlay, because the retired radial drove the same steps.

   grantMissionOne  grantQuest(prelude_01)                -> startSupplies
   grantVentReward  sendSignal(mustafar_air_filter_reward) -> signalFilterReward
   grantMissionTwo  grantQuest(prelude_03)                -> startSalvage
   grantRodReward   sendSignal(mustafar_rod_reward)        -> signalRodReward
   grantVentQuest   grantQuest(prelude_02) if not active   -> grantVentQuest

The two sendSignal actions are not a message bus: .qst _02 task 5 and _03 task 7 are
Wait for Signal tasks, so the signal IS the task completing. The repo's two signal*
functions already are those completions.

s_85 / who_is_mensix grants nothing on live and grants nothing here. It is the
pointer at Milo Mensix, and storyArcChaptersScreenPlay reads the prelude's own
STAGE_DONE, not anything said in this tree.

NO LEVEL GATE, AND THAT IS THE CORRECTION

The retired radial refused to start the prelude below combat level 75 and said so in
an invented system message. Live's Chivos has no level test anywhere -- not in the
conditions, not in the actions, not in OnStartNpcConversation. The .qst Level field
is what the JOURNAL DISPLAYS, not an entry requirement. The gate is gone with the
radial; requiredLevel stays as the recorded .qst value.

ONE EDGE ANIMATION

Every gesture live plays sits on a ConvoScreen animation / playerAnimation field
except one. s_36 (mission_briefing) is reached from two options: s_21 out of the
freelance offer, which plays only the npc's "sweat", and s_34 out of the vent
reward, which plays the player's "nod" as well. The npc half is common and lives on
the screen; the player half cannot, so it is keyed by edge below.
--]]

chivos_conv_handler = conv_handler:new {}
chivos_conv_handler.screenPlayName = "storyArcPreludeScreenPlay"

-- [from screen][to screen] = { { actor, animation }, ... }, the same shape
-- serpent_thief_conv_handler.lua:98 uses. See ONE EDGE ANIMATION.
chivos_conv_handler.edgeAnimations = {
	vent_reward = {
		mission_briefing = { { "player", "nod" } },  -- s_34
	},
}

function chivos_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = storyArcPreludeScreenPlay:getStage(pPlayer)

	-- 1 hasWonAllMissions. A bark on live; see the tree header.
	if (stage >= storyArcPreludeScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("all_missions_done")
	end
	-- 2 hasCollectedRods. ACTION grantRodReward waits on the option.
	if (stage == storyArcPreludeScreenPlay.STAGE_RODS_DONE) then
		return convoTemplate:getScreen("have_rods")
	end
	-- 3 isOnMissionTwo. STAGE_TRAVEL and STAGE_SALVAGE.
	if (stage >= storyArcPreludeScreenPlay.STAGE_TRAVEL) then
		return convoTemplate:getScreen("rods_yet")
	end
	-- 4 hasWonVentMission. The freelance offer into the reactor briefing.
	if (stage >= storyArcPreludeScreenPlay.STAGE_REACTOR_OFFER) then
		return convoTemplate:getScreen("freelance_offer")
	end
	-- 5 hasCleanedVents. ACTION grantVentReward waits on the option.
	if (stage == storyArcPreludeScreenPlay.STAGE_FILTERS_DONE) then
		return convoTemplate:getScreen("vents_report")
	end
	-- 6 isOnMissionOne. STAGE_SUPPLIES and STAGE_FILTERS.
	if (stage >= storyArcPreludeScreenPlay.STAGE_SUPPLIES) then
		return convoTemplate:getScreen("finished_yet")
	end
	-- 7 hasCompletedSupply. Unreachable -- see the header.
	if (stage > storyArcPreludeScreenPlay.STAGE_SUPPLIES) then
		return convoTemplate:getScreen("supply_only")
	end
	-- 8 default. He has never met this player.
	return convoTemplate:getScreen("first_meeting")
end

function chivos_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	self:playEdgeAnimations(pPlayer, pNpc, self:getLastScreenID(pPlayer), screenID)

	if (screenID == "ill_take_the_job") then
		storyArcPreludeScreenPlay:startSupplies(pPlayer)
	elseif (screenID == "vent_reward") then
		storyArcPreludeScreenPlay:signalFilterReward(pPlayer)
	elseif (screenID == "ill_look") then
		storyArcPreludeScreenPlay:startSalvage(pPlayer)
	elseif (screenID == "handing_rods_over") then
		storyArcPreludeScreenPlay:signalRodReward(pPlayer)
	elseif (screenID == "ill_do_it") then
		storyArcPreludeScreenPlay:grantVentQuest(pPlayer)
	end

	return pClonedScreen
end

-- The screen the player was looking at when he picked the option. runScreenHandlers
-- runs before the new screen is sent, and the session's last screen only updates on
-- the send path, so this is still the previous screen. nil on an opening screen.
function chivos_conv_handler:getLastScreenID(pPlayer)
	if (pPlayer == nil) then
		return nil
	end

	local pSession = CreatureObject(pPlayer):getConversationSession()

	if (pSession == nil) then
		return nil
	end

	local pLastScreen = LuaConversationSession(pSession):getLastConversationScreen()

	if (pLastScreen == nil) then
		return nil
	end

	return LuaConversationScreen(pLastScreen):getScreenID()
end

function chivos_conv_handler:playEdgeAnimations(pPlayer, pNpc, fromID, toID)
	if (fromID == nil) then
		return
	end

	local edges = self.edgeAnimations[fromID]

	if (edges == nil) then
		return
	end

	local animations = edges[toID]

	if (animations == nil) then
		return
	end

	for i = 1, #animations do
		local actor = animations[i][1] == "npc" and pNpc or pPlayer

		CreatureObject(actor):doAnimation(animations[i][2])
	end
end

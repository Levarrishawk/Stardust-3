--[[
	Surveyor Jo Keslev -- conversation handler for The Mining Field Markers.

	The file this replaces was a verbatim copy of fs_patrol_quest_start_conv_handler: it read
	VillageJediManagerTownship:getCurrentPhase(), FsPatrolCompletedCount and FS_PATROL_QUEST_*,
	and returned screen ids (intro_noteligible, all_eight_points, you_know_the_drill, ...) that
	do not exist in the jo_kelsev template. Every path through it was dead, so Jo Keslev could
	not hand out a single marker set.

	All state lives in miningFieldMarkersScreenPlay -- this file only routes.

	Screen flow:
	  first_screen -> opt1 -> opt1a -> opt1b -> opt1c -> opt1d -> choose_search_location
	  choose_search_location  options built here, one per area the player has left
	  choose_<area>           starts that area's set (startArea)
	  in_progress             player is part way through a set
	  turn_in                 a set is finished and unpaid -- paid on entering this screen
	  welcome_back            at least one set paid, none pending, areas remain
	  finished_all            all seven sets paid

	Engine notes that shape the code below:
	  * runScreenHandlers runs for the INITIAL screen as well as for option-linked screens
	    (ConversationObserverImplementation.cpp:133 calls it on whatever getNextConversationScreen
	    returned). Anything with a side effect therefore needs its own guard -- see the
	    rewarded flag on finished_all.
	  * getInitialScreen is only consulted when there is no last screen for the session
	    (conv_handler.lua), i.e. once per conversation.
	  * addOption writes onto the CLONED screen, and the session stores that clone, so
	    getOptionLink resolves runtime-added options on the next turn.
--]]

jo_kelsev_conv_handler = conv_handler:new {}

-- Area key -> { option string, quest-start screen }. The option strings are the stock
-- @conversation/som_exploration_marker entries the SD1 port had hard-wired one per screen;
-- they are added at runtime instead so the player can pick any area, as on live.
jo_kelsev_conv_handler.areaOptions = {
	mining_field    = { "@conversation/som_exploration_marker:s_46", "choose_facility" },
	crystal_flats   = { "@conversation/som_exploration_marker:s_50", "choose_crystal_flats" },
	smoking_forest  = { "@conversation/som_exploration_marker:s_54", "choose_smoking_forest" },
	central_volcano = { "@conversation/som_exploration_marker:s_58", "choose_central_volcano" },
	burning_plains  = { "@conversation/som_exploration_marker:s_62", "choose_burning_plains" },
	berkens_flow    = { "@conversation/som_exploration_marker:s_66", "choose_berkens_flow" },
	nesting_grounds = { "@conversation/som_exploration_marker:s_70", "choose_tulrus_nesting_grounds" },
}

-- Quest-start screen -> area key, derived from areaOptions so the two can never drift.
jo_kelsev_conv_handler.areaByScreen = {}

for key, option in pairs(jo_kelsev_conv_handler.areaOptions) do
	jo_kelsev_conv_handler.areaByScreen[option[2]] = key
end

function jo_kelsev_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (miningFieldMarkersScreenPlay:hasCompletedAllAreas(pPlayer)) then
		return convoTemplate:getScreen("finished_all")
	end

	-- A finished-but-unpaid set outranks everything else: the player walked back here to
	-- get paid for it.
	if (miningFieldMarkersScreenPlay:getAreaAwaitingTurnIn(pPlayer) ~= nil) then
		return convoTemplate:getScreen("turn_in")
	end

	if (miningFieldMarkersScreenPlay:getActiveArea(pPlayer) ~= nil) then
		return convoTemplate:getScreen("in_progress")
	end

	-- Fewer areas left than there are areas means the player has been paid at least once,
	-- so skip the whole recruitment pitch.
	if (#miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer) < #miningFieldMarkersScreenPlay.markerAreas) then
		return convoTemplate:getScreen("welcome_back")
	end

	return convoTemplate:getScreen("first_screen")
end

function jo_kelsev_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "choose_search_location") then
		self:addAreaOptions(pPlayer, clonedConversation)

	elseif (screenID == "turn_in") then
		local area = miningFieldMarkersScreenPlay:getAreaAwaitingTurnIn(pPlayer)

		if (area ~= nil) then
			miningFieldMarkersScreenPlay:turnInArea(pPlayer, area)
		end

		-- Offer the next set straight away, but only while one is left. When that was the
		-- seventh set the conversation ends here and the next hail opens on finished_all,
		-- which is where the completion line ("...and as promised...") belongs anyway.
		if (#miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer) > 0) then
			clonedConversation:addOption("@conversation/som_exploration_marker:s_38", "choose_search_location")
			clonedConversation:addOption("@conversation/som_exploration_marker:s_76", "deny")
		else
			clonedConversation:setStopConversation(true)
		end

	elseif (self.areaByScreen[screenID] ~= nil) then
		local area = miningFieldMarkersScreenPlay:getAreaByKey(self.areaByScreen[screenID])

		if (area ~= nil) then
			miningFieldMarkersScreenPlay:startArea(pPlayer, area)
		end

	elseif (screenID == "finished_all") then
		miningFieldMarkersScreenPlay:grantCompletionReward(pPlayer)
	end

	return pClonedScreen
end

-- One option per area the player has neither started nor finished, in NGE listing order.
function jo_kelsev_conv_handler:addAreaOptions(pPlayer, clonedConversation)
	local remaining = miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer)

	for i = 1, #remaining do
		local option = self.areaOptions[remaining[i].key]

		if (option ~= nil) then
			clonedConversation:addOption(option[1], option[2])
		end
	end

	-- Reachable only if the player somehow lands here with everything taken; without this
	-- the screen would render with no options at all and strand the conversation.
	if (#remaining == 0) then
		clonedConversation:setStopConversation(true)
	end
end

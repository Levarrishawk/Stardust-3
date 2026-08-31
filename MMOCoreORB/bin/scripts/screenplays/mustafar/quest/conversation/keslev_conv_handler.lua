--[[
	Surveyor Keslev -- conversation handler for The Mining Field Markers.

	The tree is in mobile/conversations/mustafar/som_exploration_marker.lua, which carries
	the note on how it was checked against Mustafar's live som_exploration_marker
	conversation. This file routes, grants each area's quest, hands over the completion
	reward, and plays the animations.

	All state lives in miningFieldMarkersScreenPlay -- this file only routes.

	THIS FILE REPLACES jo_kelsev_conv_handler.lua

	Two things were wrong with the name. Live calls him Surveyor Keslev, with no middle
	name -- all seven shipped quest journals say so. And the file it replaces was originally
	a verbatim copy of fs_patrol_quest_start_conv_handler: it read
	VillageJediManagerTownship:getCurrentPhase(), FsPatrolCompletedCount and
	FS_PATROL_QUEST_*, and returned screen ids (intro_noteligible, all_eight_points,
	you_know_the_drill, ...) that exist in no Mustafar template. Every path through it was
	dead, so Keslev could not hand out a single marker set.

	THE FOUR OPENINGS, IN LIVE TEST ORDER

	Live tests four conditions in order and takes the first that passes. Order matters:
	a player who has finished everything also satisfies hasAcceptedOne, so the later test
	would swallow the earlier one if they were reversed.

	    1  completedReward   the crystal is already handed over   -> already_rewarded
	    2  completeAll       all seven areas finished             -> finished_all
	    3  hasAcceptedOne    any area started or finished         -> welcome_back
	    4  default           everything else                      -> first_screen

	Live's test 1 is an objvar, mustafar.tanray_heart. This uses the screenplay's own
	"rewarded" flag instead, because that is the flag grantCompletionReward already writes
	and it is the Core3 idiom. Same gate, different store.

	There is no turn-in opening and no in-progress opening. Live has neither -- each area
	pays itself off the .qst's Reward task the moment its markers are done. An earlier
	revision invented both. See mining_field_markers.lua.

	WHERE THE ACTIONS FIRE

	Live, each action hangs off the player's OPTION and fires before the screen that option
	leads to is shown. Core3 gives runScreenHandlers the screen the player arrived AT, so
	the faithful place is the screen the option leads to:

	    grant area quest   choose_facility ... choose_tulrus_nesting_grounds
	    grant the crystal  reward (s_42)   -- was finished_all, one screen too early

	The reward fire point was the same bug q4p3 had: a player who opened finished_all and
	walked away without clicking "Thank you" was still paid.

	THE ANIMATIONS  --  and a correction about where they could have lived

	This file used to say the animations sit here "because a ConvoScreen has no field for
	them". That is false. ConvoScreen reads "animation" and "playerAnimation" off each
	screen and plays them when the screen is sent (ConversationScreen.h, readObject and
	sendTo), and seven other Mustafar trees here already use them. The claim was written
	from not finding the fields rather than from looking for them.

	The table stays, and that it is safe is checked rather than assumed: a screen-keyed
	table only loses data when two options reach the SAME screen carrying DIFFERENT
	gestures, and none here do. There is also a reason a screen field would be awkward for
	seven of these rows -- the choose_* screens are reached by options this handler ADDS at
	runtime in addAreaOptions, so the tree never lists the edge that leads to them.

	Live has 30 animation calls. 4 are the greeting on each opening and live in
	getInitialScreen above. The other 26 hang off player options -- but they land on only
	19 distinct screens, which is what the table below has, and the arithmetic is worth
	writing down because it looks like seven are missing:

	    live calls   26
	    less  -7     the seven area options are listed TWICE, once under
	                 choose_search_location and once under choose_again, and both copies
	                 fire the same "explain" onto the same seven destination screens
	    = 19 rows

	Keying by destination screen is what collapses them. It is also why this table cannot
	distinguish the two paths -- it does not need to, because live plays the same animation
	on both.

	Unlike q4p3, these are mostly the NPC's -- Keslev is doing the explaining -- so each
	entry names its actor. choose_again carries two, in live order: the player nods, then
	Keslev bounces.
--]]

keslev_conv_handler = conv_handler:new {}

-- Area key -> { option string, quest-start screen }. Live guards each option with
-- !isQuestActiveOrComplete on that area's quest, which is exactly what
-- miningFieldMarkersScreenPlay:getRemainingAreas returns.
keslev_conv_handler.areaOptions = {
	mining_field    = { "@conversation/som_exploration_marker:s_46", "choose_facility" },
	crystal_flats   = { "@conversation/som_exploration_marker:s_50", "choose_crystal_flats" },
	smoking_forest  = { "@conversation/som_exploration_marker:s_54", "choose_smoking_forest" },
	central_volcano = { "@conversation/som_exploration_marker:s_58", "choose_central_volcano" },
	burning_plains  = { "@conversation/som_exploration_marker:s_62", "choose_burning_plains" },
	berkens_flow    = { "@conversation/som_exploration_marker:s_66", "choose_berkens_flow" },
	nesting_grounds = { "@conversation/som_exploration_marker:s_70", "choose_tulrus_nesting_grounds" },
}

-- The order live lists the areas in, which is neither alphabetical nor the order
-- miningFieldMarkersScreenPlay.markerAreas happens to be written in. Live builds its
-- response array in this sequence and skips the ones already taken, so the options a
-- player sees keep this relative order however many are left.
keslev_conv_handler.areaListOrder = {
	"mining_field", "crystal_flats", "smoking_forest", "central_volcano",
	"burning_plains", "berkens_flow", "nesting_grounds",
}

-- Quest-start screen -> area key, derived from areaOptions so the two can never drift.
keslev_conv_handler.areaByScreen = {}

for key, option in pairs(keslev_conv_handler.areaOptions) do
	keslev_conv_handler.areaByScreen[option[2]] = key
end

-- Keyed by the screen the player's option LEADS TO. Each entry is { actor, animation }
-- in the order live plays them. See THE ANIMATIONS.
keslev_conv_handler.screenAnimations = {
	-- The pitch.
	opt1                          = { { "npc", "explain" } },
	opt1a                         = { { "npc", "explain" } },
	opt1b                         = { { "npc", "explain" } },
	opt1c                         = { { "npc", "rub_chin_thoughtful" } },
	opt1d                         = { { "npc", "explain" } },

	-- Taking the job, first time and on a return visit.
	choose_search_location        = { { "player", "nod" } },
	choose_again                  = { { "player", "nod" }, { "npc", "bounce" } },

	-- The three refusals. Same reply, different reaction.
	deny                          = { { "player", "refuse_offer_affection" } },
	deny_later                    = { { "player", "shake_head_no" } },
	deny_back                     = { { "player", "shake_head_no" } },

	-- Picking an area.
	choose_facility               = { { "npc", "explain" } },
	choose_crystal_flats          = { { "npc", "explain" } },
	choose_smoking_forest         = { { "npc", "explain" } },
	choose_central_volcano        = { { "npc", "explain" } },
	choose_burning_plains         = { { "npc", "explain" } },
	choose_berkens_flow           = { { "npc", "explain" } },
	choose_tulrus_nesting_grounds = { { "npc", "explain" } },

	-- Taking the crystal.
	reward                        = { { "npc", "bow4" } },
}

function keslev_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Order is live's. See THE FOUR OPENINGS.
	if (miningFieldMarkersScreenPlay:hasTakenCompletionReward(pPlayer)) then
		CreatureObject(pNpc):doAnimation("bow")

		return convoTemplate:getScreen("already_rewarded")
	end

	if (miningFieldMarkersScreenPlay:hasCompletedAllAreas(pPlayer)) then
		CreatureObject(pNpc):doAnimation("thank")

		return convoTemplate:getScreen("finished_all")
	end

	-- Live's hasAcceptedOne: any of the seven area quests active or complete. Fewer areas
	-- remaining than there are areas says the same thing about the same seven quests.
	if (#miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer) < #miningFieldMarkersScreenPlay.markerAreas) then
		CreatureObject(pNpc):doAnimation("wave1")

		return convoTemplate:getScreen("welcome_back")
	end

	CreatureObject(pNpc):doAnimation("bow4")

	return convoTemplate:getScreen("first_screen")
end

function keslev_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	-- Both area lists are built the same way; they differ only in Keslev's line.
	if (screenID == "choose_search_location" or screenID == "choose_again") then
		self:addAreaOptions(pPlayer, clonedConversation)

	elseif (self.areaByScreen[screenID] ~= nil) then
		local area = miningFieldMarkersScreenPlay:getAreaByKey(self.areaByScreen[screenID])

		if (area ~= nil) then
			miningFieldMarkersScreenPlay:startArea(pPlayer, area)
		end

	-- The crystal and the badge, one screen after Keslev says he is handing them over.
	-- See WHERE THE ACTIONS FIRE.
	elseif (screenID == "reward") then
		miningFieldMarkersScreenPlay:grantCompletionReward(pPlayer)
	end

	return pClonedScreen
end

-- One option per area the player has neither started nor finished. getRemainingAreas
-- answers WHICH areas; areaListOrder decides the order they are listed in, because
-- markerAreas is not written in live's listing order.
function keslev_conv_handler:addAreaOptions(pPlayer, clonedConversation)
	local remaining = {}

	for _, area in ipairs(miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer)) do
		remaining[area.key] = true
	end

	local offered = 0

	for i = 1, #self.areaListOrder do
		local key = self.areaListOrder[i]
		local option = self.areaOptions[key]

		if (remaining[key] and option ~= nil) then
			clonedConversation:addOption(option[1], option[2])
			offered = offered + 1
		end
	end

	-- Reachable only if the player somehow lands here with everything taken; without this
	-- the screen would render with no options at all and strand the conversation.
	if (offered == 0) then
		clonedConversation:setStopConversation(true)
	end
end

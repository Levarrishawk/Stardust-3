--[[
	Lesnorr -- the ground giver for the Kashyyyk slaver quest head that had no giver:

		convoy/ep3_trando_lesnorr   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua and is registered
	there (line 766). That file is included by screenplays/space/screenplays.lua before this one, so
	the global is loaded by the time this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	REACHABILITY, STATED PLAINLY. ep3_lesnorr is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed; nothing here depends on them, so it costs nothing to land now.
]]

Ep3LesnorrConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questType/questName, lines 720-721).
EP3_LESNORR_CONVOY = {type = "convoy", name = "ep3_trando_lesnorr"}

-- Handler-owned bookkeeping.
EP3_LESNORR_TAKEN_KEY = ":ep3_lesnorr:taken" -- has ever accepted the contract
EP3_LESNORR_PAID_KEY = ":ep3_lesnorr:paid"   -- has already been through the s_1006 payoff screen

function Ep3LesnorrConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3LesnorrConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_trando_lesnorr" does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it; the re-check
-- is kept anyway so a refused grant leaves no residue.
function Ep3LesnorrConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- s_1035 "Until you learn to fly, you are really not very useful to me" is the client's own gate.
function Ep3LesnorrConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3LesnorrConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_LESNORR_CONVOY.type, EP3_LESNORR_CONVOY.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_LESNORR_CONVOY.type, EP3_LESNORR_CONVOY.name)

	-- Delivered. First hail after the run gets the payoff arc, every hail after that gets s_1000.
	if (complete) then
		if (self:getFlag(pPlayer, EP3_LESNORR_PAID_KEY) == 1) then
			return convoTemplate:getScreen("ep3_lesnorr_paid")
		end

		return convoTemplate:getScreen("ep3_lesnorr_complete")
	end

	-- Contract running.
	if (active) then
		return convoTemplate:getScreen("ep3_lesnorr_busy")
	end

	--[[
		FLAGGED INTERPRETATION -- FAILURE DETECTION. See the matching block in
		mobile/conversations/space/neutral/kashyyyk_slaver/ep3_lesnorr_convo.lua. The client ships
		s_1010 ("you lost every shuttle in the fleet") and its s_1012/s_1014 retry, but
		SpaceConvoyScreenplay records no per-survivor count that a conversation can read, so this
		handler cannot separate "lost the convoy" from "abandoned the contract". Anyone who once
		accepted and now holds neither an active nor a complete quest gets the s_1010 arc. The text
		is client fact; that trigger is not.
	]]
	if (self:getFlag(pPlayer, EP3_LESNORR_TAKEN_KEY) == 1) then
		if (not self:canFly(pPlayer)) then
			return convoTemplate:getScreen("ep3_lesnorr_no_pilot")
		end

		return convoTemplate:getScreen("ep3_lesnorr_lost")
	end

	if (not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_lesnorr_no_pilot")
	end

	return convoTemplate:getScreen("ep3_lesnorr_greeting")
end

function Ep3LesnorrConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_1026 "Right. When do we leave?" lands here.
	-- THE RE-GRANT. s_1012 "Give me another shot." lands on ep3_lesnorr_retry.
	if (screenID == "ep3_lesnorr_accept" or screenID == "ep3_lesnorr_retry") then
		if (self:grant(pPlayer, pNpc, convoy_ep3_trando_lesnorr, EP3_LESNORR_CONVOY)) then
			self:setFlag(pPlayer, EP3_LESNORR_TAKEN_KEY, 1)
			self:setFlag(pPlayer, EP3_LESNORR_PAID_KEY, 0)
		end

	--[[
		FLAGGED INTERPRETATION -- THE BONUS. s_1024 promises "if you can get them all through in one
		piece I will have a bonus for you" and s_1006 hands it over. No bonus amount is attested
		anywhere -- not in the stf, not in the screenplay -- and SpaceConvoyScreenplay already pays
		its own creditReward on completion. Rather than invent a second payout, this screen is text
		only and simply latches so the player is not offered it twice. If a bonus figure is ever
		decided, this is the one place to add it.
	]]
	elseif (screenID == "ep3_lesnorr_bonus") then
		self:setFlag(pPlayer, EP3_LESNORR_PAID_KEY, 1)
	end

	return pScreenClone
end

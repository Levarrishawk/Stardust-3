--[[
	Mssikss -- the ground giver for the Kashyyyk slaver quest head that had no giver:

		recovery/ep3_trando_mssikss   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua and is registered
	there (line 712). That file is included by screenplays/space/screenplays.lua before this one, so
	the global is loaded by the time this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	REACHABILITY, STATED PLAINLY. ep3_mssikss is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3MssikssConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questType/questName, lines 667-668).
EP3_MSSIKSS_RECOVERY = {type = "recovery", name = "ep3_trando_mssikss"}

EP3_MSSIKSS_TAKEN_KEY = ":ep3_mssikss:taken" -- has ever accepted the job
EP3_MSSIKSS_PAID_KEY = ":ep3_mssikss:paid"   -- has already been through the s_1123 payoff screen

function Ep3MssikssConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3MssikssConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_trando_mssikss" does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it; the re-check
-- is kept anyway so a refused grant leaves no residue.
function Ep3MssikssConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- s_1163 "I am in desperate need of a fighter pilot" is the client's own gate.
function Ep3MssikssConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3MssikssConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_MSSIKSS_RECOVERY.type, EP3_MSSIKSS_RECOVERY.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_MSSIKSS_RECOVERY.type, EP3_MSSIKSS_RECOVERY.name)

	-- Freighter recovered. First hail after the run gets the payoff arc, every hail after that gets
	-- s_1117, which is the client's own written ending for him.
	if (complete) then
		if (self:getFlag(pPlayer, EP3_MSSIKSS_PAID_KEY) == 1) then
			return convoTemplate:getScreen("ep3_mssikss_paid")
		end

		return convoTemplate:getScreen("ep3_mssikss_complete")
	end

	if (active) then
		return convoTemplate:getScreen("ep3_mssikss_busy")
	end

	if (not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_mssikss_no_pilot")
	end

	-- See the FLAGGED INTERPRETATION block above ep3_mssikss_retry in
	-- mobile/conversations/space/neutral/kashyyyk_slaver/ep3_mssikss_convo.lua: this is the best
	-- failure test the recovery screenplay makes available, not a client-attested one.
	if (self:getFlag(pPlayer, EP3_MSSIKSS_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_mssikss_retry")
	end

	return convoTemplate:getScreen("ep3_mssikss_greeting")
end

function Ep3MssikssConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_1151 "Let's do this." lands on ep3_mssikss_accept.
	-- THE RE-GRANT. s_1129 "I will not fail again." lands on ep3_mssikss_retry_yes.
	if (screenID == "ep3_mssikss_accept" or screenID == "ep3_mssikss_retry_yes") then
		if (self:grant(pPlayer, pNpc, recovery_ep3_trando_mssikss, EP3_MSSIKSS_RECOVERY)) then
			self:setFlag(pPlayer, EP3_MSSIKSS_TAKEN_KEY, 1)
			self:setFlag(pPlayer, EP3_MSSIKSS_PAID_KEY, 0)
		end

	--[[
		FLAGGED INTERPRETATION -- THE REWARD. s_1123 "Here you go" is the payoff line, but no amount
		is attested anywhere -- not in the stf, not in the screenplay -- and SpaceRecoveryScreenplay
		already pays its own creditReward (3500) on completion. Rather than invent a second payout,
		this screen is text only and simply latches so the player is not shown it twice. If a figure
		is ever decided, this is the one place to add it.
	]]
	elseif (screenID == "ep3_mssikss_reward") then
		self:setFlag(pPlayer, EP3_MSSIKSS_PAID_KEY, 1)
	end

	return pScreenClone
end

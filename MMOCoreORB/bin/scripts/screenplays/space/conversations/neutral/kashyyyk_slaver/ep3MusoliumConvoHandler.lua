--[[
	Mosolium Zssik -- the ground giver for the Kashyyyk slaver quest head that had no giver:

		inspect/ep3_trando_mosolium_zssik_04   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua and is registered
	there (line 659). That file is included by screenplays/space/screenplays.lua before this one, so
	the global is loaded by the time this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	REACHABILITY, STATED PLAINLY. ep3_musolium is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3MusoliumConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questType/questName, lines 667-668 of the
-- inspect block).
EP3_MOSOLIUM_INSPECT = {type = "inspect", name = "ep3_trando_mosolium_zssik_04"}

--[[
	FLAGGED INTERPRETATION -- THE DOOR. s_1113 ("Perhaps you should go talk to Boshaz") is clearly
	written for a player Mosolium has not been introduced to, and Boshaz is the step before him in the
	same Trandoshan arc. The client does not state the precise condition, so the gate used here is
	the completion of Boshaz's own space quest, escort/ep3_trando_boshaz_zssik_01. The line is client
	fact; that condition is not. It is one constant, changed in one place.
]]
EP3_MOSOLIUM_DOOR = {type = "escort", name = "ep3_trando_boshaz_zssik_01"}

EP3_MOSOLIUM_TAKEN_KEY = ":ep3_musolium:taken"     -- has ever accepted the inspect
EP3_MOSOLIUM_KLESK_KEY = ":ep3_musolium:klesk"     -- 0 not offered, 1 accepted, 2 settled
EP3_MOSOLIUM_DONE_KEY = ":ep3_musolium:orooroo"    -- has been passed on to Orooroo

--[[
	FLAGGED INTERPRETATION -- GROUND LEG PROGRESSION. There is no Kashyyyk ground screenplay, no
	Kashyyyk ground spawn areas and no Klesk mobile in this repo, so "kill Klesk and take his key
	card" cannot be checked. With that true, the leg advances one step per hail: accept -> "go do it"
	-> settled. The dialogue is client fact; this progression is not.

	Set this to false once a real Klesk ground quest exists, then replace the single
	getFlag() == 1 branch below with the real completion test. Nothing else in this file changes.
]]
MOSOLIUM_GROUND_LEG_AUTO = true

function Ep3MusoliumConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3MusoliumConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_trando_mosolium_zssik_04" does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it; the re-check
-- is kept anyway so a refused grant leaves no residue.
function Ep3MusoliumConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3MusoliumConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3MusoliumConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Passed on to Orooroo already.
	if (self:getFlag(pPlayer, EP3_MOSOLIUM_DONE_KEY) == 1) then
		return convoTemplate:getScreen("ep3_musolium_done")
	end

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_MOSOLIUM_INSPECT.type, EP3_MOSOLIUM_INSPECT.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_MOSOLIUM_INSPECT.type, EP3_MOSOLIUM_INSPECT.name)

	-- Space leg done -- the Klesk ground leg, then the payoff.
	if (complete) then
		local klesk = self:getFlag(pPlayer, EP3_MOSOLIUM_KLESK_KEY)

		if (klesk == 0) then
			return convoTemplate:getScreen("ep3_musolium_codes_in")
		end

		if (klesk == 1) then
			if (MOSOLIUM_GROUND_LEG_AUTO) then
				self:setFlag(pPlayer, EP3_MOSOLIUM_KLESK_KEY, 2)
			end

			return convoTemplate:getScreen("ep3_musolium_klesk_active")
		end

		return convoTemplate:getScreen("ep3_musolium_payoff")
	end

	if (active) then
		return convoTemplate:getScreen("ep3_musolium_busy")
	end

	-- Took it once and no longer holds it. See the FLAGGED INTERPRETATION block above
	-- ep3_musolium_failed in mobile/conversations/space/neutral/kashyyyk_slaver/ep3_musolium_convo.lua.
	if (self:getFlag(pPlayer, EP3_MOSOLIUM_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_musolium_failed")
	end

	-- Not introduced yet, or cannot fly the job he is about to describe.
	if (not SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_MOSOLIUM_DOOR.type, EP3_MOSOLIUM_DOOR.name)
		or not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_musolium_stranger")
	end

	return convoTemplate:getScreen("ep3_musolium_greeting")
end

function Ep3MusoliumConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_1105 "Ok, and where can I find these flight leaders?" lands on ep3_musolium_accept.
	-- THE RE-GRANT. s_1077 "A minor set back." lands on ep3_musolium_retry_yes.
	if (screenID == "ep3_musolium_accept" or screenID == "ep3_musolium_retry_yes") then
		if (self:grant(pPlayer, pNpc, inspect_ep3_trando_mosolium_zssik_04, EP3_MOSOLIUM_INSPECT)) then
			self:setFlag(pPlayer, EP3_MOSOLIUM_TAKEN_KEY, 1)
		end

	-- Klesk ground leg accepted. s_1067 "Yes, I am ready to begin." lands here.
	elseif (screenID == "ep3_musolium_klesk_accept") then
		self:setFlag(pPlayer, EP3_MOSOLIUM_KLESK_KEY, 1)

	-- Handed off to Orooroo. Both shipped endings latch, so he does not repeat the payoff.
	elseif (screenID == "ep3_musolium_orooroo" or screenID == "ep3_musolium_orooroo_later") then
		self:setFlag(pPlayer, EP3_MOSOLIUM_DONE_KEY, 1)
	end

	return pScreenClone
end

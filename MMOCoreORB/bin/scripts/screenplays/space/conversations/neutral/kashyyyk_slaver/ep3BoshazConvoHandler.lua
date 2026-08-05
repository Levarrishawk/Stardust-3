--[[
	Boshaz Zssik -- the ground giver for the Kashyyyk slaver quest head that had no giver:

		escort/ep3_trando_boshaz_zssik_01   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua
	(escort_ep3_trando_boshaz_zssik_01 = SpaceEscortScreenplay:new, registered line 624). That file is
	included by screenplays/space/screenplays.lua before this one, so the global is loaded by the time
	this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	Boshaz is also the door into the rest of the Trandoshan arc: Ep3MusoliumConvoHandler gates its
	s_1113 "Perhaps you should go talk to Boshaz" screen on
	SpaceHelpers:isSpaceQuestComplete(pPlayer, "escort", "ep3_trando_boshaz_zssik_01"), i.e. on this
	quest finishing.

	REACHABILITY, STATED PLAINLY. ep3_boshaz is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3BoshazConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questType/questName, lines 582-583).
EP3_BOSHAZ_ESCORT = {type = "escort", name = "ep3_trando_boshaz_zssik_01"}

EP3_BOSHAZ_TAKEN_KEY = ":ep3_boshaz:taken"         -- has ever accepted the escort
EP3_BOSHAZ_REFUSED_KEY = ":ep3_boshaz:refused"     -- heard the Zssik pitch and walked away
EP3_BOSHAZ_CHAWROO_KEY = ":ep3_boshaz:chawroo"     -- 0 not accepted, 1 accepted, 2 settled
EP3_BOSHAZ_DONE_KEY = ":ep3_boshaz:dakar"          -- paid off and sent on to Dakar

--[[
	FLAGGED INTERPRETATION -- GROUND LEG PROGRESSION. The Zssik pitch ends in a GROUND task: rescue
	Chawroo from the Blackscale patrol northwest of here (s_157) and get him to set up the meeting.
	There is no Kashyyyk ground screenplay, no Kashyyyk ground spawn areas and no Chawroo mobile in
	this repo, so that leg cannot be checked. With that true, the leg advances one step per hail:
	accept -> "you had better hurry" -> settled. The dialogue is client fact; this progression is not.

	Set this to false once a real Chawroo ground quest exists, then replace the single
	getFlag() == 1 branch below with the real completion test. Nothing else in this file changes.
]]
BOSHAZ_GROUND_LEG_AUTO = true

function Ep3BoshazConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3BoshazConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_trando_boshaz_zssik_01" does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it; the re-check
-- is kept anyway so a refused grant leaves no residue.
function Ep3BoshazConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3BoshazConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3BoshazConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Paid off and handed on to Dakar already.
	if (self:getFlag(pPlayer, EP3_BOSHAZ_DONE_KEY) == 1) then
		return convoTemplate:getScreen("ep3_boshaz_dakar")
	end

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_BOSHAZ_ESCORT.type, EP3_BOSHAZ_ESCORT.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BOSHAZ_ESCORT.type, EP3_BOSHAZ_ESCORT.name)

	-- Escort survived -- the reveal, the Zssik pitch, then the Chawroo ground leg.
	if (complete) then
		local chawroo = self:getFlag(pPlayer, EP3_BOSHAZ_CHAWROO_KEY)

		if (chawroo == 2) then
			return convoTemplate:getScreen("ep3_boshaz_ground_done")
		end

		if (chawroo == 1) then
			if (BOSHAZ_GROUND_LEG_AUTO) then
				self:setFlag(pPlayer, EP3_BOSHAZ_CHAWROO_KEY, 2)
			end

			return convoTemplate:getScreen("ep3_boshaz_ground_active")
		end

		-- Heard the pitch and walked away. s_617 is the client's own "have you changed your mind
		-- about working for the Zssik" re-entry.
		if (self:getFlag(pPlayer, EP3_BOSHAZ_REFUSED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_boshaz_return")
		end

		return convoTemplate:getScreen("ep3_boshaz_setup")
	end

	if (active) then
		return convoTemplate:getScreen("ep3_boshaz_busy")
	end

	-- Took it once and no longer holds it. See the FLAGGED INTERPRETATION block above
	-- ep3_boshaz_escort_failed in mobile/conversations/space/neutral/kashyyyk_slaver/ep3_boshaz_convo.lua.
	if (self:getFlag(pPlayer, EP3_BOSHAZ_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_boshaz_escort_failed")
	end

	-- s_725 is a brush-off, not a pilot gate, so a non-pilot still gets the greeting; the gate fires
	-- at the point of the offer (see runScreenHandlers below).
	return convoTemplate:getScreen("ep3_boshaz_greeting")
end

function Ep3BoshazConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_735 "For me, that isn't even a challenge." lands on ep3_boshaz_escort_accept.
	if (screenID == "ep3_boshaz_escort_accept") then
		--[[
			FLAGGED INTERPRETATION -- THE PILOT GATE. This .stf ships no "you are not a pilot" line.
			The nearest shipped refusal is s_723, which ends "I do have a job that is in need of a good
			star pilot. Finish up with what you are tasked with and then...perhaps...I will talk with
			you." It is used here for a player who cannot fly the job he just described. The text is
			client fact; using it for this condition is not.
		]]
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_boshaz_busy")
		end

		if (self:grant(pPlayer, pNpc, escort_ep3_trando_boshaz_zssik_01, EP3_BOSHAZ_ESCORT)) then
			self:setFlag(pPlayer, EP3_BOSHAZ_TAKEN_KEY, 1)
		end

	-- THE RE-GRANT. s_715 "I just had an off day. I can do your task." lands on ep3_boshaz_escort_retry.
	elseif (screenID == "ep3_boshaz_escort_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_boshaz_busy")
		end

		self:grant(pPlayer, pNpc, escort_ep3_trando_boshaz_zssik_01, EP3_BOSHAZ_ESCORT)

	-- Turned the clan down. Both shipped walk-aways latch, so the next hail opens on s_617.
	elseif (screenID == "ep3_boshaz_refuse" or screenID == "ep3_boshaz_too_dangerous") then
		self:setFlag(pPlayer, EP3_BOSHAZ_REFUSED_KEY, 1)

	-- Chawroo ground leg accepted. s_155 "Alright, where can I find Chawroo?" lands on ep3_boshaz_where.
	elseif (screenID == "ep3_boshaz_where") then
		self:setFlag(pPlayer, EP3_BOSHAZ_REFUSED_KEY, 0)
		self:setFlag(pPlayer, EP3_BOSHAZ_CHAWROO_KEY, 1)

	--[[
		THE PAYOFF. s_607 "They have been dealt with if that is what you mean." lands here.

		FLAGGED INTERPRETATION -- NO SECOND PAYOUT. s_609 says "here is payment for the completion of
		your first task for us", but no amount is attested anywhere in the .stf or the screenplay, and
		escort_ep3_trando_boshaz_zssik_01 already pays creditReward = 2500 on its own completion. This
		screen is therefore text-only and latches him onto Dakar. If a figure is ever decided, this is
		the one place to add it.
	]]
	elseif (screenID == "ep3_boshaz_payoff") then
		self:setFlag(pPlayer, EP3_BOSHAZ_DONE_KEY, 1)
	end

	return pScreenClone
end

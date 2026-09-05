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

	-- java OnStartNpcConversation order (ep3_trandoshan_boshaz_zssik_01.java:1470-1658).
	-- Existing space screen ids wrap the same keys; zssik_02 state is the screenplay.

	-- hasCompletedGroundQuest
	if (trandoBoshazZssik02ScreenPlay ~= nil and trandoBoshazZssik02ScreenPlay:getStage(pPlayer) == 0 and trandoBoshazZssik02ScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("ep3_boshaz_dakar")
	end

	-- isOnTask01 (talkToBoshaz)
	if (trandoBoshazZssik02ScreenPlay ~= nil and trandoBoshazZssik02ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("ep3_boshaz_ground_done")
	end

	-- isOnGroundQuest
	if (trandoBoshazZssik02ScreenPlay ~= nil and trandoBoshazZssik02ScreenPlay:getStage(pPlayer) > 0) then
		return convoTemplate:getScreen("ep3_boshaz_ground_active")
	end

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_BOSHAZ_ESCORT.type, EP3_BOSHAZ_ESCORT.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BOSHAZ_ESCORT.type, EP3_BOSHAZ_ESCORT.name)

	-- hasCompletedSpaceMission / hasReceivedReward
	if (complete and self:getFlag(pPlayer, EP3_BOSHAZ_DONE_KEY) == 1) then
		return convoTemplate:getScreen("ep3_boshaz_return")
	end

	-- hasWonSpaceMission
	if (complete) then
		if (self:getFlag(pPlayer, EP3_BOSHAZ_REFUSED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_boshaz_return")
		end

		return convoTemplate:getScreen("ep3_boshaz_setup")
	end

	-- hasFailedSpaceMission
	if (self:getFlag(pPlayer, EP3_BOSHAZ_TAKEN_KEY) == 1 and not active) then
		return convoTemplate:getScreen("ep3_boshaz_escort_failed")
	end

	-- isOnSpaceMission
	if (active) then
		return convoTemplate:getScreen("ep3_boshaz_busy")
	end

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
	elseif (screenID == "ep3_boshaz_where" or screenID == "s_157") then
		self:setFlag(pPlayer, EP3_BOSHAZ_REFUSED_KEY, 0)
		self:setFlag(pPlayer, EP3_BOSHAZ_CHAWROO_KEY, 1)

		if (trandoBoshazZssik02ScreenPlay ~= nil) then
			trandoBoshazZssik02ScreenPlay:grantQuest(pPlayer)
		end

	elseif (screenID == "ep3_boshaz_hurry" or screenID == "s_615") then
		if (trandoBoshazZssik02ScreenPlay ~= nil) then
			trandoBoshazZssik02ScreenPlay:clearQuest(pPlayer)
			trandoBoshazZssik02ScreenPlay:grantQuest(pPlayer)
		end

	elseif (screenID == "ep3_boshaz_payoff" or screenID == "s_609") then
		self:setFlag(pPlayer, EP3_BOSHAZ_DONE_KEY, 1)

		if (trandoBoshazZssik02ScreenPlay ~= nil) then
			trandoBoshazZssik02ScreenPlay:signalRewardBoshaz(pPlayer)
		end

		if (trandoBoshazTransferScreenPlay ~= nil) then
			trandoBoshazTransferScreenPlay:grantQuest(pPlayer)
		end
	end

	return pScreenClone
end

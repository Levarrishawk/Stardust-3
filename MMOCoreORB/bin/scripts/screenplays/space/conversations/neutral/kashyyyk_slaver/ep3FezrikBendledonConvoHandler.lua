--[[
	Fezrik Bendledon -- the ground giver for the Kashyyyk smuggling chain that had no giver:

		delivery_no_pickup/ep3_trando_fezrik_01   (head, questZone space_naboo)
			-> delivery_no_pickup/ep3_trando_fezrik_02   (side quest, COMPLETION split)
				-> delivery_no_pickup/ep3_trando_fezrik_03   (side quest, COMPLETION split)
					-> destroy_surpriseattack/ep3_trando_fezrik_04   (side quest, COMPLETION split)

	All four globals live in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua and are
	registered there (lines 478, 511, 544, 574). That file is included by
	screenplays/space/screenplays.lua before this one, so the globals are loaded by the time this
	handler runs.

	Only the HEAD is granted from a conversation. Legs 02-04 carry sideQuest = true with
	SIDE_QUEST_SPLIT_TYPES.COMPLETION, so each screenplay hands the next one out itself on completion.
	The player therefore never comes back to Fezrik mid-chain for the next leg -- which is exactly why
	the client gave him one accept arc and one failure arc and nothing in between.

	REACHABILITY, STATED PLAINLY. ep3_fezrik_bendledon is not spawned anywhere in this repo, there are
	no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3FezrikBendledonConvoHandler = conv_handler:new {}

-- The chain, in order. Names/types are copied from KashyyykSlaverScreenplay.lua verbatim.
EP3_FEZRIK_1 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_01"}
EP3_FEZRIK_2 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_02"}
EP3_FEZRIK_3 = {type = "delivery_no_pickup", name = "ep3_trando_fezrik_03"}
EP3_FEZRIK_4 = {type = "destroy_surpriseattack", name = "ep3_trando_fezrik_04"}

EP3_FEZRIK_TAKEN_KEY = ":ep3_fezrik:taken" -- has ever accepted the run

function Ep3FezrikBendledonConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3FezrikBendledonConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand the head out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of these four names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to them; the
-- re-check is kept anyway so a refused grant leaves no residue.
function Ep3FezrikBendledonConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- s_1034 "I have need of a pilot. If you ever happen to become one look me up" is the client's own
-- gate, written for exactly this case.
function Ep3FezrikBendledonConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3FezrikBendledonConvoHandler:anyLegActive(pPlayer)
	return SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_FEZRIK_1.type, EP3_FEZRIK_1.name)
		or SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_FEZRIK_2.type, EP3_FEZRIK_2.name)
		or SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_FEZRIK_3.type, EP3_FEZRIK_3.name)
		or SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_FEZRIK_4.type, EP3_FEZRIK_4.name)
end

function Ep3FezrikBendledonConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- The glitterdust is home only when the LAST leg is complete.
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_FEZRIK_4.type, EP3_FEZRIK_4.name)) then
		if (self:getFlag(pPlayer, EP3_FEZRIK_TAKEN_KEY) == 2) then
			return convoTemplate:getScreen("ep3_fezrik_thanks")
		end

		return convoTemplate:getScreen("ep3_fezrik_complete")
	end

	-- Any leg in flight. The screenplays chain themselves, so mid-chain he has nothing to say.
	if (self:anyLegActive(pPlayer)) then
		return convoTemplate:getScreen("ep3_fezrik_busy")
	end

	if (not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_fezrik_no_pilot")
	end

	-- See the FLAGGED INTERPRETATION block above ep3_fezrik_failed in
	-- mobile/conversations/space/neutral/kashyyyk_slaver/ep3_fezrik_bendledon_convo.lua: this is the
	-- best failure test the delivery screenplays make available, not a client-attested one.
	if (self:getFlag(pPlayer, EP3_FEZRIK_TAKEN_KEY) ~= 0) then
		return convoTemplate:getScreen("ep3_fezrik_failed")
	end

	return convoTemplate:getScreen("ep3_fezrik_greeting")
end

function Ep3FezrikBendledonConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_871 "Not a problem. I will make your deliveries." lands on ep3_fezrik_accept.
	-- THE RE-GRANT. s_843 "Let me make it up to you." lands on ep3_fezrik_retry, and s_845 restates
	-- the whole Naboo -> Corellia -> Lok route, so the head is what gets handed out again.
	if (screenID == "ep3_fezrik_accept" or screenID == "ep3_fezrik_retry") then
		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254); the ownerId is never
		-- released, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the
		-- journal write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops on a
		-- completed quest while everything around it still fires -- the datapad mission object is created
		-- (:981), "Mission Received" is sent (:1023) and the fanfare plays (:1025).
		--
		-- EVERY COMPLETED LEG IS RELEASED, NOT JUST THE HEAD. This is a four-leg chain that the
		-- screenplays drive themselves: each leg carries sideQuestSplitType = COMPLETION, so leg N's
		-- completeQuest is what fires leg N+1's startQuest (SpaceDeliveryScreenplay.lua:66-74). The
		-- stuck state that reaches ep3_fezrik_retry is "some prefix of the chain is complete, nothing is
		-- active, EP3_FEZRIK_4 is not complete" -- e.g. legs 01 and 02 done, leg 03 failed. Clearing only
		-- the head is not enough: the re-granted leg 01 would run and complete, its COMPLETION split
		-- would call startQuest on leg 02, and leg 02 is still sitting there completed with its ownerId
		-- set, so its activation no-ops and the chain dies one leg further along with nothing to show for
		-- it. Whatever prefix is complete has to be released in one pass, here, before the head goes out.
		--
		-- reset + clear, in that order, is the shipped house move for exactly this, copied from
		-- RsfSquadronScreenplay:resetDingeQuests (RsfSquadronScreenplay.lua:1841-1879). resetQuest for
		-- legs 01-03 is SpaceDeliveryScreenplay:resetQuest (SpaceDeliveryScreenplay.lua:191-212, reached
		-- by inheritance -- SpaceDeliveryNoPickupScreenplay only overrides data fields): it fails the
		-- quest silently (failSpaceQuest with notifyClient false, which reaches clearJournalQuest at
		-- space_helpers.lua:1105 and so does release the ownerId), drops the waypoint, drops the
		-- ZONESWITCHED observer and runs cleanUpQuestData. Leg 04 is a SpaceSurpriseAttackScreenplay
		-- (KashyyykSlaverScreenplay.lua:546) and its resetQuest is the same shape plus the kill counter.
		-- clearSpaceQuest is then a no-op that matches the precedent.
		--
		-- EACH LEG IS GUARDED ON ITS OWN COMPLETED STATE ON PURPOSE. Both ids reach here with no leg
		-- active (getInitialScreen:102-104 sends any in-flight leg to ep3_fezrik_busy), and every failure
		-- and abandon path runs SpaceHelpers:failSpaceQuest, which clears the journal entry -- so a failed
		-- leg already has ownerId 0 by isJournalQuestActive/isJournalQuestComplete
		-- (PlayerObjectImplementation.cpp:3374-3387). Those legs are not reset. On a first grant
		-- (ep3_fezrik_accept) no guard fires at all.
		--
		-- LEG 04's GUARD IS DEFENSIVE, NOT LIVE. Neither id is reachable with leg 04 complete:
		-- getInitialScreen:93-99 returns ep3_fezrik_complete/ep3_fezrik_thanks in that case, and
		-- ep3_fezrik_retry hangs only off ep3_fezrik_failed (ep3_fezrik_bendledon_convo.lua:172). It is
		-- kept so the release covers the whole chain by construction rather than by that reachability
		-- argument holding forever.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_FEZRIK_1.type, EP3_FEZRIK_1.name)) then
			delivery_no_pickup_ep3_trando_fezrik_01:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_FEZRIK_1.type, EP3_FEZRIK_1.name, false)
		end

		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_FEZRIK_2.type, EP3_FEZRIK_2.name)) then
			delivery_no_pickup_ep3_trando_fezrik_02:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_FEZRIK_2.type, EP3_FEZRIK_2.name, false)
		end

		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_FEZRIK_3.type, EP3_FEZRIK_3.name)) then
			delivery_no_pickup_ep3_trando_fezrik_03:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_FEZRIK_3.type, EP3_FEZRIK_3.name, false)
		end

		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_FEZRIK_4.type, EP3_FEZRIK_4.name)) then
			destroy_surpriseattack_ep3_trando_fezrik_04:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_FEZRIK_4.type, EP3_FEZRIK_4.name, false)
		end

		-- grant() is the shared shape (see the comment on it, and Ep3CpgVeteranConvoHandler:grant()) and
		-- is left alone. With the clears above, the head is neither active nor complete when startQuest
		-- runs, so grant()'s "or isSpaceQuestComplete" arm can no longer return true vacuously and a true
		-- return is now a real activation on both ids.
		if (self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_trando_fezrik_01, EP3_FEZRIK_1)) then
			self:setFlag(pPlayer, EP3_FEZRIK_TAKEN_KEY, 1)
		end

	-- s_839 is the payoff line. The delivery and surprise-attack screenplays already pay their own
	-- creditReward per leg and no extra figure is attested anywhere, so this latches only: the next
	-- hail gets s_1732, the client's own "nothing more for you to do" ending.
	elseif (screenID == "ep3_fezrik_complete") then
		self:setFlag(pPlayer, EP3_FEZRIK_TAKEN_KEY, 2)
	end

	return pScreenClone
end

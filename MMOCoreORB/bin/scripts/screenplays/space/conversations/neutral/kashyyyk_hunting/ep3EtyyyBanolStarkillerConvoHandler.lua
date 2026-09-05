--[[
	Banol Starkiller -- the ground giver for the two Kashyyyk hunting quest heads that had no giver:

		assassinate/ep3_hunting_banol_destroy_tripps_goods   (head, questZone space_kashyyyk)
		recovery/ep3_hunting_banol_capture_fordan            (head, questZone space_kashyyyk)

	Both globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua (lines 338/376 and
	378/441). That file is included by screenplays/space/screenplays.lua before this one, so both
	globals are loaded by the time this handler runs.

	Neither quest has a parent and neither has a side quest (sideQuest = false on both), so this
	conversation is their only entry point and their only retry point. The two are chained here in
	conversation, not by the engine, exactly as the .stf chains them: s_526 "You did pretty good taking
	out Tripp's latest shipment... Any interest in another little project?" is the Fordan pitch and it
	only exists after the shipment job.

	Ground screens and java OnStartNpcConversation order folded in. ruling 2026-09-04.
	NO JOURNAL: do not call the journal engine.
]]

Ep3EtyyyBanolStarkillerConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questType/questName, lines 341-342 and 381-382).
EP3_BANOL_SHIPMENT = {type = "assassinate", name = "ep3_hunting_banol_destroy_tripps_goods"}
EP3_BANOL_FORDAN = {type = "recovery", name = "ep3_hunting_banol_capture_fordan"}

EP3_BANOL_SHIPMENT_TAKEN_KEY = ":ep3_banol:shipment_taken" -- has ever accepted the shipment job
EP3_BANOL_FORDAN_TAKEN_KEY = ":ep3_banol:fordan_taken"     -- has ever accepted the Fordan capture
EP3_BANOL_FORDAN_PITCHED_KEY = ":ep3_banol:fordan_pitched" -- has been shown the s_526 Fordan pitch
EP3_BANOL_SORDAAN_KEY = ":ep3_sordaan_xris:referred"       -- nothing writes this yet; see below

--[[
	FLAGGED INTERPRETATION -- THE SORDAAN REFERRAL, and the one switch that reverts it.

	s_556 opens "Sordaan wanted me to throw some work your way", and s_570 is the brush-off for anyone
	Sordaan has not sent. Honouring that gate needs an ep3_sordaan_xris conversation to write
	EP3_BANOL_SORDAAN_KEY. No such conversation exists anywhere in this repo -- his .stf ships 162
	entries of an unbuilt ground chain -- so enforcing the gate today would make both of Banol's space
	quests permanently unreachable, which is the exact defect this file was written to fix.

	So the gate is present and OFF. Flip this one constant to true the day Sordaan Xris is built and
	writes that key, and ep3_banol_brushoff becomes live with no other change.
]]
BANOL_REQUIRE_SORDAAN_REFERRAL = false

function Ep3EtyyyBanolStarkillerConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyBanolStarkillerConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). Neither quest name contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to either; the
-- re-check is kept anyway so a refused grant leaves no residue.
function Ep3EtyyyBanolStarkillerConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyBanolStarkillerConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyBanolStarkillerConvoHandler:alreadyHasSpaceQuest(pPlayer)
	return EtyyyHuntState:hasAnySpaceQuest(pPlayer)
end

function Ep3EtyyyBanolStarkillerConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- ep3_etyyy_banol_starkiller.java OnStartNpcConversation:512-758
	if (EtyyyHuntState:spaceFailed(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods") or (self:getFlag(pPlayer, EP3_BANOL_SHIPMENT_TAKEN_KEY) == 1 and not SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_BANOL_SHIPMENT.type, EP3_BANOL_SHIPMENT.name) and not SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BANOL_SHIPMENT.type, EP3_BANOL_SHIPMENT.name))) then
		return convoTemplate:getScreen("s_486")
	elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods") and (SpaceHelpers:isSpaceQuestComplete(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan") or EtyyyHuntState:spaceFailed(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan"))) then
		return convoTemplate:getScreen("s_496")
	elseif (EtyyyHuntState:spaceFailed(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan") or (self:getFlag(pPlayer, EP3_BANOL_FORDAN_TAKEN_KEY) == 1 and not SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_BANOL_FORDAN.type, EP3_BANOL_FORDAN.name) and not SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BANOL_FORDAN.type, EP3_BANOL_FORDAN.name))) then
		return convoTemplate:getScreen("s_506")
	elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan")) then
		return convoTemplate:getScreen("s_516")
	elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods")) then
		return convoTemplate:getScreen("s_526")
	elseif (EtyyyHuntState:canDoBanol(pPlayer)) then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("greet")
		end
		return convoTemplate:getScreen("s_556")
	end
	return convoTemplate:getScreen("s_570")
end

function Ep3EtyyyBanolStarkillerConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "s_520" or screenID == "s_546" or screenID == "s_564") then
		if (self:alreadyHasSpaceQuest(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_752")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, assassinate_ep3_hunting_banol_destroy_tripps_goods, "assassinate", "ep3_hunting_banol_destroy_tripps_goods")
		self:setFlag(pPlayer, EP3_BANOL_SHIPMENT_TAKEN_KEY, 1)
	elseif (screenID == "s_534") then
		if (self:alreadyHasSpaceQuest(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_752")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods", false)
		SpaceHelpers:clearSpaceQuest(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, recovery_ep3_hunting_banol_capture_fordan, "recovery", "ep3_hunting_banol_capture_fordan")
		self:setFlag(pPlayer, EP3_BANOL_FORDAN_TAKEN_KEY, 1)
	-- THE SHIPMENT GRANT. Four shipped accept points all land on the same quest.
	elseif (screenID == "ep3_banol_accept" or screenID == "ep3_banol_retry"
		or screenID == "ep3_banol_reoffer_accept" or screenID == "ep3_banol_fordan_failed_accept"
		or screenID == "ep3_banol_praise_accept" or screenID == "ep3_banol_else_accept") then

		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_banol_no_space")
		end

		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254); the ownerId is never
		-- released, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the
		-- journal write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops on a
		-- completed quest while everything around it still fires -- the datapad mission object is created
		-- (:981), "Mission Received" is sent (:1023) and the fanfare plays (:1025). The shipment job is a
		-- repeatable offer that is reached from the completed state by design, so without this it hands
		-- out a phantom mission every time and can never be completed again (completeSpaceQuest bails at
		-- space_helpers.lua:1045 on not-active).
		--
		-- ALL SIX ACCEPT IDS ARE COVERED, which is why this sits inside the same if. Four of them are
		-- reachable with the shipment already complete: ep3_banol_praise_accept off ep3_banol_fordan_praise
		-- (getInitialScreen:108-110), ep3_banol_fordan_failed_accept off ep3_banol_fordan_failed (:114-116),
		-- ep3_banol_reoffer_accept off ep3_banol_reoffer (:122-124), and ep3_banol_else_accept off the
		-- ep3_banol_fordan_intro -> fordan_decline -> ep3_banol_else run (:126) -- that last one is the
		-- ordinary first-playthrough path, not an edge case. ep3_banol_accept and ep3_banol_retry come in
		-- on a not-complete shipment and the guard below simply does not fire for them.
		--
		-- IT SITS AFTER THE canFly EARLY RETURN ON PURPOSE. A player who is brushed off to
		-- ep3_banol_no_space gets no quest, so their journal must not be touched.
		--
		-- reset + clear, in that order, is the shipped house move for exactly this, copied from
		-- RsfSquadronScreenplay:resetDingeQuests (RsfSquadronScreenplay.lua:1841-1879). resetQuest is
		-- SpaceAssassinateScreenplay:resetQuest (SpaceAssassinateScreenplay.lua:135-166) -- the shipment
		-- job is a SpaceAssassinateScreenplay (KashyyykHuntingScreenplay.lua:338): it fails the quest
		-- silently (failSpaceQuest with notifyClient false, which reaches clearJournalQuest at
		-- space_helpers.lua:1105 and so does release the ownerId), drops the waypoint, drops the
		-- ZONESWITCHED observer, despawns the target ships and cancels the fail event. clearSpaceQuest is
		-- then a no-op that matches the precedent.
		--
		-- GUARDED ON THE COMPLETED STATE ON PURPOSE. On a first grant, and on ep3_banol_retry after a
		-- shipment failure, the quest is neither active nor complete, which by isJournalQuestActive/
		-- isJournalQuestComplete (PlayerObjectImplementation.cpp:3374-3387) means ownerId is already 0 --
		-- every failure and abandon path runs SpaceHelpers:failSpaceQuest, which clears the journal entry.
		-- Those paths must not be reset, and are not.
		--
		-- EP3_BANOL_FORDAN IS NOT TOUCHED HERE. Its own grant below is already correct: s_506 says Fordan
		-- is gone for good, getInitialScreen never re-offers the recovery quest, and a completed Fordan
		-- slot is exactly what :108 reads to hand out ep3_banol_fordan_praise.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BANOL_SHIPMENT.type, EP3_BANOL_SHIPMENT.name)) then
			assassinate_ep3_hunting_banol_destroy_tripps_goods:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_BANOL_SHIPMENT.type, EP3_BANOL_SHIPMENT.name, false)
		end

		-- grant() is the shared shape (see the comment on it, and Ep3CpgVeteranConvoHandler:grant()) and
		-- is left alone. With the clear above, the shipment is neither active nor complete when startQuest
		-- runs, so grant()'s "or isSpaceQuestComplete" arm can no longer return true vacuously and a true
		-- return is now a real activation on all six ids.
		if (self:grant(pPlayer, pNpc, assassinate_ep3_hunting_banol_destroy_tripps_goods, EP3_BANOL_SHIPMENT)) then
			self:setFlag(pPlayer, EP3_BANOL_SHIPMENT_TAKEN_KEY, 1)

			-- Taking the shipment job again puts the Fordan pitch back on the table for when it lands.
			if (screenID == "ep3_banol_reoffer_accept" or screenID == "ep3_banol_else_accept") then
				self:setFlag(pPlayer, EP3_BANOL_FORDAN_PITCHED_KEY, 0)
			end
		end

	-- THE FORDAN GRANT. s_532 "I'll do it." lands on ep3_banol_fordan_accept.
	elseif (screenID == "ep3_banol_fordan_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_banol_no_space")
		end

		if (self:grant(pPlayer, pNpc, recovery_ep3_hunting_banol_capture_fordan, EP3_BANOL_FORDAN)) then
			self:setFlag(pPlayer, EP3_BANOL_FORDAN_TAKEN_KEY, 1)
		end

	-- The Fordan job has now been put to the player; latch it either way so he does not repeat the
	-- pitch at every hail.
	elseif (screenID == "ep3_banol_fordan_intro" or screenID == "ep3_banol_fordan_brush"
		or screenID == "ep3_banol_fordan_decline") then
		self:setFlag(pPlayer, EP3_BANOL_FORDAN_PITCHED_KEY, 1)
	end

	return pScreenClone
end

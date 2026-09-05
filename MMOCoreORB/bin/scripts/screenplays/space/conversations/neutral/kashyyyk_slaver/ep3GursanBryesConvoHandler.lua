--[[
	Gursan Bryes -- the ground giver for the three Kashyyyk slaver-file quest heads that had no giver:

		assassinate/ep3_slaver_trando_reinforcement_intercept   (questZone space_tatooine)
		space_battle/ep3_slaver_khrask_space_battle             (questZone space_kashyyyk)
		space_battle/ep3_slaver_khrask_space_battle_alt         (questZone space_kashyyyk, repeatable)

	All three globals live in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua (lines 285, 131
	and 167; className/questName/questType directly beneath each). That file is included by
	screenplays/space/screenplays.lua before this one, so the globals are loaded by the time this
	handler runs.

	Before this file nothing in the repo handed any of the three out. None of them declares a
	parentQuest, and nothing else names any of them as a sideQuest, so nothing chained them either.

	Each DOES declare a sideQuest of its own -- space_battle/ep3_slaver_hsskas_space_battle off the
	intercept, assassinate/ep3_slaver_lord_cyssc_final off the Cyssc ambush, and
	assassinate/ep3_slaver_lord_cyssc_alt off the repeatable variant. All three fire from
	SpaceQuestLogic.lua:128 and need nothing here.

	ORDERING IS ENFORCED HERE, NOT BY parentQuest. Every Space*Screenplay uses parentQuest only as a
	fail-cascade (createEvent(200, ..., "failQuest", ...)); it starts nothing and gates nothing. So the
	client's own ordering is enforced in getInitialScreen below:

	  * Kymayrr's space_battle/ep3_slaver_rhosk_space_battle gates leg 1, because his own opener s_858
	    reads "With the loss of Adjutant Rhosk, Avatar Platform has been shaken up" and because
	    ep3_kymayrr:s_313 is what sends the player to him ("My friend Gursan Bryes who stays in the
	    huts below will brief you on what our future plans are").
	  * Leg 1 gates leg 2. FLAGGED INTERPRETATION -- see the convo file header: the client's stated
	    order is Tatooine intercept -> Blackscale Compound -> false plea -> Cyssc ambush (s_830 "With
	    both Rhosk and Hss'kas gone Warden Tosk is sure to know something is up"), but the two middle
	    ground steps were never shipped as quests in this repo, so the ladder is collapsed onto the
	    space legs that exist. The relative order is client fact; the collapsing is ours.
	  * Leg 2 gates leg 3, the repeatable variant, whose own opener s_38 reads "It looks like you are
	    not the only one returning to Kashyyyk."

	FLAGGED INTERPRETATION -- s_872 AS THE FLIGHT GATE AND THE NOT-YET-UNLOCKED SCREEN. See the convo
	file header. s_872 "Move along, I have important matters to attend." is his only brush-off, so it
	carries both roles.

	NO FAILURE LATCHES, DELIBERATELY. He ships no failure line and no retry line for any leg, so a
	player who took one and no longer holds it simply walks that pitch again. Only the two DEBRIEFED
	latches below exist, and they exist only because he ships a distinct thank-you screen per leg that
	must not repeat forever.

	REACHABILITY, STATED PLAINLY. ep3_gursan_bryes is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of those
	are addressed.
]]

Ep3GursanBryesConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim.
EP3_GURSAN_INTERCEPT = {type = "assassinate", name = "ep3_slaver_trando_reinforcement_intercept"}
EP3_GURSAN_CYSSC = {type = "space_battle", name = "ep3_slaver_khrask_space_battle"}
EP3_GURSAN_ALT = {type = "space_battle", name = "ep3_slaver_khrask_space_battle_alt"}

-- The repeatable variant's split child. Reset only -- SpaceBattleScreenplay:completeQuest:112-120 owns
-- the grant, off the sideQuest declaration at KashyyykSlaverScreenplay.lua:177-181.
EP3_GURSAN_ALT_SIDE = {type = "assassinate", name = "ep3_slaver_lord_cyssc_alt"}

-- Kymayrr's battle. Read only -- Ep3KymayrrConvoHandler owns the grant.
EP3_GURSAN_RHOSK_GATE = {type = "space_battle", name = "ep3_slaver_rhosk_space_battle"}

EP3_GURSAN_CYSSC_DEBRIEFED_KEY = ":ep3_gursan:cyssc_debriefed"
EP3_GURSAN_ALT_DEBRIEFED_KEY = ":ep3_gursan:alt_debriefed"

function Ep3GursanBryesConvoHandler:getFlag(pPlayer, key)
	if (pPlayer == nil) then
		return false
	end

	return readData(SceneObject(pPlayer):getObjectID() .. key) == 1
end

function Ep3GursanBryesConvoHandler:setFlag(pPlayer, key)
	if (pPlayer == nil) then
		return
	end

	writeData(SceneObject(pPlayer):getObjectID() .. key, 1)
end

function Ep3GursanBryesConvoHandler:clearFlag(pPlayer, key)
	if (pPlayer == nil) then
		return
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. key)
end

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of these three names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3GursanBryesConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3GursanBryesConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3GursanBryesConvoHandler:isActive(pPlayer, quest)
	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
end

function Ep3GursanBryesConvoHandler:isComplete(pPlayer, quest)
	return SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3GursanBryesConvoHandler:entryActive(pPlayer)
	return slaverGursanEntryQuestScreenPlay ~= nil and slaverGursanEntryQuestScreenPlay:getStage(pPlayer) > 0
end

function Ep3GursanBryesConvoHandler:entryCanGrant(pPlayer)
	return slaverGursanEntryQuestScreenPlay ~= nil and slaverGursanEntryQuestScreenPlay:canGrantQuest(pPlayer)
end

function Ep3GursanBryesConvoHandler:entryFinished(pPlayer)
	return slaverGursanEntryQuestScreenPlay ~= nil
		and slaverGursanEntryQuestScreenPlay:getStage(pPlayer) == 0
		and slaverGursanEntryQuestScreenPlay:getRuns(pPlayer) > 0
end

function Ep3GursanBryesConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- java OnStartNpcConversation order (ep3_gursan_bryes.java:972-1283). Space screens that
	-- already wrap a java key are returned by their existing ids; compound-only keys use the
	-- java screen ids added to this template.

	-- haveWonRepeatCyssc
	if (self:isComplete(pPlayer, EP3_GURSAN_ALT_SIDE) or (self:isComplete(pPlayer, EP3_GURSAN_ALT) and not self:getFlag(pPlayer, EP3_GURSAN_ALT_DEBRIEFED_KEY))) then
		return convoTemplate:getScreen("ep3_gursan_alt_done")
	end

	-- cysscTimerActive (debrief latch stands in for the daily objVar)
	if (self:isComplete(pPlayer, EP3_GURSAN_ALT) and self:getFlag(pPlayer, EP3_GURSAN_ALT_DEBRIEFED_KEY)) then
		return convoTemplate:getScreen("ep3_gursan_alt_reoffer")
	end

	-- canRepeatCyssc (java also requires the alt quests are not currently held)
	if (self:isComplete(pPlayer, EP3_GURSAN_CYSSC) and self:getFlag(pPlayer, EP3_GURSAN_CYSSC_DEBRIEFED_KEY)
		and not self:isActive(pPlayer, EP3_GURSAN_ALT) and not self:isActive(pPlayer, EP3_GURSAN_ALT_SIDE)) then
		return convoTemplate:getScreen("ep3_gursan_alt_offer")
	end

	-- hasDefeatedCysscSpace
	if (self:isComplete(pPlayer, EP3_GURSAN_CYSSC) and not self:isActive(pPlayer, EP3_GURSAN_ALT) and not self:isActive(pPlayer, EP3_GURSAN_ALT_SIDE)) then
		return convoTemplate:getScreen("ep3_gursan_cyssc_done")
	end

	-- hasCysscSpaceSeries
	if (self:isActive(pPlayer, EP3_GURSAN_ALT) or self:isActive(pPlayer, EP3_GURSAN_CYSSC) or self:isActive(pPlayer, EP3_GURSAN_ALT_SIDE)) then
		return convoTemplate:getScreen("ep3_gursan_cyssc_active")
	end

	if (self:isActive(pPlayer, EP3_GURSAN_INTERCEPT)) then
		return convoTemplate:getScreen("ep3_gursan_brushoff")
	end

	-- canCompleteSignalQuest
	if (self:isComplete(pPlayer, EP3_GURSAN_INTERCEPT) and self:entryFinished(pPlayer)) then
		return convoTemplate:getScreen("ep3_gursan_cyssc_offer")
	end

	-- isSignalQuestActive
	if (self:isComplete(pPlayer, EP3_GURSAN_INTERCEPT) and (self:entryCanGrant(pPlayer) or self:entryActive(pPlayer))) then
		return convoTemplate:getScreen("s_816")
	end

	-- hasWonHsskasSpaceQuest
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, "space_battle", "ep3_slaver_hsskas_space_battle")) then
		return convoTemplate:getScreen("s_852")
	end

	-- hasRescuedRroot
	if (self:isComplete(pPlayer, EP3_GURSAN_RHOSK_GATE)) then
		return convoTemplate:getScreen("ep3_gursan_intercept_offer")
	end

	return convoTemplate:getScreen("ep3_gursan_brushoff")
end

function Ep3GursanBryesConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "ep3_gursan_intercept_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_gursan_brushoff")
		end

		-- Same completed-slot phantom as leg 3 below (see that comment for the C++ chapter and verse):
		-- completeJournalQuest never releases the ownerId (PlayerObjectImplementation.cpp:3236-3254), so a
		-- completed quest cannot be re-activated and the grant becomes a datapad-only phantom. Leg 1's own
		-- head is safe -- getInitialScreen:158-164 sends an active or completed player elsewhere, so this
		-- screenID is only reachable with EP3_GURSAN_INTERCEPT neither active nor complete -- but its split
		-- child is not.
		--
		-- THE CHILD. assassinate/ep3_slaver_trando_reinforcement_intercept declares sideQuest
		-- space_battle/ep3_slaver_hsskas_space_battle, BIDIRECTIONAL (KashyyykSlaverScreenplay.lua:297-301),
		-- so SpaceAssassinateScreenplay:completeQuest fires its startQuest on every completion of this leg.
		-- A player can reach this offer with that child sitting completed from a previous pass -- leg 1
		-- itself failed or was cleared while the child had already been finished -- and the child's ownerId
		-- sticks, so the next completion of leg 1 would split into a phantom one layer down.
		--
		-- UNCONDITIONAL ON PURPOSE, and it is the house shape: KashyyykSlaverScreenplay:resetHsskasQuests
		-- (KashyyykSlaverScreenplay.lua:897-907) resets this same global that way. Complete, still active and
		-- never started all want the same clean slate and all three are safe -- SpaceBattleScreenplay:resetQuest
		-- (SpaceBattleScreenplay.lua:169-189) reaches SpaceHelpers:failSpaceQuest
		-- (space_helpers.lua:1070-1108), which carries no active/complete guard; clearJournalQuest
		-- early-returns on ownerId == 0 (PlayerObjectImplementation.cpp:3259) and failQuestMission no-ops
		-- with nothing to remove.
		--
		-- ONLY THE CHILD. Leg 1's completed slot is what getInitialScreen:162-164 reads to open leg 2, so
		-- clearing the head would walk the player back down the ladder.
		space_battle_ep3_slaver_hsskas_space_battle:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "space_battle", "ep3_slaver_hsskas_space_battle", false)

		self:grant(pPlayer, pNpc, assassinate_ep3_slaver_trando_reinforcement_intercept, EP3_GURSAN_INTERCEPT)
	elseif (screenID == "ep3_gursan_cyssc_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_gursan_brushoff")
		end

		-- Same completed-slot phantom as leg 3 below (see that comment for the C++ chapter and verse):
		-- completeJournalQuest never releases the ownerId (PlayerObjectImplementation.cpp:3236-3254), so a
		-- completed quest cannot be re-activated and the grant becomes a datapad-only phantom. Leg 2's own
		-- head is safe -- getInitialScreen:144-154 sends an active or completed player elsewhere, so this
		-- screenID is only reachable with EP3_GURSAN_CYSSC neither active nor complete -- but its split
		-- child is not.
		--
		-- THE CHILD. space_battle/ep3_slaver_khrask_space_battle declares sideQuest
		-- assassinate/ep3_slaver_lord_cyssc_final, BIDIRECTIONAL (KashyyykSlaverScreenplay.lua:141-145), so
		-- SpaceBattleScreenplay:completeQuest fires its startQuest on every completion of this leg. A player
		-- can reach this offer with that child sitting completed from a previous pass -- leg 2 itself failed
		-- or was cleared while the child had already been finished -- and the child's ownerId sticks, so the
		-- next completion of leg 2 would split into a phantom one layer down.
		--
		-- UNCONDITIONAL ON PURPOSE, and it is the house shape: KashyyykSlaverScreenplay:resetCysscQuests
		-- (KashyyykSlaverScreenplay.lua:881-895) resets this same global that way. Complete, still active and
		-- never started all want the same clean slate and all three are safe --
		-- SpaceAssassinateScreenplay:resetQuest (SpaceAssassinateScreenplay.lua:135-165) reaches
		-- SpaceHelpers:failSpaceQuest (space_helpers.lua:1070-1108), which carries no active/complete guard;
		-- clearJournalQuest early-returns on ownerId == 0 (PlayerObjectImplementation.cpp:3259) and
		-- failQuestMission no-ops with nothing to remove.
		--
		-- ONLY THE CHILD. Legs 1 and 2 are one-shot and getInitialScreen reads their completed slots to know
		-- the ladder position, so clearing either would walk the player back down it.
		assassinate_ep3_slaver_lord_cyssc_final:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "assassinate", "ep3_slaver_lord_cyssc_final", false)

		self:grant(pPlayer, pNpc, space_battle_ep3_slaver_khrask_space_battle, EP3_GURSAN_CYSSC)
	elseif (screenID == "ep3_gursan_alt_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_gursan_brushoff")
		end

		-- The variant is repeatable, so the previous run's debrief latch has to come off with it or
		-- the next completion would skip straight back to the re-offer.
		self:clearFlag(pPlayer, EP3_GURSAN_ALT_DEBRIEFED_KEY)

		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254); the ownerId is never
		-- released, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the
		-- journal write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops on a
		-- completed quest while everything around it still fires -- the datapad mission object is created
		-- (:981), "Mission Received" is sent (:1023) and the fanfare plays (:1025). This leg is the one
		-- that gets hit hardest by it: getInitialScreen:131-137 hands a completed-and-debriefed player
		-- ep3_gursan_alt_reoffer, whose only option (s_39, ep3_gursan_bryes_convo.lua:206) lands right
		-- here, so without this the repeat option is an unbounded phantom-mission dispenser and the
		-- variant can never be completed again (completeSpaceQuest bails at space_helpers.lua:1045 on
		-- not-active).
		--
		-- reset + clear, in that order, is the shipped house move for exactly this, copied from
		-- RsfSquadronScreenplay:resetDingeQuests (RsfSquadronScreenplay.lua:1841-1879). resetQuest is
		-- SpaceBattleScreenplay:resetQuest (SpaceBattleScreenplay.lua:169-189) -- the alt variant is a
		-- SpaceBattleScreenplay (KashyyykSlaverScreenplay.lua:167): it fails the quest silently
		-- (failSpaceQuest with notifyClient false, which reaches clearJournalQuest at
		-- space_helpers.lua:1105 and so does release the ownerId), drops the waypoint, drops the
		-- ZONESWITCHED observer and runs cleanUpQuestData. clearSpaceQuest is then a no-op that matches
		-- the precedent.
		--
		-- GUARDED ON THE COMPLETED STATE ON PURPOSE. The first grant of this leg comes in on the same
		-- screenID from ep3_gursan_alt_offer (leg 2 complete + debriefed, getInitialScreen:144-147) with
		-- the variant neither active nor complete, and this NPC ships no failure or abandon line at all,
		-- so every other way of arriving here has already run failSpaceQuest -> clearJournalQuest and the
		-- ownerId is already 0. Those paths are not reset.
		--
		-- NOTHING ELSE IS RESET HERE. This screenID is only reachable with EP3_GURSAN_ALT not active
		-- (that returns ep3_gursan_cyssc_active), and legs 1 and 2 are one-shot -- their completed slots
		-- are what getInitialScreen reads to know the ladder position, so clearing them would walk the
		-- player back down it.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_GURSAN_ALT.type, EP3_GURSAN_ALT.name)) then
			space_battle_ep3_slaver_khrask_space_battle_alt:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_GURSAN_ALT.type, EP3_GURSAN_ALT.name, false)

			-- The split child needs the same release. This variant declares sideQuest
			-- assassinate/ep3_slaver_lord_cyssc_alt (KashyyykSlaverScreenplay.lua:177-181), so
			-- SpaceBattleScreenplay:completeQuest:112-120 fires createEvent(... "startQuest" ...) on
			-- assassinate_ep3_slaver_lord_cyssc_alt (KashyyykSlaverScreenplay.lua:242-279) on every
			-- completion of the battle leg. That child's ownerId sticks for exactly the reason above, so
			-- from run two on it is a phantom of its own, one layer down; repairing the battle leg alone
			-- does not reach it.
			--
			-- UNCONDITIONAL INSIDE THIS GUARD ON PURPOSE. The enclosing completed-check IS the "this is a
			-- repeat run" condition, so the first-grant path is still untouched. Within a repeat run the
			-- child may be complete, still active (the player re-accepts while it is live) or never started
			-- (logged out inside the 10s sideQuestDelay window), and all three want the same clean slate.
			-- All three are safe, and unconditional is the house move: resetCysscQuests
			-- (KashyyykSlaverScreenplay.lua:881-895) resets all four Cyssc quests that way.
			-- SpaceAssassinateScreenplay:resetQuest (SpaceAssassinateScreenplay.lua:135-166) reaches
			-- SpaceHelpers:failSpaceQuest (space_helpers.lua:1070-1108), which carries no active/complete
			-- guard; clearJournalQuest early-returns on ownerId == 0 (PlayerObjectImplementation.cpp:3259)
			-- and failQuestMission no-ops with nothing to remove.
			--
			-- NOT resetCysscQuests(pPlayer) ITSELF. It also resets QUEST_STRING_CYSSC_1/_2
			-- (KashyyykSlaverScreenplay.lua:835-836), the one-shot Khrask -> Cyssc-final ladder, and
			-- getInitialScreen:139-150 above reads those completed slots to know the player's position on
			-- it, so clearing them would walk him back down. It is dead code besides -- its only caller is
			-- resetAllQuests (KashyyykSlaverScreenplay.lua:955-961), which has no callers repo-wide.
			assassinate_ep3_slaver_lord_cyssc_alt:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_GURSAN_ALT_SIDE.type, EP3_GURSAN_ALT_SIDE.name, false)
		end

		-- grant() is the shared shape (see the comment on it, and Ep3CpgVeteranConvoHandler:grant()) and
		-- is left alone. With the clear above, the variant is neither active nor complete when startQuest
		-- runs, so grant()'s "or isSpaceQuestComplete" arm can no longer return true vacuously.
		self:grant(pPlayer, pNpc, space_battle_ep3_slaver_khrask_space_battle_alt, EP3_GURSAN_ALT)
	elseif (screenID == "ep3_gursan_cyssc_debrief") then
		self:setFlag(pPlayer, EP3_GURSAN_CYSSC_DEBRIEFED_KEY)
	elseif (screenID == "ep3_gursan_alt_debrief") then
		self:setFlag(pPlayer, EP3_GURSAN_ALT_DEBRIEFED_KEY)
	elseif (screenID == "s_828") then
		if (slaverGursanEntryQuestScreenPlay ~= nil) then
			slaverGursanEntryQuestScreenPlay:grantQuest(pPlayer)
		end
	elseif (screenID == "s_856") then
		-- OPEN: grantQuest ep3_gursan_slay_hsskas is outside this arc
	end

	return pScreenClone
end

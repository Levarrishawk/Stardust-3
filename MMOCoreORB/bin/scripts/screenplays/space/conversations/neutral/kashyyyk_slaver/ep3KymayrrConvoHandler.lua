--[[
	Kymayrr -- the ground giver for the one Kashyyyk slaver-file quest head that had no giver:

		space_battle/ep3_slaver_rhosk_space_battle   (questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua (line 13,
	className/questName/questType at 14/16/17). That file is included by
	screenplays/space/screenplays.lua before this one, so the global is loaded by the time this
	handler runs.

	Before this file nothing in the repo handed it out. It declares no parentQuest, and nothing else
	names it as a sideQuest, so nothing chained it either.

	It DOES declare a sideQuest of its own -- destroy_surpriseattack/ep3_slaver_rhosk_surprise_attack,
	BIDIRECTIONAL, which is also its sideFailQuest -- and that in turn chains
	recovery/ep3_slaver_rhosk_recovery, the capture of Rhosk's transport. Both fire from
	SpaceQuestLogic.lua and need nothing here. This handler hands out the head of that chain only.

	THIS IS THE ROOT OF THE WHOLE BLACKSCALE SPACE ARC. Gursan Bryes's own shipped opener,
	ep3_gursan_bryes:s_858, begins "With the loss of Adjutant Rhosk, Avatar Platform has been shaken
	up" -- so Kymayrr's battle is what unlocks him. The ordering is enforced in
	Ep3GursanBryesConvoHandler, not here.

	FLAGGED INTERPRETATION -- s_382 AS THE STANDING SCREEN AND THE FLIGHT GATE. See the convo file
	header. She ships no dismissal aimed at a pilot and no failure line, so s_382 carries both roles
	and a player who no longer holds the battle simply walks the pitch again.

	REACHABILITY, STATED PLAINLY. ep3_kymayrr is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3KymayrrConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questName/questType at 16-17).
EP3_KYMAYRR_RHOSK = {type = "space_battle", name = "ep3_slaver_rhosk_space_battle"}

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). The quest name does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is
-- kept anyway so a refused grant leaves no residue.
function Ep3KymayrrConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3KymayrrConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3KymayrrConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KYMAYRR_RHOSK.type, EP3_KYMAYRR_RHOSK.name)) then
		return convoTemplate:getScreen("ep3_kymayrr_complete")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KYMAYRR_RHOSK.type, EP3_KYMAYRR_RHOSK.name)) then
		return convoTemplate:getScreen("ep3_kymayrr_standing")
	end

	return convoTemplate:getScreen("ep3_kymayrr_intro")
end

function Ep3KymayrrConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "ep3_kymayrr_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_kymayrr_standing")
		end

		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254) and never releases the
		-- ownerId, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the journal
		-- write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops while everything
		-- around it still fires -- the datapad mission object is created (:981), "Mission Received" is sent
		-- (:1023) and the fanfare plays (:1025). The head itself cannot be stuck here, getInitialScreen:65-71
		-- sends a completed or active player elsewhere, but its split descendants can be.
		--
		-- BOTH DESCENDANTS, NOT JUST THE FIRST. This head declares sideQuest
		-- destroy_surpriseattack/ep3_slaver_rhosk_surprise_attack, BIDIRECTIONAL
		-- (KashyyykSlaverScreenplay.lua:23-27), and that child in turn declares sideQuest
		-- recovery/ep3_slaver_rhosk_recovery, COMPLETION (KashyyykSlaverScreenplay.lua:56-60). Releasing only
		-- the child strands the grandchild one leg later -- the same argument the shipped Fezrik fix makes
		-- (ep3FezrikBendledonConvoHandler.lua:144-152).
		--
		-- reset + clear, in that order, is the shipped house move, and unconditional is the house shape:
		-- KashyyykSlaverScreenplay:resetRhoskQuests (KashyyykSlaverScreenplay.lua:867-879) resets these two
		-- same globals exactly that way. resetQuest is SpaceSurpriseAttackScreenplay:resetQuest
		-- (SpaceSurpriseAttackScreenplay.lua:115-136) and SpaceRecoveryScreenplay:resetQuest
		-- (SpaceRecoveryScreenplay.lua:194-223); both reach SpaceHelpers:failSpaceQuest
		-- (space_helpers.lua:1070-1108), which carries no active/complete guard. clearJournalQuest
		-- early-returns on ownerId == 0 (PlayerObjectImplementation.cpp:3259) and failQuestMission no-ops
		-- with nothing to remove, so the never-started case costs nothing.
		destroy_surpriseattack_ep3_slaver_rhosk_surprise_attack:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_surpriseattack", "ep3_slaver_rhosk_surprise_attack", false)
		recovery_ep3_slaver_rhosk_recovery:resetQuest(pPlayer)
		SpaceHelpers:clearSpaceQuest(pPlayer, "recovery", "ep3_slaver_rhosk_recovery", false)

		self:grant(pPlayer, pNpc, space_battle_ep3_slaver_rhosk_space_battle, EP3_KYMAYRR_RHOSK)
	end

	return pScreenClone
end

--[[
	Lolo -- the Kachirho weaponsmith, and the ground giver for the bowcaster space leg that had no
	giver:

		inspect/ep3_wke_bowcaster_crafting   "Kashyyyk System: Recover Missing Bowcaster Pieces"

	The global lives in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua and is registered
	there:

		inspect_ep3_wke_bowcaster_crafting   global line 694, registerScreenPlay line 725

	That file is included by screenplays/space/screenplays.lua at line 58, before this handler, so the
	global is loaded by the time this handler runs. In any case the reference below is inside a
	function body, so it resolves at call time, not at load time.

	Before this file nothing in the repo handed it out: it had zero :startQuest call sites, declares no
	parentQuest, declares no sideQuest, and is nobody's sideQuest. The rest of the leg was already
	complete -- the courier ship_mobile/ships/wke_resist_tier3_bowcaster_parts.lua carries the matching
	cargoString, inspectTargets names it, and space_kashyyyk_spawner.lua:197-199 spawns it -- so the
	grant was the single missing piece.

	THIS GRANTS ONE QUEST AND ONLY ONE. inspect_ep3_wke_bowcaster_crafting declares
	sideQuest = false and parentQuest = "", so nothing chains off it in either direction.

	WHY THIS LIVES UNDER kashyyyk_bowcaster/ AND NOT kashyyyk_hunting/. The repo groups ground givers
	by ARC, not by which screenplay file the quest global happens to sit in: Kkrax's quest is
	registered in KesselDutyScreenplay.lua but his files live under clone_relics/. This quest is
	registered in KashyyykHuntingScreenplay.lua only because that file collects the loose Kashyyyk
	space quests; Lolo is a Kachirho weaponsmith, not an Etyyy hunting-lodge contact, so he is not
	filed with the Etyyy givers.

	FLAGGED INTERPRETATION -- s_100 AS THE FLIGHT GATE. s_100 "Sorry...no time to talk. Work, work,
	work." is Lolo's only shipped brush-off and s_101/s_102 are its only shipped continuations. It is
	shown here to a player the handler can see cannot fly the leg at all -- JTL off, not a pilot, or no
	certified ship -- exactly the way Captain Koh's s_270 is used
	(ep3MiningCaptainKohConvoHandler.lua:127-129, 257-259). The text is client fact; the trigger is
	not. Deleting the canFly() branch in getInitialScreen removes this interpretation and nothing else.

	FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceInspectScreenplay leaves no distinguishable
	failure record a conversation can read, so a "took it once" latch is written on a successful grant
	and the shipped retry block (s_89 "No luck with that pilot? ... give it another shot?") is shown to
	anyone who once took it and now has it neither active nor complete. That cannot separate "failed
	it" from "abandoned it".

	FLAGGED INTERPRETATION -- WHEN THE REPEAT BLOCK REPLACES THE DEBRIEF. That the leg repeats is
	client fact: s_256 "Can I do that space part again?" / s_258 "Sure." ship in the .stf. What the
	client does not say is when Lolo stops saying s_88 ("Ah, you have the pieces") and starts saying
	s_254 ("There is nothing more that I can do for you"). Here the switch is a latch set when the
	player has read the full debrief through s_104. Removing the DEBRIEFED latch and always returning
	ep3_lolo_done would keep the quest reachable but would lose the repeat option.

	THE %TU NOTE. None of the ep3_kachirho_lolo keys used here carries %TU, but setDialogTextTU is
	called anyway to match every other handler in this directory; it is a no-op on text without the
	token.

	REACHABILITY, STATED PLAINLY. ep3_wke_lolo is not spawned anywhere in this repo -- grep finds the
	mobile name only in its own creature template, its object template and the two serverobjects.lua
	include lists -- there are no Kashyyyk ground spawn areas, and bin/conf/config.lua ZonesEnabled has
	no Kashyyyk ground zone at all (only SpaceZonesEnabled carries "space_kashyyyk"). No spawn is
	created here because no client attestation for Lolo's exact Kachirho coordinates was available to
	this pass. This handler is correct and INERT until a Kachirho spawn exists AND the Kashyyyk ground
	zone is enabled.
]]

Ep3WkeLoloConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questName/questType at 697-698).
EP3_LOLO_QUEST = {type = "inspect", name = "ep3_wke_bowcaster_crafting"}

EP3_LOLO_TAKEN_KEY = ":ep3_lolo:taken"
EP3_LOLO_DEBRIEFED_KEY = ":ep3_lolo:debriefed"

function Ep3WkeLoloConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3WkeLoloConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3MiningCaptainKohConvoHandler:grant() and Ep3CpgVeteranConvoHandler:grant(). The quest name does
-- not contain "_duty", so SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal
-- (space_helpers.lua) does not apply; the re-check is kept anyway so a refused grant leaves no
-- residue.
function Ep3WkeLoloConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3WkeLoloConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3WkeLoloConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Leg running: he has already said everything he knows and is waiting on the parts.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_LOLO_QUEST.type, EP3_LOLO_QUEST.name)) then
		return convoTemplate:getScreen("ep3_lolo_active")
	end

	-- Parts recovered. Once the debrief has been read through, s_254 (with the shipped repeat option)
	-- becomes his standing screen.
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_LOLO_QUEST.type, EP3_LOLO_QUEST.name)) then
		if (self:getFlag(pPlayer, EP3_LOLO_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_lolo_standing")
		end

		return convoTemplate:getScreen("ep3_lolo_done")
	end

	-- FLAGGED INTERPRETATION -- FLIGHT GATE. See the header. Checked after the quest-state screens so
	-- a pilot who took the leg and then lost the ship still gets an honest status hail instead of a
	-- brush-off.
	if (not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_lolo_busy")
	end

	-- Took it once, has it neither active nor complete.
	if (self:getFlag(pPlayer, EP3_LOLO_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_lolo_retry")
	end

	return convoTemplate:getScreen("ep3_lolo_greeting")
end

function Ep3WkeLoloConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- GRANT (s_97, first pass), RE-GRANT from the retry block (s_108) and RE-GRANT from the shipped
	-- repeat option (s_258).
	if (screenID == "ep3_lolo_accept" or screenID == "ep3_lolo_retry_yes" or screenID == "ep3_lolo_repeat") then
		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254); the ownerId is never
		-- released, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the
		-- journal write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops on a
		-- completed quest while everything around it still fires -- the datapad mission object is created
		-- (:981), "Mission Received" is sent (:1023) and the fanfare plays (:1025). The repeat option has
		-- to release the slot itself first or it hands out a phantom mission every time.
		--
		-- reset + clear, in that order, is the shipped house move for exactly this, copied from
		-- RsfSquadronScreenplay:resetDingeQuests (RsfSquadronScreenplay.lua:1841-1879). resetQuest is
		-- SpaceInspectScreenplay:resetQuest (SpaceInspectScreenplay.lua:157-177): it fails the quest
		-- silently (failSpaceQuest with notifyClient false, which reaches clearJournalQuest at
		-- space_helpers.lua:1105 and so does release the ownerId), drops the waypoint, and drops the
		-- ZONESWITCHED/INSPECTEDSHIP/SHIPDOCKED observers -- note completeQuest drops only ZONESWITCHED,
		-- so the other two are still live after a completion. clearSpaceQuest is then a no-op that
		-- matches the precedent.
		--
		-- GUARDED ON THE COMPLETED STATE ON PURPOSE. The other two ids reach here with the quest neither
		-- active nor complete, which by isJournalQuestActive/isJournalQuestComplete
		-- (PlayerObjectImplementation.cpp:3374-3387) means ownerId is already 0 -- every failure and
		-- abandon path runs SpaceHelpers:failSpaceQuest, which clears the journal entry. Those paths must
		-- not be reset, and are not.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_LOLO_QUEST.type, EP3_LOLO_QUEST.name)) then
			inspect_ep3_wke_bowcaster_crafting:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_LOLO_QUEST.type, EP3_LOLO_QUEST.name, false)
		end

		-- grant() is the shared shape (see the comment on it, and Ep3CpgVeteranConvoHandler:grant()) and
		-- is left alone. With the clear above, the quest is neither active nor complete when startQuest
		-- runs, so grant()'s "or isSpaceQuestComplete" arm can no longer return true vacuously and a true
		-- return is now a real activation on all three ids.
		if (self:grant(pPlayer, pNpc, inspect_ep3_wke_bowcaster_crafting, EP3_LOLO_QUEST)) then
			self:setFlag(pPlayer, EP3_LOLO_TAKEN_KEY, 1)

			-- A repeat run starts the debrief over.
			self:setFlag(pPlayer, EP3_LOLO_DEBRIEFED_KEY, 0)
		end

	-- s_104 is the end of the post-recovery debrief; seeing it hands Lolo his standing screen.
	elseif (screenID == "ep3_lolo_done_howto") then
		self:setFlag(pPlayer, EP3_LOLO_DEBRIEFED_KEY, 1)
	end

	return pScreenClone
end

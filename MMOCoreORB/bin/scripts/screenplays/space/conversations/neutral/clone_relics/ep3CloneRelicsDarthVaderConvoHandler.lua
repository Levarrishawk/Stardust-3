--[[
	Darth Vader -- the ground giver for the Clone Relics Jedi Starfighter space battles that had no
	giver:

		space_battle/ep3_clone_relics_jedi_starfighter_4   "Kashyyyk system: Defeating an invasion."

	The global lives in screenplays/space/squadrons/KashyyykMiningScreenplay.lua and is registered
	there:

		space_battle_ep3_clone_relics_jedi_starfighter_4   global line 497, registerScreenPlay line 535

	That file is included by screenplays/space/screenplays.lua at line 60, before this handler, so the
	global is loaded by the time this handler runs. In any case every reference below is inside a
	function body, so it resolves at call time, not at load time.

	Before this file nothing in the repo handed it out: it had zero :startQuest call sites and declares
	no parentQuest.

	WIRING THIS ONE GIVER REACHES TWO QUESTS, AND ONLY ONE GRANT IS CORRECT. jedi_starfighter_4
	declares sideQuestType = "space_battle", sideQuestName = "ep3_clone_relics_jedi_starfighter_5" with
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION
	(KashyyykMiningScreenplay.lua:509-513), so SpaceQuestLogic:triggerCompletionSplitQuest grants phase
	V on phase IV's completion after sideQuestDelay = 10 seconds. Phase V needs no giver of its own and
	must not be given one. jedi_starfighter_5 also declares
	parentQuest = "space_battle_ep3_clone_relics_jedi_starfighter_4" (line 558), which is a
	fail-cascade, not a gate.

	PHASES I, II AND III ARE NOT MISSING. They are GROUND quests
	(quest/ep3_clone_relics_jedi_starfighter_1.qst .. _3.qst) and this arc shares one phase counter
	across ground and space, so a space chain starting at index 4 is the correct shipped shape. Sibling
	arcs confirm it: clone_relics_boba_fett runs ground 1 / space 2 / space 3 / ground 4-7; the queen
	arc runs ground 1 / ground 2 / space 3. Do not author space legs 1-3.

	NO ITEM IS GRANTED HERE. quest/ep3_clone_relics_jedi_starfighter_4.qst rewards
	object/tangible/ship/crafted/chassis/jedi_starfighter_reward_deed.iff -- that is the GROUND quest's
	reward, not the space leg's. Vader's s_743 ("I'm providing you with my old star fighter") is the
	client's narration of that ground reward. The space screenplays define their own rewards
	(creditReward 20000 / 25000, itemReward {}) and nothing in this handler touches items.

	THE FACTION GATE IS ATTESTED. That this arc is Imperial-only is documented client/publisher fact,
	not an invention: the shipped walkthrough source labels the reward "Jedi Starfighter (Imperials
	Only)", and an SOE developer stated "There are no plans to change the Rebel/Imperial requirements
	for the Actis and ARC-170 quests". SpaceHelpers:isImperialPilot() (space_helpers.lua:266, which
	defers to CreatureObject:isImperialPilot()) implements that documented requirement.

	FLAGGED INTERPRETATION -- s_749 AS THE WRONG-FACTION LINE. The gate is attested; the LINE is the
	interpretation. s_749 "Wrong place to be lost..." is the only shipped line in the .stf that turns a
	stranger away, and the client names no trigger for it. It is shown here to anyone who is not an
	Imperial pilot -- which also catches non-pilots and neutral pilots, since isImperialPilot() is a
	single boolean and the .stf ships no separate "you are not a pilot" line. Deleting the
	ep3_vader_intruder branch removes this interpretation.

	FLAGGED INTERPRETATION -- s_21 AS THE BRUSH-OFF. s_21 "I have no use for you at the moment %TU, get
	back to your duties." is the only shipped "not now" line and the client names no trigger. It is
	used for an Imperial pilot who cannot presently fly the mission (JTL off or no certified ship) and
	as Vader's standing screen once the arc has been debriefed through s_718. Deleting the canFly()
	branch and the DEBRIEFED latch removes this interpretation.

	FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceBattleScreenplay leaves no distinguishable
	failure record a conversation can read, so a "took it once" latch is written on a successful grant
	and the shipped failure block (s_720 "I do not accept failure %TU.") is shown to anyone who once
	took phase IV and now has neither phase active nor complete. That cannot separate "failed it" from
	"abandoned it". The .stf's own s_724 is written for exactly that case: "there is still time to stop
	them".

	THE PHASE IV / PHASE V WINDOW IS NOT A CONVERSATION STATE. Between phase IV completing and phase V
	being granted there is a 10 second sideQuestDelay (KashyyykMiningScreenplay.lua:513) in which the
	player holds neither quest. getInitialScreen does NOT branch on it, because the player cannot be
	standing here during it: phase IV completes in space -- every completion path runs through
	SpaceBattleScreenplay's in-zone handlers under isSpaceQuestActive with the player flying in
	space_kashyyyk -- and Vader is a ground creature template (mobile/custom_content/ep3/
	ep3_clone_relics_darth_vader.lua, appearance object/mobile/darth_vader.iff), so
	NpcConversationStartCommand reaches him only through its isAiAgent() branch, which requires the
	same cell, 5 metres and line of sight. Nobody lands, travels to the Kachirho bunker and hails him
	inside 10 seconds.

	Branching on it anyway is what created the soft lock this file was fixed for. "phase IV complete"
	is not a window, it is an absorbing state: phase V's failQuest cascades to the parent
	(SpaceBattleScreenplay.lua:155-157) but phase IV's failQuest bails at :129-131 because phase IV is
	complete, not active, so phase IV keeps completedFlag = 1 forever. The same state is reached with
	no failure at all if the sideQuestDelay event is lost -- log out inside those 10 seconds and phase V
	never starts. Either way the player then holds neither phase, and the shipped failure/retry block
	(s_720 / s_722 -> s_724 "there is still time to stop them") is the only screen that can get them
	moving again, so nothing may sit in front of it.

	REACHABILITY, STATED PLAINLY. Nothing spawns a Clone Relics Vader anywhere in this repo, there are
	no Kashyyyk ground spawn areas, and bin/conf/config.lua ZonesEnabled has no Kashyyyk ground zone at
	all (only SpaceZonesEnabled carries "space_kashyyyk"). No spawn is created here: the .qst says
	"downstairs in the Imperial bunker" but ships no coordinates, and this pass had no client
	attestation for an exact Kachirho bunker cell. This handler is correct and INERT until a spawn
	exists AND the Kashyyyk ground zone is enabled.
]]

Ep3CloneRelicsDarthVaderConvoHandler = conv_handler:new {}

-- Copied from KashyyykMiningScreenplay.lua verbatim (questName/questType at 500-501 and 546-547).
EP3_VADER_QUEST_4 = {type = "space_battle", name = "ep3_clone_relics_jedi_starfighter_4"}
-- Read only. Phase V is auto-granted by the COMPLETION split; this handler never grants it.
EP3_VADER_QUEST_5 = {type = "space_battle", name = "ep3_clone_relics_jedi_starfighter_5"}

EP3_VADER_TAKEN_KEY = ":ep3_vader:taken"
EP3_VADER_DEBRIEFED_KEY = ":ep3_vader:debriefed"

function Ep3CloneRelicsDarthVaderConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3CloneRelicsDarthVaderConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). The quest name does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3CloneRelicsDarthVaderConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3CloneRelicsDarthVaderConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3CloneRelicsDarthVaderConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- FLAGGED INTERPRETATION -- WRONG FACTION. Attested gate, interpreted line. See the header.
	if (not SpaceHelpers:isImperialPilot(pPlayer)) then
		return convoTemplate:getScreen("ep3_vader_intruder")
	end

	local phase5Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_VADER_QUEST_5.type, EP3_VADER_QUEST_5.name)

	-- Either phase running.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_VADER_QUEST_4.type, EP3_VADER_QUEST_4.name)
		or SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_VADER_QUEST_5.type, EP3_VADER_QUEST_5.name)) then
		return convoTemplate:getScreen("ep3_vader_orders")
	end

	-- Both phases settled: the Rebel fleet is beaten. After the debrief he has no further use for the
	-- pilot.
	if (phase5Complete) then
		if (self:getFlag(pPlayer, EP3_VADER_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_vader_no_use")
		end

		return convoTemplate:getScreen("ep3_vader_success")
	end

	-- NOTHING IS TESTED FOR PHASE IV COMPLETE HERE. Reaching this point already means neither phase is
	-- active and phase V is not complete, so a "phase IV complete" test here would be an absorbing
	-- state, not the 10 second sideQuestDelay window it looks like -- see the header. Phase IV complete
	-- with phase V dead is precisely the state the shipped failure/retry block below exists to unstick.

	-- Took phase IV once and holds neither phase now.
	if (self:getFlag(pPlayer, EP3_VADER_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_vader_failure")
	end

	-- FLAGGED INTERPRETATION -- BRUSH-OFF. An Imperial pilot who plainly cannot fly the mission.
	-- Checked after the quest-state screens so a pilot who lost the ship mid-arc still gets an honest
	-- status hail.
	if (not self:canFly(pPlayer)) then
		return convoTemplate:getScreen("ep3_vader_no_use")
	end

	return convoTemplate:getScreen("ep3_vader_offer")
end

function Ep3CloneRelicsDarthVaderConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- GRANT (s_747, end of the briefing) and RE-GRANT (s_724, "there is still time to stop them").
	-- Phase V is never granted here; it arrives on phase IV's COMPLETION split.
	if (screenID == "ep3_vader_accept" or screenID == "ep3_vader_retry") then
		-- A COMPLETED journal quest still owns its slot. PlayerObjectImplementation::completeJournalQuest
		-- sets only the completed flag (PlayerObjectImplementation.cpp:3236-3254); the ownerId is never
		-- released, and activateJournalQuest refuses outright when ownerId is set (3213-3218). So the
		-- journal write in SpaceHelpers:activateSpaceQuest (space_helpers.lua:1017) silently no-ops on a
		-- completed quest while the datapad mission object is still created (:981), "Mission Received" is
		-- still sent (:1023) and the fanfare still plays (:1025). Phase IV is exactly that: it is left
		-- completedFlag = 1 when phase V's fail cascade reaches its failQuest, which bails at
		-- SpaceBattleScreenplay.lua:129-131 because phase IV is complete rather than active. The retry has
		-- to release the slot itself or it hands out a phantom mission and the arc stays stuck.
		--
		-- reset + clear, in that order, is the shipped house move for this, copied from
		-- RsfSquadronScreenplay:resetDingeQuests (RsfSquadronScreenplay.lua:1841-1879). resetQuest is
		-- SpaceBattleScreenplay:resetQuest (SpaceBattleScreenplay.lua:169-189): it fails the quest
		-- silently (failSpaceQuest with notifyClient false, which reaches clearJournalQuest at
		-- space_helpers.lua:1105 and so does release the ownerId), drops the waypoint, drops the
		-- ZONESWITCHED observer and runs cleanUpQuestData. clearSpaceQuest is then a no-op that matches
		-- the precedent.
		--
		-- GUARDED ON THE COMPLETED STATE ON PURPOSE. On a first grant, and on a retry after a phase IV
		-- failure, the quest is neither active nor complete, which by isJournalQuestActive/
		-- isJournalQuestComplete (PlayerObjectImplementation.cpp:3374-3387) means ownerId is already 0 --
		-- SpaceHelpers:failSpaceQuest clears the journal entry on every failure path. Those paths are not
		-- reset.
		--
		-- PHASE V IS NOT RESET HERE. Both ids are only reachable from getInitialScreen with phase V
		-- neither active (that returns ep3_vader_orders) nor complete (that returns ep3_vader_success /
		-- ep3_vader_no_use), so phase V's ownerId is already 0 and resetting it could not change
		-- anything. Its COMPLETION split re-grants it when phase IV completes again.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_VADER_QUEST_4.type, EP3_VADER_QUEST_4.name)) then
			space_battle_ep3_clone_relics_jedi_starfighter_4:resetQuest(pPlayer)
			SpaceHelpers:clearSpaceQuest(pPlayer, EP3_VADER_QUEST_4.type, EP3_VADER_QUEST_4.name, false)
		end

		-- grant() is the shared shape (see the comment on it, and Ep3CpgVeteranConvoHandler:grant()) and
		-- is left alone. With the clear above, phase IV is neither active nor complete when startQuest
		-- runs, so grant()'s "or isSpaceQuestComplete" arm can no longer return true vacuously and a true
		-- return is now a real activation on both ids.
		if (self:grant(pPlayer, pNpc, space_battle_ep3_clone_relics_jedi_starfighter_4, EP3_VADER_QUEST_4)) then
			self:setFlag(pPlayer, EP3_VADER_TAKEN_KEY, 1)
			self:setFlag(pPlayer, EP3_VADER_DEBRIEFED_KEY, 0)
		end

	-- s_718 "Now leave me." is the end of the debrief.
	elseif (screenID == "ep3_vader_dismissed") then
		self:setFlag(pPlayer, EP3_VADER_DEBRIEFED_KEY, 1)
	end

	return pScreenClone
end

local Logger = require("utils.logger")
require("utils.helpers")

SpacestationKashyyykConvoHandler = conv_handler:new {}

-- Rian Ry tracks how far the pilot has come through the Kashyyyk storyline.
-- The stage is stored per player and drives which shipped greeting is used.
SPACESTATION_KASHYYYK_STAGES = {
	[0] = "spacestation_kashyyyk_greeting_hostile", -- unproven merc
	[1] = "spacestation_kashyyyk_greeting_droid_active", -- droid pilot escort underway
	[2] = "spacestation_kashyyyk_greeting_intro", -- droid saved, Rian introduces herself
	[3] = "spacestation_kashyyyk_greeting_eyma_done", -- Eyma cleared the pilot for contracts
	[4] = "spacestation_kashyyyk_greeting_rescue_pending", -- Tyyyn nebula rescue assigned
	[5] = "spacestation_kashyyyk_greeting_rescue_active", -- Tyyyn nebula rescue underway
	[6] = "spacestation_kashyyyk_greeting_rescue_failed", -- civilians lost
	[7] = "spacestation_kashyyyk_greeting_ghrag_done", -- Ghrag beaten off
	[8] = "spacestation_kashyyyk_greeting_gotal_failed", -- second transport lost
	[9] = "spacestation_kashyyyk_greeting_gotal_done", -- Gotal bandits dusted
	[10] = "spacestation_kashyyyk_greeting_escort_failed", -- escort contract botched
	[11] = "spacestation_kashyyyk_greeting_contracts", -- full CPG contract board
	[12] = "spacestation_kashyyyk_greeting_vaksai", -- corvette recovered, chassis waiting
	[13] = "spacestation_kashyyyk_ghrag_warning", -- Ghrag ambush inbound (fired from getInitialScreen)
}

-- The stage other Kashyyyk stations read to decide whether the pilot is a proven Civilian
-- Protection Guild hand (SPACESTATION_*_CPG_STAGE = 3 in the two Rodian handlers and in the
-- Independent Slaver handler). Stage 3 is the first rung where Rian says the CPG is "cleared
-- to offer transport protection contracts to you" (s_730), so it is the right gate for them.
SPACESTATION_KASHYYYK_STAGE_KEY = ":spacestation_kashyyyk:stage"

-- Set when the droid-pilot escort is handed out. Without it a never-taken escort cannot be told
-- apart from one the pilot lost, because SpaceHelpers:failSpaceQuest() clears the journal quest.
SPACESTATION_KASHYYYK_DROID_KEY = ":spacestation_kashyyyk:droid"
-- How far the pilot has got with Eyma on the surface. 1 = took the first meeting (CPG clearance),
-- 2 = went back for the second meeting and came away with the Tyyyn nebula rescue.
SPACESTATION_KASHYYYK_EYMA_KEY = ":spacestation_kashyyyk:eyma"
-- Which Tyyyn nebula rescue is outstanding. 1 = rescue_alpha handed out and not yet acknowledged,
-- 2 = rescue_alpha acknowledged, 3 = rescue_bravo handed out. 0 = nothing outstanding.
SPACESTATION_KASHYYYK_TYYYN_KEY = ":spacestation_kashyyyk:tyyyn"
-- Set while the Gotal transport escort is outstanding.
SPACESTATION_KASHYYYK_GOTAL_KEY = ":spacestation_kashyyyk:gotal"
-- Set once the Gotal transport escort has been brought home, so stage 9 is owed.
SPACESTATION_KASHYYYK_GOTAL_DONE_KEY = ":spacestation_kashyyyk:gotaldone"
-- Set while a CPG escort-duty contract is outstanding, so a botched one can be answered by s_546.
SPACESTATION_KASHYYYK_DUTY_KEY = ":spacestation_kashyyyk:duty"
-- Set while the stolen Corellian Corvette recovery is outstanding.
SPACESTATION_KASHYYYK_CORVETTE_KEY = ":spacestation_kashyyyk:corvette"
-- Set once the corvette hand-over has been settled, so stage 12 is not offered forever.
SPACESTATION_KASHYYYK_VAKSAI_KEY = ":spacestation_kashyyyk:vaksai"
-- Set once the Ghrag death-mark ambush has been fired, so the warning hail is a one-shot.
SPACESTATION_KASHYYYK_AMBUSH_KEY = ":spacestation_kashyyyk:ambush"

-- The quest behind each branch of the shipped conversation.
--
-- STF: "The Kashyyyk space station has received an automated distress call from a freighter
-- nearby. Evidently the droid pilot of this freighter has been damaged by bandits and cannot leave
-- the system without help." That is s_669/s_685/s_701 word for word.
SPACESTATION_KASHYYYK_DROID = {type = "escort", name = "ep3_kash_station_escort_alpha"}
-- STF arrival_phase_1: "Fly to the Tyyyn nebula. A weak distress signal is coming from there...";
-- quest_escort_t "Escort the Civilian Transport to the Kashyyyk space station". s_430 names the
-- same job: "a civilian transport lost in the Tyyyn nebula".
SPACESTATION_KASHYYYK_RESCUE_ALPHA = {type = "rescue", name = "ep3_kash_station_rescue_alpha"}
-- STF: "Although you succeeded in frustrating the Ghrag mercenaries by rescuing that civilian
-- transport - you also succeeded in making them very vengeful. They have gone after yet another
-- civilian transport." arrival_phase_1 "The distress signal is coming from deep within the Tyyyn
-- nebula." That is s_502: "We're hearing all sorts of noise coming from the Tyyyn nebula. I worry
-- that another transport has come under fire."
SPACESTATION_KASHYYYK_RESCUE_BRAVO = {type = "rescue", name = "ep3_kash_station_rescue_bravo"}
-- STF: "The Kashyyyk space station has received a distress call from a civilian transport that was
-- damaged by Gotal bandits", quest_location_d "near the Gotal bandits stronghold". That is s_521:
-- "another transport... also seems to have run afoul of the Gotal bandits. Most people know to
-- avoid the Gotal base."
SPACESTATION_KASHYYYK_GOTAL = {type = "escort", name = "ep3_kash_station_escort_bravo"}
-- STF: "Protect merchant cruisers, civilian transports and freighters as they pass through the
-- Kashyyyk system", duty_update "Civilian Protection Guild:". That is the standing CPG transport
-- protection contract of s_730/s_746/s_750 and the s_454 board pick.
SPACESTATION_KASHYYYK_ESCORT_DUTY = {type = "escort_duty", name = "ep3_kash_station_escort_duty"}
-- STF: "Now that their plans for system-wide domination have been quashed, the Ghrag are running
-- scared. Patrol the Kashyyyk system in search of their remaining numbers and eliminate them."
-- That is the s_450 board pick, "Let's hunt down the Ghrag!".
SPACESTATION_KASHYYYK_DESTROY_DUTY = {type = "destroy_duty", name = "ep3_kash_station_destroy_duty_neutral"}
-- STF: a stolen Corellian Corvette under Ghrag mercenary escort, quest_escort_d "Escort the vessel
-- to the Kashyyyk Space Station". That is s_464, the Rebel shipyard traitor selling a Corellian
-- Corvette warship to the Ghrag mercenaries.
SPACESTATION_KASHYYYK_CORVETTE = {type = "recovery", name = "ep3_blacksun_heavy_recovery"}
-- STF: "You are now death-marked by the Ghrag Mercenary clan! Ace fighters have been sent to
-- destroy you!" That is s_436, "Look out, %TU! The Ghrag are here to destroy you!".
SPACESTATION_KASHYYYK_AMBUSH = {type = "destroy_surpriseattack", name = "ep3_kash_station_ghrag_ambush"}

function SpacestationKashyyykConvoHandler:getStage(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASHYYYK_STAGE_KEY)
end

-- Stages 6, 8 and 10 are failure side states rather than rungs above the one before them, and the
-- retry branches have to be able to walk the pilot back down, so this setter is deliberately NOT
-- monotonic. Every caller below cites the .stf line that justifies the move.
function SpacestationKashyyykConvoHandler:setStage(pPlayer, stage)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASHYYYK_STAGE_KEY

	deleteData(key)
	writeData(key, stage)
end

function SpacestationKashyyykConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function SpacestationKashyyykConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- SpaceHelpers:failSpaceQuest() clears the journal quest and fails the datapad mission, so a quest
-- that was handed out but is now neither active nor complete was botched. That is the only way to
-- tell "lost it" from "never took it", and it is what the three retry hails are reacting to.
function SpacestationKashyyykConvoHandler:isBotched(pPlayer, quest)
	if (pPlayer == nil) then
		return false
	end

	return not SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
		and not SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
end

-- Hand a quest out and report whether it actually landed. activateSpaceQuest() refuses any quest
-- whose NAME contains "_duty" while another space duty mission sits in the datapad -- it sends
-- "@space/quest:duty_already" to the client itself and returns without touching the journal -- so
-- a grant can be turned away. It writes the journal entry synchronously
-- (PlayerObject:activateJournalQuest, space_helpers.lua), so asking straight afterwards is safe.
function SpacestationKashyyykConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- Recompute which shipped greeting Rian owes this pilot. Evaluated in a fixed order so two pending
-- results can never fight over the hail:
--   1. the corvette hand-over, because s_438 is a hand-over Rian opened herself
--   2. the Tyyyn nebula rescue, the main CPG storyline Rian is actively watching
--   3. the Gotal transport, the follow-on distress call
--   4. the standing escort-duty contract, the lowest-value of the outstanding jobs
-- and only then the storyline ladder, highest rung first.
function SpacestationKashyyykConvoHandler:refreshStage(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Re-arm the death-mark ambush if it was handed out and then lost, so the Ghrag climax can
	-- never be skipped by flying away from it.
	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_AMBUSH_KEY) ~= 0
		and self:isBotched(pPlayer, SPACESTATION_KASHYYYK_AMBUSH)) then
		self:setFlag(pPlayer, SPACESTATION_KASHYYYK_AMBUSH_KEY, 0)
	end

	--[[
		1. The stolen Corellian Corvette
	]]

	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY) ~= 0) then
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_CORVETTE.type, SPACESTATION_KASHYYYK_CORVETTE.name)) then
			-- s_438: "I knew you wouldn't let us down, %NU! That was one in a million! Would you
			-- like the Blacksun Vaksai chassis, now?"
			if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_VAKSAI_KEY) == 0) then
				self:setStage(pPlayer, 12)
				return
			end

			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY, 0)
		elseif (self:isBotched(pPlayer, SPACESTATION_KASHYYYK_CORVETTE)) then
			-- No "you lost the corvette" hail ships for this job, so the offer simply becomes
			-- available again from the contract board.
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY, 0)
		end
	end

	--[[
		2. The Tyyyn nebula rescues
	]]

	local tyyyn = self:getFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY)

	if (tyyyn ~= 0) then
		local rescue = SPACESTATION_KASHYYYK_RESCUE_ALPHA

		if (tyyyn == 3) then
			rescue = SPACESTATION_KASHYYYK_RESCUE_BRAVO
		end

		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, rescue.type, rescue.name)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY, 0)
		elseif (self:isBotched(pPlayer, rescue)) then
			-- s_508: "The civilians were lost! So many lives... it's such a shame!"
			self:setStage(pPlayer, 6)
			return
		elseif (tyyyn == 1) then
			-- s_430: "Eyma said you were going to rescue a civilian transport lost in the Tyyyn
			-- nebula. You'd better get to it!" -- assigned, not yet acknowledged.
			self:setStage(pPlayer, 4)
			return
		else
			-- s_428: "That Civilian Transport needs your help, %TU! Guide them to this station and
			-- keep them out of harm's way!"
			self:setStage(pPlayer, 5)
			return
		end
	end

	--[[
		3. The Gotal transport
	]]

	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_KEY) ~= 0) then
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_GOTAL.type, SPACESTATION_KASHYYYK_GOTAL.name)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_KEY, 0)
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_DONE_KEY, 1)
		elseif (self:isBotched(pPlayer, SPACESTATION_KASHYYYK_GOTAL)) then
			-- s_518: "So you lost that civilian transport. So many lives... it's such a shame!"
			self:setStage(pPlayer, 8)
			return
		end
	end

	--[[
		4. The standing CPG escort-duty contract
	]]

	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_DUTY_KEY) ~= 0) then
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_ESCORT_DUTY.type, SPACESTATION_KASHYYYK_ESCORT_DUTY.name)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_DUTY_KEY, 0)
		elseif (self:isBotched(pPlayer, SPACESTATION_KASHYYYK_ESCORT_DUTY)) then
			-- s_546: "Well that last escort didn't go as planned, did it?"
			self:setStage(pPlayer, 10)
			return
		end
	end

	--[[
		The storyline ladder
	]]

	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_DONE_KEY) ~= 0) then
		-- s_444: "You are cleared for two different contracts on behalf of the Civilian Protection
		-- Guild." The second of those two is the Ghrag hunt, whose own STF opens "Now that their
		-- plans for system-wide domination have been quashed, the Ghrag are running scared" -- so
		-- the board opens once the pilot has survived the Ghrag death-mark ambush, which is the
		-- last card the clan plays.
		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_AMBUSH.type, SPACESTATION_KASHYYYK_AMBUSH.name)) then
			self:setStage(pPlayer, 11)
			return
		end

		-- s_528: "Nice to see you again, %TU! Good work dusting those Gotal bandits! The CPG is
		-- impressed. And, honestly... so am I!"
		self:setStage(pPlayer, 9)
		return
	end

	-- s_494: "Looks like these Ghrag mercenaries mean business. Good job putting them back in their
	-- place!" Both Tyyyn rescues are Ghrag jobs (rescue_alpha taunt_4 "The Ghrag rule Kashyyyk
	-- space!"), so either one earns this hail.
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_RESCUE_ALPHA.type, SPACESTATION_KASHYYYK_RESCUE_ALPHA.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_RESCUE_BRAVO.type, SPACESTATION_KASHYYYK_RESCUE_BRAVO.name)) then
		self:setStage(pPlayer, 7)
		return
	end

	-- s_730: "Since Eyma gave the go-ahead, I'm cleared to offer transport protection contracts to
	-- you whenever you want them."
	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_EYMA_KEY) ~= 0) then
		self:setStage(pPlayer, 3)
		return
	end

	-- s_382: "Hey! Great job protecting that droid pilot. I thought he would be destroyed for sure!"
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_DROID.type, SPACESTATION_KASHYYYK_DROID.name)) then
		self:setStage(pPlayer, 2)
		return
	end

	if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_DROID_KEY) ~= 0) then
		-- s_251: "That droid pilot needs your help! Escort him to this station so that we can tune
		-- his navigation system and get him on his way."
		if (SpaceHelpers:isSpaceQuestActive(pPlayer, SPACESTATION_KASHYYYK_DROID.type, SPACESTATION_KASHYYYK_DROID.name)) then
			self:setStage(pPlayer, 1)
			return
		end

		-- Lost the droid. No failure hail ships for it, so drop the flag and fall back to the
		-- hostile greeting -- s_666 "What's going on around here?" is the only route to the offer,
		-- so clearing the flag is what makes a second attempt possible at all.
		self:setFlag(pPlayer, SPACESTATION_KASHYYYK_DROID_KEY, 0)
	end

	-- s_206: "Great - just what we needed: another mercenary killer. What do you want here anyway?"
	self:setStage(pPlayer, 0)
end

function SpacestationKashyyykConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	if (not SceneObject(pShip):checkInConversationRange(pNpc)) then
		return convoTemplate:getScreen("out_of_range")
	end

	self:refreshStage(pPlayer)

	local stage = self:getStage(pPlayer)

	-- STAGE 13. s_436: "Look out, %TU! The Ghrag are here to destroy you!" -- a stopConversation
	-- hail with no options, so it is a one-shot warning rather than a resting state.
	--
	-- destroy_surpriseattack/ep3_kash_station_ghrag_ambush is that attack: "You are now death-marked
	-- by the Ghrag Mercenary clan! Ace fighters have been sent to destroy you!" Its own screenplay
	-- says so outright -- "No parent quest is named by the client text; the station conversation
	-- handler owns the trigger (spacestation_kashyyyk_ghrag_warning, 'Ghrag ambush inbound')"
	-- (KashyyykStationScreenplay.lua:534-536) -- so this handler has to fire it.
	--
	-- FLAGGED INTERPRETATION: the client names no prerequisite. It is fired here at stage 9, the
	-- end of the Ghrag/Gotal arc, because that is the last rung before the contract board and the
	-- board's own Ghrag contract text ("their plans... have been quashed") only makes sense after
	-- the clan's final play has been beaten. Firing it earlier would strand stage 9 or the board.
	if (stage == 9 and self:getFlag(pPlayer, SPACESTATION_KASHYYYK_AMBUSH_KEY) == 0) then
		self:setFlag(pPlayer, SPACESTATION_KASHYYYK_AMBUSH_KEY, 1)

		destroy_surpriseattack_ep3_kash_station_ghrag_ambush:startQuest(pPlayer, pNpc)

		return convoTemplate:getScreen("spacestation_kashyyyk_ghrag_warning")
	end

	local screenID = SPACESTATION_KASHYYYK_STAGES[stage]

	if (screenID == nil) then
		return convoTemplate:getScreen("spacestation_kashyyyk_greeting")
	end

	return convoTemplate:getScreen(screenID)
end

function SpacestationKashyyykConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	-- Only show request repairs if the player has enough credits for the smallest repair
	-- Rian refuses repairs outright until the droid pilot escort is done
	if (screenID == "spacestation_kashyyyk_greeting" and self:getStage(pPlayer) >= 2 and SpaceStationScreenPlay:hasCreditsForRepair(pPlayer, pShip, 0.25)) then
		pClonedConvo:addOption("@conversation/station_kashyyyk:s_602", "spacestation_kashyyyk_repair") -- (Request Repairs)
	end

	--[[
		ORPHAN WIRING 1 -- spacestation_kashyyyk_corvette_teaser

		s_460 "Yes, there is something else I have for you. It's very dangerous. Would you like
		details?" is an ANSWER, and the only shipped question it answers is s_736 "Is there anything
		else to do?" (the same key stage 3 uses for its own follow-up). No shipped screen lists the
		teaser as an option target, so the handler has to hang it off the contract board, which is
		the only greeting that is about having work available and is reached after the storyline the
		corvette job caps off. It is offered only while the job is neither running nor settled.
	]]
	if (screenID == "spacestation_kashyyyk_greeting_contracts"
		and self:getFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY) == 0
		and self:getFlag(pPlayer, SPACESTATION_KASHYYYK_VAKSAI_KEY) == 0
		and not SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_CORVETTE.type, SPACESTATION_KASHYYYK_CORVETTE.name)) then
		pClonedConvo:addOption("@conversation/station_kashyyyk:s_736", "spacestation_kashyyyk_corvette_teaser") -- Is there anything else to do?
	end

	--[[
		ORPHAN WIRING 2 -- spacestation_kashyyyk_gotal_offer

		s_521 and s_502 are alternative answers to the same question: the stage 7 hail's "What's
		next?" (s_500) points at spacestation_kashyyyk_tyyyn_offer, and the two screens carry the
		IDENTICAL option pair (s_504 -> tyyyn_accept, s_486 -> skip), which is what an alternative
		is. s_502 is the Tyyyn nebula ("another transport has come under fire") = rescue_bravo,
		whose STF is the direct sequel to rescue_alpha. s_521 is the Gotal base ("also seems to have
		run afoul of the Gotal bandits") = escort_bravo, whose STF is "a civilian transport that was
		damaged by Gotal bandits... near the Gotal bandits stronghold".

		So once the Tyyyn thread is exhausted, the next distress call Rian passes on is the Gotal
		one, and the orphan takes the offer screen's place.
	]]
	if (screenID == "spacestation_kashyyyk_tyyyn_offer"
		and SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_RESCUE_BRAVO.type, SPACESTATION_KASHYYYK_RESCUE_BRAVO.name)) then
		local pNewScreen = LuaConversationTemplate(pConvTemplate):getScreen("spacestation_kashyyyk_gotal_offer")

		if (pNewScreen ~= nil) then
			LuaConversationScreen(pNewScreen):setDialogTextTU(CreatureObject(pPlayer):getFirstName())

			return pNewScreen
		end
	end

	--[[
		Stage writes and quest grants
	]]

	-- STAGE 0 -> 1. Both accept terminals are the same line, s_706 / s_690 "Good luck! I look
	-- forward to seeing you soon!", reached from s_704 / s_688 "I can lead the droid pilot back
	-- here." The paid branch differs only by the thousand-credit haggle in s_680.
	if (screenID == "spacestation_kashyyyk_droid_accept" or screenID == "spacestation_kashyyyk_droid_accept_paid") then
		if (self:grant(pPlayer, pNpc, escort_ep3_kash_station_escort_alpha, SPACESTATION_KASHYYYK_DROID)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_DROID_KEY, 1)
			self:setStage(pPlayer, 1)
		end

	-- STAGE 2 -> 3. s_536 "Our surface commander, Eyma, has requested a meeting with you to discuss
	-- a threat we have received. Will you agree to meet with him?" -> s_538 "Yes. (Land)" -> s_582
	-- "Ah! Good. Eyma is looking forward to seeing you!" The next rung's hail, s_730, opens "Since
	-- Eyma gave the go-ahead, I'm cleared to offer transport protection contracts to you", so
	-- taking that meeting IS the clearance. This is also the gate the two Rodian bases and the
	-- Independent Slavers read (SPACESTATION_*_CPG_STAGE = 3).
	elseif (screenID == "spacestation_kashyyyk_eyma_land_complete") then
		if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_EYMA_KEY) == 0) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_EYMA_KEY, 1)
			self:setStage(pPlayer, 3)
		end

		createEvent(3500, "SpaceStationScreenPlay", "landShip", pPlayer, "kachirho")

	-- STAGE 3 -> 4. The second Eyma meeting. s_738: "Why don't you check in with Eyma again. I know
	-- he's been hard at work pulling in favors from civilian contacts all over the Kashyyyk system.
	-- He may have uncovered more information about the Ghrag mercenaries." -> s_740 "I'll go see him
	-- now! (Land)" -> s_742 "You got it, %TU!"
	--
	-- FLAGGED INTERPRETATION: the stage 4 hail is s_430 "Eyma said you were going to rescue a
	-- civilian transport lost in the Tyyyn nebula. You'd better get to it!" -- past tense, so the
	-- assignment happened on the surface, with Eyma, before this hail. Eyma is a ground NPC and is
	-- not part of this station's conversation, so the rescue is handed out here, at the moment the
	-- pilot is cleared down to go and see him. Without this the Tyyyn arc, and every stage above
	-- it, is unreachable from the space side.
	elseif (screenID == "spacestation_kashyyyk_eyma_again_land_complete") then
		if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_EYMA_KEY) < 2
			and self:getFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY) == 0
			and not SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_RESCUE_ALPHA.type, SPACESTATION_KASHYYYK_RESCUE_ALPHA.name)) then
			if (self:grant(pPlayer, pNpc, rescue_ep3_kash_station_rescue_alpha, SPACESTATION_KASHYYYK_RESCUE_ALPHA)) then
				self:setFlag(pPlayer, SPACESTATION_KASHYYYK_EYMA_KEY, 2)
				self:setFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY, 1)
				self:setStage(pPlayer, 4)
			end
		end

		createEvent(3500, "SpaceStationScreenPlay", "landShip", pPlayer, "kachirho")

	-- STAGE 4 -> 5. s_432 "Roger that." off the stage 4 hail lands on the shared s_434 "Good luck!".
	-- The pilot has acknowledged the job, so the next hail is the in-flight one (s_428) rather than
	-- the nagging one (s_430). The same terminal is reached from the droid and rescue-active hails,
	-- where the Tyyyn flag is 0 or already past 1, so this only ever fires on the stage 4 route.
	elseif (screenID == "spacestation_kashyyyk_good_luck") then
		if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY) == 1) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY, 2)
			self:setStage(pPlayer, 5)
		end

	-- STAGE 6 -> 5. s_514 "Yes. I want to try again!" -> s_516 "That's the spirit! Let's go!" Rian
	-- hands the same rescue back out; which one it is depends on how far the pilot had got.
	elseif (screenID == "spacestation_kashyyyk_retry_rescue") then
		if (self:getFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY) == 3) then
			if (self:grant(pPlayer, pNpc, rescue_ep3_kash_station_rescue_bravo, SPACESTATION_KASHYYYK_RESCUE_BRAVO)) then
				self:setStage(pPlayer, 5)
			end
		else
			if (self:grant(pPlayer, pNpc, rescue_ep3_kash_station_rescue_alpha, SPACESTATION_KASHYYYK_RESCUE_ALPHA)) then
				self:setFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY, 2)
				self:setStage(pPlayer, 5)
			end
		end

	-- s_504 "You bet!" -> s_506 "Great! Good luck, %TU!" is the accept terminal shared by BOTH offer
	-- screens, so which job it hands over depends on which offer the pilot was looking at -- the
	-- same test the substitution above uses. Tyyyn first (rescue_bravo), then the Gotal transport.
	elseif (screenID == "spacestation_kashyyyk_tyyyn_accept") then
		if (not SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASHYYYK_RESCUE_BRAVO.type, SPACESTATION_KASHYYYK_RESCUE_BRAVO.name)) then
			if (self:grant(pPlayer, pNpc, rescue_ep3_kash_station_rescue_bravo, SPACESTATION_KASHYYYK_RESCUE_BRAVO)) then
				self:setFlag(pPlayer, SPACESTATION_KASHYYYK_TYYYN_KEY, 3)
				self:setStage(pPlayer, 5)
			end
		elseif (self:grant(pPlayer, pNpc, escort_ep3_kash_station_escort_bravo, SPACESTATION_KASHYYYK_GOTAL)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_KEY, 1)
		end

	-- STAGE 8 -> the Gotal run again. s_524 "Yes. I want to try again!" -> s_526 "That's the spirit!
	-- Let's go!"
	elseif (screenID == "spacestation_kashyyyk_retry_gotal") then
		if (self:grant(pPlayer, pNpc, escort_ep3_kash_station_escort_bravo, SPACESTATION_KASHYYYK_GOTAL)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_GOTAL_KEY, 1)
		end

	--[[
		The standing CPG contracts
	]]

	-- s_732 "Sounds good." -> s_734 "Exellent! Good luck, %TU!" is the accept for the transport
	-- protection contract Rian offers from s_730 / s_746 / s_750, all three of which describe
	-- escorting civilian transports through the system -- escort_duty/ep3_kash_station_escort_duty
	-- ("Protect merchant cruisers, civilian transports and freighters as they pass through the
	-- Kashyyyk system"). s_456 "You are quite the hero, %TU!" is the same contract taken off the
	-- board, behind s_454 "Let me protect our civilian friends." s_554 "You got it!" is the retry
	-- after a botched one.
	--
	-- DUTY GATE: the quest name contains "_duty", so activateSpaceQuest() turns the grant away while
	-- another space duty mission is in the datapad and sends "@space/quest:duty_already" itself. The
	-- outstanding-contract flag is only set when the journal actually took the quest, so a refused
	-- grant can never be mistaken for a botched contract later.
	elseif (screenID == "spacestation_kashyyyk_contract_granted"
		or screenID == "spacestation_kashyyyk_contract_civilian"
		or screenID == "spacestation_kashyyyk_escort_retry") then
		if (self:grant(pPlayer, pNpc, escort_duty_ep3_kash_station_escort_duty, SPACESTATION_KASHYYYK_ESCORT_DUTY)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_DUTY_KEY, 1)
		end

	-- s_450 "Let's hunt down the Ghrag!" -> s_452 "You got it! Good luck, %TU!" The board's other
	-- contract is destroy_duty/ep3_kash_station_destroy_duty_neutral, "Patrol the Kashyyyk system in
	-- search of their remaining numbers and eliminate them", duty_update "Civilian Protection
	-- Guild:". No failure hail ships for it, so no outstanding flag is kept.
	--
	-- DUTY GATE: same as above -- refused grants message the client themselves.
	elseif (screenID == "spacestation_kashyyyk_contract_ghrag") then
		destroy_duty_ep3_kash_station_destroy_duty_neutral:startQuest(pPlayer, pNpc)

	--[[
		The stolen Corellian Corvette
	]]

	-- s_468 "I knew I could count on you, %NU! I will upload the mission data to you right now!" ->
	-- s_291 "Thanks!" -> s_472 "Good luck!" is the only terminal of the accept branch.
	-- recovery/ep3_blacksun_heavy_recovery is that job: a stolen Corellian Corvette under Ghrag
	-- mercenary escort, "Escort the vessel to the Kashyyyk Space Station".
	elseif (screenID == "spacestation_kashyyyk_corvette_luck") then
		if (self:grant(pPlayer, pNpc, recovery_ep3_blacksun_heavy_recovery, SPACESTATION_KASHYYYK_CORVETTE)) then
			self:setFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY, 1)
		end

	-- STAGE 12 -> 11. s_440 "You bet!" -> s_442 "Congratulations! Happy flying!"
	--
	-- REWARD GAP: s_484 and s_438 promise a "Blacksun Vaksai prototype" chassis. No vaksai chassis,
	-- deed or PCD exists in this tree -- object/tangible/ship/crafted/chassis/ holds only
	-- blacksun_heavy_s01..s04, blacksun_light_s01..s04 and blacksun_medium_s01..s04. Nothing is
	-- granted here rather than substituting a different hull; the quest itself already hands over
	-- blacksun_heavy_s01_deed.iff as its itemReward on completion
	-- (KashyyykMiningScreenplay.lua:330-333), so this screen is the dialogue acknowledgement of a
	-- reward the pilot has in fact already been paid.
	elseif (screenID == "spacestation_kashyyyk_vaksai_granted") then
		self:setFlag(pPlayer, SPACESTATION_KASHYYYK_VAKSAI_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASHYYYK_CORVETTE_KEY, 0)
		self:setStage(pPlayer, 11)
	end

	-- Handle Landing. The station clears pilots to the Kachirho starport
	-- ("I'll let you land at the Kachirho starport" - station_kashyyyk:s_210).
	-- The two Eyma landings are handled in the stage block above, which lands the ship itself.
	if (screenID == "spacestation_kashyyyk_land_complete" or screenID == "spacestation_kashyyyk_hostile_land_complete"
		or screenID == "spacestation_kashyyyk_forced_land_complete" or screenID == "spacestation_kashyyyk_deal_land_complete"
		or screenID == "spacestation_kashyyyk_clearance_land_complete" or screenID == "spacestation_kashyyyk_quick_land_complete"
		or screenID == "spacestation_kashyyyk_bye_land_complete") then
		createEvent(3500, "SpaceStationScreenPlay", "landShip", pPlayer, "kachirho")
	end

	-- Handle Repair Options
	if (screenID == "spacestation_kashyyyk_repair") then
		local timeNow = getTimestampMilli()
		local lastRepair = readData(SceneObject(pNpc):getObjectID() .. ":SpaceStation:repairDelay:")

		-- Timer for station repair
		if (timeNow < lastRepair) then
			local pNewScreen = LuaConversationTemplate(pConvTemplate):getScreen("repair_recent")
			LuaConversationScreen(pNewScreen):setDialogTextTU(CreatureObject(pPlayer):getFirstName())

			return pNewScreen
		end

		-- We already checked if player has enough credits for at least 25% repair, add that option
		pClonedConvo:addOption("@conversation/station_kashyyyk:s_606", "repair_small") -- Repair a little of the damage

		if (SpaceStationScreenPlay:hasCreditsForRepair(pPlayer, pShip, 0.50)) then
			pClonedConvo:addOption("@conversation/station_kashyyyk:s_618", "repair_half") -- Repair half the damage
		end
		if (SpaceStationScreenPlay:hasCreditsForRepair(pPlayer, pShip, 0.75)) then
			pClonedConvo:addOption("@conversation/station_kashyyyk:s_630", "repair_most") -- Repair most of the damage
		end
		if (SpaceStationScreenPlay:hasCreditsForRepair(pPlayer, pShip, 1.00)) then
			pClonedConvo:addOption("@conversation/station_kashyyyk:s_643", "repair_full") -- Repair all of the damage
		end

		pClonedConvo:addOption("@conversation/station_kashyyyk:s_661", "spacestation_kashyyyk_copy_that") -- Nevermind
	end

	-- Repair selection
	if (screenID == "repair_small") then
		pClonedConvo:setDialogTextDI(SpaceStationScreenPlay:getRepairCost(pShip, 0.25))
	elseif (screenID == "repair_half") then
		pClonedConvo:setDialogTextDI(SpaceStationScreenPlay:getRepairCost(pShip, 0.50))
	elseif (screenID == "repair_most") then
		pClonedConvo:setDialogTextDI(SpaceStationScreenPlay:getRepairCost(pShip, 0.75))
	elseif (screenID == "repair_full") then
		pClonedConvo:setDialogTextDI(SpaceStationScreenPlay:getRepairCost(pShip, 1.0))
	end

	-- Handle Repairing Ship
	if (screenID == "accept_repair_25") then
		SpaceStationScreenPlay:repairShip(pPlayer, pShip, 0.25, pNpc, true)
	elseif (screenID == "accept_repair_50") then
		SpaceStationScreenPlay:repairShip(pPlayer, pShip, 0.50, pNpc, true)
	elseif (screenID == "accept_repair_75") then
		SpaceStationScreenPlay:repairShip(pPlayer, pShip, 0.75, pNpc, true)
	elseif (screenID == "accept_repair_full") then
		SpaceStationScreenPlay:repairShip(pPlayer, pShip, 1.0, pNpc, true)
	end

	return pScreenClone
end

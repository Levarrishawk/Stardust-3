--[[
	CPG Veteran Pilot -- the in-space comm giver for
	destroy_duty/ep3_kash_station_destroy_duty_veteran.

	Why a ship can be a quest giver at all: NpcConversationStartCommand.h has an isShipAiAgent()
	branch that calls sendConversationStartTo() with no distance, line-of-sight or station-type
	requirement, and ShipAiAgentImplementation.cpp starts the conversation observer from the agent's
	conversationTemplate. The 22 stations already use exactly that path. Range is enforced here,
	the same way the station handlers enforce it, with SceneObject(pShip):checkInConversationRange().

	Where the client says to look for him: station_kashyyyk.stf s_273 -- "You might check in with the
	CPG Veteran pilot that patrols the asteroid belt. Look for a friendly YT-1300 vessel protecting
	the civilian traffic near the station." ep3_cpg_veteran_tier4/tier5 are yt1300_tier4/tier5 and
	already spawn at the belt (space_kashyyyk_spawner.lua: kash_cpg_veteran_belt_1 at 3340/2308/3473,
	kash_cpg_belt_patrol_2, kash_cpg_veteran_escort_1).

	Corroborated by ep3_eyma.stf s_254/s_256/s_258, which also sends the pilot to a YT-1300 "flying a
	patrol pattern around the station".
]]

Ep3CpgVeteranConvoHandler = conv_handler:new {}

-- destroy_duty/ep3_kash_station_destroy_duty_veteran, duty_update "\#pcontrast3 CPG Veteran Pilot:".
-- The quest is s_40 + s_42 word for word: he is listening to the Ghrag command frequency and
-- forwarding intercept coordinates for the replacement pilots they have recruited.
EP3_CPG_VETERAN_QUEST = {type = "destroy_duty", name = "ep3_kash_station_destroy_duty_veteran"}

-- The two Rian Ry jobs he comments on. Both mappings are the Kashyyyk station handler's own
-- documented ones (SPACESTATION_KASHYYYK_DROID / SPACESTATION_KASHYYYK_GOTAL).
EP3_CPG_VETERAN_DROID = {type = "escort", name = "ep3_kash_station_escort_alpha"}
EP3_CPG_VETERAN_GOTAL = {type = "escort", name = "ep3_kash_station_escort_bravo"}

-- Set the first time he is hailed, so s_187 ("Welcome to Kashyyyk my friend") is a one-shot.
EP3_CPG_VETERAN_MET_KEY = ":ep3_cpg_veteran:met"

-- FLAGGED INTERPRETATION -- PREREQUISITE. The client names no prerequisite for this contract, but
-- his own opening line does: s_38 "The Ghrag are beaten but they are still here... and they are
-- trying to get back in the game." The Ghrag are beaten at Rian's stage 7
-- (spacestation_kashyyyk_greeting_ghrag_done), so the offer is held back until then. Lower this to
-- 0 if the owner wants it available to any pilot.
EP3_CPG_VETERAN_MIN_STAGE = 7

-- Rian's three "you lost the transport" side states (stages 6, 8 and 10 in
-- SPACESTATION_KASHYYYK_STAGES). s_273/s_283 only make sense in one of them.
EP3_CPG_VETERAN_LOST_STAGES = {[6] = true, [8] = true, [10] = true}

-- Read-only view of the stage Rian's handler keeps. This handler never writes it.
function Ep3CpgVeteranConvoHandler:getStationStage(pPlayer)
	if (pPlayer == nil or SPACESTATION_KASHYYYK_STAGE_KEY == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASHYYYK_STAGE_KEY)
end

function Ep3CpgVeteranConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3CpgVeteranConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand the contract out and report whether it actually landed.
--
-- SpaceHelpers:activateSpaceQuest() refuses any quest whose NAME contains "_duty" while another
-- space duty mission is already in the datapad -- it sends "@space/quest:duty_already" to the
-- client itself and returns without touching the journal -- and this quest name does contain
-- "_duty". It writes the journal entry synchronously (PlayerObject:activateJournalQuest), so
-- asking straight afterwards is safe. Nothing in this handler is marked "outstanding" until this
-- returns true, so a refused grant leaves no residue.
function Ep3CpgVeteranConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- True when the Ghrag interception contract can be offered right now.
function Ep3CpgVeteranConvoHandler:canOfferQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_VETERAN_QUEST.type, EP3_CPG_VETERAN_QUEST.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_CPG_VETERAN_QUEST.type, EP3_CPG_VETERAN_QUEST.name)) then
		return false
	end

	return self:getStationStage(pPlayer) >= EP3_CPG_VETERAN_MIN_STAGE
end

function Ep3CpgVeteranConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	-- s_156 "Can't you see I'm busy?!" is the only shipped brush-off, so it stands in for every
	-- reason he will not talk shop.
	if (not isJtlEnabled() or not SpaceHelpers:isPilot(pPlayer)) then
		return convoTemplate:getScreen("ep3_cpg_veteran_busy")
	end

	local stage = self:getStationStage(pPlayer)

	-- Contract settled.
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_CPG_VETERAN_QUEST.type, EP3_CPG_VETERAN_QUEST.name)) then
		return convoTemplate:getScreen("ep3_cpg_veteran_praise")
	end

	-- Contract running. s_165 "Keep up the good work!" is the only shipped in-progress hail.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_VETERAN_QUEST.type, EP3_CPG_VETERAN_QUEST.name)) then
		return convoTemplate:getScreen("ep3_cpg_veteran_good_work")
	end

	-- One of Rian's jobs is outstanding; he nags about it by name.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_VETERAN_DROID.type, EP3_CPG_VETERAN_DROID.name)) then
		return convoTemplate:getScreen("ep3_cpg_veteran_droid")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_VETERAN_GOTAL.type, EP3_CPG_VETERAN_GOTAL.name)) then
		return convoTemplate:getScreen("ep3_cpg_veteran_gotal")
	end

	-- A transport was lost.
	if (EP3_CPG_VETERAN_LOST_STAGES[stage]) then
		return convoTemplate:getScreen("ep3_cpg_veteran_lost")
	end

	-- First hail.
	if (self:getFlag(pPlayer, EP3_CPG_VETERAN_MET_KEY) == 0) then
		self:setFlag(pPlayer, EP3_CPG_VETERAN_MET_KEY, 1)

		return convoTemplate:getScreen("ep3_cpg_veteran_welcome")
	end

	-- FLAGGED INTERPRETATION. s_162 "Oh no? Are you sure you're fighting for the right side?" is the
	-- one shipped line with a faction edge, and s_23 "Yes. My side." is the only shipped answer that
	-- fits it. The client names no trigger. It is used for an Imperial-aligned pilot who has not yet
	-- been vouched for by the guild; once Rian has cleared them (stage 3, "cleared to offer transport
	-- protection contracts to you") he drops it, so it never gates anyone out of the contract.
	-- Deleting this one branch removes the interpretation without touching anything else.
	if (SpaceHelpers:isImperialPilot(pPlayer) and stage < 3) then
		return convoTemplate:getScreen("ep3_cpg_veteran_right_side")
	end

	-- Vouched for by the CPG commander.
	if (stage >= 3) then
		return convoTemplate:getScreen("ep3_cpg_veteran_cpg_friend")
	end

	return convoTemplate:getScreen("ep3_cpg_veteran_greeting")
end

function Ep3CpgVeteranConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- s_37 "I'm looking for more work." is the shipped entry to the contract arc. No shipped screen
	-- lists it as an option target, so it is hung off the three hails that are about work.
	if ((screenID == "ep3_cpg_veteran_greeting"
		or screenID == "ep3_cpg_veteran_welcome"
		or screenID == "ep3_cpg_veteran_cpg_friend")
		and self:canOfferQuest(pPlayer)) then
		pClonedConvo:addOption("@conversation/ep3_cpg_veteran:s_37", "ep3_cpg_veteran_work_1") --I'm looking for more work.
	end

	-- The grant. s_43 "Sounds good." lands here.
	--
	-- If the pilot already has a duty mission in the datapad, activateSpaceQuest() turns the grant
	-- away and tells the client itself with "@space/quest:duty_already". Nothing is recorded either
	-- way, so the offer simply comes back the next time he is hailed.
	if (screenID == "ep3_cpg_veteran_accept") then
		self:grant(pPlayer, pNpc, destroy_duty_ep3_kash_station_destroy_duty_veteran, EP3_CPG_VETERAN_QUEST)
	end

	return pScreenClone
end

--[[
	CPG Ace -- "CPG Patrol Gamma". A comm-hailable ship NPC that GRANTS NOTHING.

	conversation/ep3_cpg_ace.stf contains no offer/accept pair. Every line either points the pilot at
	Rian Ry (s_169 "You should check in with Rian Ry. She's commander of the Kashyyyk space station.")
	or comments on a job Rian already handed out. Wiring a quest onto him would be authored content,
	so he is built as flavour and as the client's own signpost to the station board.

	ep3_cpg_ace_tier4/tier5 already spawn all over the Kashyyyk lanes
	(space_kashyyyk_spawner.lua: kash_cpg_station_guard_1, kash_cpg_station_patrol_1,
	kash_cpg_belt_patrol_2, kash_cpg_tyyyn_response, kash_cpg_methane_patrol).
]]

Ep3CpgAceConvoHandler = conv_handler:new {}

-- The three Rian Ry jobs he comments on. The droid and Gotal mappings are the Kashyyyk station
-- handler's own (SPACESTATION_KASHYYYK_DROID / SPACESTATION_KASHYYYK_GOTAL). The Tyyyn one is
-- rescue_bravo rather than rescue_alpha because s_237 says "again", and rescue_bravo's STF is the
-- direct sequel to rescue_alpha ("They have gone after yet another civilian transport").
EP3_CPG_ACE_DROID = {type = "escort", name = "ep3_kash_station_escort_alpha"}
EP3_CPG_ACE_GOTAL = {type = "escort", name = "ep3_kash_station_escort_bravo"}
EP3_CPG_ACE_TYYYN = {type = "rescue", name = "ep3_kash_station_rescue_bravo"}

-- The Ghrag interception contract the CPG Veteran hands out. s_243 is the ace's reaction to it.
EP3_CPG_ACE_VETERAN_QUEST = {type = "destroy_duty", name = "ep3_kash_station_destroy_duty_veteran"}

-- Set the first time he is hailed, so s_187 is a one-shot.
EP3_CPG_ACE_MET_KEY = ":ep3_cpg_ace:met"

function Ep3CpgAceConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3CpgAceConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Read-only view of the stage Rian's handler keeps. This handler never writes it.
function Ep3CpgAceConvoHandler:getStationStage(pPlayer)
	if (pPlayer == nil or SPACESTATION_KASHYYYK_STAGE_KEY == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASHYYYK_STAGE_KEY)
end

function Ep3CpgAceConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	if (not isJtlEnabled() or not SpaceHelpers:isPilot(pPlayer)) then
		return convoTemplate:getScreen("ep3_cpg_ace_busy")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_CPG_ACE_VETERAN_QUEST.type, EP3_CPG_ACE_VETERAN_QUEST.name)) then
		return convoTemplate:getScreen("ep3_cpg_ace_praise")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_ACE_DROID.type, EP3_CPG_ACE_DROID.name)) then
		return convoTemplate:getScreen("ep3_cpg_ace_droid")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_ACE_GOTAL.type, EP3_CPG_ACE_GOTAL.name)) then
		return convoTemplate:getScreen("ep3_cpg_ace_gotal")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CPG_ACE_TYYYN.type, EP3_CPG_ACE_TYYYN.name)) then
		return convoTemplate:getScreen("ep3_cpg_ace_tyyyn")
	end

	if (self:getFlag(pPlayer, EP3_CPG_ACE_MET_KEY) == 0) then
		self:setFlag(pPlayer, EP3_CPG_ACE_MET_KEY, 1)

		return convoTemplate:getScreen("ep3_cpg_ace_welcome")
	end

	-- Once Rian has cleared the pilot for CPG contracts (her stage 3) the ace stops being neutral
	-- about them.
	if (self:getStationStage(pPlayer) >= 3) then
		return convoTemplate:getScreen("ep3_cpg_ace_good_work")
	end

	return convoTemplate:getScreen("ep3_cpg_ace_greeting")
end

function Ep3CpgAceConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	return pScreenClone
end

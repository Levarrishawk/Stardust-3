local Logger = require("utils.logger")
require("utils.helpers")

SpacestationRodianBaseConvoHandler = conv_handler:new {}

-- Sordaan only hires proven Civilian Protection Guild pilots, which is the same
-- standing Rian Ry hands out at the Kashyyyk station.
SPACESTATION_RODIAN_BASE_CPG_STAGE = 3

function SpacestationRodianBaseConvoHandler:isProtector(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return readData(SceneObject(pPlayer):getObjectID() .. ":spacestation_kashyyyk:stage") >= SPACESTATION_RODIAN_BASE_CPG_STAGE
end

function SpacestationRodianBaseConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	if (not self:isProtector(pPlayer)) then
		return convoTemplate:getScreen("spacestation_rodian_base_greeting_unqualified")
	end

	return convoTemplate:getScreen("spacestation_rodian_base_greeting")
end

function SpacestationRodianBaseConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- QUEST GRANT: Sordaan's Gotal Bandit contract.
	-- Both terminals are the same contract: s_194 "Don't let me down, pilot!" is reached by
	-- taking the job outright, s_198 "Good! Don't let me down, pilot!" by taking it after
	-- asking about (or haggling over) the three-hundred-per-kill pay. The .stf gives no
	-- separate mission for the pay branch, so both grant the one Rodian duty.
	--
	-- DUTY GATE: activateSpaceQuest() refuses any "_duty" quest while another space duty
	-- mission sits in the datapad and sends "@space/quest:duty_already" itself, so no
	-- silent failure is possible here. This station has no shipped "busy" screen to
	-- substitute, so the client message is the whole of the feedback.
	if (screenID == "spacestation_rodian_base_granted" or screenID == "spacestation_rodian_base_accepted") then
		destroy_duty_ep3_kash_station_destroy_duty_rodian:startQuest(pPlayer, pNpc)
	end

	return pScreenClone
end

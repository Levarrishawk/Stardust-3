local Logger = require("utils.logger")
require("utils.helpers")

SpacestationRodianTrippBaseConvoHandler = conv_handler:new {}

-- Tripp only hands contracts to proven Civilian Protection Guild pilots, which is
-- the same standing Rian Ry hands out at the Kashyyyk station.
SPACESTATION_RODIAN_TRIPP_BASE_CPG_STAGE = 3

function SpacestationRodianTrippBaseConvoHandler:isProtector(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return readData(SceneObject(pPlayer):getObjectID() .. ":spacestation_kashyyyk:stage") >= SPACESTATION_RODIAN_TRIPP_BASE_CPG_STAGE
end

function SpacestationRodianTrippBaseConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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
		return convoTemplate:getScreen("spacestation_rodian_tripp_base_greeting_unqualified")
	end

	return convoTemplate:getScreen("spacestation_rodian_tripp_base_greeting")
end

function SpacestationRodianTrippBaseConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- QUEST GRANT: Tripp's Chiss poacher seek-and-destroy contract.
	-- s_198 "Good! Don't let me down, pilot!" is the straight accept off the orders screen;
	-- s_28 "Uploading mission package now!" is the accept after asking what it is worth. The
	-- orders screen (s_193) is explicit that the mission package IS the coordinate upload, so
	-- both terminals grant the one Rodian-Tripp duty.
	--
	-- DUTY GATE: see the note in spacestation_rodian_base_conv_handler.lua -- activateSpaceQuest()
	-- enforces one space duty at a time and sends "@space/quest:duty_already" itself.
	if (screenID == "spacestation_rodian_tripp_base_accepted" or screenID == "spacestation_rodian_tripp_base_upload") then
		destroy_duty_ep3_kash_station_destroy_duty_rodian_tripp:startQuest(pPlayer, pNpc)
	end

	return pScreenClone
end

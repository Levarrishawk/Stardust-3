local Logger = require("utils.logger")
require("utils.helpers")

SpacestationIndieSlaverConvoHandler = conv_handler:new {}

-- The slavers send unproven pilots to the Civilian Protection Guild first, which is
-- the same standing Rian Ry hands out at the Kashyyyk station.
SPACESTATION_INDIE_SLAVER_CPG_STAGE = 3

function SpacestationIndieSlaverConvoHandler:isProtector(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return readData(SceneObject(pPlayer):getObjectID() .. ":spacestation_kashyyyk:stage") >= SPACESTATION_INDIE_SLAVER_CPG_STAGE
end

function SpacestationIndieSlaverConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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
		return convoTemplate:getScreen("spacestation_indie_slaver_greeting_unqualified")
	end

	return convoTemplate:getScreen("spacestation_indie_slaver_greeting")
end

function SpacestationIndieSlaverConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- QUEST GRANT: hijack a Trandoshan slaver transport bound for the Avatar platform.
	-- s_193/s_32 describe disabling the transport, slicing its navicomputer and leading it
	-- back here for processing -- that is recovery_duty/ep3_indie_slavers_recovery. s_34
	-- "Good luck!" is the only accept terminal.
	--
	-- DUTY GATE: this quest NAME ("ep3_indie_slavers_recovery") contains no "_duty" substring,
	-- so activateSpaceQuest()'s string.find(questName, "_duty") test does NOT fire and it is
	-- exempt from the one-duty-at-a-time rule even though its questType is recovery_duty.
	if (screenID == "spacestation_indie_slaver_accepted") then
		recovery_duty_ep3_indie_slavers_recovery:startQuest(pPlayer, pNpc)
	end

	return pScreenClone
end

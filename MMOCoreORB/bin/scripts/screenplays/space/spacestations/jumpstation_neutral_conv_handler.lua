-- Deep Space - Kessel Space Battlefield entry station (Neutral/Freelance,
-- Dathomir space) conversation handler.  Mirrors jumpstation_rebel_conv_handler.lua;
-- jump logic in deep_space_jump.lua.
--
-- Every screen this handler selects is backed by a real client string in
-- string/en/conversation/battlefield_entry_station_neutral.stf - see the key map
-- at the head of mobile/conversations/space/jumpstation_neutral.lua.
--
-- The neutral station greets everyone (it has no "wrong faction" / "sign up"
-- line at all).  Its two rejection lines fire on the SIDE-PICK, not the greeting:
--   s_45e440c8 "Rebels are not welcome here"    -> declared Rebel picking the Empire route
--   s_993453d7 "Imperials are not welcome here." -> declared Imperial picking the Rebel route
-- which is the only reading that fits its own briefing text, s_a99b5897: the
-- freelancer poses as one side and "will be treated as an enemy by the other".
-- INTERPRETATION (flagged): the .stf does not state that these two lines belong
-- to the side-pick; the placement is ours.

local Logger = require("utils.logger")
require("utils.helpers")

JumpstationNeutralConvoHandler = conv_handler:new {}

function JumpstationNeutralConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	return convoTemplate:getScreen("jumpstation_neutral_greeting")
end

-- Both fee prompts (s_7e6edae) and the insufficient line (s_37d359a2) carry %DI.
function JumpstationNeutralConvoHandler:showCostOrInsufficient(pConvTemplate, pPlayer, pScreenClone, pClonedConvo)
	local cost = DeepSpaceJumpScreenPlay.DEEP_SPACE_JUMP_PRESTIGE_COST
	local prestigeType = DeepSpaceJumpScreenPlay:getPrestigeType(pPlayer, "neutral")
	local balance = DeepSpaceJumpScreenPlay:getPrestigeBalance(pPlayer, prestigeType)

	if (prestigeType == nil or balance < cost) then
		local pInsufficient = LuaConversationTemplate(pConvTemplate):getScreen("jumpstation_neutral_insufficient")

		if (pInsufficient == nil) then
			return pScreenClone
		end

		local pInsufficientClone = LuaConversationScreen(pInsufficient):cloneScreen()
		LuaConversationScreen(pInsufficientClone):setDialogTextDI(cost)

		return pInsufficientClone
	end

	pClonedConvo:setDialogTextDI(cost)

	return pScreenClone
end

function JumpstationNeutralConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

	local faction = CreatureObject(pPlayer):getFaction()

	-- Posing as an Imperial: a declared Rebel is turned away
	if (screenID == "jumpstation_neutral_deepspace_imperial") then
		if (faction == FACTIONREBEL) then
			return LuaConversationTemplate(pConvTemplate):getScreen("jumpstation_neutral_rebels_no")
		end

		return self:showCostOrInsufficient(pConvTemplate, pPlayer, pScreenClone, pClonedConvo)
	end

	-- Using the Rebel Alliance's hyperspace route: a declared Imperial is turned away
	if (screenID == "jumpstation_neutral_deepspace_rebel") then
		if (faction == FACTIONIMPERIAL) then
			return LuaConversationTemplate(pConvTemplate):getScreen("jumpstation_neutral_imperials_no")
		end

		return self:showCostOrInsufficient(pConvTemplate, pPlayer, pScreenClone, pClonedConvo)
	end

	-- The side picked decides which Deep Space arrival point is used
	if (screenID == "jumpstation_neutral_jump_imperial") then
		createEvent(3500, "DeepSpaceJumpScreenPlay", "beginJump", pPlayer, "neutral_imperial")
	elseif (screenID == "jumpstation_neutral_jump_rebel") then
		createEvent(3500, "DeepSpaceJumpScreenPlay", "beginJump", pPlayer, "neutral_rebel")
	end

	-- Kessel carries no prestige fee: no Kessel cost/insufficient string exists in
	-- any of the three battlefield entry station tables.
	if (screenID == "jumpstation_neutral_kessel_jump") then
		createEvent(3500, "DeepSpaceJumpScreenPlay", "beginKesselJump", pPlayer, "")
	end

	return pScreenClone
end

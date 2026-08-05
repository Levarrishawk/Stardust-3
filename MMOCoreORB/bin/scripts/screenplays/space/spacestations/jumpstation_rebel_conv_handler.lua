-- Deep Space - Kessel Space Battlefield entry station (Rebel, Dantooine space)
-- conversation handler.  Mirrors the spacestation_*_conv_handler idiom; jump
-- logic in deep_space_jump.lua.
--
-- Every screen this handler selects is backed by a real client string in
-- string/en/conversation/battlefield_entry_station_rebel.stf - see the key map at
-- the head of mobile/conversations/space/jumpstation_rebel.lua.
--
-- INTERPRETATION (flagged, not client-attested): the .stf carries three separate
-- rejection lines and does not say which player state maps to which.  The split
-- used here is:
--   s_514ace33 "You are not welcome at this station!"                -> overt Imperial
--   s_33f71018 "You are not of the proper faction..."                -> Imperial, not overt
--   s_17456755 "Sign up with the Rebel Alliance and we'll talk."     -> no faction
-- Rebel players are never gated on faction status, so no declared Rebel can be
-- locked out by this mapping.

local Logger = require("utils.logger")
require("utils.helpers")

JumpstationRebelConvoHandler = conv_handler:new {}

function JumpstationRebelConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	local faction = CreatureObject(pPlayer):getFaction()

	if (faction == FACTIONIMPERIAL) then
		if (CreatureObject(pPlayer):getFactionStatus() > ONLEAVE) then
			return convoTemplate:getScreen("jumpstation_rebel_enemy")
		end

		return convoTemplate:getScreen("jumpstation_rebel_wrong_faction")
	elseif (faction ~= FACTIONREBEL) then
		return convoTemplate:getScreen("jumpstation_rebel_sign_up")
	end

	return convoTemplate:getScreen("jumpstation_rebel_greeting")
end

function JumpstationRebelConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

	local cost = DeepSpaceJumpScreenPlay.DEEP_SPACE_JUMP_PRESTIGE_COST

	-- Deep Space fee prompt: s_c2f477d7 carries %DI, and a pilot who cannot pay
	-- (or who never mastered their wings, so has no prestige pool at all) gets
	-- s_f68255a0 instead, which also carries %DI.
	if (screenID == "jumpstation_rebel_deepspace") then
		local prestigeType = DeepSpaceJumpScreenPlay:getPrestigeType(pPlayer, "rebel")
		local balance = DeepSpaceJumpScreenPlay:getPrestigeBalance(pPlayer, prestigeType)

		if (prestigeType == nil or balance < cost) then
			local pInsufficient = LuaConversationTemplate(pConvTemplate):getScreen("jumpstation_rebel_insufficient")

			if (pInsufficient == nil) then
				return pScreenClone
			end

			local pInsufficientClone = LuaConversationScreen(pInsufficient):cloneScreen()
			LuaConversationScreen(pInsufficientClone):setDialogTextDI(cost)

			return pInsufficientClone
		end

		pClonedConvo:setDialogTextDI(cost)
	end

	if (screenID == "jumpstation_rebel_deepspace_jump") then
		createEvent(3500, "DeepSpaceJumpScreenPlay", "beginJump", pPlayer, "rebel")
	end

	-- Kessel carries no prestige fee: no Kessel cost/insufficient string exists in
	-- any of the three battlefield entry station tables.
	if (screenID == "jumpstation_rebel_kessel_jump") then
		createEvent(3500, "DeepSpaceJumpScreenPlay", "beginKesselJump", pPlayer, "")
	end

	return pScreenClone
end

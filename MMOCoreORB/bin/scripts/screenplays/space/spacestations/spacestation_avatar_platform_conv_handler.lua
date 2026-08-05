local Logger = require("utils.logger")
require("utils.helpers")

SpacestationAvatarPlatformConvoHandler = conv_handler:new {}

-- The uprising on the platform decides which hail the pilot gets.
SPACESTATION_AVATAR_PLATFORM_STAGES = {
	[0] = "spacestation_avatar_platform_greeting_trespass", -- no business here
	[1] = "spacestation_avatar_platform_greeting", -- fighting has broken out, help wanted
	[2] = "spacestation_avatar_platform_greeting_damaged", -- comms shot out
}

SPACESTATION_AVATAR_PLATFORM_STAGE_KEY = ":spacestation_avatar_platform:stage"

function SpacestationAvatarPlatformConvoHandler:getStage(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_AVATAR_PLATFORM_STAGE_KEY)
end

-- Stages only ever move forward. Every caller below cites the .stf line that justifies the move.
function SpacestationAvatarPlatformConvoHandler:setStage(pPlayer, stage)
	if (pPlayer == nil) then
		return
	end

	if (self:getStage(pPlayer) >= stage) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. SPACESTATION_AVATAR_PLATFORM_STAGE_KEY

	deleteData(key)
	writeData(key, stage)
end

-- STAGE 0 -> 1. The stage 1 hail (s_66) opens with "Your ship's authorization codes check out."
-- The only approach codes for this platform in the tree are the ones the player steals in
-- inspect/ep3_trando_mosolium_zssik_04 ("steal the Avatar Platform approach codes",
-- inspectCargo = "avatar_landing_codes", KashyyykSlaverScreenplay.lua:630-658). Promotion is
-- lazy so the Trandoshan arc does not have to know this station exists.
function SpacestationAvatarPlatformConvoHandler:checkCodeClearance(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) >= 1) then
		return
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, "inspect", "ep3_trando_mosolium_zssik_04")) then
		self:setStage(pPlayer, 1)
	end
end

function SpacestationAvatarPlatformConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	self:checkCodeClearance(pPlayer)

	local screenID = SPACESTATION_AVATAR_PLATFORM_STAGES[self:getStage(pPlayer)]

	if (screenID == nil) then
		return convoTemplate:getScreen("spacestation_avatar_platform_greeting_trespass")
	end

	return convoTemplate:getScreen(screenID)
end

function SpacestationAvatarPlatformConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- QUEST GRANT (stage 0). s_80: "You have failed to comply with a direct order. Scrambling
	-- fighters for an intercept with trespassing vessel." destroy_surpriseattack/
	-- ep3_avatar_defensive_attack is exactly that intercept -- its own STF title_d says it is
	-- "triggered by failing to comply with the Avatar Space Platform's demands"
	-- (KashyyykHuntingScreenplay.lua:661). It carries no credit reward; it is the punishment.
	if (screenID == "spacestation_avatar_platform_defiant") then
		destroy_surpriseattack_ep3_avatar_defensive_attack:startQuest(pPlayer, pNpc)

	-- STAGE 1 -> 2. Both stage 1 terminals end with the platform coming apart, so either one
	-- leaves the comm system in the state the stage 2 hail (s_81 "...breaking up...station badly
	-- damaged...") describes:
	--   s_66 "Stand by to land on alpha pad. Good luck and watch your back. Things are nasty
	--        down here." -- the player is put onto the station while the fighting is still on.
	--   s_70 "Lock down sections eight through twelve...send in the...blast...end communication."
	--        -- the transmission is cut off mid-order; that IS the comms going down.
	elseif (screenID == "spacestation_avatar_platform_help" or screenID == "spacestation_avatar_platform_refuse") then
		self:setStage(pPlayer, 2)
	end

	return pScreenClone
end

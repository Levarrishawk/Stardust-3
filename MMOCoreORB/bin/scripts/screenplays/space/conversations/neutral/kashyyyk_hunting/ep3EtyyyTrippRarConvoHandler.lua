--[[
	Tripp Rar -- the ground giver for the Kashyyyk hunting quest head that had no giver:

		escort/ep3_hunting_tripp_protect_shipment   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua
	(escort_ep3_hunting_tripp_protect_shipment = SpaceEscortScreenplay:new, line 282, registered line
	332). That file is included by screenplays/space/screenplays.lua before this one, so the global is
	loaded by the time this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	Only the SPACE arc of this .stf is wired here. The Etyyy ground mouf hunt that fills the other
	half of the file is not built and not faked -- see the header of
	mobile/conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_tripp_rar_convo.lua for the full
	list of keys left out and why.

	REACHABILITY, STATED PLAINLY. ep3_etyyy_tripp_rar is not spawned anywhere in this repo, there are
	no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3EtyyyTrippRarConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questType/questName, lines 285-286).
EP3_TRIPP_SHIPMENT = {type = "escort", name = "ep3_hunting_tripp_protect_shipment"}

EP3_TRIPP_TAKEN_KEY = ":ep3_etyyy_tripp_rar:taken"       -- has ever accepted the escort
EP3_TRIPP_THANKED_KEY = ":ep3_etyyy_tripp_rar:thanked"   -- has been through the s_370 payoff

function Ep3EtyyyTrippRarConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyTrippRarConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_hunting_tripp_protect_shipment" does not contain "_duty",
-- so SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it; the
-- re-check is kept anyway so a refused grant leaves no residue.
function Ep3EtyyyTrippRarConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyTrippRarConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyTrippRarConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)

	if (complete) then
		-- s_378 is the end of her shipped space arc; after it she has nothing else wired to say, so
		-- she stays on her own "at least you defeated them" line rather than repeating the payoff.
		if (self:getFlag(pPlayer, EP3_TRIPP_THANKED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_tripp_mercenaries")
		end

		return convoTemplate:getScreen("ep3_tripp_complete")
	end

	if (active) then
		return convoTemplate:getScreen("ep3_tripp_in_flight")
	end

	-- Took it once and no longer holds it. See the FLAGGED INTERPRETATION block above
	-- ep3_tripp_failed in mobile/conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_tripp_rar_convo.lua.
	if (self:getFlag(pPlayer, EP3_TRIPP_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_tripp_failed")
	end

	return convoTemplate:getScreen("ep3_tripp_offer")
end

function Ep3EtyyyTrippRarConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_386 "Um, sure, I suppose I could do that." lands on ep3_tripp_accept.
	if (screenID == "ep3_tripp_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_tripp_no_space")
		end

		if (self:grant(pPlayer, pNpc, escort_ep3_hunting_tripp_protect_shipment, EP3_TRIPP_SHIPMENT)) then
			self:setFlag(pPlayer, EP3_TRIPP_TAKEN_KEY, 1)
		end

	-- THE RE-GRANT. s_230 "I could try again." lands on ep3_tripp_retry.
	elseif (screenID == "ep3_tripp_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_tripp_no_space")
		end

		self:grant(pPlayer, pNpc, escort_ep3_hunting_tripp_protect_shipment, EP3_TRIPP_SHIPMENT)

	-- s_376 "they just seemed like a random group of mercenaries" -- the end of the shipped arc.
	elseif (screenID == "ep3_tripp_mercenaries") then
		self:setFlag(pPlayer, EP3_TRIPP_THANKED_KEY, 1)
	end

	return pScreenClone
end

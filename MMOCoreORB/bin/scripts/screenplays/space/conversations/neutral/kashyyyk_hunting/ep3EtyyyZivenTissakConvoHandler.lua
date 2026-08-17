--[[
	Ziven Tissak -- the ground giver for the three Kashyyyk hunting quest heads that had no giver:

		rescue/ep3_hunting_ziven_fordans_ship                   (head, questZone space_kashyyyk)
		assassinate/ep3_hunting_ziven_vs_sordaans_freighter_01  (head, questZone space_kashyyyk)
		assassinate/ep3_hunting_ziven_vs_sordaans_freighter_02  (questZone space_kashyyyk)

	All three globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua (443/503,
	505/544, 546/585). That file is included by screenplays/space/screenplays.lua before this one, so
	all three globals are loaded by the time this handler runs.

	None of the three declares a sideQuest, so nothing hands any of them out on its own. freighter_02
	declares parentQuest = freighter_01, but that field is a fail-cascade only
	(SpaceAssassinateScreenplay.lua:121-122 fails the parent when the child fails) -- it is not a gate
	and it does not start anything. The ordering is enforced here instead, matching s_761 "Once you
	succeeded in that, we'll give you the location of the second freighter."

	This arc is the other half of Banol Starkiller's. Banol's recovery quest leaves Fordan's ship
	stripped at recoveryPoints[3] {3400, 3400, 3200}; Ziven's rescue quest sets rescueLocation to the
	same coordinate. Neither screenplay references the other, so a player can run either side first --
	which is correct, they are rival employers, not a single ladder.

	REACHABILITY, STATED PLAINLY. ep3_etyyy_ziven_tissak is not spawned anywhere in this repo, there
	are no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of those
	are addressed.
]]

Ep3EtyyyZivenTissakConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questType/questName at 446-447, 508-509, 549-550).
EP3_ZIVEN_FORDAN = {type = "rescue", name = "ep3_hunting_ziven_fordans_ship"}
EP3_ZIVEN_FREIGHTER_1 = {type = "assassinate", name = "ep3_hunting_ziven_vs_sordaans_freighter_01"}
EP3_ZIVEN_FREIGHTER_2 = {type = "assassinate", name = "ep3_hunting_ziven_vs_sordaans_freighter_02"}

EP3_ZIVEN_FORDAN_TAKEN_KEY = ":ep3_ziven:fordan_taken"
EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY = ":ep3_ziven:freighter1_taken"
EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY = ":ep3_ziven:freighter2_taken"

function Ep3EtyyyZivenTissakConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyZivenTissakConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). None of the three quest names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3EtyyyZivenTissakConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyZivenTissakConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyZivenTissakConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Walked backwards, deepest leg first, so a later leg always wins over an earlier one.
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FREIGHTER_2.type, EP3_ZIVEN_FREIGHTER_2.name)) then
		return convoTemplate:getScreen("ep3_ziven_complete")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FREIGHTER_2.type, EP3_ZIVEN_FREIGHTER_2.name)) then
		return convoTemplate:getScreen("ep3_ziven_freighter2_in_flight")
	end

	if (self:getFlag(pPlayer, EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_ziven_freighter2_failed")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FREIGHTER_1.type, EP3_ZIVEN_FREIGHTER_1.name)) then
		return convoTemplate:getScreen("ep3_ziven_freighter2_offer")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FREIGHTER_1.type, EP3_ZIVEN_FREIGHTER_1.name)) then
		return convoTemplate:getScreen("ep3_ziven_freighter1_in_flight")
	end

	if (self:getFlag(pPlayer, EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_ziven_freighter1_failed")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FORDAN.type, EP3_ZIVEN_FORDAN.name)) then
		return convoTemplate:getScreen("ep3_ziven_freighter1_offer")
	end

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FORDAN.type, EP3_ZIVEN_FORDAN.name)) then
		return convoTemplate:getScreen("ep3_ziven_fordan_in_flight")
	end

	-- Took the rescue once and no longer holds it. See the FLAGGED INTERPRETATION block above
	-- ep3_ziven_fordan_failed in the convo file.
	if (self:getFlag(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_ziven_fordan_failed")
	end

	return convoTemplate:getScreen("ep3_ziven_fordan_offer")
end

function Ep3EtyyyZivenTissakConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE RESCUE GRANT / RE-GRANT.
	if (screenID == "ep3_ziven_fordan_accept" or screenID == "ep3_ziven_fordan_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, rescue_ep3_hunting_ziven_fordans_ship, EP3_ZIVEN_FORDAN)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY, 1)
		end

	-- THE FIRST FREIGHTER GRANT / RE-GRANT.
	elseif (screenID == "ep3_ziven_freighter1_accept" or screenID == "ep3_ziven_freighter1_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01, EP3_ZIVEN_FREIGHTER_1)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY, 1)
		end

	-- THE SECOND FREIGHTER GRANT / RE-GRANT.
	elseif (screenID == "ep3_ziven_freighter2_accept" or screenID == "ep3_ziven_freighter2_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02, EP3_ZIVEN_FREIGHTER_2)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY, 1)
		end
	end

	return pScreenClone
end

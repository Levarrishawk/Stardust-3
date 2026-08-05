--[[
	Chrilooc -- the ground giver for the Kashyyyk hunting quest head that had no giver:

		recovery/ep3_hunting_chrilooc_medical_supplies   (head, questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua
	(recovery_ep3_hunting_chrilooc_medical_supplies = SpaceRecoveryScreenplay:new, line 591, registered
	line 652). That file is included by screenplays/space/screenplays.lua before this one, so the
	global is loaded by the time this handler runs.

	The quest has no parent and no side quest (sideQuest = false), so this conversation is its only
	entry point and its only retry point.

	REACHABILITY, STATED PLAINLY. ep3_etyyy_chrilooc is not spawned anywhere in this repo, there are
	no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3EtyyyChriloocConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questType/questName, lines 594-595).
EP3_CHRILOOC_SUPPLIES = {type = "recovery", name = "ep3_hunting_chrilooc_medical_supplies"}

EP3_CHRILOOC_TAKEN_KEY = ":ep3_etyyy_chrilooc:taken"   -- has ever accepted the recovery
EP3_CHRILOOC_TOLD_KEY = ":ep3_etyyy_chrilooc:told"     -- has heard the Etyyy lead (s_390)

--[[
	The Etyyy access gate is NOT a new flag. Kerssoc's own handler already writes
	EP3_KERSSOC_ACCESS_KEY (":ep3_etyyy_kerssoc:etyyy") at ep3EtyyyKerssocConvoHandler.lua:222, and
	that is exactly what s_384 ("Do whatever Kerssoc asks, and he should let you in") and s_394
	("Kerssoc can grant you access to the hunting grounds") describe. The constant is re-declared here
	only so this file does not depend on Kerssoc's load order; the string is identical.
]]
EP3_CHRILOOC_ETYYY_ACCESS_KEY = ":ep3_etyyy_kerssoc:etyyy"

--[[
	FLAGGED INTERPRETATION -- JOHNSON SMITH. s_368 ("You've spoken to Johnson Smith?") and s_366 ("So
	you discovered the truth") are written for a player who has already dealt with Johnson Smith.
	There is no Johnson Smith conversation in this repo -- his .stf ships (ep3_etyyy_johnson_smith)
	and his mobile ships (mobile/custom_content/ep3/ep3_etyyy_johnson_smith.lua), but nothing gives
	him a conversationTemplate. So NOTHING writes this key today and neither screen is reachable yet.
	A future Johnson Smith handler writes 1 when the player has spoken to him and 2 once the Brody
	Johnson truth is out; nothing in this file has to change.
]]
EP3_CHRILOOC_JOHNSON_KEY = ":ep3_etyyy_johnson_smith:progress"

function Ep3EtyyyChriloocConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyChriloocConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). "ep3_hunting_chrilooc_medical_supplies" does not contain
-- "_duty", so SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to it;
-- the re-check is kept anyway so a refused grant leaves no residue.
function Ep3EtyyyChriloocConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyChriloocConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

-- Is the player already working with Kerssoc? Any of Kerssoc's three space quests touched at all.
function Ep3EtyyyChriloocConvoHandler:withKerssoc(pPlayer)
	local names = {
		{type = "delivery_no_pickup", name = "ep3_hunting_kerssoc_smuggle_goods"},
		{type = "escort", name = "ep3_hunting_kerssoc_supplies"},
		{type = "assassinate", name = "ep3_hunting_kerssoc_destroy_chiss_weapons"},
	}

	for i = 1, #names, 1 do
		if (SpaceHelpers:isSpaceQuestActive(pPlayer, names[i].type, names[i].name)
			or SpaceHelpers:isSpaceQuestComplete(pPlayer, names[i].type, names[i].name)) then
			return true
		end
	end

	return false
end

function Ep3EtyyyChriloocConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local active = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_CHRILOOC_SUPPLIES.type, EP3_CHRILOOC_SUPPLIES.name)
	local complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_CHRILOOC_SUPPLIES.type, EP3_CHRILOOC_SUPPLIES.name)

	if (complete) then
		local johnson = self:getFlag(pPlayer, EP3_CHRILOOC_JOHNSON_KEY)

		-- Both of these are unreachable until a Johnson Smith chain exists. See the block above.
		if (johnson == 2) then
			return convoTemplate:getScreen("ep3_chrilooc_truth")
		end

		if (johnson == 1) then
			return convoTemplate:getScreen("ep3_chrilooc_johnson_done")
		end

		-- First time he pays out in information.
		if (self:getFlag(pPlayer, EP3_CHRILOOC_TOLD_KEY) ~= 1) then
			return convoTemplate:getScreen("ep3_chrilooc_complete")
		end

		-- Told already: Etyyy access decides which of his own follow-ups he opens on.
		if (self:getFlag(pPlayer, EP3_CHRILOOC_ETYYY_ACCESS_KEY) == 1) then
			return convoTemplate:getScreen("ep3_chrilooc_etyyy_return")
		end

		return convoTemplate:getScreen("ep3_chrilooc_no_access")
	end

	if (active) then
		return convoTemplate:getScreen("ep3_chrilooc_busy")
	end

	-- Took it once and no longer holds it. See the FLAGGED INTERPRETATION block above
	-- ep3_chrilooc_failed in mobile/conversations/space/neutral/kashyyyk_hunting/ep3_etyyy_chrilooc_convo.lua.
	if (self:getFlag(pPlayer, EP3_CHRILOOC_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_chrilooc_failed")
	end

	return convoTemplate:getScreen("ep3_chrilooc_greeting")
end

function Ep3EtyyyChriloocConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT. s_442 "Very well. I'll do it." lands on ep3_chrilooc_accept.
	if (screenID == "ep3_chrilooc_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_chrilooc_no_space")
		end

		if (self:grant(pPlayer, pNpc, recovery_ep3_hunting_chrilooc_medical_supplies, EP3_CHRILOOC_SUPPLIES)) then
			self:setFlag(pPlayer, EP3_CHRILOOC_TAKEN_KEY, 1)
		end

	-- THE RE-GRANT. s_416 "I understand. I'll try again." lands on ep3_chrilooc_retry.
	elseif (screenID == "ep3_chrilooc_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_chrilooc_retry_no_space")
		end

		self:grant(pPlayer, pNpc, recovery_ep3_hunting_chrilooc_medical_supplies, EP3_CHRILOOC_SUPPLIES)

	-- Heard the Etyyy lead. After this he opens on his own follow-ups, not on s_390 again.
	elseif (screenID == "ep3_chrilooc_complete") then
		self:setFlag(pPlayer, EP3_CHRILOOC_TOLD_KEY, 1)

	-- s_392 "How do I get to these hunting grounds?" -- the client ships two answers, s_396 for a
	-- player with no Kerssoc history and s_394 for one already working with him.
	elseif (screenID == "ep3_chrilooc_how") then
		if (self:withKerssoc(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_chrilooc_how_working")
		end
	end

	return pScreenClone
end

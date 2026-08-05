--[[
	Kerssoc -- the ground giver for the Kashyyyk hunting chain that had no giver:

		delivery_no_pickup/ep3_hunting_kerssoc_smuggle_goods   (head, questZone space_corellia)
			-> escort/ep3_hunting_kerssoc_supplies             (side quest, COMPLETION split)
				-> assassinate/ep3_hunting_kerssoc_destroy_chiss_weapons

	All three globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua and are
	registered there (lines 66, 120, 159). That file is included by screenplays/space/screenplays.lua
	before this one, so the globals are loaded by the time this handler runs.

	Only the HEAD is granted from a conversation. The other two are side quests that the screenplays
	hand out themselves on completion (sideQuest = true, SIDE_QUEST_SPLIT_TYPES.COMPLETION), so the
	two retry screens here are the recovery path for a failed or abandoned leg -- which is exactly
	what the client text says they are (s_1092 "I'll give you another chance", s_1082 "Ready to try
	your luck again?").

	REACHABILITY, STATED PLAINLY. ep3_etyyy_kerssoc is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed; nothing here depends on them, so it costs nothing to land now.
]]

Ep3EtyyyKerssocConvoHandler = conv_handler:new {}

-- The chain, in order. Names/types are copied from KashyyykHuntingScreenplay.lua verbatim.
EP3_KERSSOC_SMUGGLE = {type = "delivery_no_pickup", name = "ep3_hunting_kerssoc_smuggle_goods"}
EP3_KERSSOC_SUPPLIES = {type = "escort", name = "ep3_hunting_kerssoc_supplies"}
EP3_KERSSOC_WEAPONS = {type = "assassinate", name = "ep3_hunting_kerssoc_destroy_chiss_weapons"}

-- Handler-owned progression for the two GROUND legs, which have no screenplay to hang off.
-- 0 = not offered, 1 = accepted, 2 = settled.
EP3_KERSSOC_PELTS_KEY = ":ep3_etyyy_kerssoc:pelts" -- s_1132, 17 flawless Kashyyyk bantha pelts
EP3_KERSSOC_CAMP_KEY = ":ep3_etyyy_kerssoc:camp"   -- s_1072, 21 Chiss poachers
EP3_KERSSOC_ACCESS_KEY = ":ep3_etyyy_kerssoc:etyyy" -- s_1060/s_1064, access to the hunting grounds
EP3_KERSSOC_REFUSED_KEY = ":ep3_etyyy_kerssoc:refused"

--[[
	FLAGGED INTERPRETATION -- GROUND LEG PROGRESSION. There is no Kashyyyk ground screenplay, no
	Kashyyyk ground spawn areas and no "flawless Kashyyyk bantha pelt" collection task in this repo,
	so the 17-pelt and 21-poacher counts cannot be checked. With this true, each ground leg advances
	one step per hail: accept -> "go get them" -> settled. The dialogue is client fact; this
	progression is not.

	Set it to false once real ground quests exist, then replace the two getFlag() == 1 branches below
	with the real completion test. Nothing else in this file changes.
]]
KERSSOC_GROUND_LEGS_AUTO = true

function Ep3EtyyyKerssocConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyKerssocConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand a quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of these three names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to them; the
-- re-check is kept anyway so a refused grant leaves no residue.
function Ep3EtyyyKerssocConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

-- The delivery is flown, so it is only offered to someone who can fly it.
function Ep3EtyyyKerssocConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyKerssocConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local smuggleActive = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KERSSOC_SMUGGLE.type, EP3_KERSSOC_SMUGGLE.name)
	local smuggleComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KERSSOC_SMUGGLE.type, EP3_KERSSOC_SMUGGLE.name)
	local suppliesActive = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KERSSOC_SUPPLIES.type, EP3_KERSSOC_SUPPLIES.name)
	local suppliesComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KERSSOC_SUPPLIES.type, EP3_KERSSOC_SUPPLIES.name)
	local weaponsActive = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KERSSOC_WEAPONS.type, EP3_KERSSOC_WEAPONS.name)
	local weaponsComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KERSSOC_WEAPONS.type, EP3_KERSSOC_WEAPONS.name)

	local pelts = self:getFlag(pPlayer, EP3_KERSSOC_PELTS_KEY)
	local camp = self:getFlag(pPlayer, EP3_KERSSOC_CAMP_KEY)

	-- Chain finished and the gate is open.
	if (self:getFlag(pPlayer, EP3_KERSSOC_ACCESS_KEY) == 1) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_hunting_grounds")
	end

	-- Space chain done; the last ground leg, then the payoff.
	if (weaponsComplete) then
		if (camp == 0) then
			return convoTemplate:getScreen("ep3_etyyy_kerssoc_camp")
		end

		if (camp == 1) then
			if (KERSSOC_GROUND_LEGS_AUTO) then
				self:setFlag(pPlayer, EP3_KERSSOC_CAMP_KEY, 2)
			end

			return convoTemplate:getScreen("ep3_etyyy_kerssoc_camp_active")
		end

		return convoTemplate:getScreen("ep3_etyyy_kerssoc_access")
	end

	-- Third leg in flight.
	if (weaponsActive) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_busy_weapons")
	end

	-- Second leg done but the third never landed or was lost. s_1082 is the retry.
	if (suppliesComplete) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_weapons_retry")
	end

	-- Second leg in flight.
	if (suppliesActive) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_busy_escort")
	end

	-- Head done but the escort never landed or was lost. s_1092 is the retry.
	if (smuggleComplete) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_escort_retry")
	end

	-- Head in flight.
	if (smuggleActive) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_smuggle_active")
	end

	-- Pelts handed over; this is the screen that leads to the space quest.
	if (pelts == 2) then
		if (not self:canFly(pPlayer)) then
			return convoTemplate:getScreen("ep3_etyyy_kerssoc_pelts_turnin_nopilot")
		end

		return convoTemplate:getScreen("ep3_etyyy_kerssoc_pelts_turnin")
	end

	-- Pelt leg running.
	if (pelts == 1) then
		if (KERSSOC_GROUND_LEGS_AUTO) then
			self:setFlag(pPlayer, EP3_KERSSOC_PELTS_KEY, 2)
		end

		return convoTemplate:getScreen("ep3_etyyy_kerssoc_pelts_waiting")
	end

	-- Turned him down before.
	if (self:getFlag(pPlayer, EP3_KERSSOC_REFUSED_KEY) == 1) then
		return convoTemplate:getScreen("ep3_etyyy_kerssoc_no_hunter")
	end

	return convoTemplate:getScreen("ep3_etyyy_kerssoc_greeting")
end

function Ep3EtyyyKerssocConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- Ground leg accepted. s_1134 "I'll do it." lands here from both intro arcs.
	if (screenID == "ep3_etyyy_kerssoc_pelts_accept") then
		self:setFlag(pPlayer, EP3_KERSSOC_REFUSED_KEY, 0)
		self:setFlag(pPlayer, EP3_KERSSOC_PELTS_KEY, 1)

	-- Both shipped refusals.
	elseif (screenID == "ep3_etyyy_kerssoc_pelts_decline" or screenID == "ep3_etyyy_kerssoc_pelts_not_worth") then
		self:setFlag(pPlayer, EP3_KERSSOC_REFUSED_KEY, 1)

	-- THE GRANT. s_1110 "Okay, I'll deliver them." lands here.
	elseif (screenID == "ep3_etyyy_kerssoc_smuggle_accept") then
		self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods, EP3_KERSSOC_SMUGGLE)

	-- Retry of the escort leg. s_1094 "Yes I am." lands here.
	elseif (screenID == "ep3_etyyy_kerssoc_escort_retry_yes") then
		self:grant(pPlayer, pNpc, escort_ep3_hunting_kerssoc_supplies, EP3_KERSSOC_SUPPLIES)

	-- Retry of the weapons leg. s_1084 "I am. This time I'll succeed." lands here.
	elseif (screenID == "ep3_etyyy_kerssoc_weapons_retry_yes") then
		self:grant(pPlayer, pNpc, assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons, EP3_KERSSOC_WEAPONS)

	-- Second ground leg accepted.
	elseif (screenID == "ep3_etyyy_kerssoc_camp_accept") then
		self:setFlag(pPlayer, EP3_KERSSOC_CAMP_KEY, 1)

	-- The gate opens.
	elseif (screenID == "ep3_etyyy_kerssoc_access_yes") then
		self:setFlag(pPlayer, EP3_KERSSOC_ACCESS_KEY, 1)
	end

	return pScreenClone
end

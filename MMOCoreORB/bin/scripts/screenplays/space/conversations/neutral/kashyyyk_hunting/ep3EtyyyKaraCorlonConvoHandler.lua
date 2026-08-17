--[[
	Kara Corlon -- the ground giver for the Kashyyyk poacher delivery chain that had no giver:

		delivery_no_pickup/ep3_hunting_kara_poacher_delivery_01   (head, questZone space_dantooine)
			-> delivery_no_pickup/ep3_hunting_kara_poacher_delivery_02   (side quest, COMPLETION split)
				-> delivery_no_pickup/ep3_hunting_kara_poacher_delivery_03   (side quest, COMPLETION split)

	All three globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua and are
	registered there (lines 205, 241, 276). That file is included by screenplays/space/screenplays.lua
	before this one, so the globals are loaded by the time this handler runs.

	Only the HEAD is granted cold. Legs 02 and 03 carry SIDE_QUEST_SPLIT_TYPES.COMPLETION, so each
	screenplay hands the next one out itself; the s_54 and s_44 arcs are the client's own recovery
	lines ("Was there a mix up with the second delivery?", "Is there a problem with the last
	delivery?") and are used here for exactly that -- a leg that is neither running nor done.

	REACHABILITY, STATED PLAINLY. ep3_etyyy_kara_corlon is not spawned anywhere in this repo, there
	are no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3EtyyyKaraCorlonConvoHandler = conv_handler:new {}

-- The chain, in order. Names/types are copied from KashyyykHuntingScreenplay.lua verbatim.
EP3_KARA_1 = {type = "delivery_no_pickup", name = "ep3_hunting_kara_poacher_delivery_01"}
EP3_KARA_2 = {type = "delivery_no_pickup", name = "ep3_hunting_kara_poacher_delivery_02"}
EP3_KARA_3 = {type = "delivery_no_pickup", name = "ep3_hunting_kara_poacher_delivery_03"}

EP3_KARA_FAREWELL_KEY = ":ep3_etyyy_kara_corlon:farewell"

function Ep3EtyyyKaraCorlonConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyKaraCorlonConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand a leg out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of these three names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply to them; the
-- re-check is kept anyway so a refused grant leaves no residue.
function Ep3EtyyyKaraCorlonConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyKaraCorlonConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyKaraCorlonConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local a1 = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KARA_1.type, EP3_KARA_1.name)
	local c1 = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KARA_1.type, EP3_KARA_1.name)
	local a2 = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KARA_2.type, EP3_KARA_2.name)
	local c2 = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KARA_2.type, EP3_KARA_2.name)
	local a3 = SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KARA_3.type, EP3_KARA_3.name)
	local c3 = SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KARA_3.type, EP3_KARA_3.name)

	-- All three home.
	if (c3) then
		if (self:getFlag(pPlayer, EP3_KARA_FAREWELL_KEY) == 1) then
			return convoTemplate:getScreen("ep3_kara_done")
		end

		return convoTemplate:getScreen("ep3_kara_complete")
	end

	-- Leg 02 or 03 in flight. s_40 is the client's own "finish your current space tasks" line.
	if (a2 or a3) then
		return convoTemplate:getScreen("ep3_kara_busy_other")
	end

	-- Leg 03 dropped.
	if (c2) then
		return convoTemplate:getScreen("ep3_kara_leg3")
	end

	-- Leg 02 dropped.
	if (c1) then
		return convoTemplate:getScreen("ep3_kara_leg2")
	end

	-- Leg 01 in flight -- she nudges, she does not re-offer.
	if (a1) then
		return convoTemplate:getScreen("ep3_kara_leg1")
	end

	-- s_78 is a brush-off, not a pilot gate, so a non-pilot still gets the greeting; the client's
	-- own pilot gate for this NPC is s_86, which fires at the point of the offer.
	return convoTemplate:getScreen("ep3_kara_greeting")
end

function Ep3EtyyyKaraCorlonConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- THE GRANT of the head. s_84 "Yes, let's do this." lands on ep3_kara_accept.
	if (screenID == "ep3_kara_accept") then
		if (not self:canFly(pPlayer)) then
			-- s_86: "wait, you already have something to do in space" -- the client's own refusal at
			-- exactly this point in the conversation.
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_kara_busy_first")
		end

		self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kara_poacher_delivery_01, EP3_KARA_1)

	-- Re-offer of leg 02. s_56 "I'm on my way." lands on ep3_kara_leg2_go.
	elseif (screenID == "ep3_kara_leg2_go") then
		self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kara_poacher_delivery_02, EP3_KARA_2)

	-- Re-offer of leg 03. s_46 "I'll handle that delivery right now." lands on ep3_kara_leg3_go.
	elseif (screenID == "ep3_kara_leg3_go") then
		self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kara_poacher_delivery_03, EP3_KARA_3)

	-- s_76 "Thank you." -- after this she moves to s_36, her "we can't be seen talking" screen.
	elseif (screenID == "ep3_kara_farewell") then
		self:setFlag(pPlayer, EP3_KARA_FAREWELL_KEY, 1)
	end

	return pScreenClone
end

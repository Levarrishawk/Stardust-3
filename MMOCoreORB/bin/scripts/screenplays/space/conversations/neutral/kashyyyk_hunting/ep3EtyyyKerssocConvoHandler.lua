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

	Ground screens and java OnStartNpcConversation order folded in. ruling 2026-09-04.
	NO JOURNAL: do not call the journal engine.
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

function Ep3EtyyyKerssocConvoHandler:hasManfredsDelivery(pPlayer)
	return pPlayer ~= nil and huntManfredStealChissGoodsScreenPlay:isTaskActive(pPlayer, "manfred_deliverToKerssoc")
end

function Ep3EtyyyKerssocConvoHandler:hasCompletedAllQuests(pPlayer)
	return pPlayer ~= nil and (huntKerssocEnterEtyyyScreenPlay:isQuestActive(pPlayer) or huntKerssocEnterEtyyyScreenPlay:hasCompletedQuest(pPlayer))
end

function Ep3EtyyyKerssocConvoHandler:finishedAttackingChissCamp(pPlayer)
	return pPlayer ~= nil and (huntKerssocKillChissPoachersScreenPlay:isTaskActive(pPlayer, "kerssoc_attackChissPoachers") or huntKerssocKillChissPoachersScreenPlay:hasCompletedQuest(pPlayer))
end

function Ep3EtyyyKerssocConvoHandler:attackingChissCamp(pPlayer)
	return pPlayer ~= nil and huntKerssocKillChissPoachersScreenPlay:isTaskActive(pPlayer, "kerssoc_killingChissPoachers")
end

function Ep3EtyyyKerssocConvoHandler:hasCompletedDestroyWeaponsQuest(pPlayer)
	return pPlayer ~= nil and SpaceHelpers:isSpaceQuestComplete(pPlayer, "assassinate", "ep3_hunting_kerssoc_destroy_chiss_weapons")
end

function Ep3EtyyyKerssocConvoHandler:hasCompletedEscortQuest(pPlayer)
	return pPlayer ~= nil and SpaceHelpers:isSpaceQuestComplete(pPlayer, "escort", "ep3_hunting_kerssoc_supplies")
end

function Ep3EtyyyKerssocConvoHandler:hasCompletedDeliverQuest(pPlayer)
	return pPlayer ~= nil and SpaceHelpers:isSpaceQuestComplete(pPlayer, "delivery_no_pickup", "ep3_hunting_kerssoc_smuggle_goods")
end

function Ep3EtyyyKerssocConvoHandler:isOnDeliverQuest(pPlayer)
	return pPlayer ~= nil and SpaceHelpers:isSpaceQuestActive(pPlayer, "delivery_no_pickup", "ep3_hunting_kerssoc_smuggle_goods")
end

function Ep3EtyyyKerssocConvoHandler:finishedHuntingBantha(pPlayer)
	return pPlayer ~= nil and (huntKerssocBanthaPeltsScreenPlay:isTaskActive(pPlayer, "kerssoc_kashyyykBanthaPelts") or huntKerssocBanthaPeltsScreenPlay:hasCompletedQuest(pPlayer))
end

function Ep3EtyyyKerssocConvoHandler:isHuntingBantha(pPlayer)
	return pPlayer ~= nil and huntKerssocBanthaPeltsScreenPlay:isTaskActive(pPlayer, "kerssoc_huntingBantha")
end

function Ep3EtyyyKerssocConvoHandler:fromChrilooc(pPlayer)
	return pPlayer ~= nil and huntChriloocSeekRodiansScreenPlay:isTaskActive(pPlayer, "chrilooc_talkToKerssoc")
end

function Ep3EtyyyKerssocConvoHandler:alreadyHasSpaceMission(pPlayer)
	return EtyyyHuntState:hasAnySpaceQuest(pPlayer)
end

function Ep3EtyyyKerssocConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- java OnStartNpcConversation order (ep3_etyyy_kerssoc.java:700-1026)
	if (self:hasManfredsDelivery(pPlayer)) then
		EtyyyHuntState:raise(pPlayer, "manfred_deliverToKerssoc")
		return convoTemplate:getScreen("s_1056")
	elseif (self:hasCompletedAllQuests(pPlayer)) then
		return convoTemplate:getScreen("s_1058")
	elseif (self:finishedAttackingChissCamp(pPlayer)) then
		EtyyyHuntState:raise(pPlayer, "kerssoc_attackChissPoachers")
		return convoTemplate:getScreen("s_1060")
	elseif (self:attackingChissCamp(pPlayer)) then
		return convoTemplate:getScreen("s_1070")
	elseif (self:hasCompletedDestroyWeaponsQuest(pPlayer)) then
		return convoTemplate:getScreen("s_1072")
	elseif (self:hasCompletedEscortQuest(pPlayer)) then
		return convoTemplate:getScreen("s_1082")
	elseif (self:hasCompletedDeliverQuest(pPlayer)) then
		return convoTemplate:getScreen("s_1092")
	elseif (self:isOnDeliverQuest(pPlayer)) then
		return convoTemplate:getScreen("s_1102")
	elseif (self:finishedHuntingBantha(pPlayer)) then
		EtyyyHuntState:raise(pPlayer, "kerssoc_kashyyykBanthaPelts")
		return convoTemplate:getScreen("s_1104")
	elseif (self:isHuntingBantha(pPlayer)) then
		return convoTemplate:getScreen("s_1118")
	elseif (self:fromChrilooc(pPlayer)) then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("greet")
		end
		EtyyyHuntState:raise(pPlayer, "chrilooc_talkToKerssoc")
		return convoTemplate:getScreen("s_1124")
	end
	return convoTemplate:getScreen("s_1146")
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

	if (screenID == "s_1064") then
		EtyyyHuntState:raise(pPlayer, "chrilooc_gainEtyyyEntry")
		huntKerssocEnterEtyyyScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1076") then
		huntKerssocKillChissPoachersScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1086") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_1303")
		end
		EtyyyHuntState:grantSpace(pPlayer, pNpc, assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons, "assassinate", "ep3_hunting_kerssoc_destroy_chiss_weapons")
	elseif (screenID == "ep3_etyyy_kerssoc_weapons_retry_yes") then
		self:grant(pPlayer, pNpc, assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons, EP3_KERSSOC_WEAPONS)
	elseif (screenID == "s_1096") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_1302")
		end
		EtyyyHuntState:grantSpace(pPlayer, pNpc, escort_ep3_hunting_kerssoc_supplies, "escort", "ep3_hunting_kerssoc_supplies")
	elseif (screenID == "ep3_etyyy_kerssoc_escort_retry_yes") then
		self:grant(pPlayer, pNpc, escort_ep3_hunting_kerssoc_supplies, EP3_KERSSOC_SUPPLIES)
	elseif (screenID == "s_1112") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_1301")
		end
		EtyyyHuntState:grantSpace(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods, "delivery_no_pickup", "ep3_hunting_kerssoc_smuggle_goods")
	elseif (screenID == "ep3_etyyy_kerssoc_smuggle_accept") then
		self:grant(pPlayer, pNpc, delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods, EP3_KERSSOC_SMUGGLE)
	elseif (screenID == "s_1136") then
		huntKerssocBanthaPeltsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "ep3_etyyy_kerssoc_pelts_accept") then
		self:setFlag(pPlayer, EP3_KERSSOC_REFUSED_KEY, 0)
		self:setFlag(pPlayer, EP3_KERSSOC_PELTS_KEY, 1)
		huntKerssocBanthaPeltsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "ep3_etyyy_kerssoc_pelts_decline" or screenID == "ep3_etyyy_kerssoc_pelts_not_worth") then
		self:setFlag(pPlayer, EP3_KERSSOC_REFUSED_KEY, 1)
	elseif (screenID == "ep3_etyyy_kerssoc_camp_accept") then
		self:setFlag(pPlayer, EP3_KERSSOC_CAMP_KEY, 1)
	elseif (screenID == "ep3_etyyy_kerssoc_access_yes") then
		self:setFlag(pPlayer, EP3_KERSSOC_ACCESS_KEY, 1)
	end

	return pScreenClone
end

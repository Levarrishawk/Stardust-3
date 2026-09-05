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

	Ground screens and java OnStartNpcConversation order folded in. ruling 2026-09-04.
	NO JOURNAL: do not call the journal engine.
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

function Ep3EtyyyTrippRarConvoHandler:alreadyHasSpaceMission(pPlayer)
	return EtyyyHuntState:hasAnySpaceQuest(pPlayer)
end

function Ep3EtyyyTrippRarConvoHandler:killedBrightclaw(pPlayer)
	return huntLootBrightclawKilledScreenPlay:isQuestActive(pPlayer)
end

function Ep3EtyyyTrippRarConvoHandler:killedPaleclaw(pPlayer)
	return huntLootPaleclawKilledScreenPlay:isQuestActive(pPlayer)
end

function Ep3EtyyyTrippRarConvoHandler:killedBrightclawPlusAll(pPlayer)
	return huntLootPaleclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSilkthrowerKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootStonelegKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSpiketopKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootGreyclimberKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function Ep3EtyyyTrippRarConvoHandler:killedPaleclawPlusAll(pPlayer)
	return huntLootBrightclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSilkthrowerKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootStonelegKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSpiketopKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootGreyclimberKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function Ep3EtyyyTrippRarConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- ep3_etyyy_tripp_rar.java OnStartNpcConversation:1188-1750
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)) then
		return convoTemplate:getScreen("s_370")
	elseif ((self:getFlag(pPlayer, EP3_TRIPP_TAKEN_KEY) == 1 or EtyyyHuntState:spaceFailed(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)) and not SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)) then
		return convoTemplate:getScreen("s_156")
	elseif (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_TRIPP_SHIPMENT.type, EP3_TRIPP_SHIPMENT.name)) then
		return convoTemplate:getScreen("s_749")
	elseif (self:killedBrightclawPlusAll(pPlayer) and self:killedBrightclaw(pPlayer)) then
		return convoTemplate:getScreen("s_470")
	elseif (self:killedBrightclaw(pPlayer)) then
		return convoTemplate:getScreen("s_476")
	elseif (self:killedPaleclawPlusAll(pPlayer) and self:killedPaleclaw(pPlayer)) then
		return convoTemplate:getScreen("s_480")
	elseif (self:killedPaleclaw(pPlayer)) then
		return convoTemplate:getScreen("s_482")
	elseif (huntTrippCollectMoufIncisorsScreenPlay:hasCompletedQuest(pPlayer) and SpaceHelpers:isSpaceQuestComplete(pPlayer, "assassinate", "ep3_hunting_banol_destroy_tripps_goods")) then
		return convoTemplate:getScreen("s_384")
	elseif (huntTrippCollectMoufIncisorsScreenPlay:hasCompletedQuest(pPlayer)) then
		return convoTemplate:getScreen("s_398")
	elseif (huntTrippCollectMoufIncisorsScreenPlay:isTaskActive(pPlayer, "tripp_moufIncisors")) then
		return convoTemplate:getScreen("s_404")
	elseif (huntTrippCollectMoufIncisorsScreenPlay:isTaskActive(pPlayer, "tripp_collectingMoufIncisors")) then
		return convoTemplate:getScreen("s_418")
	elseif (huntTrippCollectMoufPeltsScreenPlay:isTaskActive(pPlayer, "tripp_moufPelts") or huntTrippCollectMoufPeltsScreenPlay:hasCompletedQuest(pPlayer)) then
		EtyyyHuntState:raise(pPlayer, "tripp_moufPelts")
		return convoTemplate:getScreen("s_424")
	elseif (huntTrippCollectMoufPeltsScreenPlay:isTaskActive(pPlayer, "tripp_collectingMoufPelts")) then
		return convoTemplate:getScreen("s_438")
	elseif (huntTrippCollectMoufPeltsScreenPlay:isTaskActive(pPlayer, "tripp_talkToTripp")) then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("greet")
		end
		return convoTemplate:getScreen("s_444")
	end
	return convoTemplate:getScreen("s_466")
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

	if (screenID == "s_470") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedBrightclaw")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_476") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedBrightclaw")
	elseif (screenID == "s_480") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedPaleclaw")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_482") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedPaleclaw")
	elseif (screenID == "s_388") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_750")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "escort", "ep3_hunting_tripp_protect_shipment", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, escort_ep3_hunting_tripp_protect_shipment, "escort", "ep3_hunting_tripp_protect_shipment")
		self:setFlag(pPlayer, EP3_TRIPP_TAKEN_KEY, 1)
	elseif (screenID == "s_408") then
		EtyyyHuntState:raise(pPlayer, "tripp_moufIncisors")
		EtyyyHuntState:raise(pPlayer, "sordaan_trippSendsYou")
		huntSordaanSeekSordaanScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_428") then
		huntTrippCollectMoufIncisorsScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_452") then
		EtyyyHuntState:raise(pPlayer, "tripp_talkToTripp")
	-- THE GRANT. s_386 "Um, sure, I suppose I could do that." lands on ep3_tripp_accept.
	elseif (screenID == "ep3_tripp_accept") then
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

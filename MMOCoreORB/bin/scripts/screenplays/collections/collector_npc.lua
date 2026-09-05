-- Collector NPC loop (ruling 2026-09-04: "finish ... collections").
-- SOURCED offer: collection.java:410-551 (showNpcCollections / findAndGrantSlot /
-- checkMaxActive / npcHasMoreCollections). Conversation-free SUI: OURS (the mobiles
-- have no dialogue tree; CreatureTemplate.cpp does not parse objectMenuComponent, so
-- conversationTemplate opens the same SUI).
-- SOURCED removal: collection.java:730 showNpcCollectionsRemoval, :680 removeCollection,
-- novicecollector.java:882-932 handleCollectionRemoval -> @collection:confirm_delete_prompt
-- YES/NO -> handlePlayerConfirmedCollectionDelete. The offer-list "#remove" row is OURS
-- (conversation-free stand-in for the convo option that called showNpcCollectionsRemoval).
-- SOURCED collectorsByTemplate: creatures.tab column template (line citations on each row).
-- Override: per-NPC writeStringData keyed by object id (<oid>:collection.columnName), then
-- customName if it matches a CollectionData.npcs collector, then the template map.

CollectorNpcScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectorNpcScreenPlay",
	MAX_ACTIVE = 2,
	collectorsByTemplate = {
		["npc_dressed_collection_npc_female_human_03"] = "novice_collector", -- SOURCED creatures.tab:3735
		["npc_dressed_collection_npc_female_mon_01"] = "nexus_collector", -- SOURCED creatures.tab:5780
		["npc_dressed_collection_npc_female_zab_01"] = "tatooine_collector", -- SOURCED creatures.tab:5781
		["npc_dressed_collection_npc_male_bith_01"] = "corellia_collector", -- SOURCED creatures.tab:5782
		["npc_dressed_collection_npc_male_human_01"] = "dantooine_collector", -- SOURCED creatures.tab:5783
		["npc_dressed_collection_npc_male_human_02"] = "endor_collector", -- SOURCED creatures.tab:5784
		["npc_dressed_collection_npc_male_ithorian_01"] = "lok_collector", -- SOURCED creatures.tab:5785
		["npc_dressed_collection_npc_male_ithorian_02"] = "yavin4_collector", -- SOURCED creatures.tab:5786
	},
}

registerScreenPlay("CollectorNpcScreenPlay", true)

function CollectorNpcScreenPlay:start()
	CollectionManager.addListener(function(pPlayer)
		CollectorNpcScreenPlay:ensureKillObserver(pPlayer)
	end)
end

function CollectorNpcScreenPlay:npcRow(collectorName)
	if (collectorName == nil or CollectionData.npcs == nil) then
		return nil
	end

	for i = 1, #CollectionData.npcs do
		if (CollectionData.npcs[i].collector == collectorName) then
			return CollectionData.npcs[i]
		end
	end

	return nil
end

function CollectorNpcScreenPlay:getCollectorName(pNpc)
	if (pNpc == nil) then
		return nil
	end

	-- Per-NPC key (object id), not a global DirectorManager name. Spawn writes this.
	local oid = SceneObject(pNpc):getObjectID()
	local stored = readStringData(oid .. ":collection.columnName")

	if (stored ~= nil and stored ~= "") then
		return stored
	end

	local custom = SceneObject(pNpc):getCustomObjectName()

	if (custom ~= nil and self:npcRow(custom) ~= nil) then
		return custom
	end

	if (not SceneObject(pNpc):isAiAgent()) then
		return nil
	end

	return self.collectorsByTemplate[AiAgent(pNpc):getCreatureTemplateName()]
end

function CollectorNpcScreenPlay:availableAndActive(pPlayer, collectorName)
	local available = {}
	local active = {}
	local row = self:npcRow(collectorName)

	if (pPlayer == nil or row == nil or row.entries == nil) then
		return available, active
	end

	for i = 1, #row.entries do
		local entry = row.entries[i]
		local hasActivation = CollectionManager.hasCompletedCollectionSlot(pPlayer, entry.slot)
		local complete = CollectionManager.hasCompletedCollection(pPlayer, entry.collection)

		if (not hasActivation) then
			table.insert(available, entry)
		elseif (not complete) then
			table.insert(active, entry)
		end
	end

	return available, active
end

function CollectorNpcScreenPlay:checkMaxActive(pPlayer, collectorName)
	local _, active = self:availableAndActive(pPlayer, collectorName)
	return #active >= self.MAX_ACTIVE
end

function CollectorNpcScreenPlay:npcHasMoreCollections(pPlayer, collectorName)
	local available = self:availableAndActive(pPlayer, collectorName)
	return #available > 0
end

function CollectorNpcScreenPlay:ensureKillObserver(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "killObserver")) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "CollectorNpcScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "killObserver", "1")
end

function CollectorNpcScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (not SceneObject(pVictim):isAiAgent()) then
		return 0
	end

	-- SOURCED base_player.java:10563-10617 receiveCreditForKill: category is
	-- "kill_" .. creature objectName only. Template name and social group are not
	-- credited (a mutant_rancor must not also advance kill_rancor).
	local objectName = SceneObject(pVictim):getObjectName()

	if (objectName == nil or objectName == "") then
		return 0
	end

	local slots = CollectionManager.getAllCollectionSlotsInCategory("kill_" .. objectName)

	for s = 1, #slots do
		local slotName = slots[s]

		if (CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)) then
			if (not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)) then
				CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)
			end
		end
	end

	return 0
end

function CollectorNpcScreenPlay:openOffer(pPlayer, pNpc)
	if (pPlayer == nil or pNpc == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	self:ensureKillObserver(pPlayer)

	local collectorName = self:getCollectorName(pNpc)

	if (collectorName == nil) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "collector", collectorName)
	writeScreenPlayData(pPlayer, self.screenplayName, "npcId", tostring(SceneObject(pNpc):getObjectID()))

	if (self:checkMaxActive(pPlayer, collectorName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:max_active_collections")
		return
	end

	if (not self:npcHasMoreCollections(pPlayer, collectorName)) then
		CreatureObject(pPlayer):sendSystemMessage("@conversation/collections_collector:s_22")
		return
	end

	self:showNpcCollections(pPlayer, pNpc, collectorName)
end

function CollectorNpcScreenPlay:showNpcCollections(pPlayer, pNpc, collectorName)
	local available, active = self:availableAndActive(pPlayer, collectorName)
	local sui = SuiListBox.new("CollectorNpcScreenPlay", "offerCallback")
	sui.setTitle("@collection:col_npc_title")
	sui.setPrompt("@collection:col_npc_prompt")
	sui.setForceCloseDistance(16)
	sui.setOkButtonText("@ui:ok")
	sui.showOtherButton()
	sui.setOtherButtonText("@conversation/novicecollector:s_47")
	sui.setTargetNetworkId(SceneObject(pNpc):getObjectID())

	if (#active > 0) then
		sui.add("@collection:collection_sui_delete_title", "#remove")
	end

	for i = 1, #available do
		sui.add("@collection_n:" .. available[i].collection, available[i].collection)
	end

	sui.sendTo(pPlayer)
end

function CollectorNpcScreenPlay:showRemoval(pPlayer, pNpc, collectorName)
	local _, active = self:availableAndActive(pPlayer, collectorName)
	local sui = SuiListBox.new("CollectorNpcScreenPlay", "removalCallback")
	sui.setTitle("@collection:collection_sui_delete_title")
	sui.setPrompt("@collection:collection_sui_delete_prompt")
	sui.setForceCloseDistance(16)
	sui.setOkButtonText("@ui:ok")
	sui.setTargetNetworkId(SceneObject(pNpc):getObjectID())

	for i = 1, #active do
		sui.add("@collection_n:" .. active[i].collection .. "_finished", active[i].collection)
	end

	if (#active == 0) then
		sui.add("@conversation/collections_collector:s_38", "")
	end

	sui.sendTo(pPlayer)
end

function CollectorNpcScreenPlay:findAndGrantSlot(pPlayer, collectorName, selectedCollection)
	local row = self:npcRow(collectorName)

	if (pPlayer == nil or row == nil or selectedCollection == nil or selectedCollection == "") then
		return false
	end

	if (self:checkMaxActive(pPlayer, collectorName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:max_active_collections")
		return false
	end

	for i = 1, #row.entries do
		if (row.entries[i].collection == selectedCollection) then
			self:ensureKillObserver(pPlayer)
			return CollectionManager.modifyCollectionSlotValue(pPlayer, row.entries[i].slot, 1)
		end
	end

	return false
end

function CollectorNpcScreenPlay:offerCallback(pPlayer, pSui, eventIndex, args, otherPressed)
	if (pPlayer == nil) then
		return
	end

	if (eventIndex == 1) then
		return
	end

	if (otherPressed == "true") then
		CollectionsUI:open(pPlayer)
		return
	end

	local selected = ""
	local row = tonumber(args)

	if (row ~= nil) then
		local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

		if (pPageData ~= nil) then
			selected = LuaSuiPageData(pPageData):getStoredData(tostring(row)) or ""
		end
	end

	local collectorName = readScreenPlayData(pPlayer, self.screenplayName, "collector")
	local npcId = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "npcId")) or 0
	local pNpc = getSceneObject(npcId)

	if (selected == "#remove") then
		if (pNpc ~= nil) then
			self:showRemoval(pPlayer, pNpc, collectorName)
		end

		return
	end

	if (selected == "") then
		return
	end

	self:findAndGrantSlot(pPlayer, collectorName, selected)
end

function CollectorNpcScreenPlay:removalCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	local selected = ""
	local row = tonumber(args)

	if (row ~= nil) then
		local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

		if (pPageData ~= nil) then
			selected = LuaSuiPageData(pPageData):getStoredData(tostring(row)) or ""
		end
	end

	if (selected == "") then
		return
	end

	if (CollectionManager.hasCompletedCollection(pPlayer, selected)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:collection_complete_can_not_clear")
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "selectedToDelete", selected)

	local npcId = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "npcId")) or 0
	local pNpc = getSceneObject(npcId)
	local sui = SuiMessageBox.new("CollectorNpcScreenPlay", "confirmDeleteCallback")
	sui.setTitle("@collection:confirm_delete_title")
	sui.setPrompt("@collection:confirm_delete_prompt")
	sui.setForceCloseDistance(16)
	sui.setOkButtonText("@ui:yes")
	sui.setCancelButtonText("@ui:no")

	if (pNpc ~= nil) then
		sui.setTargetNetworkId(SceneObject(pNpc):getObjectID())
	end

	sui.sendTo(pPlayer)
end

function CollectorNpcScreenPlay:confirmDeleteCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local selected = readScreenPlayData(pPlayer, self.screenplayName, "selectedToDelete")
	deleteScreenPlayData(pPlayer, self.screenplayName, "selectedToDelete")

	if (eventIndex ~= 0) then
		return
	end

	if (selected == nil or selected == "") then
		return
	end

	if (CollectionManager.hasCompletedCollection(pPlayer, selected)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:collection_complete_can_not_clear")
		return
	end

	CollectionManager.clearCollection(pPlayer, selected)
	CreatureObject(pPlayer):sendSystemMessage("@collection:collection_cleared")
end

CollectorNpcMenuComponent = { }

function CollectorNpcMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@collection:col_npc_title")
end

function CollectorNpcMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	CollectorNpcScreenPlay:openOffer(pPlayer, pSceneObject)
	return 0
end

collectorNpcConvoTemplate = ConvoTemplate:new {
	initialScreen = "start",
	templateType = "Lua",
	luaClassHandler = "collectorNpcConvoHandler",
	screens = {}
}

collectorNpcConvoStart = ConvoScreen:new {
	id = "start",
	leftDialog = "@collection:col_npc_prompt",
	stopConversation = "true",
	options = {}
}
collectorNpcConvoTemplate:addScreen(collectorNpcConvoStart)

addConversationTemplate("collectorNpcConvoTemplate", collectorNpcConvoTemplate)

collectorNpcConvoHandler = conv_handler:new {}

function collectorNpcConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	CollectorNpcScreenPlay:openOffer(pPlayer, pNpc)
	return nil
end

--[[
Myyydril junk compactor SUI  --  theme_park.dungeon.myyydril.junk_compactor

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live attached junk_compactor.java to the lightningroom34 giver
(ep3_myyydril_caverns.tab file line 833, script npc.converse.junk_dealer,
conversation.ep3_myyydril_compactor). The conversation is the Myyydril arc.
This file is the SUI that conversation opens.

Export: MyyydrilCompactor.open(pPlayer)

JAVA -> LUA

	junk_compactor.java:39-66   inventory scan vs ep3_myyydril_compactor.tab
	                            (utils.getFilteredPlayerContents at :45 is
	                            recursive; bank / datapad / mission excluded)
	junk_compactor.java:67-107  listbox / no-items msgbox
	junk_compactor.java:157-185 sell one (price > 0 and not quest_item :172)
	junk_compactor.java:226-275 sell all (java Vector junk is never filled
	                            from tmp -- OURS sells the scanned list)

	OURS payout: java money.systemPayout(ACCT_RELIC_DEALER, player, price,
	"handleSoldJunk") at :179 (async account credit, destroy on success
	:218). Core3 has no relic-dealer account payout; addCashCredits then
	destroy (JunkDealer:sellAllItems shape, junk_dealer.lua:126).

Prices are the tab (file lines 3-15). Input IFFs are listed even when the
template is not in this tree; a missing item simply never matches. No new stf.
--]]

MyyydrilCompactor = {
	-- ep3_myyydril_compactor.tab file lines 3-15. price -1 means "do not buy"
	-- in the java (>= 0 to list; > 0 and not quest_item to pay).
	prices = {
		["object/tangible/loot/quest/mind_pod_eye.iff"] = 1000,           -- tab file line 3
		["object/tangible/loot/quest/mind_pod_sac.iff"] = 900,            -- tab file line 4
		["object/tangible/loot/quest/mind_pod_brain.iff"] = 2000,         -- tab file line 5
		["object/tangible/loot/quest/mind_pod_stomach.iff"] = 800,        -- tab file line 6
		["object/tangible/loot/quest/naktra_crystal.iff"] = 3000,         -- tab file line 7
		["object/tangible/loot/quest/mind_pod_parasites.iff"] = 700,      -- tab file line 8
		["object/tangible/loot/quest/mind_pod_blood.iff"] = 1500,         -- tab file line 9
		["object/tangible/loot/quest/mind_pod_guts.iff"] = 1800,          -- tab file line 10
		["object/tangible/loot/quest/mind_pod_slime.iff"] = 2500,         -- tab file line 11
		["object/tangible/loot/quest/decomposed_foot.iff"] = 1900,        -- tab file line 12
		["object/tangible/loot/quest/decomposed_hand.iff"] = 2100,        -- tab file line 13
		["object/tangible/loot/quest/decomposed_skull.iff"] = 1550,       -- tab file line 14
		["object/tangible/loot/quest/broken_bottle.iff"] = 100,           -- tab file line 15
	},
}

function MyyydrilCompactor.open(pPlayer)
	MyyydrilCompactor:showSellJunkSui(pPlayer)
end

function MyyydrilCompactor:priceOf(pItem)
	if (pItem == nil) then
		return -1
	end

	local template = SceneObject(pItem):getTemplateObjectPath()
	local price = self.prices[template]

	if (price == nil) then
		return -1
	end

	return price
end

function MyyydrilCompactor:isQuestItem(pItem)
	-- junk_compactor.java:172 hasObjVar(item, "quest_item").
	-- OPEN: no hasObjVar / getObjVar Lua binding in this tree
	-- (LuaSceneObject.cpp, LuaTangibleObject.cpp). The pay path still
	-- consults this guard so a later binding can fill it in.
	return false
end

function MyyydrilCompactor:getAllJunkItems(pPlayer)
	local junk = {}
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return junk
	end

	-- java utils.getFilteredPlayerContents (utils.java:1319) walks player
	-- contents recursively, excluding bank / datapad / mission. Starting at
	-- inventory and recursing nested containers is that scan. Equipped
	-- items live in slots, so they are not listed (java !isEquipped).
	-- Row shape and craftersName filter: JunkDealer:getEligibleJunk
	-- (junk_dealer.lua:44 / :67). That helper is not recursive, so the
	-- walk itself is local.
	self:scanContainer(pInventory, junk)
	return junk
end

function MyyydrilCompactor:scanContainer(pContainer, junk)
	if (pContainer == nil) then
		return
	end

	for i = 0, SceneObject(pContainer):getContainerObjectsSize() - 1 do
		local pItem = SceneObject(pContainer):getContainerObject(i)

		if (pItem ~= nil) then
			if (TangibleObject(pItem):getCraftersName() == "") then
				if (self:priceOf(pItem) >= 0) then
					local text = "[" .. self:priceOf(pItem) .. "] " .. SceneObject(pItem):getDisplayedName()
					table.insert(junk, { text, SceneObject(pItem):getObjectID() })
				end
			end

			if (SceneObject(pItem):getContainerObjectsSize() > 0) then
				self:scanContainer(pItem, junk)
			end
		end
	end
end

function MyyydrilCompactor:showSellJunkSui(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local junk = self:getAllJunkItems(pPlayer)

	if (#junk == 0) then
		local sui = SuiMessageBox.new("MyyydrilCompactor", "noCallback")
		sui.setTitle("@loot_dealer:sell_title")
		sui.setPrompt("@loot_dealer:no_items")
		sui.sendTo(pPlayer)
		return
	end

	local suiManager = LuaSuiManager()
	suiManager:sendListBox(pPlayer, pPlayer, "@loot_dealer:sell_title", "@loot_dealer:sell_prompt", 3, "@cancel", "@loot_dealer:btn_sell_all", "@loot_dealer:btn_sell", "MyyydrilCompactor", "handleSellJunkSui", 10, junk)
end

function MyyydrilCompactor:noCallback()
end

function MyyydrilCompactor:handleSellJunkSui(pPlayer, pSui, eventIndex, otherPressed, rowIndex)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	if (otherPressed == "true") then
		self:sellAllJunk(pPlayer)
		return
	end

	rowIndex = tonumber(rowIndex)

	if (rowIndex == nil or rowIndex < 0) then
		return
	end

	local listBox = LuaSuiListBox(pSui)
	local oid = listBox:getMenuObjectID(rowIndex)
	local pItem = getSceneObject(oid)
	self:sellJunkItem(pPlayer, pItem, true)
end

function MyyydrilCompactor:sellJunkItem(pPlayer, pItem, reshowSui)
	if (pPlayer == nil or pItem == nil) then
		return
	end

	if (readData(SceneObject(pItem):getObjectID() .. ":MyyydrilCompactor:sold") == 1) then
		local already = LuaStringIdChatParameter("@loot_dealer:prose_junk_sold")
		already:setTT(SceneObject(pItem):getDisplayedName())
		CreatureObject(pPlayer):sendSystemMessage(already:_getObject())
		return
	end

	local price = self:priceOf(pItem)

	-- junk_compactor.java:172 price > 0 && !hasObjVar(item, "quest_item")
	if (price <= 0 or self:isQuestItem(pItem)) then
		local noBuy = LuaStringIdChatParameter("@loot_dealer:prose_no_buy")
		noBuy:setTT(SceneObject(pItem):getDisplayedName())
		CreatureObject(pPlayer):sendSystemMessage(noBuy:_getObject())
		return
	end

	writeData(SceneObject(pItem):getObjectID() .. ":MyyydrilCompactor:sold", 1)
	-- OURS: java :179 money.systemPayout(ACCT_RELIC_DEALER, ...); Core3
	-- addCashCredits (LuaCreatureObject.cpp:106 / :764).
	CreatureObject(pPlayer):addCashCredits(price, true)

	local sold = LuaStringIdChatParameter("@loot_dealer:prose_sold_junk")
	sold:setTT(SceneObject(pItem):getDisplayedName())
	sold:setDI(price)
	CreatureObject(pPlayer):sendSystemMessage(sold:_getObject())

	createEvent(10, "MyyydrilCompactor", "destroyItem", pItem, "")

	if (reshowSui) then
		self:showSellJunkSui(pPlayer)
	end
end

function MyyydrilCompactor:destroyItem(pItem)
	if (pItem == nil) then
		return
	end

	SceneObject(pItem):destroyObjectFromWorld()
	SceneObject(pItem):destroyObjectFromDatabase()
end

function MyyydrilCompactor:sellAllJunk(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local junk = self:getAllJunkItems(pPlayer)

	if (#junk == 0) then
		local sui = SuiMessageBox.new("MyyydrilCompactor", "noCallback")
		sui.setTitle("@loot_dealer:sell_title")
		sui.setPrompt("@loot_dealer:no_items")
		sui.sendTo(pPlayer)
		return
	end

	local total = 0
	local sold = 0

	for i = 1, #junk do
		local pItem = getSceneObject(junk[i][2])

		if (pItem ~= nil and readData(SceneObject(pItem):getObjectID() .. ":MyyydrilCompactor:sold") ~= 1) then
			local price = self:priceOf(pItem)

			if (price > 0 and not self:isQuestItem(pItem)) then
				writeData(SceneObject(pItem):getObjectID() .. ":MyyydrilCompactor:sold", 1)
				total = total + price
				sold = sold + 1
				createEvent(10, "MyyydrilCompactor", "destroyItem", pItem, "")
			end
		end
	end

	if (total <= 0) then
		CreatureObject(pPlayer):sendSystemMessage("@loot_dealer:prose_no_buy_all")
		return
	end

	-- OURS: java :267 money.systemPayout(ACCT_RELIC_DEALER, ...) on sell-all.
	CreatureObject(pPlayer):addCashCredits(total, true)

	local msg = LuaStringIdChatParameter("@loot_dealer:prose_sold_all_junk")
	msg:setDI(total)
	CreatureObject(pPlayer):sendSystemMessage(msg:_getObject())
end

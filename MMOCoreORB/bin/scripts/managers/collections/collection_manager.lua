--[[
	CollectionManager — Lua port of the SOE collection natives over CollectionData.

	Read natives (base_class.java:15290-15382), same names, same argument order:
	  getCollectionSlotInfo(slotName) -> {book, page, collection, music}
	  isCollectionSlotATitle(slotName) / isCollectionATitle(collectionName) / isCollectionPageATitle(pageName)
	  getCollectionSlotCategoryInfo(slotName)
	  getCollectionSlotPrereqInfo(slotName)
	  getCollectionSlotName(slotId)
	  getAllCollectionSlotsInCollection(collectionName)
	  getAllCollectionSlotsInPage(pageName) / getAllCollectionsInPage(pageName)
	  getAllCollectionSlotsInBook(bookName) / getAllCollectionsInBook(bookName) / getAllCollectionPagesInBook(bookName)
	  getAllCollectionBooks()
	  getAllCollectionSlotsInCategory(categoryName)
	  getAllCollectionSlotsInCategoryInCollection(collectionName, categoryName)
	  getAllCollectionSlotsInCategoryInPage(pageName, categoryName)
	  getAllCollectionSlotsInCategoryInBook(bookName, categoryName)
	  getAllCollectionSlotCategoriesInCollection(collectionName)
	  getAllCollectionSlotCategoriesInPage(pageName)
	  getAllCollectionSlotCategoriesInBook(bookName)
	  getAllCollectionSlotCategories()
	  getCollectionSlotMaxValue(slotName)

	Player state (base_class.java:15163-15221), persisted writeScreenPlayData/readScreenPlayData
	as screenPlay "Collections" + variable slotName (the Collections:<slotName> key). Never sent
	on the wire.
	  modifyCollectionSlotValue(pPlayer, slotName, delta)
	  getCollectionSlotValue(pPlayer, slotName)
	  hasCompletedCollectionSlotPrereq(pPlayer, slotName)
	  hasCompletedCollectionSlot(pPlayer, slotName)
	  hasCompletedCollection(pPlayer, collectionName)
	  hasCompletedCollectionPage(pPlayer, pageName)
	  hasCompletedCollectionBook(pPlayer, bookName)

	On every actual change: onSlotModified(pPlayer, book, page, collection, slot, isCounter,
	prev, cur, max, completed) — addListener(fn) is the OnCollectionSlotModified hook.

	Rewards (collection.java:95 grantCollectionReward; player_collection.java:27):
	  rewardsFor(collectionName)
	  grantCollectionReward(pPlayer, collectionName, canReset)
	Implemented kinds: item (iff path only), xpModifier, quest_signal (hook), reward_text (shipped prose),
	slot_name (via modifyCollectionSlotValue).
	OPEN: command, skill_mod, crafting_template, grantRandomItem, grantWeightedRandom, quest,
	item static_item names (no iff path — NGE createStaticItem).
]]

require("managers.collections.collection_data")

CollectionManager = CollectionManager or {}

CollectionManager.SCREENPLAY = "Collections"
CollectionManager.BADGE_BOOK = "badge_book"
CollectionManager.REWARD_ON_UPDATE = "rewardOnUpdate"
CollectionManager.REWARD_ON_COMPLETE = "rewardOnComplete"
CollectionManager.CLEAR_ON_COMPLETE = "clearOnComplete"
CollectionManager.UPDATE_ON_COUNT = "updateOnCount"
CollectionManager.NO_MESSAGE = "noMessage"
CollectionManager.NO_SCRIPT_NOTIFY = "noScriptNotifyOnModify"

-- XP amount rule (OURS). SOE xp.java:1933 grantCollectionXP is xpModifier * (XP in the current
-- NGE combat-level band) and grantXpByTemplate uses quest_combat / quest_crafting / quest_social,
-- none of which this tree has. mustafar_quest_xp.lua already ruled combat_general as the
-- substitution for unknown NGE XP types (PlayerObjectImplementation.cpp falls through to a
-- 2000 cap on an unknown type). Amount: math.floor(xpModifier * 1000) combat_general, or
-- space_combat_general when isSpaceXp is set (PlayerManagerImplementation.cpp already awards
-- that type). xpModifier in rewards.tab is 0 / 0.1 / 0.2 / 0.25 / 0.3, so the grant is 0 / 100
-- / 200 / 250 / 300 — the same scale as kidnappedNobleConvoHandler.lua:21 (250 combat_general).
CollectionManager.XP_MODIFIER_SCALE = 1000
CollectionManager.XP_TYPE = "combat_general"
CollectionManager.SPACE_XP_TYPE = "space_combat_general"

CollectionManager.OPEN_REWARD_KINDS = {
	"command",
	"skill_mod",
	"crafting_template",
	"grantRandomItem",
	"grantWeightedRandom",
	"quest",
	"item static_item names (no iff path)",
}

CollectionManager.listeners = CollectionManager.listeners or {}
CollectionManager.questSignalListeners = CollectionManager.questSignalListeners or {}

function CollectionManager.addListener(fn)
	if fn == nil then
		return
	end

	CollectionManager.listeners[#CollectionManager.listeners + 1] = fn
end

function CollectionManager.addQuestSignalListener(fn)
	if fn == nil then
		return
	end

	CollectionManager.questSignalListeners[#CollectionManager.questSignalListeners + 1] = fn
end

local function slotIndex(slotName)
	return CollectionData.slotByName[slotName]
end

local function collectionIndex(collectionName)
	return CollectionData.collectionByName[collectionName]
end

local function pageIndex(pageName)
	return CollectionData.pageByName[pageName]
end

local function bookIndex(bookName)
	return CollectionData.bookByName[bookName]
end

local function bookAt(bi)
	return CollectionData.books[bi]
end

local function pageAt(bi, pi)
	local book = bookAt(bi)
	if book == nil then
		return nil
	end

	return book.pages[pi]
end

local function collectionAt(bi, pi, ci)
	local page = pageAt(bi, pi)
	if page == nil then
		return nil
	end

	return page.collections[ci]
end

local function slotAt(bi, pi, ci, si)
	local collection = collectionAt(bi, pi, ci)
	if collection == nil then
		return nil
	end

	return collection.slots[si]
end

local function resolveSlot(slotName)
	local idx = slotIndex(slotName)
	if idx == nil then
		return nil
	end

	local book = bookAt(idx[1])
	local page = pageAt(idx[1], idx[2])
	local collection = collectionAt(idx[1], idx[2], idx[3])
	local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
	if book == nil or page == nil or collection == nil or slot == nil then
		return nil
	end

	return book, page, collection, slot
end

local function hasCategory(slot, categoryName)
	local categories = slot.categories
	if categories == nil then
		return false
	end

	for i = 1, #categories do
		if categories[i] == categoryName then
			return true
		end
	end

	return false
end

local function uniqueAppend(list, seen, value)
	if value == nil or value == "" or seen[value] then
		return
	end

	seen[value] = true
	list[#list + 1] = value
end

local function slotsInCollection(collection)
	local names = {}
	if collection == nil or collection.slots == nil then
		return names
	end

	for i = 1, #collection.slots do
		names[#names + 1] = collection.slots[i].name
	end

	return names
end

local function slotsInPage(page)
	local names = {}
	if page == nil or page.collections == nil then
		return names
	end

	for ci = 1, #page.collections do
		local slots = page.collections[ci].slots
		if slots ~= nil then
			for si = 1, #slots do
				names[#names + 1] = slots[si].name
			end
		end
	end

	return names
end

local function slotsInBook(book)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for pi = 1, #book.pages do
		local pageSlots = slotsInPage(book.pages[pi])
		for i = 1, #pageSlots do
			names[#names + 1] = pageSlots[i]
		end
	end

	return names
end

local function collectionsInPage(page)
	local names = {}
	if page == nil or page.collections == nil then
		return names
	end

	for i = 1, #page.collections do
		names[#names + 1] = page.collections[i].name
	end

	return names
end

local function collectionsInBook(book)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for pi = 1, #book.pages do
		local pageCols = collectionsInPage(book.pages[pi])
		for i = 1, #pageCols do
			names[#names + 1] = pageCols[i]
		end
	end

	return names
end

local function filterSlotsByCategory(slotNames, categoryName)
	local out = {}
	for i = 1, #slotNames do
		local idx = slotIndex(slotNames[i])
		if idx ~= nil then
			local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
			if slot ~= nil and hasCategory(slot, categoryName) then
				out[#out + 1] = slotNames[i]
			end
		end
	end

	return out
end

local function categoriesInSlotNames(slotNames)
	local out = {}
	local seen = {}
	for i = 1, #slotNames do
		local idx = slotIndex(slotNames[i])
		if idx ~= nil then
			local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
			if slot ~= nil and slot.categories ~= nil then
				for ci = 1, #slot.categories do
					uniqueAppend(out, seen, slot.categories[ci])
				end
			end
		end
	end

	return out
end

function CollectionManager.getCollectionSlotInfo(slotName)
	local book, page, collection, slot = resolveSlot(slotName)
	if slot == nil then
		return nil
	end

	return {book.name, page.name, collection.name, slot.music or ""}
end

function CollectionManager.isCollectionSlotATitle(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	return slot ~= nil and slot.title == 1
end

function CollectionManager.isCollectionATitle(collectionName)
	local idx = collectionIndex(collectionName)
	if idx == nil then
		return false
	end

	local collection = collectionAt(idx[1], idx[2], idx[3])
	return collection ~= nil and collection.title == 1
end

function CollectionManager.isCollectionPageATitle(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return false
	end

	local page = pageAt(idx[1], idx[2])
	return page ~= nil and page.title == 1
end

function CollectionManager.getCollectionSlotCategoryInfo(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return {}
	end

	return slot.categories or {}
end

function CollectionManager.getCollectionSlotPrereqInfo(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return {}
	end

	return slot.prereqs or {}
end

function CollectionManager.getCollectionSlotName(slotId)
	return CollectionData.slotById[slotId]
end

function CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	local idx = collectionIndex(collectionName)
	if idx == nil then
		return {}
	end

	return slotsInCollection(collectionAt(idx[1], idx[2], idx[3]))
end

function CollectionManager.getAllCollectionSlotsInPage(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return {}
	end

	return slotsInPage(pageAt(idx[1], idx[2]))
end

function CollectionManager.getAllCollectionsInPage(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return {}
	end

	return collectionsInPage(pageAt(idx[1], idx[2]))
end

function CollectionManager.getAllCollectionSlotsInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	return slotsInBook(bookAt(idx))
end

function CollectionManager.getAllCollectionsInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	return collectionsInBook(bookAt(idx))
end

function CollectionManager.getAllCollectionPagesInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	local book = bookAt(idx)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for i = 1, #book.pages do
		names[#names + 1] = book.pages[i].name
	end

	return names
end

function CollectionManager.getAllCollectionBooks()
	local names = {}
	for i = 1, #CollectionData.books do
		names[#names + 1] = CollectionData.books[i].name
	end

	return names
end

function CollectionManager.getAllCollectionSlotsInCategory(categoryName)
	local out = {}
	for i = 1, #CollectionData.books do
		local names = filterSlotsByCategory(slotsInBook(CollectionData.books[i]), categoryName)
		for n = 1, #names do
			out[#out + 1] = names[n]
		end
	end

	return out
end

function CollectionManager.getAllCollectionSlotsInCategoryInCollection(collectionName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInCollection(collectionName), categoryName)
end

function CollectionManager.getAllCollectionSlotsInCategoryInPage(pageName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInPage(pageName), categoryName)
end

function CollectionManager.getAllCollectionSlotsInCategoryInBook(bookName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInBook(bookName), categoryName)
end

function CollectionManager.getAllCollectionSlotCategoriesInCollection(collectionName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInCollection(collectionName))
end

function CollectionManager.getAllCollectionSlotCategoriesInPage(pageName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInPage(pageName))
end

function CollectionManager.getAllCollectionSlotCategoriesInBook(bookName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInBook(bookName))
end

function CollectionManager.getAllCollectionSlotCategories()
	local out = {}
	local seen = {}
	for i = 1, #CollectionData.books do
		local cats = CollectionManager.getAllCollectionSlotCategoriesInBook(CollectionData.books[i].name)
		for c = 1, #cats do
			uniqueAppend(out, seen, cats[c])
		end
	end

	return out
end

function CollectionManager.getCollectionSlotMaxValue(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return 0
	end

	return slot.maxValue
end

function CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	if pPlayer == nil or slotName == nil or slotIndex(slotName) == nil then
		return 0
	end

	local stored = readScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName)
	return tonumber(stored) or 0
end

function CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	local value = CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	if slot.maxValue < 0 then
		return value >= 1
	end

	return value >= slot.maxValue
end

function CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	local prereqs = slot.prereqs
	if prereqs == nil or #prereqs == 0 then
		return true
	end

	for i = 1, #prereqs do
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, prereqs[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollection(pPlayer, collectionName)
	local names = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollectionPage(pPlayer, pageName)
	local names = CollectionManager.getAllCollectionsInPage(pageName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollection(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollectionBook(pPlayer, bookName)
	local names = CollectionManager.getAllCollectionPagesInBook(bookName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollectionPage(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

local function storeSlotValue(pPlayer, slotName, value)
	if value == 0 then
		deleteScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName)
		return
	end

	writeScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName, tostring(value))
end

function CollectionManager.clearCollection(pPlayer, collectionName)
	if pPlayer == nil then
		return
	end

	local names = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	for i = 1, #names do
		deleteScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, names[i])
	end
end

function CollectionManager.onSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	CollectionManager.handleCollectionSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)

	for i = 1, #CollectionManager.listeners do
		CollectionManager.listeners[i](pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	end
end

function CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, delta)
	local book, page, collection, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	delta = tonumber(delta) or 0
	if delta == 0 then
		return false
	end

	local prev = CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	local isCounter = slot.maxValue >= 0
	local cur = prev
	if isCounter then
		cur = prev + delta
		if cur < 0 then
			cur = 0
		end
		if slot.maxValue >= 0 and cur > slot.maxValue then
			cur = slot.maxValue
		end
	else
		if delta > 0 then
			cur = 1
		else
			cur = 0
		end
	end

	if cur == prev then
		return false
	end

	storeSlotValue(pPlayer, slotName, cur)

	local completed = false
	if isCounter then
		completed = cur >= slot.maxValue
	else
		completed = cur >= 1
	end

	if not hasCategory(slot, CollectionManager.NO_SCRIPT_NOTIFY) then
		CollectionManager.onSlotModified(pPlayer, book.name, page.name, collection.name, slotName, isCounter, prev, cur, slot.maxValue, completed)
	end

	return true
end

local function sendCollectionProse(pPlayer, stringId, slotName, collectionName)
	local messageString = LuaStringIdChatParameter(stringId)
	if slotName ~= nil then
		messageString:setTU("@collection_n:" .. slotName)
	end
	if collectionName ~= nil then
		messageString:setTO("@collection_n:" .. collectionName)
	end
	CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
end

-- player_collection.java:27 OnCollectionSlotModified
function CollectionManager.handleCollectionSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	if pPlayer == nil then
		return
	end

	-- player_collection.java:29 — badge_book has its own message path
	if bookName == CollectionManager.BADGE_BOOK then
		return
	end

	local collectionSlots = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	if #collectionSlots == 0 then
		return
	end

	local newCollection = true
	local canResetCollection = false
	for i = 1, #collectionSlots do
		if collectionSlots[i] ~= slotName then
			if CollectionManager.getCollectionSlotValue(pPlayer, collectionSlots[i]) > 0 then
				newCollection = false
				break
			end
		end
	end

	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return
	end

	local isHidden = slot.hidden == 1
	-- player_collection.java:56-63 first slot of a new collection, not hidden
	if newCollection and cur == 1 and not isHidden then
		sendCollectionProse(pPlayer, "@collection:player_hidden_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	end

	local categories = slot.categories or {}
	for i = 1, #categories do
		local category = categories[i]
		-- player_collection.java:68-69 rewardOnUpdate
		if category == CollectionManager.REWARD_ON_UPDATE then
			CollectionManager.grantCollectionReward(pPlayer, slotName, false)
		end
		-- player_collection.java:71-77 updateOnCount:<n>
		if string.sub(category, 1, string.len(CollectionManager.UPDATE_ON_COUNT)) == CollectionManager.UPDATE_ON_COUNT then
			local countToUpdateAt = tonumber(string.match(category, ":(%d+)$"))
			if countToUpdateAt ~= nil and countToUpdateAt == cur and isCounter then
				CollectionManager.grantCollectionReward(pPlayer, slotName .. ":" .. tostring(countToUpdateAt), false)
			end
		end
	end

	if not completed then
		return
	end

	local giveMessage = true
	for i = 1, #categories do
		local category = categories[i]
		-- player_collection.java:88-89 rewardOnComplete
		if category == CollectionManager.REWARD_ON_COMPLETE then
			CollectionManager.grantCollectionReward(pPlayer, slotName, false)
		end
		-- player_collection.java:91-92 noMessage
		if category == CollectionManager.NO_MESSAGE then
			giveMessage = false
		end
		-- player_collection.java:94-96
		if bookName == "saga_relic_book" then
			giveMessage = false
		end
		-- player_collection.java:97-98 clearOnComplete
		if category == CollectionManager.CLEAR_ON_COMPLETE and CollectionManager.hasCompletedCollection(pPlayer, collectionName) then
			canResetCollection = true
		end
	end

	if isHidden and giveMessage then
		-- player_collection.java:102-108
		sendCollectionProse(pPlayer, "@collection:player_hidden_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	elseif giveMessage then
		-- player_collection.java:110-116
		sendCollectionProse(pPlayer, "@collection:player_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	end

	if CollectionManager.hasCompletedCollection(pPlayer, collectionName) then
		local colIdx = collectionIndex(collectionName)
		local collection = nil
		if colIdx ~= nil then
			collection = collectionAt(colIdx[1], colIdx[2], colIdx[3])
		end
		local collectionHidden = collection ~= nil and collection.hidden == 1
		-- player_collection.java:123-133
		if not collectionHidden then
			sendCollectionProse(pPlayer, "@collection:player_collection_complete", nil, collectionName)
		end
		CollectionManager.grantCollectionReward(pPlayer, collectionName, canResetCollection)
	end
end

function CollectionManager.rewardsFor(collectionName)
	local indices = CollectionData.rewardsByName[collectionName]
	local rows = {}
	if indices == nil then
		return rows
	end

	for i = 1, #indices do
		rows[#rows + 1] = CollectionData.rewards[indices[i]]
	end

	return rows
end

local function splitComma(text)
	local out = {}
	if text == nil or text == "" then
		return out
	end

	for part in string.gmatch(text, "[^,]+") do
		local trimmed = string.match(part, "^%s*(.-)%s*$")
		if trimmed ~= nil and trimmed ~= "" then
			out[#out + 1] = trimmed
		end
	end

	return out
end

local function itemIsIff(item)
	if string.find(item, ".iff", 1, true) ~= nil then
		return true
	end

	if string.sub(item, 1, 7) == "object/" then
		return true
	end

	return false
end

local function giveIffItem(pPlayer, template, stackAmount)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	if pInventory == nil then
		return nil
	end

	if string.sub(template, -4) ~= ".iff" then
		template = template .. ".iff"
	end

	local pItem = giveItem(pInventory, template, -1)
	if pItem ~= nil and stackAmount ~= nil and stackAmount > 1 then
		TangibleObject(pItem):setUseCount(stackAmount)
	end

	return pItem
end

function CollectionManager.grantCollectionReward(pPlayer, collectionName, canReset)
	-- collection.java:95-104
	if pPlayer == nil or collectionName == nil or collectionName == "" then
		return false
	end

	local rows = CollectionManager.rewardsFor(collectionName)
	if #rows == 0 then
		return false
	end

	-- collection.java:105 dataTableSearchColumnForString — first matching row
	local row = rows[1]

	-- collection.java:126-139 slot_name (comma list)
	if row.slotName ~= nil and row.slotName ~= "" then
		local slots = splitComma(row.slotName)
		for i = 1, #slots do
			CollectionManager.modifyCollectionSlotValue(pPlayer, slots[i], 1)
		end
	end

	-- collection.java:142-167 xpModifier. Amount rule: CollectionManager.XP_MODIFIER_SCALE.
	local xpModifier = tonumber(row.xpModifier) or 0
	if xpModifier > 0 then
		local xpAmount = math.floor(xpModifier * CollectionManager.XP_MODIFIER_SCALE)
		if xpAmount > 0 then
			local xpType = CollectionManager.XP_TYPE
			if row.isSpaceXp == 1 then
				xpType = CollectionManager.SPACE_XP_TYPE
			end
			CreatureObject(pPlayer):awardExperience(xpType, xpAmount, true)
			local xpMessage = LuaStringIdChatParameter("@collection:reward_xp_amount")
			xpMessage:setDI(xpAmount)
			CreatureObject(pPlayer):sendSystemMessage(xpMessage:_getObject())
		end
	end

	-- collection.java:179-235 item. Iff paths only; static_item names are OPEN.
	if row.item ~= nil and row.item ~= "" then
		if row.grantRandomItem == 1 or row.grantWeightedRandom == 1 then
			-- OPEN: grantRandomItem / grantWeightedRandom — collection.java:185-210
		else
			local items = splitComma(row.item)
			local stackAmount = row.stackAmount or 1
			for i = 1, #items do
				if itemIsIff(items[i]) then
					giveIffItem(pPlayer, items[i], stackAmount)
				end
			end
		end
	end

	-- OPEN: command — collection.java:236-242
	-- OPEN: skill_mod — collection.java:244-259
	-- OPEN: quest — collection.java:169-177 groundquests.grantQuestNoAcceptUI
	-- OPEN: crafting_template — collection.java:272 updateCraftingSlot

	-- collection.java:261-264 quest_signal
	if row.questSignal ~= nil and row.questSignal ~= "" then
		for i = 1, #CollectionManager.questSignalListeners do
			CollectionManager.questSignalListeners[i](pPlayer, row.questSignal)
		end
	end

	-- reward_text is type `c` in rewards.tab — shipped prose, not an STF key.
	if row.rewardText ~= nil and row.rewardText ~= "" then
		CreatureObject(pPlayer):sendSystemMessage(row.rewardText)
	end

	-- collection.java:266-268 clearOnComplete
	if canReset == true then
		CollectionManager.clearCollection(pPlayer, collectionName)
	end

	return true
end

return CollectionManager

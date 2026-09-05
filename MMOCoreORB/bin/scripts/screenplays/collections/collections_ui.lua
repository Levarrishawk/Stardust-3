-- Server SUI collections browser. The client cannot draw the NGE collections
-- window, so this is a book → page → collection → slot list box (quest_tracker_ui.lua
-- pane/picker: SuiListBox, showOtherButton, stored-data-per-row).

CollectionsUI = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionsUI"
}

registerScreenPlay("CollectionsUI", true)

function CollectionsUI:start()
end

local function stfName(name)
	local title = getStringId("@collection_n:" .. name)

	if (title == nil or title == "") then
		return "@collection_n:" .. name
	end

	return title
end

local function mark(done)
	if (done) then
		return "[x] "
	end

	return "[ ] "
end

local function slotRecord(slotName)
	local idx = CollectionData.slotByName[slotName]

	if (idx == nil) then
		return nil
	end

	local book = CollectionData.books[idx[1]]

	if (book == nil or book.pages == nil) then
		return nil
	end

	local page = book.pages[idx[2]]

	if (page == nil or page.collections == nil) then
		return nil
	end

	local collection = page.collections[idx[3]]

	if (collection == nil or collection.slots == nil) then
		return nil
	end

	return collection.slots[idx[4]]
end

local function writeNav(pPlayer, level, bookName, pageName, collectionName)
	writeScreenPlayData(pPlayer, CollectionsUI.screenplayName, "level", level or "books")
	writeScreenPlayData(pPlayer, CollectionsUI.screenplayName, "book", bookName or "")
	writeScreenPlayData(pPlayer, CollectionsUI.screenplayName, "page", pageName or "")
	writeScreenPlayData(pPlayer, CollectionsUI.screenplayName, "collection", collectionName or "")
end

local function readNav(pPlayer)
	return {
		level = readScreenPlayData(pPlayer, CollectionsUI.screenplayName, "level") or "books",
		book = readScreenPlayData(pPlayer, CollectionsUI.screenplayName, "book") or "",
		page = readScreenPlayData(pPlayer, CollectionsUI.screenplayName, "page") or "",
		collection = readScreenPlayData(pPlayer, CollectionsUI.screenplayName, "collection") or ""
	}
end

function CollectionsUI:buildRows(pPlayer)
	local nav = readNav(pPlayer)
	local rows = {}

	if (nav.level == "slots" and nav.collection ~= "") then
		local slots = CollectionManager.getAllCollectionSlotsInCollection(nav.collection)

		for i = 1, #slots do
			local slotName = slots[i]
			local slot = slotRecord(slotName)
			local hidden = slot ~= nil and slot.hidden == 1
			local value = CollectionManager.getCollectionSlotValue(pPlayer, slotName)
			local maxValue = CollectionManager.getCollectionSlotMaxValue(slotName)

			if (not hidden or value > 0) then
				local done = CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)
				local extra = ""

				if (maxValue ~= nil and maxValue >= 0) then
					extra = " (" .. tostring(value) .. " / " .. tostring(maxValue) .. ")"
				end

				table.insert(rows, { mark(done) .. stfName(slotName) .. extra, slotName })
			end
		end
	elseif (nav.level == "collections" and nav.page ~= "") then
		local collections = CollectionManager.getAllCollectionsInPage(nav.page)

		for i = 1, #collections do
			local name = collections[i]
			local done = CollectionManager.hasCompletedCollection(pPlayer, name)
			table.insert(rows, { mark(done) .. stfName(name), name })
		end
	elseif (nav.level == "pages" and nav.book ~= "") then
		local pages = CollectionManager.getAllCollectionPagesInBook(nav.book)

		for i = 1, #pages do
			local name = pages[i]
			local done = CollectionManager.hasCompletedCollectionPage(pPlayer, name)
			table.insert(rows, { mark(done) .. stfName(name), name })
		end
	else
		local books = CollectionManager.getAllCollectionBooks()

		for i = 1, #books do
			local name = books[i]
			local done = CollectionManager.hasCompletedCollectionBook(pPlayer, name)
			table.insert(rows, { mark(done) .. stfName(name), name })
		end
	end

	if (#rows == 0) then
		table.insert(rows, { "@collection:already_finished_collection", "" })
	end

	return rows
end

function CollectionsUI:titleFor(pPlayer)
	local nav = readNav(pPlayer)

	if (nav.level == "slots" and nav.collection ~= "") then
		return "@collection_n:" .. nav.collection
	elseif (nav.level == "collections" and nav.page ~= "") then
		return "@collection_n:" .. nav.page
	elseif (nav.level == "pages" and nav.book ~= "") then
		return "@collection_n:" .. nav.book
	end

	return "@collection:collection_list_title"
end

function CollectionsUI:promptFor(pPlayer)
	local nav = readNav(pPlayer)

	if (nav.level == "slots" and nav.collection ~= "") then
		return "@collection_d:" .. nav.collection
	elseif (nav.level == "collections" and nav.page ~= "") then
		return "@collection_d:" .. nav.page
	elseif (nav.level == "pages" and nav.book ~= "") then
		return "@collection_d:" .. nav.book
	end

	return "@collection:collection_list_title"
end

function CollectionsUI:open(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	writeNav(pPlayer, "books", "", "", "")
	self:send(pPlayer)
end

function CollectionsUI:send(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local nav = readNav(pPlayer)
	local sui = SuiListBox.new("CollectionsUI", "callback")
	sui.setTitle(self:titleFor(pPlayer))
	sui.setPrompt(self:promptFor(pPlayer))
	sui.setForceCloseDistance(0)
	sui.setOkButtonText("@ui:ok")
	sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())

	if (nav.level ~= "books") then
		sui.showOtherButton()
		sui.setOtherButtonText("@ui:back")
	end

	local rows = self:buildRows(pPlayer)

	for i = 1, #rows do
		sui.add(rows[i][1], rows[i][2])
	end

	sui.sendTo(pPlayer)
end

function CollectionsUI:callback(pPlayer, pSui, eventIndex, args, otherPressed)
	if (pPlayer == nil) then
		return
	end

	if (eventIndex == 1) then
		return
	end

	local nav = readNav(pPlayer)

	if (otherPressed == "true") then
		if (nav.level == "slots") then
			writeNav(pPlayer, "collections", nav.book, nav.page, "")
		elseif (nav.level == "collections") then
			writeNav(pPlayer, "pages", nav.book, "", "")
		else
			writeNav(pPlayer, "books", "", "", "")
		end

		self:send(pPlayer)
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
		self:send(pPlayer)
		return
	end

	if (nav.level == "books") then
		writeNav(pPlayer, "pages", selected, "", "")
	elseif (nav.level == "pages") then
		writeNav(pPlayer, "collections", nav.book, selected, "")
	elseif (nav.level == "collections") then
		writeNav(pPlayer, "slots", nav.book, nav.page, selected)
	else
		self:send(pPlayer)
		return
	end

	self:send(pPlayer)
end

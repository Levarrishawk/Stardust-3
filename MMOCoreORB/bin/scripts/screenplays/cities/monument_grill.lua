MonumentGrill = ScreenPlay:new { screenplayName = "MonumentGrill", numberOfActs = 1 }
registerScreenPlay("MonumentGrill", true)

local building = 37000108
local prefix = "MonumentGrill:"
local names = {"Maela Venn", "Taro Dain", "Seli Orr", "Iren Tal", "Vessa Rin", "Corin Hale"}
local rest, spacing, tableTime = 300, 45, 35

-- Cell number, local x, height, local z, optional table number and facing.
-- Each final stop returns to its assigned place at the kitchen pass.
MonumentGrill.routes = {
	{ -- Section 1
		{37000120, -20.65, -0.895, 18.55},
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, 13.89, -0.895, 6.10, 5, 100},
		{37000111, 13.30, -0.895, 4.20},
		{37000111, 12.60, -0.895, -2.80},
		{37000111, 13.29, -0.895, -3.90, 6, 90},
		{37000111, 16.10, -0.895, -6.30},
		{37000111, 23.09, -0.895, -7.10, 4, 100},
		{37000111, 22.75, -0.895, -5.60},
		{37000111, 28.47, 0.105, 1.41},
		{37000110, 29.77, 0.105, 1.41},
		{37000110, 31.15, 0.105, -5.95},
		{37000110, 29.95, 0.105, -7.24, 3, 80},
		{37000110, 32.12, 0.105, -3.26, 2, 150},
		{37000110, 34.98, 0.105, -2.64},
		{37000109, 36.28, 0.105, -2.64},
		{37000109, 37.13, 0.105, -5.96, 1, 160},
		{37000109, 36.28, 0.105, -2.64},
		{37000110, 34.98, 0.105, -2.64},
		{37000110, 29.77, 0.105, 1.41},
		{37000111, 28.47, 0.105, 1.41},
		{37000111, 10.85, -0.895, 3.85},
		{37000111, 8.75, -0.895, 5.25},
		{37000111, -8.40, -0.895, 10.85},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -22.75, -0.895, 20.30},
		{37000120, -26.05, -0.895, 21.62},
	},
	{ -- Section 2
		{37000120, -18.20, -0.895, 16.10},
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, 7.00, -0.895, 5.25},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, 11.20, -0.895, 2.45},
		{37000111, 11.20, -0.895, -7.00},
		{37000111, 10.48, -0.895, -9.14, 7, 130},
		{37000111, 12.60, -0.895, -9.10},
		{37000111, 20.26, -0.895, -11.86},
		{37000112, 20.26, -0.895, -13.16},
		{37000112, 18.46, -0.895, -14.28, 12, -110},
		{37000112, 17.08, -0.895, -17.08, 13, -160},
		{37000112, 19.25, -0.895, -17.15},
		{37000112, 22.57, -0.895, -15.66, 8, 70},
		{37000112, 24.35, -0.895, -17.22, 9, -170},
		{37000112, 25.20, -0.895, -18.90},
		{37000112, 24.85, -0.895, -21.70},
		{37000112, 22.91, -0.895, -23.75, 10, 180},
		{37000112, 17.74, -0.895, -23.68, 11, -170},
		{37000112, 18.90, -0.895, -20.65},
		{37000112, 20.26, -0.895, -13.16},
		{37000111, 20.26, -0.895, -11.86},
		{37000111, 15.75, -0.895, -2.80},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, -6.30, -0.897, 10.15},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -23.80, -0.895, 21.35},
		{37000120, -24.65, -0.895, 21.62},
	},
	{ -- Section 3
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, 7.00, -0.895, 5.25},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, 11.20, -0.895, 2.45},
		{37000111, 11.20, -0.895, 1.05},
		{37000111, 8.75, -0.895, -4.90},
		{37000111, -0.70, -0.895, -7.00},
		{37000111, -9.87, -0.895, -7.06, 15, -110},
		{37000111, -2.58, -0.895, -9.27, 14, 130},
		{37000111, 1.05, -0.895, -9.45},
		{37000111, 5.59, -0.895, -11.86},
		{37000114, 5.59, -0.895, -13.16},
		{37000114, 3.85, -0.895, -15.40},
		{37000114, 2.45, -0.895, -15.75},
		{37000114, 2.10, -0.895, -17.40, 20, -50},
		{37000114, 2.21, -0.895, -17.50, 18, 50},
		{37000114, 3.21, -0.895, -23.76, 19, -180},
		{37000114, 8.38, -0.895, -23.66, 17, 170},
		{37000114, 9.13, -0.895, -19.40, 16, 20},
		{37000114, 5.59, -0.895, -13.16},
		{37000111, 5.59, -0.895, -11.86},
		{37000111, 10.50, -0.895, -0.70},
		{37000111, 11.20, -0.895, 1.75},
		{37000111, 11.20, -0.895, 2.45},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, -7.70, -0.895, 10.50},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -23.25, -0.895, 21.62},
	},
	{ -- Section 4
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, 7.00, -0.895, 5.25},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, 11.20, -0.895, 2.45},
		{37000111, 11.20, -0.895, 1.05},
		{37000111, 8.75, -0.895, -4.90},
		{37000111, -1.75, -0.895, -7.70},
		{37000111, -8.69, -0.895, -13.84},
		{37000116, -8.31, -0.895, -15.08},
		{37000116, -7.00, -0.895, -15.40},
		{37000116, -6.30, -0.895, -15.40},
		{37000116, -5.95, -0.895, -14.35},
		{37000116, -3.97, -0.895, -14.02, 22, -140},
		{37000116, -3.56, -0.895, -17.22, 21, -80},
		{37000116, -4.90, -0.895, -18.20},
		{37000116, -5.95, -0.895, -18.20},
		{37000116, -7.94, -0.895, -20.65, 24, -130},
		{37000116, -9.10, -0.895, -18.55},
		{37000116, -10.72, -0.895, -18.30, 26, -80},
		{37000116, -10.50, -0.895, -23.10},
		{37000116, -10.79, -0.895, -23.72, 25, -170},
		{37000116, -5.67, -0.895, -23.76, 23, -180},
		{37000116, -8.05, -0.895, -16.80},
		{37000116, -8.31, -0.895, -15.08},
		{37000111, -8.69, -0.895, -13.84},
		{37000111, -1.40, -0.895, -7.70},
		{37000111, 8.75, -0.895, -4.90},
		{37000111, 11.20, -0.895, 1.05},
		{37000111, 11.20, -0.895, 2.45},
		{37000111, 9.10, -0.895, 5.25},
		{37000111, -8.40, -0.895, 10.85},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -21.66, -0.895, 21.62},
	},
	{ -- Section 5
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, -0.70, -0.895, 10.15},
		{37000111, 3.50, -0.895, 11.55},
		{37000111, 5.54, -0.895, 12.62},
		{37000115, 5.54, -0.895, 13.92},
		{37000115, 3.85, -0.895, 15.75},
		{37000115, 3.85, -0.895, 16.80},
		{37000115, 1.92, -0.895, 17.17, 33, 40},
		{37000115, 1.92, -0.895, 17.06, 32, 140},
		{37000115, 3.85, -0.895, 16.80},
		{37000115, 4.20, -0.895, 15.05},
		{37000115, 6.45, -0.895, 15.81, 31, 100},
		{37000115, 5.25, -0.895, 20.30},
		{37000115, 4.24, -0.895, 21.18, 34, -120},
		{37000115, 7.35, -0.895, 22.05},
		{37000115, 8.05, -0.895, 22.05},
		{37000115, 8.90, -0.895, 21.59, 30, -180},
		{37000115, 6.30, -0.895, 18.90},
		{37000115, 5.54, -0.895, 13.92},
		{37000111, 5.54, -0.895, 12.62},
		{37000111, 11.20, -0.895, 11.20},
		{37000111, 17.11, -0.895, 12.62},
		{37000113, 17.11, -0.895, 13.92},
		{37000113, 16.80, -0.895, 16.80},
		{37000113, 14.28, -0.895, 19.26, 28, 10},
		{37000113, 16.80, -0.895, 16.45},
		{37000113, 16.45, -0.895, 15.05},
		{37000113, 14.68, -0.895, 15.38, 29, -10},
		{37000113, 16.45, -0.895, 15.05},
		{37000113, 20.65, -0.895, 17.15},
		{37000113, 21.16, -0.895, 17.56, 27, -170},
		{37000113, 18.55, -0.895, 16.10},
		{37000113, 17.50, -0.895, 15.05},
		{37000113, 17.11, -0.895, 13.92},
		{37000111, 17.11, -0.895, 12.62},
		{37000111, 10.85, -0.895, 11.20},
		{37000111, -2.80, -0.895, 10.15},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -20.26, -0.895, 21.62},
	},
	{ -- Section 6
		{37000120, -17.50, -0.895, 16.10},
		{37000120, -16.52, -0.895, 14.17},
		{37000111, -15.22, -0.895, 14.17},
		{37000111, -2.36, -0.895, 10.17, 37, 50},
		{37000111, 8.99, -0.895, 10.63, 36, 110},
		{37000111, 10.85, -0.895, 11.20},
		{37000111, 12.37, -0.895, 11.53, 35, -160},
		{37000111, 10.85, -0.895, 11.20},
		{37000111, -1.75, -0.895, 10.15},
		{37000111, -4.20, -0.899, 11.20},
		{37000111, -6.73, -0.895, 15.02},
		{37000117, -6.21, -0.895, 16.21},
		{37000117, -6.30, -0.895, 18.20},
		{37000117, -3.85, -0.895, 19.25},
		{37000117, -3.34, -0.895, 19.66, 39, -170},
		{37000117, -3.39, -0.895, 20.06, 38, 0},
		{37000117, -5.25, -0.895, 20.65},
		{37000117, -9.45, -0.895, 19.25},
		{37000117, -10.50, -0.895, 20.30},
		{37000117, -11.59, -0.895, 20.82, 40, 50},
		{37000117, -9.80, -0.895, 19.95},
		{37000117, -6.21, -0.895, 16.21},
		{37000111, -6.73, -0.895, 15.02},
		{37000111, -15.22, -0.895, 14.17},
		{37000120, -16.52, -0.895, 14.17},
		{37000120, -17.85, -0.895, 16.80},
		{37000120, -18.86, -0.895, 21.62},
	},
}

local function atPoint(pNpc, point)
	local actor = SceneObject(pNpc)
	if actor:getParentID() ~= point[1] then return false end
	local dx, dy = actor:getPositionX() - point[2], actor:getPositionY() - point[4]
	return dx * dx + dy * dy <= 0.45 * 0.45 and math.abs(actor:getPositionZ() - point[3]) < 0.7
end

function MonumentGrill:start()
	if not isZoneEnabled("coruscant") then return end
	local shift = readData(prefix .. "shift") + 1
	writeData(prefix .. "shift", shift)
	createEvent(1000, self.screenplayName, "rounds", nil, tostring(shift))
	createEvent(16000, self.screenplayName, "kitchen", nil, shift .. "/1/1")
end

local function walk(pNpc, point, key, now)
	local ai = AiAgent(pNpc)
	ai:clearPatrolPoints()
	ai:clearCurrentPath()
	ai:setMovementState(AI_PATROLLING)
	ai:setNextPosition(point[2], point[3], point[4], point[1])
	writeData(key .. "sent", now)
end

function MonumentGrill:serveSection(slot, now)
	local route = self.routes[slot]
	local home = route[#route]
	local key = prefix .. slot .. ":"
	local pNpc = getSceneObject(readData(key .. "npc"))
	if pNpc == nil then
		if readData(key .. "retry") > now then return end
		writeData(key .. "retry", now + 20)
		pNpc = spawnMobile("coruscant", "monument_grill_waiter", 0, home[2], home[3], home[4], 0, home[1])
		if pNpc == nil then return end
		CreatureObject(pNpc):setCustomObjectName(names[slot] .. " (Wait Staff)")
		CreatureObject(pNpc):clearOptionBit(CONVERSABLE)
		writeData(key .. "npc", SceneObject(pNpc):getObjectID())
		writeData(key .. "point", 0)
		writeData(key .. "ready", now + 4 + spacing * (slot - 1))
		writeData(key .. "atTable", 0)
	end

	local i = readData(key .. "point")
	if i == 0 then
		if now < math.max(readData(key .. "ready"), readData(prefix .. "lastDeparture") + spacing) then return end
		writeData(prefix .. "lastDeparture", now)
		writeData(key .. "point", 1)
		walk(pNpc, route[1], key, now)
		return
	end

	local point = route[i]
	if readData(key .. "atTable") ~= 0 then
		if now < readData(key .. "leave") and atPoint(pNpc, point) then return end
		CreatureObject(pNpc):clearOptionBit(CONVERSABLE)
		writeData(key .. "atTable", 0)
	elseif not atPoint(pNpc, point) then
		local age = now - readData(key .. "sent")
		if age >= 25 or (age >= 3 and AiAgent(pNpc):getPatrolPointsSize() == 0) then
			walk(pNpc, point, key, now)
		end
		return
	elseif point[5] then
		AiAgent(pNpc):clearPatrolPoints()
		SceneObject(pNpc):updateDirection(math.rad(point[6]))
		writeData(key .. "atTable", point[5])
		writeData(key .. "arrived", now)
		writeData(key .. "leave", now + tableTime)
		CreatureObject(pNpc):setOptionBit(CONVERSABLE)
		return
	elseif i == #route then
		AiAgent(pNpc):clearPatrolPoints()
		SceneObject(pNpc):updateDirection(0)
		writeData(key .. "point", 0)
		writeData(key .. "ready", now + rest)
		return
	end
	writeData(key .. "point", i + 1)
	walk(pNpc, route[i + 1], key, now)
end

function MonumentGrill:rounds(_, args)
	if tonumber(args) ~= readData(prefix .. "shift") then return 0 end
	local pExpo = getSceneObject(37000120)
	if pExpo ~= nil and SceneObject(pExpo):getParentID() == building then
		local now = os.time()
		for slot = 1, #self.routes do self:serveSection(slot, now) end
	end
	createEvent(1500, self.screenplayName, "rounds", nil, args)
	return 0
end

local calls = {
	{"chef", "Two braised canron, one without the glaze.", "line", "Yes, Chef! One plain, one glazed."},
	{"prep", "How many plates for the next pickup, Chef?", "chef", "Four warm ones, please. Send the garnish with them."},
	{"line", "Chef, can you taste the noodle broth?", "chef", "Just a pinch of salt. Then send it."},
	{"chef", "Two slices of ryshcate for the window table.", "pass", "Yes, Chef. Both on the pass."},
	{"chef", "Capanata first. Give the canron another minute.", "line", "Yes, Chef! Capanata coming up."},
	{"prep", "Hot tray behind you!", "pass", "Heard, behind. Landing space on your left."},
	{"line", "Last canron from this pan, Chef.", "chef", "Thank you. Start the next pan while that one rests."},
	{"pass", "Wipe the rims on those two, please.", "prep", "Clean cloth here. Both plates ready."},
}

local function kitchenHasListener(pSpeaker)
	for _, cell in ipairs({37000119, 37000120, 37000121, 37000111}) do
		local pCell = getSceneObject(cell)
		if pCell ~= nil then
			local room = SceneObject(pCell)
			for i = 0, room:getContainerObjectsSize() - 1 do
				local pGuest = room:getContainerObject(i)
				if pGuest ~= nil and SceneObject(pGuest):isPlayerCreature()
					and (cell ~= 37000111 or SceneObject(pGuest):isInRangeWithObject(pSpeaker, 18)) then return true end
			end
		end
	end
	return false
end

local function onStation(role)
	local pCook = getSceneObject(readData("CoruscantEntertainmentScreenPlay:grill:" .. role))
	local cell = (role == "chef" or role == "line") and 37000119 or 37000121
	if pCook ~= nil and SceneObject(pCook):getParentID() == cell then return pCook end
end

function MonumentGrill:kitchen(_, args)
	local shift, index, beat = args:match("^(%d+)/(%d+)/(%d+)$")
	index, beat = tonumber(index), tonumber(beat)
	if tonumber(shift) ~= readData(prefix .. "shift") then return 0 end
	local call = calls[index]
	local first, second = onStation(call[1]), onStation(call[3])
	local delay = 18
	if first and second and kitchenHasListener(first) then
		if beat == 1 then
			spatialChat(first, call[2])
			beat, delay = 2, math.random(2, 3)
		else
			spatialChat(second, call[4])
			index, beat, delay = index % #calls + 1, 1, math.random(55, 95)
		end
	else
		-- An absent speaker or listener never leaves a reply queued on its own.
		if beat == 2 or not first or not second then index = index % #calls + 1 end
		beat = 1
	end
	createEvent(delay * 1000, self.screenplayName, "kitchen", nil, shift .. "/" .. index .. "/" .. beat)
	return 0
end

local dish = "object/tangible/food/monument_square/"
local drink = "object/tangible/food/bartender_drinks/"
local foodMenu = {
	{"Ramorrean capanata", 30, dish .. "grill_capanata.iff"},
	{"Teltier noodles with greens", 45, dish .. "grill_noodles.iff"},
	{"Slow-braised canron", 75, dish .. "grill_canron.iff"},
	{"Corellian ryshcate", 35, dish .. "grill_ryshcate.iff"},
}
local barMenu = {
	{"Desert Bloom", 25, drink .. "desert_bloom.iff"},
	{"Imported Utozz", 35, drink .. "imported_utozz.iff"},
	{"Ruby Bliel", 18, drink .. "ruby_bliel.iff"},
	{"Hot chocolate", 12, drink .. "hot_chocolate.iff"},
}

-- Resolve a menu against the actor's physical position on every conversation step.
local function service(pPlayer, pNpc)
	local guest, npc = SceneObject(pPlayer), SceneObject(pNpc)
	if guest:getZoneName() ~= "coruscant" or guest:getParentID() ~= npc:getParentID()
		or not guest:isInRangeWithObject(pNpc, 6) then return end
	local role = AiAgent(pNpc):getCreatureTemplateName()
	if role == "monument_grill_bartender" and npc:getParentID() == 37000111 then return barMenu, 0, 1 end
	if role ~= "monument_grill_waiter" then return end
	for slot, route in ipairs(MonumentGrill.routes) do
		local key = prefix .. slot .. ":"
		if readData(key .. "npc") == npc:getObjectID() then
			local point = route[readData(key .. "point")]
			local number = readData(key .. "atTable")
			if number > 0 and point and point[5] == number and atPoint(pNpc, point) then
				return foodMenu, number, readData(key .. "arrived"), key
			end
			return
		end
	end
end

MonumentGrillMenuHandler = conv_handler:new {}
function MonumentGrillMenuHandler:runScreenHandlers(pTemplate, pPlayer, pNpc, option, pScreen)
	if pPlayer == nil or pNpc == nil or pScreen == nil then return pScreen end
	local id = LuaConversationScreen(pScreen):getScreenID()
	local ticket = prefix .. "order:" .. SceneObject(pPlayer):getObjectID()
	local npcId = SceneObject(pNpc):getObjectID()
	local menu, number, visit, key = service(pPlayer, pNpc)
	local authorized = readData(ticket) == npcId and readData(ticket .. ":visit") == visit
	deleteData(ticket)
	deleteData(ticket .. ":visit")
	if id == "bye" then return pScreen end
	if not menu then return LuaConversationTemplate(pTemplate):getScreen("closed") end
	local copy = LuaConversationScreen(pScreen):cloneScreen()
	local screen = LuaConversationScreen(copy)
	if id == "hello" or id == "menu" then
		if key then
			local leave = math.min(visit + 60, math.max(readData(key .. "leave"), os.time() + 20))
			writeData(key .. "leave", leave)
		end
		if id == "hello" then
			screen:setCustomDialogText(number == 0 and "Welcome to the bar. What may I pour for you?" or
				string.format("Good evening, table %02d. May I bring you something from the kitchen?", number))
		else
			screen:setCustomDialogText(number == 0 and "Our drinks this evening." or "From the kitchen this evening.")
			for i, item in ipairs(menu) do screen:addOption(item[1] .. " (" .. item[2] .. " credits)", "order" .. i) end
			screen:addOption("Another time, thank you.", "bye")
			writeData(ticket, npcId)
			writeData(ticket .. ":visit", visit)
		end
	else
		local item = menu[tonumber(id:match("^order([1-4])$"))]
		if not item or not authorized then return LuaConversationTemplate(pTemplate):getScreen("closed") end
		screen:setCustomDialogText(MonumentSquareVendorHandler:purchase(pPlayer, pNpc, item))
	end
	return copy
end

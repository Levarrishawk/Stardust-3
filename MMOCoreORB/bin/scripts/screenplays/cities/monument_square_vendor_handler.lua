MonumentSquareVendorHandler = conv_handler:new {}

local food = "object/tangible/food/monument_square/"
local shop = {
	monument_caf_seller = {
		greeting = "Fresh pot, still hot. Caf for the walk, or a puffcake for the way back?",
		{"Shuttle-stop caf", 10, food .. "caf.iff"}, {"Honey puffcake", 15, food .. "puffcake.iff"},
	},
	monument_food_seller = {
		greeting = "Walk around to this side, out of the steam. What'll it be?",
		{"Cup of fire stew", 20, food .. "stew.iff"}, {"Bofa sweet", 12, food .. "bofa.iff"},
	},
	monument_keepsake_seller = {
		greeting = "I traced the ridge for that little projector. See the crooked shoulder? You can pick it out on the real thing from here.",
		{"Umate pocket holoprojector", 125, "object/tangible/furniture/decorative/umate_pocket_holo.iff"},
		{"Monument Square keepsake bowl", 45, "object/tangible/furniture/decorative/carved_bowl.iff"},
	},
}

function MonumentSquareVendorHandler:purchase(pPlayer, pNpc, item)
	if SceneObject(pPlayer):getZoneName() ~= "coruscant" or not SceneObject(pPlayer):isInRangeWithObject(pNpc,6) then
		return "Come a little closer so I can hand it to you."
	end
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	if pInventory == nil or SceneObject(pInventory):isContainerFullRecursive() then
		return "Make a little room in your inventory first."
	end
	if CreatureObject(pPlayer):getCashCredits() < item[2] then
		return "You'll need " .. item[2] .. " credits in cash for that."
	end
	local pItem = giveItem(pInventory,item[3],-1)
	if pItem == nil then return "I couldn't hand that over. You've still got your credits." end
	CreatureObject(pPlayer):subtractCashCredits(item[2])
	SceneObject(pItem):setCustomObjectName(item[1])
	return "Here you go. One " .. item[1] .. " for " .. item[2] .. " credits."
end

function MonumentSquareVendorHandler:runScreenHandlers(pTemplate,pPlayer,pNpc,option,pScreen)
	if pPlayer == nil or pNpc == nil or pScreen == nil then return pScreen end
	local stock = shop[AiAgent(pNpc):getCreatureTemplateName()]
	if not stock then return pScreen end
	local id = LuaConversationScreen(pScreen):getScreenID()
	if id == "bye" then return pScreen end
	local copy = LuaConversationScreen(pScreen):cloneScreen()
	local screen = LuaConversationScreen(copy)
	if id == "hello" then
		screen:setCustomDialogText(stock.greeting)
		for i,item in ipairs(stock) do
			screen:addOption(item[1] .. " (" .. item[2] .. " credits)", "buy" .. i)
		end
		screen:addOption("Just browsing, thanks.", "bye")
	elseif id == "buy1" or id == "buy2" then
		screen:setCustomDialogText(self:purchase(pPlayer,pNpc,stock[id == "buy1" and 1 or 2]))
	end
	return copy
end

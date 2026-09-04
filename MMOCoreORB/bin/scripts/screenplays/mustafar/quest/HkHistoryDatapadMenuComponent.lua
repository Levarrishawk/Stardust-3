--[[
The Access Record Archives list on the droid factory history datapad.

There were never ten placed consoles. string/en/som/som_quest.stf carries one radial
string (hk_history_datapad, "Access Record Archives"), ten row labels
(hk_history_datapad_01..10, "Entry #64951".."Entry #64960") and one refusal
(hk_history_datapad_select) -- which is a single object holding all ten behind a list.
This component is that list. The prose itself is hk_history.lua's entries table.

Attached declaratively via objectMenuComponent on
object/custom_content/tangible/item/som/droid_factory_history_datapad.lua, the same way
object/tangible/magic_eight_ball/magic_eight_ball.lua:45 attaches its own component.
--]]

HkHistoryDatapadMenuComponent = { }

function HkHistoryDatapadMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)

	menuResponse:addRadialMenuItem(20, 3, "@som/som_quest:hk_history_datapad")
end

function HkHistoryDatapadMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	-- Inventory item, so the guard is ownership and not range.
	if (SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
		return 0
	end

	local history = _G["somHkHistoryScreenPlay"]

	if (history == nil or history.entries == nil) then
		return 0
	end

	local sui = SuiListBox.new("HkHistoryDatapadMenuComponent", "entryCallback")

	sui.setTitle("@som/som_quest:hk_history_datapad")
	sui.setPrompt("@som/som_quest:hk_history_datapad")

	-- Row order is the entries table's own reading order, so the row index maps
	-- straight back onto it in the callback.
	for i = 1, #history.entries, 1 do
		sui.add("@som/som_quest:hk_history_datapad_" .. string.format("%02d", history.entries[i].number), "")
	end

	sui.setTargetNetworkId(SceneObject(pSceneObject):getObjectID())
	sui.sendTo(pPlayer)

	return 0
end

function HkHistoryDatapadMenuComponent:entryCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	local history = _G["somHkHistoryScreenPlay"]

	if (history == nil or history.entries == nil) then
		return
	end

	-- SuiListBox hands the row back 0-based; bartenders.lua:359 is the same +1.
	local row = tonumber(args)

	if (row == nil) then
		CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:hk_history_datapad_select")
		return
	end

	local entry = history.entries[row + 1]

	if (entry == nil) then
		CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:hk_history_datapad_select")
		return
	end

	history:playEntry(pPlayer, entry.number, nil)
end

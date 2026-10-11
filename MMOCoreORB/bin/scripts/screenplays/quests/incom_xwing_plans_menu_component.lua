IncomXwingPlansMenuComponent = {}

function IncomXwingPlansMenuComponent:fillObjectMenuResponse(pObject, pMenu, pPlayer)
	if (IncomXwingPlans:canUseTerminal(pPlayer, pObject)) then
		LuaObjectMenuResponse(pMenu):addRadialMenuItem(20, 3, "Access flight test archive")
	end
end

function IncomXwingPlansMenuComponent:handleObjectMenuSelect(pObject, pPlayer, selectedID)
	if (selectedID == 20) then
		IncomXwingPlans:openTerminal(pPlayer, pObject)
	end
	return 0
end

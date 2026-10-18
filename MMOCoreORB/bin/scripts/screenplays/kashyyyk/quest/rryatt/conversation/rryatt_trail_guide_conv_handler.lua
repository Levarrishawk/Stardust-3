-- Female guides descend and raise mastery signals; male guides ascend (DSRC conversations).
rryatt_trail_guide_conv_handler = conv_handler:new {}

function rryatt_trail_guide_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local npc = KashyyykRryattNpcs:getNpc(pNpc)
	if (npc == nil) then
		print("Rryatt trail guide: conversation rejected for unregistered NPC "
			.. tostring(pNpc ~= nil and SceneObject(pNpc):getObjectID() or 0))
		return nil
	elseif (not KashyyykRryattNpcs:canUseNpc(pPlayer, pNpc)) then
		if (pPlayer ~= nil) then
			print("Rryatt trail guide: conversation eligibility rejected; npc=" .. SceneObject(pNpc):getObjectID()
				.. " distance=" .. SceneObject(pPlayer):getDistanceTo3d(pNpc)
				.. " playerZone=" .. SceneObject(pPlayer):getZoneName()
				.. " playerParent=" .. SceneObject(pPlayer):getParentID())
		end
		return nil
	end
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	return convoTemplate:getScreen(npc.up and "s_86" or "s_61")
end

function rryatt_trail_guide_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	if (screenID == "s_65" or screenID == "s_90") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, false)
	elseif (screenID == "s_69" or screenID == "s_94") then
		KashyyykRryattNpcs:travel(pPlayer, pNpc, true)
	end
	return pClonedScreen
end

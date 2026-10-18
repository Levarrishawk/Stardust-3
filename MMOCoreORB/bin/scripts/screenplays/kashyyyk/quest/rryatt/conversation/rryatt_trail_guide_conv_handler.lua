-- Female guides descend and raise mastery signals; male guides ascend (DSRC conversations).
rryatt_trail_guide_conv_handler = conv_handler:new {}

local function worldPosition(pObject)
	if (pObject == nil) then return "missing" end
	return "(x=" .. SceneObject(pObject):getWorldPositionX()
		.. ", height=" .. SceneObject(pObject):getWorldPositionZ()
		.. ", y=" .. SceneObject(pObject):getWorldPositionY() .. ")"
end

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
				.. " playerParent=" .. SceneObject(pPlayer):getParentID()
				.. " player=" .. worldPosition(pPlayer) .. " guide=" .. worldPosition(pNpc)
				.. " expectedGuide=(x=" .. npc[2] .. ", height=" .. npc[3] .. ", y=" .. npc[4] .. ")")
			if (npc[1] == "ep3_rryatt_trail_guide_f_01") then
				local pTree = getSceneObject(100000109)
				local pHut = getSceneObject(100000111)
				print("Rryatt trail guide: server snapshot tree100000109=" .. worldPosition(pTree)
					.. " treeTemplate=" .. tostring(pTree ~= nil and SceneObject(pTree):getTemplateObjectPath() or "missing")
					.. " hut100000111=" .. worldPosition(pHut))
			end
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

-- ep3_myyydril_weaponsmith
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_weaponsmith_conv_handler = conv_handler:new {}

-- Java questCompleteNoSchem: completed treesh_craft_1 and not hasSchematic(appearance).
-- PlayerObject.idl:2070 hasSchematic(DraftSchematic); LuaPlayerObject.cpp:311-315
-- takes the iff path, hashes it, and looks it up in SchematicMap.
function ep3_myyydril_weaponsmith_conv_handler:hasAppearanceSchematic(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):hasSchematic("object/draft_schematic/weapon/appearance/weapon_appearance_knife_naktra_crystal.iff")
end

function ep3_myyydril_weaponsmith_conv_handler:questCompleteNoSchem(pPlayer)
	return (myyydrilTreeshCraft1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) == 0) and not self:hasAppearanceSchematic(pPlayer)
end

function ep3_myyydril_weaponsmith_conv_handler:getNextConversationScreen(pConvTemplate, pPlayer, selectedOption, pNpc)
	local convsession = CreatureObject(pPlayer):getConversationSession()
	local lastConvScreen = nil

	if (convsession ~= nil) then
		local session = LuaConversationSession(convsession)
		lastConvScreen = session:getLastConversationScreen()
	end

	local conv = LuaConversationTemplate(pConvTemplate)
	local nextConvScreen

	if (lastConvScreen ~= nil) then
		local luaLastConvScreen = LuaConversationScreen(lastConvScreen)
		local optionLink = luaLastConvScreen:getOptionLink(selectedOption)

		if (optionLink == "s_766") then
			if (self:questCompleteNoSchem(pPlayer)) then
				optionLink = "s_766"
			else
				optionLink = "s_766_has_schem"
			end
		end

		nextConvScreen = conv:getScreen(optionLink)

		if nextConvScreen == nil then
			nextConvScreen = self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end
	else
		nextConvScreen = self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	end

	return nextConvScreen
end

function ep3_myyydril_weaponsmith_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilTreeshCraft1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_758")
	elseif (((myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) >= 2) and not (myyydrilTreeshCraft1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) == 0))) then
		return convoTemplate:getScreen("s_778")
	elseif ((myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer) >= 2)) then
		return convoTemplate:getScreen("s_798")
	elseif (CreatureObject(pPlayer):hasSkill("class_munitions_phase1_novice")) then
		return convoTemplate:getScreen("s_818")
	end

	return convoTemplate:getScreen("s_886")
end

function ep3_myyydril_weaponsmith_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_36") then
		MyyydrilSignals:send(pPlayer, "giveSwords")
		do
			local pGhost = CreatureObject(pPlayer):getPlayerObject()
			if (pGhost ~= nil) then
				PlayerObject(pGhost):addRewardedSchematic("object/draft_schematic/weapon/appearance/weapon_appearance_knife_naktra_crystal.iff", 2, -1, true)
			end
		end
		do
			local pGhost = CreatureObject(pPlayer):getPlayerObject()
			if (pGhost ~= nil) then
				PlayerObject(pGhost):removeRewardedSchematic("object/draft_schematic/weapon/knife_naktra_crystal_false.iff", true)
			end
		end
	elseif (screenID == "s_794") then
		MyyydrilSignals:send(pPlayer, "giveSwords")
		do
			local pGhost = CreatureObject(pPlayer):getPlayerObject()
			if (pGhost ~= nil) then
				PlayerObject(pGhost):addRewardedSchematic("object/draft_schematic/weapon/appearance/weapon_appearance_knife_naktra_crystal.iff", 2, -1, true)
			end
		end
		do
			local pGhost = CreatureObject(pPlayer):getPlayerObject()
			if (pGhost ~= nil) then
				PlayerObject(pGhost):removeRewardedSchematic("object/draft_schematic/weapon/knife_naktra_crystal_false.iff", true)
			end
		end
	elseif (screenID == "s_866") then
		myyydrilTreeshCraft1ScreenPlay:grantQuest(pPlayer)
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/myyydril:knife")
	end

	return pClonedScreen
end


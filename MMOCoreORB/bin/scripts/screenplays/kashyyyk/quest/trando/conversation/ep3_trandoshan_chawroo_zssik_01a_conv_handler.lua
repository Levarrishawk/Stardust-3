-- ep3_trandoshan_chawroo_zssik_01a -- ep3_trandoshan_chawroo_zssik_01a
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_trandoshan_chawroo_zssik_01a_conv_handler = conv_handler:new {}

ep3_trandoshan_chawroo_zssik_01a_conv_handler.screenAnimations = {
	s_751 = "nod_head_once",
	s_757 = "bow4",
	s_761 = "embarrassed",
	s_765 = "slump_head",
	s_769 = "embarrassed",
	s_773 = "sigh_deeply",
	s_777 = "point_accusingly",
	s_781 = "shake_head_no",
	s_789 = "nod_head_multiple",
	s_785 = "weeping",
	s_747 = "sigh_deeply",
	s_753 = "embarrassed",
	s_791 = "standing_raise_fist",
	s_793 = "point_accusingly",
}

function ep3_trandoshan_chawroo_zssik_01a_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01")) then
		return convoTemplate:getScreen("s_70")
	elseif (trandoBoshazZssik02ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_753")
	elseif (trandoBoshazZssik02ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_791")
	end
	return convoTemplate:getScreen("s_793")
end

function ep3_trandoshan_chawroo_zssik_01a_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_789") then
		trandoBoshazZssik02ScreenPlay:signalChawrooLifeDebt(pPlayer)
	elseif (screenID == "s_785") then
		trandoBoshazZssik02ScreenPlay:signalChawrooLifeDebt(pPlayer)
	end

	return pClonedScreen
end


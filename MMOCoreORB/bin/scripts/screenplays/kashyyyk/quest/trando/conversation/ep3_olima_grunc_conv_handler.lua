-- ep3_olima_grunc -- ep3_trandoshan_olima_grunc
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_olima_grunc_conv_handler = conv_handler:new {}

ep3_olima_grunc_conv_handler.screenAnimations = {
	s_1197 = "goodbye",
	s_1201 = "goodbye",
	s_1207 = "manipulate_medium",
	s_1213 = "slump_head",
	s_1219 = "laugh_cackle",
	s_1259 = "goodbye",
	s_1223 = "gesticulate_wildly",
	s_1227 = "gesticulate_wildly",
	s_1255 = "goodbye",
	s_1231 = "smack_self",
	s_1235 = "wave_finger_warning",
	s_1239 = "nod_head_once",
	s_1251 = "goodbye",
	s_1243 = "laugh",
	s_1247 = "rub_chin_thoughtful",
	s_1193 = "bow5",
	s_1203 = "rub_belly",
	s_1209 = "greet",
	s_1215 = "greet",
}

function ep3_olima_grunc_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoOlimaGruncScreenPlay:getStage(pPlayer) == 0 and trandoOlimaGruncScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_1193")
	elseif (trandoOlimaGruncScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1203")
	elseif ((trandoOlimaGruncScreenPlay:getStage(pPlayer) > 0 and not trandoOlimaGruncScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1209")
	end
	return convoTemplate:getScreen("s_1215")
end

function ep3_olima_grunc_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1197") then
		trandoOlimaGruncScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1207") then
		trandoOlimaGruncScreenPlay:signalRewardOlima(pPlayer)
	elseif (screenID == "s_1247") then
		trandoOlimaGruncScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end


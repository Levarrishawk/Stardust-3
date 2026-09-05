-- ep3_orooroo_betrayer -- ep3_trandoshan_orooroo_zssik_04
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_orooroo_betrayer_conv_handler = conv_handler:new {}

ep3_orooroo_betrayer_conv_handler.screenAnimations = {
	s_159 = "whisper",
	s_164 = "whisper",
	s_172 = "whisper",
	s_196 = "whisper",
	s_176 = "whisper",
	s_180 = "whisper",
	s_184 = "whisper",
	s_188 = "whisper",
	s_192 = "whisper",
	s_153 = "wave_on_dismissing",
	s_155 = "whisper",
	s_166 = "smell_air",
	s_168 = "whisper",
	s_202 = "wave_on_dismissing",
}

function ep3_orooroo_betrayer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01")) then
		return convoTemplate:getScreen("s_97")
	elseif ((trandoOroorooZssik08ScreenPlay:getStage(pPlayer) == 0 and trandoOroorooZssik08ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_153")
	elseif (trandoOroorooZssik08ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_155")
	elseif ((trandoOroorooZssik08ScreenPlay:getStage(pPlayer) > 0 and not trandoOroorooZssik08ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_166")
	elseif ((trandoMosoliumTransferScreenPlay:getStage(pPlayer) > 0 and not trandoMosoliumTransferScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_168")
	elseif ((trandoMosoliumZssik05ScreenPlay:getStage(pPlayer) == 0 and trandoMosoliumZssik05ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_200")
	end
	return convoTemplate:getScreen("s_202")
end

function ep3_orooroo_betrayer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_164") then
		trandoOroorooTransferScreenPlay:grantQuest(pPlayer)
		trandoOroorooZssik08ScreenPlay:signalRewardOrooroo(pPlayer)
	elseif (screenID == "s_188") then
		trandoOroorooZssik08ScreenPlay:grantQuest(pPlayer)
		trandoMosoliumTransferScreenPlay:signalReadyForOrooroo(pPlayer)
	end

	return pClonedScreen
end


-- ep3_rodian_guard_male. Java giveQuest* is never called.
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires no grant.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.
-- defined by the arc that owns ep3_wookiee_benefactor_2

ep3_rodian_guard_male_conv_handler = conv_handler:new {}

ep3_rodian_guard_male_conv_handler.screenAnimations = {
	s_eb018d3d = "shake_head_no",
	s_56dc37ee = "rub_chin_thoughtful",
	s_ad7f810c = "smack_self",
	s_ee40364b = "shake_head_disgust",
	s_aca8a41d = "bow",
}

function ep3_rodian_guard_male_conv_handler:finished(pPlayer, play)
	return play:getRuns(pPlayer) > 0
end

function ep3_rodian_guard_male_conv_handler:hasFinishedWookieeBenefactor(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	if (type(wookieeBenefactor2ScreenPlay) == "table" and wookieeBenefactor2ScreenPlay.getRuns ~= nil) then
		return wookieeBenefactor2ScreenPlay:getRuns(pPlayer) > 0
	end

	return (tonumber(readScreenPlayData(pPlayer, "wookieeBenefactor2ScreenPlay", "runs")) or 0) > 0
end

function ep3_rodian_guard_male_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not self:finished(pPlayer, rodianHunter1ScreenPlay)) then
		return convoTemplate:getScreen("s_eb018d3d")
	elseif (not self:hasFinishedWookieeBenefactor(pPlayer)) then
		return convoTemplate:getScreen("s_56dc37ee")
	elseif (not self:finished(pPlayer, rodianHunter2ScreenPlay)) then
		return convoTemplate:getScreen("s_ad7f810c")
	elseif (not self:finished(pPlayer, rodianHunter3ScreenPlay)) then
		return convoTemplate:getScreen("s_ee40364b")
	end

	return convoTemplate:getScreen("s_aca8a41d")
end

function ep3_rodian_guard_male_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	return pClonedScreen
end

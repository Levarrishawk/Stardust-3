-- ep3_rodian_hunter_1 / _2 / _3
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / clear.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.
-- defined by the arc that owns ep3_wookiee_benefactor_2
-- OPEN: giveQuestFour / giveQuestFive have no .qst; those screens are no-ops.

ep3_rodian_hunter_conv_handler = conv_handler:new {}

ep3_rodian_hunter_conv_handler.screenAnimations = {
	s_31d7e474 = "greet",
	s_225d3518 = "shrug_hands",
	s_b26194cb = "greet",
	s_cf298387 = "implore",
	s_d2849e62 = "rub_chin_thoughtful",
	s_b21a191 = "shake_head_disgust",
	s_d0306922 = "greet",
	s_fa986495 = "shake_head_no",
	s_1a09ac5e = "nod",
	s_a80d9308 = "goodbye",
	s_50c166a3 = "point_forward",
	s_d28436cd = "goodbye",
	s_4e4fe804 = "apologize",
	s_34824b35 = "goodbye",
	s_e3bd19bc = "explain",
	s_fe77e31e = "slump_head",
	s_81fdc59e = "goodbye",
	s_de3892ae = "goodbye",
	s_fa2e7213 = "manipulate_medium",
	s_e9a0750f = "explain",
	s_88467f34 = "pound_fist_palm",
	s_fe631380 = "belly_laugh",
	s_f53e4c0c = "goodbye",
	s_7d09a75e = "goodbye",
}

function ep3_rodian_hunter_conv_handler:finished(pPlayer, play)
	return play:getRuns(pPlayer) > 0
end

function ep3_rodian_hunter_conv_handler:onQuest(pPlayer, play)
	return play:getStage(pPlayer) > 0
end

function ep3_rodian_hunter_conv_handler:hasFinishedWookieeBenefactor(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	if (type(wookieeBenefactor2ScreenPlay) == "table" and wookieeBenefactor2ScreenPlay.getRuns ~= nil) then
		return wookieeBenefactor2ScreenPlay:getRuns(pPlayer) > 0
	end

	return (tonumber(readScreenPlayData(pPlayer, "wookieeBenefactor2ScreenPlay", "runs")) or 0) > 0
end

function ep3_rodian_hunter_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not self:finished(pPlayer, rodianHunter1ScreenPlay)) then
		return convoTemplate:getScreen("s_31d7e474")
	elseif (self:onQuest(pPlayer, rodianHunter1ScreenPlay)) then
		return convoTemplate:getScreen("s_225d3518")
	elseif (not self:hasFinishedWookieeBenefactor(pPlayer)) then
		return convoTemplate:getScreen("s_b26194cb")
	elseif (not self:finished(pPlayer, rodianHunter2ScreenPlay)) then
		return convoTemplate:getScreen("s_cf298387")
	elseif (self:onQuest(pPlayer, rodianHunter2ScreenPlay)) then
		return convoTemplate:getScreen("s_d2849e62")
	elseif (not self:finished(pPlayer, rodianHunter3ScreenPlay)) then
		return convoTemplate:getScreen("s_b21a191")
	end

	return convoTemplate:getScreen("s_d0306922")
end

function ep3_rodian_hunter_conv_handler:resetHunter(pPlayer)
	rodianHunter1ScreenPlay:clearQuest(pPlayer)
	rodianHunter2ScreenPlay:clearQuest(pPlayer)
	rodianHunter3ScreenPlay:clearQuest(pPlayer)
	deleteScreenPlayData(pPlayer, rodianHunter1ScreenPlay.screenplayName, "runs")
	deleteScreenPlayData(pPlayer, rodianHunter2ScreenPlay.screenplayName, "runs")
	deleteScreenPlayData(pPlayer, rodianHunter3ScreenPlay.screenplayName, "runs")
end

function ep3_rodian_hunter_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_a80d9308") then
		rodianHunter1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_81fdc59e") then
		rodianHunter2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_fe631380") then
		rodianHunter3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_fa2e7213") then
		self:resetHunter(pPlayer)
	elseif (screenID == "s_f53e4c0c" or screenID == "s_7d09a75e") then
		-- OPEN: ep3_rodian_hunter_4 / _5 have no .qst in this arc.
	end

	return pClonedScreen
end

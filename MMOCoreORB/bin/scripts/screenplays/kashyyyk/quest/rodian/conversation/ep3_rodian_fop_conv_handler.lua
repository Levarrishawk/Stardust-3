-- ep3_rodian_fop_1 / _2 / _3
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / clear.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.
-- Live OnStart: defaultCondition is always true, so the DEFAULT CONVO hub is the
-- only reachable root. Later roots in the java are dead; they stay in the template.
-- Hub replies s_ce7e4cd9 / s_4b16bcf are omitted once those quests are complete
-- (one static screen per combination; never rely on grantQuest rejecting).

ep3_rodian_fop_conv_handler = conv_handler:new {}

ep3_rodian_fop_conv_handler.screenAnimations = {
	s_c8fc6f31 = "greet",
	s_c8fc6f31_q1 = "greet",
	s_c8fc6f31_q2 = "greet",
	s_c8fc6f31_both = "greet",
	s_d628eb2d = "greet",
	s_f3acc17c = "bow",
	s_ef75f1bd = "bow",
	s_1af1928c = "explain",
	s_9d3e4637 = "shrug_hands",
	s_21fea0de = "shrug_shoulders",
	s_1f2267dd = "manipulate_medium",
	s_b4a2635a = "gesticulate_wildly",
	s_98f012fb = "goodbye",
	s_a5f02cb6 = "wave_on_dismissing",
	s_5788ca33 = "pound_fist_palm",
	s_3fa4f0ff = "wave_on_dismissing",
	s_add1e6bf = "goodbye",
	s_b0e55a4a = "point_forward",
	s_258b522b = "goodbye",
	s_2fed2a17 = "goodbye",
	s_2551a79 = "explain",
	s_6488c3cb = "goodbye",
	s_da6e65ae = "goodbye",
}

function ep3_rodian_fop_conv_handler:finished(pPlayer, play)
	return play:getRuns(pPlayer) > 0
end

function ep3_rodian_fop_conv_handler:hubScreenId(pPlayer)
	local q1 = self:finished(pPlayer, rodianFop1ScreenPlay)
	local q2 = self:finished(pPlayer, rodianFop2ScreenPlay)

	if (q1 and q2) then
		return "s_c8fc6f31_both"
	elseif (q1) then
		return "s_c8fc6f31_q1"
	elseif (q2) then
		return "s_c8fc6f31_q2"
	end

	return "s_c8fc6f31"
end

function ep3_rodian_fop_conv_handler:questPickScreenId(pPlayer)
	local q1 = self:finished(pPlayer, rodianFop1ScreenPlay)
	local q2 = self:finished(pPlayer, rodianFop2ScreenPlay)

	if (q1 and q2) then
		return "s_59a3429f_both"
	elseif (q1) then
		return "s_59a3429f_q1"
	elseif (q2) then
		return "s_59a3429f_q2"
	end

	return "s_59a3429f"
end

function ep3_rodian_fop_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	return convoTemplate:getScreen(self:hubScreenId(pPlayer))
end

function ep3_rodian_fop_conv_handler:resetFop(pPlayer)
	rodianFop1ScreenPlay:clearQuest(pPlayer)
	rodianFop2ScreenPlay:clearQuest(pPlayer)
	rodianFop3ScreenPlay:clearQuest(pPlayer)
	deleteScreenPlayData(pPlayer, rodianFop1ScreenPlay.screenplayName, "runs")
	deleteScreenPlayData(pPlayer, rodianFop2ScreenPlay.screenplayName, "runs")
	deleteScreenPlayData(pPlayer, rodianFop3ScreenPlay.screenplayName, "runs")
end

function ep3_rodian_fop_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (screenID == "s_59a3429f") then
		pConvScreen = convoTemplate:getScreen(self:questPickScreenId(pPlayer))
		screen = LuaConversationScreen(pConvScreen)
		screenID = screen:getScreenID()
	end

	local pClonedScreen = screen:cloneScreen()

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_98f012fb" or screenID == "s_2fed2a17") then
		rodianFop1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_add1e6bf" or screenID == "s_6488c3cb") then
		rodianFop2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_bdf6c22c") then
		rodianFop3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1f2267dd" or screenID == "s_da6e65ae") then
		self:resetFop(pPlayer)
	end

	return pClonedScreen
end

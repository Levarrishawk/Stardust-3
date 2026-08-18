--[[
	The crazed Mustafarian hermit -- conversation handler for
	som_kenobi_main_quest_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_crazed_hermit.lua,
	which carries the note on how it was reconstructed from the shipped string
	table and why both meetings live in one tree.

	WHAT THE .qst ASKS FOR, in order:
	  task 10  signal 'talkedHermit1'  -- the first meeting ends
	  task 14  Encounter som_kenobi_blistmok, Count 4, 5-50   ('attacked')
	  task 15  signal 'talkedHermit2'  -- the shard changes hands, SPARED
	  task 21  Destroy Multiple and Loot the hermit           -- KILLED
	Both endings are real endings; task 17 grants som_kenobi_main_quest_spared
	and task 22 grants som_kenobi_main_quest_killed. This handler never picks
	one -- the player does, by which screen they walk into.

	THE PROVOCATION IS THE COMBAT TRIGGER. Nine screens end with the voice in
	the crystal telling him to kill: s_54, s_76, s_81, s_85, s_90, s_91, s_96,
	s_102 and s_106. On any of them the screenplay flips him hostile and sets
	the player as his defender. He is spawned ATTACKABLE and killable from the
	start -- see som_crazed_mustafarian_hermit.lua -- so this only aims him; it
	does not change what he is.

	HE STAYS PROVOKED. Once he has turned, there is nothing in the table for
	talking him back down and the .qst has no path back either, so the killed
	branch is committed at that point. That is not a design choice made here;
	SOE wrote no reconciliation line.
]]

crazed_hermit_conv_handler = conv_handler:new {}

crazed_hermit_conv_handler.screenPlayName = "kenobiSpineScreenPlay"

-- the two screens where the shard actually changes hands
crazed_hermit_conv_handler.handoverScreens = {
	handover_free = true,   -- s_82, he is talked free of the voice
	handover_trade = true,  -- s_97, the player promises to hunt the voice down
}

-- every screen that ends with "kill him"
crazed_hermit_conv_handler.provokeScreens = {
	kill_calm = true,       -- s_54
	kill_fade = true,       -- s_76
	kill_promise = true,    -- s_81
	kill_help = true,       -- s_85
	kill_stop = true,       -- s_90
	kill_forcestop = true,  -- s_91
	kill_find = true,       -- s_96
	kill_demand = true,     -- s_102
	kill_force = true,      -- s_106
}

-- the three screens that close the first meeting
crazed_hermit_conv_handler.firstMeetingEnds = {
	madness = true,  -- s_50
	nopain = true,   -- s_66
	tired = true,    -- s_71
}

function crazed_hermit_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = kenobiSpineScreenPlay:getHermitStage(pPlayer)

	if (stage >= kenobiSpineScreenPlay.HERMIT_GAVE) then
		-- s_110, "Please, leave me alone. I need to rest."
		return convoTemplate:getScreen("rest")
	elseif (stage == kenobiSpineScreenPlay.HERMIT_WAVE_DONE) then
		-- s_67, "No more fun left. They are quiet now. Finally, quiet..."
		return convoTemplate:getScreen("quiet")
	elseif (stage == kenobiSpineScreenPlay.HERMIT_MET) then
		-- talked to once, the blistmoks are still coming. s_108.
		return convoTemplate:getScreen("ambient")
	end

	return convoTemplate:getScreen("greeting")
end

function crazed_hermit_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (self.handoverScreens[screenID]) then
		kenobiSpineScreenPlay:hermitHandsOverShard(pPlayer, pNpc)
	elseif (self.provokeScreens[screenID]) then
		kenobiSpineScreenPlay:hermitTurnsHostile(pPlayer, pNpc)
	elseif (self.firstMeetingEnds[screenID]) then
		kenobiSpineScreenPlay:hermitFirstMeetingDone(pPlayer, pNpc)
	end

	return pClonedScreen
end

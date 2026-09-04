--[[
	Captain Diskret Stahn -- conversation handler for the grounded pilot in the Mensix cantina.

	Same shape as pei_yi_conv_handler: the tree lives in
	mobile/conversations/mustafar/som_diskret_stahn.lua, which carries THE TUNE (why the grant
	live makes is not made here) and THE GATE (what live actually tests). One persistent flag
	records that he has passed the tune on. This file only routes.

	THE GATE

	Live guards the tune twice on the same condition:

	    condition_isEntertainer -> utils.isProfession(player, utils.ENTERTAINER)

	branch 10 hides the s_41 option "I'm a bit of a musician" from anyone who fails it, and
	branch 12 checks it again before granting. The second check is unreachable in live, since
	nobody who fails the first ever reaches it -- but s_50 "maybe you're needing a little more
	practice" is the arm it guards, so both are kept here.

	No level test, unlike pei_yi_conv_handler's condition of the same name; live's two copies
	differ and are rendered as they are written. Core3 has no NGE profession enum, and
	social_entertainer_novice is the profession root the rest of this codebase tests (see
	screenplays/themepark/conversations/theater_manager_conv_handler.lua:203). This file used to
	gate on social_musician_novice, which is the skill live's UNUSED condition_isMusician names.

	Live tests hasCommand("startMusic+calypso") for the return greeting; see THE TUNE for why
	there is no command to test. readScreenPlayData returns "" for a key never written, hence
	comparing to "1" rather than testing for nil.
--]]

diskret_stahn_conv_handler = conv_handler:new {}

diskret_stahn_conv_handler.screenPlayName = "mensix_mining_facility_main"
diskret_stahn_conv_handler.taughtKey = "diskret_stahn_taught"
diskret_stahn_conv_handler.requiredSkill = "social_entertainer_novice"

function diskret_stahn_conv_handler:hasBeenTaught(pPlayer)
	return readScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey) == "1"
end

-- Live's condition_isEntertainer, in Core3 terms; see THE GATE.
function diskret_stahn_conv_handler:isEntertainer(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill(self.requiredSkill)
end

function diskret_stahn_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasBeenTaught(pPlayer)) then
		return convoTemplate:getScreen("greeting_taught")
	end

	return convoTemplate:getScreen("greeting")
end

function diskret_stahn_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "how_long") then
		-- Live branch 10 gates s_41 on isEntertainer, so a non-entertainer is never offered
		-- "I'm a bit of a musician" at all and only sees the way out. Both options stay declared
		-- on the screen because that is what live's screen carries; dropping one is a per-player
		-- edit, so it is done here. LuaConversationScreen binds removeAllOptions and not
		-- removeOption (LuaConversationScreen.cpp:21), so the survivor is re-added rather than
		-- the loser removed.
		if (not self:isEntertainer(pPlayer)) then
			clonedConversation:removeAllOptions()
			clonedConversation:addOption("@conversation/som_diskret_stahn:s_56", "bye_horrible")
		end

	elseif (screenID == "ask_tune") then
		if (self:isEntertainer(pPlayer)) then
			clonedConversation:addOption("@conversation/som_diskret_stahn:s_45", "taught")
		else
			clonedConversation:addOption("@conversation/som_diskret_stahn:s_45", "too_unskilled")
		end

		clonedConversation:addOption("@conversation/som_diskret_stahn:s_52", "bye_nevermind")

	elseif (screenID == "taught") then
		writeScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey, "1")
	end

	return pClonedScreen
end

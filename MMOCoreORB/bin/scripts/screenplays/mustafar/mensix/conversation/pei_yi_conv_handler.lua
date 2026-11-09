--[[
	Pei Yi -- conversation handler for the stranded dancer in the Mensix cantina.

	The tree is in mobile/conversations/mustafar/som_pei_yi.lua, which carries THE DANCE (why
	the grant live makes is not made here) and THE GATE (what live actually tests). This file
	only routes.

	Stardust uses the entertainer skill to qualify for the lesson.

	State is one flag, kept in persistent screenplay data under the screenplay that spawns her,
	so a character who has had the lesson still gets the return-visit greeting after a restart.
	Live tests hasCommand("startDance+peiyi") instead; see THE DANCE for why there is no command
	to test. readScreenPlayData returns "" for a key never written, hence comparing to "1"
	rather than testing for nil.
--]]

pei_yi_conv_handler = conv_handler:new {}

pei_yi_conv_handler.screenPlayName = "mensix_mining_facility_main"
pei_yi_conv_handler.taughtKey = "pei_yi_taught"
pei_yi_conv_handler.requiredSkill = "social_entertainer_novice"

function pei_yi_conv_handler:hasBeenTaught(pPlayer)
	return readScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey) == "1"
end

-- Use the entertainer profession root.
function pei_yi_conv_handler:isEntertainer(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill(self.requiredSkill)
end

function pei_yi_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasBeenTaught(pPlayer)) then
		return convoTemplate:getScreen("greeting_taught")
	end

	return convoTemplate:getScreen("greeting")
end

function pei_yi_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "miss_show") then
		-- Live branch 13 gates s_56 on isEntertainer, so a non-entertainer is never offered
		-- "I'm a dancer myself" at all and only sees the way out. Both options stay declared on
		-- the screen because that is what live's screen carries; dropping one is a per-player
		-- edit, so it is done here. LuaConversationScreen binds removeAllOptions and not
		-- removeOption (LuaConversationScreen.cpp:21), so the survivor is re-added rather than
		-- the loser removed.
		if (not self:isEntertainer(pPlayer)) then
			clonedConversation:removeAllOptions()
			clonedConversation:addOption("@conversation/som_pei_yi:s_70", "bye_too_bad")
		end

	elseif (screenID == "offer_lesson") then
		-- Live branch 15 checks isEntertainer again before granting. Nobody who failed the
		-- branch 13 gate can reach this screen, so the else arm is where s_64 lives rather
		-- than a path a player takes.
		if (self:isEntertainer(pPlayer)) then
			clonedConversation:addOption("@conversation/som_pei_yi:s_60", "taught")
		else
			clonedConversation:addOption("@conversation/som_pei_yi:s_60", "too_unskilled")
		end

		clonedConversation:addOption("@conversation/som_pei_yi:s_66", "bye_another")

	elseif (screenID == "taught") then
		writeScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey, "1")
	end

	return pClonedScreen
end
